//________________________________
//
//   	NS2 Factions Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Factions_GUIExperienceBar.lua

class 'Factions_GUIExperienceBar' (GUIScript)

Factions_GUIExperienceBar.kMarineBarTextureName = "ui/Factions/xpbar_marine.png"
Factions_GUIExperienceBar.kMarineBackgroundTextureName = "ui/Factions/xpbarbg_marine.png"
Factions_GUIExperienceBar.kMarine2BarTextureName = "ui/Factions/xpbar_marine.png"
Factions_GUIExperienceBar.kMarine2BackgroundTextureName = "ui/Factions/xpbarbg_marine.png"

Factions_GUIExperienceBar.kTextFontName = "MicrogrammaDBolExt"

Factions_GUIExperienceBar.kExperienceBackgroundWidth = 450
Factions_GUIExperienceBar.kExperienceBackgroundHeight = 30
Factions_GUIExperienceBar.kExperienceBackgroundMinimisedHeight = 30
Factions_GUIExperienceBar.kExperienceBackgroundOffset = Vector(-Factions_GUIExperienceBar.kExperienceBackgroundWidth/2, -Factions_GUIExperienceBar.kExperienceBackgroundHeight-10, 0)

Factions_GUIExperienceBar.kExperienceBorder = 0

Factions_GUIExperienceBar.kExperienceBarOffset = Vector(Factions_GUIExperienceBar.kExperienceBorder, Factions_GUIExperienceBar.kExperienceBorder, 0)
Factions_GUIExperienceBar.kExperienceBarWidth = Factions_GUIExperienceBar.kExperienceBackgroundWidth - Factions_GUIExperienceBar.kExperienceBorder*2
Factions_GUIExperienceBar.kExperienceBarHeight = Factions_GUIExperienceBar.kExperienceBackgroundHeight - Factions_GUIExperienceBar.kExperienceBorder*2
Factions_GUIExperienceBar.kExperienceBarMinimisedHeight = Factions_GUIExperienceBar.kExperienceBackgroundMinimisedHeight - Factions_GUIExperienceBar.kExperienceBorder*2

// Texture Coords
Factions_GUIExperienceBar.kMarineBarTextureX1 = 12
Factions_GUIExperienceBar.kMarineBarTextureX2 = 500
Factions_GUIExperienceBar.kMarineBarTextureY1 = 0
Factions_GUIExperienceBar.kMarineBarTextureY2 = 31
Factions_GUIExperienceBar.kMarineBarBackgroundTextureX1 = 12
Factions_GUIExperienceBar.kMarineBarBackgroundTextureX2 = 500
Factions_GUIExperienceBar.kMarineBarBackgroundTextureY1 = 0
Factions_GUIExperienceBar.kMarineBarBackgroundTextureY2 = 31
Factions_GUIExperienceBar.kMarine2BarTextureX1 = 13
Factions_GUIExperienceBar.kMarine2BarTextureX2 = 498
Factions_GUIExperienceBar.kMarine2BarTextureY1 = 0
Factions_GUIExperienceBar.kMarine2BarTextureY2 = 31
Factions_GUIExperienceBar.kMarine2BarBackgroundTextureX1 = 13
Factions_GUIExperienceBar.kMarine2BarBackgroundTextureX2 = 498
Factions_GUIExperienceBar.kMarine2BarBackgroundTextureY1 = 0
Factions_GUIExperienceBar.kMarine2BarBackgroundTextureY2 = 31

Factions_GUIExperienceBar.kMarineBackgroundGUIColor = Color(1.0, 1.0, 1.0, 0.2)
Factions_GUIExperienceBar.kMarineGUIColor = Color(1.0, 1.0, 1.0, 0.9)
Factions_GUIExperienceBar.kMarine2BackgroundGUIColor = Color(1.0, 1.0, 1.0, 0.4)
Factions_GUIExperienceBar.kMarine2GUIColor = Color(1.0, 1.0, 1.0, 0.9)
Factions_GUIExperienceBar.kMarineTextColor = Color(1.0, 1.0, 1.0, 1)
Factions_GUIExperienceBar.kMarine2TextColor = Color(0.9, 0.7, 0.7, 1)
Factions_GUIExperienceBar.kExperienceTextFontSize = 15
Factions_GUIExperienceBar.kExperienceTextOffset = Vector(0, -10, 0)
Factions_GUIExperienceBar.kNormalAlpha = 0.9
Factions_GUIExperienceBar.kMinimisedTextAlpha = 0.7
Factions_GUIExperienceBar.kMinimisedAlpha = 0.7

