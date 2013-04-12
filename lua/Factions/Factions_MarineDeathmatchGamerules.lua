//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineDeathmatchGamerules.lua

Script.Load("lua/Factions/Factions_GenericGamerules.lua")

class 'MarineDeathmatchGamerules' (GenericGamerules)

MarineDeathmatchGamerules.kMapName = "factions_marinedeathmatch_gamerules"

local networkVars =
{
	team1Tokens = "integer (0 to 1000)",
	team2Tokens = "integer (0 to 1000)",
}

if Server then

	function MarineDeathmatchGamerules:OnCreate()
	
		GenericGamerules.OnCreate(self)
		
		self.isMarinevsMarine = true
		self.isCompetitive = true
		self.isClassBased = true
		self.isCombatRules = true
		self.isFactionsMovement = true
		self.usesMarineColours = true
		self.usesAlienColours = false
		self.factionsGameType = kFactionsGameType.MarineDeathmatch
		
		// Marines vs. Marines
		kTeam1Type = kMarineTeamType
		kTeam2Type = kMarineTeamType

		kMarineTeamColor = 0x3390FF
		kMarineTeamColorFloat = Color(0.2, 0.564, 1)

		kAlienTeamColor = 0x41FF30
		kAlienTeamColorFloat = Color(0.254, 1, 0.188)

		// Used for playing team and scoreboard
		kTeam1Name = "TSA"
		kTeam2Name = "TSF"
		
	end

	function MarineDeathmatchGamerules:GetGameModeName()
		return "Combat Deathmatch"
	end
	
	function MarineDeathmatchGamerules:GetGameModeText()
		return { "Both sides fight until the other team's CC is destroyed,",
                 "or one side runs out of lives!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function MarineDeathmatchGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.team1Tokens = kInitialTokenValue
		self.team2Tokens = kInitialTokenValue
		
		// Lock the command chairs and reveal the objectives.
		self:RevealCommandChairLocations()
		self:LockCommandChairs()
		
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function MarineDeathmatchGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayersWithAnyClass()
			local team2Players = self.team2:GetNumPlayersWithAnyClass()
				
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

Shared.LinkClassToMap("MarineDeathmatchGamerules", MarineDeathmatchGamerules.kMapName, networkVars)