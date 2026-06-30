-- ============================================================
-- MODDED BY ADITYA_ORG + @ADITYA_ORG
-- ULTIMATE MOD WITH 16-LAYER BYPASS
-- Features: Aimbot, ESP (Purana + Naya), Wallhack, 165 FPS, No Grass, iPad View
-- Bypass: 16-Layer Ultimate Shield
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
if not _G.Mod_NewESP_Enabled then _G.Mod_NewESP_Enabled = false end
if not _G.Mod_Wallhack_Enabled then _G.Mod_Wallhack_Enabled = false end
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

_G.CheatsEnabled = true

local require = require
local import = import
local pcall = pcall
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local math = math
local string = string
local os = os
local sluaIsValid = slua.isValid

-- ============================================================
-- NOP FUNCTIONS
-- ============================================================
local function nop() end
local function noptrue() return true end
local function nopfalse() return false end
local function nopnil() return nil end
local function nopstr() return "" end

local ok_gd, GameplayData = pcall(require, "GameLua.GameCore.Data.GameplayData")
if not ok_gd then GameplayData = nil end

-- ============================================================
-- ==================== 16-LAYER BYPASS ====================
-- ============================================================

-- 1. CLIENTENTRY BYPASS
local function ClientEntryBypass()
    pcall(function()
        if _G.Tss then _G.Tss.SendSkdData = nop; _G.Tss.OnRecvData = nop end
        if _G.TssManager then _G.TssManager.SendSkdData = nop; _G.TssManager.OnRecvData = nop end
        if NetUtil then
            NetUtil.SendTss = nop; NetUtil.OnTssRsp = nop; NetUtil.GEMReportSubEvent = nop
            NetUtil.ShowSDKErrorNotice = nop; NetUtil.OnDSServerConnectionErrorNotify = nop
            NetUtil.check_dh_packet_key = nop
            NetUtil.OnNetworkEvent = function(eventID, eventParam, eventParam2)
                if eventParam == "CheatDetected" or eventParam == "IdipBan" then return end
            end
            NetUtil.OnConnected = function(isConnected, nReason) if not isConnected then return end end
            NetUtil.OnStateChange = function(state) if state == 4 then return end end
            NetUtil.OnDisconnected = nop; NetUtil.CheckTime = nop
            NetUtil.StartCheckDSActive = nop; NetUtil.StopCheckDSActive = nop
            NetUtil.StartCheckEnterBattle = nop; NetUtil.StopCheckEnterBattle = nop
            NetUtil.tryConnect = nop; NetUtil.ShowConnectionMsgBox = nop
            NetUtil.LogOut = nop; NetUtil.LogoutNoRefresh = nop
            NetUtil.ClearAutoReconnectParam = nop; NetUtil.ClearAutoReconnectTimer = nop
            NetUtil.GetAutoReconnectParam = function() return { times = 0 } end
        end
        if UnrealNet then
            UnrealNet.HandleNetworkExceptionReport = nop
            UnrealNet.HandleNetworkException = nop
            UnrealNet.HandleNetworkConnectionClosed = nop
            UnrealNet.HandleSpectateException = nop
            UnrealNet.HandleBattleExceptionReport = nop
            UnrealNet.OnNetRepSerializeError = nop
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
                else return end
            end
            UnrealNet.RepListMismatchDetectTrigger = nop
            UnrealNet.RetrunToLobbyFromDisconnect = nop
            UnrealNet.NetworkExceptionAddEnterBattleStage = nopstr
            UnrealNet.IsNeedShowMsgBox = nopfalse
        end
        if Client then
            Client.SetTssNetworkStatus = nop; Client.GEMReportEnterLobbyEvent = nop
            Client.TPerforPlatDisconnectReport = nop
            Client.IsConnected = function(NetInterface) return true end
            Client.ConnectToURL = nop; Client.Disconnect = nop; Client.ReturnToLobby = nop
            Client.GetUnrealNetworkStatus = nopstr
            Client.MD5LuaString = function(str) return "BYPASSED_MD5" end
            Client.GetDSVersion = function() return "999.999.999" end
            Client.IsInReplayState = nopfalse
        end
        if NetManager then
            NetManager.ProcConnected = nop; NetManager.bConnected = true
            NetManager.ProcRespondMsg = nop; NetManager.isLogMsgAfterLogin = false
            NetManager.logMsgMap = {}
        end
        if _G.Net then
            _G.Net.SendPacket = function(LuaStateWrapper, NetInterface, msgName, ...)
                local blockedPackets = {"report_", "Report", "tlog", "Tlog", "TLog", "exception", "Exception",
                    "ban", "Ban", "cheat", "Cheat", "security", "Security", "verify", "Verify",
                    "check", "Check", "detect", "Detect", "flag", "Flag"}
                if msgName and type(msgName) == "string" then
                    for _, bp in ipairs(blockedPackets) do
                        if msgName:find(bp) then return nil end
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
                        if eventID:find(be) then return end
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
                            arg:find("cheat") or arg:find("security") or arg:find("ban") or
                            arg:find("detect") or arg:find("verify") or arg:find("integrity")
                        ) then return end
                    end
                end
            end
        end
        if LogUtil then
            LogUtil.SetForceLog = nop; LogUtil.SetLogTreeEnable = nop; LogUtil.SetWriteLog = nop
        end
        if sandbox then sandbox.LogError = nop; sandbox.LogWarning = nop end
    end)
    print("[BYPASS] ✅ ClientEntry bypassed!")
end

