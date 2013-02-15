//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GenericGamerules.lua

class 'GenericGamerules' (NS2Gamerules)

GenericGamerules.kMapName = "factions_generic_gamerules"

local networkVars =
{
}

if Server then
	
	// We need this here so that the new logic in NS2Gamerules is not called.
	function GenericGamerules:OnCreate()
	
        originalNS2GamerulesOnCreate(self)
        
    end
	
	// Spawn protection
	function GenericGamerules:JoinTeam(player, newTeamNumber, force)
	
		local success, newPlayer = NS2Gamerules.JoinTeam(self, player, newTeamNumber, force)
		
		if success then
		
			//set spawn protect
			if HasMixin(newPlayer, "SpawnProtect") then
				newPlayer:SetSpawnProtect()
			end
			
		end
	
	end
	
	
	// Make sure to override these in your child class
	function GenericGamerules:GetGameModeName()
		return "No mode name"
	end
	
	// Note use of a table of messages here.
	function GenericGamerules:GetGameModeText()
		return { "No mode description" }
	end
	
	// Send a message to players when they connect.
	function GenericGamerules:OnClientConnect(client)

		NS2Gamerules.OnClientConnect(self, client)
		local player = client:GetControllingPlayer()
		
		player:BuildAndSendDirectMessage("Welcome to Factions v" .. kFactionsVersion .. "!")
		player:BuildAndSendDirectMessage("Current Game Mode: " .. self:GetGameModeName())
		for index, message in ipairs(self:GetGameModeText()) do
			player:BuildAndSendDirectMessage(message)
		end
		
	end
	
	// Reveal the command chair locations with this.
	function GenericGamerules:RevealCommandChairLocations()
	
		for index, commandStructure in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
			commandStructure:RevealObjective()
		end
	
	end
	
	// Useful for locking the command chairs on game start.
	function GenericGamerules:LockCommandChairs()
	
		for index, commandStructure in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
			commandStructure:LockCommandChair()
		end
	
	end

end

Shared.LinkClassToMap("GenericGamerules", GenericGamerules.kMapName, networkVars)