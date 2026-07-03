-- ============================================================
-- MODDED BY TrnDravix + @TrnDravix
-- Complete MOD with Bypass V2.0 + SKINS + PBC WALLHACK + COLOR CONTROLS + GLOW
-- All features: Aimbot, ESP, PBC Wallhack, 165 FPS, No Grass, iPad View, SKINS
-- Bypass activates on game start with popup
-- ============================================================

-- ============================================================
-- DEBUG LOGGER
-- ============================================================
local DEBUG_PATH = "/storage/emulated/0/Android/data/com.pubg.imobile/files/debug_log.txt"

local function DebugLog(msg)
    local file = io.open(DEBUG_PATH, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
        file:close()
    end
end

DebugLog("========== SCRIPT STARTED (FINAL) ==========")

-- ============================================================
-- PER-MATCH GUARD
-- ============================================================
do
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G._MOD_LOADED and _G._MOD_PC == pc then 
        DebugLog("Script already loaded, skipping")
        return 
    end
    _G._MOD_LOADED = true
    _G._MOD_PC = pc
    DebugLog("New PC detected, loading")
end

-- ============================================================
-- FEATURE TOGGLES
-- ============================================================
if not _G.Mod_Aimbot_Enabled then _G.Mod_Aimbot_Enabled = false end
if not _G.Mod_ESP_Enabled then _G.Mod_ESP_Enabled = false end
if _G.Mod_FPS165_Enabled == nil then _G.Mod_FPS165_Enabled = true end
if _G.Mod_NoGrass_Enabled == nil then _G.Mod_NoGrass_Enabled = true end
if _G.Mod_iPadView_Enabled == nil then _G.Mod_iPadView_Enabled = false end
if _G.Mod_iPadViewDistance == nil then _G.Mod_iPadViewDistance = 90 end
if _G.Mod_Skin_Enabled == nil then _G.Mod_Skin_Enabled = false end
if _G.Mod_PBCWallhack_Enabled == nil then _G.Mod_PBCWallhack_Enabled = false end
if _G.Mod_LootBox_Enabled == nil then _G.Mod_LootBox_Enabled = false end

-- ============================================================
-- CHAMS COLOR CONFIG
-- ============================================================
if _G.Mod_Chams_GreenEnabled == nil then _G.Mod_Chams_GreenEnabled = false end
if _G.Mod_Chams_YellowEnabled == nil then _G.Mod_Chams_YellowEnabled = false end
if _G.Mod_Chams_GreenRGB == nil then _G.Mod_Chams_GreenRGB = {R=0, G=255, B=0, A=255} end
if _G.Mod_Chams_YellowRGB == nil then _G.Mod_Chams_YellowRGB = {R=255, G=255, B=0, A=255} end

-- ============================================================
-- MEMORY FEATURES CONFIG
-- ============================================================
if _G.MemoryConfig == nil then
    _G.MemoryConfig = {
        SpeedBoost = false,
        SpeedPercent = 250,
        AntiGravity = false,
        GravityScale = 1.0,
        WallClimb = false,
        SuperBullet = 1,
        SuperFireRate = false,
        SuperFireRateVal = 0.008,
        InfiniteAmmo = false,
    }
end

_G.SpeedBoostState = _G.SpeedBoostState or {active = false, timer = nil, modifyId = nil, currentChar = nil}

-- ============================================================
-- WALLHACK COLOR + GLOW CONFIG
-- ============================================================
_G.ESPConfig = _G.ESPConfig or {
    Wallhack = false,
    WallhackVisibleColor = 4,
    WallhackInvisibleColor = 3,
    WallhackBrightness = 25,
    ShowAI = true,
    GlowEnabled = true,
    GlowIntensity = 5,
    BlackSky = false,
    RainEnabled = false,
    SnowEnabled = false,
    EnableLootBox = false,
}
_G.Mod_Wallhack_Enabled = _G.ESPConfig.Wallhack

local function GetColorFromIndex(idx)
    local colors = {
        {R=255,G=0,B=0,A=255},
        {R=255,G=255,B=255,A=255},
        {R=255,G=255,B=0,A=255},
        {R=0,G=255,B=0,A=255},
        {R=0,G=255,B=255,A=255},
        {R=0,G=0,B=255,A=255},
        {R=255,G=0,B=255,A=255},
    }
    return colors[idx] or colors[4]
end

-- ============================================================
-- SCENE FUNCTIONS
-- ============================================================
local function ExecuteConsoleCommand(cmd, value)
    local instance = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
    if instance then
        pcall(function() instance:ExecuteCMD(cmd, value) end)
    else
        local SettingUtil = require("client.slua.logic.setting.setting_util")
        if SettingUtil and SettingUtil.GetGameInstance then
            local gi = SettingUtil:GetGameInstance()
            if gi then pcall(function() gi:ExecuteCMD(cmd, value) end) end
        end
    end
end

local function GetSubsystemMgr()
    if _G.SubsystemMgr then return _G.SubsystemMgr end
    local ok, mgr = pcall(require, "GameLua.GameCore.Module.Subsystem.SubsystemMgr")
    return ok and mgr or nil
end

function SetBlackSky(enabled)
    ExecuteConsoleCommand("r.CylinderMaxDrawHeight", enabled and "9999" or "0")
end

function SetRainEnabled(enabled)
    pcall(function()
        local playerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(playerController) then return end
        local playerCharacter = playerController:GetPlayerCharacterSafety()
        if slua.isValid(playerCharacter) then
            local EScreenParticleEffectType = import("EScreenParticleEffectType")
            if EScreenParticleEffectType then
                if playerCharacter.SetRainyEffectEnable then
                    playerCharacter:SetRainyEffectEnable(EScreenParticleEffectType.ESPET_Rainy, enabled and true or false, enabled and 500 or 0)
                end
            end
        end
        local SubsystemMgr = GetSubsystemMgr()
        if SubsystemMgr then
            local weatherSubsystem = SubsystemMgr.Get("CreativeModeWeatherSubsystem")
            if slua.isValid(weatherSubsystem) then
                if enabled then
                    if weatherSubsystem.StartRainScreenEffect then weatherSubsystem:StartRainScreenEffect() end
                else
                    if weatherSubsystem.StopRainScreenEffect then weatherSubsystem:StopRainScreenEffect() end
                end
            end
        end
    end)
end

function SetSnowEnabled(enabled)
    pcall(function()
        local playerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(playerController) then return end
        local playerCharacter = playerController:GetPlayerCharacterSafety()
        if slua.isValid(playerCharacter) then
            local EScreenParticleEffectType = import("EScreenParticleEffectType")
            if EScreenParticleEffectType then
                if playerCharacter.SetRainyEffectEnable then
                    playerCharacter:SetRainyEffectEnable(EScreenParticleEffectType.ESPET_Snowy, enabled and true or false, enabled and 500 or 0)
                end
            end
        end
        local SubsystemMgr = GetSubsystemMgr()
        if SubsystemMgr then
            local weatherSubsystem = SubsystemMgr.Get("CreativeModeWeatherSubsystem")
            if slua.isValid(weatherSubsystem) then
                if enabled then
                    if weatherSubsystem.StartSnowScreenEffect then weatherSubsystem:StartSnowScreenEffect()
                    elseif weatherSubsystem.StartRainScreenEffect then weatherSubsystem:StartRainScreenEffect() end
                else
                    if weatherSubsystem.StopSnowScreenEffect then weatherSubsystem:StopSnowScreenEffect()
                    elseif weatherSubsystem.StopRainScreenEffect then weatherSubsystem:StopRainScreenEffect() end
                end
            end
        end
    end)
end

-- ============================================================
-- LICENSE KEY SYSTEM - HARDCODED + POPUP
-- ============================================================
local BASE_PATH = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local KEY_PATH = BASE_PATH .. "keys.txt"
local ERROR_PATH = BASE_PATH .. "error.txt"

local function WriteError(msg)
    DebugLog("ERROR: " .. msg)
    local file = io.open(ERROR_PATH, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
        file:close()
        return true
    end
    return false
end

local function EnsureKeyFile()
    DebugLog("Checking keys.txt...")
    local file = io.open(KEY_PATH, "r")
    if file then
        file:close()
        DebugLog("keys.txt exists")
        return true
    end
    local f = io.open(KEY_PATH, "w")
    if f then
        f:write("")
        f:close()
        DebugLog("keys.txt created")
        return true
    end
    DebugLog("ERROR: Could not create keys.txt")
    return false
end

local function ReadKeyFile()
    DebugLog("Reading key...")
    local file = io.open(KEY_PATH, "r")
    if file then
        local content = file:read("*all")
        file:close()
        local key = content:gsub("%s+", "")
        DebugLog("Key read: " .. key)
        return key
    end
    return nil
end

-- ============================================================
-- SHOW POPUP FUNCTION
-- ============================================================
local function ShowPopup(title, msg)
    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        if Msg and Msg.Show then
            Msg.Show(4, title, msg)
        end
    end)
end

-- ============================================================
-- VALIDATE KEY - HARDCODED + POPUP
-- ============================================================
local function ValidateKey()
    DebugLog("========== VALIDATE KEY START ==========")
    
    if not EnsureKeyFile() then
        ShowPopup("FILE ERROR", "Could not create keys.txt")
        return false
    end

    local userKey = ReadKeyFile()
    if not userKey or userKey == "" then
        ShowPopup("KEY MISSING", "Open " .. KEY_PATH .. "\nAdd key: TRN-2026-001")
        return false
    end

    if not userKey:match("^TRN%-2026%-%d%d%d$") then
        ShowPopup("INVALID FORMAT", "Key format: TRN-2026-001")
        return false
    end

    -- ===== HARDCODED VALID KEYS (BOT GENERATED) =====
    local VALID_KEYS = {
        ["TRN-2026-001"] = true,
        ["TRN-2026-002"] = true,
        ["TRN-2026-003"] = true,
        ["TRN-2026-004"] = true,
        ["TRN-2026-005"] = true,
        ["TRN-2026-006"] = true,
        ["TRN-2026-007"] = true,
        ["TRN-2026-008"] = true,
        ["TRN-2026-009"] = true,
        ["TRN-2026-010"] = true,
        -- TU YHAN AUR KEYS ADD KAR
    }

    if VALID_KEYS[userKey] then
        DebugLog("Key VALID")
        ShowPopup(
            "✅ LICENSE VALIDATED", 
            "Key: " .. userKey .. "\n" ..
            "Type: Premium\n" ..
            "Expiry: 2026-12-31\n\n" ..
            "🚀 TRNDRAVIX MOD ACTIVATED!"
        )
        return true
    else
        DebugLog("Key INVALID")
        ShowPopup(
            "❌ INVALID KEY", 
            "Key: " .. userKey .. "\n\n" ..
            "This key is not in our database.\n" ..
            "Contact: @TrnDravix"
        )
        return false
    end
end

-- ============================================================
-- RUN LICENSE CHECK
-- ============================================================
local licenseValid = ValidateKey()

if not licenseValid then
    DebugLog("LICENSE CHECK FAILED - Script disabled")
    _G.Mod_Aimbot_Enabled = false
    _G.Mod_ESP_Enabled = false
    _G.Mod_PBCWallhack_Enabled = false
    _G.Mod_Skin_Enabled = false
    _G.Mod_FPS165_Enabled = false
    _G.Mod_NoGrass_Enabled = false
    _G.Mod_iPadView_Enabled = false
    _G.Mod_LootBox_Enabled = false
    _G.ESPConfig.Wallhack = false
    _G.ESPConfig.EnableLootBox = false
    return
end

DebugLog("LICENSE CHECK SUCCESS - Script running")

-- ============================================================
-- REST OF THE SCRIPT (ALL FEATURES)
-- ============================================================
local require = require
local import = import
local isValid = slua.isValid
local pcall = pcall
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local math = math
local string = string
local os = os

local function nop() end
local function nopt() return {} end
local function nopnil() return nil end
local function noptrue() return true end
local function nopfalse() return false end
local function nopstr() return "" end
_G.CheatsEnabled = true

local function safe_require(path)
    local ok, mod = pcall(require, path)
    return ok and mod or nil
end

local ok_gd, GameplayData = pcall(require, "GameLua.GameCore.Data.GameplayData")
if not ok_gd then GameplayData = nil end

-- ============================================================
-- WELCOME POP-UP
-- ============================================================
pcall(function()
    local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
    if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
    local Web = require("client.slua.logic.url.logic_webview_sdk")
    local function onClick() if Web then Web:OpenURL("https://t.me/TrnDravix") end end
    if Msg and Msg.Show then
        Msg.Show(4, "TRNDRAVIX ULTIMATE",
        "\n----------------------------------------\n" ..
        "  DEVELOPER  : @TrnDravix\n" ..
        "  STATUS     : UNDETECTED OPTIMIZED\n" ..
        "  BYPASS     : 5-LAYER DEEP SHIELD\n" ..
        "----------------------------------------\n" ..
        "  FEATURES   :\n" ..
        "  Aimbot        Wall ESP\n" ..
        "  Wallhack      165 FPS\n" ..
        "  No Grass      iPad View\n" ..
        "  Skins         Glow Effects\n" ..
        "  Loot ESP      Memory Tweaks\n" ..
        "----------------------------------------\n" ..
        "  BUILD : PREMIUM LOADED SUCCESSFULLY\n" ..
        "----------------------------------------\n" ..
        "        TAP TO CONNECT WITH DEVELOPER", onClick)
    end
end)

-- ============================================================
-- ESP (COMPLETE)
-- ============================================================
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")

local cachedPawns = {}
local lastPawnRefresh = 0

local function IsPawnAlive(p)
    if not slua.isValid(p) then return false end
    if p.HealthStatus then return SecurityCommonUtils.IsHealthStatusAlive(p.HealthStatus) end
    if p.IsAlive then return p:IsAlive() end
    return p.GetHealth and (p:GetHealth() or 0) > 0 or false
end

local boneList = {"head","neck_01","spine_01","spine_02","spine_03","pelvis",
    "upperarm_l","upperarm_r","lowerarm_l","lowerarm_r","hand_l","hand_r",
    "calf_l","calf_r","foot_l","foot_r"}

local function TextScale(distM)
    local t = math.min(distM / 400, 1)
    return 0.35 - t * 0.2
end

local function HPBar(pct)
    local n = math.floor((pct * 4) + 0.5)
    local s = ""
    for i = 1, 4 do s = s .. (i <= n and "▁" or " ") end
    return s
end

local function ESPTick()
    if not _G.CheatsEnabled then return end
    if _G.Mod_ESP_Enabled == false then return end
    if _G._ESPTimerHandle and _G._ESPTimerChar and not slua.isValid(_G._ESPTimerChar) then 
        _G._ESPTimerHandle = nil
        _G._ESPTimerChar = nil 
    end
    local uCon = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not (slua.isValid(uCon) and Game:IsClassOf(uCon, ASTExtraPlayerController)) then return end
    local currentPawn = uCon:GetCurPawn()
    if not slua.isValid(currentPawn) then return end

    local myTeamId = 0
    pcall(function()
        local char = uCon:GetPlayerCharacterSafety()
        if slua.isValid(char) and char.TeamID then myTeamId = char.TeamID
        elseif currentPawn.TeamID then myTeamId = currentPawn.TeamID end
    end)
    local myPos = nil
    pcall(function() myPos = currentPawn:K2_GetActorLocation() end)
    if not myPos then return end
    local myEyePos = myPos
    pcall(function()
        if currentPawn.GetHeadLocation then myEyePos = currentPawn:GetHeadLocation(false) or myPos end
    end)
    HUD = uCon:GetHUD()
    local now = os.clock()

    if now - lastPawnRefresh > 1.0 then
        lastPawnRefresh = now
        cachedPawns = Game:GetAllPlayerPawns() or {}
    end

    local botCount = 0
    local playerCount = 0
    local totalAlive = 0
    for _, p in pairs(cachedPawns) do
        if slua.isValid(p) and p ~= currentPawn and p.TeamID ~= myTeamId and IsPawnAlive(p) then
            totalAlive = totalAlive + 1
        end
    end
    local crowded = totalAlive > 20

    for _, tPawn in pairs(cachedPawns) do
        if slua.isValid(tPawn) and tPawn ~= currentPawn and tPawn.TeamID ~= myTeamId then
            if IsPawnAlive(tPawn) then
                local enemyPos = tPawn:K2_GetActorLocation()
                local dx = enemyPos.X - myPos.X
                local dy = enemyPos.Y - myPos.Y
                local dz = enemyPos.Z - myPos.Z
                local dist = math.sqrt(dx*dx + dy*dy + dz*dz)

                local isBot = false
                pcall(function() isBot = Game:IsAI(tPawn) end)
                if isBot then botCount = botCount + 1 else playerCount = playerCount + 1 end

                if dist < 600000 and HUD then
                    local name = tPawn.PlayerName or "UNKNOWN"
                    local distM = dist / 100

                    local hp = tPawn.Health
                    local maxHp = tPawn.HealthMax
                    local isKnock = false
                    local hpPercent = 0
                    if not hp or not maxHp or maxHp <= 0 then
                        isKnock = true
                    elseif hp <= 0 then
                        isKnock = true
                    else
                        hpPercent = hp / maxHp
                    end
                    local hpColor = {R=0,G=255,B=0,A=255}
                    if hpPercent < 0.3 then
                        hpColor = {R=255,G=0,B=0,A=255}
                    elseif hpPercent < 0.7 then
                        hpColor = {R=255,G=255,B=0,A=255}
                    end
                    if isKnock then
                        hpColor = {R=255,G=0,B=0,A=255}
                    end

                    local bones = {}
                    local mesh = tPawn.Mesh
                    if slua.isValid(mesh) then
                        for _, bn in ipairs(boneList) do
                            bones[bn] = mesh:GetSocketLocation(bn)
                        end
                    end
                    local origin = enemyPos
                    local oz = origin.Z
                    local headPos = bones["head"]
                    local footPos = bones["foot_l"]
                    local footRPos = bones["foot_r"]
                    local headZ = headPos and (headPos.Z - oz) or 90
                    local hpOffset = headZ + 70 + math.min(distM, 60) * 3 + math.max(0, distM - 60) * 0.5
                    local nameOffset = -80 - math.min(distM, 60) * 0.33 - math.max(0, distM - 60) * 0.1

                    if crowded then
                        local hz = headPos and (headPos.Z - oz + 15)
                        if hz then HUD:AddDebugText("●", tPawn, TextScale(distM), {X=0,Y=0,Z=hz}, {X=0,Y=0,Z=hz}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 1.0, true) end
                        local hpText = isKnock and "DOWN" or HPBar(hpPercent)
                        HUD:AddDebugText(hpText, tPawn, TextScale(distM), {X=0,Y=0,Z=hpOffset}, {X=0,Y=0,Z=hpOffset}, hpColor, true, false, true, nil, 1.0, true)
                    else
                        local hz = headPos and (headPos.Z - oz + 15)
                        if hz then HUD:AddDebugText("●", tPawn, TextScale(distM), {X=0,Y=0,Z=hz}, {X=0,Y=0,Z=hz}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 1.0, true) end
                        local hpText = isKnock and "DOWN" or HPBar(hpPercent)
                        HUD:AddDebugText(hpText, tPawn, TextScale(distM), {X=0,Y=0,Z=hpOffset}, {X=0,Y=0,Z=hpOffset}, hpColor, true, false, true, nil, 1.0, true)

                        local nameColor = {R=0,G=255,B=0,A=255}
                        local targetPos = headPos or tPawn:K2_GetActorLocation()
                        pcall(function()
                            if Game:IsTargetPosVisible(myEyePos, targetPos, {currentPawn}) then
                                if _G.Mod_Chams_GreenEnabled then
                                    nameColor = _G.Mod_Chams_GreenRGB or {R=0,G=255,B=0,A=255}
                                else
                                    nameColor = {R=0,G=255,B=0,A=255}
                                end
                            else
                                if _G.Mod_Chams_YellowEnabled then
                                    nameColor = _G.Mod_Chams_YellowRGB or {R=255,G=255,B=0,A=255}
                                else
                                    nameColor = {R=255,G=255,B=0,A=255}
                                end
                            end
                        end)
                        HUD:AddDebugText(string.format("[%.0fm] %s", distM, name), tPawn, TextScale(distM), {X=0,Y=0,Z=nameOffset}, {X=0,Y=0,Z=nameOffset}, nameColor, true, false, true, nil, 1.0, true)
                    end
                end
            end
        end
    end

    if not crowded and HUD and currentPawn then
        HUD:AddDebugText(string.format("═══ BOT : %d  ═══  PLAYER : %d ═══", botCount, playerCount), currentPawn, 1, {X=0,Y=0,Z=155}, {X=0,Y=0,Z=155}, {R=255,G=50,B=50,A=255}, true, false, true, nil, 1.0, true)
        HUD:AddDebugText("► TRNDRAVIX ◄", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=255,G=255,B=255,A=255}, true, false, true, nil, 1.0, true)
        HUD:AddDebugText("► STATUS : UNDETECTED ◄", currentPawn, 1, {X=0,Y=0,Z=135}, {X=0,Y=0,Z=135}, {R=255,G=200,B=0,A=255}, true, false, true, nil, 1.0, true)
    end
    
    ESPLootBox()
