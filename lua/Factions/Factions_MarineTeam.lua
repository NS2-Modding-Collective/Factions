//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineTeam.lua

local networkVars = {
}
	
// Different game logic for different game modes.
local originalSpawnInitialStructures = MarineTeam.SpawnInitialStructures
function MarineTeam:SpawnInitialStructures(techPoint)

	// Special logic depending on the game mode
	// For game modes using Combat-like rules
	// Spawn an armory.
	if GetGamerulesInfo():GetIsCombatRules() then
		local tower, commandStation = PlayingTeam.SpawnInitialStructures(self, techPoint)

		//Check if there is already an Armory
		if #GetEntitiesForTeam("Armory", self:GetTeamNumber()) == 0 then	
			// Don't Spawn an IP, make an armory instead!
			// spawn initial Armory for marine team    
			local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
			
			for i = 1, kSpawnMaxRetries do
				// Use a reduced distance for spawn logic.
				local kArmorySpawnMaxDistance = kSpawnMaxDistance / 3
			
				// Increase the spawn distance on a gradual basis.
				local origin = CalculateRandomSpawn(nil, techPointOrigin, kTechId.Armory, true, kArmorySpawnMaxDistance, (kArmorySpawnMaxDistance * i / kSpawnMaxRetries), nil)

				if origin then			
					local armory = CreateEntity(Armory.kMapName, origin - Vector(0, 0.1, 0), self:GetTeamNumber())
					
					SetRandomOrientation(armory)
					armory:SetConstructionComplete()
					
					break				
				end		
			end
		end
		
		self.ipsToConstruct = 0
		
		return tower, commandStation
	else
		return originalSpawnInitialStructures(self, techPoint)
	end
end

// Depending on the game mode, don't check for presence of IPs
local overrideUpdate = MarineTeam.Update
function MarineTeam:Update(timePassed)
	
	if GetGamerulesInfo():GetIsCombatRules() then
		PlayingTeam.Update(self, timePassed)
		
		// Update distress beacon mask
		self:UpdateGameMasks(timePassed)
		
		// Don't check for IPs!
	else
		overrideUpdate(self, timePassed)
	end
	
end