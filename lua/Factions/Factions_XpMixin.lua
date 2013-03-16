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

kMinePointValue =  kMineCost * buildingXpFactor

// default start xp
kPlayerInitialIndivRes = 0
// default start lvl
kStartLevel = 1

// Max xp you can get
kMaxPersonalResources = 9999
kMaxResources = 9999

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
kXpList[7] = { Level=7, 		XP=1450, 	MarineName="Commander", 			XpMultiplier=1.6}
kXpList[8] = { Level=8, 		XP=1900, 	MarineName="Major", 				XpMultiplier=1.7}
kXpList[9] = { Level=9, 		XP=2300, 	MarineName="Field Marshal", 		XpMultiplier=1.8}
kXpList[10] = { Level=10, 	XP=2800, 	MarineName="General", 				XpMultiplier=1.9}
kXpList[11] = { Level=11, 	XP=3500, 	MarineName="President", 			XpMultiplier=2.0}
kXpList[12] = { Level=12, 	XP=4500, 	MarineName="Badass", 				XpMultiplier=2.1}
kXpList[13] = { Level=13, 	XP=6000, 	MarineName="Rambo", 				XpMultiplier=2.2}
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
	"GetResources",
	"GetPersonalResources",
	"GetDisplayResources",
}

XpMixin.networkVars =
{
    level = "integer (0 to 99)",
    // score was no networkvar so add it that we can refer on it as client
    score = "integer (0 to " .. kMaxScore .. ")",
}

function XpMixin:__initmixin()
    self.level = kStartLevel
end

// Resources are divided by 10 as we are limited to 999 max.
function XpMixin:SetResources(amount)

    local oldVisibleResources = math.floor(self.resources * 10)
    
    self.resources = Clamp(amount/10, 0, kMaxPersonalResources)
    
    local newVisibleResources = math.floor(self.resources * 10)
    
    if oldVisibleResources ~= newVisibleResources then
        self:SetScoreboardChanged(true)
    end
    
end

function XpMixin:GetResources()
	return Player.GetResources(self) * 10
end

function XpMixin:GetPersonalResources()
	return Player.GetPersonalResources(self) * 10
end

function XpMixin:GetDisplayResources()
	return Player.GetDisplayResources(self) * 10
end


// also adds res when score will be added so you can use them to buy something
function XpMixin:AddScore(points, res)
    if Server then
        if points ~= nil and points ~= 0 then        
            self:AddResources(points)
            self:SetScoreboardChanged(true)
            self:CheckLvlUp()  
        end    
    end    
end

// gives res back when rejoining
function XpMixin:Reset()     
end

function XpMixin:CheckLvlUp()    
    local xp = self:GetXp()
    local diffLevels = self:GetLvlForXp(xp) - self:GetLvl()
    if diffLevels > 0 then
        //Lvl UP
        self.level = self:GetLvlForXp(xp)        
        // Trigger sound on level up
        //StartSoundEffectAtOrigin(CombatEffects.kMarineLvlUpSound, self:GetOrigin())        
        local LvlName = self:GetLvlName(self:GetLvl())
        //self:SendDirectMessage( "!! Level UP !! New Lvl: " .. LvlName .. " (" .. self:GetLvl() .. ")")
        
        // Trigger an effect
        //self:TriggerEffects("combat_level_up") 
        // For Debugging:
        self:SendDirectMessage( "!! Level UP !! New Lvl: " .. LvlName .. " (" .. self:GetLvl() .. ")")      
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


function XpMixin:GetLvlForXp(xp)

	local returnlevel = 1

	// Look up the level of this amount of Xp
	if xp >= kMaxXp then 
		return maxLvl
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