Factions_GUIExperienceBar.kBarFadeInRate = 0.2
Factions_GUIExperienceBar.kBarFadeOutDelay = 0.5
Factions_GUIExperienceBar.kBarFadeOutRate = 0.1
Factions_GUIExperienceBar.kBackgroundBarRate = 90
Factions_GUIExperienceBar.kTextIncreaseRate = 50

local function GetTeamType()

	local player = Client.GetLocalPlayer()
	
	if not player:isa("ReadyRoomPlayer") then	
		local teamnumber = player:GetTeamNumber()
		if teamnumber == kTeam1Index then
			return "Marines"
		elseif teamnumber == kTeam2Index then
			return "Marines"
		elseif teamnumber == kNeutralTeamType then 
			return "Spectator"
		else
			return "Unknown"
		end
	else
		return "Ready Room"
	end
	
end

function Factions_GUIExperienceBar:Initialize()

	self:CreateExperienceBar()
	self.rankIncreased = false
	self.currentExperience = 0
	self.showExperience = false
	self.experienceAlpha = Factions_GUIExperienceBar.kNormalAlpha
	self.experienceTextAlpha = Factions_GUIExperienceBar.kNormalAlpha
	self.barMoving = false
	self.playerTeam = "Ready Room"
	self.fadeOutTime = Shared.GetTime()
	self.experienceData = {}
	
end

function Factions_GUIExperienceBar:CreateExperienceBar()

    self.experienceBarBackground = GUIManager.CreateGraphicItem()
    self.experienceBarBackground:SetSize(Vector(Factions_GUIExperienceBar.kExperienceBackgroundWidth, Factions_GUIExperienceBar.kExperienceBackgroundMinimisedHeight, 0))
    self.experienceBarBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    self.experienceBarBackground:SetPosition(Factions_GUIExperienceBar.kExperienceBackgroundOffset)
	self.experienceBarBackground:SetLayer(kGUILayerPlayerHUDBackground)
    self.experienceBarBackground:SetIsVisible(false)
    
    self.experienceBar = GUIManager.CreateGraphicItem()
    self.experienceBar:SetSize(Vector(Factions_GUIExperienceBar.kExperienceBarWidth, Factions_GUIExperienceBar.kExperienceBarHeight, 0))
    self.experienceBar:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.experienceBar:SetPosition(Factions_GUIExperienceBar.kExperienceBarOffset)
    self.experienceBar:SetIsVisible(false)
    self.experienceBarBackground:AddChild(self.experienceBar)
    
    self.experienceText = GUIManager.CreateTextItem()
    self.experienceText:SetFontSize(Factions_GUIExperienceBar.kExperienceTextFontSize)
    self.experienceText:SetFontName(Factions_GUIExperienceBar.kTextFontName)
    self.experienceText:SetFontIsBold(false)
    self.experienceText:SetAnchor(GUIItem.Center, GUIItem.Top)
    self.experienceText:SetTextAlignmentX(GUIItem.Align_Center)
    self.experienceText:SetTextAlignmentY(GUIItem.Align_Center)
    self.experienceText:SetPosition(Factions_GUIExperienceBar.kExperienceTextOffset)
    self.experienceText:SetIsVisible(false)
    self.experienceBarBackground:AddChild(self.experienceText)
	
end

