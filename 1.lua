-- ============================================================
-- MODDED BY TrnDravix + @TrnDravix
-- Complete MOD with 11-LAYER BYPASS:
-- 1. HiggsBosonComponent (Main Anti-Cheat)
-- 2. ClientHawkEyePatrolSubsystem (HawkEye)
-- 3. ClientBanLogic (Voice Ban)
-- 4. RealTimeBan (Real-time Ban)
-- 5. Gokuba (Security Module)
-- 6. RacingAntiCheatLogic (Racing Anti-Cheat)
-- 7. ClientReportPlayerSubsystem (Player Reports)
-- 8. DSReportPlayerSubsystem (DS Reports)
-- 9. tlog_report_utils (Telemetry)
-- 10. ToolReportUtil (Report Utils)
-- 11. ClientEntry (TSS, NetUtil, UnrealNet)
-- Features: Aimbot, ESP, Wallhack, 165 FPS, No Grass, iPad View
-- ============================================================

-- ============================================================
-- PER-MATCH GUARD
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
if _G.Mod_Wallhack_Enabled == nil then _G.Mod_Wallhack_Enabled = false end
if _G.Mod_FPS165_Enabled == nil then _G.Mod_FPS165_Enabled = true end
if _G.Mod_NoGrass_Enabled == nil then _G.Mod_NoGrass_Enabled = false end
if _G.Mod_iPadView_Enabled == nil then _G.Mod_iPadView_Enabled = false end
if _G.Mod_iPadViewDistance == nil then _G.Mod_iPadViewDistance = 90 end

-- ============================================================
-- ESP CONFIG
-- ============================================================
_G.ESPConfig = _G.ESPConfig or {
    Wallhack = false,
    WallhackVisibleColor = 4,
    WallhackInvisibleColor = 3,
    WallhackBrightness = 25,
    WallhackGlow = 3.0,
    ShowAI = true,
}
_G.Mod_Wallhack_Enabled = _G.ESPConfig.Wallhack

if _G.Mod_Chams_GreenEnabled == nil then _G.Mod_Chams_GreenEnabled = false end
if _G.Mod_Chams_YellowEnabled == nil then _G.Mod_Chams_YellowEnabled = false end
if _G.Mod_Chams_GreenRGB == nil then _G.Mod_Chams_GreenRGB = {R=0, G=255, B=0, A=255} end
if _G.Mod_Chams_YellowRGB == nil then _G.Mod_Chams_YellowRGB = {R=255, G=255, B=0, A=255} end

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
-- ==================== 11-LAYER BYPASS ENGINE ====================
-- ============================================================

-- ============================================================
-- 1. CLIENTENTRY.LUA BYPASS
-- ============================================================
local function ClientEntryBypass()
    pcall(function()
        if _G.Tss then
            _G.Tss.SendSkdData = function() return end
            _G.Tss.OnRecvData = function() return end
        end
        if _G.TssManager then
            _G.TssManager.SendSkdData = function() return end
            _G.TssManager.OnRecvData = function() return end
        end
        if NetUtil then
            NetUtil.SendTss = function() return end
            NetUtil.OnTssRsp = function() return end
            NetUtil.GEMReportSubEvent = function() return end
            NetUtil.ShowSDKErrorNotice = function() return end
            NetUtil.OnDSServerConnectionErrorNotify = function() return end
            NetUtil.check_dh_packet_key = function() return end
            NetUtil.OnNetworkEvent = function(eventID, eventParam, eventParam2)
                if eventParam == "CheatDetected" then return end
                if eventParam == "IdipBan" then return end
            end
            NetUtil.OnConnected = function(isConnected, nReason)
                if not isConnected then return end
            end
            NetUtil.OnStateChange = function(state)
                if state == 4 then return end
            end
            NetUtil.OnDisconnected = function() return end
            NetUtil.CheckTime = function() return end
            NetUtil.StartCheckDSActive = function() return end
            NetUtil.StopCheckDSActive = function() return end
            NetUtil.StartCheckEnterBattle = function() return end
            NetUtil.StopCheckEnterBattle = function() return end
            NetUtil.tryConnect = function() return end
            NetUtil.ShowConnectionMsgBox = function() return end
            NetUtil.LogOut = function() return end
            NetUtil.LogoutNoRefresh = function() return end
            NetUtil.ClearAutoReconnectParam = function() return end
            NetUtil.ClearAutoReconnectTimer = function() return end
            NetUtil.GetAutoReconnectParam = function() return { times = 0 } end
        end
        if UnrealNet then
            UnrealNet.HandleNetworkExceptionReport = function() return end
            UnrealNet.HandleNetworkException = function() return end
            UnrealNet.HandleNetworkConnectionClosed = function() return end
            UnrealNet.HandleSpectateException = function() return end
            UnrealNet.HandleBattleExceptionReport = function() return end
            UnrealNet.OnNetRepSerializeError = function() return end
            UnrealNet.FilterNetworkException = function(ExceptionType, ErrorMessage)
                if ErrorMessage and type(ErrorMessage) == "string" then
                    local em = ErrorMessage:lower()
                    if em:find("cheat") or em:find("ban") or em:find("security") or
                       em:find("integrity") or em:find("violation") or em:find("hack") or
                       em:find("flag") or em:find("detect") or em:find("verify") then
                        return false
                    end
                end
                return false
            end
            UnrealNet.FailureReceivedReason = UnrealNet.FailureReceivedReason or {}
            UnrealNet.FailureReceivedReason.CheatDetected = "BYPASSED"
            UnrealNet.HandleNetworkEvent = function(EventType, EventMessage)
                if EventType == "NetworkEstablished" or EventType == "NetworkRecovered" then
                else
                    return
                end
            end
            UnrealNet.RepListMismatchDetectTrigger = function() return end
            UnrealNet.RetrunToLobbyFromDisconnect = function() return end
            UnrealNet.NetworkExceptionAddEnterBattleStage = function() return "" end
            UnrealNet.IsNeedShowMsgBox = function() return false end
        end
        if Client then
            Client.SetTssNetworkStatus = function() return end
            Client.GEMReportEnterLobbyEvent = function() return end
            Client.TPerforPlatDisconnectReport = function() return end
            Client.IsConnected = function(NetInterface) return true end
            Client.ConnectToURL = function() return end
            Client.Disconnect = function() return end
            Client.ReturnToLobby = function() return end
            Client.GetUnrealNetworkStatus = function() return "Online" end
            Client.MD5LuaString = function(str) return "BYPASSED_MD5" end
            Client.GetDSVersion = function() return "999.999.999" end
            Client.IsInReplayState = function() return false end
        end
        if NetManager then
            NetManager.ProcConnected = function() return end
            NetManager.bConnected = true
            NetManager.ProcRespondMsg = function(msg, ...) return end
            NetManager.isLogMsgAfterLogin = false
            NetManager.logMsgMap = {}
        end
        if _G.Net then
            _G.Net.SendPacket = function(LuaStateWrapper, NetInterface, msgName, ...)
                local blockedPackets = {
                    "report_", "Report", "tlog", "Tlog", "TLog",
                    "exception", "Exception", "ban", "Ban",
                    "cheat", "Cheat", "security", "Security",
                    "verify", "Verify", "check", "Check",
                    "detect", "Detect", "flag", "Flag"
                }
                if msgName and type(msgName) == "string" then
                    for _, bp in ipairs(blockedPackets) do
                        if msgName:find(bp) then
                            return nil
                        end
                    end
                end
                return true
            end
        end
        if EventSystem then
            local oldPost = EventSystem.postEvent
            EventSystem.postEvent = function(eventType, eventID, ...)
                if eventID and type(eventID) == "string" then
                    local blocked = {"SECURITY", "CHEAT", "BAN", "REPORT", "FLAG"}
                    for _, be in ipairs(blocked) do
                        if eventID:find(be) then
                            return
                        end
                    end
                end
                if oldPost then oldPost(eventType, eventID, ...) end
            end
        end
        local logFuncs = {"log", "log_warning", "log_error", "log_shipping_client", "log_format", "log_tree"}
        for _, funcName in ipairs(logFuncs) do
            if _G[funcName] then
                _G[funcName] = function(...)
                    local args = {...}
                    for _, arg in ipairs(args) do
                        if type(arg) == "string" and (
                            arg:find("cheat") or arg:find("security") or
                            arg:find("ban") or arg:find("detect") or
                            arg:find("verify") or arg:find("integrity")
                        ) then
                            return
                        end
                    end
                end
            end
        end
        if LogUtil then
            LogUtil.SetForceLog = function() return end
            LogUtil.SetLogTreeEnable = function() return end
            LogUtil.SetWriteLog = function() return end
        end
        if sandbox then
            sandbox.LogError = function(...) return end
            sandbox.LogWarning = function(...) return end
        end
    end)
    print("[BYPASS] ✅ ClientEntry bypassed!")