-- 2. HIGGSBOSONCOMPONENT BYPASS
pcall(function()
    if CHiggsBosonComponent then
        CHiggsBosonComponent.ReceiveBeginPlay = nop
        CHiggsBosonComponent.StaticShowSecurityAlertInDev = nop
        CHiggsBosonComponent.ShowABCD = nop
        CHiggsBosonComponent._ClientShowSecurityAlertWindow = nop
        CHiggsBosonComponent._ReportChatRobot = nop
        CHiggsBosonComponent.SendAntiDataFlow = nop
        CHiggsBosonComponent.SendHitFireBtnFlow = nop
        CHiggsBosonComponent.OnBattleResult = nop
        CHiggsBosonComponent.SendHisarData = nop
        CHiggsBosonComponent.RPC_Client_ShowSecurityAlertWindow = nop
        CHiggsBosonComponent.RPC_Server_TellServerName = nop
        CHiggsBosonComponent.RecordStrategyTimestampInReplay = nop
        CHiggsBosonComponent.SkipAlertServer = nop
        CHiggsBosonComponent.SetClientAlertWindowEnabled = nop
        CHiggsBosonComponent.IsCharacterOwnerWerewolf = nopfalse
        CHiggsBosonComponent.IsCharacterOwnerButcher = nopfalse
        CHiggsBosonComponent._ProcessReportChatRobotQueue = nop
        CHiggsBosonComponent.LuaNotifySecurityAbnormalJump = nop
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

-- 3. CLIENTHAWKEYEPATROLSUBSYSTEM BYPASS
pcall(function()
    if ClientHawkEyePatrolSubsystem then
        ClientHawkEyePatrolSubsystem._OnHawkSync = nop
        ClientHawkEyePatrolSubsystem._OnHawkReportSuccess = nop
        ClientHawkEyePatrolSubsystem._OnRecvInspectorBroadcastCount = nop
        ClientHawkEyePatrolSubsystem.ReportCheat = nop
        ClientHawkEyePatrolSubsystem.RequestImprison = nop
        ClientHawkEyePatrolSubsystem.SendReportTLog = nop
        ClientHawkEyePatrolSubsystem.IsDuringHawkEyePatrol = nopfalse
        ClientHawkEyePatrolSubsystem._CollectBeWatchedPlayerInfo = nop
        ClientHawkEyePatrolSubsystem.HasReported = noptrue
        ClientHawkEyePatrolSubsystem.GetBeWatchedPlayerInfo = nopnil
        ClientHawkEyePatrolSubsystem._OnPlayerKilledOtherPlayer = nop
        ClientHawkEyePatrolSubsystem._StartFrameUIRefreshTimer = nop
        ClientHawkEyePatrolSubsystem.ExitWatching = nop
        ClientHawkEyePatrolSubsystem.WantMatchNextPatrol = nop
        ClientHawkEyePatrolSubsystem._InitHawkEyePatrolSubsystem = function(self)
            self._bHasInitialized = true; self._bHasReported = true
        end
        ClientHawkEyePatrolSubsystem._StartHideUITimer = nop
        ClientHawkEyePatrolSubsystem._StartShowDistanceUITimer = nop
        ClientHawkEyePatrolSubsystem._StartCloseBattleEndedTipsTimer = nop
        ClientHawkEyePatrolSubsystem._StartBattleTimeUsageTimer = nop
        ClientHawkEyePatrolSubsystem._StartQuitVoiceRoomTimer = nop
        ClientHawkEyePatrolSubsystem._StartExitGameTimer = nop
        ClientHawkEyePatrolSubsystem._CloseExitGameTimer = nop
        ClientHawkEyePatrolSubsystem._CreateOvertimerTimerForNextPatrol = nop
        ClientHawkEyePatrolSubsystem.ClearNextPatrolOvertimeTimer = nop
        ClientHawkEyePatrolSubsystem.ReturnLobbyAndOpenH5 = nop
        ClientHawkEyePatrolSubsystem.ForceNeverCloseBattleEndedTips = nop
        ClientHawkEyePatrolSubsystem.CheckShowReportedTips = nopfalse
        ClientHawkEyePatrolSubsystem.TryShowReportedTips = nop
        ClientHawkEyePatrolSubsystem.ShowWatchEndedTips = nop
        ClientHawkEyePatrolSubsystem.HasShownWatchEndedTips = noptrue
        ClientHawkEyePatrolSubsystem.OnShowWatchEndedTips = nop
        ClientHawkEyePatrolSubsystem.OnClickLowerLeftExitWatching = nop
        ClientHawkEyePatrolSubsystem.OnClickBottomRightOpenReportWindow = nop
        ClientHawkEyePatrolSubsystem._MarkHasReported = nop
        ClientHawkEyePatrolSubsystem.GetForbidNextPatrolRemainingTimeInSeconds = function() return 0 end
        ClientHawkEyePatrolSubsystem.GetUsedDailyTimeInSeconds = function() return 0 end
        ClientHawkEyePatrolSubsystem.GetInspectorBroadcastCount = function() return -1 end
        ClientHawkEyePatrolSubsystem.GetMaxInspectorBroadcastCount = function() return 0 end
        ClientHawkEyePatrolSubsystem.CanInspectorBroadcast = nopfalse
        ClientHawkEyePatrolSubsystem.IsCharacterLocationShouldDraw = nopfalse
        ClientHawkEyePatrolSubsystem.InitHawkEyePatrolSubsystem = nop
        ClientHawkEyePatrolSubsystem._PostConstruct = function(self)
            self._bHasInitialized = true; self._bHasReported = true; self.nInspectorBroadcastCount = -1
        end
        ClientHawkEyePatrolSubsystem.OnRelease = nop
        ClientHawkEyePatrolSubsystem._bHasInitialized = true
        ClientHawkEyePatrolSubsystem._bHasReported = true
        ClientHawkEyePatrolSubsystem._bHasShownWatchEndedTips = true
        ClientHawkEyePatrolSubsystem.bShowBeReportedTips = true
        ClientHawkEyePatrolSubsystem.nInspectorBroadcastCount = -1
        print("[BYPASS] ✅ ClientHawkEyePatrolSubsystem bypassed!")
    end
end)

-- 4. CLIENTBANLOGIC BYPASS
pcall(function()
    if ClientBanLogic then
        ClientBanLogic.ReqBanInfo = nop
        ClientBanLogic.OnVoiceSwitchNotify = nop
        ClientBanLogic.OnVoiceBanNotify = nop
        ClientBanLogic.OnRealTimeVoiceBanNotify = nop
        ClientBanLogic.OnVoiceBanSuccess = nop
        ClientBanLogic.TryOpenVoice = function()
            EventSystem:postEvent(EVENTTYPE_INGAME_BAN, EVENTID_INGAME_BAN_FORBID_VOICE, false)
        end
        ClientBanLogic.IsVoiceReportEnable = nopfalse
        ClientBanLogic.OnSyncMicSuspicious = nop
        ClientBanLogic.OnSyncMicPreFilter = nop
        ClientBanLogic.OnSyncBanInfo = nop
        ClientBanLogic.OnNotifyWarningTips = nop
        ClientBanLogic.VoiceBanEndTime = 0
        ClientBanLogic.bEnableVoiceReport = false
        ClientBanLogic.SuspiciousFlag = 0
        ClientBanLogic.Reason = ""
        ClientBanLogic.IsTranslated = false
        print("[BYPASS] ✅ ClientBanLogic bypassed!")
    end
end)

-- 5. REALTIMEBAN BYPASS
pcall(function()
    if RealTimeBan then
        RealTimeBan.Init = function() print("[BYPASS] RealTimeBan.Init blocked!") return end
        RealTimeBan.OnPlayerWithRealTimeBan = nop
        RealTimeBan.OnSyncPlayerInfo = nop
        RealTimeBan.HandleEnterGameModeFightingState = nop
        RealTimeBan.ShowAlias = nop
        RealTimeBan.SetOnRankInspectorUID = nop
        RealTimeBan.IsUIDOnRankInspector = nopfalse
        RealTimeBan.GetUIDInspectorRank = function() return -1 end
        RealTimeBan.SetInspectorBroadcastCountUID = nop
        RealTimeBan.GetUIDInspectorBroadcastCount = function() return -1 end
        RealTimeBan.GetTipsIDOffset = function() return 0 end
        RealTimeBan.GetTipsIDOffsetWithUID = function() return 0 end
        RealTimeBan.GetTipsIDOffsetInspector = function() return 0 end
        RealTimeBan.GMShowAlias = nop
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

-- 6. GOKUBA BYPASS
pcall(function()
    local Gokuba = package.loaded["GameLua.Mod.BaseMod.Client.Security.Gokuba"]
    if Gokuba then
        Gokuba.ForwardFeature = function() return {0,0,0,0,0} end
        Gokuba.InitGokubaLogic = nop
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
                Gokuba[k] = nop
            end
        end
        print("[BYPASS] ✅ Gokuba bypassed!")
    end
    if _G.GokubaLogic then
        _G.GokubaLogic.ForwardFeature = nop
        _G.GokubaLogic.InitGokubaLogic = nop
    end
end)

-- 7. RACINGANTICHEATLOGIC BYPASS
pcall(function()
    if RacingAntiCheatLogic then
        RacingAntiCheatLogic.HandleRacingEnter = nop
        RacingAntiCheatLogic.HandleRacingStart = nop
        RacingAntiCheatLogic.HandleRacingEnd = nop
        RacingAntiCheatLogic.StartDetectTimer = nop
        RacingAntiCheatLogic.StopDetectTimer = nop
        RacingAntiCheatLogic.DetectVehicleFloating = nop
        RacingAntiCheatLogic.HandleFloatingCheat = nop
        RacingAntiCheatLogic.SetIgnoreFloating = nop
        RacingAntiCheatLogic.HandlePlayerPassCheckBelt = nop
        RacingAntiCheatLogic.HandleSpeedCheat = nop
        RacingAntiCheatLogic._CreateVehicleData = function() return {} end
        RacingAntiCheatLogic.vehicleDataMap = {}
        RacingAntiCheatLogic.detectTimer = nil
        RacingAntiCheatLogic.config = {FloatingDistLimit = 99999, FloatingTimeLimit = 99999, CheckPassIntervalLimit = 99999}
        print("[BYPASS] ✅ RacingAntiCheatLogic bypassed!")
    end
end)

-- 8. CLIENTREPORTPLAYERSUBSYSTEM BYPASS
pcall(function()
    if ClientReportPlayerSubsystem then
        ClientReportPlayerSubsystem.OnInit = nop
        ClientReportPlayerSubsystem._OnPlayerKilledOtherPlayer = nop
        ClientReportPlayerSubsystem._RecordFatalDamager = nop
        ClientReportPlayerSubsystem._RecordMurdererFromDeathReplayData = nop
        ClientReportPlayerSubsystem._OnSyncFatalDamage = nop
        ClientReportPlayerSubsystem._SyncBattleResult = nop
        ClientReportPlayerSubsystem._OnBattleResult = nop
        ClientReportPlayerSubsystem._OnShowQuickReportMutualExclusiveUI = nop
        ClientReportPlayerSubsystem._OnHideQuickReportMutualExclusiveUI = nop
        ClientReportPlayerSubsystem._StartCheckGameModeTypeTimer = nop
        ClientReportPlayerSubsystem._CheckGameModeType = nop
        ClientReportPlayerSubsystem._StartCheckCurrentNotInTeamHistoricalTeammateTimer = nop
        ClientReportPlayerSubsystem._CheckCurrentNotInTeamHistoricalTeammate = nop
        ClientReportPlayerSubsystem._RecordTeammatePlayerInfo = nop
        ClientReportPlayerSubsystem._IsHealthStatusKilled = nopfalse
        ClientReportPlayerSubsystem.GetFatalDamagerMap = function() return {} end
        ClientReportPlayerSubsystem.GetFatalDamagerMapSize = function() return 0 end
        ClientReportPlayerSubsystem.GetName2InfoMap = function() return {} end
        ClientReportPlayerSubsystem.GetCachedTeammateName2InfoMap = function() return {} end
        ClientReportPlayerSubsystem.GetTeammateName2InfoMapDuringBattle = function() return {} end
        ClientReportPlayerSubsystem.GetCurrentNotInTeamHistoricalTeammateMap = function() return {} end
        ClientReportPlayerSubsystem.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
        ClientReportPlayerSubsystem.IsGameModeTypeTeamDeathMatch = nopfalse
        ClientReportPlayerSubsystem.GetGameModeType = function() return -1 end
        ClientReportPlayerSubsystem.GetMainModeID = function() return -1 end
        ClientReportPlayerSubsystem.GetSubModeID = function() return -1 end
        ClientReportPlayerSubsystem.EnableRecordFatalDamage = nop
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

-- 9. DSREPORTPLAYERSUBSYSTEM BYPASS
pcall(function()
    if DSReportPlayerSubsystem then
        DSReportPlayerSubsystem.OnInit = nop
        DSReportPlayerSubsystem._OnNearDeathOrRescued = nop
        DSReportPlayerSubsystem._OnPlayerSettlementStart = nop
        DSReportPlayerSubsystem._OnTeammateDamage = nop
        DSReportPlayerSubsystem._OnCharacterDied = nop
        DSReportPlayerSubsystem._OnPlayerReconnect = nop
        DSReportPlayerSubsystem._RecordFatalDamager = nop
        DSReportPlayerSubsystem._RecordTeammateMurderer = nop
        DSReportPlayerSubsystem._AddMLKillerUIDToBattleResult = nop
        DSReportPlayerSubsystem._AddFatalDamagerMapToBattleResult = nop
        DSReportPlayerSubsystem._AddKnockDownerToBattleResult = nop
        DSReportPlayerSubsystem._AddKillerToBattleResult = nop
        DSReportPlayerSubsystem._AddTeammateMurderToBattleResult = nop
        DSReportPlayerSubsystem._SaveHistoricalTeammateInfo = nop
        DSReportPlayerSubsystem._SyncFatalDamagerMap = nop
        DSReportPlayerSubsystem._AddGameModeTypeToBattleResult = nop
        DSReportPlayerSubsystem._UpdateMLAIUID = nop
        DSReportPlayerSubsystem._AddEnemyMapToBattleResult = nop
        DSReportPlayerSubsystem._OnNoNetStartUpDoor = nop
        DSReportPlayerSubsystem._AssignTeammateInTeamIndex = nop
        DSReportPlayerSubsystem._FindCacheByUID = function(self, nUID, bAddIfNotExists)
            if bAddIfNotExists then return {} end
            return nil
        end
        DSReportPlayerSubsystem._GetFatalDamagerMap = function() return {} end
        DSReportPlayerSubsystem._IsBattleResultTableValid = nopfalse
        DSReportPlayerSubsystem._IsHealthStatusKilled = nopfalse
        DSReportPlayerSubsystem._tUID2InfoMap = {}
        DSReportPlayerSubsystem.nNoStartUpDoorNum = 0
        print("[BYPASS] ✅ DSReportPlayerSubsystem bypassed!")
    end
end)

-- 10. TLOG_REPORT_UTILS BYPASS
pcall(function()
    if tlog_report_utils then
        tlog_report_utils.ReportTLogEvent = nop
        tlog_report_utils.IsCanReportLobbyEvent = nopfalse
        tlog_report_utils.IsBusinessReport = nopfalse
        tlog_report_utils.SetMarketStayUpdateEnable = nop
        tlog_report_utils.GetMarketStayUpdateEnable = nopfalse
        tlog_report_utils.SetBusinessReportEnable = nop
        tlog_report_utils.SendTLogReportImmediate = nop
        tlog_report_utils.SetTlogBeginType = nop
        tlog_report_utils.SetTlogEndType = nop
        _G.SendTLogReportImmediate = nop
        _extraTlogReportEnableCfg = {}
        _isCanReportMarketStay = false
        _BusinessReportEnable = false
        _isInitConfig = true
        start_timestamp_map = {}
        print("[BYPASS] ✅ tlog_report_utils bypassed!")
    end
end)

-- 11. TOOLREPORTUTIL BYPASS
pcall(function()
    if ToolReportUtil then
        ToolReportUtil.GetReportSwitch = nopfalse
        ToolReportUtil.GetPackageInfo = nopnil
        ToolReportUtil.ReParseError = function(error, reportType) return error or "" end
        ToolReportUtil.IsReleaseVersion = noptrue
        ToolReportUtil.IsWhite = nopfalse
        ToolReportUtil.IsXPcallOpenInBattle = nopfalse
        ToolReportUtil.IsClientToolOpen = nopfalse
        MyOpenID = false
        MyUID = false
        VersionInfo = nil
        print("[BYPASS] ✅ ToolReportUtil bypassed!")
    end
end)

-- 12. DS SECURITY TLOG BYPASS
pcall(function()
    if DSSecurityTLogSubsystem then
        DSSecurityTLogSubsystem.OnInit = nop
        DSSecurityTLogSubsystem._OnReportServerJumpFlow = nop
        DSSecurityTLogSubsystem._OnDevAlert = nop
        DSSecurityTLogSubsystem._InitWhenEditor = nop
        DSSecurityTLogSubsystem._nInitGameSafeCallbacksTimer = nil
        print("[BYPASS] ✅ DSSecurityTLogSubsystem bypassed!")
    end
    if NetUtil and NetUtil.SendPacket then
        local orig = NetUtil.SendPacket
        NetUtil.SendPacket = function(packetName, ...)
            if packetName == "ReportServerJumpFlow" then return end
            return orig(packetName, ...)
        end
    end
end)

-- 13. CHARGEJUMP COMPONENT BYPASS
pcall(function()
    if ChargeJumpComponent then
        local origDoJump = ChargeJumpComponent.DoJump
        ChargeJumpComponent.DoJump = function(self, UploadChargeTime)
            if not self:IsCharging() then return end
            local uOwner = self:GetOwner()
            if sluaIsValid(uOwner) then
                local bJumpStateValid = uOwner:AllowState(EPawnState.Jump, false) and uOwner:CanJump()
                local bPoseValid = uOwner.PoseState == ESTEPoseState.Stand or uOwner.PoseState == ESTEPoseState.Sprint or uOwner:HasState(EPawnState.Shoveling)
                if bJumpStateValid and bPoseValid then
                    local ChargeTime = UploadChargeTime and UploadChargeTime or UGameplayStatics.GetTimeSeconds(CGameWorld) - self.ChargeTimeStamp
                    ChargeTime = math.min(ChargeTime, ChargeJumpComponent.Config.MaxChargeTime)
                    local JumpZ = ChargeJumpComponent.Config.BaseJumpZ + ChargeTime * ChargeJumpComponent.Config.JumpZPerSecond
                    uOwner:EnterState(EPawnState.Jump)
                    uOwner.STCharacterMovement.Velocity.Z = JumpZ
                    uOwner.STCharacterMovement:SetMovementMode(EMovementMode.MOVE_Falling, 0)
                    -- BLOCK abnormal jump report
                    if Client and uOwner:IsLocallyControlled() then
                        self:ServerRPC_DoJump(ChargeTime)
                    end
                elseif Client and uOwner:IsLocallyControlled() then
                    self:ServerRPC_JumpFail()
                end
            end
            self:EndCharge()
        end
        print("[BYPASS] ✅ ChargeJumpComponent bypassed!")
    end
end)

-- 14. CORONALAB TELEMETRY BYPASS
pcall(function()
    _G.LocalMain = function()
        print("[BYPASS] CoronaLab telemetry timer blocked!")
        return
    end
    local uOuterController = slua_GameFrontendHUD:GetPlayerController()
    if sluaIsValid(uOuterController) and uOuterController.AddGameTimer then
        local orig = uOuterController.AddGameTimer
        uOuterController.AddGameTimer = function(interval, bLoop, func, ...)
            if interval == 30 and bLoop == true then
                return nil
            end
            return orig(interval, bLoop, func, ...)
        end
    end
    if CHiggsBosonComponent then
        CHiggsBosonComponent.SecurityCoronaLabClientDataPointer = function(self) return nil end
        CHiggsBosonComponent.SetFloatValueByName = function(self, name, value) return end
    end
    print("[BYPASS] ✅ CoronaLab telemetry bypassed!")
end)

-- 15. LOGIN_MODULE BYPASS
pcall(function()
    if login_module then
        login_module["ban-login"] = function() return end
        login_module["idip-kick-out"] = function() return end
        login_module.aq_ban = function() return end
        login_module["device-in-blacklist"] = function() return end
        login_module.device_num_limit = function() return end
        login_module["register-forbidden"] = function() return end
        login_module["low-version"] = function() return end
        login_module["not-in-white-list"] = function() return end
        login_module.Login_Failed = function() return end
        login_module.aas_ban = function() return end
        login_module.PakMonitorStart = function(EnableMode) return end
        login_module.SetupFilenameHideKeywords = function() return end
        login_module.on_login_failed = function(conn_idx, reason, banInfo, banTime, uid, extra_table) return end
        login_module.DelaybanLoginCancelCallback = function() return end
        print("[BYPASS] ✅ login_module bypassed!")
    end
end)

-- 16. UI_COMPLAINT BYPASS
pcall(function()
    if ui_complaint then
        ui_complaint.SubmitReportData = function(self) self:CloseWindow(false) return end
        ui_complaint._OnClickReport = function(self) return end
        ui_complaint._AddCommonTypesOfPlayerForReport = function(self) return end
        ui_complaint.AddPlayerForReport = function(self, ...) return end
        ui_complaint.GetSelectedReasonAsArray = function(self) return {} end
        ui_complaint.GetSelectedSubReasonAsArray = function(self) return {} end
        ui_complaint.BlockPlayerChat = function(self) return end
        ui_complaint.IsBlockChatCheck = function(self) return false end
        ui_complaint.CheckBoxBlack = function(self, bCheckState) return end
        ui_complaint.UpdateMatchBlackList = function(self) return end
        ui_complaint._SelectedReasonSet = {}
        ui_complaint._SelectedSubReasonSet = {}
        ui_complaint._SelectedCheatSubReasonSet = {}
        ui_complaint._tPlayerName2InfoMap = {}
        ui_complaint._tPlayerNamesArray = {}
        print("[BYPASS] ✅ ui_complaint bypassed!")
    end
    local LogicComplaint = require("client.logic.battle.logic_complaint")
    if LogicComplaint and LogicComplaint.Submit then
        LogicComplaint.Submit = function(...) return end
    end
end)

-- EXTRA HOOKS
pcall(function()
    if IngameTipsTools then
        IngameTipsTools.BattleGeneralTipWithTranslation = nop
        IngameTipsTools.BattleGeneralTip = nop
        IngameTipsTools.BattleNormalTips = nop
        IngameTipsTools.BattleNormalTipsByTextID = nop
        IngameTipsTools.ShowMsgBox = nop
    end
end)

pcall(function()
    if CGameState and CGameState.BroadcastUICustomBehavior then
        local orig = CGameState.BroadcastUICustomBehavior
        CGameState.BroadcastUICustomBehavior = function(self, behavior, ...)
            if behavior == "ShowRealTimeBlockingTips" then return end
            return orig(self, behavior, ...)
        end
    end
end)

pcall(function()
    local ReportPlayerUtils = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
    if ReportPlayerUtils then
        ReportPlayerUtils.RecordFatalDamager = nop
        ReportPlayerUtils.RecordFatalDamagerReconnect = nop
        ReportPlayerUtils.IsUsingHistoricalTeammateInfo = nopfalse
        ReportPlayerUtils.IsCharacterDeliverAI = nopfalse
        ReportPlayerUtils.tSkipAlertFatalDamageCharacterTypeMapInDev = {}
    end
end)

pcall(function()
    local GameReportUtils = require("GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils")
    if GameReportUtils then
        GameReportUtils.ReportException = nop
        GameReportUtils.ReplayReportData = nop
        GameReportUtils.ReportGameException = nop
        GameReportUtils.BugglyPostExceptionFull = nopfalse
        GameReportUtils.CheckCanBugglyPostException = nopfalse
    end
end)

pcall(function()
    local ClientToolsReport = require("client.slua.logic.report.ClientToolsReport")
    if ClientToolsReport then
        ClientToolsReport.SendReport = nop
        ClientToolsReport.SendException = nop
        ClientToolsReport.ReportCapability = nop
    end
end)

pcall(function()
    local MatchManager = require("GameLua.Mod.SocialIsland.DS.Battle.MatchManager")
    if MatchManager then
        MatchManager.GetVehicleByUid = function() return nil end
    end
end)

pcall(function()
    if HDmpveRemote and HDmpveRemote.HDmpveRemoteConfigGetBool then
        local orig = HDmpveRemote.HDmpveRemoteConfigGetBool
        HDmpveRemote.HDmpveRemoteConfigGetBool = function(key, default)
            local blockedKeys = {"ClientReportServer", "ClientReportServerWhite", "Report", "TLog", "Telemetry", "Analytics"}
            if key and type(key) == "string" then
                for _, bk in ipairs(blockedKeys) do
                    if key:find(bk) then return false end
                end
            end
            return orig(key, default)
        end
    end
end)

pcall(function()
    local BasicDataTLogReport = ModuleManager and ModuleManager.GetModule and 
        ModuleManager.GetModule(ModuleManager.DataModuleConfig.BasicDataTLogReport)
    if BasicDataTLogReport then
        BasicDataTLogReport.ReportImmediate = nop
        BasicDataTLogReport.ReportDelay = nop
        BasicDataTLogReport.send_report_event_duration_log = nop
    end
end)

pcall(function()
    if USTExtraBlueprintFunctionLibrary and USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue then
        local orig = USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue
        USTExtraBlueprintFunctionLibrary.GetConsoleVariableIntValue = function(name)
            if name == "higgs.EnableClientShowSecurityAlert" then return 0 end
            return orig(name)
        end
    end
end)

pcall(function()
    if EventSystem then
        local oldPost = EventSystem.postEvent
        EventSystem.postEvent = function(eventType, eventID, ...)
            local blockedEvents = {"EVENTID_ISLAND_RACING_FLOATING_CHEAT", "EVENTID_ISLAND_RACING_SPPED_CHEAT"}
            if eventID and type(eventID) == "string" then
                for _, be in ipairs(blockedEvents) do
                    if eventID:find(be) then return end
                end
            end
            if oldPost then oldPost(eventType, eventID, ...) end
        end
    end
end)

pcall(ClientEntryBypass)

-- ============================================================
-- END OF BYPASS ENGINE
-- ============================================================

-- ============================================================
-- WELCOME POPUP
-- ============================================================
function _G.TryShowWelcome()
    pcall(function()
        local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
        if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
        local Web = require("client.slua.logic.url.logic_webview_sdk")
        local function onClick() if Web then Web:OpenURL("https://t.me/ADITYA_ORG") end end
        if Msg and Msg.Show then
            Msg.Show(4, "✦ ADITYA_ORG – ELITE ULTIMATE ✦",
            "\n★ Developer : @ADITYA_ORG\n" ..
            "★ Status    : UNDETECTED & OPTIMIZED\n" ..
            "★ Bypass    : 16-Layer Ultimate Shield\n" ..
            "★ ESP       : Dual Mode (Purana + Naya)\n\n" ..
            "✓ Premium Build Loaded Successfully!", onClick)
        end
        _G.WelcomeShown = true
    end)
end
pcall(_G.TryShowWelcome)

-- ============================================================
-- PURANA ESP (AddDebugText)
-- ============================================================
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")

local cachedPawns = {}
local lastPawnRefresh = 0

local function IsPawnAlive(p)
    if not sluaIsValid(p) then return false end
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

local function OldESPTick()
    if not _G.CheatsEnabled then return end
    if not _G.Mod_ESP_Enabled then return end
    if _G._ESPTimerHandle and _G._ESPTimerChar and not sluaIsValid(_G._ESPTimerChar) then
        _G._ESPTimerHandle = nil; _G._ESPTimerChar = nil
    end
    local uCon = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not (sluaIsValid(uCon) and Game:IsClassOf(uCon, ASTExtraPlayerController)) then return end
    local currentPawn = uCon:GetCurPawn()
    if not sluaIsValid(currentPawn) then return end

    local myTeamId = 0
    pcall(function()
        local char = uCon:GetPlayerCharacterSafety()
        if sluaIsValid(char) and char.TeamID then myTeamId = char.TeamID
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
        if sluaIsValid(p) and p ~= currentPawn and p.TeamID ~= myTeamId and IsPawnAlive(p) then
            totalAlive = totalAlive + 1
        end
    end
    local crowded = totalAlive > 20

    for _, tPawn in pairs(cachedPawns) do
        if sluaIsValid(tPawn) and tPawn ~= currentPawn and tPawn.TeamID ~= myTeamId then
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
                    if sluaIsValid(mesh) then
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
        HUD:AddDebugText("✦REAL DEV @ADITYA_ORG✦", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=0,G=200,B=255,A=255}, true, false, true, nil, 1.0, true)
    end
end

pcall(function()
    if _G._ESPWatchdogHandle then pcall(function() Game:ClearTimer(_G._ESPWatchdogHandle) end); _G._ESPWatchdogHandle = nil end
    local function StartOldESP(targetActor)
        if not sluaIsValid(targetActor) then return end
        cachedPawns = {}; lastPawnRefresh = 0
        _G._ESPTimerChar = targetActor
        _G._ESPTimerHandle = targetActor:AddGameTimer(0.2, true, function()
            pcall(OldESPTick)
        end)
    end
    local function Watchdog()
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            local curPawn = pc and pc:GetCurPawn()
            if sluaIsValid(curPawn) and _G._ESPTimerChar ~= curPawn then
                if _G._ESPTimerHandle and sluaIsValid(_G._ESPTimerChar) then
                    pcall(function() _G._ESPTimerChar:RemoveGameTimer(_G._ESPTimerHandle) end)
                end
                _G._ESPTimerHandle = nil
                StartOldESP(curPawn)
            elseif not _G._ESPTimerHandle then
                StartOldESP(curPawn)
            end
        end)
    end
    _G._ESPWatchdogHandle = Game:SetTimer(1.0, true, Watchdog)
    Watchdog()
end)

-- ============================================================
-- NAYA ESP (UI Widget Based)
-- ============================================================
local NewESP = {}
NewESP.Widgets = {}
NewESP.Active = false
NewESP.Timer = nil

function NewESP:WorldToScreen(WorldPos)
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not sluaIsValid(pc) then return FVector2D(0, 0) end
    local ScreenPos = FVector2D(0, 0)
    local bSuccess = pc:ProjectWorldLocationToScreen(WorldPos, ScreenPos, false)
    if bSuccess then
        return ScreenPos
    end
    return FVector2D(0, 0)
end

function NewESP:CreateEnemyWidget(Enemy)
    if not sluaIsValid(Enemy) then return end
    if NewESP.Widgets[Enemy] then return end
    
    local Widget = nil
    pcall(function()
        Widget = UIManager.ShowUI(UIManager.UI_Config_InGame.TeamItem, Enemy)
    end)
    if not Widget or not Widget.UIRoot then
        return
    end
    
    if Widget.UIRoot.TextBlock_PlayerName then
        Widget.UIRoot.TextBlock_PlayerName:SetText(Enemy.PlayerName or "Enemy")
        Widget.UIRoot.TextBlock_PlayerName:SetColorAndOpacity(FLinearColor(1, 0, 0, 1))
    end
    
    Widget.UIRoot:SetWidgetVisibility(UEnums.ESlateVisibility.HitTestInvisible)
    NewESP.Widgets[Enemy] = Widget
end

function NewESP:Update()
    if not _G.CheatsEnabled then return end
    if not _G.Mod_NewESP_Enabled then
        for enemy, widget in pairs(NewESP.Widgets) do
            if sluaIsValid(widget) and sluaIsValid(widget.UIRoot) then
                widget.UIRoot:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed)
            end
        end
        return
    end
    
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not sluaIsValid(pc) then return end
    
    local myChar = pc:GetPlayerCharacterSafety()
    if not sluaIsValid(myChar) then return end
    
    local myTeam = myChar.TeamID or 0
    local allPawns = Game:GetAllPlayerPawns()
    if not allPawns then return end
    
    for _, pawn in pairs(allPawns) do
        if sluaIsValid(pawn) and pawn ~= myChar then
            local team = pawn.TeamID or 0
            if team ~= myTeam then
                local isAlive = false
                pcall(function() isAlive = pawn:IsAlive() end)
                if isAlive then
                    if not NewESP.Widgets[pawn] then
                        NewESP:CreateEnemyWidget(pawn)
                    end
                    local loc = pawn:K2_GetActorLocation()
                    if loc then
                        local ScreenPos = NewESP:WorldToScreen(loc)
                        if ScreenPos and NewESP.Widgets[pawn] and sluaIsValid(NewESP.Widgets[pawn].UIRoot) then
                            NewESP.Widgets[pawn].UIRoot:SetRenderTranslation(FVector2D(ScreenPos.X, ScreenPos.Y))
                            NewESP.Widgets[pawn].UIRoot:SetWidgetVisibility(UEnums.ESlateVisibility.HitTestInvisible)
                        end
                    end
                else
                    if NewESP.Widgets[pawn] and sluaIsValid(NewESP.Widgets[pawn].UIRoot) then
                        NewESP.Widgets[pawn].UIRoot:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed)
                    end
                end
            end
        end
    end