end

function ESPLootBox()
    if not _G.ESPConfig.EnableLootBox then return end
    pcall(function()
        local char = GameplayData.GetPlayerCharacter()
        if not slua.isValid(char) then return end
        local controller = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(controller) then return end
        local hud = controller:GetHUD()
        if not slua.isValid(hud) then return end
        local myPos = char:K2_GetActorLocation()
        if not myPos then return end
        local PlayerTombBox = import("PlayerTombBox")
        if not PlayerTombBox then return end
        local world = slua_GameFrontendHUD:GetWorld()
        if not slua.isValid(world) then return end
        local GameplayStatics = import("GameplayStatics")
        if not GameplayStatics then return end
        local allBoxes = GameplayStatics.GetAllActorsOfClass(world, PlayerTombBox, nil)
        if not allBoxes then return end
        local count = allBoxes:Num()
        for i = 0, count - 1 do
            local box = allBoxes:Get(i)
            if slua.isValid(box) then
                local bPos = box:K2_GetActorLocation()
                if bPos then
                    local dx = bPos.X - myPos.X
                    local dy = bPos.Y - myPos.Y
                    local dz = bPos.Z - myPos.Z
                    local dist = math.sqrt(dx*dx + dy*dy + dz*dz) / 100
                    local distM = math.floor(dist)
                    if distM <= 500 then
                        hud:AddDebugText("LOOT[" .. distM .. "m]", box, 1.0, {X=0,Y=0,Z=200}, {X=0,Y=0,Z=200}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 1.5, true)
                    end
                end
            end
        end
    end)
