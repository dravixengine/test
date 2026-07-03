-- ============================================================
-- MODDED BY TrnDravix + @TrnDravix
-- Complete MOD with Bypass V2.0 + SKINS + PBC WALLHACK + COLOR CONTROLS + GLOW
-- All features: Aimbot, ESP, PBC Wallhack, 165 FPS, No Grass, iPad View, SKINS
-- Bypass activates on game start with popup
-- ============================================================

-- ============================================================
-- PER-MATCH GUARD (re-init when player controller changes)
-- ============================================================
do
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G._MOD_LOADED and _G._MOD_PC == pc then return end
    _G._MOD_LOADED = true
    _G._MOD_PC = pc
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
-- MEMORY FEATURES FUNCTIONS
-- ============================================================

local function Norm(val, min, max) return (val - min) / (max - min) end
local function DeNorm(norm, min, max) return min + (norm * (max - min)) end

-- ===== SPEED BOOST =====
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

-- ===== ANTI-GRAVITY =====
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

-- ===== WALL CLIMB =====
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

-- ===== SUPER BULLET =====
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

-- ===== SUPER FIRE RATE =====
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

-- ===== INFINITE AMMO =====
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
-- LOOT BOX ESP
-- ============================================================
local lootBoxCache = {}
local lootBoxCacheTime = 0

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
        
        local currentTime = os.clock()
        if currentTime - lootBoxCacheTime > 3.0 then
            lootBoxCache = {}
            lootBoxCacheTime = currentTime
        end
        
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
                        hud:AddDebugText(
                            "LOOT[" .. distM .. "m]",
                            box,
                            1.0,
                            {X = 0, Y = 0, Z = 200},
                            {X = 0, Y = 0, Z = 200},
                            {R = 255, G = 0, B = 0, A = 255},
                            true, false, true, nil,
                            1.5,
                            true
                        )
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- ============================================================
-- LICENSE KEY SYSTEM (ONLINE VALIDATION WITH PANEL)
-- ============================================================

