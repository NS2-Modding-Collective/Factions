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
CombatDeathmatchGamerules.kDefaultTimeLimit = 1800

local networkVars =
{
	timelimit = "integer (1 to 65535)"
}

if Server then

	function CombatDeathmatchGamerules:OnCreate()
	
		self.isMarinevsMarine = false
		self.isCompetitive = true
		self.isClassBased = false
		self.isCombatRules = true
		self.isFactionsMovement = false
		self.usesMarineColours = false
		self.usesAlienColours = false
		self.lightsStartOff = false
		self.powerPointsTakeDamage = true
		self.factionsGameType = kFactionsGameType.CombatDeathmatch
	
		GenericGamerules.OnCreate(self)
		
	end

	function CombatDeathmatchGamerules:GetGameModeName()
		return "Combat Deathmatch"
	end
	
	function CombatDeathmatchGamerules:GetGameModeText()
		return { "Both sides fight until the other team's Hive/CC is destroyed,",
                 "or the time runs out!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function CombatDeathmatchGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.timelimit = CombatDeathmatchGamerules.kDefaultTimeLimit
		
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