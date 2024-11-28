local _, namespace = ...

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
			return string.format("%d min", value)
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
			return string.format("%d sec", value)
		end,
	},
})