end

-- ============================================================
-- 2. HIGGSBOSONCOMPONENT.LUA BYPASS
-- ============================================================
pcall(function()
    if CHiggsBosonComponent then
        CHiggsBosonComponent.ReceiveBeginPlay = function(self) return end
        CHiggsBosonComponent.StaticShowSecurityAlertInDev = function(uPlayerController, sMessage, bIsClientShowWindow, bSkipServer) return end
        CHiggsBosonComponent.ShowABCD = function(self, sMessage, bIsClientShowWindow) return end
        CHiggsBosonComponent._ClientShowSecurityAlertWindow = function(sMessage) return end
        CHiggsBosonComponent._ReportChatRobot = function(sMessage, uHiggsBosonComponent) return end
        CHiggsBosonComponent.SendAntiDataFlow = function(self) return end
        CHiggsBosonComponent.SendHitFireBtnFlow = function(self) return end
        CHiggsBosonComponent.OnBattleResult = function(self) return end
        CHiggsBosonComponent.SendHisarData = function() return end
        CHiggsBosonComponent.RPC_Client_ShowSecurityAlertWindow = function(self, sMessage) return end
        CHiggsBosonComponent.RPC_Server_TellServerName = function(self, sServerName) return end
        CHiggsBosonComponent.RecordStrategyTimestampInReplay = function(nStrategyTypeInReplay, nValue, uController, nTimeInSecondsOffSet) return end
        CHiggsBosonComponent.SkipAlertServer = function(self) return end
        CHiggsBosonComponent.SetClientAlertWindowEnabled = function(bIsEnabled) return end
        CHiggsBosonComponent.IsCharacterOwnerWerewolf = function(self) return false end
        CHiggsBosonComponent.IsCharacterOwnerButcher = function(self) return false end
        CHiggsBosonComponent._ProcessReportChatRobotQueue = function() return end
        CHiggsBosonComponent.bSkipAlertServer = true
        bIsSkipAlertServer = true
        bSkipUploadNoschat = true
        _nReportNosChatTimerID = nil
        _nReportNosChatMessageID = 0
        _tReportNosChatQueue = {}
        LastTimeHandleAlert = -1
        print("[BYPASS] ✅ HiggsBosonComponent bypassed!")
    end
end)