function Factions_GUIExperienceBar:Update(deltaTime)

	// Alter the display based on team, status.
	local newTeam = false
	if (self.playerTeam ~= GetTeamType()) then
		self.playerTeam = GetTeamType()
		newTeam = true
	end
	
	// We have switched teams.
	if (newTeam) then
		if (self.playerTeam == "Marines") then
			self.experienceBarBackground:SetIsVisible(true)
			self.experienceBar:SetIsVisible(true)
			self.experienceText:SetIsVisible(true)
			self.experienceData.barPixelCoordsX1 = Factions_GUIExperienceBar.kMarineBarTextureX1
			self.experienceData.barPixelCoordsX2 = Factions_GUIExperienceBar.kMarineBarTextureX2
			self.experienceData.barPixelCoordsY1 = Factions_GUIExperienceBar.kMarineBarTextureY1
			self.experienceData.barPixelCoordsY2 = Factions_GUIExperienceBar.kMarineBarTextureY2
			self.experienceBarBackground:SetTexture(Factions_GUIExperienceBar.kMarineBackgroundTextureName)
			self.experienceBarBackground:SetTexturePixelCoordinates(Factions_GUIExperienceBar.kMarineBarBackgroundTextureX1, Factions_GUIExperienceBar.kMarineBarBackgroundTextureY1, Factions_GUIExperienceBar.kMarineBarBackgroundTextureX2, Factions_GUIExperienceBar.kMarineBarBackgroundTextureY2)
			self.experienceBarBackground:SetColor(Factions_GUIExperienceBar.kMarineBackgroundGUIColor)
			self.experienceBar:SetTexture(Factions_GUIExperienceBar.kMarineBarTextureName)
		    self.experienceBar:SetTexturePixelCoordinates(Factions_GUIExperienceBar.kMarineBarTextureX1, Factions_GUIExperienceBar.kMarineBarTextureY1, Factions_GUIExperienceBar.kMarineBarTextureX2, Factions_GUIExperienceBar.kMarineBarTextureY2)
			self.experienceBar:SetColor(Factions_GUIExperienceBar.kMarineGUIColor)
			self.experienceText:SetColor(Factions_GUIExperienceBar.kMarineTextColor)
			self.experienceAlpha = 1.0
			self.showExperience = true
		else
			self.experienceBarBackground:SetIsVisible(false)
			self.experienceBar:SetIsVisible(false)
			self.experienceText:SetIsVisible(false)
			self.showExperience = false
		end
	end
		
	// Recalculate, tween and fade
	if (self.showExperience) then
		self:CalculateExperienceData()
		self:UpdateExperienceBar(deltaTime)
		self:UpdateFading(deltaTime)
		self:UpdateText(deltaTime)
		self:UpdateVisible(deltaTime)
	end
	
end

function Factions_GUIExperienceBar:CalculateExperienceData()

	local player = Client.GetLocalPlayer()
	self.experienceData.isVisible = player:GetIsAlive()
	self.experienceData.targetExperience = player:GetScore()
	self.experienceData.experienceToNextLevel = player:XPUntilNextLevel()
	self.experienceData.nextLevelExperience = player:GetNextLevelXP()
	self.experienceData.thisLevel = player:GetLvl()
	self.experienceData.thisLevelName = player:GetLvlName(self.experienceData.thisLevel)
	self.experienceData.experiencePercent = player:GetLevelProgression()
	self.experienceData.experienceLastTick = self.experienceData.targetExperience

end

function Factions_GUIExperienceBar:UpdateExperienceBar(deltaTime)

    local expBarPercentage = self.experienceData.experiencePercent
	local calculatedBarWidth = Factions_GUIExperienceBar.kExperienceBarWidth * expBarPercentage
	local currentBarWidth = self.experienceBar:GetSize().x
	local targetBarWidth = calculatedBarWidth
	
	// Method to allow proper tweening visualisation when you go up a rank.
	// Currently detecting this by examining old vs new size.
	if (math.ceil(calculatedBarWidth) < math.floor(currentBarWidth)) then
		self.rankIncreased = true
	end
	
	if (self.rankIncreased) then
		targetBarWidth = Factions_GUIExperienceBar.kExperienceBarWidth
		// Once we reach the end, reset the bar back to the beginning.
		if (currentBarWidth >= targetBarWidth) then
			self.rankIncreased = false
			currentBarWidth = 0
			targetBarWidth = calculatedBarWidth
		end
	end
	
	if (self.experienceData.targetExperience == maxXp) then
		currentBarWidth = Factions_GUIExperienceBar.kExperienceBarWidth
		targetBarWidth = Factions_GUIExperienceBar.kExperienceBarWidth
		calculatedBarWidth = Factions_GUIExperienceBar.kExperienceBarWidth
		self.rankIncreased = false
	end
	
	self.experienceBar:SetSize(Vector(Slerp(currentBarWidth, targetBarWidth, deltaTime*Factions_GUIExperienceBar.kBackgroundBarRate), self.experienceBar:GetSize().y, 0))
	local texCoordX2 = self.experienceData.barPixelCoordsX1 + (Slerp(currentBarWidth, targetBarWidth, deltaTime*Factions_GUIExperienceBar.kBackgroundBarRate) / Factions_GUIExperienceBar.kExperienceBarWidth * (self.experienceData.barPixelCoordsX2 - self.experienceData.barPixelCoordsX1))
	self.experienceBar:SetTexturePixelCoordinates(self.experienceData.barPixelCoordsX1, self.experienceData.barPixelCoordsY1, texCoordX2, self.experienceData.barPixelCoordsY2)
	
	// Detect and register if the bar is moving
	if (math.abs(currentBarWidth - calculatedBarWidth) > 0.01) then
		self.barMoving = true
	else
		// Delay the fade out by a while
		if (self.barMoving) then
			self.fadeOutTime = Shared.GetTime() + Factions_GUIExperienceBar.kBarFadeOutDelay
		end
		self.barMoving = false
	end
	