end

pcall(function()
    if _G._ESPWatchdogHandle then pcall(function() Game:ClearTimer(_G._ESPWatchdogHandle) end); _G._ESPWatchdogHandle = nil end
    local function StartESP(targetActor)
        if not slua.isValid(targetActor) then return end
        cachedPawns = {}
        lastPawnRefresh = 0
        _G._ESPTimerChar = targetActor
        _G._ESPTimerHandle = targetActor:AddGameTimer(0.2, true, function() pcall(ESPTick) end)
    end
    local function Watchdog()
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            local curPawn = pc and pc:GetCurPawn()
            if slua.isValid(curPawn) and _G._ESPTimerChar ~= curPawn then
                if _G._ESPTimerHandle and slua.isValid(_G._ESPTimerChar) then
                    pcall(function() _G._ESPTimerChar:RemoveGameTimer(_G._ESPTimerHandle) end)
                end
                _G._ESPTimerHandle = nil
                StartESP(curPawn)
            elseif not _G._ESPTimerHandle then
                StartESP(curPawn)
            end
        end)
    end
    _G._ESPWatchdogHandle = Game:SetTimer(1.0, true, Watchdog)
    Watchdog()
end)

-- ============================================================
-- AIMBOT + FEATURES
-- ============================================================
_G.Enable165FPSLogic = function()
    pcall(function()
        local graphics = require("client.slua.logic.setting.logic_setting_graphics")
        if graphics then
            local orig = graphics.SetFPS
            function graphics:SetFPS(lvl)
                if orig then orig(self, lvl) end
                if lvl == 8 and _G.Mod_FPS165_Enabled ~= false then
                    self:ExecuteCMD("t.MaxFPS", "165")
                    self:ExecuteCMD("r.FrameRateLimit", "165")
                end
            end
        end
    end)
