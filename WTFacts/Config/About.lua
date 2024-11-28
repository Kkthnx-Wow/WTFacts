local _, namespace = ...

-- Function to create the About section canvas
local function CreateAboutCanvas(canvas)
	-- Set the canvas size and default padding
	canvas:SetAllPoints(true)

	-- Title
	local title = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP", canvas, "TOP", 0, -70)
	title:SetText("|cffFFD700WTFacts|r") -- Gold text color

	-- Description
	local description = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	description:SetPoint("TOP", title, "BOTTOM", 0, -10)
	description:SetWidth(500)
	description:SetText("WTFacts is a World of Warcraft addon that delivers random and fun facts to enhance your gameplay experience. " .. "Whether you're leveling up, defeating a boss, or completing a dungeon, WTFacts surprises you with unique trivia about Azeroth, its characters, and more!")

	-- Features Heading
	local featuresHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	featuresHeading:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -20)
	featuresHeading:SetText("|cffFFD700Features:|r")

	-- Features List
	local features = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	features:SetPoint("TOPLEFT", featuresHeading, "BOTTOMLEFT", 0, -10)
	features:SetWidth(500)
	features:SetText("- Random Facts triggered by specific game events.\n" .. "- Customizable settings for cooldowns, delays, and enabled events.\n" .. "- Group-aware fact delivery in appropriate chat channels.")

	-- Triggered Events Heading
	local eventsHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	eventsHeading:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)
	eventsHeading:SetText("|cffFFD700Triggered Events:|r")

	-- Triggered Events List
	local events = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	events:SetPoint("TOPLEFT", eventsHeading, "BOTTOMLEFT", 0, -10)
	events:SetWidth(500)
	events:SetText("- Boss Kill\n" .. "- Level Up\n" .. "- Dungeon Completion\n" .. "- Mythic+ Completion\n" .. "- Achievement Earned")

	-- Slash Commands Heading
	local commandsHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	commandsHeading:SetPoint("TOPLEFT", events, "BOTTOMLEFT", 0, -20)
	commandsHeading:SetText("|cffFFD700Slash Commands:|r")

	-- Slash Commands List
	local commands = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	commands:SetPoint("TOPLEFT", commandsHeading, "BOTTOMLEFT", 0, -10)
	commands:SetWidth(500)
	commands:SetText("/wtfacts - Manually trigger a random fact.")

	-- Contributions Heading
	local contributionsHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	contributionsHeading:SetPoint("TOPLEFT", commands, "BOTTOMLEFT", 0, -20)
	contributionsHeading:SetText("|cffFFD700Contributions:|r")

	-- PayPal Button
	local paypalButton = CreateFrame("Button", nil, canvas, "UIPanelButtonTemplate")
	paypalButton:SetPoint("TOPLEFT", contributionsHeading, "BOTTOMLEFT", 0, -10)
	paypalButton:SetSize(150, 25)
	paypalButton:SetText("Donate via PayPal")
	paypalButton:SetScript("OnClick", function()
		print("Visit this link to donate: https://www.paypal.com/paypalme/kkthnxtv")
	end)
	paypalButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Click to open the donation link.")
		GameTooltip:Show()
	end)
	paypalButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Feedback Button
	local feedbackButton = CreateFrame("Button", nil, canvas, "UIPanelButtonTemplate")
	feedbackButton:SetPoint("TOPLEFT", paypalButton, "BOTTOMLEFT", 0, -10)
	feedbackButton:SetSize(150, 25)
	feedbackButton:SetText("Report Feedback")
	feedbackButton:SetScript("OnClick", function()
		print("Visit the repository for feedback: https://github.com/Kkthnx-Wow/WTFacts")
	end)
	feedbackButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Click to open the feedback repository.")
		GameTooltip:Show()
	end)
	feedbackButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Support Heading
	local supportHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	supportHeading:SetPoint("TOPLEFT", feedbackButton, "BOTTOMLEFT", 0, -20)
	supportHeading:SetText("|cffFFD700Support:|r")

	-- Support Details
	local support = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	support:SetPoint("TOPLEFT", supportHeading, "BOTTOMLEFT", 0, -10)
	support:SetWidth(500)
	support:SetText("Have feedback, ideas, or bugs to report? Click 'Report Feedback' or contact us directly.")
end

-- Register the About canvas with the interface
namespace:RegisterSubSettingsCanvas("About", CreateAboutCanvas)
