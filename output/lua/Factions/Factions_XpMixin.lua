//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_XpMixin.lua
// Changes everything needed for the xp system

Script.Load("lua/MixinUtility.lua")

/*
    Classes (base xp you get when you kill someone, 
    will be multiplied by the XpMultiplier from his level)
    TODO: Also include every new class
*/

kSkulkPointValue = 30
kGorgePointValue = 90
kLerkPointValue = 70
kFadePointValue = 150
kOnosPointValue = 300
kMarinePointValue = 60
kJetpackPointValue = 80
kExosuitPointValue = 120

// Buildings
// only get 80 % xp of what the building has cost when you destroy it
local buildingXpFactor = 0.8
kArmoryPointValue = kArmoryCost * buildingXpFactor
kObservatoryPointValue = kObservatoryCost * buildingXpFactor
kPhaseGatePointValue = kPhaseGateCost * buildingXpFactor
kSentryPointValue = kSentryCost * buildingXpFactor
kPowerPointPointValue = 0

kMinePointValue = kMineCost * buildingXpFactor

// default start xp
kPlayerInitialIndivRes = 0
// default start lvl
kStartLevel = 1
kStartXPAvailable = 0

// Max xp you can get
kMaxXP = 25000
kMaxScore = kMaxXP
kMaxPersonalResources = kMaxXP
kMaxResources = kMaxXP

// how much % from the xp are the teammates nearby getting and the range
mateXpAmount = 0.4
mateXpRange = 20


// How much lvl you will lose when you rejoin the same team
kPenaltyLevel = 1

// list will all level names, given xp, needed xp for next lvl etc.
kXpList = {}
//              Level       NeededXp    LevelName                       XpMultiplier (the killer gets)                
kXpList[1] = { Level=1, 		XP=0,		MarineName="Private", 				XpMultiplier=1}
kXpList[2] = { Level=2, 		XP=100, 	MarineName="Private First Class", 	XpMultiplier=1.1}
kXpList[3] = { Level=3, 		XP=250, 	MarineName="Corporal", 				XpMultiplier=1.2}
kXpList[4] = { Level=4, 		XP=500, 	MarineName="Sergeant", 				XpMultiplier=1.3}
kXpList[5] = { Level=5, 		XP=800, 	MarineName="Lieutenant", 			XpMultiplier=1.4}
kXpList[6] = { Level=6, 		XP=1100, 	MarineName="Captain", 				XpMultiplier=1.5}
kXpList[7] = { Level=7, 		XP=1450, 	MarineName="Veteran", 				XpMultiplier=1.6}
kXpList[8] = { Level=8, 		XP=1900, 	MarineName="Commander", 			XpMultiplier=1.7}
kXpList[9] = { Level=9, 		XP=2300, 	MarineName="Major", 				XpMultiplier=1.8}
kXpList[10] = { Level=10, 		XP=2800, 	MarineName="Field Marshal", 		XpMultiplier=1.9}
kXpList[11] = { Level=11, 		XP=3500, 	MarineName="General", 				XpMultiplier=2.0}
kXpList[12] = { Level=12, 		XP=4000, 	MarineName="President", 			XpMultiplier=2.1}
kXpList[13] = { Level=13, 		XP=4500, 	MarineName="Badass", 				XpMultiplier=2.2}
kXpList[14] = { Level=14, 		XP=5000, 	MarineName="Rambo", 				XpMultiplier=2.3}
kXpList[15] = { Level=15, 		XP=5500, 	MarineName="Ninja", 				XpMultiplier=2.4}
kMaxLvl = table.maxn(kXpList)
kMaxXp = kXpList[kMaxLvl]["XP"]

XpMixin = CreateMixin( XpMixin )
XpMixin.type = "Xp"

XpMixin.optionalCallbacks =
{
}

XpMixin.expectedCallbacks = 
{
}

XpMixin.overrideFunctions =
{
	"SetResources",
	"AddResources",
	"GetResources",
	"GetPersonalResources",
	"GetDisplayResources",
}

XpMixin.networkVars =
{
    level = "integer (0 to 99)",
	permanentXpAvailable = "integer (0 to " .. kMaxXP .. ")",
    // score was no networkvar so add it that we can refer on it as client
    score = "integer (0 to " .. kMaxScore .. ")",
    upgradePointsSpent = "integer (0 to " .. kMaxLvl .. ")",
}

function XpMixin:__initmixin()
    self:ResetXp()
end

// gives res back when rejoining
function XpMixin:Reset()
	self:ResetXp()
end

function XpMixin:ResetXp()
    self.level = kStartLevel
	self.permanentXpAvailable = kStartXPAvailable
	self:ResetSpentUpgradePoints()
	self:ApplyLevelTiedUpgrades()
end

function XpMixin:CopyPlayerDataFrom(player)

	if player.level then		
		self.level = player.level
		self.permanentXpAvailable = player.permanentXpAvailable
		self.upgradePointsSpent = player.upgradePointsSpent
		self:ApplyLevelTiedUpgrades()
	end

end

// Resources are divided by 10 as we are limited to 999 max.
function XpMixin:SetResources(amount)

    local oldVisibleResources = math.floor(self.permanentXpAvailable)

    self.permanentXpAvailable = Clamp(amount, 0, kMaxPersonalResources)
    
    local newVisibleResources = math.floor(self.permanentXpAvailable)
    
    if oldVisibleResources ~= newVisibleResources then
        self:SetScoreboardChanged(true)
    end
    
