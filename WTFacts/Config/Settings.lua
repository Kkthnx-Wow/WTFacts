local _, namespace = ...

local string_format = string.format

-- Register Settings with Event Options
namespace:RegisterSettings("WTFactsDB", {
	{
		key = "enabled",
		type = "toggle",
		title = "Enable WTFacts",
		tooltip = "Enable or disable the WTFacts addon.",
		default = true,
	},
	{
		key = "cooldown",
		type = "slider",
		title = "Fact Cooldown (minutes)",
		tooltip = "Set the cooldown period for facts (in minutes).",
		default = 10,
		minValue = 1,
		maxValue = 60,
		valueStep = 1,
		valueFormat = function(value)
			return string_format("%d min", value)
		end,
	},
	{
		key = "delay",
		type = "slider",
		title = "Message Delay (seconds)",
		tooltip = "Set the delay for sending the message after triggering (in seconds).",
		default = 2,
		minValue = 1,
		maxValue = 5,
		valueStep = 1,
		valueFormat = function(value)
			return string_format("%d sec", value)
		end,
	},
	{
		key = "achievementEarned",
		type = "toggle",
		title = "Fact-worthy Achievements",
		tooltip = "Get a random WTFact when you earn an achievement.",
		default = true,
	},
	{
		key = "bossKill",
		type = "toggle",
		title = "Boss Down Facts",
		tooltip = "Drop a random WTFact when you or your group defeats a boss.",
		default = true,
	},
	{
		key = "mythicPlusCompleted",
		type = "toggle",
		title = "Mythic+ Fact Finish",
		tooltip = "Celebrate Mythic+ completions with a random WTFact.",
		default = true,
	},
	{
		key = "dungeonCompletion",
		type = "toggle",
		title = "Dungeon Done Facts",
		tooltip = "Reveal a random WTFact after finishing a dungeon.",
		default = true,
	},
	{
		key = "levelUp",
		type = "toggle",
		title = "Level Up Laughter",
		tooltip = "Share a fun WTFact to celebrate leveling up.",
		default = true,
	},
})