-- ============================================================
-- 3. CLIENTHAWKEYEPATROLSUBSYSTEM.LUA BYPASS
-- ============================================================
pcall(function()
    if ClientHawkEyePatrolSubsystem then
        ClientHawkEyePatrolSubsystem._OnHawkSync = function(self, _, __, uCharacter) return end
        ClientHawkEyePatrolSubsystem._OnHawkReportSuccess = function(self, _, __, bReporter) return end
        ClientHawkEyePatrolSubsystem._OnRecvInspectorBroadcastCount = function(self, _, __, nBroadcastCount, bSendHawkReportBoardcast) return end
        ClientHawkEyePatrolSubsystem.ReportCheat = function(self, bInspectorBroadcast) return end
        ClientHawkEyePatrolSubsystem.RequestImprison = function(self, bImprison) return end
        ClientHawkEyePatrolSubsystem.SendReportTLog = function(self, tReasonCodeArray, bInspectorBroadcast) return end
        ClientHawkEyePatrolSubsystem.IsDuringHawkEyePatrol = function(self) return false end
        ClientHawkEyePatrolSubsystem._CollectBeWatchedPlayerInfo = function(self) return end
        ClientHawkEyePatrolSubsystem.HasReported = function(self) return true end
        ClientHawkEyePatrolSubsystem.GetBeWatchedPlayerInfo = function(self) return nil end
        ClientHawkEyePatrolSubsystem._OnPlayerKilledOtherPlayer = function(self, FatalDamageParameter) return end
        ClientHawkEyePatrolSubsystem._StartFrameUIRefreshTimer = function(self) return end
        ClientHawkEyePatrolSubsystem.ExitWatching = function(self) return end
        ClientHawkEyePatrolSubsystem.WantMatchNextPatrol = function(self) return end
        ClientHawkEyePatrolSubsystem._InitHawkEyePatrolSubsystem = function(self)
            self._bHasInitialized = true
            self._bHasReported = true
            return
        end
        ClientHawkEyePatrolSubsystem._StartHideUITimer = function(self) return end
        ClientHawkEyePatrolSubsystem._StartShowDistanceUITimer = function(self) return end
        ClientHawkEyePatrolSubsystem._StartCloseBattleEndedTipsTimer = function(self) return end
        ClientHawkEyePatrolSubsystem._StartBattleTimeUsageTimer = function(self) return end
        ClientHawkEyePatrolSubsystem._StartQuitVoiceRoomTimer = function(self) return end
        ClientHawkEyePatrolSubsystem._StartExitGameTimer = function(self) return end
        ClientHawkEyePatrolSubsystem._CloseExitGameTimer = function(self) return end
        ClientHawkEyePatrolSubsystem._CreateOvertimerTimerForNextPatrol = function(self) return end
        ClientHawkEyePatrolSubsystem.ClearNextPatrolOvertimeTimer = function(self, bIsOvertime) return end
        ClientHawkEyePatrolSubsystem.ReturnLobbyAndOpenH5 = function(self, bIsOvertime) return end
        ClientHawkEyePatrolSubsystem.ForceNeverCloseBattleEndedTips = function(self) return end
        ClientHawkEyePatrolSubsystem.CheckShowReportedTips = function(self) return false end
        ClientHawkEyePatrolSubsystem.TryShowReportedTips = function(self) return end
        ClientHawkEyePatrolSubsystem.ShowWatchEndedTips = function(self) return end
        ClientHawkEyePatrolSubsystem.HasShownWatchEndedTips = function(self) return true end
        ClientHawkEyePatrolSubsystem.OnShowWatchEndedTips = function(self) return end
        ClientHawkEyePatrolSubsystem.OnClickLowerLeftExitWatching = function(self) return end
        ClientHawkEyePatrolSubsystem.OnClickBottomRightOpenReportWindow = function(self) return end
        ClientHawkEyePatrolSubsystem._MarkHasReported = function(self) return end
        ClientHawkEyePatrolSubsystem.GetForbidNextPatrolRemainingTimeInSeconds = function(self) return 0 end
        ClientHawkEyePatrolSubsystem.GetUsedDailyTimeInSeconds = function(self) return 0 end
        ClientHawkEyePatrolSubsystem.GetInspectorBroadcastCount = function(self) return -1 end
        ClientHawkEyePatrolSubsystem.GetMaxInspectorBroadcastCount = function(self) return 0 end
        ClientHawkEyePatrolSubsystem.CanInspectorBroadcast = function(self) return false end
        ClientHawkEyePatrolSubsystem.IsCharacterLocationShouldDraw = function(self, uMyLocation, uCharacterLocation) return false end
        ClientHawkEyePatrolSubsystem.InitHawkEyePatrolSubsystem = function() return end
        ClientHawkEyePatrolSubsystem._PostConstruct = function(self)
            self._bHasInitialized = true
            self._bHasReported = true
            self.nInspectorBroadcastCount = -1
            return
        end
        ClientHawkEyePatrolSubsystem.OnRelease = function(self) return end
        ClientHawkEyePatrolSubsystem._bHasInitialized = true
        ClientHawkEyePatrolSubsystem._bHasReported = true
        ClientHawkEyePatrolSubsystem._bHasShownWatchEndedTips = true
        ClientHawkEyePatrolSubsystem.bShowBeReportedTips = true
        ClientHawkEyePatrolSubsystem.nInspectorBroadcastCount = -1
        print("[BYPASS] ✅ ClientHawkEyePatrolSubsystem bypassed!")
    end
end)

-- ============================================================
-- 4. CLIENTBANLOGIC.LUA BYPASS
-- ============================================================
pcall(function()
    if ClientBanLogic then
        ClientBanLogic.ReqBanInfo = function() return end
        ClientBanLogic.OnVoiceSwitchNotify = function(Message) return end
        ClientBanLogic.OnVoiceBanNotify = function(Message) return end
        ClientBanLogic.OnRealTimeVoiceBanNotify = function(Uid, Reason, Endtime) return end
        ClientBanLogic.OnVoiceBanSuccess = function(Uid, Name, Bantime) return end
        ClientBanLogic.TryOpenVoice = function()
            EventSystem:postEvent(EVENTTYPE_INGAME_BAN, EVENTID_INGAME_BAN_FORBID_VOICE, false)
            return
        end
        ClientBanLogic.IsVoiceReportEnable = function() return false end
        ClientBanLogic.OnSyncMicSuspicious = function(SuspiciousFlag) return end
        ClientBanLogic.OnSyncMicPreFilter = function(BanID) return end
        ClientBanLogic.OnSyncBanInfo = function(BanID, Flg) return end
        ClientBanLogic.OnNotifyWarningTips = function(TextID, bOffMic) return end
        ClientBanLogic.VoiceBanEndTime = 0
        ClientBanLogic.bEnableVoiceReport = false
        ClientBanLogic.SuspiciousFlag = 0
        ClientBanLogic.Reason = ""
        ClientBanLogic.IsTranslated = false
        print("[BYPASS] ✅ ClientBanLogic bypassed!")
    end
end)

