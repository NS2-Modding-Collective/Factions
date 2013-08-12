//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_XenoswarmGamerules.lua

Script.Load("lua/Factions/Factions_GenericGamerules.lua")

class 'XenoswarmGamerules' (GenericGamerules)

XenoswarmGamerules.kMapName = "xenoswarm_gamerules"

local kGameEndCheckInterval = 0.75
local kMaxDifficulty = 10

local networkVars =
{
	timeLeft = "time",
	teamScore = "integer (0 to " .. kMaxScore .. ")",
	difficulty = "integer (0 to " .. kMaxDifficulty .. ")",
}

if Server then

	function XenoswarmGamerules:OnCreate()
	
		self.isMarinevsMarine = false
		self.isCompetitive = false
		self.isClassBased = true
		self.isCombatRules = true
		self.isFactionsMovement = true
		self.usesMarineColours = true
		self.usesAlienColours = false
		self.lightsStartOff = false
		self.powerPointsTakeDamage = false
		self.startWithArmory = true
		self.startWithPhaseGate = true
		self.injuredMarines = true
		self.factionsGameType = kFactionsGameType.Xenoswarm
	
		GenericGamerules.OnCreate(self)
		
		SetCachedTechData(kTechId.Sentry, kTechDataNotOnInfestation, false)
		SetCachedTechData(kTechId.Armory, kTechDataNotOnInfestation, false)
		SetCachedTechData(kTechId.MiniArmory, kTechDataNotOnInfestation, false)
		SetCachedTechData(kTechId.PhaseGate, kTechDataNotOnInfestation, false)
		SetCachedTechData(kTechId.Observatory, kTechDataNotOnInfestation, false)
		
	end

	function XenoswarmGamerules:GetGameModeName()
		return "Xenoswarm"
	end
	
	function XenoswarmGamerules:GetGameHintText(isSupport)
	
		local gameHintText = { "To change your class type 'class' in the console.", 
								"To buy upgrades press the Evolve key.", }
		
		if isSupport then
			table.insert(gameHintText, "As a support, build structures with the weapon in slot " .. kBuilderHUDSlot)
		end
		
		return gameHintText
				 
	end
				 
	
	function XenoswarmGamerules:GetGameModeText()

		local gameModeText =  { "Defend your command station against waves of marauding enemies!",
								"-------", }
								
		for index, text in ipairs(self:GetGameHintText(false)) do
			table.insert(gameModeText, text)
		end
		
		return gameModeText
				 
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function XenoswarmGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.timeLeft = kInitialTimeLeft
		
		// Lock the command chairs
		self:LockCommandChairs()
		self.difficulty = self.team1:GetNumPlayersWithAnyClass()
		
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function XenoswarmGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayersWithAnyClass()
				
			if (team1Players > 0) then
				
				if self:GetGameState() == kGameState.NotStarted then
					self:SetGameState(kGameState.PreGame)
				end
					
			elseif self:GetGameState() == kGameState.PreGame then
				self:SetGameState(kGameState.NotStarted)
			end
				
		end
        
    end
	
	function XenoswarmGamerules:CheckGameEnd()
    
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

function XenoswarmGamerules:GetDifficulty()

	return self.difficulty

end

function XenoswarmGamerules:SetDifficulty(newDifficulty)

	self.difficulty = newDifficulty
	SendGlobalChatMessage("Difficulty set to " .. self.difficulty .. " / " .. kMaxDifficulty)

end

function XenoswarmGamerules:JoinTeam(player, newTeamNumber, force)
	
	local oldTeamNumber = player:GetTeamNumber()
	
	local success, newPlayer = GenericGamerules.JoinTeam(self, player, newTeamNumber, force)
	
	if success then
	
		// Adjust the difficulty if a player joins or leaves team 1
		if  (oldTeamNumber ~= kTeam1Index and newTeamNumber == kTeam1Index) or
			(oldTeamNumber == kTeam1Index and newTeamNumber ~= kTeam1Index) then
			self:RecalculateDifficulty()
		end
		
	end

end

// Recalculate difficulty on disconnect
function XenoswarmGamerules:OnClientDisconnect(client)

	GenericGamerules.OnClientDisconnect(self, client)
	
	self:RecalculateDifficulty()
	
end

function XenoswarmGamerules:RecalculateDifficulty()

	local newDifficulty = self.team1:GetNumPlayers()
	if self:GetDifficulty() ~= newDifficulty then
		self:SetDifficulty(newDifficulty)
	end

end

function XenoswarmGamerules:ResetDifficulty()

	self:SetDifficulty(0)

end

// Enforce unbalanced teams!
function XenoswarmGamerules:GetCanJoinTeamNumber(teamNumber)

	if teamNumber == kTeam1Index then
		return true
	else
		return false
	end

end

Shared.LinkClassToMap("XenoswarmGamerules", XenoswarmGamerules.kMapName, networkVars)