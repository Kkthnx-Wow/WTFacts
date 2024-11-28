-- Addon Table
local _, namespace = ...

-- Cache Globals and Functions for Performance
local math_floor = math.floor
local math_random = math.random
local string_format = string.format
local C_PartyInfo_IsPartyWalkIn = C_PartyInfo.IsPartyWalkIn
local C_Timer_After = C_Timer.After
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local SendChatMessage = SendChatMessage
local time = time

local WTFacts = namespace:CreateFrame("Frame")

-- Cooldown Tracker
local lastFactTime = 0

-- Utility Functions

-- Function to get the appropriate chat channel
local function GetChatChannel()
	if IsPartyLFG() or C_PartyInfo_IsPartyWalkIn() then
		return "INSTANCE_CHAT"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	else
		-- No valid chat channel available
		return nil
	end
end

-- Function to format time
local function FormatTime(seconds)
	if seconds >= 60 then
		local mins = math_floor(seconds / 60)
		local secs = seconds % 60
		return string_format("%d min%s %d sec%s", mins, mins > 1 and "s" or "", secs, secs > 1 and "s" or "")
	else
		return string_format("%d sec%s", seconds, seconds > 1 and "s" or "")
	end
end

-- Main Logic

-- Function to display a random fact
local function ShowRandomFact()
	if not namespace:GetOption("enabled") then
		return
	end

	local currentTime = time()
	local cooldown = namespace:GetOption("cooldown") * 60
	local delay = namespace:GetOption("delay")
	local timeLeft = cooldown - (currentTime - lastFactTime)

	if timeLeft > 0 then
		print(string_format("|cff5bc0be[WTFacts]: The addon is on cooldown. %s remaining.|r", FormatTime(timeLeft)))
		return
	end

	local randomFact = namespace.factslist[math_random(#namespace.factslist)]
	local channel = GetChatChannel()

	if not channel then
		print("|cff5bc0be[WTFacts]: No valid chat channel available. You must be in a party, raid, or instance.|r")
		return -- Exit without setting cooldown
	end

	print(string_format("|cff5bc0be[WTFacts]: Sending fact in %d seconds...|r", delay))
	C_Timer_After(delay, function()
		SendChatMessage("[WTFacts]: " .. randomFact, channel)
		lastFactTime = currentTime -- Set cooldown time only after successful output
	end)
end

-- Dynamic Event Registration

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

-- Register Callbacks for Settings
namespace:RegisterOptionCallback("enabled", function(value)
	UpdateEventRegistration()
end)

namespace:RegisterOptionCallback("cooldown", function(value) end)

namespace:RegisterOptionCallback("delay", function(value) end)

namespace:RegisterOptionCallback("achievementEarned", function(value)
	UpdateEventRegistration()
end)

namespace:RegisterOptionCallback("bossKill", function(value)
	UpdateEventRegistration()
end)

namespace:RegisterOptionCallback("mythicPlusCompleted", function(value)
	UpdateEventRegistration()
end)

namespace:RegisterOptionCallback("dungeonCompletion", function(value)
	UpdateEventRegistration()
end)

namespace:RegisterOptionCallback("levelUp", function(value)
	UpdateEventRegistration()
end)

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
end