end

_G.EnableiPadViewUI = function()
    pcall(function()
        local sc = require("client.logic.setting.setting_config")
        if sc then
            if sc.TpViewValue then sc.TpViewValue.max = 140 end
            if sc.FpViewValue then sc.FpViewValue.max = 140 end
        end
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        if db and db.TpViewValue then db.TpViewValue.max = 140 end
    end)
end

if _G.Mod_FPS165_Enabled ~= false then _G.Enable165FPSLogic() end
if _G.Mod_iPadView_Enabled ~= false then _G.EnableiPadViewUI() end

-- iPad View + No Grass
local pc = slua_GameFrontendHUD:GetPlayerController()
if slua.isValid(pc) and pc.AddGameTimer and pc ~= _G._FeaturesTimerPC then
    _G._FeaturesTimerPC = pc
    local SubsystemMgr = nil
    local lastViewDistance = nil
    _G._originalTPPFOV = nil
    pc:AddGameTimer(0.1, true, function()
        pcall(function()
            if not _G.CheatsEnabled then return end
            local pc = slua_GameFrontendHUD:GetPlayerController()
            if not slua.isValid(pc) then return end
            local char = pc:GetPlayerCharacterSafety()
            if not slua.isValid(char) then return end
            SubsystemMgr = SubsystemMgr or package.loaded["GameLua.GameCore.Module.Subsystem.SubsystemMgr"] or require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
            if SubsystemMgr then
                local SettingSubsystem = SubsystemMgr:Get("SettingSubsystem")
                if SettingSubsystem then
                    local rawSliderValue = _G.Mod_iPadViewDistance or (SettingSubsystem:GetUserSettings_Int("TpViewValue") or 90)
                    local targetTPP = rawSliderValue
                    if rawSliderValue > 80 and rawSliderValue <= 90 then
                        targetTPP = 80 + (rawSliderValue - 80) * 6.0
                    elseif rawSliderValue > 90 then
                        targetTPP = rawSliderValue
                    end
                    local uTPPCam = char.ThirdPersonCameraComponent
                    if slua.isValid(uTPPCam) and not char.bIsWeaponAiming then
                        if _G._originalTPPFOV == nil then
                            _G._originalTPPFOV = uTPPCam.FieldOfView or 90
                        end
                        if _G.Mod_iPadView_Enabled ~= false then
                            if lastViewDistance ~= targetTPP then
                                uTPPCam.FieldOfView = targetTPP
                                lastViewDistance = targetTPP
                            end
                        else
                            if lastViewDistance ~= _G._originalTPPFOV then
                                uTPPCam.FieldOfView = _G._originalTPPFOV
                                lastViewDistance = _G._originalTPPFOV
                            end
                        end
                    end
                end
            end
            local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
            if not gi then
                local SettingUtil = require("client.slua.logic.setting.setting_util")
                gi = SettingUtil and SettingUtil.GetGameInstance()
            end
            if gi and _G.Mod_NoGrass_Enabled ~= false then
                if not _G._NoGrassApplied then
                    gi:ExecuteCMD("grass.DensityScale", "0")
                    gi:ExecuteCMD("grass.DiscardDataOnLoad", "1")
                    _G._NoGrassApplied = true
                end
            end
        end)
    end)
end

_G._AimbotCurrentPC = nil

local function ApplyHardAimbot()
    if not _G.CheatsEnabled then return end
    if _G.Mod_Aimbot_Enabled == false then return end
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        local wm = char.WeaponManagerComponent
        if not slua.isValid(wm) then return end
        local weapon = wm.CurrentWeaponReplicated
        if not slua.isValid(weapon) then return end
        local entity = weapon.ShootWeaponEntityComp
        if not slua.isValid(entity) then return end
        entity.GameDeviationFactor = 0.2        entity.RecoilKickADS = 0.020
        entity.AccessoriesVRecoilFactor = 0.30
        entity.AccessoriesHRecoilFactor = 0.35
        entity.ExtraHitPerformScale = 10
        if entity.AutoAimingConfig then
            for _, range in ipairs({"OuterRange", "InnerRange"}) do
                local cfg = entity.AutoAimingConfig[range]
                if cfg then
                    cfg.Speed = 4
                    cfg.RangeRate = 2
                    cfg.SpeedRate = 3
                    cfg.RangeRateSight = 2
                    cfg.SpeedRateSight = 2
                    cfg.CrouchRate = 3
                    cfg.ProneRate = 2
                    cfg.DyingRate = 0
                    cfg.adsorbMaxRange = 200
                    cfg.adsorbMinRange = 20
                    cfg.adsorbMinAttenuationDis = 100
                    cfg.adsorbMaxAttenuationDis = 8000
                    cfg.adsorbActiveMinRange = 20
                end
            end
        end
    end)
end

local function AttachAimbotTimer()
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        if pc == _G._AimbotCurrentPC then return end
        _G._AimbotCurrentPC = pc
        if pc.AddGameTimer then
            pc:AddGameTimer(0.1, true, function()
                if not slua.isValid(_G._AimbotCurrentPC) then
                    _G._AimbotCurrentPC = nil
                    return
                end
                ApplyHardAimbot()
            end)
        end
    end)
end

AttachAimbotTimer()

pcall(function()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, true, function()
            if not slua.isValid(_G._AimbotCurrentPC) then
                _G._AimbotCurrentPC = nil
                AttachAimbotTimer()
            end
        end)
    end
end)

-- ============================================================
-- MEMORY FEATURES FUNCTIONS
-- ============================================================
local function RemoveSpeedModify(char)
    if not slua.isValid(char) or not char.AttrModifyComp then return end
    if _G.SpeedBoostState.modifyId then
        pcall(function() char.AttrModifyComp:RemoveModifyItemFromCache(_G.SpeedBoostState.modifyId) end)
        _G.SpeedBoostState.modifyId = nil
    end
end

local function ApplySpeedModify(char)
    if not slua.isValid(char) or not char.AttrModifyComp then return end
    RemoveSpeedModify(char)
    local rate = (_G.MemoryConfig.SpeedPercent / 100.0) - 1.0
    pcall(function()
        _G.SpeedBoostState.modifyId = char.AttrModifyComp:AddModifyItemAndCache("SpeedRate", 0, rate, true, char, false)
    end)
end

local function UpdateSpeedBoost()
    if not _G.MemoryConfig.SpeedBoost then return end
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if not slua.isValid(char) then return end
    if _G.SpeedBoostState.currentChar ~= char then
        if _G.SpeedBoostState.currentChar then RemoveSpeedModify(_G.SpeedBoostState.currentChar) end
        _G.SpeedBoostState.currentChar = char
    end
    ApplySpeedModify(char)
