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

-- Register Callbacks for Settings
namespace:RegisterOptionCallback("enabled", function(value)
	if value then
		print("|cff5bc0beWTFacts Enabled!|r")
	else
		print("|cff5bc0beWTFacts Disabled!|r")
	end
end)

namespace:RegisterOptionCallback("cooldown", function(value)
	print(string.format("|cff5bc0beWTFacts Cooldown set to %d minutes.|r", value))
end)

namespace:RegisterOptionCallback("delay", function(value)
	print(string.format("|cff5bc0beWTFacts Message Delay set to %d seconds.|r", value))
end)
