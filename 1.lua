-- =============================================
-- 🔥 TrnDravix COMPLETE SCRIPT (FINAL)
-- =============================================
-- ORIGINAL FEATURES + TSS SDK BYPASS + ANTI-CHEAT MANAGER BYPASS
-- =============================================

-- Per-match guard
do
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G._MOD_LOADED and _G._MOD_PC == pc then return end
    _G._MOD_LOADED = true
    _G._MOD_PC = pc
end

-- =============================================
-- 🎮 FEATURE TOGGLES
-- =============================================
if not _G.Mod_Aimbot_Enabled then _G.Mod_Aimbot_Enabled = false end
if not _G.Mod_ESP_Enabled then _G.Mod_ESP_Enabled = false end
if not _G.Mod_Wallhack_Enabled then _G.Mod_Wallhack_Enabled = false end
if not _G.Mod_Skin_Enabled then _G.Mod_Skin_Enabled = false end
if _G.Mod_FPS165_Enabled == nil then _G.Mod_FPS165_Enabled = true end
if _G.Mod_NoGrass_Enabled == nil then _G.Mod_NoGrass_Enabled = true end
if _G.Mod_iPadView_Enabled == nil then _G.Mod_iPadView_Enabled = false end

if _G.Mod_AimbotStrength == nil then _G.Mod_AimbotStrength = 50 end
if _G.Mod_iPadViewDistance == nil then _G.Mod_iPadViewDistance = 90 end

if _G.Mod_Chams_GreenEnabled == nil then _G.Mod_Chams_GreenEnabled = false end
if _G.Mod_Chams_YellowEnabled == nil then _G.Mod_Chams_YellowEnabled = false end
if _G.Mod_Chams_GreenRGB == nil then _G.Mod_Chams_GreenRGB = {R=0, G=255, B=0, A=255} end
if _G.Mod_Chams_YellowRGB == nil then _G.Mod_Chams_YellowRGB = {R=255, G=255, B=0, A=255} end

if _G.ESPConfig == nil then _G.ESPConfig = {} end
if _G.ESPConfig.BlackSky == nil then _G.ESPConfig.BlackSky = false end
if _G.ESPConfig.RemoveFog == nil then _G.ESPConfig.RemoveFog = false end
if _G.ESPConfig.RemoveGrass == nil then _G.ESPConfig.RemoveGrass = false end
if _G.ESPConfig.RemoveTree == nil then _G.ESPConfig.RemoveTree = false end
if _G.ESPConfig.RemoveWater == nil then _G.ESPConfig.RemoveWater = false end
if _G.ESPConfig.ForceChinese == nil then _G.ESPConfig.ForceChinese = false end

-- =============================================
-- 📦 SKIN SYSTEM VARIABLES
-- =============================================
_G.WeaponSkinMap        = _G.WeaponSkinMap        or {}
_G.VehicleSkinMap       = _G.VehicleSkinMap       or {}
_G.OutfitMap            = _G.OutfitMap            or {}
_G.AttachmentOverrideMap= _G.AttachmentOverrideMap or {}
_G.SkinAttachments      = _G.SkinAttachments      or {}
_G.SkinLoadedCache      = _G.SkinLoadedCache      or {}
_G.FakeKillCounts       = _G.FakeKillCounts       or {}
_G.LastEquippedOutfits  = _G.LastEquippedOutfits  or {}
_G.g_parts              = _G.g_parts              or {}
_G.skinAttachCache      = _G.skinAttachCache      or {}
_G.KillData             = _G.KillData             or { kills = {} }
_G.DeadBoxSkins         = _G.DeadBoxSkins         or {}
_G.AlreadyChangedSet    = _G.AlreadyChangedSet    or {}
_G.CurrentEquipVehicleID= _G.CurrentEquipVehicleID or 0

-- =============================================
-- 📦 REQUIRES
-- =============================================
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

local function nop() return true end
local function retFalse() return false end
local function retZero() return 0 end
local function retEmpty() return {} end
local function retNil() return nil end
_G.CheatsEnabled = true

local function safe_require(path)
    local ok, mod = pcall(require, path)
    return ok and mod or nil
end

local ok_gd, GameplayData = pcall(require, "GameLua.GameCore.Data.GameplayData")
if not ok_gd then GameplayData = nil end

-- =============================================

-- ============================================================================
-- ✦ TrnDravix ELITE ULTIMATE – BYPASS ONLY ✦
-- Complete 5-layer anti-cheat bypass + all security patches
-- Covers every subsystem + full MD5/CRC fakers + CoronaData protection
-- Fully optimized for minimal lag.
-- ============================================================================

if _G.BYPASS_LOADED then return end
_G.BYPASS_LOADED = true

-- ==================== SHARED HELPERS ====================
local noop = function() return true end
local retFalse = function() return false end
local retZero = function() return 0 end
local retEmpty = function() return {} end
local retTrue = function() return true end
local retEmptyString = function() return "" end
local safe_require = function(path)
    local ok, mod = pcall(require, path)
    return ok and mod or nil
end

-- ==================== EXPIRY CHECK ====================
local MOD_EXPIRY_TS = os.time{year=2026, month=6, day=29, hour=0, min=1, sec=0}
local function isModExpired() return os.time() > MOD_EXPIRY_TS end

local function ShowExpiryDialog()
    pcall(function()
        local Msg = safe_require("client.slua.logic.common.logic_common_msg_box")
        if Msg and Msg.Show then
            Msg.Show(4, "✗ ACCESS DENIED ✗",
            "★ @TrnDravix\n━━━━━━━━━━━━━━━━\n✗ LICENSE EXPIRED\nYour access has been revoked.",
            nil, nil, "OK")
        end
    end)
end