-- ============================================================
-- 5. REALTIMEBAN.LUA BYPASS
-- ============================================================
pcall(function()
    if RealTimeBan then
        RealTimeBan.Init = function()
            print("[BYPASS] RealTimeBan.Init blocked!")
            return
        end
        RealTimeBan.OnPlayerWithRealTimeBan = function(_, _, uid, reason, tExitInfo) return end
        RealTimeBan.OnSyncPlayerInfo = function(_, _, uid, infoToDS) return end
        RealTimeBan.HandleEnterGameModeFightingState = function() return end
        RealTimeBan.ShowAlias = function() return end
        RealTimeBan.SetOnRankInspectorUID = function(UID, flag) return end
        RealTimeBan.IsUIDOnRankInspector = function(UID) return false end
        RealTimeBan.GetUIDInspectorRank = function(UID) return -1 end
        RealTimeBan.SetInspectorBroadcastCountUID = function(UID, Count) return end
        RealTimeBan.GetUIDInspectorBroadcastCount = function(UID) return -1 end
        RealTimeBan.GetTipsIDOffset = function() return 0 end
        RealTimeBan.GetTipsIDOffsetWithUID = function(UID) return 0 end
        RealTimeBan.GetTipsIDOffsetInspector = function(UID) return 0 end
        RealTimeBan.GMShowAlias = function(WantedLevel, WantOnRank, WantedName, WantRank) return end
        RealTimeBan.tOnRankInspectorUIDSet = {}
        RealTimeBan.tInspectorRankUIDSet = {}
        RealTimeBan.tInspectorBroadcastCountUIDSet = {}
        RealTimeBan.MaxAliasLevel = -1
        RealTimeBan.CurrentAlias = nil
        RealTimeBan.CurrentName = nil
        RealTimeBan.is_onrank_inspector = false
        RealTimeBan.inspector_rank = -1
        RealTimeBan.bHasOldAlias = false
        RealTimeBan.ShowTipsAliasConfig = {}
        RealTimeBan.DelayTime = {}
        RealTimeBan.OldShowTipsAlias = 0
        print("[BYPASS] ✅ RealTimeBan bypassed!")
    end
end)

-- ============================================================
-- 6. GOKUBA.LUA BYPASS
-- ============================================================
pcall(function()
    local Gokuba = package.loaded["GameLua.Mod.BaseMod.Client.Security.Gokuba"]
    if Gokuba then
        Gokuba.ForwardFeature = function() return {0,0,0,0,0} end
        Gokuba.InitGokubaLogic = function() return end
        if Gokuba.TimerHandle then
            local time_ticker = require("common.time_ticker")
            time_ticker.RemoveTimer(Gokuba.TimerHandle)
            Gokuba.TimerHandle = nil
        end
        for k, v in pairs(Gokuba) do
            if type(v) == "function" and (
                k:find("Init") or k:find("Start") or k:find("Check") or
                k:find("Scan") or k:find("Report") or k:find("Forward") or
                k:find("Feature") or k:find("Detect")
            ) then
                Gokuba[k] = function(...) return end
            end
        end
        print("[BYPASS] ✅ Gokuba bypassed!")
    end
    if _G.GokubaLogic then
        _G.GokubaLogic.ForwardFeature = function() return end
        _G.GokubaLogic.InitGokubaLogic = function() return end
    end
end)

-- ============================================================
-- 7. RACINGANTICHEATLOGIC.LUA BYPASS
-- ============================================================
pcall(function()
    if RacingAntiCheatLogic then
        RacingAntiCheatLogic.HandleRacingEnter = function(sourcePlayerUID, targetPlayerUID) return end
        RacingAntiCheatLogic.HandleRacingStart = function() return end
        RacingAntiCheatLogic.HandleRacingEnd = function() return end
        RacingAntiCheatLogic.StartDetectTimer = function() return end
        RacingAntiCheatLogic.StopDetectTimer = function() return end
        RacingAntiCheatLogic.DetectVehicleFloating = function(playerUID, vehicleData) return end
        RacingAntiCheatLogic.HandleFloatingCheat = function(playerUID, vehicleData) return end
        RacingAntiCheatLogic.SetIgnoreFloating = function(playerUID, bNeedIgnore) return end
        RacingAntiCheatLogic.HandlePlayerPassCheckBelt = function(playerUID, lastRecord, checkIndex) return end
        RacingAntiCheatLogic.HandleSpeedCheat = function(playerUID, checkIndex) return end
        RacingAntiCheatLogic._CreateVehicleData = function(playerUID) return {} end
        RacingAntiCheatLogic.vehicleDataMap = {}
        RacingAntiCheatLogic.detectTimer = nil
        RacingAntiCheatLogic.config = {
            FloatingDistLimit = 99999,
            FloatingTimeLimit = 99999,
            CheckPassIntervalLimit = 99999
        }
        print("[BYPASS] ✅ RacingAntiCheatLogic bypassed!")
    end
end)

