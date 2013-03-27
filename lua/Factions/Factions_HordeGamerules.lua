//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_HordeGamerules.lua

Script.Load("lua/Factions/Factions_GenericGamerules.lua")

class 'HordeGamerules' (GenericGamerules)

HordeGamerules.kMapName = "factions_horde_gamerules"

local kGameEndCheckInterval = 0.75

local networkVars =
{
	timeLeft = "time",
}

if Server then

	function HordeGamerules:GetGameModeName()
		return "Horde"
	end
	
	function HordeGamerules:GetGameModeText()
		return { "Defend your command station against waves of marauding enemies!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function HordeGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.timeLeft = kInitialTimeLeft
		
		// Lock the command chairs
		self:LockCommandChairs()
		
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function HordeGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayers()
				
			if (team1Players > 0) then
				
				if self:GetGameState() == kGameState.NotStarted then
					self:SetGameState(kGameState.PreGame)
				end
					
			elseif self:GetGameState() == kGameState.PreGame then
				self:SetGameState(kGameState.NotStarted)
			end
				
		end
        
    end
	
	function HordeGamerules:CheckGameEnd()
    
        if self:GetGameStarted() and self.timeGameEnded == nil and not Shared.GetCheatsEnabled() and not self.preventGameEnd then
        
            if self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + kGameEndCheckInterval) then
            
                local team1Lost = self.team1:GetHasTeamLost()
                local team1Won = self.team1:GetHasTeamWon()
                
                local team1Players = self.team1:GetNumPlayers()
                
                if (team1Lost and team1Won) then
                    self:DrawGame()
                elseif team1Lost then
                    self:EndGame(self.team2)
                elseif team1Won then
                    self:EndGame(self.team1)
                end
                
                self.timeLastGameEndCheck = Shared.GetTime()
                
            end
            
        end
        
    end

end

Shared.LinkClassToMap("HordeGamerules", HordeGamerules.kMapName, networkVars)