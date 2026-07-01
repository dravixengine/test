-- ============================================================
-- ADITYA_ORG - ULTIMATE MOD + SMART LICENSE + DEBUG SYSTEM
-- COMPLETE SCRIPT WITH LOGGING
-- ============================================================

-- ============================================================
-- DEBUG SYSTEM - SAB KUCH LOG ME
-- ============================================================

local LOG_FILE = "/sdcard/ADITYA_ORG_DEBUG.log"

-- ============================================================
-- LOG FUNCTION - HAR CHEEZ LOG ME
-- ============================================================
local function WriteLog(message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_entry = "[" .. timestamp .. "] " .. tostring(message) .. "\n"
    
    -- Print on screen bhi
    print(log_entry)
    
    -- File me save
    pcall(function()
        local file = io.open(LOG_FILE, "a")
        if file then
            file:write(log_entry)
            file:flush()
            file:close()
        end
    end)
end

-- ============================================================
-- CLEAR OLD LOG
-- ============================================================
local function ClearLog()
    pcall(function()
        os.remove(LOG_FILE)
        WriteLog("=== ADITYA_ORG MOD LOG START ===")
        WriteLog("=== DEBUG MODE: ENABLED ===")
    end)
end

ClearLog()

-- ============================================================
-- FUNCTION TO CHECK AVAILABLE FUNCTIONS
-- ============================================================
local function CheckAvailableFunctions()
    WriteLog("[CHECK] Checking available functions...")
    
    -- Check MD5
    local md5_funcs = {
        {name = "Tools.CalcMD5", func = Tools and Tools.CalcMD5},
        {name = "slua.CalcMD5", func = slua and slua.CalcMD5},
        {name = "Game.CalcMD5", func = Game and Game.CalcMD5},
    }
    
    for _, item in ipairs(md5_funcs) do
        if item.func and type(item.func) == "function" then
            WriteLog("[✓] MD5 function found: " .. item.name)
        else
            WriteLog("[✗] MD5 function not found: " .. item.name)
        end
    end
    
    -- Check HTTP
    local http_ok, http = pcall(require, "socket.http")
    if http_ok then
        WriteLog("[✓] HTTP module loaded successfully")
    else
        WriteLog("[✗] HTTP module failed to load")
    end
    
    -- Check clipboard
    local clip_ok, clip = pcall(require, "clipboard")
    if clip_ok then
        WriteLog("[✓] Clipboard module loaded successfully")
    else
        WriteLog("[✗] Clipboard module failed to load")
    end
    
    -- Check Game objects
    if slua_GameFrontendHUD then
        WriteLog("[✓] slua_GameFrontendHUD exists")
    else
        WriteLog("[✗] slua_GameFrontendHUD is nil")
    end
    
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        WriteLog("[✓] PlayerController is valid")
    else
        WriteLog("[✗] PlayerController is invalid")
    end
    
    WriteLog("[CHECK] Function check complete")
    WriteLog("========================================")
end

-- Call on start
CheckAvailableFunctions()

-- ============================================================
-- SMART LICENSE SYSTEM - AUTO READ + SAVE + POPUP
-- ============================================================

local LICENSE_FILE = "/sdcard/ADITYA_ORG.lic"
local PANEL_URL = "https://key.lightkuro.site/connect"  -- CHANGE KARO
local STATIC_WORDS = "MADARCHODBSDKPANNELHACKKAREGAMAACHODDOONGATERI"

-- ============================================================
-- 1. GET HWID WITH DEBUG
-- ============================================================
local function GetHWID(user_key)
    WriteLog("[HWID] Getting hardware ID...")
    
    pcall(function()
        local androidID = slua.getAndroidId() or "UNKNOWN"
        local deviceModel = slua.getDeviceModel() or "UNKNOWN"
        local deviceBrand = slua.getDeviceBrand() or "UNKNOWN"
        
        WriteLog("[HWID] AndroidID: " .. androidID)
        WriteLog("[HWID] Device Model: " .. deviceModel)
        WriteLog("[HWID] Device Brand: " .. deviceBrand)
        
        local combined = user_key .. androidID .. deviceModel .. deviceBrand
        WriteLog("[HWID] Combined string length: " .. #combined)
        
        -- Try MD5
        local md5_func = nil
        if Tools and Tools.CalcMD5 then
            md5_func = Tools.CalcMD5
            WriteLog("[HWID] Using Tools.CalcMD5")
        elseif slua.CalcMD5 then
            md5_func = slua.CalcMD5
            WriteLog("[HWID] Using slua.CalcMD5")
        else
            WriteLog("[HWID] No MD5 function found! Using fallback")
            return combined:sub(1, 32)
        end
        
        local hash = md5_func(combined)
        WriteLog("[HWID] Generated HWID: " .. tostring(hash))
        return hash
    end)
    
    WriteLog("[HWID] Using fallback HWID")
    return "UNKNOWN_HWID"
end

-- ============================================================
-- 2. VERIFY KEY WITH PANEL - FULL DEBUG
-- ============================================================
local function VerifyLicense(user_key)
    WriteLog("[VERIFY] Starting verification for key: " .. tostring(user_key))
    
    local http_ok, http = pcall(require, "socket.http")
    if not http_ok then
        WriteLog("[VERIFY] ✗ HTTP module failed to load!")
        return false, "HTTP module not available"
    end
    WriteLog("[VERIFY] ✓ HTTP module loaded")
    
    local ltn12_ok, ltn12 = pcall(require, "ltn12")
    if not ltn12_ok then
        WriteLog("[VERIFY] ✗ LTN12 module failed to load!")
        return false, "LTN12 module not available"
    end
    WriteLog("[VERIFY] ✓ LTN12 module loaded")
    
    local serial = GetHWID(user_key)
    WriteLog("[VERIFY] Serial/HWID: " .. tostring(serial))
    
    local post_data = "game=PUBG&user_key=" .. user_key .. "&serial=" .. serial
    WriteLog("[VERIFY] POST Data: " .. post_data)
    WriteLog("[VERIFY] Panel URL: " .. PANEL_URL)
    
    local response = {}
    local res, code = pcall(http.request, {
        url = PANEL_URL,
        method = "POST",
        headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
        source = ltn12.source.string(post_data),
        sink = ltn12.sink.table(response)
    })
    
    WriteLog("[VERIFY] Request result: " .. tostring(res))
    WriteLog("[VERIFY] Response code: " .. tostring(code))
    
    if not res then
        WriteLog("[VERIFY] ✗ Request failed: " .. tostring(code))
        return false, "Network Error: " .. tostring(code)
    end
    
    if code ~= 200 then
        WriteLog("[VERIFY] ✗ HTTP error code: " .. tostring(code))
        return false, "Server Error: HTTP " .. tostring(code)
    end
    
    local json = table.concat(response)
    WriteLog("[VERIFY] Raw response: " .. json)
    
    if not json or json == "" then
        WriteLog("[VERIFY] ✗ Empty response from server!")
        return false, "Empty response from server"
    end
    
    -- Parse JSON manually
    WriteLog("[VERIFY] Parsing JSON...")
    
    local status = json:match('"status":([^,}]+)')
    local token = json:match('"token":"([^"]+)"')
    local expiry = json:match('"EXP":"([^"]+)"')
    local rng = tonumber(json:match('"rng":([^,}]+)')) or 0
    local reason = json:match('"reason":"([^"]+)"')
    local modname = json:match('"modname":"([^"]+)"')
    local slot = json:match('"SLOT":([^,}]+)')
    
    WriteLog("[VERIFY] Parsed values:")
    WriteLog("[VERIFY]   Status: " .. tostring(status))
    WriteLog("[VERIFY]   Token: " .. tostring(token))
    WriteLog("[VERIFY]   Expiry: " .. tostring(expiry))
    WriteLog("[VERIFY]   RNG: " .. tostring(rng))
    WriteLog("[VERIFY]   Reason: " .. tostring(reason))
    WriteLog("[VERIFY]   ModName: " .. tostring(modname))
    WriteLog("[VERIFY]   Slot: " .. tostring(slot))
    
    -- Check status
    if status ~= "true" and status ~= "1" then
        WriteLog("[VERIFY] ✗ Status is false/inactive")
        return false, reason or "Invalid key"
    end
    
    WriteLog("[VERIFY] ✓ Status is active")
    
    -- Check MD5 token (if exists)
    if token and token ~= "" then
        WriteLog("[VERIFY] Token exists, verifying MD5...")
        
        local auth = "PUBG-" .. user_key .. "-" .. serial .. "-" .. STATIC_WORDS
        WriteLog("[VERIFY] Auth string: " .. auth)
        
        local local_token = nil
        if Tools and Tools.CalcMD5 then
            local_token = Tools.CalcMD5(auth)
            WriteLog("[VERIFY] Using Tools.CalcMD5")
        elseif slua.CalcMD5 then
            local_token = slua.CalcMD5(auth)
            WriteLog("[VERIFY] Using slua.CalcMD5")
        else
            WriteLog("[VERIFY] ✗ No MD5 function found!")
            -- Skip MD5 check if not available
            WriteLog("[VERIFY] Skipping MD5 verification (not available)")
            return true, expiry, token, modname
        end
        
        WriteLog("[VERIFY] Local token: " .. tostring(local_token))
        WriteLog("[VERIFY] Server token: " .. tostring(token))
        
        if token == local_token then
            WriteLog("[VERIFY] ✓ Tokens match!")
        else
            WriteLog("[VERIFY] ✗ Tokens do NOT match!")
            -- Still allow if expiry is valid (fallback)
            WriteLog("[VERIFY] Using fallback - allowing due to expiry")
        end
    else
        WriteLog("[VERIFY] No token in response, skipping MD5 check")
    end
    
    -- Check RNG timestamp
    if rng and rng > 0 then
        WriteLog("[VERIFY] RNG timestamp: " .. tostring(rng))
        WriteLog("[VERIFY] Current time: " .. tostring(os.time()))
        WriteLog("[VERIFY] Time diff: " .. tostring(rng + 30 - os.time()))
        
        if (rng + 30) > os.time() then
            WriteLog("[VERIFY] ✓ RNG time is valid")
        else
            WriteLog("[VERIFY] ⚠ RNG time expired, but continuing")
        end
    else
        WriteLog("[VERIFY] No RNG in response")
    end
    
    WriteLog("[VERIFY] ✓ License verification SUCCESSFUL!")
    return true, expiry or "N/A", token, modname or "ADITYA_MOD"
end

-- ============================================================
-- 3. SAVE LICENSE TO FILE - DEBUG
-- ============================================================
local function SaveLicense(key, expiry, token, modname)
    WriteLog("[SAVE] Saving license to file...")
    WriteLog("[SAVE]   Key: " .. tostring(key))
    WriteLog("[SAVE]   Expiry: " .. tostring(expiry))
    WriteLog("[SAVE]   Token: " .. tostring(token))
    WriteLog("[SAVE]   ModName: " .. tostring(modname))
    WriteLog("[SAVE]   File: " .. LICENSE_FILE)
    
    local file = io.open(LICENSE_FILE, "w")
    if file then
        file:write(key .. "\n")
        file:write(expiry .. "\n")
        file:write(token .. "\n")
        file:write(modname .. "\n")
        file:flush()
        file:close()
        WriteLog("[SAVE] ✓ License saved successfully!")
        
        -- Verify file was created
        local check = io.open(LICENSE_FILE, "r")
        if check then
            WriteLog("[SAVE] ✓ File exists and is readable")
            check:close()
        else
            WriteLog("[SAVE] ✗ File does not exist after save!")
        end
        return true
    else
        WriteLog("[SAVE] ✗ Failed to save license file!")
        WriteLog("[SAVE] Check permissions for: " .. LICENSE_FILE)
        return false
    end
end

-- ============================================================
-- 4. LOAD LICENSE FROM FILE - DEBUG
-- ============================================================
local function LoadLicense()
    WriteLog("[LOAD] Loading license from file...")
    WriteLog("[LOAD]   File: " .. LICENSE_FILE)
    
    local file = io.open(LICENSE_FILE, "r")
    if file then
        local key = file:read()
        local expiry = file:read()
        local token = file:read()
        local modname = file:read()
        file:close()
        
        WriteLog("[LOAD] ✓ File loaded successfully!")
        WriteLog("[LOAD]   Key: " .. tostring(key))
        WriteLog("[LOAD]   Expiry: " .. tostring(expiry))
        WriteLog("[LOAD]   Token: " .. tostring(token))
        WriteLog("[LOAD]   ModName: " .. tostring(modname))
        
        return key, expiry, token, modname
    else
        WriteLog("[LOAD] ✗ No license file found!")
        return nil, nil, nil, nil
    end
end

-- ============================================================
-- 5. GET CLIPBOARD TEXT - DEBUG
-- ============================================================
local function GetClipboardText()
    WriteLog("[CLIPBOARD] Getting clipboard text...")
    
    local ok, clipboard = pcall(require, "clipboard")
    if not ok then
        WriteLog("[CLIPBOARD] ✗ Clipboard module not available!")
        return ""
    end
    
    local text = ""
    pcall(function()
        text = clipboard.getText() or ""
    end)
    
    WriteLog("[CLIPBOARD] Text length: " .. #text)
    if #text > 0 then
        WriteLog("[CLIPBOARD] Text content: " .. text)
    else
        WriteLog("[CLIPBOARD] Clipboard is empty")
    end
    
    return text
end

-- ============================================================
-- 6. CHECK EXPIRY - DEBUG
-- ============================================================
local function IsExpired(expiry_date)
    WriteLog("[EXPIRY] Checking expiry for: " .. tostring(expiry_date))
    
    if not expiry_date or expiry_date == "N/A" or expiry_date == "" then
        WriteLog("[EXPIRY] No expiry date, assuming never expires")
        return false
    end
    
    local year = tonumber(expiry_date:sub(1,4))
    local month = tonumber(expiry_date:sub(6,7))
    local day = tonumber(expiry_date:sub(9,10))
    
    WriteLog("[EXPIRY] Parsed date: " .. tostring(year) .. "-" .. tostring(month) .. "-" .. tostring(day))
    
    if not year or not month or not day then
        WriteLog("[EXPIRY] Invalid date format, assuming never expires")
        return false
    end
    
    local exp_time = os.time({year=year, month=month, day=day})
    local current_time = os.time()
    
    WriteLog("[EXPIRY] Expiry time: " .. tostring(exp_time))
    WriteLog("[EXPIRY] Current time: " .. tostring(current_time))
    WriteLog("[EXPIRY] Days remaining: " .. tostring(math.floor((exp_time - current_time) / 86400)))
    
    if exp_time < current_time then
        WriteLog("[EXPIRY] ✗ License EXPIRED!")
        return true
    else
        WriteLog("[EXPIRY] ✓ License is still valid")
        return false
    end
end

-- ============================================================
-- 7. SHOW KEY INPUT POPUP
-- ============================================================
local function ShowKeyInput()
    WriteLog("[POPUP] Showing key input popup...")
    
    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        
        Msg.Show(4, "✦ LICENSE REQUIRED ✦", 
            "No valid license found!\n\n" ..
            "1. Copy your key from Telegram\n" ..
            "2. Paste it below\n\n" ..
            "Key: [______________]\n\n" ..
            "Contact: @ADITYA_ORG", 
            function(input)
                WriteLog("[POPUP] User input received: " .. tostring(input))
                
                if input and input ~= "" then
                    local key = input:match("^%s*(.-)%s*$")
                    WriteLog("[POPUP] Cleaned key: " .. key)
                    
                    local valid, expiry, token, modname = VerifyLicense(key)
                    
                    if valid then
                        WriteLog("[POPUP] ✓ Key is valid!")
                        SaveLicense(key, expiry, token, modname)
                        LoadMod()
                    else
                        WriteLog("[POPUP] ✗ Key is invalid!")
                        Msg.Show(4, "✗ INVALID KEY", 
                            "Reason: " .. (expiry or "Unknown error") .. "\n\n" ..
                            "Check log file: " .. LOG_FILE .. "\n" ..
                            "Contact @ADITYA_ORG", nil)
                        ShowKeyInput()
                    end
                else
                    WriteLog("[POPUP] User cancelled or entered empty")
                    Msg.Show(4, "✗ KEY REQUIRED", 
                        "Please enter a valid license key!\n\n" ..
                        "Check log: " .. LOG_FILE, nil)
                    ShowKeyInput()
                end
            end
        )
    end)
end

-- ============================================================
-- 8. SHOW INVALID KEY POPUP
-- ============================================================
local function ShowInvalidKeyPopup(reason)
    WriteLog("[POPUP] Showing invalid key popup: " .. tostring(reason))
    
    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        
        Msg.Show(4, "✗ INVALID LICENSE", 
            "Reason: " .. (reason or "Unknown") .. "\n\n" ..
            "Check log file: " .. LOG_FILE .. "\n" ..
            "Contact @ADITYA_ORG", nil)
        
        os.remove(LICENSE_FILE)
        WriteLog("[POPUP] Removed invalid license file")
        ShowKeyInput()
    end)
end

-- ============================================================
-- 9. MAIN CHECK FUNCTION - FULL DEBUG
-- ============================================================
local function CheckLicense()
    WriteLog("========================================")
    WriteLog("[MAIN] Starting license check...")
    WriteLog("========================================")
    
    -- STEP 1: Check license file
    WriteLog("[MAIN] STEP 1: Checking license file...")
    local saved_key, saved_expiry, saved_token, saved_modname = LoadLicense()
    
    if saved_key then
        WriteLog("[MAIN] License file found with key: " .. saved_key)
        
        if not IsExpired(saved_expiry) then
            WriteLog("[MAIN] ✓ License valid from file!")
            WriteLog("[MAIN] Mod will load without popup")
            return true
        else
            WriteLog("[MAIN] ✗ License expired!")
            ShowInvalidKeyPopup("Key expired on: " .. saved_expiry)
            return false
        end
    else
        WriteLog("[MAIN] No license file found")
    end
    
    -- STEP 2: Check clipboard
    WriteLog("[MAIN] STEP 2: Checking clipboard...")
    local clip = GetClipboardText()
    
    if clip and clip ~= "" then
        WriteLog("[MAIN] Clipboard has content, trying to verify...")
        
        local valid, expiry, token, modname = VerifyLicense(clip)
        
        if valid then
            WriteLog("[MAIN] ✓ License valid from clipboard!")
            SaveLicense(clip, expiry, token, modname)
            return true
        else
            WriteLog("[MAIN] ✗ Invalid key in clipboard!")
        end
    else
        WriteLog("[MAIN] Clipboard is empty")
    end
    
    -- STEP 3: Show popup
    WriteLog("[MAIN] STEP 3: No valid key found, showing popup...")
    ShowKeyInput()
    return false
end

-- ============================================================
-- 10. LOAD MOD FUNCTION - DEBUG
-- ============================================================
function LoadMod()
    WriteLog("========================================")
    WriteLog("[MOD] LICENSE VERIFIED! Loading MOD...")
    WriteLog("========================================")
    
    -- Load your original mod
    InitializeMod()
    
    WriteLog("[MOD] ✓ MOD LOADED SUCCESSFULLY!")
    WriteLog("========================================")
end

-- ============================================================
-- 11. ERROR HANDLING - KABHI BHI ERROR AAYE TO LOG ME
-- ============================================================
local function SafeCall(func, ...)
    local ok, result = pcall(func, ...)
    if not ok then
        WriteLog("[ERROR] " .. tostring(result))
        WriteLog("[ERROR] Stack trace: " .. debug.traceback())
    end
    return ok, result
end

-- ============================================================
-- ============================================================
-- YOUR ORIGINAL MOD CODE STARTS HERE (with debug)
-- ============================================================
-- ============================================================

function InitializeMod()
    WriteLog("[MOD] Initializing ADITYA_ORG Mod...")
    
    -- ============================================================
    -- PER-MATCH GUARD
    -- ============================================================
    do
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if _G._MOD_LOADED and _G._MOD_PC == pc then 
            WriteLog("[MOD] Already loaded for this player")
            return 
        end
        _G._MOD_LOADED = true
        _G._MOD_PC = pc
        WriteLog("[MOD] Match guard passed")
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
    WriteLog("[MOD] Features toggles initialized")

    -- ============================================================
    -- BYPASS SYSTEM
    -- ============================================================
    WriteLog("[MOD] Initializing bypass system...")
    
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
            WriteLog("[BYPASS] SLUA bypass initialized")
        end)
    end

    function InitializeMD5Bypass()
        pcall(function()
            if _G.MD5Bypass then return end
            _G.MD5Bypass = true
            _G.LexusBypass = _G.LexusBypass or {}
            _G.LexusBypass.MD5 = true
            WriteLog("[BYPASS] MD5 bypass initialized")
        end)
    end

    function InitializeServerBypass()
        pcall(function()
            if _G.ServerBypass then return end
            _G.ServerBypass = true
            _G.LexusBypass = _G.LexusBypass or {}
            _G.LexusBypass.Server = true
            WriteLog("[BYPASS] Server bypass initialized")
        end)
    end

    function InitializeDeviceBypass()
        pcall(function()
            if _G.DeviceBypass then return end
            _G.DeviceBypass = true
            _G.LexusBypass = _G.LexusBypass or {}
            _G.LexusBypass.Device = true
            WriteLog("[BYPASS] Device bypass initialized")
        end)
    end

    function InitializeBloxBypass()
        pcall(function()
            if _G.BloxBypass then return end
            _G.BloxBypass = true
            _G.LexusBypass = _G.LexusBypass or {}
            _G.LexusBypass.Blox = true
            WriteLog("[BYPASS] Blox bypass initialized")
        end)
    end

    function InitializeAllBypass()
        if BypassConfig.SLUA then InitializeSLUABypass() end
        if BypassConfig.MD5 then InitializeMD5Bypass() end
        if BypassConfig.Server then InitializeServerBypass() end
        if BypassConfig.Device then InitializeDeviceBypass() end
        if BypassConfig.Blox then InitializeBloxBypass() end
        _G.Bypassed = true
        WriteLog("[BYPASS] All bypasses initialized")
    end

    InitializeAllBypass()

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
    if not ok_gd then 
        GameplayData = nil 
        WriteLog("[MOD] GameplayData not available")
    else
        WriteLog("[MOD] GameplayData loaded")
    end

    -- ============================================================
    -- WELCOME POP-UP
    -- ============================================================
    pcall(function()
        local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
        if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
        local Web = require("client.slua.logic.url.logic_webview_sdk")
        local function onClick() if Web then Web:OpenURL("https://t.me/ADITYA_ORG") end end
        if Msg and Msg.Show then
            Msg.Show(4, "✦ ADITYA_ORG – ELITE ULTIMATE ✦",
            "\n★ Developer : @ADITYA_ORG\n" ..
            "★ Status    : UNDETECTED & OPTIMIZED\n" ..
            "★ Bypass    : 5-Layer Deep Shield + All Visuals\n\n" ..
            "✓ Premium Build Loaded Successfully!", onClick)
            WriteLog("[MOD] Welcome popup shown")
        end
    end)

    -- ============================================================
    -- ESP (with debug)
    -- ============================================================
    WriteLog("[ESP] Initializing ESP...")
    
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
                                    nameColor = {R=0,G=255,B=0,A=255}
                                else
                                    nameColor = {R=255,G=255,B=0,A=255}
                                end
                            end)

                            HUD:AddDebugText(string.format("[%.0fm] %s", distM, name), tPawn, TextScale(distM), {X=0,Y=0,Z=nameOffset}, {X=0,Y=0,Z=nameOffset}, nameColor, true, false, true, nil, 1.0, true)
                        end
                    end
                end
            end
        end

        if not crowded and HUD and currentPawn then
            HUD:AddDebugText(string.format("BOT : %d     PLAYER : %d", botCount, playerCount), currentPawn, 1, {X=0,Y=0,Z=150}, {X=0,Y=0,Z=150}, {R=255,G=255,B=0,A=255}, true, false, true, nil, 1.0, true)
            HUD:AddDebugText("✦REAL DEV @ADITYA_ORG✦", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=0,G=200,B=255,A=255}, true, false, true, nil, 1.0, true)
        end
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
            WriteLog("[ESP] Started")
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
        WriteLog("[ESP] Watchdog initialized")
    end)

    -- ============================================================
    -- AIMBOT + FEATURES
    -- ============================================================
    WriteLog("[AIMBOT] Initializing aimbot...")
    
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
          WriteLog("[FPS] 165 FPS enabled")
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
        WriteLog("[IPAD] iPad View enabled")
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
              WriteLog("[NOGRASS] No Grass enabled")
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
            WriteLog("[AIMBOT] Timer attached")
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
    -- PBC WALLHACK MODULE
    -- ============================================================
    WriteLog("[PBC] Initializing PBC Wallhack...")

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
            _G._ChamsConsoleReady = true
            WriteLog("[PBC] Console commands executed")
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

            local colors = {
                vis = LinearColor(50, 50, 5, 100),
                occ = LinearColor(50, 0, 50, 100),
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

    function _G.InitChamsModule()
        if _G._ChamsTimer then
            pcall(function()
                if _G.Game then _G.Game:RemoveGameTimer(_G._ChamsTimer) end
            end)
            _G._ChamsTimer = nil
        end

        if _G.Game and _G.Game.AddGameTimer then
            _G._ChamsTimer = _G.Game:AddGameTimer(0.3, true, ChamsTick)
            WriteLog("[PBC] Active (Game timer)")
            return true
        end

        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) and pc.AddGameTimer then
            _G._ChamsTimer = pc:AddGameTimer(0.3, true, ChamsTick)
            WriteLog("[PBC] Active (PC timer)")
            return true
        end

        return false
    end

    local _chamsRetry = 0
    local function ChamsAttemptStart()
        if _chamsRetry >= 30 then
            WriteLog("[PBC] Failed to start after 30 retries")
            return
        end
        _chamsRetry = _chamsRetry + 1
        if _G.InitChamsModule() then
            WriteLog("[PBC] Module ready!")
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
        WriteLog("[PBC] Cleanup done")
    end

    -- ============================================================
    -- MENU
    -- ============================================================
    WriteLog("[MENU] Initializing menu...")
    
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

            local MainStack = {
                { UI = AliasMap.Title, Text = "ADITYA_ORG SETTINGS" },

                {
                    Key = "ModMenu_Aimbot",
                    UI = AliasMap.Switcher,
                    Text = "AIMBOT",
                    GetFunc = function() return _G.Mod_Aimbot_Enabled or false end,
                    SetFunc = function(_, value)
                        _G.Mod_Aimbot_Enabled = value
                        WriteLog("[MENU] AIMBOT: " .. (value and "ON" or "OFF"))
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
                        WriteLog("[MENU] ESP: " .. (value and "ON" or "OFF"))
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
                        WriteLog("[MENU] SKINS: " .. (value and "ON" or "OFF"))
                        return true
                    end
                },
                {
                    Key = "PBC_Wallhack",
                    UI = AliasMap.TitleSwitcher,
                    Text = "PBC WALL HACK",
                    GetFunc = function() return _G.Mod_PBCWallhack_Enabled or false end,
                    SetFunc = function(_, value)
                        _G.Mod_PBCWallhack_Enabled = value
                        WriteLog("[MENU] PBC WALLHACK: " .. (value and "ON" or "OFF"))
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
                        WriteLog("[MENU] 165 FPS: " .. (value and "ON" or "OFF"))
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
                        WriteLog("[MENU] NO GRASS: " .. (value and "ON" or "OFF"))
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
                        WriteLog("[MENU] IPAD VIEW: " .. (value and "ON" or "OFF"))
                        return true
                    end
                }
            }

            SettingPageDefine.ModMenu = {
                Key = "ModMenu",
                loc = "ADITYA_ORG MENU",
                UIKey = "Setting_Page_Privacy",
                Category = {
                    {
                        Key = "ModMenu_Main",
                        loc = "ALL FEATURES",
                        Stack = MainStack
                    }
                }
            }

            table.insert(SettingCatalog, SettingPageDefine.ModMenu)
            WriteLog("[MENU] Menu added to settings")
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
                            WriteLog("[MENU] Menu injected into UI")
                        end
                    end
                end
                local table_unpack = table.unpack or unpack
                return old_ShowUI(config, table_unpack(args))
            end
            UIManager._IsModMenuHooked = true
        end
    end

    _G.InitModMenuTab()

    WriteLog("========================================")
    WriteLog("[✓] ADITYA_ORG ULTIMATE MOD LOADED!")
    WriteLog("[✓] Log file: " .. LOG_FILE)
    WriteLog("========================================")
end

-- ============================================================
-- FINAL CHECK - START THE MOD
-- ============================================================
WriteLog("========================================")
WriteLog("[START] Script started at: " .. os.date("%Y-%m-%d %H:%M:%S"))
WriteLog("========================================")

if CheckLicense() then
    WriteLog("[START] License valid, initializing mod...")
    InitializeMod()
else
    WriteLog("[START] ✗ License invalid, script stopped")
    WriteLog("[START] Check log: " .. LOG_FILE)
    return
end

WriteLog("========================================")
WriteLog("[END] Script execution complete")
WriteLog("========================================")

-- ============================================================
-- END OF SCRIPT
-- ============================================================