-- ============================================================
-- 8. CLIENTREPORTPLAYERSUBSYSTEM.LUA BYPASS
-- ============================================================
pcall(function()
    if ClientReportPlayerSubsystem then
        ClientReportPlayerSubsystem.OnInit = function(self) return end
        ClientReportPlayerSubsystem._OnPlayerKilledOtherPlayer = function(self, FatalDamageParameter) return end
        ClientReportPlayerSubsystem._RecordFatalDamager = function(self, bIsKnockDown, sName, sUID, bIsAI, bIsMLAI, sOriginalUID, bIsDeliver) return end
        ClientReportPlayerSubsystem._RecordMurdererFromDeathReplayData = function(self, bIsDead, bIsValidDeathReplay, bIsSuicide, sPlayerName, sPlayerUID, bIsPlayerAI, eAIType, nDamageType, sMLAIUID) return end
        ClientReportPlayerSubsystem._OnSyncFatalDamage = function(self, _, __, FatalDamageArray, bIsKnockDown) return end
        ClientReportPlayerSubsystem._SyncBattleResult = function(self, _, __, tBattleResult) return end
        ClientReportPlayerSubsystem._OnBattleResult = function(self, _, __) return end
        ClientReportPlayerSubsystem._OnShowQuickReportMutualExclusiveUI = function(self, _, __) return end
        ClientReportPlayerSubsystem._OnHideQuickReportMutualExclusiveUI = function(self, _, __) return end
        ClientReportPlayerSubsystem._StartCheckGameModeTypeTimer = function(self) return end
        ClientReportPlayerSubsystem._CheckGameModeType = function(self) return end
        ClientReportPlayerSubsystem._StartCheckCurrentNotInTeamHistoricalTeammateTimer = function(self) return end
        ClientReportPlayerSubsystem._CheckCurrentNotInTeamHistoricalTeammate = function(self) return end
        ClientReportPlayerSubsystem._RecordTeammatePlayerInfo = function(self) return end
        ClientReportPlayerSubsystem._IsHealthStatusKilled = function(self, nHealthStatus) return false end
        ClientReportPlayerSubsystem.GetFatalDamagerMap = function(self, bIsKnockDown) return {} end
        ClientReportPlayerSubsystem.GetFatalDamagerMapSize = function(self, bIsKnockDown) return 0 end
        ClientReportPlayerSubsystem.GetName2InfoMap = function(self, bIsKnockDown) return {} end
        ClientReportPlayerSubsystem.GetCachedTeammateName2InfoMap = function(self, bIsExcludeMyself) return {} end
        ClientReportPlayerSubsystem.GetTeammateName2InfoMapDuringBattle = function(self, bIsExcludeMyself) return {} end
        ClientReportPlayerSubsystem.GetCurrentNotInTeamHistoricalTeammateMap = function(self) return {} end
        ClientReportPlayerSubsystem.GetInTeamIndexFromHistoricalTeammateInfo = function(self, sName) return -1 end
        ClientReportPlayerSubsystem.IsGameModeTypeTeamDeathMatch = function(self) return false end
        ClientReportPlayerSubsystem.GetGameModeType = function(self) return -1 end
        ClientReportPlayerSubsystem.GetMainModeID = function(self) return -1 end
        ClientReportPlayerSubsystem.GetSubModeID = function(self) return -1 end
        ClientReportPlayerSubsystem.EnableRecordFatalDamage = function(self, bEnable) return end
        ClientReportPlayerSubsystem._tKnockDownerMap = {}
        ClientReportPlayerSubsystem._tMurdererMap = {}
        ClientReportPlayerSubsystem._ds2history = {}
        ClientReportPlayerSubsystem._tMapCurrentNotInTeamHistoricalTeammate = {}
        ClientReportPlayerSubsystem._tTeammateName2InfoMap = {}
        ClientReportPlayerSubsystem._bEnableRecordFatalDamage = false
        ClientReportPlayerSubsystem._bIsGameModeTypeTeamDeathMatch = false
        ClientReportPlayerSubsystem._nGameModeType = -1
        ClientReportPlayerSubsystem._nMainModeID = -1
        ClientReportPlayerSubsystem._nSubModeID = -1
        ClientReportPlayerSubsystem._nCheckTDMGameModeTypeTimer = nil
        ClientReportPlayerSubsystem._nCurrentNotInTeamHistoricalTeammateTimer = nil
        print("[BYPASS] ✅ ClientReportPlayerSubsystem bypassed!")
    end
end)

