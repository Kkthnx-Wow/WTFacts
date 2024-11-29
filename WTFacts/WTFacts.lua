local _, namespace = ...

-- Cache Globals and Functions
-- local math_floor = math.floor
local math_random = math.random
-- local string_format = string.format
local C_PartyInfo_IsPartyWalkIn = C_PartyInfo.IsPartyWalkIn
local C_Timer_After = C_Timer.After
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local SendChatMessage = SendChatMessage
local time = time

local WTFacts = namespace:CreateFrame("Frame")

-- Cooldown and Lock Tracking
local lastFactTime = 0
local factLock = false

-- Utility Functions
local function GetChatChannel()
	if IsPartyLFG() or C_PartyInfo_IsPartyWalkIn() then
		return "INSTANCE_CHAT"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	else
		return nil
	end
end

-- Main Logic
local function ShowRandomFact()
	if not namespace:GetOption("enabled") then
		return
	end

	if factLock then
		return
	end

	local currentTime = time()
	local cooldown = namespace:GetOption("cooldown") * 60
	local delay = namespace:GetOption("delay")
	local timeLeft = cooldown - (currentTime - lastFactTime)

	if timeLeft > 0 then
		return
	end

	local randomFact = namespace.factslist[math_random(#namespace.factslist)]
	local channel = GetChatChannel()

	if not channel then
		print("|cff5bc0be[WTFacts]: No valid chat channel available. You must be in a party, raid, or instance.|r")
		return
	end

	factLock = true
	C_Timer_After(delay, function()
		SendChatMessage("[WTFacts]: " .. randomFact, channel)
		lastFactTime = currentTime
		factLock = false
	end)
end

-- Event Registration Management
local function UpdateEventRegistration()
	WTFacts:UnregisterAllEvents(ShowRandomFact)

	if namespace:GetOption("achievementEarned") then
		WTFacts:RegisterEvent("ACHIEVEMENT_EARNED", ShowRandomFact)
	end
	if namespace:GetOption("bossKill") then
		WTFacts:RegisterEvent("BOSS_KILL", ShowRandomFact)
	end
	if namespace:GetOption("mythicPlusCompleted") then
		WTFacts:RegisterEvent("CHALLENGE_MODE_COMPLETED", ShowRandomFact)
	end
	if namespace:GetOption("dungeonCompletion") then
		WTFacts:RegisterEvent("LFG_COMPLETION_REWARD", ShowRandomFact)
	end
	if namespace:GetOption("levelUp") then
		WTFacts:RegisterEvent("PLAYER_LEVEL_UP", ShowRandomFact)
	end
end

-- Slash Command for Manual Trigger
namespace:RegisterSlash("/wtfacts", function()
	ShowRandomFact()
end)

-- On Addon Loaded
function namespace:OnLoad()
	print("|cff5bc0beWTFacts Loaded!|r Type /wtfacts to manually trigger a fact.")
end

-- On Player Login
function namespace:OnLogin()
	namespace:Defer(UpdateEventRegistration)

	namespace:RegisterOptionCallback("enabled", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)

	namespace:RegisterOptionCallback("cooldown", function(value) end)
	namespace:RegisterOptionCallback("delay", function(value) end)

	namespace:RegisterOptionCallback("achievementEarned", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)

	namespace:RegisterOptionCallback("bossKill", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)

	namespace:RegisterOptionCallback("mythicPlusCompleted", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)

	namespace:RegisterOptionCallback("dungeonCompletion", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)

	namespace:RegisterOptionCallback("levelUp", function(value)
		namespace:Defer(UpdateEventRegistration)
	end)
end