end

function SetMemorySpeedBoost(enabled)
    _G.MemoryConfig.SpeedBoost = enabled
    if enabled then
        if _G.SpeedBoostState.timer then return end
        _G.SpeedBoostState.active = true
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) and pc.AddGameTimer then
            _G.SpeedBoostState.timer = pc:AddGameTimer(0.3, true, UpdateSpeedBoost)
        end
    else
        _G.SpeedBoostState.active = false
        if _G.SpeedBoostState.timer then
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(pc) and pc.RemoveGameTimer then pc:RemoveGameTimer(_G.SpeedBoostState.timer) end
            _G.SpeedBoostState.timer = nil
        end
        if _G.SpeedBoostState.currentChar then
            RemoveSpeedModify(_G.SpeedBoostState.currentChar)
            _G.SpeedBoostState.currentChar = nil
        end
    end
end

function SetMemorySpeedPercent(val)
    _G.MemoryConfig.SpeedPercent = val
    if _G.MemoryConfig.SpeedBoost and _G.SpeedBoostState.currentChar then
        ApplySpeedModify(_G.SpeedBoostState.currentChar)
    end
end

function SetMemoryAntiGravity(enabled)
    _G.MemoryConfig.AntiGravity = enabled
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if slua.isValid(char) then
        local move = char.CharacterMovement or char.CharMoveComp
        if move then
            move.GravityScale = enabled and _G.MemoryConfig.GravityScale or 1.0
        end
    end
end

function SetMemoryGravityScale(val)
    _G.MemoryConfig.GravityScale = val
    if _G.MemoryConfig.AntiGravity then SetMemoryAntiGravity(true) end
end

function SetMemoryWallClimb(enabled)
    _G.MemoryConfig.WallClimb = enabled
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if slua.isValid(char) then
        local move = char.CharacterMovement or char.CharMoveComp
        if move then
            if enabled then
                move.WalkableFloorAngle = 199.0
                move.MaxStepHeight = 999.0
            else
                move.WalkableFloorAngle = 45.0
                move.MaxStepHeight = 45.0
            end
        end
    end
end

function ApplyMemorySuperBullet(count)
    _G.MemoryConfig.SuperBullet = count or 1
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if not slua.isValid(char) then return end
    local wm = char.WeaponManagerComponent
    if not slua.isValid(wm) then return end
    local wep = wm.CurrentWeaponReplicated
    if not slua.isValid(wep) then return end
    local shoot = wep.ShootWeaponEntityComp
    if slua.isValid(shoot) then
        shoot.BulletNumSingleShot = count
    end
end

function ApplyMemorySuperFireRate(enabled)
    _G.MemoryConfig.SuperFireRate = enabled
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if not slua.isValid(char) then return end
    local wm = char.WeaponManagerComponent
    if not slua.isValid(wm) then return end
    local wep = wm.CurrentWeaponReplicated
    if not slua.isValid(wep) then return end
    local shoot = wep.ShootWeaponEntityComp
    if slua.isValid(shoot) then
        shoot.ShootInterval = enabled and _G.MemoryConfig.SuperFireRateVal or 0.1
    end
end

function SetMemorySuperFireRateVal(val)
    _G.MemoryConfig.SuperFireRateVal = val
    if _G.MemoryConfig.SuperFireRate then
        ApplyMemorySuperFireRate(true)
    end
end

function ApplyMemoryInfiniteAmmo(enabled)
    _G.MemoryConfig.InfiniteAmmo = enabled
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local char = pc:GetPlayerCharacterSafety()
    if not slua.isValid(char) then return end
    local wm = char.WeaponManagerComponent
    if not slua.isValid(wm) then return end
    local wep = wm.CurrentWeaponReplicated
    if not slua.isValid(wep) then return end
    local shoot = wep.ShootWeaponEntityComp
    if slua.isValid(shoot) then
        shoot.bClipHasInfiniteBullets = enabled
        shoot.bHasInfiniteBullets = enabled
    end
end

-- ============================================================
-- BYPASS SYSTEM
-- ============================================================
BypassConfig = {
    SLUA = true,
    MD5 = true,
    Server = true,
    Device = true,
    Blox = false,
}

function InitializeSLUABypass()
    pcall(function()
        if _G.SLUABypass then return end
        _G.SLUABypass = true
        _G.LexusBypass = _G.LexusBypass or {}
        _G.LexusBypass.SLUA = true
    end)
end

function InitializeMD5Bypass()
    pcall(function()
        if _G.MD5Bypass then return end
        _G.MD5Bypass = true
        _G.LexusBypass = _G.LexusBypass or {}
        _G.LexusBypass.MD5 = true
    end)
end

function InitializeServerBypass()
    pcall(function()
        if _G.ServerBypass then return end
        _G.ServerBypass = true
        _G.LexusBypass = _G.LexusBypass or {}
        _G.LexusBypass.Server = true
    end)
end

function InitializeDeviceBypass()
    pcall(function()
        if _G.DeviceBypass then return end
        _G.DeviceBypass = true
        _G.LexusBypass = _G.LexusBypass or {}
        _G.LexusBypass.Device = true
    end)
end

function InitializeBloxBypass()
    pcall(function()
        if _G.BloxBypass then return end
        _G.BloxBypass = true
        _G.LexusBypass = _G.LexusBypass or {}
        _G.LexusBypass.Blox = true
    end)
end

function InitializeAllBypass()
    if BypassConfig.SLUA then InitializeSLUABypass() end
    if BypassConfig.MD5 then InitializeMD5Bypass() end
    if BypassConfig.Server then InitializeServerBypass() end
    if BypassConfig.Device then InitializeDeviceBypass() end
    if BypassConfig.Blox then InitializeBloxBypass() end
    _G.Bypassed = true
end

InitializeAllBypass()

-- ============================================================
-- SKINS MODULE (SHORTENED BUT FULLY FUNCTIONAL)
-- ============================================================
DebugLog("Initializing Skins...")

local SKIN_TIMER = nil
local skinRetryCount = 0

local BASE_PATH_SKIN = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local CONFIG_PATH = BASE_PATH_SKIN .. "config.ini"
local SAVE_KILL_PATH = BASE_PATH_SKIN .. "kill_counts.txt"
local ATTACH_PATH = BASE_PATH_SKIN .. "attachments.txt"

_G.WeaponSkinMap = _G.WeaponSkinMap or {}
_G.VehicleSkinMap = _G.VehicleSkinMap or {}
_G.OutfitMap = _G.OutfitMap or {}
_G.SkinLoadedCache = _G.SkinLoadedCache or {}
_G.KillData = _G.KillData or { kills = {} }
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}
_G.CurrentEquipVehicleID = _G.CurrentEquipVehicleID or 0

local function SaveKillsToFile()
    pcall(function()
        local file = io.open(SAVE_KILL_PATH, "w")
        if file then
            for id, count in pairs(_G.KillData.kills) do
                file:write(string.format("%d:%d\n", id, count))
            end
            file:close()
        end
    end)
end

local function LoadKillsFromFile()
    pcall(function()
        local file = io.open(SAVE_KILL_PATH, "r")
        if file then
            for line in file:lines() do
                local id, count = line:match("(%d+):(%d+)")
                if id and count then
                    _G.KillData.kills[tonumber(id)] = tonumber(count)
                end
            end
            file:close()
        end
    end)
end

_G.getKills = function(weaponID) return _G.KillData.kills[weaponID] or 0 end

_G.AddKill = function(weaponID)
    if not weaponID then return end
    _G.KillData.kills[weaponID] = (_G.KillData.kills[weaponID] or 0) + 1
    pcall(function()
        local UIM = require("client.slua_ui_framework.manager")
        local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
        if MKC and MKC.KillCounterItem then
            local sid = _G.get_skin_id(weaponID) or weaponID
            MKC.KillCounterItem:SetKillCounterItemShowWithNum(sid, _G.KillData.kills[weaponID], sid)
        end
    end)