-- ============================================================
-- 9. DSREPORTPLAYERSUBSYSTEM.LUA BYPASS
-- ============================================================
pcall(function()
    if DSReportPlayerSubsystem then
        DSReportPlayerSubsystem.OnInit = function(self) return end
        DSReportPlayerSubsystem._OnNearDeathOrRescued = function(self, _, __, uVictimCharacter, uDamageCauser, bIsNotHealthy, nDamageType, uKillerCharacter) return end
        DSReportPlayerSubsystem._OnPlayerSettlementStart = function(self, _, __, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._OnTeammateDamage = function(self, _, __, sVictimPlayerUID, sPerpetratorPlayerUID, nTeammateDamageType, nVictimHealthStatus, bIsJustifiableDefense) return end
        DSReportPlayerSubsystem._OnCharacterDied = function(self, _, __, uVictimCharacter, nDamageType, uDamageCauser, uKillerController) return end
        DSReportPlayerSubsystem._OnPlayerReconnect = function(self, _, __, uVictimComp) return end
        DSReportPlayerSubsystem._RecordFatalDamager = function(self, nVictimUID, bIsKnockDown, sName, sUID, bIsAI, bIsMLAI, sOriginalUID, bIsDeliver) return end
        DSReportPlayerSubsystem._RecordTeammateMurderer = function(self, sVictimPlayerUID, sPerpetratorPlayerUID) return end
        DSReportPlayerSubsystem._AddMLKillerUIDToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._AddFatalDamagerMapToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._AddKnockDownerToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._AddKillerToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._AddTeammateMurderToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._SaveHistoricalTeammateInfo = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._SyncFatalDamagerMap = function(self, tCache, uVictimComp, bIsKnockDown) return end
        DSReportPlayerSubsystem._AddGameModeTypeToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._UpdateMLAIUID = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._AddEnemyMapToBattleResult = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._OnNoNetStartUpDoor = function(self) return end
        DSReportPlayerSubsystem._AssignTeammateInTeamIndex = function(self, nUID, tPlayerBattleResult) return end
        DSReportPlayerSubsystem._FindCacheByUID = function(self, nUID, bAddIfNotExists)
            if bAddIfNotExists then return {} end
            return nil
        end
        DSReportPlayerSubsystem._GetFatalDamagerMap = function(self, nVictimUID, bIsKnockDown) return {} end
        DSReportPlayerSubsystem._IsBattleResultTableValid = function(self, nUID, tPlayerBattleResult) return false end
        DSReportPlayerSubsystem._IsHealthStatusKilled = function(self, nHealthStatus) return false end
        DSReportPlayerSubsystem._tUID2InfoMap = {}
        DSReportPlayerSubsystem.nNoStartUpDoorNum = 0
        print("[BYPASS] ✅ DSReportPlayerSubsystem bypassed!")
    end
end)

-- ============================================================
-- 10. TLOG_REPORT_UTILS.LUA BYPASS
-- ============================================================
pcall(function()
    if tlog_report_utils then
        tlog_report_utils.ReportTLogEvent = function(buttton_type, reason, reason_str, IsImmediateReport) return end
        tlog_report_utils.IsCanReportLobbyEvent = function(buttton_type) return false end
        tlog_report_utils.IsBusinessReport = function(button_type) return false end
        tlog_report_utils.SetMarketStayUpdateEnable = function(marketStayUpdateEnable) return end
        tlog_report_utils.GetMarketStayUpdateEnable = function() return false end
        tlog_report_utils.SetBusinessReportEnable = function(enable) return end
        tlog_report_utils.SendTLogReportImmediate = function(buttton_type, reason, reason_str, IsImmediateReport) return end
        tlog_report_utils.SetTlogBeginType = function(tlogType, timestamp) return end
        tlog_report_utils.SetTlogEndType = function(tlogType, timestamp) return end
        _G.SendTLogReportImmediate = function(buttton_type, reason, reason_str, IsImmediateReport) return end
        _extraTlogReportEnableCfg = {}
        _isCanReportMarketStay = false
        _BusinessReportEnable = false
        _isInitConfig = true
        start_timestamp_map = {}
        print("[BYPASS] ✅ tlog_report_utils bypassed!")
    end
end)

-- ============================================================
-- 11. TOOLREPORTUTIL.LUA BYPASS
-- ============================================================
pcall(function()
    if ToolReportUtil then
        ToolReportUtil.GetReportSwitch = function(switchKey, reportRate) return false end
        ToolReportUtil.GetPackageInfo = function() return nil end
        ToolReportUtil.ReParseError = function(error, reportType) return error or "" end
        ToolReportUtil.IsReleaseVersion = function() return true end
        ToolReportUtil.IsWhite = function(whiteKey) return false end
        ToolReportUtil.IsXPcallOpenInBattle = function(battleKey) return false end
        ToolReportUtil.IsClientToolOpen = function() return false end
        MyOpenID = false
        MyUID = false
        VersionInfo = nil
        print("[BYPASS] ✅ ToolReportUtil bypassed!")
    end
end)

-- ============================================================
-- EXTRA: IngameTipsTools Hooks
-- ============================================================
pcall(function()
    if IngameTipsTools then
        IngameTipsTools.BattleGeneralTipWithTranslation = function(...) return end
        IngameTipsTools.BattleGeneralTip = function(...) return end
        IngameTipsTools.BattleNormalTips = function(...) return end
        IngameTipsTools.BattleNormalTipsByTextID = function(...) return end
        IngameTipsTools.ShowMsgBox = function(...) return end
        print("[BYPASS] ✅ IngameTipsTools hooks blocked!")
    end
end)

-- ============================================================
-- EXTRA: CGameState Broadcast Hooks
-- ============================================================
pcall(function()
    if CGameState and CGameState.BroadcastUICustomBehavior then
        local orig = CGameState.BroadcastUICustomBehavior
        CGameState.BroadcastUICustomBehavior = function(self, behavior, ...)
            if behavior == "ShowRealTimeBlockingTips" then
                return
            end
            return orig(self, behavior, ...)
        end
        print("[BYPASS] ✅ CGameState broadcast hooks blocked!")
    end
end)

-- ============================================================
-- EXTRA: ReportPlayerUtils Hooks
-- ============================================================
pcall(function()
    local ReportPlayerUtils = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
    if ReportPlayerUtils then
        ReportPlayerUtils.RecordFatalDamager = function(tMap, sName, sUID, bIsAI, bIsMLAI, sOriginalUID, bIsDeliver) return end
        ReportPlayerUtils.RecordFatalDamagerReconnect = function(tMap, sName, sUID, bIsAI, bIsMLAI, sOriginalUID, bIsDeliver, nOccurTime) return end
        ReportPlayerUtils.IsUsingHistoricalTeammateInfo = function() return false end
        ReportPlayerUtils.IsCharacterDeliverAI = function() return false end
        ReportPlayerUtils.tSkipAlertFatalDamageCharacterTypeMapInDev = {}
        print("[BYPASS] ✅ ReportPlayerUtils bypassed!")
    end
end)

-- ============================================================
-- EXTRA: GameReportUtils Hooks
-- ============================================================
pcall(function()
    local GameReportUtils = require("GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils")
    if GameReportUtils then
        GameReportUtils.ReportException = function(...) return end
        GameReportUtils.ReplayReportData = function(...) return end
        GameReportUtils.ReportGameException = function(...) return end
        GameReportUtils.BugglyPostExceptionFull = function(...) return false end
        GameReportUtils.CheckCanBugglyPostException = function(...) return false end
        print("[BYPASS] ✅ GameReportUtils bypassed!")
    end
end)

-- ============================================================
-- EXTRA: ClientToolsReport Hooks
-- ============================================================
pcall(function()
    local ClientToolsReport = require("client.slua.logic.report.ClientToolsReport")
    if ClientToolsReport then
        ClientToolsReport.SendReport = function(...) return end
        ClientToolsReport.SendException = function(...) return end
        ClientToolsReport.ReportCapability = function(...) return end
        print("[BYPASS] ✅ ClientToolsReport bypassed!")
    end
end)

-- ============================================================
-- EXTRA: MatchManager Hooks
-- ============================================================
pcall(function()
    local MatchManager = require("GameLua.Mod.SocialIsland.DS.Battle.MatchManager")
    if MatchManager then
        MatchManager.GetVehicleByUid = function(playerUID) return nil end
        print("[BYPASS] ✅ MatchManager vehicle hooks blocked!")
    end
end)

-- ============================================================
-- EXTRA: HDmpveRemote Hooks
-- ============================================================
pcall(function()
    if HDmpveRemote and HDmpveRemote.HDmpveRemoteConfigGetBool then
        local orig = HDmpveRemote.HDmpveRemoteConfigGetBool
        HDmpveRemote.HDmpveRemoteConfigGetBool = function(key, default)
            local blockedKeys = {"ClientReportServer", "ClientReportServerWhite", "Report", "TLog", "Telemetry", "Analytics"}
            if key and type(key) == "string" then
                for _, bk in ipairs(blockedKeys) do
                    if key:find(bk) then
                        return false
                    end
                end
            end
            return orig(key, default)
        end
        print("[BYPASS] ✅ HDmpveRemote config hooks blocked!")
    end
end)

-- ============================================================
-- EXTRA: BasicDataTLogReport Hooks
-- ============================================================
pcall(function()
    local BasicDataTLogReport = ModuleManager and ModuleManager.GetModule and 
        ModuleManager.GetModule(ModuleManager.DataModuleConfig.BasicDataTLogReport)
    if BasicDataTLogReport then
        BasicDataTLogReport.ReportImmediate = function(...) return end
        BasicDataTLogReport.ReportDelay = function(...) return end
        BasicDataTLogReport.send_report_event_duration_log = function(...) return end
        print("[BYPASS] ✅ BasicDataTLogReport bypassed!")
    end
end)

-- ============================================================
-- EXTRA: Higgs Console Variable Hook
-- ============================================================
pcall(function()
    if USTExtraBlueprintFunctionLibrary and USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue then
        local orig = USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue
        USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue = function(name)
            if name == "higgs.EnableClientShowSecurityAlert" then
                return 0
            end
            return orig(name)
        end
        print("[BYPASS] ✅ Higgs console variable blocked!")
    end
end)

-- ============================================================
-- EXTRA: Block Racing Cheat Events
-- ============================================================
pcall(function()
    if EventSystem then
        local oldPost = EventSystem.postEvent
        EventSystem.postEvent = function(eventType, eventID, ...)
            local blockedEvents = {
                "EVENTID_ISLAND_RACING_FLOATING_CHEAT",
                "EVENTID_ISLAND_RACING_SPPED_CHEAT"
            }
            if eventID and type(eventID) == "string" then
                for _, be in ipairs(blockedEvents) do
                    if eventID:find(be) then
                        return
                    end
                end
            end
            if oldPost then oldPost(eventType, eventID, ...) end
        end
        print("[BYPASS] ✅ Racing cheat events blocked!")
    end
end)

-- ============================================================
-- END OF BYPASS ENGINE
-- ============================================================

-- ============================================================
-- WELCOME POP-UP
-- ============================================================
function _G.TryShowWelcome()
    pcall(function()
        local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
        if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
        local Web = require("client.slua.logic.url.logic_webview_sdk")
        local function onClick() if Web then Web:OpenURL("https://t.me/TrnDravix") end end
        if Msg and Msg.Show then
            Msg.Show(4, "✦ TrnDravix – ELITE ULTIMATE ✦",
            "\n★ Developer : @TrnDravix\n" ..
            "★ Status    : UNDETECTED & OPTIMIZED\n" ..
            "★ Bypass    : 11-Layer Ultimate Shield\n\n" ..
            "✓ Premium Build Loaded Successfully!", onClick)
        end
        _G.WelcomeShown = true
    end)
end

pcall(_G.TryShowWelcome)

-- ============================================================
-- STANDALONE WALLHACK
-- ============================================================
local function GetColorFromIndex(idx)
    local colors = {
        {R=255,G=0,B=0},   -- 1 Red
        {R=255,G=255,B=255}, -- 2 White
        {R=255,G=255,B=0}, -- 3 Yellow
        {R=0,G=255,B=0},   -- 4 Green
        {R=0,G=255,B=255}, -- 5 Cyan
        {R=0,G=0,B=255},   -- 6 Blue
        {R=255,G=0,B=255}, -- 7 Purple
    }
    return colors[idx] or colors[4]
end

local function ApplyWallHack()
    if not _G.CheatsEnabled then return end
    if not _G.ESPConfig.Wallhack then return end

    local localPlayer = GameplayData and GameplayData.GetPlayerCharacter()
    if not localPlayer or not slua.isValid(localPlayer) then return end

    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc or not slua.isValid(pc) then return end

    local myTeam = localPlayer.TeamID or 0
    local allCharacters = Game:GetAllPlayerPawns()
    if not allCharacters then return end

    local cfg = _G.ESPConfig
    local brightnessFactor = cfg.WallhackBrightness / 25.0
    local glowIntensity = cfg.WallhackGlow

    for _, enemy in pairs(allCharacters) do
        if slua.isValid(enemy) and enemy ~= localPlayer then
            local targetTeam = enemy.TeamID or 0
            if targetTeam == myTeam then goto continue end

            local isAlive = false
            pcall(function() isAlive = enemy:IsAlive() end)
            if not isAlive then goto continue end

            if not cfg.ShowAI then
                local isBot = false
                pcall(function() isBot = Game:IsAI(enemy) end)
                if isBot then goto continue end
            end

            local meshes = {}
            if slua.isValid(enemy.Mesh) then
                table.insert(meshes, enemy.Mesh)
            end
            local SkelClass = import("SkeletalMeshComponent")
            if SkelClass then
                local childs = enemy:GetComponentsByClass(SkelClass)
                if childs then
                    local count = type(childs.Num) == "function" and childs:Num() or #childs
                    for c = 1, count do
                        local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                        if slua.isValid(comp) and comp ~= enemy.Mesh then
                            table.insert(meshes, comp)
                        end
                    end
                end
            end

            local isVisible = false
            if slua.isValid(pc) and type(pc.LineOfSightTo) == "function" then
                pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
            end

            local colorIdx = isVisible and cfg.WallhackVisibleColor or cfg.WallhackInvisibleColor
            local baseColor = GetColorFromIndex(colorIdx)
            local finalColor = {
                R = math.min(255, math.floor(baseColor.R * brightnessFactor)),
                G = math.min(255, math.floor(baseColor.G * brightnessFactor)),
                B = math.min(255, math.floor(baseColor.B * brightnessFactor)),
                A = 255
            }
            local glowVec = {R=glowIntensity*255, G=glowIntensity*255, B=glowIntensity*255, A=0}

            enemy._WH_MIDs = enemy._WH_MIDs or {}
            for _, comp in ipairs(meshes) do
                if slua.isValid(comp) then
                    local ok, mat = pcall(function() return comp:GetMaterial(0) end)
                    if ok and slua.isValid(mat) then
                        local ok2, base = pcall(function() return mat:GetBaseMaterial() end)
                        if ok2 and slua.isValid(base) then
                            base.bDisableDepthTest = true
                            base.BlendMode = 2
                        end
                    end
                    comp.UseScopeDistanceCulling = false
                    comp.PrimitiveShadingStrategy = 1
                    comp.ShadingRate = 6

                    local ck = tostring(comp)
                    enemy._WH_MIDs[ck] = enemy._WH_MIDs[ck] or {}
                    for i = 0, 10 do
                        local ok3, mi = pcall(function() return comp:GetMaterial(i) end)
                        if not ok3 or not slua.isValid(mi) then break end
                        local mid = enemy._WH_MIDs[ck][i]
                        if not slua.isValid(mid) then
                            local ok4, nm = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                            if ok4 and slua.isValid(nm) then
                                enemy._WH_MIDs[ck][i] = nm
                                mid = nm
                            end
                        end
                        if slua.isValid(mid) then
                            pcall(function()
                                mid:SetVectorParameterValue("颜色", finalColor)
                                mid:SetVectorParameterValue("Color", finalColor)
                                mid:SetVectorParameterValue("BaseColor", finalColor)
                                mid:SetVectorParameterValue("BodyColor", finalColor)
                                mid:SetVectorParameterValue("DiffuseColor", finalColor)
                                mid:SetScalarParameterValue("EmissiveIntensity", glowIntensity)
                                mid:SetScalarParameterValue("GlowIntensity", glowIntensity)
                                mid:SetScalarParameterValue("EmissiveScale", glowIntensity)
                                mid:SetVectorParameterValue("EmissiveColor", {R=finalColor.R*glowIntensity, G=finalColor.G*glowIntensity, B=finalColor.B*glowIntensity, A=255})
                                mid:SetVectorParameterValue("ParaScaleOffset", glowVec)
                            end)
                        end
                    end
                end
            end
        end
        ::continue::
    end
end

local function StartWallhackTimer()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        if _G._WallhackTimer then
            pcall(function() pc:RemoveGameTimer(_G._WallhackTimer) end)
        end
        _G._WallhackTimer = pc:AddGameTimer(0.1, true, function()
            pcall(ApplyWallHack)
        end)
    end
end

pcall(function()
    StartWallhackTimer()
end)

pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, true, function()
            if not _G._WallhackTimer then
                StartWallhackTimer()
            end
        end)
    end