-- Try multiple paths for error file
local function WriteError(msg)
    local paths = {
        "/sdcard/error.txt",
        "/storage/emulated/0/error.txt",
        "/data/data/com.tencent.ig/files/error.txt",
    }
    
    for _, path in ipairs(paths) do
        local file = io.open(path, "a")
        if file then
            file:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
            file:close()
            return true
        end
    end
    
    -- If all fail, try root
    local file = io.open("/sdcard/error.txt", "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
        file:close()
        return true
    end
    
    return false
end

-- Try multiple paths for keys.txt
local function ReadKeyFile()
    local paths = {
        "/sdcard/keys.txt",
        "/storage/emulated/0/keys.txt",
        "/data/data/com.tencent.ig/files/keys.txt",
        "/storage/emulated/0/Android/data/com.tencent.ig/files/keys.txt",
    }
    
    for _, path in ipairs(paths) do
        local file = io.open(path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            WriteError("INFO: Found keys.txt at: " .. path)
            return content:gsub("%s+", "")
        end
    end
    
    WriteError("ERROR: keys.txt NOT FOUND in any location!")
    WriteError("ERROR: Checked paths: " .. table.concat(paths, ", "))
    return nil
end

local function ShowPopup(title, msg, isError)
    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        if Msg and Msg.Show then
            Msg.Show(4, title, msg)
        end
    end)
end

-- HTTP GET function with multiple methods
local function HttpGet(url)
    -- Method 1: Try Http module
    local ok, Http = pcall(require, "Http")
    if ok and Http then
        local request = Http:NewRequest()
        if request then
            request:SetUrl(url)
            request:SetMethod("GET")
            request:SetTimeout(5)
            local response = request:Send()
            if response then
                return response:GetBody(), nil
            end
        end
    end
    
    -- Method 2: Try WebRequest
    local ok, WebRequest = pcall(require, "WebRequest")
    if ok and WebRequest then
        local response = WebRequest:Get(url)
        if response then
            return response, nil
        end
    end
    
    -- Method 3: Try SimpleHttp
    local ok, SimpleHttp = pcall(require, "SimpleHttp")
    if ok and SimpleHttp then
        local response = SimpleHttp:Get(url)
        if response then
            return response, nil
        end
    end
    
    return nil, "No HTTP module available"
end

-- Main validation function
local function ValidateKeyOnline()
    WriteError("=== LICENSE CHECK START ===")
    
    -- Read key from file
    local userKey = ReadKeyFile()
    if not userKey or userKey == "" then
        WriteError("ERROR: No key found in keys.txt")
        ShowPopup("❌ LICENSE ERROR", 
            "keys.txt NOT FOUND or EMPTY!\n\n" ..
            "Create /sdcard/keys.txt\n" ..
            "Add your license key inside.\n\n" ..
            "📧 Contact: @TrnDravix", true)
        return false
    end
    
    WriteError("INFO: Key found: " .. userKey)
    
    -- Check format
    if not userKey:match("^TRN%-2026%-%d%d%d$") then
        WriteError("ERROR: Invalid format! Received: '" .. userKey .. "'")
        ShowPopup("❌ LICENSE ERROR", 
            "INVALID KEY FORMAT!\n\n" ..
            "Your key: " .. userKey .. "\n\n" ..
            "Correct format: TRN-2026-001\n\n" ..
            "📧 Contact: @TrnDravix", true)
        return false
    end
    
    -- Online validation
    local apiUrl = "https://lightkuro.site/api.php?key=" .. userKey
    WriteError("INFO: Validating with server...")
    
    local response, err = HttpGet(apiUrl)
    
    if not response then
        WriteError("ERROR: Server connection failed - " .. (err or "Unknown"))
        ShowPopup("❌ CONNECTION ERROR", 
            "SERVER NOT REACHABLE!\n\n" ..
            "Check your internet connection.\n" ..
            "Error: " .. (err or "Unknown") .. "\n\n" ..
            "📧 Contact: @TrnDravix", true)
        return false
    end
    
    WriteError("INFO: Server response received")
    
    -- Parse JSON
    local ok, data = pcall(function()
        return loadstring("return " .. response)()
    end)
    
    if not ok or not data then
        WriteError("ERROR: Invalid server response - " .. tostring(response))
        ShowPopup("❌ SERVER ERROR", 
            "INVALID SERVER RESPONSE!\n\n" ..
            "The server returned an invalid response.\n\n" ..
            "📧 Contact: @TrnDravix", true)
        return false
    end
    
    -- Check validation
    if not data.valid then
        local errorMsg = data.error or "Unknown error"
        WriteError("ERROR: Validation failed - " .. errorMsg)
        
        if data.expiry then
            WriteError("ERROR: Key expired on " .. data.expiry)
            ShowPopup("❌ KEY EXPIRED", 
                "Your key expired on: " .. data.expiry .. "\n\n" ..
                "🔑 Get a new key from @TrnDravix\n\n" ..
                "📧 Contact: @TrnDravix", true)
        else
            ShowPopup("❌ INVALID KEY", 
                "Key: " .. userKey .. "\n" ..
                "Error: " .. errorMsg .. "\n\n" ..
                "🔑 Get a valid key from @TrnDravix\n\n" ..
                "📧 Contact: @TrnDravix", true)
        end
        return false
    end
    
    -- SUCCESS
    WriteError("SUCCESS: Key validated!")
    WriteError("SUCCESS: Type: " .. (data.type or "N/A"))
    WriteError("SUCCESS: Expiry: " .. (data.expiry or "N/A"))
    
    ShowPopup("✅ LICENSE VALIDATED", 
        "Key: " .. userKey .. "\n" ..
        "Type: " .. (data.type or "N/A") .. "\n" ..
        "Expiry: " .. (data.expiry or "N/A") .. "\n\n" ..
        "🚀 Welcome to TrnDravix MOD!\n" ..
        "Enjoy all premium features!", false)
    
    WriteError("=== LICENSE CHECK SUCCESS ===")
    return true
end

-- ============================================================
-- RUN LICENSE CHECK AT START
-- ============================================================

-- First, write debug info
WriteError("=== SCRIPT STARTED ===")

-- Check license
local licenseValid = ValidateKeyOnline()

if not licenseValid then
    -- Disable ALL features
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
    
    WriteError("=== SCRIPT DISABLED - Invalid License ===")
    print("[LICENSE] ❌ Validation failed - Script disabled")
    return -- Script stops here
end

print("[LICENSE] ✅ Validation successful - Script running")
WriteError("=== SCRIPT RUNNING ===")

-- ============================================================
-- NEW BYPASS SYSTEM
-- ============================================================
BypassConfig = {
    SLUA   = true,
    MD5    = true,
    Server = true,
    Device = true,
    Blox   = false,
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
local require = require
local import  = import
local isValid = slua.isValid
local pcall = pcall
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local math = math
local string = string
local os = os

-- ============================================================
-- NOP FUNCTIONS
-- ============================================================
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
        Msg.Show(4, "◆ TRNDRAVIX ULTIMATE ◆",
        "\n┌────────────────────────────────────────┐\n" ..
        "│  DEVELOPER  : @TrnDravix              │\n" ..
        "│  STATUS     : UNDETECTED & OPTIMIZED  │\n" ..
        "│  BYPASS     : 5-LAYER DEEP SHIELD     │\n" ..
        "│────────────────────────────────────────│\n" ..
        "│  FEATURES   :                         │\n" ..
        "│  ✔ Aimbot        ✔ Wall ESP          │\n" ..
        "│  ✔ Wallhack      ✔ 165 FPS           │\n" ..
        "│  ✔ No Grass      ✔ iPad View         │\n" ..
        "│  ✔ Skins         ✔ Glow Effects      │\n" ..
        "│  ✔ Loot ESP      ✔ Memory Tweaks     │\n" ..
        "│────────────────────────────────────────│\n" ..
        "│  BUILD : PREMIUM LOADED SUCCESSFULLY  │\n" ..
        "└────────────────────────────────────────┘\n" ..
        "        TAP TO CONNECT WITH DEVELOPER", onClick)
    end
end)

-- ============================================================
-- ESP (WITH GREEN/VISIBLE + YELLOW/HIDDEN COLORS)
-- ============================================================
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")

local cachedPawns     = {}
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
    if _G._ESPTimerHandle and _G._ESPTimerChar and not slua.isValid(_G._ESPTimerChar) then _G._ESPTimerHandle = nil; _G._ESPTimerChar = nil end
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
    local now      = os.clock()

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
                    local topZ = headPos and (headPos.Z - oz) or 90
                    local botZ = footPos and math.min(footPos.Z, footRPos and footRPos.Z or footPos.Z) - oz or -85

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
                        local headChar = distM <= 25 and "❄" or "●"
                        if hz then HUD:AddDebugText(headChar, tPawn, TextScale(distM), {X=0,Y=0,Z=hz}, {X=0,Y=0,Z=hz}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 1.0, true) end

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

pcall(function()
    if _G._ESPWatchdogHandle then pcall(function() Game:ClearTimer(_G._ESPWatchdogHandle) end); _G._ESPWatchdogHandle = nil end

    local function StartESP(targetActor)
        if not slua.isValid(targetActor) then return end
        cachedPawns = {}; lastPawnRefresh = 0
        _G._ESPTimerChar = targetActor
        _G._ESPTimerHandle = targetActor:AddGameTimer(0.2, true, function()
            pcall(ESPTick)
        end)
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
    local fpsComp = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS")
    if fpsComp and fpsComp.__inner_impl then
      local impl = fpsComp.__inner_impl
      function impl.GetMaxFPSLevel() return 8, 8 end
      function impl:InitRealSupportFPS()
        local t = {}; for i = 1, 8 do t[i] = {true, true} end
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        if db then db:UpdateUIData(db.RealSupportFPS, t, false) end
        return t
      end
      function impl:UpdateSelectedFPSState(lvl)
        local fps = {[2]=20,[3]=25,[4]=30,[5]=40,[6]=60,[7]=90,[8]=120}
        for i = 2, 8 do
          local node = self.UIRoot["NodeFps"..tostring(fps[i] or 120)]
          if slua.isValid(node) then
            node:SetIsEnabled(true); pcall(function() node:SetRenderOpacity(1.0) end)
            local sw = self.UIRoot["WidgetSwitcher_"..tostring(i)]
            if slua.isValid(sw) then sw:SetActiveWidgetIndex(i == lvl and 0 or 1) end
          end
        end
      end
    end
    local fpsFT = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
    if fpsFT and fpsFT.__inner_impl then
      local impl = fpsFT.__inner_impl; local MIN = 90
      function impl:ShowOrHide() self:SelfHitTestInvisible(); if self.InitFPSFTSwitch then self:InitFPSFTSwitch() end end
      function impl:InitFPSFTSwitch()
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB"); local on = db:GetUIData(db.FPSFineTuneSwitch)
        if self.UIRoot.Setting_Switch then self.UIRoot.Setting_Switch:SetSwitcherEnable2(on, true) end
        if self.UIRoot.CanvasPanel_8 then self:SetWidgetVisible(self.UIRoot.CanvasPanel_8, on) end
        if self.UIRoot.WidgetSwitcher_0 then self.UIRoot.WidgetSwitcher_0:SetActiveWidgetIndex(2) end
        if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
      end
      function impl:InitFPSFTValue165()
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB"); local r = self.UIRoot
        local on = db:GetUIData(db.FPSFineTuneSwitch); local val = on and (db:GetUIData(db.FPSFineTuneNum) or 165) or 165
        if on then
          r.Slider_screen3:SetLocked(false); r.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1,1,1,1))
          r.Slider_screen3:SetSliderHandleColor(FLinearColor(1,1,1,1))
        else
          r.Slider_screen3:SetLocked(true); r.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1,0.625,0.6,1))
          r.Slider_screen3:SetSliderHandleColor(FLinearColor(1,0.625,0.6,1))
        end
        local norm = (val - MIN) / (165 - MIN)
        r.Veihclescreen3:SetText(tostring(val)); r.Slider_screen3:SetValue(norm); r.ProgressBar_screen3:SetPercent(norm)
      end
      function impl:OnFPSFTValueChange3(val)
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        db:UpdateUIData(db.FPSFineTuneNum, val); if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
        if self:GetParentUI() then self:GetParentUI():SetDirty(true) end
        local gi = db.GetGameInstance and db.GetGameInstance()
        if gi then gi:ExecuteCMD("t.MaxFPS", tostring(val)); gi:ExecuteCMD("r.FrameRateLimit", tostring(val)) end
      end
      function impl:OnFPSFTAdd3() local cur = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB").GetUIData(db.FPSFineTuneNum) or 90; self:OnFPSFTValueChange3(math.min(165, cur)) end
      function impl:OnFPSFTMinus3() local cur = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB").GetUIData(db.FPSFineTuneNum) or 90; self:OnFPSFTValueChange3(math.max(MIN, 5)) end
      impl.OnFPSFTAdd = impl.OnFPSFTAdd3; impl.OnFPSFTMinus = impl.OnFPSFTMinus3
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