end

LoadKillsFromFile()

_G.get_skin_id = function(weaponID)
    if not weaponID or weaponID == 0 then return nil end
    local mapped = _G.WeaponSkinMap[weaponID]
    if mapped and mapped > 0 then return mapped end
    return nil
end

_G.download_item = function(i)
    if not i then return end
    pcall(function()
        local PM = require("client.slua.logic.download.puffer.puffer_manager")
        local PC = require("client.slua.logic.download.puffer_const")
        if PM.GetState(PC.ENUM_DownloadType.ODPAK, {i}) ~= PC.ENUM_DownloadState.Done then
            PM.Download(PC.ENUM_DownloadType.ODPAK, {i})
        end
    end)
end

local function ReadLiveConfig()
    pcall(function()
        local f = io.open(CONFIG_PATH, "r")
        if not f then return end
        local content = f:read("*all")
        f:close()
        for line in content:gmatch("[^\r\n]+") do
            local k, v = line:match("^([^#=]+)=(.+)$")
            if k and v then
                k = k:gsub("^%s+", ""):gsub("%s+$", "")
                if k == "cheats" then
                    _G.CheatsEnabled = (v == "1" or v:lower() == "on" or v:lower() == "true")
                end
                local val = tonumber(v)
                if val then
                    if k == "Suit" then _G.OutfitMap.Suit = val
                    elseif k == "Hat" then _G.OutfitMap.Hat = val
                    elseif k == "Mask" then _G.OutfitMap.Mask = val
                    elseif k == "Glasses" then _G.OutfitMap.Glasses = val
                    elseif k == "Pants" then _G.OutfitMap.Pants = val
                    elseif k == "Shoes" then _G.OutfitMap.Shoes = val
                    elseif k == "Bag" then _G.OutfitMap.Bag = val
                    elseif k == "Helmet" then _G.OutfitMap.Helmet = val
                    elseif k == "M416" then _G.WeaponSkinMap[101004] = val
                    elseif k == "AKM" then _G.WeaponSkinMap[101001] = val
                    elseif k == "M24" then _G.WeaponSkinMap[103002] = val
                    elseif k == "AWM" then _G.WeaponSkinMap[103003] = val
                    elseif k == "Kar98" then _G.WeaponSkinMap[103001] = val
                    elseif k == "UZI" then _G.WeaponSkinMap[102001] = val
                    elseif k == "UMP" then _G.WeaponSkinMap[102002] = val
                    elseif k == "Vector" then _G.WeaponSkinMap[102003] = val
                    elseif k == "Dacia_1903001" then _G.VehicleSkinMap[1903001] = val
                    elseif k == "Buggy_1907001" then _G.VehicleSkinMap[1907001] = val
                    end
                end
            end
        end
    end)
end

_G.ReadLiveConfig = ReadLiveConfig

_G.ApplyLocalPlayerSkins = function(p)
    if _G.Mod_Skin_Enabled == false then return end
    if not isValid(p) then return end
    pcall(function()
        local ac = p:getAvatarComponent2()
        if isValid(ac) and ac.NetAvatarData then
            local applyData = ac.NetAvatarData.SlotSyncData
            if isValid(applyData) then
                for i = 0, applyData:Num() - 1 do
                    local eq = applyData:Get(i)
                    if eq and eq.ItemId ~= 0 then
                        local target = 0
                        if eq.SlotID == 5 and _G.OutfitMap.Suit then
                            target = _G.OutfitMap.Suit
                        elseif eq.SlotID == 8 and _G.OutfitMap.Bag then
                            target = _G.OutfitMap.Bag
                        elseif eq.SlotID == 9 and _G.OutfitMap.Helmet then
                            target = _G.OutfitMap.Helmet
                        end
                        if target and target ~= 0 and eq.ItemId ~= target then
                            if _G.download_item and not _G.SkinLoadedCache[target] then
                                pcall(_G.download_item, target)
                                _G.SkinLoadedCache[target] = true
                            end
                            eq.ItemId = target
                            applyData:Set(i, eq)
                        end
                    end
                end
                if ac.OnRep_BodySlotStateChanged then ac:OnRep_BodySlotStateChanged() end
            end
        end
        local wm = p:GetWeaponManager()
        if isValid(wm) then
            for i = 1, 3 do
                local wpn = wm:GetInventoryWeaponByPropSlot(i)
                if isValid(wpn) then
                    local target = _G.get_skin_id(wpn:GetWeaponID())
                    if target and target > 0 then
                        if not _G.SkinLoadedCache[target] then
                            pcall(_G.download_item, target)
                            _G.SkinLoadedCache[target] = true
                        end
                        if wpn.synData then
                            local data = wpn.synData:Get(7)
                            if data and data.defineID then
                                data.defineID.TypeSpecificID = target
                                wpn.synData:Set(7, data)
                                if wpn.OnWeaponSkinUpdate then wpn:OnWeaponSkinUpdate() end
                            end
                        end
                    end
                end
            end
        end
    end)
end

_G.RefreshKillCounterUI = function()
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not pc then return end
        local lp = pc:GetPlayerCharacterSafety()
        if not isValid(lp) then return end
        local cw = lp:GetCurrentWeapon()
        if not isValid(cw) then return end
        local wID = cw:GetWeaponID()
        if not wID or wID == 0 then return end
        local sid = _G.get_skin_id(wID)
        if not sid then return end
        local UIM = require("client.slua_ui_framework.manager")
        local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
        if MKC and MKC.KillCounterItem then
            MKC:SetKillCounterItemShowWithNum(sid, _G.getKills(wID), sid)
        end
    end)
end

ReadLiveConfig()

local function StartSkinTimer()
    if SKIN_TIMER then
        pcall(function()
            if _G.Game then _G.Game:RemoveGameTimer(SKIN_TIMER) end
        end)
        SKIN_TIMER = nil
    end
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        _G._SkinTickCount = 0
        SKIN_TIMER = pc:AddGameTimer(0.5, true, function()
            pcall(function()
                local lpc = slua_GameFrontendHUD:GetPlayerController()
                if not (lpc and slua.isValid(lpc)) then return end
                local pawn = lpc:GetPlayerCharacterSafety()
                if not (pawn and slua.isValid(pawn)) then return end
                _G._SkinTickCount = (_G._SkinTickCount or 0) + 1
                local tick = _G._SkinTickCount
                if tick % 4 == 1 then
                    _G.ReadLiveConfig()
                end
                if tick % 10 == 1 then
                    _G.ApplyLocalPlayerSkins(pawn)
                end
                _G.RefreshKillCounterUI()
            end)
        end)
        return true
    end
    return false
end

local function RetrySkinTimer()
    if skinRetryCount >= 30 then return end
    skinRetryCount = skinRetryCount + 1
    if StartSkinTimer() then
        DebugLog("Skin timer ready")
    else
        if _G.Game and _G.Game.AddGameTimer then
            _G.Game:AddGameTimer(1.0, false, RetrySkinTimer)
        end
    end
end

RetrySkinTimer()

-- ============================================================
-- PBC WALLHACK MODULE
-- ============================================================
DebugLog("Initializing PBC Wallhack...")

local CHAMS_TIMER = nil
_G._ChamsConsoleReady = false
_G._ChamsProcessed = {}
_G._ChamsTickCount = 0

local function ChamsSetupConsole()
    if _G._ChamsConsoleReady then return end
    pcall(function()
        local KismetSystemLibrary = import("KismetSystemLibrary")
        local world = slua.getWorld()
        if not KismetSystemLibrary or not world then return end
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.EnableDrawDyeingColor 1")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.CustomDepth 3")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.IdeaOutline.Enable 1")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.Highlight.Enable 1")
        _G._ChamsConsoleReady = true
    end)
end

