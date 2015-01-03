-- Tekkub from WoWI/GitHub made this so easy!

sArena.OptionsPanel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
sArena.OptionsPanel.name = sArena.AddonName
sArena.OptionsPanel:Hide()

function sArena.OptionsPanel:Initialize()
	local Title, SubTitle = LibStub("tekKonfig-Heading").new(self, sArena.AddonName, "Improved arena frames")

	local ClearButton = LibStub("tekKonfig-Button").new_small(self, "TOPRIGHT", -16, -16)
	ClearButton:SetSize(56, 22)
	ClearButton:SetText("Clear")
	ClearButton.tiptext = "Hides any testing frames that are visible"
	ClearButton:SetScript("OnClick", function(s) sArena:HideArenaEnemyFrames() end)

	local Test5Button = LibStub("tekKonfig-Button").new_small(self, "TOPRIGHT", ClearButton, "TOPLEFT", -25, 0)
	Test5Button:SetSize(56, 22)
	Test5Button:SetText("Test 5")
	Test5Button.tiptext = "Displays 5 test frames"
	Test5Button:SetScript("OnClick", function(s) sArena:Test(5) end)

	local Test3Button = LibStub("tekKonfig-Button").new_small(self, "TOPRIGHT", Test5Button, "TOPLEFT", -5, 0)
	Test3Button:SetSize(56, 22)
	Test3Button:SetText("Test 3")
	Test3Button.tiptext = "Displays 3 test frames"
	Test3Button:SetScript("OnClick", function(s) sArena:Test(3) end)

	local Test2Button = LibStub("tekKonfig-Button").new_small(self, "TOPRIGHT", Test3Button, "TOPLEFT", -5, 0)
	Test2Button:SetSize(56, 22)
	Test2Button:SetText("Test 2")
	Test2Button.tiptext = "Displays 2 test frames"
	Test2Button:SetScript("OnClick", function(s) sArena:Test(2) end)

	local LockButton = LibStub("tekKonfig-Button").new_small(self, "TOPRIGHT", Test2Button, "TOPLEFT", -25, 0)
	LockButton:SetSize(56, 22)
	LockButton:SetText(sArenaDB.lock and "Unlock" or "Lock")
	LockButton.tiptext = "Hides title bar and prevents dragging"
	LockButton:SetScript("OnClick", function(s)
		if sArena:CombatLockdown() then return end

		sArenaDB.lock = not sArenaDB.lock
		LockButton:SetText(sArenaDB.lock and "Unlock" or "Lock")
		
		if sArenaDB.lock then
			sArena:Hide()
		else
			sArena:Show()
		end
	end)

	local ScaleText = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	ScaleText:SetText("Frame Scale: ")
	ScaleText:SetPoint("TOPLEFT", SubTitle, "BOTTOMLEFT", 0, 0)

	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = {left = 0, right = 0, top = 0, bottom = 0},
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 8
	}

	local ScaleEditBox = CreateFrame("EditBox", nil, self)
	ScaleEditBox:SetPoint("TOPLEFT", ScaleText, "TOPRIGHT", 4, 3)
	ScaleEditBox:SetSize(35, 20)
	ScaleEditBox:SetFontObject(GameFontHighlight)
	ScaleEditBox:SetTextInsets(4,4,2,2)
	ScaleEditBox:SetBackdrop(backdrop)
	ScaleEditBox:SetBackdropColor(0,0,0,.4)
	ScaleEditBox:SetAutoFocus(false)
	ScaleEditBox:SetText(sArenaDB.scale)
	ScaleEditBox:SetScript("OnEditFocusLost", function() 
		if sArena:CombatLockdown() then
			ScaleEditBox:SetText(sArenaDB.scale)
			return
		end
		
		if type(tonumber(ScaleEditBox:GetText())) == "number" and tonumber(ScaleEditBox:GetText()) > 0 then
			sArenaDB.scale = ScaleEditBox:GetText()
			sArena.Frame:SetScale(sArenaDB.scale)
		else
			ScaleEditBox:SetText(sArenaDB.scale)
		end
	end)
	ScaleEditBox:SetScript("OnEscapePressed", ScaleEditBox.ClearFocus)
	ScaleEditBox:SetScript("OnEnterPressed", ScaleEditBox.ClearFocus)
	ScaleEditBox.tiptext = "Sets the scale of the arena frames. Numbers between 0.5 and 2 recommended."
	ScaleEditBox:SetScript("OnEnter", ClearButton:GetScript("OnEnter"))
	ScaleEditBox:SetScript("OnLeave", ClearButton:GetScript("OnLeave"))
	
	local CastingBarScaleText = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	CastingBarScaleText:SetText("Casting Bar Scale: ")
	CastingBarScaleText:SetPoint("LEFT", ScaleEditBox, "RIGHT", 10, 0)
	
	local CastingBarScaleEditBox = CreateFrame("EditBox", nil, self)
	CastingBarScaleEditBox:SetPoint("TOPLEFT", CastingBarScaleText, "TOPRIGHT", 4, 3)
	CastingBarScaleEditBox:SetSize(35, 20)
	CastingBarScaleEditBox:SetFontObject(GameFontHighlight)
	CastingBarScaleEditBox:SetTextInsets(4,4,2,2)
	CastingBarScaleEditBox:SetBackdrop(backdrop)
	CastingBarScaleEditBox:SetBackdropColor(0,0,0,.4)
	CastingBarScaleEditBox:SetAutoFocus(false)
	CastingBarScaleEditBox:SetText(sArenaDB.castingBarScale)
	CastingBarScaleEditBox:SetScript("OnEditFocusLost", function() 
		if sArena:CombatLockdown() then
			CastingBarScaleEditBox:SetText(sArenaDB.castingBarScale)
			return
		end
		
		if type(tonumber(CastingBarScaleEditBox:GetText())) == "number" and tonumber(CastingBarScaleEditBox:GetText()) > 0 then
			sArenaDB.castingBarScale = CastingBarScaleEditBox:GetText()
			for i = 1, MAX_ARENA_ENEMIES do
			_G["ArenaEnemyFrame"..i.."CastingBar"]:SetScale(sArenaDB.castingBarScale)
			end
		else
			CastingBarScaleEditBox:SetText(sArenaDB.castingBarScale)
		end
	end)
	CastingBarScaleEditBox:SetScript("OnEscapePressed", CastingBarScaleEditBox.ClearFocus)
	CastingBarScaleEditBox:SetScript("OnEnterPressed", CastingBarScaleEditBox.ClearFocus)
	CastingBarScaleEditBox.tiptext = "Sets the scale of the casting bars. Numbers between 0.5 and 2 recommended."
	CastingBarScaleEditBox:SetScript("OnEnter", ClearButton:GetScript("OnEnter"))
	CastingBarScaleEditBox:SetScript("OnLeave", ClearButton:GetScript("OnLeave"))
	
	local FlipCastingBarCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Flip Casting Bars", "LEFT", CastingBarScaleEditBox, "RIGHT", 10, 0)
	FlipCastingBarCheckbox.tiptext = "Move casting bars to the right side of the arena frames."
	FlipCastingBarCheckbox:SetHitRectInsets(0, -40, 0, 0)
	FlipCastingBarCheckbox:SetChecked(sArenaDB.flipCastingBar and true or false)
	FlipCastingBarCheckbox:SetScript("OnClick", function()
		if sArena:CombatLockdown() then
			FlipCastingBarCheckbox:SetChecked(sArenaDB.flipCastingBar and true or false)
			return
		end
		sArenaDB.flipCastingBar = FlipCastingBarCheckbox:GetChecked() and true or false
		for i = 1, MAX_ARENA_ENEMIES do
			_G["ArenaEnemyFrame"..i.."CastingBar"]:ClearAllPoints()
			if sArenaDB.flipCastingBar then
				_G["ArenaEnemyFrame"..i.."CastingBar"]:SetPoint("LEFT", _G["ArenaEnemyFrame"..i], "RIGHT", 38, -3)
			else
				_G["ArenaEnemyFrame"..i.."CastingBar"]:SetPoint("RIGHT", _G["ArenaEnemyFrame"..i], "LEFT", -15, -3)
			end
		end
	end)
	
	local ClassColoursFrame = LibStub("tekKonfig-Group").new(self, "Class Colours", "TOPLEFT", ScaleText, "BOTTOMLEFT", 0, -24)
	ClassColoursFrame:SetPoint("RIGHT", self, -16, 0)
	ClassColoursFrame:SetHeight(40)
	ClassColoursFrame:SetFrameLevel(3)
	
	local ClassColoursHealthbarCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Health Bar", "TOPLEFT", ClassColoursFrame, 8, -8)
	ClassColoursHealthbarCheckbox.tiptext = "Colour health bars by class."
	ClassColoursHealthbarCheckbox:SetHitRectInsets(0, -40, 0, 0)
	ClassColoursHealthbarCheckbox:SetChecked(sArenaDB.classcolours.health and true or false)
	ClassColoursHealthbarCheckbox:SetScript("OnClick", function()
		sArenaDB.classcolours.health = ClassColoursHealthbarCheckbox:GetChecked() and true or false
	end)
	
	local ClassColoursNameCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Name", "LEFT", ClassColoursHealthbarCheckbox, "RIGHT", 72, 0)
	ClassColoursNameCheckbox.tiptext = "Colour names by class."
	ClassColoursNameCheckbox:SetHitRectInsets(0, -40, 0, 0)
	ClassColoursNameCheckbox:SetChecked(sArenaDB.classcolours.name and true or false)
	ClassColoursNameCheckbox:SetScript("OnClick", function()
		sArenaDB.classcolours.name = ClassColoursNameCheckbox:GetChecked() and true or false
	end)
	
	local ClassColoursFrameCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Frame", "LEFT", ClassColoursNameCheckbox, "RIGHT", 45, 0)
	ClassColoursFrameCheckbox.tiptext = "Colour frames by class."
	ClassColoursFrameCheckbox:SetHitRectInsets(0, -40, 0, 0)
	ClassColoursFrameCheckbox:SetChecked(sArenaDB.classcolours.frame and true or false)
	ClassColoursFrameCheckbox:SetScript("OnClick", function()
		sArenaDB.classcolours.frame = ClassColoursFrameCheckbox:GetChecked() and true or false
	end)
	
	local TrinketsFrame = LibStub("tekKonfig-Group").new(self, "Trinkets", "TOPLEFT", ClassColoursFrame, "BOTTOMLEFT", 0, -16)
	TrinketsFrame:SetPoint("RIGHT", self, -16, 0)
	TrinketsFrame:SetHeight(80)
	TrinketsFrame:SetFrameLevel(3)
	
	local TrinketsEnableCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Enable", "TOPLEFT", TrinketsFrame, 8, -8)
	TrinketsEnableCheckbox.tiptext = "Displays a cooldown icon when an enemy uses their PvP trinket."
	TrinketsEnableCheckbox:SetHitRectInsets(0, -40, 0, 0)
	TrinketsEnableCheckbox:SetChecked(sArenaDB.Trinkets.enabled and true or false)
	TrinketsEnableCheckbox:SetScript("OnClick", function()
		sArenaDB.Trinkets.enabled = TrinketsEnableCheckbox:GetChecked() and true or false
		sArena.Trinkets:HideTrinkets()
		sArena.Trinkets:Test(5)
		sArena.Trinkets:PLAYER_ENTERING_WORLD()
	end)

	local TrinketsAlwaysShowCheckbox = LibStub("tekKonfig-Checkbox").new(self, nil, "Always Show", "LEFT", TrinketsEnableCheckbox, "RIGHT", 45, 0)
	TrinketsAlwaysShowCheckbox.tiptext = "Always show trinket icons, regardless of whether they are on cooldown"
	TrinketsAlwaysShowCheckbox:SetChecked(sArenaDB.Trinkets.alwaysShow and true or false)
	TrinketsAlwaysShowCheckbox:SetScript("OnClick", function()
		sArenaDB.Trinkets.alwaysShow = TrinketsAlwaysShowCheckbox:GetChecked() and true or false
		sArena.Trinkets:AlwaysShow(sArenaDB.Trinkets.alwaysShow)
	end)

	local TrinketsIconScaleText = TrinketsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	TrinketsIconScaleText:SetText("Icon Scale: ")
	TrinketsIconScaleText:SetPoint("TOPLEFT", TrinketsEnableCheckbox, "BOTTOMLEFT", 6, -8)

	local TrinketsIconScaleEditBox = CreateFrame("EditBox", nil, self)
	TrinketsIconScaleEditBox:SetPoint("LEFT", TrinketsIconScaleText, "RIGHT", 4, -1)
	TrinketsIconScaleEditBox:SetSize(35, 20)
	TrinketsIconScaleEditBox:SetFontObject(GameFontHighlight)
	TrinketsIconScaleEditBox:SetTextInsets(4,4,2,2)
	TrinketsIconScaleEditBox:SetBackdrop(backdrop)
	TrinketsIconScaleEditBox:SetBackdropColor(0,0,0,.4)
	TrinketsIconScaleEditBox:SetAutoFocus(false)
	TrinketsIconScaleEditBox:SetText(sArenaDB.Trinkets.scale)
	TrinketsIconScaleEditBox:SetScript("OnEditFocusLost", function() 
		if sArena:CombatLockdown() then
			TrinketsIconScaleEditBox:SetText(sArenaDB.Trinkets.scale)
			return
		end
		
		if type(tonumber(TrinketsIconScaleEditBox:GetText())) == "number" and tonumber(TrinketsIconScaleEditBox:GetText()) > 0 then
			sArenaDB.Trinkets.scale = TrinketsIconScaleEditBox:GetText()
			sArena.Trinkets:Scale(sArenaDB.Trinkets.scale)
		else
			TrinketsIconScaleEditBox:SetText(sArenaDB.Trinkets.scale)
		end
	end)
	TrinketsIconScaleEditBox:SetScript("OnEscapePressed", TrinketsIconScaleEditBox.ClearFocus)
	TrinketsIconScaleEditBox:SetScript("OnEnterPressed", TrinketsIconScaleEditBox.ClearFocus)
	TrinketsIconScaleEditBox.tiptext = "Sets the scale of the trinket icons."
	TrinketsIconScaleEditBox:SetScript("OnEnter", ClearButton:GetScript("OnEnter"))
	TrinketsIconScaleEditBox:SetScript("OnLeave", ClearButton:GetScript("OnLeave"))
end

InterfaceOptions_AddCategory(sArena.OptionsPanel)
SLASH_sArena1 = "/sarena"
SlashCmdList[sArena.AddonName] = function() InterfaceOptionsFrame_OpenToCategory(sArena.OptionsPanel) end