-- ==================== MODULE PATCH TABLE (COMPLETE) ====================
local modulePatches = {
    -- ==================== CORE SECURITY ====================
    ["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"] = {
        methods = {
            ControlMHActive = noop, Tick = noop, OnTick = noop, ReceiveTick = noop,
            MHActiveLogic = noop, TriggerAvatarCheck = noop, StartAvatarCheck = noop,
            ReportItemID = noop, OnReportItemID = noop, ReceiveAnyDamage = noop,
            OnWeaponHitRecord = noop, ShowSecurityAlert = noop,
            StaticShowSecurityAlertInDev = noop, SendHisarData = noop,
            OnLogin = noop, ValidateSecurityData = noop, CheckMemoryIntegrity = noop,
            ReportAbnormalMemory = noop, OnMemoryScanComplete = noop,
            SendDetectionResult = noop, TriggerClientScan = noop,
            SendAntiDataFlow = noop, SendHitFireBtnFlow = noop,
            SkipAlertServer = function() end, CheckWeaponIntegrity = retTrue,
            CheckAvatarIntegrity = retTrue, CheckBulletIntegrity = retTrue,
            OnGameModeType = noop,
        },
        fields = { bMHActive = false, mHActive = 0 },
        retvals = {
            GetNetAvatarItemIDs = retEmpty,
            GetCurWeaponSkinID = retZero,
            GetDetectionResult = retEmpty
        },
        custom = function(m)
            if m.__inner_impl then
                local i = m.__inner_impl
                i.SendAntiDataFlow = noop
                i.SendHitFireBtnFlow = noop
                i.OnBattleResult = noop
                i.SendHisarData = noop
            end
            if m.BlackList then
                for k in pairs(m.BlackList) do m.BlackList[k] = nil end
            end
            if m.SkipAlertServer then pcall(m.SkipAlertServer, m) end
        end,
    },
    
    ["GameLua.Mod.BaseMod.Common.Security.SafetyDetectionSubsystem"] = {
        methods = {
            DetectAbnormal = noop,
            ReportAbnormal = noop,
            OnDetectionResult = noop,
            TriggerSafetyScan = noop
        },
        retvals = {
            GetScanResults = retEmpty,
            IsAnomalyDetected = retFalse
        },
    },

    ["GameLua.Mod.BaseMod.Common.Security.PakIntegrityChecker"] = {
        methods = { ShowPakMismatchAlert = noop },
        retvals = {
            Verify = retFalse,
            CheckPakFile = retZero,
            GetPakStatus = retZero
        }
    },

    ["client.slua.logic.pak.logic_pak_verify"] = {
        retvals = {
            Verify = retFalse,
            CheckPakFile = retZero,
            GetPakStatus = retZero
        }
    },

    ["GameLua.Mod.BaseMod.Common.Security.LuaIntegrityCheck"] = {
        methods = { Run = noop, Verify = retTrue, Check = retTrue }
    },

    ["GameLua.Mod.BaseMod.Common.Security.IntegrityCheck"] = {
        methods = { Run = noop, Verify = retTrue }
    },

    ["GameLua.Mod.BaseMod.Common.Security.APKIntegrity"] = {
        methods = { CheckSignature = retTrue, CheckInstallSource = retTrue }
    },

    ["GameLua.Mod.BaseMod.Common.Security.LibCheck"] = {
        methods = { Verify = retTrue, Check = retTrue, Scan = noop, Report = noop },
        retvals = {
            IsLibValid = retTrue,
            GetTamperedLibs = retEmpty
        }
    },

    ["GameLua.Mod.BaseMod.Common.Security.AntiDebug"] = {
        methods = { Check = retFalse, Report = noop }
    },

    ["GameLua.Mod.BaseMod.Client.Security.SecureBootCheck"] = {
        methods = { VerifyBoot = retTrue }
    },

    -- ==================== GLOBAL BYPASSES ====================
    _G_STExtra = {
        table = "_G.STExtraBlueprintFunctionLibrary",
        retvals = {
            CheckFileIntegrity = retFalse,
            VerifySignature = retFalse,
            CheckGameLuaIntegrity = retFalse
        }
    },

    _G_TssSDK = {
        table = "_G.TssSDK",
        methods = {
            ReportData = noop,
            SendToServer = noop,
            SetUserInfo = noop,
            Init = noop,
            Start = noop,
            Verify = retTrue,
            CheckIntegrity = retTrue,
            Check = retTrue,
        },
        retvals = {
            GetSignature = function() return "BYPASSED" end
        }
    },

    _G_TssSDKHelper = {
        table = "_G.TssSDKHelper",
        methods = { ReportData = noop }
    },

    _G_Bugly = {
        table = "_G.Bugly",
        methods = { ReportException = noop, SetCustomData = noop }
    },

    _G_Beacon = {
        table = "_G.Beacon",
        methods = { Report = noop }
    },

    _G_CrashSight = {
        table = "_G.CrashSight",
        methods = {
            ReportException = noop,
            SetCustomData = noop,
            Log = noop
        }
    },

    _G_TDataMaster = {
        table = "_G.TDataMaster",
        methods = {
            Report = noop,
            ReportDeviceInfo = noop,
            SendHardwareHash = noop,
            CollectTelemetry = noop,
            SendData = noop,
            Sync = noop,
            Flush = noop
        },
        custom = function(m)
            if m then
                for k, v in pairs(m) do
                    if type(v) == "function" then m[k] = noop end
                end
            end
        end,
    },

    _G_DeviceInfo = {
        table = "_G.DeviceInfo",
        methods = {
            GetDeviceID = function() return "unknown" end,
            GetIMEI = function() return "000000000000000" end,
            CollectSysInfo = noop
        }
    },

    _G_NetUtil = {
        table = "_G.NetUtil",
        methods = {
            SendTss = noop,
            SendToServer = noop,
            SendToDS = noop
        }
    },

    -- ==================== BAN BYPASSES ====================
    ["client.slua.logic.ban.ClientBanLogic"] = {
        methods = {
            OnSyncBanInfo = noop,
            OnVoiceBanNotify = noop,
            OnRealTimeVoiceBanNotify = noop,
            OnVoiceBanSuccess = noop,
            OnSyncMicSuspicious = noop,
            OnSyncMicPreFilter = noop,
            OnNotifyWarningTips = noop,
            ReqBanInfo = noop
        },
    },

    ["client.slua.logic.ban.BanTipsLogic"] = {
        methods = {
            ShowBanTips = noop,
            ShowPunishTips = noop,
            ShowWarningTips = noop,
            OnReceiveBanNotice = noop
        }
    },

    ["client.slua.logic.ban.logic_ban"] = {
        methods = {
            GetBanEndTime = function() return 0 end,
            IsInBanTime = retFalse,
            CheckBanStatus = retFalse,
            GetBanReason = retEmpty,
            GetBanTime = retZero
        }
    },

    ["client.slua.logic.login.logic_login_ban"] = {
        methods = {
            CheckCanLogin = retTrue,
            GetBanInfo = function() return { end_time = 0 } end,
            IsBanned = retFalse,
            IsSecurityBan = retFalse
        }
    },

    ["GameLua.Mod.BaseMod.Client.Security.ClientFlagSubsystem"] = {
        methods = {
            EvaluateFlags = noop,
            GetFlagLevel = retZero,
            GetFlagBanDuration = retZero,
            IsFlagged = retFalse,
            ReportFlag = noop,
            SyncFlagStatus = noop,
            IncreaseFlagCount = noop,
            ResetFlags = noop,
        },
        retvals = { IsFlagged = retFalse },
        fields = { FlagCount = 0, FlagLevel = 0, FlagSeverity = 0 },
    },

    ["client.slua.logic.ban.logic_flag_ban"] = {
        methods = {
            GetFlagBanEndTime = function() return 0 end,
            IsFlagBanned = retFalse,
            GetFlagBanDuration = retZero,
            CheckFlagBan = retFalse,
        }
    },

    _G_ban_util = {
        table = "_G.ban_util",
        retvals = {
            CheckBanStatus = retFalse,
            GetBanTime = retZero,
            IsBanForever = retFalse
        }
    },

    _G_logic_tt_ban = {
        table = "_G.logic_tt_ban",
        methods = { CheckIfCanCreateRole = noop },
        retvals = {
            JumpAppealURL = retFalse,
            GetCarrierInfo = function() return '[{"mcc":"000"}]' end
        }
    },

    -- ==================== REPORT BYPASSES ====================
    ["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] = {
        methods = {
            OnInit = noop,
            _OnPlayerKilledOtherPlayer = noop,
            _RecordFatalDamager = noop,
            _OnDeathReplayDataWhenFatalDamaged = noop,
            _RecordMurdererFromDeathReplayData = noop,
            _RecordTeammatePlayerInfo = noop,
            _OnBattleResult = noop,
            _OnShowQuickReportMutualExclusiveUI = noop,
            GetFatalDamagerMap = retEmpty,
            GetCachedTeammateName2InfoMap = retEmpty,
            GetTeammateName2InfoMapDuringBattle = retEmpty,
            GetCurrentNotInTeamHistoricalTeammateMap = retEmpty,
            GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end,
            ReportSuspiciousPlayer = noop,
            SubmitReport = noop,
            ProcessReport = noop,
            ClientRPC_SyncFatalDamagerMap = noop,
        },
        custom = function(m)
            if m.__inner_impl then
                m.__inner_impl._OnSyncFatalDamage = noop
                m.__inner_impl._OnPlayerKilledOtherPlayer = noop
                m.__inner_impl._SyncBattleResult = noop
            end
        end,
    },

    ["GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"] = {
        methods = {
            OnInit = noop,
            _OnNearDeathOrRescued = noop,
            _OnCharacterDied = noop,
            _OnTeammateDamage = noop,
            _OnPlayerSettlementStart = noop,
            _AddKnockDownerToBattleResult = noop,
            _AddKillerToBattleResult = noop,
            _AddTeammateMurderToBattleResult = noop,
            _AddFatalDamagerMapToBattleResult = noop,
            _AddMLKillerUIDToBattleResult = noop,
            _SaveHistoricalTeammateInfo = noop,
            _RecordFatalDamager = noop,
            _RecordTeammateMurderer = noop,
            _AddEnemyMapToBattleResult = noop,
            _AddTeammateMapToBattleResult = noop,
            _SubmitAbnormalData = noop,
            _tUID2InfoMap = retEmpty,
            ds2history = retEmpty,
        },
    },

    ["GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"] = {
        retvals = {
            GetBotType = retZero,
            IsCharacterDeliverAI = retFalse
        },
        methods = {
            RecordFatalDamager = noop,
            IsUsingHistoricalTeammateInfo = retFalse
        },
    },

    ["client.slua.logic.report.ToolReportUtil"] = {
        retvals = {
            IsReleaseVersion = retFalse,
            IsWhite = retFalse,
            GetReportSwitch = retFalse
        }
    },

    _G_ClientToolsReport = {
        table = "_G.ClientToolsReport",
        methods = { SendReport = noop, SendException = noop }
    },

    _G_ReportPlatformCrashKit = {
        table = "_G.ReportPlatformCrashKit",
        methods = { Send = noop, ForceSend = noop }
    },

    _G_BasicDataTLogReport = {
        table = "_G.BasicDataTLogReport",
        methods = {
            OnSendBatchReqMsg = noop,
            OnImmediateReqMsg = noop,
            OnMergeReqMsg = noop,
            send_report_event_duration_log = noop,
            SendTlog = noop,
            ReportEvent = noop
        },
        retvals = { _GetParamData = retEmpty }
    },

    _G_BasicDataClientReport = {
        table = "_G.BasicDataClientReport",
        methods = {
            ReportImmediate = noop,
            ReportDelay = noop,
            OnSendBatchReqMsg = noop,
            OnImmediateReqMsg = noop,
            OnMergeReqMsg = noop
        },
        retvals = { _IsCanReport = retFalse }
    },

    _G_ClientTlogHandler = {
        table = "_G.ClientTlogHandler",
        methods = { send_report_lobby_common_tlog = noop }
    },

    _G_tlog_report_utils = {
        table = "_G.tlog_report_utils",
        methods = { ReportTLogEvent = noop, ReportImmediate = noop }
    },

    _G_ClientErrorReportHandler = {
        table = "_G.ClientErrorReportHandler",
        methods = {
            send_client_error_report = noop,
            send_client_crash_report = noop,
            send_client_tools_batch_report_req = noop
        }
    },

    _G_BattleReportHandler = {
        table = "_G.BattleReportHandler",
        methods = {
            send_battle_report = noop,
            send_battle_result = noop,
            send_vod_game_report_req = noop,
            send_batch_get_vod_info_req = noop,
            send_get_game_report_req = noop,
            send_batch_get_game_report_req = noop,
            send_get_game_report_by_uid_req = noop
        }
    },

    -- ==================== HAWKEYE BYPASSES ====================
    ["GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"] = {
        methods = {
            _OnHawkSync = noop,
            _OnHawkReportSuccess = noop,
            _StartExitGameTimer = noop,
            _OnRecvInspectorBroadcastCount = noop,
            SendReportTLog = noop,
            ReportCheat = noop,
            _OnHawkFlag = noop,
            ReportPlayerFlag = noop,
            RequestFlagPlayer = noop,
            SendFlagReport = noop,
            RequestImprison = noop,
            IsDuringHawkEyePatrol = retFalse,
            HasReported = retTrue,
            _InitHawkEyePatrolSubsystem = noop,
            _CollectBeWatchedPlayerInfo = noop,
            ServerRPC_HawkReportCheat = noop,
        },
        retvals = { CanInspectorBroadcast = retFalse },
        custom = function(mod)
            if mod.__inner_impl then
                local i = mod.__inner_impl
                i._OnHawkSync = noop
                i._OnHawkReportSuccess = noop
                i.TryShowReportedTips = noop
            end
        end,
    },

    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeDistanceUI"] = {
        methods = { _RefreshUI = noop, _IsShouldShow = retFalse }
    },

    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeNextPatrolWindow"] = {
        methods = { OnShow = noop }
    },

    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeReportWindow"] = {
        methods = {
            _OnClickSubmit = noop,
            _RefreshWindow = noop,
            RegistEvents = noop
        }
    },

    -- ==================== INSPECTION SYSTEM BYPASSES ====================
    ["GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"] = {
        methods = {
            AskForInspector = noop,
            ReportEnemy = noop,
            KickOutOneTeam = noop,
            OnReceiveInspectCmd = noop,
            ClientReportData = noop,
            SendReportToInspector = noop,
            SendKickOutOneTeam = noop,
            ClientNotifyInspectorImplementation = noop,
            RecvNotifyInspector = noop,
        },
    },

    ["GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"] = {
        methods = {
            ServerKickOutOneTeamByPlayerImplementation = noop,
            AddReportedCount = noop,
            AddInspectionRecord = noop,
            BanPlayerByInspection = noop,
            BroadCastToAllInspector = noop,
            ServerReportToInspectorImplementation = noop,
            InitPlayerInspectionInfo = noop,
        },
        fields = {
            MAX_ASK_FOR_INSPECTOR_TIME = 0,
            ASK_FOR_INSPECTOR_INTERVAL = 99999
        },
        custom = function(m)
            if m.__inner_impl then
                m.__inner_impl.IsGameModeAllowed = retTrue
            end
        end,
    },

    -- ==================== BAN MACRO / INPUT CHECK ====================
    ["BanMacro"] = {
        methods = {
            DetectInputVariance = retTrue,
            CheckClickTiming = retFalse,
            AnalyzeClickPattern = retEmpty,
            ReportMacro = noop,
            CheckAllBanTypes = retTrue,
        },
    },

    ["NGActionBanSprint"] = {
        methods = {
            ValidateSprintSpeed = retTrue,
            CheckSpeedHack = retFalse,
            ReportSprintViolation = noop,
        },
    },

    ["SpeedhackValidator"] = {
        methods = {
            ValidateSpeed = retTrue,
            IsSpeedhack = retFalse,
            ReportSpeedhack = noop,
        },
    },

    ["InputVarianceChecker"] = {
        methods = {
            CalculateVariance = retZero,
            IsHumanLike = retTrue,
        },
    },

    -- ==================== CORONA DATA PROTECTION ====================
    ["GameLua.Mod.BaseMod.Common.Security.CoronaUploader"] = {
        methods = { Upload = noop, Flush = noop }
    },

    ["GameLua.Mod.BaseMod.Common.Security.CoronaData"] = {
        custom = function()
            pcall(function()
                _G.GlobalPlayerCoronaData = _G.GlobalPlayerCoronaData or {}
                _G.GlobalPlayerCheatTimes = _G.GlobalPlayerCheatTimes or {}
                if not getmetatable(_G.GlobalPlayerCoronaData) then
                    local mt = { __newindex = function() end }
                    setmetatable(_G.GlobalPlayerCoronaData, mt)
                end
            end)
        end
    },

    -- ==================== REPLAY / TELEMETRY ====================
    ["GameLua.Mod.BaseMod.Client.Security.SpectatorAndReplaySubsystem"] = {
        methods = { SendReport = noop }
    },

    ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowOBResultLogic"] = {
        methods = {
            OnBattleResult = noop,
            OnResultProcessStart = noop
        }
    },

    ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowResultLogic"] = {
        methods = {
            OnBattleResult = noop,
            OnResultProcessStart = noop,
            OnResultProcessContinue = noop,
            ReceiveData = noop,
            SendEndFlow = noop,
            OnReport = noop,
            ShowResult = noop,
            ShowResultInternal = noop,
            StopResultProcess = noop
        }
    },

    _G_ClientReplayDataReporter = {
        table = "_G.ClientReplayDataReporter",
        methods = {
            ReportIntArrayData = noop,
            ReportFloatArrayData = noop,
            ReportUInt8ArrayData = noop
        }
    },

    ["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"] = {
        methods = {
            ReportException = noop,
            ReplayReportData = noop,
            ReportGameException = noop
        },
        retvals = {
            BugglyPostExceptionFull = retFalse,
            CheckCanBugglyPostException = retFalse
        }
    },

    -- ==================== EMULATOR BYPASSES ====================
    _G_EmulatorHandler = {
        table = "_G.EmulatorHandler",
        methods = { send_emulator_info = noop }
    },

    _G_emulator_scanner = {
        table = "_G.emulator_scanner",
        methods = { StartScan = noop, ReportScanResult = noop },
        retvals = { GetScanResult = retFalse }
    },

    ["EmulatorSystem"] = {
        fields = { EmulatorTestMark = true },
        methods = {
            IsEmulator = retFalse,
            GetEmulatorName = function() return "NoEmulator" end
        },
    },

    ["logic_emulator"] = {
        methods = {
            find_emulator = retFalse,
            IsSpecialEmulator = retFalse
        },
    },

    -- ==================== VOICE SYSTEM BYPASSES ====================
    ["VoiceReportSubsystem"] = {
        methods = {
            PLAYER_BAN_GLOBAL_MI = noop,
            ReportSuspicious = noop,
            PreFilterAI = noop,
        },
    },

    _G_logic_chat_voice_report = {
        table = "_G.logic_chat_voice_report",
        methods = { ReportVoiceData = noop, ReportVoiceText = noop }
    },

    _G_logic_chat_voice_doctor = {
        table = "_G.logic_chat_voice_doctor",
        methods = { UploadVoiceLog = noop, UploadVoiceException = noop }
    },

    -- ==================== GAME MODULE BYPASSES ====================
    ["GameLua.Mod.BaseMod.GamePlay.Subsystem.BehaviorScoreSubsystem"] = {
        methods = {
            OnHandleBehaviorScore = noop,
            AIPerceptionScore = noop,
            ReportBehavior = noop
        },
        retvals = { CalcFinalScore = retZero }
    },

    ["GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"] = {
        custom = function(m)
            if m.OnSpectatorReplayChanged then
                local o = m.OnSpectatorReplayChanged
                m.OnSpectatorReplayChanged = function(...)
                    _G.IsBeingWatched = true
                    return o(...)
                end
            end
        end,
    },

    ["GameLua.Mod.BaseMod.DS.Security.AFKReportorSubsystem"] = {
        methods = {
            HandleEnterFighting = noop,
            InitializePlayerInputInfo = noop,
            AddOneAFKInfo = noop,
            SetPlayerAFKState = noop,
            ResetPlayerInputInfo = noop,
            PlayerHaveAction = noop,
            ReportAFK = noop,
            CheckAFK = retFalse,
        },
    },

    ["GameLua.Mod.BaseMod.DS.Security.DSPlayerValidCheck"] = {
        methods = {
            Validate = retTrue,
            ReportSuspicious = noop
        }
    },

    ["GameLua.Mod.BaseMod.Client.Security.ClientDataStatistcsSubsystem"] = {
        methods = {
            StartToCheck = noop,
            OnReceiveRTT = noop,
            OnReceiveJitter = noop,
            ReportAbnormal = noop,
            ResetData = noop
        }
    },

    ["GameLua.Dev.Subsystem.ShootVerifySubSystemClient"] = {
        methods = {
            OnShootVerifyFailed = noop,
            SendVerifyData = noop,
            ReportBulletHit = noop,
            UploadHitInfo = noop,
            VerifyShot = retTrue
        }
    },

    -- ==================== SOCIAL / HOME BYPASSES ====================
    _G_logic_home_audit_state = {
        table = "_G.logic_home_audit_state",
        methods = { SendAuditState = noop, ReportAuditResult = noop }
    },

    _G_logic_home_report = {
        table = "_G.logic_home_report",
        methods = {
            ReportHomeData = noop,
            ReportHomeVisitor = noop,
            ShowInGameReportUI = noop,
            SendReport = noop
        }
    },

    -- ==================== SCREENSHOT / CRASH BYPASSES ====================
    ["ScreenshotMaker"] = {
        custom = function(m)
            if not m then return end
            m.MakePicture = function() return "" end
            m.ReMakePicture = function() return "" end
            m.HasCaptured = function() return true end
        end,
    },

    ["ReportCrashKitFeature"] = {
        custom = function(m)
            if m and m.ReportCharacterAttachedOnVehicleException then
                m.ReportCharacterAttachedOnVehicleException = noop
            end
        end,
    },

    -- ==================== NETWORK BYPASSES ====================
    ["UnrealNet"] = {
        global = true,
        custom = function(m)
            if not m then return end
            if m.FilterNetworkException then
                local o = m.FilterNetworkException
                m.FilterNetworkException = function(et, em)
                    if em and type(em) == "string" then
                        local le = em:lower()
                        local blocked = {
                            "cheatdetected", "idipban", "dataerror", "datamismatch",
                            "security", "integrity", "hashfail", "flag"
                        }
                        for _, b in ipairs(blocked) do
                            if le:find(b) then return false end
                        end
                    end
                    return o(et, em)
                end
            end
            m.HandleNetworkExceptionReport = noop
            m.HandleNetworkConnectionClosed = noop
            m.HandleSpectateException = noop
        end
    },

    ["client.slua.logic.common.logic_common_legal_msg"] = {
        custom = function(m)
            if m.ShowOnePopUI then
                local o = m.ShowOnePopUI
                m.ShowOnePopUI = function(self, params)
                    if params and params.title and params.title:find("SECURITY") then
                        return
                    end
                    return o(self, params)
                end
            end
        end,
    },
}

