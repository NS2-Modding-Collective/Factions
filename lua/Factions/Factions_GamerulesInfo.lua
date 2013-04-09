//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GamerulesInfo.lua

kFactionsGameType = enum( { 'CombatDeathmatch', 'Horde', 'MarineDeathmatch' } )

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
	usesMarineColours = "boolean",
}

function FactionsGamerulesInfo:OnCreate()
	// Set global gamerules info whenever gamerules info is built
	SetGamerulesInfo(self)
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

// TODO: Implement a cache here.
function FactionsGamerulesInfo:GetTeamType(teamNumber)
	if teamNumber == kTeam1Index then
		return kMarineTeamType
	elseif teamNumber == kTeam2Index then
		if self.isMarinevsMarine then
			return kMarineTeamType
		else
			return kAlienTeamType
		end
	else
		return kNeutralTeamType
	end
end
	
Shared.LinkClassToMap("FactionsGamerulesInfo", FactionsGamerulesInfo.kMapName, networkVars)