end)

-- ============================================================
-- ESP
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
        HUD:AddDebugText(string.format("BOT : %d     PLAYER : %d", botCount, playerCount), currentPawn, 1, {X=0,Y=0,Z=155}, {X=0,Y=0,Z=155}, {R=255,G=255,B=0,A=255}, true, false, true, nil, 1.0, true)
        HUD:AddDebugText("✦REAL DEV @TrnDravix✦", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=0,G=200,B=255,A=255}, true, false, true, nil, 1.0, true)
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
        entity.WeaponAimInTime = 20
        entity.SwitchFromIdleToBackpackTime = 0.15
        entity.SwitchFromBackpackToIdleTime = 0.15
        entity.ShotGunHorizontalSpread = 0.0
        entity.ShotGunVerticalSpread = 0.0
        entity.RecoilKickADS = 0.020
        entity.AccessoriesVRecoilFactor = 0.30
        entity.AccessoriesHRecoilFactor = 0.35
        entity.ExtraHitPerformScale = 10
        if entity.RecoilInfo then
            entity.RecoilInfo.VerticalRecoilMin = 0.2
            entity.RecoilInfo.VerticalRecoilMax = 0.5
            entity.RecoilInfo.RecoilSpeedVertical = 0.2
            entity.RecoilInfo.RecoilSpeedHorizontal = 0.15
            entity.RecoilInfo.VerticalRecoveryMax = 0.2
        end
        entity.RecoilModifierStand = 0.1
        entity.RecoilModifierCrouch = 0.1
        entity.RecoilModifierProne = 0.1
        if entity.AutoAimingConfig then
            for _, range in ipairs({"OuterRange", "InnerRange"}) do
                local cfg = entity.AutoAimingConfig[range]
                if cfg then
                    cfg.Speed = 8
                    cfg.RangeRate = 5
                    cfg.SpeedRate = 5
                    cfg.RangeRateSight = 4
                    cfg.SpeedRateSight = 4
                    cfg.CrouchRate = 4
                    cfg.ProneRate = 4
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
        pcall(function()
            local aimComp = char.BP_AutoAimingComponent_C
                         or char.BP_AutoAimingComponent
                         or char.AutoAimingComponent
            if slua.isValid(aimComp) and aimComp.Bones then
                pcall(function() aimComp.Bones[0] = "neck_01" end)
                pcall(function() aimComp.Bones[1] = "neck_01" end)
                pcall(function() aimComp.Bones[2] = "neck_01" end)
                pcall(function() aimComp.Bones:Set(0, "neck_01") end)
                pcall(function() aimComp.Bones:Set(1, "neck_01") end)
                pcall(function() aimComp.Bones:Set(2, "neck_01") end)
            end
        end)
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

        local ModMenuStack = {
            { UI = AliasMap.Title, Text = "TrnDravix SETTINGS" },

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
            -- ===== WALLHACK SECTION =====
            { UI = AliasMap.Title, Text = "--- WALLHACK ---" },
            {
                Key = "WH_Enabled",
                UI = AliasMap.TitleSwitcher,
                Text = "Wallhack",
                GetFunc = function() return _G.ESPConfig.Wallhack end,
                SetFunc = function(_, value)
                    _G.ESPConfig.Wallhack = value
                    _G.Mod_Wallhack_Enabled = value
                    print("[MOD] WALLHACK: " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
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
                Key = "WH_Glow",
                UI = AliasMap.Slider,
                Text = "Glow Intensity",
                Min = 0,
                Max = 10,
                Step = 0.5,
                IsPercent = false,
                GetFunc = function() return _G.ESPConfig.WallhackGlow or 3.0 end,
                SetFunc = function(_, value)
                    _G.ESPConfig.WallhackGlow = value
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
            -- ===== END WALLHACK SECTION =====
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
            }
        }

        SettingPageDefine.ModMenu = {
            Key = "ModMenu",
            loc = "TrnDravix MENU",
            UIKey = "Setting_Page_Privacy",
            Category = {
                {
                    Key = "ModMenu_Main",
                    loc = "ALL FEATURES",
                    Stack = ModMenuStack
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

_G.InitModMenuTab()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
