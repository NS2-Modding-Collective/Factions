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

local function SpawnMarineStructure(self, techPoint, techId, mapName, spawnPointsTable, maxRange)

	local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
	local newStructureExtents = LookupTechData(kTechId.Marine, kTechDataMaxExtents)
	local newStructureHeight = newStructureExtents.y
	local newStructureWidth = math.max(newStructureExtents.x, newStructureExtents.z)
	
	local spawnPoint = nil
	
	// First check the predefined spawn points. Look for a close one.
	for p = 1, #spawnPointsTable do
	
		local predefinedSpawnPoint = spawnPointsTable[p]
		if (predefinedSpawnPoint - techPointOrigin):GetLength() <= maxRange then
			spawnPoint = predefinedSpawnPoint
		end
		
	end
	
	// Fallback on the random method if there is no nearby spawn point.
	if not spawnPoint then
	
		for i = 1, 100 do
		
			local origin = GetRandomSpawnForCapsule(newStructureHeight, newStructureWidth, techPointOrigin + Vector(0, 0.4, 0), kInfantryPortalMinSpawnDistance, maxRange, EntityFilterAll())
			
			if origin then
				origin = GetGroundAtPosition(origin, nil, PhysicsMask.AllButPCs, newStructureExtents)
				spawnPoint = origin - Vector(0, 0.1, 0)
			end
			
		end
		
	end
	
	if spawnPoint then
	
		local structure = CreateEntity(mapName, spawnPoint, self:GetTeamNumber())
		
		SetRandomOrientation(structure)
		structure:SetConstructionComplete()
		
	end
	
end
	
// Different game logic for different game modes.
local originalSpawnInitialStructures = MarineTeam.SpawnInitialStructures
function MarineTeam:SpawnInitialStructures(techPoint)

	// Special logic depending on the game mode
	// For game modes using Combat-like rules
	// Spawn an armory.
	if GetGamerulesInfo():GetIsCombatRules() then
		local tower, commandStation = PlayingTeam.SpawnInitialStructures(self, techPoint)

		if GetGamerulesInfo():GetStartWithArmory() then
			SpawnMarineStructure(self, techPoint, kTechId.Armory, Armory.kMapName, Server.armorySpawnPoints, kSpawnMaxDistance)
		end
		
		if GetGamerulesInfo():GetStartWithPhaseGate() then
			SpawnMarineStructure(self, techPoint, kTechId.PhaseGate, PhaseGate.kMapName, Server.phaseGateSpawnPoints, kSpawnMaxDistance)
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