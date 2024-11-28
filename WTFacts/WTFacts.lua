-- Addon Table
local _, namespace = ...
local WTFacts = namespace:CreateFrame("Frame")

-- Cooldown Tracker
local lastFactTime = 0

-- Function to get the appropriate chat channel
local function GetChatChannel()
	if IsPartyLFG() or C_PartyInfo.IsPartyWalkIn() then
		return "INSTANCE_CHAT"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	else
		return "SAY"
	end
end

-- Function to format time
local function FormatTime(seconds)
	if seconds >= 60 then
		local mins = math.floor(seconds / 60)
		local secs = seconds % 60
		return string.format("%d min%s %d sec%s", mins, mins > 1 and "s" or "", secs, secs > 1 and "s" or "")
	else
		return string.format("%d sec%s", seconds, seconds > 1 and "s" or "")
	end
end

-- Function to display a random fact
local function ShowRandomFact()
	if not namespace:GetOption("enabled") then
		print("|cff5bc0be[WTFacts]: The addon is currently disabled.|r")
		return
	end

	local currentTime = time()
	local cooldown = namespace:GetOption("cooldown") * 60
	local delay = namespace:GetOption("delay")
	local timeLeft = cooldown - (currentTime - lastFactTime)

	if timeLeft > 0 then
		print(string.format("|cff5bc0be[WTFacts]: The addon is on cooldown. %s remaining.|r", FormatTime(timeLeft)))
		return
	end

	lastFactTime = currentTime
	local randomFact = namespace.factslist[math.random(#namespace.factslist)]
	local channel = GetChatChannel()

	print(string.format("||cff5bc0be[WTFacts]: Sending fact in %d seconds...|r", delay))
	C_Timer.After(delay, function()
		SendChatMessage("[WTFacts]: " .. randomFact, channel)
	end)
end

-- Register Events
WTFacts:RegisterEvent("ACHIEVEMENT_EARNED", ShowRandomFact)
WTFacts:RegisterEvent("BOSS_KILL", ShowRandomFact)
WTFacts:RegisterEvent("CHALLENGE_MODE_COMPLETED", ShowRandomFact)
WTFacts:RegisterEvent("LFG_COMPLETION_REWARD", ShowRandomFact)
WTFacts:RegisterEvent("PLAYER_LEVEL_UP", ShowRandomFact)

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
	if namespace:GetOption("enabled") then
		print("|cff5bc0beWTFacts is enabled.|r You can configure it via the settings panel.")
	else
		print("|cff5bc0beWTFacts is currently disabled.|r Enable it via the settings panel.")
	end
end