end

function XpMixin:AddResources(amount)

    local resReward = math.min(amount, kMaxPersonalResources - self:GetResources())
    local oldRes = self:GetResources()
    self:SetResources(self:GetResources() + resReward)
    
    if oldRes ~= self:GetResources() then
        self:SetScoreboardChanged(true)
    end
    
    return resReward
    
end

function XpMixin:GetResources()
	return self.permanentXpAvailable
end

function XpMixin:GetPersonalResources()
	return self.permanentXpAvailable
end

function XpMixin:GetDisplayResources()
	return self.permanentXpAvailable
end

function XpMixin:GetUpgradePointsAvailable()
	return math.max(0, self.level - self.upgradePointsSpent)
end

// Keep the same notation as AddResources. Negative number means we are spending.
function XpMixin:AddUpgradePoints(amount)
	local spentAmount = amount * -1
	self.upgradePointsSpent = math.max(self.upgradePointsSpent + spentAmount, kStartLevel)
end

function XpMixin:ResetSpentUpgradePoints()
	self.upgradePointsSpent = kStartLevel
end

// also adds res when score will be added so you can use them to buy something
function XpMixin:AddScore(points, res, noNearbyXp)
    if Server then
        if points ~= nil and points ~= 0 then        
            self:AddResources(points)
            self:SetScoreboardChanged(true)
            self:CheckLvlUp()
            // Don't get stuck in an endless cycle when adding nearby xp
            if noNearbyXp == nil and not noNearbyXp then
			    self:GiveXpToTeammatesNearby(points)
            end
        end    
    end    
end

function XpMixin:CheckLvlUp()    
    local xp = self:GetXp()
	local lvlForXp = self:GetLvlForXp(xp)
	local oldLvl = self:GetLvl()
	if oldLvl == nil then
		oldLvl = 0
	end
    local diffLevels = lvlForXp - oldLvl
    if diffLevels > 0 then
        //Lvl UP
        self.level = lvlForXp
		
        // Trigger sound on level up
        //StartSoundEffectAtOrigin(CombatEffects.kMarineLvlUpSound, self:GetOrigin())        
        local LvlName = self:GetLvlName(self:GetLvl())
        
        // Trigger an effect
        //self:TriggerEffects("combat_level_up") 
		
		// Apply any new level tied upgrades.
		self:ApplyLevelTiedUpgrades()
    end   
end  

// returns the current lvl
function XpMixin:GetLvl()
    if self.level then
        return self.level
    else
        return 0    
    end  
end

function XpMixin:GetXp()
    if self.score then
        return self.score
    else
        return 0    
    end         
end

// Todo: implement caching here
function XpMixin:GetLvlForXp(xp)

	local returnlevel = 1

	// Look up the level of this amount of Xp
	if xp >= kMaxXp then 
		return kMaxLvl
	elseif xp <= 0 then
		return 0
	end
	
	// ToDo: Do a faster search instead. We're going to be here a lot!
	for index, thislevel in ipairs(kXpList) do
	
		if xp >= thislevel["XP"] and 
		   xp < kXpList[index+1]["XP"] then
		
			returnlevel = thislevel["Level"]
		
		end
		
	end

	return returnlevel
end

// returns the name for the lvl
function XpMixin:GetLvlName(lvl)

	local LvlName = ""
	if kXpList[lvl] then
        LvlName = kXpList[lvl]["MarineName"]	
    end
	return LvlName
	
end

// returns the needed xp for the lvl
function XpMixin:XpForLvl(lvl)

	local returnXp = kXpList[1]["XP"]

	if lvl > 0 then
		returnXp = kXpList[lvl]["XP"]
	end

	return returnXp
end

function XpMixin:XPUntilNextLevel()
	
	local xp = self:GetScore()
	local lvl = self:GetLvl()
	
	if lvl == kMaxLvl then
		return 0
	else	
	    return kXpList[lvl + 1]["XP"] - xp
    end

end

function XpMixin:GetNextLevelXP()

	local xp = self:GetScore()
	local lvl = self:GetLvl()
	
	if lvl == kMaxLvl then
		return kMaxXp
	else	
	    return kXpList[lvl + 1]["XP"]
    end

end

function XpMixin:SetLevel(newLevel)
	local XpNeeded = self:XpForLvl(newLevel)
	self.score = XpNeeded
	self.level = newLevel
end

// Return the proportion of this level that we've progressed.
function XpMixin:GetLevelProgression()

	local xp = self:GetScore()
    local lvl = self:GetLvl()
    
	if lvl == kMaxLvl then
		return 1
	else	
        local thisLevel = kXpList[lvl]["XP"]
        local nextLevel = kXpList[lvl + 1]["XP"]
        return (xp - thisLevel) / (nextLevel - thisLevel)
    end
end

// Give XP to teammates around you when you kill an enemy
function Player:GiveXpToTeammatesNearby(xp)

	xp = xp * mateXpAmount

	local playersInRange = GetEntitiesForTeamWithinRange("Player", self:GetTeamNumber(), self:GetOrigin(), mateXpRange)
	
	// Only give Xp to players who are alive!
	for _, player in ipairs(playersInRange) do
		if self ~= player and player:GetIsAlive() then
			player:AddScore(xp, xp, true)    
		end
	end

end