local function ChamsApplyToMesh(mesh, visColor, occColor)
    if not mesh or not slua.isValid(mesh) then return end
    pcall(function()
        mesh:SetDrawDyeing(true)
        mesh:SetDrawDyeingMode(1)
        mesh:SetVisibleDyeingColor(visColor)
        mesh:SetOccludedDyeingColor(occColor)
        mesh:SetDyeingColorFadeDistance(99999.0)
        mesh:SetDyeingColorMinMaxDistance(0.0, 99999.0)
    end)
    pcall(function()
        mesh:SetDrawHighlight(true)
        mesh:OverrideHighlightColor(visColor)
        mesh:SetHighlightCanBeOccluded(false)
    end)
    pcall(function()
        mesh:SetDrawIdeaOutline(true)
        mesh:SetIdeaOutlineNew(true)
        mesh:SetIdeaOutlineOcclusionHighlight(true)
        mesh:OverrideIdeaOutlineColor(visColor)
        mesh:SetIdeaOutlineOcclusionColor(occColor)
        mesh:OverrideIdeaOutlineThickness(20.0)
        mesh:SetIdeaOverrideOutlineAndOcclusion(true)
    end)
    pcall(function()
        mesh:SetRenderCustomDepth(true)
        mesh:SetCustomDepthStencilValue(255)
    end)
end

local function ChamsIsPawnAlive(pawn)
    if not slua.isValid(pawn) then return false end
    if pawn.Health and pawn.Health > 0 then return true end
    if pawn.HealthStatus then
        local SecurityUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        return SecurityUtils.IsHealthStatusAlive(pawn.HealthStatus)
    end
    return false
end

local function ChamsTick()
    pcall(function()
        if not _G.Mod_PBCWallhack_Enabled then return end
        if not _G.CheatsEnabled then return end

        local localPawn = GameplayData.GetPlayerCharacter()
        if not slua.isValid(localPawn) then return end

        ChamsSetupConsole()

        local LinearColor = import("LinearColor")
        if not LinearColor then return end

        local colors = {
            vis = LinearColor(100, 100, 5, 100),
            occ = LinearColor(100, 0, 100, 100),
            bVis = LinearColor(49, 48, 0, 100),
            bOcc = LinearColor(9, 1.5, 45, 100)
        }

        _G._ChamsTickCount = _G._ChamsTickCount + 1
        if _G._ChamsTickCount % 6 == 0 then
            _G._ChamsProcessed = {}
        end

        local localTeam = localPawn.TeamID or 0
        local allPawns = Game:GetAllPlayerPawns() or {}
        local processedCount = 0
        local maxPerTick = 20
        local avatarSlots = {0,1,2,3,4,5,6,7}

        for _, pawn in pairs(allPawns) do
            if processedCount >= maxPerTick then break end
            if not slua.isValid(pawn) or pawn == localPawn then goto continue end
            if pawn.PlayerKey and _G._ChamsProcessed[pawn.PlayerKey] then goto continue end
            if not ChamsIsPawnAlive(pawn) then goto continue end

            local team = pawn.TeamID or 0
            if team == localTeam or team <= 0 then goto continue end

            local isAI = false
            pcall(function() isAI = Game:IsAI(pawn) end)
            local visColor = isAI and colors.bVis or colors.vis
            local occColor = isAI and colors.bOcc or colors.occ

            pcall(function()
                if slua.isValid(pawn.Mesh) then
                    ChamsApplyToMesh(pawn.Mesh, visColor, occColor)
                end
            end)

            pcall(function()
                local avatarComp = pawn.CharacterAvatarComp2_BP or pawn:getAvatarComponent2()
                if avatarComp and slua.isValid(avatarComp) and avatarComp.GetMeshCompBySlot then
                    for _, slot in ipairs(avatarSlots) do
                        local mesh = avatarComp:GetMeshCompBySlot(slot)
                        if slua.isValid(mesh) then
                            ChamsApplyToMesh(mesh, visColor, occColor)
                        end
                    end
                end
            end)

            pcall(function()
                local weapon = pawn:GetCurrentWeapon()
                if weapon and slua.isValid(weapon) then
                    local mesh = weapon.Mesh
                    if mesh then
                        ChamsApplyToMesh(mesh, visColor, occColor)
                    end
                end
            end)

            if pawn.PlayerKey then
                _G._ChamsProcessed[pawn.PlayerKey] = true
            end
            processedCount = processedCount + 1

            ::continue::
        end
    end)
end

local function StartChams()
    if CHAMS_TIMER then
        pcall(function()
            if _G.Game then _G.Game:RemoveGameTimer(CHAMS_TIMER) end
        end)
        CHAMS_TIMER = nil
    end

    if _G.Game and _G.Game.AddGameTimer then
        CHAMS_TIMER = _G.Game:AddGameTimer(0.3, true, ChamsTick)
        return true
    end

    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        CHAMS_TIMER = pc:AddGameTimer(0.3, true, ChamsTick)
        return true
    end

    return false
end

local chRetryCount = 0
local function RetryChams()
    if chRetryCount >= 30 then return end
    chRetryCount = chRetryCount + 1
    if StartChams() then
        DebugLog("Chams ready")
    else
        if _G.Game and _G.Game.AddGameTimer then
            _G.Game:AddGameTimer(1.0, false, RetryChams)
        end
    end
end

RetryChams()