end

function Factions_GUIExperienceBar:UpdateFading(deltaTime)

	local currentBarHeight = self.experienceBar:GetSize().y
	local currentBackgroundHeight = self.experienceBarBackground:GetSize().y
	local currentBarColor = self.experienceBar:GetColor()
	local currentTextColor = self.experienceText:GetColor()
	local targetBarHeight = currentBarHeight
	local targetBackgroundHeight = currentBackgroundHeight
	local targetBarColor = currentBarColor
	local targetAlpha = Factions_GUIExperienceBar.kNormalAlpha
	local targetTextAlpha = Factions_GUIExperienceBar.kNormalAlpha
		
	if (self.barMoving or Shared.GetTime() < self.fadeOutTime) then
		targetBarHeight = Factions_GUIExperienceBar.kExperienceBarHeight
		targetBackgroundHeight = Factions_GUIExperienceBar.kExperienceBackgroundHeight
	else
		targetBarHeight = Factions_GUIExperienceBar.kExperienceBarMinimisedHeight
		targetBackgroundHeight = Factions_GUIExperienceBar.kExperienceBackgroundMinimisedHeight
		targetAlpha = Factions_GUIExperienceBar.kMinimisedAlpha
		targetTextAlpha = Factions_GUIExperienceBar.kMinimisedTextAlpha
	end
	
	self.experienceAlpha = Slerp(self.experienceAlpha, targetAlpha, deltaTime*Factions_GUIExperienceBar.kBarFadeOutRate)
	self.experienceTextAlpha = Slerp(self.experienceTextAlpha, targetTextAlpha, deltaTime*Factions_GUIExperienceBar.kBarFadeOutRate)
	
	self.experienceBarBackground:SetSize(Vector(Factions_GUIExperienceBar.kExperienceBackgroundWidth, Slerp(currentBackgroundHeight, targetBackgroundHeight, deltaTime*Factions_GUIExperienceBar.kBackgroundBarRate), 0))
	self.experienceBar:SetSize(Vector(self.experienceBar:GetSize().x, Slerp(currentBarHeight, targetBarHeight, deltaTime*Factions_GUIExperienceBar.kBackgroundBarRate), 0))
	self.experienceBar:SetColor(Color(currentBarColor.r, currentBarColor.g, currentBarColor.b, self.experienceAlpha))
	self.experienceText:SetColor(Color(currentTextColor.r, currentTextColor.g, currentTextColor.b, self.experienceAlpha))
end

function Factions_GUIExperienceBar:UpdateText(deltaTime)
	// Tween the experience text too!
	self.currentExperience = Slerp(self.currentExperience, self.experienceData.targetExperience, deltaTime*Factions_GUIExperienceBar.kTextIncreaseRate)
	
	// Handle the case when the round changes and we are set back to 0 experience.
	if self.currentExperience > self.experienceData.targetExperience then
		self.currentExperience = 0
	end
	
	if (self.experienceData.targetExperience >= kMaxXp) then
		self.experienceText:SetText("Level " .. self.experienceData.thisLevel .. " / " .. kMaxLvl .. ": " .. tostring(math.ceil(self.currentExperience)) .. " (" .. self.experienceData.thisLevelName .. ")")
	else
		self.experienceText:SetText("Level " .. self.experienceData.thisLevel .. " / " .. kMaxLvl .. ": " .. tostring(math.ceil(self.currentExperience)) .. " / " .. self.experienceData.nextLevelExperience .. " (" .. self.experienceData.thisLevelName .. ")")
	end
end

function Factions_GUIExperienceBar:UpdateVisible(deltaTime)

	// Hide the experience bar if the player is dead.
	self.experienceBarBackground:SetIsVisible(self.experienceData.isVisible)
	
end

function Factions_GUIExperienceBar:Uninitialize()

	if self.experienceBar then
        GUI.DestroyItem(self.experienceBarBackground)
        self.experienceBar = nil
        self.experienceBarText = nil
        self.experienceBarBackground = nil
    end
    
end