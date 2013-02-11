//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_CombatDeathmatchGamerules.lua

Script.Load("lua/Factions/Factions_GenericGamerules.lua")

class 'CombatDeathmatchGamerules' (GenericGamerules)

CombatDeathmatchGamerules.kMapName = "factions_combatdeathmatch_gamerules"

local networkVars =
{
	team1Tokens = "integer (0 to 1000)",
	team2Tokens = "integer (0 to 1000)",
}

if Server then

	local overrideResetGame = GenericGamerules.ResetGame
	function CombatDeathmatchGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.team1Tokens = kInitialTokenValue
		self.team2Tokens = kInitialTokenValue
		
	end

end

Shared.LinkClassToMap("CombatDeathmatchGamerules", CombatDeathmatchGamerules.kMapName, networkVars)