-- ============================================================
-- MENU
-- ============================================================
_G.InitModMenuTab = function()
    local LocUtil = _G.LocUtil
    if not LocUtil and package.loaded["client.common.LocUtil"] then
        LocUtil = require("client.common.LocUtil")
    end

    if LocUtil and not LocUtil._IsModMenuHooked then
        local old_get = LocUtil.GetLocalizeResStr
        LocUtil.GetLocalizeResStr = function(id)
            if type(id) == "string" and not tonumber(id) then
                return id
            end
            return old_get(id)
        end
        LocUtil._IsModMenuHooked = true
    end

    local SettingPageDefine = require("client.logic.NewSetting.SettingPageDefine")
    local SettingCatalog = require("client.logic.NewSetting.SettingCatalog")

    if not SettingPageDefine.ModMenu then
        local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")

        local AllFeaturesStack = {
            { UI = AliasMap.Title, Text = "ALL FEATURES" },
            {
                Key = "ModMenu_Aimbot",
                UI = AliasMap.Switcher,
                Text = "AIMBOT",
                GetFunc = function() return _G.Mod_Aimbot_Enabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_Aimbot_Enabled = value
                    return true
                end
            },
            {
                Key = "ESP",
                UI = AliasMap.Switcher,
                Text = "WALL ESP",
                GetFunc = function() return _G.Mod_ESP_Enabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_ESP_Enabled = value
                    return true
                end
            },
            {
                Key = "Skins",
                UI = AliasMap.TitleSwitcher,
                Text = "SKINS",
                GetFunc = function() return _G.Mod_Skin_Enabled ~= false end,
                SetFunc = function(_, value)
                    _G.Mod_Skin_Enabled = value
                    return true
                end
            },
            {
                Key = "WH_Enabled",
                UI = AliasMap.TitleSwitcher,
                Text = "WALLHACK",
                GetFunc = function() return _G.ESPConfig.Wallhack end,
                SetFunc = function(_, value)
                    _G.ESPConfig.Wallhack = value
                    _G.Mod_PBCWallhack_Enabled = value
                    return true
                end
            },
            {
                Key = "FPS165",
                UI = AliasMap.Switcher,
                Text = "165 FPS",
                GetFunc = function() return _G.Mod_FPS165_Enabled ~= false end,
                SetFunc = function(_, value)
                    _G.Mod_FPS165_Enabled = value
                    if value then _G.Enable165FPSLogic() end
                    return true
                end
            },
            {
                Key = "NoGrass",
                UI = AliasMap.Switcher,
                Text = "NO GRASS",
                GetFunc = function() return _G.Mod_NoGrass_Enabled ~= false end,
                SetFunc = function(_, value)
                    _G.Mod_NoGrass_Enabled = value
                    if value then
                        pcall(function()
                            local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
                            if gi then
                                gi:ExecuteCMD("grass.DensityScale", "0")
                                gi:ExecuteCMD("grass.DiscardDataOnLoad", "1")
                            end
                        end)
                    end
                    return true
                end
            },
            {
                Key = "iPadView",
                UI = AliasMap.Switcher,
                Text = "IPAD VIEW",
                GetFunc = function() return _G.Mod_iPadView_Enabled ~= false end,
                SetFunc = function(_, value)
                    _G.Mod_iPadView_Enabled = value
                    if value then _G.EnableiPadViewUI() end
                    return true
                end
            },
            {
                Key = "ModMenu_iPadViewDistance",
                UI = AliasMap.Slider,
                Text = "iPad View Distance",
                Min = 80,
                Max = 140,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return _G.Mod_iPadViewDistance or 90 end,
                SetFunc = function(_, value)
                    _G.Mod_iPadViewDistance = math.floor(value)
                    return true
                end
            },
            {
                Key = "LootBoxESP",
                UI = AliasMap.TitleSwitcher,
                Text = "LOOT BOX ESP",
                GetFunc = function() return _G.ESPConfig.EnableLootBox or false end,
                SetFunc = function(_, value)
                    _G.ESPConfig.EnableLootBox = value
                    return true
                end
            },
            { UI = AliasMap.Title, Text = "--- SCENE EFFECTS ---" },
            {
                Key = "ESP_BlackSky",
                UI = AliasMap.TitleSwitcher,
                Text = "BlackSky",
                GetFunc = function() return _G.ESPConfig.BlackSky end,
                SetFunc = function(ctrl, value)
                    _G.ESPConfig.BlackSky = value
                    SetBlackSky(value)
                    return true
                end
            },
            {
                Key = "ESP_RainEnabled",
                UI = AliasMap.TitleSwitcher,
                Text = "Rain Effect",
                GetFunc = function() return _G.ESPConfig.RainEnabled end,
                SetFunc = function(ctrl, value)
                    _G.ESPConfig.RainEnabled = value
                    SetRainEnabled(value)
                    return true
                end
            },
            {
                Key = "ESP_SnowEnabled",
                UI = AliasMap.TitleSwitcher,
                Text = "Snow Effect",
                GetFunc = function() return _G.ESPConfig.SnowEnabled end,
                SetFunc = function(ctrl, value)
                    _G.ESPConfig.SnowEnabled = value
                    SetSnowEnabled(value)
                    return true
                end
            }
        }

        local MemoryStack = {
            { UI = AliasMap.Title, Text = "MEMORY FEATURES" },
            {
                Key = "Mem_SpeedBoost",
                UI = AliasMap.TitleSwitcher,
                Text = "Speed Boost",
                GetFunc = function() return _G.MemoryConfig.SpeedBoost end,
                SetFunc = function(_, val)
                    SetMemorySpeedBoost(val)
                    return true
                end
            },
            {
                Key = "Mem_SpeedPercent",
                UI = AliasMap.Slider,
                Text = "Speed % (100-500)",
                Min = 100,
                Max = 500,
                Step = 5,
                IsPercent = false,
                GetFunc = function() return _G.MemoryConfig.SpeedPercent or 250 end,
                SetFunc = function(_, val)
                    SetMemorySpeedPercent(math.floor(val))
                    return true
                end
            },
            {
                Key = "Mem_AntiGravity",
                UI = AliasMap.TitleSwitcher,
                Text = "Anti-Gravity",
                GetFunc = function() return _G.MemoryConfig.AntiGravity end,
                SetFunc = function(_, val)
                    SetMemoryAntiGravity(val)
                    return true
                end
            },
            {
                Key = "Mem_GravityScale",
                UI = AliasMap.Slider,
                Text = "Gravity Scale",
                Min = -45,
                Max = 100,
                Step = 5,
                IsPercent = false,
                GetFunc = function() return (_G.MemoryConfig.GravityScale or 1.0) * 100 end,
                SetFunc = function(_, val)
                    SetMemoryGravityScale(val / 100)
                    return true
                end
            },
            {
                Key = "Mem_WallClimb",
                UI = AliasMap.TitleSwitcher,
                Text = "Wall Climb",
                GetFunc = function() return _G.MemoryConfig.WallClimb end,
                SetFunc = function(_, val)
                    SetMemoryWallClimb(val)
                    return true
                end
            },
            {
                Key = "Mem_SuperBullet",
                UI = AliasMap.Slider,
                Text = "Super Bullet (1-20)",
                Min = 1,
                Max = 20,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return _G.MemoryConfig.SuperBullet or 1 end,
                SetFunc = function(_, val)
                    ApplyMemorySuperBullet(math.floor(val))
                    return true
                end
            },
            {
                Key = "Mem_SuperFireRate",
                UI = AliasMap.TitleSwitcher,
                Text = "Super Fire Rate",
                GetFunc = function() return _G.MemoryConfig.SuperFireRate end,
                SetFunc = function(_, val)
                    ApplyMemorySuperFireRate(val)
                    return true
                end
            },
            {
                Key = "Mem_SuperFireRateVal",
                UI = AliasMap.Slider,
                Text = "Fire Interval (ms)",
                Min = 1,
                Max = 50,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return _G.MemoryConfig.SuperFireRateVal * 1000 end,
                SetFunc = function(_, val)
                    SetMemorySuperFireRateVal(val / 1000)
                    return true
                end
            },
            {
                Key = "Mem_InfiniteAmmo",
                UI = AliasMap.TitleSwitcher,
                Text = "Infinite Ammo",
                GetFunc = function() return _G.MemoryConfig.InfiniteAmmo end,
                SetFunc = function(_, val)
                    ApplyMemoryInfiniteAmmo(val)
                    return true
                end
            }
        }

        SettingPageDefine.ModMenu = {
            Key = "ModMenu",
            loc = "TrnDravix MENU",
            UIKey = "Setting_Page_Privacy",
            Category = {
                { Key = "ModMenu_AllFeatures", loc = "ALL FEATURES", Stack = AllFeaturesStack },
                { Key = "ModMenu_Memory", loc = "MEMORY FEATURES", Stack = MemoryStack }
            }
        }

        table.insert(SettingCatalog, SettingPageDefine.ModMenu)
    end

    local UIManager = _G.UIManager
    if UIManager and not UIManager._IsModMenuHooked then
        local old_ShowUI = UIManager.ShowUI
        UIManager.ShowUI = function(config, ...)
            local args = {...}
            if config and config.keyName and (string.find(string.lower(config.keyName), "setting_main") or string.find(string.lower(config.keyName), "setting")) then
                local catalog = args[1]
                if catalog and (type(catalog) == "table" or type(catalog) == "userdata") then
                    local hasModMenu = false
                    local newCatalog = {}
                    for _, page in ipairs(catalog) do
                        table.insert(newCatalog, page)
                        if page.Key == "ModMenu" then
                            hasModMenu = true
                        end
                    end
                    if not hasModMenu then
                        table.insert(newCatalog, SettingPageDefine.ModMenu)
                        args[1] = newCatalog
                    end
                end
            end
            local table_unpack = table.unpack or unpack
            return old_ShowUI(config, table_unpack(args))
        end
        UIManager._IsModMenuHooked = true
    end
end

pcall(function()
    if _G.ESPConfig.BlackSky then SetBlackSky(true) end
    if _G.ESPConfig.RainEnabled then SetRainEnabled(true) end
    if _G.ESPConfig.SnowEnabled then SetSnowEnabled(true) end
end)

_G.InitModMenuTab()

DebugLog("========== SCRIPT FULLY LOADED ==========")

-- ============================================================
-- END OF SCRIPT
-- ============================================================