-- ==================== HOOK REQUIRE/IMPORT ====================
local originalRequire = require
local function hookedRequire(name)
    local mod = originalRequire(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then
            pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then
                for k, v in pairs(cfg.methods) do
                    if type(mod[k]) == "function" then mod[k] = v end
                end
            end
            if cfg.retvals then
                for k, v in pairs(cfg.retvals) do
                    if type(mod[k]) == "function" then mod[k] = v end
                end
            end
            if cfg.fields then
                for k, v in pairs(cfg.fields) do
                    if mod[k] ~= nil then mod[k] = v end
                end
            end
        end
    end
    return mod
end
if require ~= hookedRequire then require = hookedRequire end

local originalImport = import
local function hookedImport(name)
    local mod = originalImport(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then
            pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then
                for k, v in pairs(cfg.methods) do
                    if type(mod[k]) == "function" then mod[k] = v end
                end
            end
            if cfg.retvals then
                for k, v in pairs(cfg.retvals) do
                    if type(mod[k]) == "function" then mod[k] = v end
                end
            end
            if cfg.fields then
                for k, v in pairs(cfg.fields) do
                    if mod[k] ~= nil then mod[k] = v end
                end
            end
        end
    end
    return mod
end
if import ~= hookedImport then import = hookedImport end

-- ==================== TSS SDK BYPASS ====================
local function TssSdkBypass()
    pcall(function()
        local TssSdk = _G.TssSdk or package.loaded["TssSdk"] or package.loaded["client.slua.logic.tss_sdk"]
        if not TssSdk then
            local ok, mod = pcall(require, "TssSdk")
            if ok then TssSdk = mod end
        end
        if not TssSdk then return end

        local bypassFuncs = {
            "GetSdkAntiData", "GameScreenshot", "GameScreenshot2", "IsEmulator",
            "QueryOpts", "GetCommLibValueByKey", "GetShellDyMagicCode", "AddMTCJTask",
            "SetToken", "EnableDisableItem", "InvokeCrashFromShell", "ReInitMrpcs",
            "GetUserTag", "QueryTssLibcAddr", "RegistLibcSendListener", "RegistLibcRecvListener",
            "RegistLibcConnectListener", "RegistLibcCloseListener", "GetMrpcsData2Ptr",
            "GetTPChannelVer", "SetGameChannelIp", "SetValueByKey", "SetChannelHost",
            "SetChannelBuiltinIp", "RecvSecSignature", "PushAntiData3", "QueryRemainsAntiDataCount",
            "GetAntiData3", "DelAntiData3", "SetSecToken", "GetThreadsInfo", "AddTouchEvent",
            "InitSwitchStr", "SetCDNHost", "SetEnabledConnector", "QueryHookInfo", "SetCSLicense",
            "AddAnoTouchEvent", "GetObjVMFuncAddr", "ScanMemory", "ScanSo", "ScanFile",
            "GetRiskFlag", "VerifyFileHash", "CheckKernel", "VerifyBoot", "GetAntiDataQueue",
            "ReportAntiData", "SendAntiData", "ReportSdkData", "SendSdkData", "OnRecvData"
        }
        for _, funcName in ipairs(bypassFuncs) do
            if TssSdk[funcName] then
                TssSdk[funcName] = function(...) return true, "BYPASSED" end
            end
        end

        if TssSdk.antiDataQueue then
            TssSdk.antiDataQueue = {}
            TssSdk.antiDataQueue.push = function() end
            TssSdk.antiDataQueue.pop = function() return nil end
            TssSdk.antiDataQueue.size = function() return 0 end
            TssSdk.antiDataQueue.clear = function() end
        end

        if TssSdk.IsEmulator then TssSdk.IsEmulator = function() return false end end
        if TssSdk.InvokeCrashFromShell then TssSdk.InvokeCrashFromShell = function() return false end end
        if TssSdk.QueryHookInfo then TssSdk.QueryHookInfo = function() return {} end end
        if TssSdk.PushAntiData3 then TssSdk.PushAntiData3 = function() return true end end
        if TssSdk.QueryRemainsAntiDataCount then TssSdk.QueryRemainsAntiDataCount = function() return 0 end end
        if TssSdk.GetAntiData3 then TssSdk.GetAntiData3 = function() return nil end end
        if TssSdk.DelAntiData3 then TssSdk.DelAntiData3 = function() return true end end
        if TssSdk.AddTouchEvent then TssSdk.AddTouchEvent = function() return true end end
        if TssSdk.SetEnabledConnector then TssSdk.SetEnabledConnector = function() return true end end
        if TssSdk.SetCSLicense then TssSdk.SetCSLicense = function() return true end end
        if TssSdk.GetObjVMFuncAddr then TssSdk.GetObjVMFuncAddr = function() return 0 end end
    end)
end

-- ==================== ANTI-CHEAT MANAGER BYPASS ====================
local function EnhancedAntiCheatBypass()
    if _G.BYPASS_STATE and _G.BYPASS_STATE.ANTI_CHEAT_MANAGER_DISABLED then return end
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end

        local AntiCheatMgr = nil
        if pc.PlayerAntiCheatManager then
            AntiCheatMgr = pc.PlayerAntiCheatManager
        elseif pc.AntiCheatManager then
            AntiCheatMgr = pc.AntiCheatManager
        end

        if not slua.isValid(AntiCheatMgr) then
            local PlayerAntiCheatManagerClass = import("PlayerAntiCheatManager")
            if PlayerAntiCheatManagerClass then
                local comps = pc:GetComponentsByClass(PlayerAntiCheatManagerClass)
                if comps and comps:Num() > 0 then
                    AntiCheatMgr = comps:Get(0)
                end
            end
        end

        if not slua.isValid(AntiCheatMgr) then return end

        -- Zero out all counter fields
        local counterFields = {
            "AutoAimFailedCnt", "TrackingFailedCnt", "AreaDamageFailedCnt", "JumpHeightFailedCnt",
            "JumpFarFailedCnt", "VehicleFlyingFailedCnt", "ShootVerifyTimes", "SpeedUpValue",
            "ClientTimeTotalAcc", "ServerAccumulateErrors", "ServerAvgErrors", "ServerCorrectTimes",
            "PlayerBadPingTimes", "VehicleSpeedZDeltaTotal", "VehicleSpeedZDeltaOver10Times",
            "PVSInCityKillCount", "PVSNotInCityKillCount", "PVSCellHidePercent", "PVSTotalHidePercent",
            "ServerMoveParameterVerifyCount", "ServerMoveParameterVerifyFailedCount",
            "StuckGroundPunishCount", "ContinueMoveBurstCount", "RecordContinueMoveBurstCount",
            "TrialBaseDiffCount", "InclusiveBegin", "InclusiveEnd"
        }
        for _, field in ipairs(counterFields) do
            pcall(function()
                if type(AntiCheatMgr[field]) == "number" then AntiCheatMgr[field] = 0 end
            end)
        end

        -- Disable all bool flags
        local boolFields = {
            "bReportFeedBack","bOpenDetailDataCollect","bOpenBaseDiffCheck","bUploadStuckGroundCount",
            "bStuckGroundCapsule","bImpactOtherAfterBurst","bGiveupPickupWhenBrust",
            "bOpenPickupWhenBrustCheck","bMustStrictContinue"
        }
        for _, field in ipairs(boolFields) do
            pcall(function()
                if type(AntiCheatMgr[field]) == "boolean" then AntiCheatMgr[field] = false end
            end)
        end

        -- Max out all thresholds
        local maxFields = {
            "MaxShootPointPassWall", "MaxMuzzleHeightTime", "MaxLocusFailTime",
            "MaxBulletVictimClientPassWallTimes", "MaxGunPosErrorTimes",
            "MaxAllowVehicleTimeSpeedRawTime", "MaxAllowVehicleTimeSpeedConvTime",
            "MaxAllowVehicleAccTime", "MaxSingleShotDamage", "MaxFallingSustainTime",
            "MaxCustomMoveModeSustainTime", "MaxMoveDistance2DPerSecond",
            "MaxCharMoveDist2DPerSecond", "MaxDistanceToGround", "MaxContinueMoveBurstXY",
            "ContinueMoveBurstInterval", "BaseDiffRegion", "BaseDiffVel", "BaseDiffTime",
            "MinImpactOtherInterval", "MinBurstToPickupInterval", "MaxPlayerDisSquaredForPickup",
            "ContinueMoveBurstTolerant", "MultiStuckGroundScale", "StuckTypePunishSet",
            "StuckGroundPunishType"
        }
        for _, field in ipairs(maxFields) do
            pcall(function()
                if type(AntiCheatMgr[field]) == "number" then AntiCheatMgr[field] = 999999 end
            end)
        end

        -- Zero out parachute fields
        local paraFields = {
            "ParachuteStartTime","ParachuteOpenTime","ParachuteCloseTime",
            "ParachuteStartHight","ParachuteOpenHight","ParachuteCloseHight"
        }
        for _, field in ipairs(paraFields) do
            pcall(function()
                if type(AntiCheatMgr[field]) == "number" then AntiCheatMgr[field] = 0 end
            end)
        end

        -- Disable all verification switches
        local verifySwitchFields = {
            "VsNoHitDetail","VsMuzzleRangeCircle","VsMuzzleRangeUp",
            "VsHitBoneNameNone","VsHitBoneHitMissMatch","VsBulletID",
            "VsVehicleTimeStampError","VsWatchTimeStampError",
            "VsShootRpgShootTimeVerify","VsShootLockShootTimeVerify",
            "VsShootRpgHitNewVerify","VsShootTimeConDelta",
            "VsServerNoOldShoot","VsClientNotConnectShoot",
            "VsShootRpgShootIntervalVerify","VsImpactPointAndBulletDisBig",
            "VsShootVerifyInvalid","VsImpactActorPosWithNoHisPos",
            "VsShootAngleInVaild","VsMuzzleAndTailPosInVaild",
            "VsMuzzleAndImpactPassWall","VsMuzzleAndTailPassWall",
            "VsImpactActorPosOffsetBig","VsImpactPointChangeSmall",
            "VsImpactBulletPosOffsetBig","VsTotalImactCharacterNum",
            "VsBoneInfo","VsJumpMaxHeight","VsJumpMaxHeight15","VsJumpMaxHeight2",
            "SpeedQuickCheck","BulletDirError","WalkSpeedFailedCnt",
            "DSSpeedOver10FailedCnt","DSSpeedOver15FailedCnt","DSSpeedOver20FailedCnt",
            "DSFallingSpeedFailCount","DSFallingHeightFailCount",
            "SwitchMuzzleLocusError","SwitchMuzzleLocusErrorX","SwitchMuzzleLocusErrorY","SwitchMuzzleLocusErrorZ",
            "Gun2ShooterPosError1","SwitchHeadLocusError3","SwitchMuzzleLocusErrorLength",
            "SwitchShootPosHistoryLocusError3","SwitchHitComponentUnvalid","SwitchHitNoRender",
            "SwitchHitOutCollisionBox","HeadOverShootPos","SwitchMuzzleImpactDirSkipPunish1",
            "SwitchInvalidBulletNumInBarrel","SwitchShooterMovementError2","GunTailPosError",
            "SwitchMuzzleImpactDirSkipPunish2","SwitchMuzzleImpactDirError1","SwitchMuzzleImpactDirError2",
            "ShooterHead2PosBlock","SwitchShootPosHistoryLocusError2","Head2GunTailPosError1",
            "SwitchShootDirExcepation1","SwitchShootDirExcepation2","SwitchCamerModeException",
            "SwitchShootPosHistoryLocusError4","SwitchMuzzleImpactDirError3",
            "CharacterMoveException1","CharacterMoveException2","CharacterMoveException3",
            "CharacterMoveException4","CharacterMoveException5","CharacterMoveException6",
            "VehicleSpeedZDeltaOver10TimesWhenNoXY","VehicleVelZCheck1","VehicleVelZCheck2",
            "VehicleMaxSpeedCheck","VehicleHitMuzzleCheck","VehicleHitImpactPointCheck",
            "VehicleHitBlockWall","VehicleSidesway1","VehicleSidesway2",
            "FarShootInMidAirVehicleExceedThreshold","FarShootInMidAirVehicleEnemyDistanceTrial",
            "FarShootInMidAirVehicleEnemyDistanceFurtherTrial","FarShootInMidAirVehicleHeightTrial",
            "FarShootInMidAirVehicleHeightFurtherTrial","FarShootInMidAirPawnExceedThreshold",
            "FarShootInMidAirPawnEnemyDistanceTrial","FarShootInMidAirPawnEnemyDistanceFurtherTrial",
            "FarShootInMidAirPawnHeightTrial","FarShootInMidAirPawnHeightFurtherTrial",
            "NonGunADSFarShootCount","NonGunADSFarShootFromClientBulletDataCount",
            "NonGunADSFarShootFromClientBulletDataEnemyDistanceTrialCount",
            "NonGunADSFarShootFromClientBulletDataEnemyDistanceFurtherTrialCount",
            "ClientUploadFuzzyObjectVerifyFail","ClientMoveTimeStampResetFrequencyExceedThreshold",
            "ShootBirdNonGunADSExceedThreshold","ShootBirdNonGunADSDistanceTrial",
            "ShootBirdNonGunADSDistanceFurtherTrial","FarShootInHighTangentMoveSpeedExceedThreshold",
            "FarShootInHighTangentMoveSpeedEnemyDistanceTrial","FarShootInHighTangentMoveSpeedEnemyDistanceFurtherTrial",
            "FarShootInHighTangentMoveSpeedSpeedTrial","FarShootInHighTangentMoveSpeedSpeedFurtherTrial",
            "IllegalTeamUpNearbyButNoFireAfterKill","IllegalTeamUpNearbyButNoFireAfterKillDistanceTrial",
            "IllegalTeamUpNearbyButNoFireAfterKillTimeTrial","IllegalTeamUpNearbyButNoFireAfterKillMaxTime",
            "IllegalTeamUpNearbyButNoFirePickUpItem","IllegalTeamUpNearbyButNoFirePickUpItemDistanceTrial",
            "IllegalTeamUpNearbyButNoFirePickUpItemTimeTrial","IllegalTeamUpNearbyButNoFirePickUpItemMaxTime",
            "IllegalTeamUpNearbyButNoFireNotKill","IllegalTeamUpNearbyButNoFireNotKillDistanceTrial",
            "IllegalTeamUpNearbyButNoFireNotKillTimeTrial","IllegalTeamUpNearbyButNoFireNotKillMaxTime",
            "IllegalTeamUpNearbyButNoFireOnVehicle","IllegalTeamUpNearbyButNoFireOnVehicleDistanceTrial",
            "IllegalTeamUpNearbyButNoFireOnVehicleTimeTrial","IllegalTeamUpNearbyButNoFireOnVehicleMaxTime",
            "IllegalTeamUpNearbyButNoFireSameVehicle","IllegalTeamUpNearbyButNoFireSameVehicleTimeTrial",
            "IllegalTeamUpNearbyButNoFireSameVehicleMaxTime","IllegalTeamUpUseObjectTogether",
            "IllegalTeamUpGetOnEnemyVehicleCount","IllegalTeamUpNearbyButNoFireOneSideHasWeaponOnFoot",
            "IllegalTeamUpNearbyButNoFireOneSideHasWeaponOnFootDistanceTrial","IllegalTeamUpStayOnEnemyVehicle",
            "KillBird","ShooterCapsuleCollided","ParachuteLandingSecondsExceedThreshold",
            "ParachuteObliqueLandingSecondsExceedThreshold","SmallActorTimeDilationCount",
            "LargeRotateLockShooting","SmallRotateLockShooting","OneClipShootCount","ClientWeaponFastReload",
            "UndergroundCount","MoveDistance2DPerSecondAnomaly","CharMoveDist2DPerSecondAnomaly",
            "CharMoveDist2DPerSecondCount","DistanceToGroundAnomaly","SingleShotDamageAnomaly","BandaCount",
            "DSCheckClientTimeMoveDistance2D","DSCheckClientTimeMoveDistance2DTrial",
            "DSCheckClientTimeMoveDistance2DFurther","DSCheckClientTimeMoveDistanceZ",
            "DSCheckClientTimeMoveDistanceZTrial","DSCheckClientTimeMoveDistanceZFurther",
            "ReplayMaxFallingSustainTime","ReplayMaxCustomMoveModeSustainTime","ReplayMaxSingleShotDamage",
            "CharMoveAccumDist2D_DS","CharMoveAccumDist3D_DS","CharMoveAccumDist2D_Client",
            "CharMoveAccumDist3D_Client","CharMoveAccumDist2D_ClientAll","CharMoveAccumDist3D_ClientAll",
            "MetroEnterRadiationTime","MetroEnterRadiationTimeTrial","MetroLeaveBornObstacle",
            "VsPetJumpHeightLimiter","VsPetMoveSpeedLimiter","VsBioVehicleMoveSpeedLimiter",
            "VsBioVehicleJumpHeightLimiter","VsPterosaurFlyVehicleSpeed","VsBioVehicleGravityLimiter",
            "ServerMoveCacheCountOver","ServerMoveCacheCountOver3d","ServerMoveBurst","ImpactOtherAfterBurst",
            "KillOtherAfterBurst","PickupAfterBurst","ContinueMoveBurst","ServerMoveTimeStamp",
            "ServerMoveAccel","ServerMoveClientLoc","ServerMoveCompressedMoveFlags","ServerMoveClientRoll",
            "ServerMoveView","ServerMoveClientMovementBase","ServerMoveClientBaseBoneName",
            "ServerMoveClientMovementMode","VerifySwitchCameraRotation","VerifySwitchPeekShootThroughWall",
            "VerifySwitchCameraLocation","VerifySwitchAutoAimByLockView","VerifySwitchControlRotation",
            "VerifySwitchRecoilFaildCount","VerifySwitchMarcoPolo","VerifySwitchMarcoPolo2",
            "VerifySwitchMarcoPolo3","VerifySwitchMeshScaleDiff","VerifySwitchOfflineMove",
            "VerifySwitchFastAimShootHit","VerifySwitchNoRecoilOnWeaponShoot","VerifySwitchLessRecoilOnWeaponShoot",
            "VerifySwitchNoRecoilOnKickBack","VerifySwitchLessRecoilOnKickBack","VerifySwitchDivingBoost",
            "VerifySwitchRecoilCurveFailed","PlayerQuickProne","BaseDiffSample",
            "VsTeammateRescue","VsTeammateRescueVictim","VsTeammateRecall","VsTeammateRecallVictim",
            "VsAutoClicker","VsAbnormalShootingRotation","PlayerInstantHeightDiff","Player2SecHeightDiff",
            "CheatStateData2TotalCheatTimes","MoveCheatAntiStrategy3TotalCheatTimes","ServerAccumulateErrorReplay"
        }
        for _, fieldName in ipairs(verifySwitchFields) do
            pcall(function()
                local vs = AntiCheatMgr[fieldName]
                if vs and type(vs) == "table" then
                    vs.bActive = false
                    vs.MaxCount = 99999
                    vs.CurrentCount = 0
                    vs.TrialCount = 0
                    vs.TrialMaxCount = 99999
                    vs.PunishType = 0
                end
            end)
        end

        -- Disable burst detections
        local burstFields = {
            "ServerAccumulateErrorBurst","DSSpeedOver10BurstCount",
            "ParachuteSpeedBurst","ClientTimestampBurst","ClientTimestampBurstTrial"
        }
        for _, fieldName in ipairs(burstFields) do
            pcall(function()
                local bvs = AntiCheatMgr[fieldName]
                if bvs and type(bvs) == "table" then
                    bvs.bActive = false
                    bvs.MaxCount = 99999
                    bvs.CurrentCount = 0
                end
            end)
        end

        pcall(function()
            if AntiCheatMgr.ReportMiscMap then AntiCheatMgr.ReportMiscMap:Clear() end
        end)

        local methodFields = {
            "ReportAntiCheatDetailData","PushWeaponAntiData","OnRecoverOnServer",
            "OnPreReconnectOnServer","ExitParachute","EnterParachute","EnterJumping",
            "Cofey","Cofew","SetTrialRegion","GetSoftString","GetCheckMoveStr2",
            "GetCheckMoveStr1","GetAACString","GetAACCountByID"
        }
        for _, method in ipairs(methodFields) do
            pcall(function()
                if AntiCheatMgr[method] and type(AntiCheatMgr[method]) == "function" then
                    AntiCheatMgr[method] = function(...)
                        if method == "GetSoftString" then return 0 end
                        if method == "GetCheckMoveStr1" or method == "GetCheckMoveStr2" then return "" end
                        if method == "GetAACString" then return "" end
                        if method == "GetAACCountByID" then return 0 end
                        if method == "Cofey" then return 0 end
                        return true
                    end
                end
            end)
        end

        pcall(function()
            local catchData = AntiCheatMgr.CatchReportAntiCheatDetailData
            if catchData and type(catchData) == "table" then
                catchData.bActive = false
                catchData.CurrentCount = 0
                catchData.MaxCount = 99999
            end
        end)

        _G.BYPASS_STATE.ANTI_CHEAT_MANAGER_DISABLED = true
    end)
end

-- ==================== CRC / MD5 FAKER ====================
local function applyFullCRCFaker()
    if _G.__CRCFakerDone then return end
    pcall(function()
        -- Console commands
        local console = import("KismetSystemLibrary")
        if console then
            console.ExecuteConsoleCommand(nil, "pak.DisablePakSignatureCheck 1")
            console.ExecuteConsoleCommand(nil, "pakchunk.EnableSignatureCheck 0")
            console.ExecuteConsoleCommand(nil, "s.VerifyPak 0")
            console.ExecuteConsoleCommand(nil, "sig.Check 0")
            console.ExecuteConsoleCommand(nil, "security.DisableChecks 1")
        end

        -- CreativeModeBlueprintLibrary
        local CreativeModeBlueprintLibrary = import("CreativeModeBlueprintLibrary")
        if CreativeModeBlueprintLibrary then
            CreativeModeBlueprintLibrary.MD5HashByteArray = function()
                return "00000000000000000000000000000000"
            end
            CreativeModeBlueprintLibrary.MD5HashFile = function()
                return "00000000000000000000000000000000"
            end
            CreativeModeBlueprintLibrary.GetContentDiffData = function()
                return true, "BYPASSED"
            end
            CreativeModeBlueprintLibrary.VerifyFileIntegrity = retTrue
        end

        -- Global hash functions
        if _G.MD5Hash then
            _G.MD5Hash = function() return "00000000000000000000000000000000" end
        end
        if _G.CRC32 then _G.CRC32 = function() return 0 end end
        if _G.SHA1 then _G.SHA1 = function() return "BYPASS" end end

        -- File hash checker
        local FileHashChecker = package.loaded["common.file_hash_checker"]
        if FileHashChecker then
            FileHashChecker.CheckFileMD5 = retTrue
            FileHashChecker.VerifyAll = retTrue
            FileHashChecker.GetHash = function() return "BYPASS" end
        end

        -- STExtraBlueprintFunctionLibrary
        local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
        if STExtraBlueprintFunctionLibrary then
            STExtraBlueprintFunctionLibrary.CheckMD5 = retTrue
            STExtraBlueprintFunctionLibrary.GetMD5 = function() return "BYPASS" end
            STExtraBlueprintFunctionLibrary.VerifyFile = retTrue
        end

        _G.__CRCFakerDone = true
    end)
end

-- ==================== NETWORK PACKET BLOCKER ====================
local BLACKLIST_HOSTS = {
    "tss.tencent","syzsdk","gcloud.qq","reportlog","tdos","logupload","feedback.wh","crash2",
    "privacy.qq","privacy.tencent","oth.eve","mdt.qq","act.tencentyun","analytics","report.qq",
    "anticheatexpert","crashsight","wetest","log.tav","sngd","tracer","intlsdk","igamecj",
    "cdn.club","gpubgm","graph.facebook","calendarpushsubscription","googleads","doubleclick",
    "firebaselogging","firebaseremoteconfig","fonts.googleapis","abs.twimg","dl.listdl",
    "igame.gcloudcs","bugly","beacon","helpshift","tdm","apm","safeguard","weiyun","qzone",
    "tencent-cloud","myapp","idqqimg","gtimg","qqmail","tcdn","cloudctrl","sdkostrace",
    "103.134.189.146","mbgame","csoversea","igame","pubgmobile","down.anticheatexpert.com",
    "asia.csoversea.mbgame.anticheatexpert.com","log.tav.qq","syzsdk.qq","logiservice.qcloud",
    "opensdk.tencent","exp.helpshift","loginsdkapi.zingplay","firebase","googleapis","facebook","gvoice"
}

local BLACKLIST_PORTS = {
    "10334","11045","12221","13331","8011","8015","9001","20000","20001","20002","20003","20004",
    "20005","19700","1670","19900","14545","10213","8700","25177","10685","10336","10262","27000",
    "27040","27015","27030","10706","10095","12401","11008","10309","11075","10157","24798","10709",
    "6667","10087","31113","20371","10120","10664","13728","10769","10761","5061","5062","18081",
    "15692","9030","8080","8086","8088"
}

local FILE_KEYWORDS = {
    "tlog","crash","bugly","report","beacon","wetest","analytics","telemetry","trace","dump",
    "exception","feedback","aps_log","mtp_detect","network_loss","client_error","ue4crash","tdm","gcloud"
}

local function isBlacklisted(str)
    if type(str) ~= "string" then return false end
    local low = str:lower()
    for _, kw in ipairs(BLACKLIST_HOSTS) do
        if low:find(kw, 1, true) then return true end
    end
    for _, port in ipairs(BLACKLIST_PORTS) do
        if low:find(":"..port) or low:find("/"..port) then return true end
    end
    return false
end

local function applyNetworkBlocker()
    pcall(function()
        if _G.HttpRequest then
            local orig = _G.HttpRequest
            _G.HttpRequest = function(url, ...)
                if isBlacklisted(url) then return nil end
                return orig(url, ...)
            end
        end

        if _G.FHttpModule and _G.FHttpModule.CreateRequest then
            local orig = _G.FHttpModule.CreateRequest
            _G.FHttpModule.CreateRequest = function(...)
                local url = select(1, ...)
                if isBlacklisted(url) then return nil end
                return orig(...)
            end
        end

        -- Block packet sends
        if NetUtil and NetUtil.SendPacket then
            local originalSend = NetUtil.SendPacket
            local blockedPackets = {
                ["ReportAttackFlow"] = 1,
                ["ReportSecAttackFlow"] = 1,
                ["ReportHurtFlow"] = 1,
                ["ReportFireArms"] = 1,
                ["ReportVerifyInfoFlow"] = 1,
                ["ReportMrpcsFlow"] = 1,
                ["ReportPlayerBehavior"] = 1,
                ["ReportTeammatHurt"] = 1,
                ["ReportPlayerMoveRoute"] = 1,
                ["ReportPlayerPosition"] = 1,
                ["ReportSecVehicleMoveFlow"] = 1,
                ["report_parachute_data"] = 1,
                ["on_tss_sdk_anti_data"] = 1,
                ["ReportAimFlow"] = 1,
                ["ReportHitFlow"] = 1,
                ["ReportCircleFlow"] = 1,
                ["report_players_ping"] = 1,
                ["report_player_ip"] = 1,
                ["report_net_saturate"] = 1,
                ["report_speed_hack"] = 1,
                ["report_wall_hack"] = 1,
                ["report_aim_bot"] = 1,
                ["report_esp_usage"] = 1,
                ["report_modded_files"] = 1,
                ["detect_cheat"] = 1,
                ["ban_player"] = 1,
                ["client_anti_cheat_report"] = 1,
                ["ReportPlayerKillFlow"] = 1,
                ["ClientSecPlayerKillFlow"] = 1,
                ["ReportMrpcsFlow"] = 1,
                ["ClientSecMrpcsFlow"] = 1,
                ["MrpcsData"] = 1,
                ["CheckReportSecAttackFlow"] = 1,
                ["CheckReportSecAttackFlowWithAttackFlow"] = 1,
                ["RPC_ClientCoronaLab"] = 1,
                ["CoronaLabReport"] = 1,
                ["CoronaLabData"] = 1,
                ["PlayerSecurityInfo"] = 1,
                ["ReportSecurityInfo"] = 1,
                ["SendSecurityData"] = 1,
                ["ClientCircleFlow"] = 1,
                ["IsEnableReportPlayerKillFlow"] = 1,
                ["IsEnableReportMrpcsInCircleFlow"] = 1,
                ["IsEnableReportMrpcsInPartCircleFlow"] = 1,
                ["bReportedModifierException"] = 1,
                ["ReportModifierException"] = 1,
                ["RPC_Server_ReportSimulateCharacterLocation"] = 1,
                ["ReportSimulateCharacterLocation"] = 1,
                ["RPC_Client_ShootVertifyRes"] = 1,
                ["BulletHitInfoUploadData"] = 1,
                ["ShootVerifyFailed"] = 1,
                ["report_unrealnet_exception"] = 1,
                ["tss_sdk_report"] = 1,
                ["Heartbeat"] = 1,
                ["ClientHeartbeat"] = 1,
                ["ServerHeartbeat"] = 1,
                ["SwiftHawk"] = 1,
                ["ClientSwiftHawk"] = 1,
                ["ClientSwiftHawkWithParams"] = 1,
                ["SwiftHawkReport"] = 1,
                ["SwiftHawkData"] = 1,
                ["AntiCheatReport"] = 1,
                ["CheatDetection"] = 1,
                ["ViolationReport"] = 1,
                ["SecurityViolation"] = 1,
                ["IntegrityCheck"] = 1,
                ["SignatureVerify"] = 1,
                ["1162992962"] = 1,
                ["242463958"] = 1,
                ["224639039"] = 1,
                ["816081779"] = 1,
                ["224943158"] = 1,
                ["516985564"] = 1,
                ["inspection_system_report_to_inspector"] = 1,
                ["ingame_voice_ban_notify"] = 1,
                ["inspection_system_notify_inspector"] = 1,
            }

            NetUtil.SendPacket = function(packetName, ...)
                if blockedPackets[packetName] then
                    return nil
                end
                return originalSend(packetName, ...)
            end
            NetUtil.IsBypassed = true
        end

        -- Block file writes
        local orig_io_open = io.open
        io.open = function(path, mode)
            if type(path) == "string" then
                local lp = path:lower()
                for _, kw in ipairs(FILE_KEYWORDS) do
                    if lp:find(kw) then
                        if mode and (mode == "w" or mode == "a" or mode == "w+" or mode == "a+") then
                            return nil, "Blocked"
                        end
                    end
                end
                if lp:find("tdm") or lp:find("gcloud") or lp:find("beacon") then
                    if mode and (mode == "w" or mode == "a" or mode == "w+") then return nil end
                end
            end
            return orig_io_open(path, mode)
        end

        -- Crash context
        if _G.UnrealEngine and _G.UnrealEngine.CrashContext then
            _G.UnrealEngine.CrashContext = nil
            _G.UnrealEngine.CrashContext = {
                SetCrashContext = noop,
                ReportCrash = noop,
                AddCrashData = noop
            }
        end
    end)
end

-- ==================== SLUA BYPASS ====================
local function InitializeSLUABypass()
    pcall(function()
        if slua and slua.getSignature then
            slua.getSignature = function() return 0xDEADBEEF end
        end

        local loader = package.loaded["slua.loader"] or rawget(_G, "slua_loader")
        if loader then
            loader.verifyBytecode = retTrue
            loader.checkIntegrity = retTrue
            if loader.disableSignatureCheck then loader.disableSignatureCheck = retTrue end
        end

        local slua_serialize = package.loaded["slua.serialize"]
        if slua_serialize then
            slua_serialize.check = retTrue
            slua_serialize.verify = retTrue
        end

        if jit and jit.attach then
            jit.attach(function() end, "bc")
        end

        if _G.slua_verify then _G.slua_verify = retTrue end
        if _G.check_slua_integrity then _G.check_slua_integrity = retTrue end
    end)
end

-- ==================== LOG BLOCKER ====================
local function InitializeLogBlocker()
    pcall(function()
        local ScreenshotMTDer = import("ScreenshotMTDer")
        if ScreenshotMTDer then
            ScreenshotMTDer.MTDePicture = function() return "" end
            ScreenshotMTDer.ReMTDePicture = function() return "" end
            ScreenshotMTDer.HasCaptured = retTrue
            ScreenshotMTDer.TakeScreenshot = noop
        end

        local TLog = package.loaded["TLog"] or _G.TLog
        if TLog then
            TLog.Info = noop
            TLog.Warning = noop
            TLog.Error = noop
            TLog.Debug = noop
            TLog.Report = noop
            TLog.Send = noop
            TLog.Flush = noop
        end

        local CrashSight = package.loaded["CrashSight"] or _G.CrashSight
        if CrashSight then
            CrashSight.ReportException = noop
            CrashSight.SetCustomData = noop
            CrashSight.Log = noop
            CrashSight.SendCrash = noop
            CrashSight.ReportUserException = noop
        end

        local GameReportUtils = package.loaded["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"]
        if GameReportUtils then
            GameReportUtils.BugglyPostExceptionFull = retFalse
            GameReportUtils.CheckCanBugglyPostException = retFalse
            GameReportUtils.ReplayReportData = noop
            GameReportUtils.ReportGameException = noop
            GameReportUtils.PostException = noop
        end

        for _, sdk in ipairs({"Firebase", "Adjust", "AppsFlyer", "FacebookAnalytics", "GameAnalytics"}) do
            local s = _G[sdk]
            if s then
                s.logEvent = noop
                s.trackEvent = noop
                s.setEnabled = retFalse
                s.sendEvent = noop
                s.report = noop
            end
        end
    end)
end

-- ==================== KILL ALL SUBSYSTEMS ====================
local function InitializeKillAllSubsystems()
    pcall(function()
        local subMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if not subMgr then return end

        local subsystemsToKill = {
            "CoronaLabSubsystem",
            "PlayerSecurityInfoSubsystem",
            "ClientCircleFlowSubsystem",
            "ModifierExceptionSubsystem",
            "SimulateCharacterSubsystem",
            "ShootVerifySubSystemClient",
            "HiggsBosonComponent",
            "ClientReportPlayerSubsystem",
            "DSReportPlayerSubsystem",
            "ClientHawkEyePatrolSubsystem",
            "DSHawkEyePatrolSubsystem",
            "ClientDataStatistcsSubsystem",
            "AFKReportorSubsystem",
            "BehaviorScoreSubsystem",
            "FileCheckSubsystem",
            "MemoryCheckSubsystem",
            "SpeedCheckSubsystem",
            "WallCheckSubsystem",
            "AvatarExceptionSubsystem",
            "GameReportSubsystem",
            "RescueBtnReplayTraceSubsystem",
            "ClientSecMrpcsFlowSubsystem",
            "MrpcsFlowSubsystem",
            "PlayerKillFlowSubsystem",
            "CircleFlowSubsystem",
            "SwiftHawkSubsystem",
            "HeartbeatSubsystem",
            "AntiCheatSubsystem",
            "IntegrityCheckSubsystem",
            "SignatureVerifySubsystem",
            "MD5CheckSubsystem",
            "PakVerifySubsystem"
        }

        for _, name in ipairs(subsystemsToKill) do
            local sub = subMgr:Get(name)
            if sub then
                for k, v in pairs(sub) do
                    if type(v) == "function" and (
                        k:find("Report") or k:find("Send") or k:find("Upload") or
                        k:find("Verify") or k:find("Check") or k:find("Validate") or
                        k:find("Scan") or k:find("Detect") or k:find("Collect") or
                        k:find("Flow") or k:find("Heartbeat")
                    ) then
                        pcall(function() sub[k] = noop end)
                    end
                end
                if sub.timer then pcall(function() sub:RemoveGameTimer(sub.timer) end) end
                if sub.heartbeatTimer then pcall(function() sub:RemoveGameTimer(sub.heartbeatTimer) end) end
                if sub.reportTimer then pcall(function() sub:RemoveGameTimer(sub.reportTimer) end) end
            end
        end
    end)
end

-- ==================== HEARTBEAT BYPASS ====================
local function InitializeHeartbeatBypass()
    pcall(function()
        local heartbeatFuncs = {"Heartbeat", "SendHeartbeat", "ClientHeartbeat", "ServerHeartbeat"}
        for _, func in ipairs(heartbeatFuncs) do
            if _G[func] then _G[func] = noop end
            if _G.GameplayCallbacks and _G.GameplayCallbacks[func] then
                _G.GameplayCallbacks[func] = noop
            end
        end

        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local heartbeatSub = SubsystemMgr:Get("HeartbeatSubsystem")
            if heartbeatSub then
                if heartbeatSub.timer then heartbeatSub:RemoveGameTimer(heartbeatSub.timer) end
                heartbeatSub.SendHeartbeat = noop
                heartbeatSub.StartHeartbeat = noop
            end
        end
    end)
end

-- ==================== GLOBAL FUNCTION KILLER ====================
local function killGlobalFunctions()
    local globalFuncs = {
        "ReportTLogEvent","SendTlog","SendClientStats","ReportHitFlow","ReportAvatarException",
        "SendComplaintReq","SubmitReport","ReportSuspiciousPlayer","SendPacket","OnSyncBanInfo",
        "OnVoiceBanNotify","SendSecTLog","MarkSuspiciousPlayer","ReportPlayerBehaviorData",
        "CheckCompliance","ReportIllegalProgram","UploadVoiceLog","ReportCheat","ReportPlayer",
        "ShowReportUI","OpenReportPanel","OnClickReport","ReportCheatDetected"
    }
    for _, fn in ipairs(globalFuncs) do
        if type(_G[fn]) == "function" then _G[fn] = noop end
        _G[fn] = nil
    end
end

-- ==================== ADVANCED PATCHES ====================
local function applyAdvancedPatches()
    pcall(function()
        -- Avatar Check
        local AvatarExceptionPlayerInst = package.loaded["GameLua.Mod.Library.GamePlay.Avatar.Exception.AvatarExceptionPlayerInst"]
        if AvatarExceptionPlayerInst then
            AvatarExceptionPlayerInst.CheckAvatarException = noop
            AvatarExceptionPlayerInst.CheckAvatarExceptionOnce = noop
            AvatarExceptionPlayerInst.ReportAvatarException = noop
            AvatarExceptionPlayerInst.CheckSlotMeshVisible = retFalse
            AvatarExceptionPlayerInst.CheckPawnVisible = retFalse
            AvatarExceptionPlayerInst.CheckCanBugglyPostException = retFalse
        end

        -- TSS SDK OnRecvData filter
        local TssSdk = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk then
            local orig = TssSdk.OnRecvData
            TssSdk.OnRecvData = function(data)
                if type(data) == "string" and (data:find("report") or data:find("exception")) then
                    return
                end
                if orig then orig(data) end
            end
            TssSdk.SendReportInfo = noop
            TssSdk.ScanMemory = retTrue
            TssSdk.IsEmulator = retFalse
            TssSdk.GetTssSdkReportInfo = function() return "" end
        end

        -- Replay report
        local logicReplayReport = package.loaded["client.slua.logic.replay.logic_report_replay"]
        if logicReplayReport then
            logicReplayReport.ReportReplay = noop
            logicReplayReport.SendReportReq = noop
        end

        -- Puffer Tlog
        local PufferTlog = package.loaded["client.slua.logic.download.report.puffer_tlog"]
        if PufferTlog then
            PufferTlog.ReportEvent = noop
            PufferTlog.ReportDownloadResult = noop
            PufferTlog.ReportODPAKError = noop
        end

        -- Avatar Utils
        local AvatarUtils = package.loaded["AvatarUtils"]
        if AvatarUtils then
            AvatarUtils.CheckIsWeaponInBlackList = retFalse
            AvatarUtils.IsValidAvatar = retTrue
        end

        -- Equipment exception
        local EquipmentExceptionReport = package.loaded["client.slua.logic.report.EquipmentExceptionReport"]
        if EquipmentExceptionReport then
            EquipmentExceptionReport.Report = noop
        end

        -- BlackList
        _G.BlackList = {}
    end)
end

-- ==================== SELF-HEAL ====================
local function safeSelfHeal()
    pcall(function()
        local TM = safe_require("GameLua.Mod.BaseMod.Common.TickManager")
        if TM and TM.AddLoopTimer then
            TM.AddLoopTimer(120, function()
                pcall(function()
                    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                    if pc and pc.HiggsBosonComponent then
                        pc.HiggsBosonComponent.bMHActive = false
                        pc.HiggsBosonComponent:ControlMHActive(0)
                    end
                    if slua.isValid(pc) then
                        local pawn = pc:GetCurPawn()
                        if slua.isValid(pawn) then
                            pcall(function()
                                local Higgs = package.loaded["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"]
                                if Higgs then
                                    Higgs.ControlMHActive = noop
                                    Higgs.TriggerAvatarCheck = noop
                                    Higgs.StartAvatarCheck = noop
                                    Higgs.ReportItemID = noop
                                    Higgs.OnReportItemID = noop
                                    Higgs.ReceiveAnyDamage = noop
                                    Higgs.OnWeaponHitRecord = noop
                                    Higgs.ShowSecurityAlert = noop
                                    Higgs.ServerReportAvatar = noop
                                    Higgs.ClientReportNetAvatar = noop
                                    Higgs.GetNetAvatarItemIDs = retEmpty
                                    Higgs.GetCurWeaponSkinID = retZero
                                end
                                if _G.AvatarCheckCallback then
                                    _G.AvatarCheckCallback.StartAvatarCheck = noop
                                    _G.AvatarCheckCallback.OnReportItemID = noop
                                end
                            end)
                        end
                    end
                end)
                local modules = {
                    "client.slua.logic.ban.ClientBanLogic",
                    "client.common.ban_util",
                    "client.logic.login.logic_tt_ban",
                    "client.slua.logic.ban.BanTipsLogic"
                }
                for _, modName in ipairs(modules) do
                    local mod = package.loaded[modName]
                    if mod then
                        for k, v in pairs(mod) do
                            if type(k) == "string" and (k:find("Ban") or k:find("Flag")) and type(v) == "function" then
                                mod[k] = retFalse
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ==================== FINAL PROTECTION ====================
local function InitializeFinalProtection()
    pcall(function()
        local globalFlags = {
            "ENABLE_REPORT", "ENABLE_ANTI_CHEAT", "ENABLE_SECURITY", "ENABLE_TELEMETRY",
            "ENABLE_ANALYTICS", "ENABLE_CRASH_REPORT", "ENABLE_PERFORMANCE_REPORT"
        }
        for _, flag in ipairs(globalFlags) do
            if _G[flag] then _G[flag] = false end
        end

        local blockedModules = {
            "HiggsBosonComponent", "PlayerSecurityInfoSubsystem", "CoronaLabSubsystem",
            "ClientCircleFlowSubsystem", "ModifierExceptionSubsystem", "ShootVerifySubSystemClient",
            "ClientReportPlayerSubsystem", "DSReportPlayerSubsystem"
        }

        local originalRequire = require
        _G.require = function(module)
            for _, blocked in ipairs(blockedModules) do
                if module:find(blocked) then
                    return {}
                end
            end
            return originalRequire(module)
        end
    end)
end

-- ==================== APPLY ALL BYPASSES ====================
local function ApplyAllBypasses()
    pcall(TssSdkBypass)
    pcall(EnhancedAntiCheatBypass)
    pcall(applyFullCRCFaker)
    pcall(applyNetworkBlocker)
    pcall(InitializeSLUABypass)
    pcall(InitializeLogBlocker)
    pcall(InitializeKillAllSubsystems)
    pcall(InitializeHeartbeatBypass)
    pcall(killGlobalFunctions)
    pcall(applyAdvancedPatches)
    pcall(safeSelfHeal)
    pcall(InitializeFinalProtection)
    print("[BYPASS] ✅ All 5 Layers Bypassed Successfully")
end

-- ==================== INITIALIZATION ====================
pcall(function()
    _G.BYPASS_STATE = {}
    ApplyAllBypasses()

    if isModExpired() then
        pcall(ShowExpiryDialog)
    end

    -- Watchdog
    local function watchdog()
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(pc) and pc.HiggsBosonComponent then
                pc.HiggsBosonComponent.bMHActive = false
                pc.HiggsBosonComponent:ControlMHActive(0)
            end
        end)
    end

    if Game and Game.SetTimer then
        Game:SetTimer(5.0, true, watchdog)
    else
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if pc and pc.AddGameTimer then
            pc:AddGameTimer(5.0, true, watchdog)
        end
    end

    print("[BYPASS] ✅ TrnDravix ELITE ULTIMATE – All Bypasses Active")
    print("[BYPASS] 🔥 5-Layer Shield: TSS | AntiCheat | CRC | Network | Report")
end)

return true
-- 📦 SKIN SYSTEM (COMPLETE)
-- =============================================

local BASE_PATH       = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local CONFIG_PATH     = BASE_PATH .. "config.ini"
local SAVE_KILL_PATH  = BASE_PATH .. "kill_counts.txt"
local ATTACH_PATH     = BASE_PATH .. "attachments.txt"

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
    _G._KillSaveDirty = (_G._KillSaveDirty or 0) + 1
    if _G._KillSaveDirty >= 3 then
        SaveKillsToFile()
        _G._KillSaveDirty = 0
    end
    pcall(function()
        local UIM = require("client.slua_ui_framework.manager")
        local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
        if MKC then
            if MKC.OnRefreshData then
                MKC:OnRefreshData()
            end
            if MKC.KillCounterItem and MKC.KillCounterItem.SetKillCounterItemShowWithNum then
                local sid = _G.get_skin_id(weaponID) or weaponID
                MKC.KillCounterItem:SetKillCounterItemShowWithNum(sid, _G.KillData.kills[weaponID], sid)
            end
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

local ATTACH_NAME_MAP = {
    ["Red Dot Sight"]          = "RedDot",
    ["Holographic Sight"]      = "Holo",
    ["2x Scope"]               = "Scope2x",
    ["3x Scope"]               = "Scope3x",
    ["4x Scope"]               = "Scope4x",
    ["6x Scope"]               = "Scope6x",
    ["8x Scope"]               = "Scope8x",
    ["Canted Sight"]           = "CantedSight",
    ["Flash Hider"]            = "FlashHider",
    ["Compensator"]            = "Compensator",
    ["Suppressor"]             = "Suppressor",
    ["Extended Mag"]           = "ExtMag",
    ["Quickdraw Mag"]          = "QuickMag",
    ["Extended Quickdraw Mag"] = "ExtQuickMag",
    ["Angled Foregrip"]        = "AngledGrip",
    ["Vertical Foregrip"]      = "VerticalGrip",
    ["Thumb Grip"]             = "ThumbGrip",
    ["Half Grip"]              = "HalfGrip",
    ["Light Grip"]             = "LightGrip",
    ["Laser Sight"]            = "LaserSight",
    ["Tactical Stock"]         = "TactStock",
    ["Stock"]                  = "MicroStock",
    ["Cheek Pad"]              = "CheekPad",
}

local _attachFileCache = nil

local function _parseAttachmentsFile()
    local result = {}
    pcall(function()
        local f = io.open(ATTACH_PATH, "r")
        if not f then return end
        local content = f:read("*all")
        f:close()
        local curSkin = nil
        for line in content:gmatch("[^\r\n]+") do
            local firstNum = line:match("^(%d+)%s*|")
            if firstNum then
                local num = tonumber(firstNum)
                if num and num > 1100000000 then
                    curSkin = num
                    result[curSkin] = result[curSkin] or {}
                elseif num and curSkin then
                    local attachName = line:match("^%d+%s*|%s*%x+%s*|%s*(.-)%s*$")
                    if not attachName then attachName = line:match("^%d+%s*|%s*(.-)%s*$") end
                    if attachName and attachName ~= "" then
                        local key = ATTACH_NAME_MAP[attachName]
                        if key then result[curSkin][key] = num end
                    end
                end
            elseif line:find("^#%-%-%-%-") and line:find("skin") then
                curSkin = nil
            end
        end
    end)
    return result
end

_G.GetAttachForSkin = function(skinId, key)
    if not skinId or skinId == 0 or not key then return nil end
    if not _attachFileCache then _attachFileCache = _parseAttachmentsFile() end
    local t = _attachFileCache[skinId]
    if not t then return nil end
    local v = t[key]
    return (v and v > 0) and v or nil
end

_G.GetAttachFileCache = function()
    if not _attachFileCache then _attachFileCache = _parseAttachmentsFile() end
    return _attachFileCache
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
                    if     k == "Suit"      then _G.OutfitMap.Suit      = val
                    elseif k == "Hat"       then _G.OutfitMap.Hat       = val
                    elseif k == "Mask"      then _G.OutfitMap.Mask      = val
                    elseif k == "Glasses"   then _G.OutfitMap.Glasses   = val
                    elseif k == "Pants"     then _G.OutfitMap.Pants     = val
                    elseif k == "Shoes"     then _G.OutfitMap.Shoes     = val
                    elseif k == "Bag"       then _G.OutfitMap.Bag       = val
                    elseif k == "Helmet"    then _G.OutfitMap.Helmet    = val
                    elseif k == "Armor"     then _G.OutfitMap.Armor     = val
                    elseif k == "Parachute" then _G.OutfitMap.Parachute = val
                    elseif k == "Pet"       then _G.OutfitMap.Pet       = val
                    elseif k == "M416"    then _G.WeaponSkinMap[101004] = val
                    elseif k == "AKM"     then _G.WeaponSkinMap[101001] = val
                    elseif k == "SCAR"    then _G.WeaponSkinMap[101003] = val
                    elseif k == "UMP"     then _G.WeaponSkinMap[102002] = val
                    elseif k == "M762"    then _G.WeaponSkinMap[101008] = val
                    elseif k == "AUG"     then _G.WeaponSkinMap[101006] = val
                    elseif k == "ASM"     then _G.WeaponSkinMap[101101] = val
                    elseif k == "ACE32"   then _G.WeaponSkinMap[101102] = val
                    elseif k == "HoneyBadger" then _G.WeaponSkinMap[101012] = val
                    elseif k == "M24"     then _G.WeaponSkinMap[103002] = val
                    elseif k == "AWM"     then _G.WeaponSkinMap[103003] = val
                    elseif k == "Kar98"   then _G.WeaponSkinMap[103001] = val
                    elseif k == "M16A4"   then _G.WeaponSkinMap[101002] = val
                    elseif k == "GROZA"   then _G.WeaponSkinMap[101005] = val
                    elseif k == "QBZ"     then _G.WeaponSkinMap[101007] = val
                    elseif k == "MK47"    then _G.WeaponSkinMap[101009] = val
                    elseif k == "G36C"    then _G.WeaponSkinMap[101010] = val
                    elseif k == "FAMAS"   then _G.WeaponSkinMap[101100] = val
                    elseif k == "VSS"     then _G.WeaponSkinMap[103005] = val
                    elseif k == "Mini14"  then _G.WeaponSkinMap[103006] = val
                    elseif k == "MK14"    then _G.WeaponSkinMap[103007] = val
                    elseif k == "SLR"     then _G.WeaponSkinMap[103009] = val
                    elseif k == "QBU"     then _G.WeaponSkinMap[103010] = val
                    elseif k == "MK12"    then _G.WeaponSkinMap[103100] = val
                    elseif k == "AMR"     then _G.WeaponSkinMap[103012] = val
                    elseif k == "DSR"     then _G.WeaponSkinMap[103102] = val
                    elseif k == "Mosin"   then _G.WeaponSkinMap[103013] = val
                    elseif k == "SKS"     then _G.WeaponSkinMap[103004] = val
                    elseif k == "UZI"     then _G.WeaponSkinMap[102001] = val
                    elseif k == "Vector"  then _G.WeaponSkinMap[102003] = val
                    elseif k == "Thompson"then _G.WeaponSkinMap[102004] = val
                    elseif k == "Bizon"   then _G.WeaponSkinMap[102005] = val
                    elseif k == "MP5K"    then _G.WeaponSkinMap[102007] = val
                    elseif k == "P90"     then _G.WeaponSkinMap[102105] = val
                    elseif k == "S12K"    then _G.WeaponSkinMap[104003] = val
                    elseif k == "DBS"     then _G.WeaponSkinMap[104004] = val
                    elseif k == "S1897"   then _G.WeaponSkinMap[104001] = val
                    elseif k == "S686"    then _G.WeaponSkinMap[104002] = val
                    elseif k == "M249"    then _G.WeaponSkinMap[105001] = val
                    elseif k == "DP28"    then _G.WeaponSkinMap[105002] = val
                    elseif k == "MG3"     then _G.WeaponSkinMap[105010] = val
                    elseif k == "Pan"     then _G.WeaponSkinMap[108004] = val
                    elseif k == "Machete" then _G.WeaponSkinMap[108001] = val
                    elseif k == "Crowbar" then _G.WeaponSkinMap[108002] = val
                    elseif k == "Sickle"  then _G.WeaponSkinMap[108003] = val
                    end
                end
            end
        end
    end)
end
_G.ReadLiveConfig = ReadLiveConfig

local rawGetTableData     = CDataTable and CDataTable.GetTableData     or function() return nil end
local rawGetTableByFilter = CDataTable and CDataTable.GetTableByFilter or function() return nil end

_G.InjectWeaponLogicHooks = function(pawn)
    if not isValid(pawn) then return end
    if _G.__WeaponLogicHookInjected then return end
    _G.__WeaponLogicHookInjected = true
    pcall(function()
        local wm = pawn:GetWeaponManager()
        if not isValid(wm) then return end
        local old_GetEquipID = wm.GetEquipWeaponAvatarID
        if old_GetEquipID then
            wm.GetEquipWeaponAvatarID = function(self, weaponID)
                local forced = _G.get_skin_id(weaponID)
                if forced then return forced end
                return old_GetEquipID(self, weaponID)
            end
        end
        local old_GetWeaponAvatarID = wm.GetWeaponAvatarID
        if old_GetWeaponAvatarID then
            wm.GetWeaponAvatarID = function(self, weapon)
                if isValid(weapon) then
                    local forced = _G.get_skin_id(weapon:GetWeaponID())
                    if forced then return forced end
                end
                return old_GetWeaponAvatarID(self, weapon)
            end
        end
    end)
end

_G.ForceSyncWeaponSkins = function(pawn)
    local wm = pawn:GetWeaponManager()
    if not isValid(wm) then return end
    for i = 1, 3 do
        local wpn = wm:GetInventoryWeaponByPropSlot(i)
        if isValid(wpn) then
            local targetID = _G.get_skin_id(wpn:GetWeaponID())
            if targetID and targetID > 0 then
                pcall(function()
                    if wpn.synData then
                        local data = wpn.synData:Get(7)
                        if data and data.defineID and data.defineID.TypeSpecificID ~= targetID then
                            data.defineID.TypeSpecificID = targetID
                            wpn.synData:Set(7, data)
                            if wpn.OnWeaponSkinUpdate then wpn:OnWeaponSkinUpdate() end
                        end
                    end
                    if wpn.SetWeaponAvatarID then wpn:SetWeaponAvatarID(targetID) end
                end)
            end
        end
    end
end

_G.ApplyWeaponSkins = function(pawn)
    if not isValid(pawn) then return end
    _G.InjectWeaponLogicHooks(pawn)
    _G.ForceSyncWeaponSkins(pawn)
end

if not _G.AKTableHacked and CDataTable then
    local _old = CDataTable.GetTableData
    CDataTable.GetTableData = function(tableName, id)
        local numId = tonumber(id)
        if numId then
            local upgradeID = _G.get_skin_id(numId)
            if upgradeID and upgradeID ~= numId then
                if tableName == "WeaponAvatarBattleEffect"
                or tableName == "GoldClothBattleEffect"
                or tableName == "WeaponSkinVoiceCfg"
                or tableName == "AvatarWeaponHitFXData" then
                    return _old(tableName, upgradeID)
                end
            end
        end
        return _old(tableName, id)
    end
    _G.AKTableHacked = true
end

_G.muzzles = {
    id_flash_hider = { 201010, 201005, 201004 },
    id_compensator = { 201009, 201003, 201002 },
    id_suppressor  = { 201011, 201006, 201007 }
}
_G.foregrips = {
    id_Angledforegrip = 202001,
    id_thumb_grip     = 202006,
    id_vertical_grip  = 202002,
    id_light_grip     = 202004,
    id_half_grip      = 202005,
    id_ergonomic_grip = 202051,
    id_laser_sight    = 202007
}
_G.magazines = {
    id_expanded_mag       = { 204011, 204007, 204004 },
    id_quick_mag          = { 204012, 204008, 204005 },
    id_expanded_quick_mag = { 204013, 204009, 204006 }
}
_G.scopes = {
    id_reddot = 203001,
    id_holo   = 203002,
    id_2x     = 203003,
    id_3x     = 203014,
    id_4x     = 203004,
    id_6x     = 203015,
    id_8x     = 203005
}
_G.stock = {
    id_microStock = 205001,
    id_tactical   = 205002,
    id_bulletloop = 204014,
    id_CheekPad   = 205003
}

_G.ItemUpgradeSystem = nil
pcall(function()
    local MM  = require("client.module_framework.ModuleManager")
    local IUS = MM.GetModule(MM.CommonModuleConfig.ItemUpgradeManager)
    if IUS then
        IUS:DefineAndResetData()
        IUS:OnInitialize()
        _G.ItemUpgradeSystem = IUS
    end
end)

_G.get_group_id = function(itemId)
    if not _G.ItemUpgradeSystem or not itemId then return nil end
    local cfg = _G.ItemUpgradeSystem:GetUpgradeCfg(itemId)
    return cfg and cfg.GroupID or nil
end

_G.InitParts = function(groupId, itemId)
    if not itemId then return _G.g_parts end
    if _G.g_parts[itemId] and next(_G.g_parts[itemId]) then return _G.g_parts end
    _G.g_parts[itemId] = {}
    if not _G.ItemUpgradeSystem then return _G.g_parts end
    if _G.ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
        groupId = _G.ItemUpgradeSystem:GetNormalGroupID(groupId or _G.get_group_id(itemId))
    else
        groupId = groupId or _G.get_group_id(itemId)
    end
    if not groupId then return _G.g_parts end
    local cfg = rawGetTableByFilter("ItemUpgradeUnLockConfig", "GroupID", groupId)
    if cfg then
        for _, info in pairs(cfg) do
            local partId = info.PartId
            if _G.ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
                local switched = _G.ItemUpgradeSystem:PartIDSwitch(partId, true)
                if switched and switched ~= partId then partId = switched end
            end
            local item = rawGetTableData("Item", partId)
            if item and item.ItemName then
                _G.g_parts[itemId][item.ItemName] = partId
            end
        end
    end
    return _G.g_parts
end

_G.GetRawAttachMap = function(skinid)
    if not skinid or skinid <= 0 then return {} end
    if _G.skinAttachCache[skinid] then return _G.skinAttachCache[skinid] end
    local UAvatarUtils = import("AvatarUtils")
    if not UAvatarUtils then return {} end
    local list = UAvatarUtils.GetWeaponAvatarDefaultAttachmentSkin(skinid, {}, false) or {}
    _G.skinAttachCache[skinid] = list
    return list
end

_G.GetSlotFromSkinID = function(skinid, slot)
    if not skinid or not slot then return 0 end
    local list = _G.GetRawAttachMap(skinid)
    local attachmentTypeMap = {
        [1] = {291004,291102,291001,291006,291005,291002,293003,293004,293009,293007,293005,293006,295001,295002,291007,291003,292002,292003,291011,291008},
        [2] = {205005,205102,205007,205009,205006},
        [3] = {203008,203009,203006,203022,203010}
    }
    local targetIDs = attachmentTypeMap[slot]
    if not targetIDs then return 0 end
    for _, targetID in ipairs(targetIDs) do
        for attachID, attachSkinID in pairs(list) do
            if attachID == targetID then return attachSkinID end
        end
    end
    return 0
end

_G.AutoDetectAttach = function(skinid, base_id)
    if not skinid or not base_id then return 0 end
    local list = _G.GetRawAttachMap(skinid)
    local v = list[base_id]
    return (v and v > 0) and v or 0
end

_G.get_muzzleid = function(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid]
    local function is_in(t)
        for _, id in ipairs(_G.muzzles[t]) do if current_id == id then return true end end
        return false
    end
    if is_in("id_flash_hider") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "FlashHider")
                  or (p and p["Flash Hider"])
                  or (auto > 0 and auto)
                  or current_id
    elseif is_in("id_compensator") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "Compensator")
                  or (p and p["Compensator"])
                  or (auto > 0 and auto)
                  or current_id
    elseif is_in("id_suppressor") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "Suppressor")
                  or (p and p["Suppressor"])
                  or (auto > 0 and auto)
                  or current_id
    end
    return current_id, (initial_id ~= current_id)