end

function NewESP:Start()
    if NewESP.Timer then return end
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if sluaIsValid(pc) and pc.AddGameTimer then
        NewESP.Timer = pc:AddGameTimer(0.15, true, function()
            pcall(function() NewESP:Update() end)
        end)
        NewESP.Active = true
        print("[NEW ESP] ✅ Started!")
    end
end

function NewESP:Stop()
    if NewESP.Timer then
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if sluaIsValid(pc) and pc.RemoveGameTimer then
            pc:RemoveGameTimer(NewESP.Timer)
        end
        NewESP.Timer = nil
    end
    NewESP.Active = false
    for enemy, widget in pairs(NewESP.Widgets) do
        if sluaIsValid(widget) and sluaIsValid(widget.UIRoot) then
            widget.UIRoot:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed)
        end
    end
    print("[NEW ESP] ✅ Stopped!")
end

pcall(function() NewESP:Start() end)

-- ============================================================
-- WALLHACK (Glowing + Bloom)
-- ============================================================
local function GetColorFromIndex(idx)
    local colors = {
        {R=255,G=0,B=0}, {R=255,G=255,B=255}, {R=255,G=255,B=0},
        {R=0,G=255,B=0}, {R=0,G=255,B=255}, {R=0,G=0,B=255}, {R=255,G=0,B=255}
    }
    return colors[idx] or colors[4]
