//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
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

	function CombatDeathmatchGamerules:OnCreate()
	
		GenericGamerules.OnCreate(self)
		
		isMarinevsMarine = true
		isCompetitive = true
		
	end

	function CombatDeathmatchGamerules:GetGameModeName()
		return "Combat Deathmatch"
	end
	
	function CombatDeathmatchGamerules:GetGameModeText()
		return { "Both sides fight until the other team's CC is destroyed,",
                 "or one side runs out of lives!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function CombatDeathmatchGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.team1Tokens = kInitialTokenValue
		self.team2Tokens = kInitialTokenValue
		
		// Lock the command chairs and reveal the objectives.
		self:RevealCommandChairLocations()
		self:LockCommandChairs()
		
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function CombatDeathmatchGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayers()
			local team2Players = self.team2:GetNumPlayers()
				
			if (team1Players > 0 and team2Players > 0) or (Shared.GetCheatsEnabled() and (team1Players > 0 or team2Players > 0)) then
				
				if self:GetGameState() == kGameState.NotStarted then
					self:SetGameState(kGameState.PreGame)
				end
					
			elseif self:GetGameState() == kGameState.PreGame then
				self:SetGameState(kGameState.NotStarted)
			end
				
		end
        
    end

end

Shared.LinkClassToMap("CombatDeathmatchGamerules", CombatDeathmatchGamerules.kMapName, networkVars)