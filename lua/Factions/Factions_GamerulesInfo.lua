//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GamerulesInfo.lua

kFactionsGameType = enum( { 'CombatDeathmatch', 'Xenoswarm', 'MarineDeathmatch' } )

// Global gamerules accessors. When GamerulesInfo is initialized by map they should call SetGamerules(). 
globalGamerulesInfo = globalGamerulesInfo or nil

function GetHasGamerulesInfo()

    return globalGamerulesInfo ~= nil
	
end

function SetGamerulesInfo(GamerulesInfo)

    if GamerulesInfo ~= globalGamerulesInfo then
        globalGamerulesInfo = GamerulesInfo
    end
    
end

function GetGamerulesInfo()

    return globalGamerulesInfo
	
end

Script.Load("lua/Entity.lua")

class 'FactionsGamerulesInfo' (Entity)

FactionsGamerulesInfo.kMapName = "factions_gamerules_info"

local networkVars =
{
	gameType = "enum kFactionsGameType",
	isMarinevsMarine = "boolean",
	isCompetitive = "boolean",
	isCombatRules = "boolean",
	isClassBased = "boolean",
	isFactionsMovemement = "boolean",
	isInSuddenDeath = "boolean",
	lightsStartOff = "boolean",
	usesMarineColours = "boolean",
	usesAlienColours = "boolean",
	timeLimit = "time",
}

function FactionsGamerulesInfo:OnCreate()
	// Set global gamerules info whenever gamerules info is built
	SetGamerulesInfo(self)
	self.timeSinceGameStart = 0
	self.isMapEntity = true
end

if Server then
	function FactionsGamerulesInfo:SetGameType(value)
		self.gameType = value
	end

	function FactionsGamerulesInfo:SetIsCompetitive(value)
		self.isCompetitive = value
	end

	function FactionsGamerulesInfo:SetIsCombatRules(value)
		self.isCombatRules = value
	end

	function FactionsGamerulesInfo:SetIsClassBased(value)
		self.isClassBased = value
	end

	function FactionsGamerulesInfo:SetIsFactionsMovement(value)
		self.isFactionsMovemement = value
	end

	function FactionsGamerulesInfo:SetIsMarinevsMarine(value)
		self.isMarinevsMarine = value
	end
	
	function FactionsGamerulesInfo:SetIsInSuddenDeath(value)
		self.isInSuddenDeath = value
	end
	
	function FactionsGamerulesInfo:SetUsesMarineColours(value)
		self.usesMarineColours = value
	end
	
	function FactionsGamerulesInfo:SetUsesAlienColours(value)
		self.usesAlienColours = value
	end
	
	function FactionsGamerulesInfo:SetTimeLimit(value)
		self.timeLimit = value
	end
	
	function FactionsGamerulesInfo:SetLightsStartOff(value)
		self.lightsStartOff = value
	end
end

function FactionsGamerulesInfo:GetGameType()
	if self.gameType == nil then
		return kFactionsGameType.CombatDeathmatch
	else
		return self.gameType
	end
end

function FactionsGamerulesInfo:GetIsMarinevsMarine()
	return self.isMarinevsMarine
end

function FactionsGamerulesInfo:GetIsCompetitive()
	return self.isCompetitive
end

function FactionsGamerulesInfo:GetIsCombatRules()
	return self.isCombatRules
end

function FactionsGamerulesInfo:GetIsClassBased()
	return self.isClassBased
end

function FactionsGamerulesInfo:GetIsFactionsMovement()
	return self.isFactionsMovemement
end

function FactionsGamerulesInfo:GetIsInSuddenDeath()
	return self.isInSuddenDeath
end

function FactionsGamerulesInfo:GetUsesMarineColours()
	return self.usesMarineColours
end

function FactionsGamerulesInfo:GetUsesAlienColours()
	return self.usesAlienColours
end

function FactionsGamerulesInfo:GetTimeLimit()
	return self.timeLimit
end

function FactionsGamerulesInfo:GetTimeSinceGameStart()
	return self.timeSinceGameStart
end

function FactionsGamerulesInfo:GetLightsStartOff()
	return self.lightsStartOff
end

function FactionsGamerulesInfo:GetTimeRemaining()
	if self.timeLimit == 0 then
		return -1
	else
		local timeLeft = self.timeLimit - self.timeSinceGameStart
		if timeLeft < 0 then
			timeLeft = 0
		end
		return timeLeft
	end
end

local function UpdateLocalGameTimer(self, dt)
	if self.timeLimitCache == nil or self.timeLimitCache ~= self.timeLimit then
		self.timeLimitCache = self.timeLimit
	end
	
	self.timeSinceGameStart = self.timeSinceGameStart + dt
end

function FactionsGamerulesInfo:OnUpdate(dt)
	UpdateLocalGameTimer(self, dt)
end

local cacheGetTeamType = { }
function FactionsGamerulesInfo:GetTeamType(teamNumber)

	local returnType = cacheGetTeamType[teamNumber]
	if returnType == nil then
	
		if teamNumber == kTeam1Index then
			returnType = kMarineTeamType
		elseif teamNumber == kTeam2Index then
			if self.isMarinevsMarine then
				returnType = kMarineTeamType
			else
				returnType = kAlienTeamType
			end
		else
			returnType = kNeutralTeamType
		end
	
		cacheGetTeamType[teamNumber] = returnType
	
	end
	
	return returnType
	
end
	
Shared.LinkClassToMap("FactionsGamerulesInfo", FactionsGamerulesInfo.kMapName, networkVars)