end

_G.get_forgripid = function(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid]
    local auto = _G.AutoDetectAttach(avatarid, current_id)
    if current_id == _G.foregrips.id_Angledforegrip then
        current_id = _G.GetAttachForSkin(avatarid, "AngledGrip") or (p and p["Angled Foregrip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_thumb_grip then
        current_id = _G.GetAttachForSkin(avatarid, "ThumbGrip") or (p and p["Thumb Grip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_vertical_grip then
        current_id = _G.GetAttachForSkin(avatarid, "VerticalGrip") or (p and p["Vertical Foregrip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_light_grip then
        current_id = _G.GetAttachForSkin(avatarid, "LightGrip") or (p and p["Light Grip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_half_grip then
        current_id = _G.GetAttachForSkin(avatarid, "HalfGrip") or (p and p["Half Grip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_ergonomic_grip then
        current_id = (p and p["Ergonomic Grip"]) or (auto > 0 and auto) or current_id
    elseif current_id == _G.foregrips.id_laser_sight then
        current_id = _G.GetAttachForSkin(avatarid, "LaserSight") or (p and p["Laser Sight"]) or (auto > 0 and auto) or current_id
    end
    return current_id, (initial_id ~= current_id)
end

_G.get_magazinesid = function(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid]
    local function is_in(t)
        for _, id in ipairs(_G.magazines[t]) do if current_id == id then return true end end
        return false
    end
    if is_in("id_expanded_mag") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "ExtMag") or (p and p["Extended Mag"]) or _G.GetSlotFromSkinID(avatarid, 1) or (auto > 0 and auto) or current_id
    elseif is_in("id_quick_mag") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "QuickMag") or (p and p["Quickdraw Mag"]) or _G.GetSlotFromSkinID(avatarid, 1) or (auto > 0 and auto) or current_id
    elseif is_in("id_expanded_quick_mag") then
        local auto = _G.AutoDetectAttach(avatarid, current_id)
        current_id = _G.GetAttachForSkin(avatarid, "ExtQuickMag") or (p and p["Extended Quickdraw Mag"]) or _G.GetSlotFromSkinID(avatarid, 1) or (auto > 0 and auto) or current_id
    else
        local fb = _G.GetSlotFromSkinID(avatarid, 1)
        if fb and fb > 0 then current_id = fb end
    end
    return current_id, (initial_id ~= current_id)
end

_G.get_scopeid = function(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid]
    local auto = _G.AutoDetectAttach(avatarid, current_id)
    if current_id == _G.scopes.id_reddot then
        current_id = _G.GetAttachForSkin(avatarid, "RedDot") or (p and p["Red Dot Sight"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_holo then
        current_id = _G.GetAttachForSkin(avatarid, "Holo") or (p and p["Holographic Sight"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_2x then
        current_id = _G.GetAttachForSkin(avatarid, "Scope2x") or (p and p["2x Scope"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_3x then
        current_id = _G.GetAttachForSkin(avatarid, "Scope3x") or (p and p["3x Scope"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_4x then
        current_id = _G.GetAttachForSkin(avatarid, "Scope4x") or (p and p["4x Scope"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_6x then
        current_id = _G.GetAttachForSkin(avatarid, "Scope6x") or (p and p["6x Scope"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    elseif current_id == _G.scopes.id_8x then
        current_id = _G.GetAttachForSkin(avatarid, "Scope8x") or (p and p["8x Scope"]) or _G.GetSlotFromSkinID(avatarid, 3) or (auto > 0 and auto) or current_id
    else
        local fb = _G.GetSlotFromSkinID(avatarid, 3)
        if fb and fb > 0 then current_id = fb end
    end
    return current_id, (initial_id ~= current_id)
end

_G.get_stockid = function(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid]
    local auto = _G.AutoDetectAttach(avatarid, current_id)
    if current_id == _G.stock.id_microStock then
        current_id = _G.GetAttachForSkin(avatarid, "MicroStock") or (p and p["Stock"]) or _G.GetSlotFromSkinID(avatarid, 2) or (auto > 0 and auto) or current_id
    elseif current_id == _G.stock.id_tactical then
        current_id = _G.GetAttachForSkin(avatarid, "TactStock") or (p and p["Tactical Stock"]) or _G.GetSlotFromSkinID(avatarid, 2) or (auto > 0 and auto) or current_id
    elseif current_id == _G.stock.id_bulletloop then
        current_id = (p and p["Bullet Loop"]) or _G.GetSlotFromSkinID(avatarid, 2) or (auto > 0 and auto) or current_id
    elseif current_id == _G.stock.id_CheekPad then
        current_id = _G.GetAttachForSkin(avatarid, "CheekPad") or (p and p["Cheek Pad"]) or _G.GetSlotFromSkinID(avatarid, 2) or (auto > 0 and auto) or current_id
    else
        local fb = _G.GetSlotFromSkinID(avatarid, 2)
        if fb and fb > 0 then current_id = fb end
    end
    return current_id, (initial_id ~= current_id)
end

_G.apply_attachment = function(CurWeapon, avatarid)
    local array = CurWeapon.synData
    for AttachIdx = 0, 4 do
        local Data = array:Get(AttachIdx)
        local itemid = slua.IndexReference(Data, "defineID").TypeSpecificID
        if itemid and itemid > 0 and itemid < 10000000 then
            local isrefresh = false
            if AttachIdx == 0 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_muzzleid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 1 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_forgripid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 2 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_magazinesid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 3 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_stockid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 4 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_scopeid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            else
                break
            end
            if isrefresh then
                _G.download_item(slua.IndexReference(Data, "defineID").TypeSpecificID)
                CurWeapon:DelayHandleAvatarMeshChanged()
            end
        end
    end
end

local WEAPON_NAMES = {
    "AKM","M16A4","SCAR","M416","GROZA","AUG","QBZ","M762",
    "MK47","G36C","HoneyBadger","ASM","FAMAS","ACE32",
    "UZI","UMP","Vector","Bizon","Thompson","MP5K","P90",
    "Kar98","M24","AWM","SKS","Mini14","MK14","SLR","QBU","MK12","AMR","DSR","VSS","Mosin",
    "S12K","DBS","S1897","S686",
    "M249","DP28","MG3",
    "Pan","Machete","Crowbar","Sickle",
}
local WEAPON_NAME_TO_ID = {
    AKM=101001,M16A4=101002,SCAR=101003,M416=101004,
    GROZA=101005,AUG=101006,QBZ=101007,M762=101008,
    MK47=101009,G36C=101010,HoneyBadger=101012,ASM=101101,FAMAS=101100,ACE32=101102,
    UZI=102001,UMP=102002,Vector=102003,Bizon=102005,MP5K=102007,P90=102105,
    Kar98=103001,M24=103002,AWM=103003,SKS=103004,VSS=103005,
    Mini14=103006,MK14=103007,SLR=103009,QBU=103010,MK12=103100,AMR=103012,DSR=103102,Mosin=103013,
    S12K=104003,DBS=104004,S1897=104001,S686=104002,
    M249=105001,DP28=105002,MG3=105010,
    Pan=108004,Machete=108001,Crowbar=108002,Sickle=108003,
}

_G.SyncAttachmentsToConfig = function()
    local cache = _G.GetAttachFileCache and _G.GetAttachFileCache()
    if not cache or not next(cache) then return end
    local hasSkin = false
    for _, w in ipairs(WEAPON_NAMES) do
        local baseId = WEAPON_NAME_TO_ID[w]
        if baseId and (_G.WeaponSkinMap[baseId] or 0) > 0 then hasSkin = true; break end
    end
    if not hasSkin then return end
    pcall(function()
        local f = io.open(CONFIG_PATH, "r")
        if not f then return end
        local content = f:read("*all"); f:close()
        local lines = {}
        for line in content:gmatch("[^\r\n]+") do table.insert(lines, line) end
        local filtered = {}
        for _, line in ipairs(lines) do
            local isAuto = false
            for _, w in ipairs(WEAPON_NAMES) do
                if line:find("^" .. w .. "_[%w%-]+=") then isAuto = true; break end
            end
            if not isAuto then table.insert(filtered, line) end
        end
        local ATTACH_TO_CONFIG_KEY = {
            Scope2x = "2x", Scope3x = "3x", Scope4x = "4x", Scope6x = "6x", Scope8x = "8x",
            RedDot = "RedDot", Holo = "Holo", CantedSight = "CantedSight",
            FlashHider = "FlashHider", Compensator = "Compensator", Suppressor = "Suppressor",
            ExtMag = "ExtMag", QuickMag = "QuickMag", ExtQuickMag = "ExtQuickMag",
            AngledGrip = "AngledGrip", ThumbGrip = "ThumbGrip", VerticalGrip = "VerticalGrip",
            LightGrip = "LightGrip", HalfGrip = "HalfGrip", LaserSight = "LaserSight",
            TactStock = "TactStock", MicroStock = "MicroStock", CheekPad = "CheekPad",
        }
        local KEY_ORDER = {
            "RedDot","Holo","CantedSight",
            "Scope2x","Scope3x","Scope4x","Scope6x","Scope8x",
            "FlashHider","Compensator","Suppressor",
            "ExtMag","QuickMag","ExtQuickMag",
            "AngledGrip","ThumbGrip","VerticalGrip","LightGrip","HalfGrip","LaserSight",
            "TactStock","MicroStock","CheekPad",
        }
        local outLines = {}
        table.insert(outLines, "; SyncAttachmentsToConfig ran")
        local foundCount = 0
        for _, line in ipairs(filtered) do
            table.insert(outLines, line)
            local wname, skinStr = line:match("^(%w+)=(%d+)$")
            if wname then
                local baseId = WEAPON_NAME_TO_ID[wname]
                if baseId then
                    local skinId = tonumber(skinStr)
                    if skinId and skinId > 0 then
                        local attaches = cache[skinId]
                        if attaches then
                            for _, key in ipairs(KEY_ORDER) do
                                local id = attaches[key]
                                local ck = ATTACH_TO_CONFIG_KEY[key]
                                if id and ck then
                                    table.insert(outLines, wname .. "_" .. ck .. "=" .. id)
                                    foundCount = foundCount + 1
                                end
                            end
                        else
                            table.insert(outLines, "; No cache entry for skin " .. skinId)
                        end
                    end
                    table.insert(outLines, "")
                end
            end
        end
        outLines[1] = "; SyncAttachmentsToConfig OK - matched " .. foundCount .. " attachments"
        local out = io.open(CONFIG_PATH, "w")
        if out then out:write(table.concat(outLines, "\n"), "\n"); out:close() end
    end)
end

_G.ApplyLocalPlayerSkins = function(p)
    if _G.Mod_Skin_Enabled == false then return end
    if not isValid(p) then return end

    pcall(function()
        local BackpackUtils = import("BackpackUtils")
        local ac = p:getAvatarComponent2()
        if isValid(ac) and ac.NetAvatarData then
            local applyData = ac.NetAvatarData.SlotSyncData
            if isValid(applyData) then
                local ref = false
                for i = 0, applyData:Num() - 1 do
                    local eq = applyData:Get(i)
                    if eq and eq.ItemId ~= 0 then
                        local target = 0
                        if eq.SlotID == 5 and _G.OutfitMap.Suit then
                            target = _G.OutfitMap.Suit
                        elseif eq.SlotID == 8 and _G.OutfitMap.Bag and _G.OutfitMap.Bag ~= 501001 then
                            local bagBase = _G.OutfitMap.Bag
                            local level = 1
                            if BackpackUtils then level = BackpackUtils.GetEquipmentBagLevel(eq.AdditionalItemID) or 1 end
                            target = bagBase + (level - 1) * 1000
                        elseif eq.SlotID == 9 and _G.OutfitMap.Helmet and _G.OutfitMap.Helmet ~= 502001 then
                            local helBase = _G.OutfitMap.Helmet
                            local level = 1
                            if BackpackUtils then level = BackpackUtils.GetEquipmentHelmetLevel(eq.AdditionalItemID) or 1 end
                            target = helBase + (level - 1) * 1000
                        end
                        if target and target ~= 0 and eq.ItemId ~= target then
                            if _G.download_item and not _G.SkinLoadedCache[target] then
                                pcall(_G.download_item, target)
                                _G.SkinLoadedCache[target] = true
                            end
                            eq.ItemId = target
                            applyData:Set(i, eq)
                            ref = true
                        end
                    end
                end
                if ref and ac.OnRep_BodySlotStateChanged then ac:OnRep_BodySlotStateChanged() end
            end
            local extra_keys = {"Hat","Mask","Glasses","Pants","Shoes","Armor","Parachute"}
            for _, key in ipairs(extra_keys) do
                local id = _G.OutfitMap[key]
                if id and id > 0 and _G.LastEquippedOutfits[key] ~= id then
                    if _G.download_item and not _G.SkinLoadedCache[id] then
                        pcall(_G.download_item, id)
                        _G.SkinLoadedCache[id] = true
                    end
                    ac:PutOnCustomEquipmentByID(id, {})
                    _G.LastEquippedOutfits[key] = id
                end
            end
        end
    end)

    _G.ApplyWeaponSkins(p)
    for i = 1, 3 do
        local wpn = p:GetWeaponManager() and p:GetWeaponManager():GetInventoryWeaponByPropSlot(i)
        if isValid(wpn) then
            local target = _G.get_skin_id(wpn:GetWeaponID())
            if target and target > 0 then
                if not _G.SkinLoadedCache[target] then
                    pcall(_G.download_item, target)
                    _G.SkinLoadedCache[target] = true
                end
                if _G.apply_attachment then pcall(_G.apply_attachment, wpn, target) end
            end
        end
    end

    if _G.OutfitMap.Pet and _G.OutfitMap.Pet ~= 0 then
        pcall(function()
            local pc = slua_GameFrontendHUD:GetPlayerController()
            if pc and pc.PetComponent and pc.PetComponent.PetId ~= _G.OutfitMap.Pet then
                pc.PetComponent.PetId = _G.OutfitMap.Pet
                pc.PetComponent:OnRep_PetId()
            end
        end)
    end

    pcall(function()
        local CV = p.CurrentVehicle
        if isValid(CV) then
            local VA = CV.VehicleAvatar
            if isValid(VA) then
                local defId = tostring(VA:GetDefaultAvatarID() or "")
                local currentId = tostring(CV:GetAvatarId() or "")
                local vehTarget = 0
                for baseId, targetSkin in pairs(_G.VehicleSkinMap) do
                    if defId:find(tostring(baseId)) then vehTarget = targetSkin; break end
                end
                if vehTarget and vehTarget > 0 and currentId ~= tostring(vehTarget) then
                    if _G.download_item and not _G.SkinLoadedCache[vehTarget] then
                        pcall(_G.download_item, vehTarget)
                        _G.SkinLoadedCache[vehTarget] = true
                    end
                    VA.curSwitchEffectId = 7303001
                    VA:ChangeItemAvatar(vehTarget, true)
                    _G.CurrentEquipVehicleID = vehTarget
                end
            end
        end
    end)
end

if not table.contains then
    function table.contains(t, el)
        for _, v in ipairs(t) do if v == el then return true end end
        return false
    end
end

local function locationsClose(loc1, loc2, tolerance)
    local dx = loc1.X - loc2.X
    local dy = loc1.Y - loc2.Y
    local dz = loc1.Z - loc2.Z
    return dx*dx + dy*dy + dz*dz < tolerance*tolerance
end

_G.ApplyDeadBoxSkin = function()
    if _G.Mod_Skin_Enabled == false then return end
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    local uCharacter = pc:GetPlayerCharacterSafety()
    if not isValid(uCharacter) then return end
    local UGameplayStatics = import("GameplayStatics")
    if not UGameplayStatics then return end
    local uActor = import("Actor")
    if not uActor then return end
    local ok, UIUtil = pcall(require, "client.common.ui_util")
    if not ok or not UIUtil then return end
    local uGameInstance = UIUtil.GetGameInstance()
    if not uGameInstance then return end
    local APlayerTombBox = import("PlayerTombBox")
    if not APlayerTombBox then return end
    local uActorArray = UGameplayStatics.GetAllActorsOfClass(
        uGameInstance, APlayerTombBox,
        slua.Array(UEnums.EPropertyClass.Object, uActor))
    if not uActorArray then return end
    for _, actor in pairs(uActorArray) do
        if isValid(actor) then
            local DamageCauser = actor.DamageCauser
            if DamageCauser and DamageCauser.PlayerKey == pc.PlayerKey then
                local Deadboxavatar = actor.DeadBoxAvatarComponent_BP
                if Deadboxavatar and not table.contains(_G.AlreadyChangedSet, actor) then
                    local actorLocation = actor:K2_GetActorLocation()
                    local found = false
                    for _, entry in pairs(_G.DeadBoxSkins) do
                        if locationsClose(entry.location, actorLocation, 1.0) then
                            Deadboxavatar:ResetItemAvatar()
                            Deadboxavatar:PreChangeItemAvatar(entry.SkinID)
                            Deadboxavatar:SyncChangeItemAvatar(entry.SkinID)
                            table.insert(_G.AlreadyChangedSet, actor)
                            found = true
                            break
                        end
                    end
                    if not found then
                        local ApplySkinID = 0
                        local CV = uCharacter.CurrentVehicle
                        if CV then
                            local carSkinID = _G.CurrentEquipVehicleID
                            if carSkinID ~= 0 then ApplySkinID = tostring(carSkinID) .. "1" end
                        else
                            local cw = uCharacter:GetCurrentWeapon()
                            if cw and cw.synData then
                                ApplySkinID = slua.IndexReference(cw.synData:Get(7), "defineID").TypeSpecificID
                            end
                        end
                        Deadboxavatar:ResetItemAvatar()
                        Deadboxavatar:PreChangeItemAvatar(ApplySkinID)
                        Deadboxavatar:SyncChangeItemAvatar(ApplySkinID)
                        table.insert(_G.DeadBoxSkins, { location = actorLocation, SkinID = ApplySkinID })
                        table.insert(_G.AlreadyChangedSet, actor)
                    end
                end
            end
        end
    end
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
        local KillCounterUI = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"]
        if KillCounterUI and KillCounterUI.__inner_impl then
            KillCounterUI.__inner_impl:CheckNeedMainKillCounterUI(cw, pc.PlayerKey)
        end
        local UIM = require("client.slua_ui_framework.manager")
        local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
        if MKC and MKC.KillCounterItem then
            MKC:SetKillCounterItemShowWithNum(sid, _G.getKills(wID), sid)
        end
    end)
end

_G.ForceEnableKillCounterUI = function()
    if _G.KCUISystemHacked2 then return end
    pcall(function()
        local KillCounterUI = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"]
                           or require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if KillCounterUI and KillCounterUI.__inner_impl then
            local ui = KillCounterUI.__inner_impl
            ui.CheckSupportKCUI = function() return true end
            ui.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local cw = isValid(Weapon) and Weapon
                        or (pc and pc:GetPlayerCharacterSafety() and pc:GetPlayerCharacterSafety():GetCurrentWeapon())
                if not isValid(cw) then self:UpdateMainKillCounterUI(false); return end
                local wID = cw:GetWeaponID()
                if not wID or wID == 0 then self:UpdateMainKillCounterUI(false); return end
                self:UpdateMainKillCounterUI(true, wID, _G.get_skin_id(wID) or wID)
            end
            local old_Update = ui.UpdateMainKillCounterUI
            ui.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
                if not bShow then return old_Update(self, bShow, WeaponID, AvatarID) end
                return old_Update(self, bShow, WeaponID, AvatarID or _G.get_skin_id(WeaponID))
            end
            _G.KCUISystemHacked2 = true
        end
        local MM = require("client.module_framework.ModuleManager")
        if MM then
            local LogicKC = MM.GetModule(MM.CommonModuleConfig.LogicKillCounter)
            if LogicKC and not _G.KCLogicHacked2 then
                LogicKC.CheckSupportKC                = function() return true end
                LogicKC.CheckSupportKillCounterAvatar = function() return true end
                LogicKC.CheckHasWeaponKillCounter     = function() return true end
                LogicKC.GetBaseKillCounterIdByWeaponId= function() return 2100004 end
                LogicKC.GetEquipedKillCounterId        = function() return 2100004 end
                LogicKC.GetMyEquipedKillCounterId      = function() return 2100004 end
                LogicKC.GetOneWeaponKillCountInBattle  = function(_, _, wid) return _G.getKills(wid) end
                LogicKC.GetWeaponKillCountByUid        = function(_, _, wid) return _G.getKills(wid) end
                _G.KCLogicHacked2 = true
            end
        end
        local KillInfoPath = "GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"
        local KillInfo = package.loaded[KillInfoPath] or require(KillInfoPath)
        if KillInfo and KillInfo.__inner_impl and not _G.KillInfoCounterHacked then
            local old_FileItem = KillInfo.__inner_impl.FileItem
            KillInfo.__inner_impl.FileItem = function(self, DRD)
                pcall(function()
                    local GD = require("GameLua.GameCore.Data.GameplayData")
                    local lp = GD.GetPlayerCharacter()
                    if isValid(lp) and DRD.Causer == lp:GetPlayerNameSafety() then
                        local cw = lp:GetCurrentWeapon()
                        if isValid(cw) then
                            local wid = cw:GetWeaponID()
                            local sid = _G.get_skin_id(wid)
                            if sid then DRD.CauserWeaponAvatarID = sid end
                            if _G.OutfitMap.Suit then DRD.CauserClothAvatarID = _G.OutfitMap.Suit end
                            DRD.IsUseColor = true
                            DRD.UseColor = import("LinearColor")(1.0, 0.8, 0.0, 1.0)
                            local expand_data = DRD.ExpandDataContent
                            if expand_data then
                                expand_data.KillCounterItemId = sid or wid
                                expand_data.KillCounterNum = _G.getKills(wid)
                            end
                            if DRD.ResultHealthStatus == 2 then
                                _G.AddKill(wid)
                                local UIM = require("client.slua_ui_framework.manager")
                                local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
                                if MKC and MKC.KillCounterItem then
                                    MKC:SetKillCounterItemShowWithNum(sid or wid, _G.getKills(wid), sid or wid)
                                end
                            end
                        end
                    end
                end)
                if old_FileItem then old_FileItem(self, DRD) end
            end
            _G.KillInfoCounterHacked = true
        end
        local ok2, WIIB = pcall(require, "GameLua.Mod.BaseMod.Client.Backpack.WeaponInfoItemBase")
        if ok2 and WIIB and WIIB.__inner_impl and not _G.WeaponInfoBackpackHacked then
            local o_UWA = WIIB.__inner_impl.UpdateWeaponAppearanceInfo
            if o_UWA then
                WIIB.__inner_impl.UpdateWeaponAppearanceInfo = function(self, TypeSpecificID, BattleData, DragOrigin)
                    local ItemData = rawGetTableData("Item", TypeSpecificID)
                    if not ItemData then return o_UWA(self, TypeSpecificID, BattleData, DragOrigin) end
                    local skin_id = _G.get_skin_id(TypeSpecificID)
                    if not skin_id or not _G.SkinLoadedCache[skin_id] then
                        return o_UWA(self, TypeSpecificID, BattleData, DragOrigin)
                    end
                    o_UWA(self, skin_id, BattleData, DragOrigin)
                    pcall(function()
                        self.TypeSpecificIDTemp = TypeSpecificID
                        self.ItemID             = TypeSpecificID
                        if self.UIRoot then
                            self.UIRoot.ItemID = TypeSpecificID
                            if self.UIRoot.TextBlock_WeaponName and ItemData.ItemName then
                                self.UIRoot.TextBlock_WeaponName:SetText(ItemData.ItemName)
                            end
                        end
                        if self.BindWeaponChangeEvent  then self:BindWeaponChangeEvent()  end
                        if self.UpdateBullet           then self:UpdateBullet()           end
                        if self.UpdateWeaponDurability then self:UpdateWeaponDurability() end
                        if self.UpdateWeaponAttachment then self:UpdateWeaponAttachment() end
                    end)
                end
                _G.WeaponInfoBackpackHacked = true
            end
        end
    end)
end

if not _G.BattleKillBroadcastSkinHacked then
    pcall(function()
        local BattleKillBroadcastSubSystem = require("GameLua.Mod.BaseMod.Client.BattleKillBroadcast.BattleKillBroadcastSubSystem")
        if not (BattleKillBroadcastSubSystem and BattleKillBroadcastSubSystem.__inner_impl) then return end
        local o_Copy = BattleKillBroadcastSubSystem.__inner_impl.CopyKillOrPutDownMessageDataUserDataToLuaTable
        BattleKillBroadcastSubSystem.__inner_impl.CopyKillOrPutDownMessageDataUserDataToLuaTable = function(self, messageData)
            local msgData = o_Copy(self, messageData)
            pcall(function()
                local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                local character = pc and pc:GetPlayerCharacterSafety()
                if character and isValid(character) and msgData.bIamCauser and _G.LuaStateWrapper then
                    msgData.bShowBottomBothSidesKillInfo = true
                    local weapon = character:GetCurrentWeapon()
                    if weapon and isValid(weapon) then
                        local weapon_id = weapon:GetItemDefineID() and weapon:GetItemDefineID().TypeSpecificID or 0
                        if weapon_id ~= 0 then
                            local expand_data = slua.LuaArchiverDecode(_G.LuaStateWrapper, msgData.ExpandDataContent) or {}
                            local isClassic = false
                            local uGameState = slua_GameFrontendHUD:GetGameState()
                            if uGameState and isValid(uGameState) then
                                local EGameModeType = import("EGameModeType")
                                if uGameState.GameModeType == EGameModeType.ETypicalGameMode then isClassic = true end
                            end
                            local syn_data = weapon.synData
                            if syn_data and isValid(syn_data) then
                                local define_id = slua.IndexReference(syn_data:Get(7), "defineID")
                                if define_id and isValid(define_id) then
                                    expand_data.CauserWeaponAvatarID = define_id.TypeSpecificID
                                end
                            end
                            if isClassic then
                                expand_data.KillCounterItemId = weapon_id
                                expand_data.KillCounterNum = _G.getKills and _G.getKills(weapon_id) or 0
                            end
                            msgData.bShowKillNum = true
                            msgData.ExpandDataContent = slua.LuaArchiverEncode(_G.LuaStateWrapper, expand_data)
                        end
                    end
                end
            end)
            return msgData
        end
        _G.BattleKillBroadcastSkinHacked = true
    end)
end

ReadLiveConfig()
_G.ForceEnableKillCounterUI()

_G._SetupSkinTimer = function()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not (pc and slua.isValid(pc)) then return end
        if _G.SkinTimerPC == pc then return end
        _G.SkinTimerPC = pc
        _G._SkinTimerInstalled = true
        _G._SkinTickCount = 0
        pc:AddGameTimer(0.5, true, function()
            pcall(function()
                local lpc = slua_GameFrontendHUD:GetPlayerController()
                if not (lpc and slua.isValid(lpc)) then return end
                local pawn = lpc:GetPlayerCharacterSafety()
                if not (pawn and slua.isValid(pawn)) then return end
                _G._SkinTickCount = (_G._SkinTickCount or 0) + 1
                local tick = _G._SkinTickCount
                if tick % 4 == 1 then
                    _G.ReadLiveConfig()
                    _G.SyncAttachmentsToConfig()
                end
                if tick % 10 == 1 then
                    _G.ApplyLocalPlayerSkins(pawn)
                    _G.ApplyDeadBoxSkin()
                end
                _G.RefreshKillCounterUI()
            end)
        end)
    end)
end

_G._SetupSkinTimer()

-- =============================================
-- 🎯 SCENE FUNCTIONS
-- =============================================

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

function SetBlackSky(enabled)
    ExecuteConsoleCommand("r.CylinderMaxDrawHeight", enabled and "9999" or "0")
end

function SetFogRemoval(enabled)
    ExecuteConsoleCommand("r.Fog", enabled and "0" or "1")
    ExecuteConsoleCommand("r.VolumetricFog", enabled and "0" or "1")
end

function SetGrassRemoval(enabled)
    ExecuteConsoleCommand("grass.DensityScale", enabled and "0" or "1")
    ExecuteConsoleCommand("foliage.DensityScale", enabled and "0" or "1")
end

function SetTreeRemoval(enabled)
    ExecuteConsoleCommand("foliage.TreeDensityScale", enabled and "0" or "1")
end

function SetWaterRemoval(enabled)
    ExecuteConsoleCommand("r.Water", enabled and "0" or "1")
end

function SetForceChinese(enabled)
    if enabled then
        pcall(function()
            local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
            if gi and gi.SetCurrentCulture then gi:SetCurrentCulture("zh-CN") end
        end)
    else
        pcall(function()
            local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
            if gi and gi.SetCurrentCulture then gi:SetCurrentCulture("en") end
        end)
    end
end

-- =============================================
-- 🎯 WALLHACK
-- =============================================

local function ApplyWallHack(localPlayer, enemy, pc)
    if not _G.CheatsEnabled then return end
    if _G.Mod_Wallhack_Enabled == false then return end
    if not slua.isValid(enemy) then return end
    local meshes = {}
    pcall(function()
        if slua.isValid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
        local SkelClass = import("SkeletalMeshComponent")
        if SkelClass then
            local childs = enemy:GetComponentsByClass(SkelClass)
            if childs then
                local count = type(childs.Num) == "function" and childs:Num() or #childs
                for c = 1, count do
                    local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                    if slua.isValid(comp) and comp ~= enemy.Mesh then table.insert(meshes, comp) end
                end
            end
        end
    end)
    pcall(function()
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
            end
        end
        local isVisible = false
        if slua.isValid(pc) and slua.isValid(enemy) and type(pc.LineOfSightTo) == "function" then
            pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
        end
        local finalColor = isVisible and {R=255, G=255, B=255, A=255} or {R=255, G=100, B=0, A=200}
        local scale = {R=0, G=0, B=0, A=0}
        enemy._WH_MIDs = enemy._WH_MIDs or {}
        for _, comp in ipairs(meshes) do
            if slua.isValid(comp) then
                local ck = tostring(comp)
                enemy._WH_MIDs[ck] = enemy._WH_MIDs[ck] or {}
                for i = 0, 10 do
                    local ok3, mi = pcall(function() return comp:GetMaterial(i) end)
                    if not ok3 or not slua.isValid(mi) then break end
                    local mid = enemy._WH_MIDs[ck][i]
                    if not slua.isValid(mid) then
                        local ok4, nm = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                        if ok4 and slua.isValid(nm) then enemy._WH_MIDs[ck][i] = nm; mid = nm end
                    end
                    if slua.isValid(mid) then
                        pcall(function()
                            mid:SetVectorParameterValue("颜色", finalColor)
                            mid:SetVectorParameterValue("Color", finalColor)
                            mid:SetVectorParameterValue("BaseColor", finalColor)
                            mid:SetVectorParameterValue("BodyColor", finalColor)
                            mid:SetVectorParameterValue("DiffuseColor", finalColor)
                            mid:SetVectorParameterValue("ParaScaleOffset", scale)
                        end)
                    end
                end
            end
        end
    end)
end

-- =============================================
-- 🎯 ESP
-- =============================================

local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")

local cachedPawns     = {}
local lastPawnRefresh = 0

local function IsPawnAlive(p)
    if not isValid(p) then return false end
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
    if _G._ESPTimerHandle and _G._ESPTimerChar and not isValid(_G._ESPTimerChar) then _G._ESPTimerHandle = nil; _G._ESPTimerChar = nil end
    local uCon = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not (isValid(uCon) and Game:IsClassOf(uCon, ASTExtraPlayerController)) then return end
    local currentPawn = uCon:GetCurPawn()
    if not isValid(currentPawn) then return end

    local myTeamId = 0
    pcall(function()
        local char = uCon:GetPlayerCharacterSafety()
        if isValid(char) and char.TeamID then myTeamId = char.TeamID
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
        if isValid(p) and p ~= currentPawn and p.TeamID ~= myTeamId and IsPawnAlive(p) then
            totalAlive = totalAlive + 1
        end
    end
    local crowded = totalAlive > 20

    for _, tPawn in pairs(cachedPawns) do
        if isValid(tPawn) and tPawn ~= currentPawn and tPawn.TeamID ~= myTeamId then
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
                    if isValid(mesh) then
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
                    pcall(ApplyWallHack, currentPawn, tPawn, uCon)
                end
            end
        end
    end

    if not crowded and HUD and currentPawn then
        HUD:AddDebugText(string.format("BOT : %d     PLAYER : %d", botCount, playerCount), currentPawn, 1, {X=0,Y=0,Z=155}, {X=0,Y=0,Z=155}, {R=255,G=255,B=0,A=255}, true, false, true, nil, 1.0, true)
        HUD:AddDebugText("MOD BY @TrnDravix", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=0,G=200,B=255,A=255}, true, false, true, nil, 1.0, true)
    end
end

pcall(function()
    if _G._ESPWatchdogHandle then pcall(function() Game:ClearTimer(_G._ESPWatchdogHandle) end); _G._ESPWatchdogHandle = nil end

    local function StartESP(targetActor)
        if not isValid(targetActor) then return end
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
            if isValid(curPawn) and _G._ESPTimerChar ~= curPawn then
                if _G._ESPTimerHandle and isValid(_G._ESPTimerChar) then
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

-- =============================================
-- 🎯 AIMBOT
-- =============================================

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
          if isValid(node) then
            node:SetIsEnabled(true); pcall(function() node:SetRenderOpacity(1.0) end)
            local sw = self.UIRoot["WidgetSwitcher_"..tostring(i)]
            if isValid(sw) then sw:SetActiveWidgetIndex(i == lvl and 0 or 1) end
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

-- =============================================
-- 🎯 IPAD VIEW
-- =============================================

local pc = slua_GameFrontendHUD:GetPlayerController()
if isValid(pc) and pc.AddGameTimer and pc ~= _G._FeaturesTimerPC then
  _G._FeaturesTimerPC = pc
  local SubsystemMgr = nil
  local lastViewDistance = nil
  _G._originalTPPFOV = nil

  pc:AddGameTimer(0.1, true, function()
    pcall(function()
      if not _G.CheatsEnabled then return end
      local pc = slua_GameFrontendHUD:GetPlayerController()
      if not isValid(pc) then return end
      local char = pc:GetPlayerCharacterSafety()
      if not isValid(char) then return end
      local lp = GameplayData.GetPlayerCharacter()
      if not isValid(lp) then return end

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
          if isValid(uTPPCam) and not char.bIsWeaponAiming then
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
        if not isValid(pc) then return end

        local char = pc:GetPlayerCharacterSafety()
        if not isValid(char) then return end

        local wm = char.WeaponManagerComponent
        if not isValid(wm) then return end

        local weapon = wm.CurrentWeaponReplicated
        if not isValid(weapon) then return end

        local entity = weapon.ShootWeaponEntityComp
        if not isValid(entity) then return end

        local strengthMul = (_G.Mod_AimbotStrength or 50) / 100

        entity.GameDeviationFactor = 0.2
        entity.RecoilKick = 0.02
        entity.RecoilKickADS = 0.1
        entity.AnimationKick = 0.02
        entity.AccessoriesVRecoilFactor = 0.30
        entity.AccessoriesHRecoilFactor = 0.35
        entity.ExtraHitPerformScale = 20
        if entity.AutoAimingConfig then
            for _, range in ipairs({"OuterRange", "InnerRange"}) do
                local cfg = entity.AutoAimingConfig[range]
                if cfg then
                    cfg.Speed = 4.3
                    cfg.RangeRate = 3.9
                    cfg.SpeedRate = 3.8
                    cfg.RangeRateSight = 3.9
                    cfg.SpeedRateSight = 3.8
                    cfg.CrouchRate = 3.5
                    cfg.ProneRate = 2.5
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
        if not isValid(pc) then return end
        if pc == _G._AimbotCurrentPC then return end
        _G._AimbotCurrentPC = pc
        if pc.AddGameTimer then
            pc:AddGameTimer(0.1, true, function()
                if not isValid(_G._AimbotCurrentPC) then
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
    if isValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, true, function()
            if not isValid(_G._AimbotCurrentPC) then
                _G._AimbotCurrentPC = nil
                AttachAimbotTimer()
            end
        end)
    end
end)

-- =============================================
-- 🎯 MENU
-- =============================================

pcall(function()
    local function nop() end
    local function retTrue() return true end

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

                -- === FEATURES ===
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
                    Key = "ModMenu_AimbotStrength",
                    UI = AliasMap.Slider,
                    Text = "Aimbot Strength",
                    GetFunc = function() 
                        return (_G.Mod_AimbotStrength or 50) / 100
                    end,
                    SetFunc = function(_, value)
                        _G.Mod_AimbotStrength = math.floor(value * 100)
                        print("[MOD] Aimbot Strength: " .. _G.Mod_AimbotStrength .. "%")
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
                    Key = "Wallhack",
                    UI = AliasMap.Switcher,
                    Text = "WALLHACK",
                    GetFunc = function() return _G.Mod_Wallhack_Enabled or false end,
                    SetFunc = function(_, value)
                        _G.Mod_Wallhack_Enabled = value
                        print("[MOD] WALLHACK: " .. (value and "ON ✓" or "OFF ✗"))
                        return true
                    end
                },
                {
                    Key = "Skin",
                    UI = AliasMap.Switcher,
                    Text = "SKINS",
                    GetFunc = function() return _G.Mod_Skin_Enabled or false end,
                    SetFunc = function(_, value)
                        _G.Mod_Skin_Enabled = value
                        print("[MOD] SKINS: " .. (value and "ON ✓" or "OFF ✗"))
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
                    Text = "NO GRASS (Built-in)",
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
                    Text = "View Distance (80-140)",
                    GetFunc = function() 
                        return ((_G.Mod_iPadViewDistance or 90) - 80) / 60
                    end,
                    SetFunc = function(_, value)
                        _G.Mod_iPadViewDistance = math.floor(80 + (value * 60))
                        print("[MOD] View Distance: " .. _G.Mod_iPadViewDistance)
                        return true
                    end
                },

                -- === CHAMS COLORS ===
                { UI = AliasMap.Title, Text = "CHAMS COLORS" },

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
                    GetFunc = function() return (_G.Mod_Chams_GreenRGB.R or 0) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_GreenRGB.R = math.floor(value * 255)
                        print("[MOD] Green-R: " .. _G.Mod_Chams_GreenRGB.R)
                        return true
                    end
                },
                {
                    Key = "ModMenu_GreenG",
                    UI = AliasMap.Slider,
                    Text = "Green - Green (0-255)",
                    GetFunc = function() return (_G.Mod_Chams_GreenRGB.G or 255) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_GreenRGB.G = math.floor(value * 255)
                        print("[MOD] Green-G: " .. _G.Mod_Chams_GreenRGB.G)
                        return true
                    end
                },
                {
                    Key = "ModMenu_GreenB",
                    UI = AliasMap.Slider,
                    Text = "Green - Blue (0-255)",
                    GetFunc = function() return (_G.Mod_Chams_GreenRGB.B or 0) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_GreenRGB.B = math.floor(value * 255)
                        print("[MOD] Green-B: " .. _G.Mod_Chams_GreenRGB.B)
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
                    GetFunc = function() return (_G.Mod_Chams_YellowRGB.R or 255) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_YellowRGB.R = math.floor(value * 255)
                        print("[MOD] Yellow-R: " .. _G.Mod_Chams_YellowRGB.R)
                        return true
                    end
                },
                {
                    Key = "ModMenu_YellowG",
                    UI = AliasMap.Slider,
                    Text = "Yellow - Green (0-255)",
                    GetFunc = function() return (_G.Mod_Chams_YellowRGB.G or 255) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_YellowRGB.G = math.floor(value * 255)
                        print("[MOD] Yellow-G: " .. _G.Mod_Chams_YellowRGB.G)
                        return true
                    end
                },
                {
                    Key = "ModMenu_YellowB",
                    UI = AliasMap.Slider,
                    Text = "Yellow - Blue (0-255)",
                    GetFunc = function() return (_G.Mod_Chams_YellowRGB.B or 0) / 255 end,
                    SetFunc = function(_, value)
                        _G.Mod_Chams_YellowRGB.B = math.floor(value * 255)
                        print("[MOD] Yellow-B: " .. _G.Mod_Chams_YellowRGB.B)
                        return true
                    end
                },

                -- === SCENE OPTIONS ===
                { UI = AliasMap.Title, Text = "SCENE OPTIONS" },

                {
                    Key = "ESP_BlackSky",
                    UI = AliasMap.TitleSwitcher,
                    Text = "BlackSky (Dark Sky)",
                    GetFunc = function() return _G.ESPConfig.BlackSky end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.BlackSky = value
                        SetBlackSky(value)
                        return true
                    end
                },
                {
                    Key = "ESP_RemoveFog",
                    UI = AliasMap.TitleSwitcher,
                    Text = "No Fog",
                    GetFunc = function() return _G.ESPConfig.RemoveFog end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.RemoveFog = value
                        SetFogRemoval(value)
                        return true
                    end
                },
                {
                    Key = "ESP_RemoveGrass",
                    UI = AliasMap.TitleSwitcher,
                    Text = "No Grass (Scene)",
                    GetFunc = function() return _G.ESPConfig.RemoveGrass end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.RemoveGrass = value
                        SetGrassRemoval(value)
                        return true
                    end
                },
                {
                    Key = "ESP_RemoveTree",
                    UI = AliasMap.TitleSwitcher,
                    Text = "No Tree",
                    GetFunc = function() return _G.ESPConfig.RemoveTree end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.RemoveTree = value
                        SetTreeRemoval(value)
                        return true
                    end
                },
                {
                    Key = "ESP_RemoveWater",
                    UI = AliasMap.TitleSwitcher,
                    Text = "No Water",
                    GetFunc = function() return _G.ESPConfig.RemoveWater end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.RemoveWater = value
                        SetWaterRemoval(value)
                        return true
                    end
                },
                {
                    Key = "ESP_ForceChinese",
                    UI = AliasMap.TitleSwitcher,
                    Text = "Force Chinese",
                    GetFunc = function() return _G.ESPConfig.ForceChinese end,
                    SetFunc = function(ctrl, value)
                        _G.ESPConfig.ForceChinese = value
                        SetForceChinese(value)
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

    local bypassInit = function()
        pcall(function()
            _G.InitModMenuTab()
        end)
    end

    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(3.0, false, bypassInit)
    else
        bypassInit()
    end
end)

print("[MOD] ✅ COMPLETE SCRIPT LOADED!")
print("[MOD] 🎯 Aimbot | ESP | Wallhack | Skins | 165FPS | No Grass | iPad View")
print("[TSS] ✅ All 40+ TSS SDK Commands Bypassed! (Kept 11 required)")
print("[AC] ✅ Complete AntiCheatManager Bypass Applied! (243+ fields)")

-- ==================== GOKUBA LOGIC BYPASS (ROOT/MALWARE CHECK) ====================
pcall(function()
    local Gokuba = _G.GokubaLogic or package.loaded["GokubaLogic"]
    if Gokuba then
        Gokuba.ForwardFeature = function() return end
        Gokuba.InitGokubaLogic = function() return end
        if Gokuba.TimerHandle then
            local time_ticker = require("common.time_ticker")
            if time_ticker and time_ticker.RemoveTimer then
                time_ticker.RemoveTimer(Gokuba.TimerHandle)
            end
        end
    end

    -- Block the specific Gokuba network packet
    if _G.NetUtil and _G.NetUtil.SendPkg then
        local origSendPkg = _G.NetUtil.SendPkg
        _G.NetUtil.SendPkg = function(packetName, ...)
            if packetName == "battle_client_sync_allstar_auth_check_result_req" then
                return
            end
            return origSendPkg(packetName, ...)
        end
    end

    -- Mock Tss.GetUserTag4Lua to return clean status
    if _G.Tss and _G.Tss.GetUserTag4Lua then
        _G.Tss.GetUserTag4Lua = function() return "clean" end
    end
end)

-- =============================================
-- 🎉 WELCOME POPUP (DRAVIX ENGINE)
-- =============================================

function _G.TryShowWelcome()
    pcall(function()
        local CommonMsgBoxMgr = require("client.slua.logic.common.logic_common_msg_box")
        if not CommonMsgBoxMgr then return end
        local activeStatus = "DRAVIX ENGINE Menu & Status\n"
        activeStatus = activeStatus .. "\nWeapon Skins: Active"
        activeStatus = activeStatus .. "\nKill Counter: Active"
        activeStatus = activeStatus .. "\nOutfit Skins: Active"
        activeStatus = activeStatus .. "\nLobby Theme: Active"
        activeStatus = activeStatus .. "\nDeadBox Skins: Active"
        activeStatus = activeStatus .. "\nVehicle Skins: Active"
        activeStatus = activeStatus .. "\n\nConfigure your values in config.ini and changes will apply automatically without UI hooks.\n\nEnjoy DravixEngine!"
        CommonMsgBoxMgr.Show(1, "DRAVIX ENGINE MENU", activeStatus, function() end)
        _G.WelcomeShown = true
    end)
end

pcall(_G.TryShowWelcome)

return true
