-- ============================================================
-- MODDED BY TrnDravix + @TrnDravix
-- Complete MOD with Bypass V2.0 + SKINS + PBC WALLHACK + COLOR CONTROLS + GLOW
-- PANEL VALIDATION: POST via Worker (https://aged-mouse-89ad.anshulrajput4204.workers.dev/)
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

DebugLog("========== SCRIPT STARTED (POST VIA WORKER) ==========")

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
-- PANEL VALIDATION SYSTEM (POST VIA WORKER)
-- ============================================================
local BASE_PATH = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local KEY_PATH = BASE_PATH .. "keys.txt"
local ERROR_PATH = BASE_PATH .. "error.txt"
local HWID_PATH = BASE_PATH .. ".hwid"
local PANEL_URL = "https://aged-mouse-89ad.anshulrajput4204.workers.dev/"

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

local function get_hwid()
    DebugLog("Getting HWID...")
    local file = io.open(HWID_PATH, "r")
    if file then
        local hwid = file:read("*all"):gsub("%s+", "")
        file:close()
        DebugLog("HWID read: " .. hwid)
        return hwid
    end
    
    local android_id = "RAND_" .. os.time() .. "_" .. math.random(1000, 9999)
    local f = io.open(HWID_PATH, "w")
    if f then
        f:write(android_id)
        f:close()
        DebugLog("HWID created: " .. android_id)
    end
    return android_id
end

local function ShowPopup(title, msg)
    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        if Msg and Msg.Show then
            Msg.Show(4, title, msg)
        end
    end)
end

-- ============================================================
-- HTTP POST FUNCTION
-- ============================================================
local function HttpPost(url, data, contentType)
    DebugLog("HttpPost: " .. url)
    DebugLog("Data: " .. data)
    
    -- Try SimpleHttp POST
    local ok, SimpleHttp = pcall(require, "SimpleHttp")
    if ok and SimpleHttp and SimpleHttp.Post then
        DebugLog("SimpleHttp POST available")
        local response = SimpleHttp:Post(url, data, contentType or "application/x-www-form-urlencoded")
        if response then
            DebugLog("SimpleHttp POST SUCCESS, length: " .. #response)
            return response, nil
        else
            DebugLog("SimpleHttp POST returned nil")
        end
    end
    
    -- Try Http module POST
    local ok, Http = pcall(require, "Http")
    if ok and Http then
        DebugLog("Http module available")
        local request = Http:NewRequest()
        if request then
            request:SetUrl(url)
            request:SetMethod("POST")
            if contentType then
                request:SetHeader("Content-Type", contentType)
            end
            request:SetBody(data)
            request:SetTimeout(10)
            DebugLog("Sending Http POST...")
            local response = request:Send()
            if response then
                local body = response:GetBody()
                if body then
                    DebugLog("Http POST SUCCESS, length: " .. #body)
                    return body, nil
                else
                    DebugLog("Http POST response body is nil")
                end
            else
                DebugLog("Http POST returned nil")
            end
        else
            DebugLog("Could not create Http request")
        end
    end
    
    -- Try WebRequest POST
    local ok, WebRequest = pcall(require, "WebRequest")
    if ok and WebRequest and WebRequest.Post then
        DebugLog("WebRequest POST available")
        local response = WebRequest:Post(url, data, contentType or "application/x-www-form-urlencoded")
        if response then
            DebugLog("WebRequest POST SUCCESS, length: " .. #response)
            return response, nil
        end
    end
    
    DebugLog("ALL POST METHODS FAILED")
    return nil, "No HTTP POST module"
end

-- ============================================================
-- PARSE PANEL RESPONSE (JSON)
-- ============================================================
local function parsePanelResponse(response)
    DebugLog("Parsing panel response: " .. response)
    
    -- Try Lua table format first
    local data = nil
    local ok, parsed = pcall(function()
        return loadstring("return " .. response)()
    end)
    if ok and parsed then
        data = parsed
        DebugLog("Parsed as Lua table")
    end
    
    -- Try JSON
    if not data then
        local ok_json, json = pcall(require, "json")
        if ok_json and json and json.decode then
            local ok2, decoded = pcall(json.decode, response)
            if ok2 and decoded then
                data = decoded
                DebugLog("Parsed as JSON")
            end
        end
    end
    
    -- Manual pattern matching
    if not data then
        local status = response:match('"status"%s*:%s*(%w+)')
        if status then
            data = { status = (status == "true") }
            DebugLog("Manual parse: status=" .. status)
        end
    end
    
    return data
end

-- ============================================================
-- VALIDATE KEY WITH PANEL (POST VIA WORKER)
-- ============================================================
local function ValidateKeyWithPanel(userKey)
    DebugLog("Validating via worker (POST): " .. PANEL_URL)
    
    local hwid = get_hwid()
    local payload = "key=" .. userKey .. "&serial=" .. hwid
    DebugLog("Payload: " .. payload)
    
    local response, err = HttpPost(PANEL_URL, payload)
    if not response then
        DebugLog("Worker POST request failed: " .. (err or "Unknown"))
        return nil
    end
    
    DebugLog("Worker POST response: " .. response)
    return parsePanelResponse(response)
end

-- ============================================================
-- MAIN VALIDATE KEY - WITH CLEAN POPUP
-- ============================================================
local function ValidateKey()
    DebugLog("========== VALIDATE KEY START ==========")
    
    if not EnsureKeyFile() then
        ShowPopup("FILE ERROR", "Could not create keys.txt")
        return false
    end

    local userKey = ReadKeyFile()
    if not userKey or userKey == "" then
        ShowPopup("KEY MISSING", "Open " .. KEY_PATH .. "\nAdd your panel key")
        return false
    end

    DebugLog("Validating key: " .. userKey)
    
    local panelData = ValidateKeyWithPanel(userKey)
    
    if panelData and panelData.status == true then
        local data = panelData.data or {}
        local expiry = data.EXP or "N/A"
        local modname = data.modname or "DRAVIX TOOL"
        local credit = data.credit or "0"
        
        DebugLog("PANEL SUCCESS: " .. modname .. " | Expiry: " .. expiry)
        
        ShowPopup(
            "✅ KEY VERIFIED",
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "  Key     : " .. userKey .. "\n" ..
            "  Status  : ✅ ACTIVE\n" ..
            "  Tool    : " .. modname .. "\n" ..
            "  Credit  : " .. credit .. "\n" ..
            "  Expiry  : " .. expiry .. "\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "  🚀 MOD ACTIVATED SUCCESSFULLY"
        )
        return true
    else
        DebugLog("PANEL FAILED: Invalid key")
        ShowPopup(
            "❌ KEY VERIFICATION FAILED",
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "  Key     : " .. userKey .. "\n" ..
            "  Status  : ❌ INVALID\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "  Contact: @TrnDravix"
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
        "  PANEL      : ACTIVE\n" ..
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
-- REST OF YOUR SCRIPT (ESP, AIMBOT, SKINS, WALLHACK, MENU, etc.)
-- ============================================================
-- NOTE: Apni original script ka baaki ka code yahan paste kar do
-- ============================================================

DebugLog("========== SCRIPT FULLY LOADED ==========")

-- ============================================================
-- END OF SCRIPT
-- ============================================================