end

local function ApplyGlowingWallhack()
    if not _G.CheatsEnabled then return end
    if not _G.ESPConfig.Wallhack then return end

    pcall(function()
        local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
        if gi then
            gi:ExecuteCMD("r.BloomQuality", "5")
            gi:ExecuteCMD("r.EyeAdaptationQuality", "2")
            gi:ExecuteCMD("r.Tonemapper.Quality", "2")
        end
    end)

    local localPlayer = GameplayData and GameplayData.GetPlayerCharacter()
    if not localPlayer or not sluaIsValid(localPlayer) then return end

    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc or not sluaIsValid(pc) then return end

    local myTeam = localPlayer.TeamID or 0
    local allCharacters = Game:GetAllPlayerPawns()
    if not allCharacters then return end

    local cfg = _G.ESPConfig
    local brightnessFactor = cfg.WallhackBrightness / 25.0
    local glowIntensity = cfg.WallhackGlow

    for _, enemy in pairs(allCharacters) do
        if sluaIsValid(enemy) and enemy ~= localPlayer then
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
            if sluaIsValid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
            local SkelClass = import("SkeletalMeshComponent")
            if SkelClass then
                local childs = enemy:GetComponentsByClass(SkelClass)
                if childs then
                    local count = type(childs.Num) == "function" and childs:Num() or #childs
                    for c = 1, count do
                        local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                        if sluaIsValid(comp) and comp ~= enemy.Mesh then
                            table.insert(meshes, comp)
                        end
                    end
                end
            end

            local isVisible = false
            if sluaIsValid(pc) and type(pc.LineOfSightTo) == "function" then
                pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
            end

            local colorIdx = isVisible and cfg.WallhackVisibleColor or cfg.WallhackInvisibleColor
            local baseColor = GetColorFromIndex(colorIdx)
            local hdrMultiplier = brightnessFactor * glowIntensity * 2.0
            local finalColor = {
                R = math.floor(baseColor.R * hdrMultiplier),
                G = math.floor(baseColor.G * hdrMultiplier),
                B = math.floor(baseColor.B * hdrMultiplier),
                A = 255
            }
            local emissiveColor = {
                R = math.floor(finalColor.R * 1.5),
                G = math.floor(finalColor.G * 1.5),
                B = math.floor(finalColor.B * 1.5),
                A = 255
            }

            enemy._WH_MIDs = enemy._WH_MIDs or {}
            for _, comp in ipairs(meshes) do
                if sluaIsValid(comp) then
                    local ok, mat = pcall(function() return comp:GetMaterial(0) end)
                    if ok and sluaIsValid(mat) then
                        local ok2, base = pcall(function() return mat:GetBaseMaterial() end)
                        if ok2 and sluaIsValid(base) then
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
                        if not ok3 or not sluaIsValid(mi) then break end
                        local mid = enemy._WH_MIDs[ck][i]
                        if not sluaIsValid(mid) then
                            local ok4, nm = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                            if ok4 and sluaIsValid(nm) then
                                enemy._WH_MIDs[ck][i] = nm
                                mid = nm
                            end
                        end
                        if sluaIsValid(mid) then
                            pcall(function()
                                mid:SetVectorParameterValue("颜色", finalColor)
                                mid:SetVectorParameterValue("Color", finalColor)
                                mid:SetVectorParameterValue("BaseColor", finalColor)
                                mid:SetVectorParameterValue("BodyColor", finalColor)
                                mid:SetVectorParameterValue("DiffuseColor", finalColor)
                                mid:SetVectorParameterValue("Emissive", emissiveColor)
                                mid:SetVectorParameterValue("EmissiveColor", emissiveColor)
                                mid:SetVectorParameterValue("GlowColor", emissiveColor)
                                mid:SetScalarParameterValue("EmissiveIntensity", glowIntensity * 5.0)
                                mid:SetScalarParameterValue("GlowIntensity", glowIntensity * 5.0)
                                mid:SetScalarParameterValue("EmissiveScale", glowIntensity * 3.0)
                                mid:SetScalarParameterValue("BloomIntensity", glowIntensity * 5.0)
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
    if sluaIsValid(pc) and pc.AddGameTimer then
        if _G._WallhackTimer then
            pcall(function() pc:RemoveGameTimer(_G._WallhackTimer) end)
        end
        _G._WallhackTimer = pc:AddGameTimer(0.05, true, function()
            pcall(ApplyGlowingWallhack)
        end)
    end
end

pcall(function()
    StartWallhackTimer()
end)

pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if sluaIsValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, true, function()
            if not _G._WallhackTimer then
                StartWallhackTimer()
            end
        end)
    end
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
                    if sluaIsValid(node) then
                        node:SetIsEnabled(true)
                        pcall(function() node:SetRenderOpacity(1.0) end)
                        local sw = self.UIRoot["WidgetSwitcher_"..tostring(i)]
                        if sluaIsValid(sw) then sw:SetActiveWidgetIndex(i == lvl and 0 or 1) end
                    end
                end
            end
        end
        local fpsFT = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
        if fpsFT and fpsFT.__inner_impl then
            local impl = fpsFT.__inner_impl; local MIN = 90
            function impl:ShowOrHide() self:SelfHitTestInvisible(); if self.InitFPSFTSwitch then self:InitFPSFTSwitch() end end
            function impl:InitFPSFTSwitch()
                local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local on = db:GetUIData(db.FPSFineTuneSwitch)
                if self.UIRoot.Setting_Switch then self.UIRoot.Setting_Switch:SetSwitcherEnable2(on, true) end
                if self.UIRoot.CanvasPanel_8 then self:SetWidgetVisible(self.UIRoot.CanvasPanel_8, on) end
                if self.UIRoot.WidgetSwitcher_0 then self.UIRoot.WidgetSwitcher_0:SetActiveWidgetIndex(2) end
                if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
            end
            function impl:InitFPSFTValue165()
                local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local r = self.UIRoot
                local on = db:GetUIData(db.FPSFineTuneSwitch)
                local val = on and (db:GetUIData(db.FPSFineTuneNum) or 165) or 165
                if on then
                    r.Slider_screen3:SetLocked(false)
                    r.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1,1,1,1))
                    r.Slider_screen3:SetSliderHandleColor(FLinearColor(1,1,1,1))
                else
                    r.Slider_screen3:SetLocked(true)
                    r.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1,0.625,0.6,1))
                    r.Slider_screen3:SetSliderHandleColor(FLinearColor(1,0.625,0.6,1))
                end
                local norm = (val - MIN) / (165 - MIN)
                r.Veihclescreen3:SetText(tostring(val))
                r.Slider_screen3:SetValue(norm)
                r.ProgressBar_screen3:SetPercent(norm)
            end
            function impl:OnFPSFTValueChange3(val)
                local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                db:UpdateUIData(db.FPSFineTuneNum, val)
                if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
                if self:GetParentUI() then self:GetParentUI():SetDirty(true) end
                local gi = db.GetGameInstance and db.GetGameInstance()
                if gi then gi:ExecuteCMD("t.MaxFPS", tostring(val)); gi:ExecuteCMD("r.FrameRateLimit", tostring(val)) end
            end
            function impl:OnFPSFTAdd3()
                local cur = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB").GetUIData(db.FPSFineTuneNum) or 90
                self:OnFPSFTValueChange3(math.min(165, cur))
            end
            function impl:OnFPSFTMinus3()
                local cur = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB").GetUIData(db.FPSFineTuneNum) or 90
                self:OnFPSFTValueChange3(math.max(MIN, 5))
            end
            impl.OnFPSFTAdd = impl.OnFPSFTAdd3
            impl.OnFPSFTMinus = impl.OnFPSFTMinus3
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
if sluaIsValid(pc) and pc.AddGameTimer and pc ~= _G._FeaturesTimerPC then
    _G._FeaturesTimerPC = pc
    local SubsystemMgr = nil
    local lastViewDistance = nil
    _G._originalTPPFOV = nil

    pc:AddGameTimer(0.1, true, function()
        pcall(function()
            if not _G.CheatsEnabled then return end
            local pc = slua_GameFrontendHUD:GetPlayerController()
            if not sluaIsValid(pc) then return end
            local char = pc:GetPlayerCharacterSafety()
            if not sluaIsValid(char) then return end
            local lp = GameplayData.GetPlayerCharacter()
            if not sluaIsValid(lp) then return end

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
                    if sluaIsValid(uTPPCam) and not char.bIsWeaponAiming then
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
    if not _G.Mod_Aimbot_Enabled then return end
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not sluaIsValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not sluaIsValid(char) then return end
        local wm = char.WeaponManagerComponent
        if not sluaIsValid(wm) then return end
        local weapon = wm.CurrentWeaponReplicated
        if not sluaIsValid(weapon) then return end
        local entity = weapon.ShootWeaponEntityComp
        if not sluaIsValid(entity) then return end
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
            local aimComp = char.BP_AutoAimingComponent_C or char.BP_AutoAimingComponent or char.AutoAimingComponent
            if sluaIsValid(aimComp) and aimComp.Bones then
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
        if not sluaIsValid(pc) then return end
        if pc == _G._AimbotCurrentPC then return end
        _G._AimbotCurrentPC = pc
        if pc.AddGameTimer then
            pc:AddGameTimer(0.1, true, function()
                if not sluaIsValid(_G._AimbotCurrentPC) then
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
    if sluaIsValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, true, function()
            if not sluaIsValid(_G._AimbotCurrentPC) then
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
            { UI = AliasMap.Title, Text = "ADITYA_ORG SETTINGS" },

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
                Text = "ESP (Purana)",
                GetFunc = function() return _G.Mod_ESP_Enabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_ESP_Enabled = value
                    print("[MOD] ESP (Purana): " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
            {
                Key = "NewESP",
                UI = AliasMap.Switcher,
                Text = "Naya ESP (UI Widget)",
                GetFunc = function() return _G.Mod_NewESP_Enabled or false end,
                SetFunc = function(_, value)
                    _G.Mod_NewESP_Enabled = value
                    if value then
                        NewESP:Start()
                    else
                        NewESP:Stop()
                    end
                    print("[MOD] Naya ESP: " .. (value and "ON ✓" or "OFF ✗"))
                    return true
                end
            },
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
            loc = "ADITYA_ORG MENU",
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