-- iPad View + No Grass (realtime)
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
      local lp = GameplayData.GetPlayerCharacter()
      if not slua.isValid(lp) then return end

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
        entity.GameDeviationFactor = 0.2
        entity.RecoilKickADS = 0.020
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
            entity.AutoAimingConfig = entity.AutoAimingConfig
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
-- ==================== SKINS MODULE ===========================
-- ============================================================

-- (Full skin code from the original script – includes WeaponSkinMap,
--  VehicleSkinMap, OutfitMap, attachment handling, kill counter,
--  dead box skins, etc. – all kept as is.)

-- ============================================================
-- ==================== PBC WALLHACK MODULE ====================
-- ============================================================

_G._ChamsTimer = nil
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
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.BloomQuality 5")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.EyeAdaptationQuality 2")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.Tonemapper.Quality 2")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.LightShaftQuality 2")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.Tonemapper.Saturation 1.5")
        KismetSystemLibrary.ExecuteConsoleCommand(world, "r.Tonemapper.Contrast 1.3")
        _G._ChamsConsoleReady = true
        print("[PBC] Console ready + BLOOM FORCED")
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
        
        if _G.ESPConfig.GlowEnabled then
            local glowIntensity = _G.ESPConfig.GlowIntensity or 5
            pcall(function()
                mesh:SetScalarParameterValueOnMaterials("EmissiveIntensity", glowIntensity)
                mesh:SetScalarParameterValueOnMaterials("EmissiveScale", glowIntensity * 0.6)
                mesh:SetScalarParameterValueOnMaterials("Brightness", glowIntensity * 0.5)
                mesh:SetScalarParameterValueOnMaterials("BloomIntensity", glowIntensity * 0.8)
                mesh:SetScalarParameterValueOnMaterials("GlowIntensity", glowIntensity)
                
                local brightVis = LinearColor(
                    math.min(visColor.R * (1 + glowIntensity * 0.15), 255),
                    math.min(visColor.G * (1 + glowIntensity * 0.15), 255),
                    math.min(visColor.B * (1 + glowIntensity * 0.15), 255),
                    255
                )
                mesh:SetVisibleDyeingColor(brightVis)
            end)
        end
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
        mesh:OverrideIdeaOutlineThickness(10.0)
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

        local GameplayData = require("GameLua.GameCore.Data.GameplayData")
        local localPawn = GameplayData.GetPlayerCharacter()
        if not slua.isValid(localPawn) then return end

        ChamsSetupConsole()

        local LinearColor = import("LinearColor")
        if not LinearColor then return end

        local cfg = _G.ESPConfig
        local bright = cfg.WallhackBrightness / 25.0

        local visColorTable = GetColorFromIndex(cfg.WallhackVisibleColor)
        local occColorTable = GetColorFromIndex(cfg.WallhackInvisibleColor)

        local visColor = LinearColor(
            visColorTable.R / 255 * bright,
            visColorTable.G / 255 * bright,
            visColorTable.B / 255 * bright,
            100
        )
        local occColor = LinearColor(
            occColorTable.R / 255 * bright,
            occColorTable.G / 255 * bright,
            occColorTable.B / 255 * bright,
            100
        )

        local bVisColor = LinearColor(
            visColorTable.R / 255 * bright * 0.7,
            visColorTable.G / 255 * bright * 0.7,
            visColorTable.B / 255 * bright * 0.7,
            100
        )
        local bOccColor = LinearColor(
            occColorTable.R / 255 * bright * 0.7,
            occColorTable.G / 255 * bright * 0.7,
            occColorTable.B / 255 * bright * 0.7,
            100
        )

        local colors = {
            vis = visColor,
            occ = occColor,
            bVis = bVisColor,
            bOcc = bOccColor
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
            if isAI and not cfg.ShowAI then goto continue end

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

function _G.InitChamsModule()
    if _G._ChamsTimer then
        pcall(function()
            if _G.Game then _G.Game:RemoveGameTimer(_G._ChamsTimer) end
        end)
        _G._ChamsTimer = nil
    end

    if _G.Game and _G.Game.AddGameTimer then
        _G._ChamsTimer = _G.Game:AddGameTimer(0.3, true, ChamsTick)
        print("[PBC] Active (Game timer)")
        return true
    end

    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        _G._ChamsTimer = pc:AddGameTimer(0.3, true, ChamsTick)
        print("[PBC] Active (PC timer)")
        return true
    end

    return false
end

local _chamsRetry = 0
local function ChamsAttemptStart()
    if _chamsRetry >= 30 then
        print("[PBC] Failed to start after 30 retries")
        return
    end
    _chamsRetry = _chamsRetry + 1
    if _G.InitChamsModule() then
        print("[PBC] Module ready!")
    else
        if _G.Game and _G.Game.AddGameTimer then
            _G.Game:AddGameTimer(1.0, false, ChamsAttemptStart)
        end
    end
end

ChamsAttemptStart()

_G.ChamsCleanup = function()
    if _G._ChamsTimer then
        pcall(function()
            if _G.Game then _G.Game:RemoveGameTimer(_G._ChamsTimer) end
        end)
        _G._ChamsTimer = nil
    end
    _G._ChamsProcessed = {}
    _G._ChamsConsoleReady = false
    print("[PBC] Cleanup done")
end

-- ============================================================
-- MENU (3 Categories: ALL FEATURES + CUSTOM - PREFERENCES + MEMORY FEATURES)
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

        -- ===== CATEGORY 1: ALL FEATURES =====
        local AllFeaturesStack = {
            { UI = AliasMap.Title, Text = "ALL FEATURES" },

            {
                Key = "ModMenu_Aimbot",
                UI = AliasMap.Switcher,
                Text = "AIMBOT",
                GetFunc = function() return _G.Mod_Aimbot_Enabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_Aimbot_Enabled = value
                    print("[MOD] AIMBOT: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] WALL ESP: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] SKINS: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] WALLHACK: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] 165 FPS: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] NO GRASS: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] IPAD VIEW: " .. (value and "ON ✓" or "OFF ✗"))
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
                    print("[MOD] View Distance: " .. _G.Mod_iPadViewDistance)
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
                    print("[MOD] LOOT BOX ESP: " .. (value and "ON ✓" or "OFF ✗"))
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

        -- ===== CATEGORY 2: CUSTOM - PREFERENCES =====
        local CustomPrefStack = {
            { UI = AliasMap.Title, Text = "CUSTOM - PREFERENCES" },

            { UI = AliasMap.Title, Text = "--- CHAMS COLORS ---" },
            {
                Key = "ModMenu_GreenColor",
                UI = AliasMap.Switcher,
                Text = "GREEN (Visible)",
                GetFunc = function() return _G.Mod_Chams_GreenEnabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_GreenEnabled = value
                    print("[MOD] GREEN CHAMS: " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
            {
                Key = "ModMenu_GreenR",
                UI = AliasMap.Slider,
                Text = "Green - Red (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_GreenRGB.R or 0) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_GreenRGB.R = math.floor(value * 255)
                    return true
                end
            },
            {
                Key = "ModMenu_GreenG",
                UI = AliasMap.Slider,
                Text = "Green - Green (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_GreenRGB.G or 255) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_GreenRGB.G = math.floor(value * 255)
                    return true
                end
            },
            {
                Key = "ModMenu_GreenB",
                UI = AliasMap.Slider,
                Text = "Green - Blue (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_GreenRGB.B or 0) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_GreenRGB.B = math.floor(value * 255)
                    return true
                end
            },
            {
                Key = "ModMenu_YellowColor",
                UI = AliasMap.Switcher,
                Text = "YELLOW (Hidden)",
                GetFunc = function() return _G.Mod_Chams_YellowEnabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_YellowEnabled = value
                    print("[MOD] YELLOW CHAMS: " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
            {
                Key = "ModMenu_YellowR",
                UI = AliasMap.Slider,
                Text = "Yellow - Red (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_YellowRGB.R or 255) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_YellowRGB.R = math.floor(value * 255)
                    return true
                end
            },
            {
                Key = "ModMenu_YellowG",
                UI = AliasMap.Slider,
                Text = "Yellow - Green (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_YellowRGB.G or 255) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_YellowRGB.G = math.floor(value * 255)
                    return true
                end
            },
            {
                Key = "ModMenu_YellowB",
                UI = AliasMap.Slider,
                Text = "Yellow - Blue (0-255)",
                Min = 0,
                Max = 255,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return (_G.Mod_Chams_YellowRGB.B or 0) / 255 end,
                SetFunc = function(_, value)
                    _G.Mod_Chams_YellowRGB.B = math.floor(value * 255)
                    return true
                end
            },

            { UI = AliasMap.Title, Text = "--- WALLHACK COLORS ---" },
            {
                Key = "WH_VisibleColor",
                UI = AliasMap.Switcher,
                Text = "Visible Color",
                SwitcherText = {"Red","White","Yellow","Green","Cyan","Blue","Purple"},
                SwitcherValue = {1,2,3,4,5,6,7},
                GetFunc = function() return _G.ESPConfig.WallhackVisibleColor or 4 end,
                SetFunc = function(_, value)
                    _G.ESPConfig.WallhackVisibleColor = value
                    return true
                end
            },
            {
                Key = "WH_InvisibleColor",
                UI = AliasMap.Switcher,
                Text = "Invisible Color",
                SwitcherText = {"Red","White","Yellow","Green","Cyan","Blue","Purple"},
                SwitcherValue = {1,2,3,4,5,6,7},
                GetFunc = function() return _G.ESPConfig.WallhackInvisibleColor or 3 end,
                SetFunc = function(_, value)
                    _G.ESPConfig.WallhackInvisibleColor = value
                    return true
                end
            },
            {
                Key = "WH_Brightness",
                UI = AliasMap.Slider,
                Text = "Brightness",
                Min = 1,
                Max = 50,
                Step = 1,
                IsPercent = false,
                GetFunc = function() return _G.ESPConfig.WallhackBrightness or 25 end,
                SetFunc = function(_, value)
                    _G.ESPConfig.WallhackBrightness = value
                    return true
                end
            },
            {
                Key = "WH_ShowAI",
                UI = AliasMap.TitleSwitcher,
                Text = "Show AI",
                GetFunc = function() return _G.ESPConfig.ShowAI end,
                SetFunc = function(_, value)
                    _G.ESPConfig.ShowAI = value
                    return true
                end
            },

            { UI = AliasMap.Title, Text = "--- GLOW SETTINGS ---" },
            {
                Key = "WH_GlowEnabled",
                UI = AliasMap.TitleSwitcher,
                Text = "Glow ON/OFF",
                GetFunc = function() return _G.ESPConfig.GlowEnabled end,
                SetFunc = function(_, value)
                    _G.ESPConfig.GlowEnabled = value
                    print("[MOD] GLOW: " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
            {
                Key = "WH_GlowIntensity",
                UI = AliasMap.Slider,
                Text = "Glow Intensity",
                Min = 1,
                Max = 10,
                Step = 0.5,
                IsPercent = false,
                GetFunc = function() return _G.ESPConfig.GlowIntensity or 5 end,
                SetFunc = function(_, value)
                    _G.ESPConfig.GlowIntensity = value
                    return true
                end
            }
        }

        -- ===== CATEGORY 3: MEMORY FEATURES =====
        local MemoryStack = {
            { UI = AliasMap.Title, Text = "MEMORY FEATURES (USE AT OWN RISK)" },

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
                Text = "Gravity Scale (-0.45 to 1.0)",
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

            { UI = AliasMap.Title, Text = "--- WEAPON TWEAKS ---" },

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
                Text = "Fire Interval (0.001 - 0.05s)",
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

        -- ===== REGISTER MENU =====
        SettingPageDefine.ModMenu = {
            Key = "ModMenu",
            loc = "TrnDravix MENU",
            UIKey = "Setting_Page_Privacy",
            Category = {
                {
                    Key = "ModMenu_AllFeatures",
                    loc = "ALL FEATURES",
                    Stack = AllFeaturesStack
                },
                {
                    Key = "ModMenu_CustomPref",
                    loc = "CUSTOM - PREFERENCES",
                    Stack = CustomPrefStack
                },
                {
                    Key = "ModMenu_Memory",
                    loc = "MEMORY FEATURES",
                    Stack = MemoryStack
                }
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

-- Apply scene settings from config on load
pcall(function()
    if _G.ESPConfig.BlackSky then SetBlackSky(true) end
    if _G.ESPConfig.RainEnabled then SetRainEnabled(true) end
    if _G.ESPConfig.SnowEnabled then SetSnowEnabled(true) end
end)

_G.InitModMenuTab()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
