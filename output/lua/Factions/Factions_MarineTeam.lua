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

local originalInitialise = MarineTeam.Initialize
function MarineTeam:Initialize(teamName, teamNumber)

	originalInitialise(self, teamName, teamNumber)
    self.clientOwnedStructures = { }
	
end

local originalOnInitialized = MarineTeam.OnInitialized
function MarineTeam:OnInitialized()

	originalOnInitialized(self)
    self.clientOwnedStructures = { }
	
end
	
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

function MarineTeam:GetNumDroppedStructures(player, techId)

    local structureTypeTable = self:GetDroppedMarineStructures(player, techId)
    return (not structureTypeTable and 0) or #structureTypeTable
    
end

local function RemoveMarineStructureFromClient(self, techId, clientId)

    local structureTypeTable = self.clientOwnedStructures[clientId]
    
    if structureTypeTable then
    
        if not structureTypeTable[techId] then
        
            structureTypeTable[techId] = { }
            return
            
        end    
        
        local removeIndex = 0
        local structure = nil
        for index, id in ipairs(structureTypeTable[techId])  do
        
            if id then
            
                removeIndex = index
                structure = Shared.GetEntity(id)
                break
                
            end
            
        end
        
        if structure then
        
            table.remove(structureTypeTable[techId], removeIndex)
            structure.consumed = true
            if structure:GetCanDie() then
                structure:Kill()
            else
                DestroyEntity(structure)
            end
            
        end
        
    end
    
end

function MarineTeam:AddMarineStructure(player, structure)

    if player ~= nil and structure ~= nil then
    
        local clientId = Server.GetOwner(player):GetUserId()
        local structureId = structure:GetId()
        local techId = structure:GetTechId()

        if not self.clientOwnedStructures[clientId] then
            self.clientOwnedStructures[clientId] = { }
        end
        
        local structureTypeTable = self.clientOwnedStructures[clientId]
        
        if not structureTypeTable[techId] then
            structureTypeTable[techId] = { }
        end
        
        table.insertunique(structureTypeTable[techId], structureId)
        
        local numAllowedStructure = LookupTechData(techId, kTechDataMaxAmount, -1) //* self:GetNumHives()
        
        if numAllowedStructure >= 0 and table.count(structureTypeTable[techId]) > numAllowedStructure then
            RemoveMarineStructureFromClient(self, techId, clientId)
        end
        
    end
    
end

function MarineTeam:GetDroppedMarineStructures(player, techId)

    local owner = Server.GetOwner(player)

    if owner then
    
        local clientId = owner:GetUserId()
        local structureTypeTable = self.clientOwnedStructures[clientId]
        
        if structureTypeTable then
            return structureTypeTable[techId]
        end
    
    end
    
end

function MarineTeam:GetNumDroppedMarineStructures(player, techId)

    local structureTypeTable = self:GetDroppedMarineStructures(player, techId)
    return (not structureTypeTable and 0) or #structureTypeTable
    
end

function MarineTeam:UpdateClientOwnedStructures(oldEntityId)

    if oldEntityId then
    
        for clientId, structureTypeTable in pairs(self.clientOwnedStructures) do
        
            for techId, structureList in pairs(structureTypeTable) do
            
                for i, structureId in ipairs(structureList) do
                
                    if structureId == oldEntityId then
                    
                        if newEntityId then
                            structureList[i] = newEntityId
                        else
                        
                            table.remove(structureList, i)
                            break
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end

end

function MarineTeam:OnEntityChange(oldEntityId, newEntityId)

    PlayingTeam.OnEntityChange(self, oldEntityId, newEntityId)

    // Check if the oldEntityId matches any client's built structure and
    // handle the change.
    
    self:UpdateClientOwnedStructures(oldEntityId)

end

Class_Reload("MarineTeam", networkVars)