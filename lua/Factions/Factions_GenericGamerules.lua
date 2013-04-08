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
	isMarinevsMarine = "boolean",
	isCompetitive = "boolean",
	isCombatRules = "boolean",
	isClassBased = "boolean",
	isFactionsMovemement = "boolean",
}

if Server then
	
	// We need this here so that the new logic in NS2Gamerules is not called.
	function GenericGamerules:OnCreate()
	
        originalNS2GamerulesOnCreate(self)
		
		Server.CreateEntity(FactionsGamerulesInfo.kMapName)
		
		Shared.Message("Server started for Factions v" .. kFactionsVersion .. "!")
		Shared.Message("Current Game Mode: " .. self:GetGameModeName())
        
    end
	
	function GenericGamerules:GetIsMarinevsMarine()
		return self.isMarinevsMarine
	end
	
	function GenericGamerules:GetIsCompetitive()
		return self.isCompetitive
	end
	
	function GenericGamerules:GetIsCombatRules()
		return self.isCombatRules
	end
	
	function GenericGamerules:GetIsClassBased()
		return self.isClassBased
	end
	
	function GenericGamerules:GetIsFactionsMovement()
		return self.isClassBased
	end
	
	/**
     * Starts a new game by resetting the map and all of the players. Keep everyone on current teams (readyroom, playing teams, etc.) but 
     * respawn playing players.
     */
    function GenericGamerules:ResetGame()
    
        // save commanders for later re-login
        local team1CommanderClientIndex = self.team1:GetCommander() and self.team1:GetCommander().clientIndex or nil
        local team2CommanderClientIndex = self.team2:GetCommander() and self.team2:GetCommander().clientIndex or nil
        
        // Cleanup any peeps currently in the commander seat by logging them out
        // have to do this before we start destroying stuff.
        self:LogoutCommanders()
        
        // Destroy any map entities that are still around
        DestroyLiveMapEntities()
        
        // Track which clients have joined teams so we don't 
        // give them starting resources again if they switch teams
        self.userIdsInGame = {}
        
        self:SetGameState(kGameState.NotStarted)
        
        // Reset all players, delete other not map entities that were created during 
        // the game (hives, command structures, initial resource towers, etc)
        // We need to convert the EntityList to a table since we are destroying entities
        // within the EntityList here.
        for index, entity in ientitylist(Shared.GetEntitiesWithClassname("Entity")) do
        
            // Don't reset/delete NS2Gamerules or TeamInfo.
            // NOTE!!!
            // MapBlips are destroyed by their owner which has the MapBlipMixin.
            // There is a problem with how this reset code works currently. A map entity such as a Hive creates
            // it's MapBlip when it is first created. Before the entity:isa("MapBlip") condition was added, all MapBlips
            // would be destroyed on map reset including those owned by map entities. The map entity Hive would still reference
            // it's original MapBlip and this would cause problems as that MapBlip was long destroyed. The right solution
            // is to destroy ALL entities when a game ends and then recreate the map entities fresh from the map data
            // at the start of the next game, including the NS2Gamerules. This is how a map transition would have to work anyway.
            // Do not destroy any entity that has a parent. The entity will be destroyed when the parent is destroyed or
            // when the owner manually destroyes the entity.
            local shieldTypes = { "GameInfo", "MapBlip", "NS2Gamerules" }
            local allowDestruction = true
            for i = 1, #shieldTypes do
                allowDestruction = allowDestruction and not entity:isa(shieldTypes[i])
            end
            
            if allowDestruction and entity:GetParent() == nil then
            
                local isMapEntity = entity:GetIsMapEntity()
                local mapName = entity:GetMapName()
                
                // Reset all map entities and all player's that have a valid Client (not ragdolled players for example).
                local resetEntity = entity:isa("FactionsGamerulesInfo") or entity:isa("TeamInfo") or entity:GetIsMapEntity() or (entity:isa("Player") and entity:GetClient() ~= nil)
                if resetEntity then
                
                    if entity.Reset then
                        entity:Reset()
                    end
                    
                else
                    DestroyEntity(entity)
                end
                
            end       
            
        end
        
        // Clear out obstacles from the navmesh before we start repopualating the scene
        RemoveAllObstacles()
        
        // Build list of tech points
        local techPoints = EntityListToTable(Shared.GetEntitiesWithClassname("TechPoint"))
        if table.maxn(techPoints) < 2 then
            Print("Warning -- Found only %d %s entities.", table.maxn(techPoints), TechPoint.kMapName)
        end
        
        local resourcePoints = Shared.GetEntitiesWithClassname("ResourcePoint")
        if resourcePoints:GetSize() < 2 then
            Print("Warning -- Found only %d %s entities.", resourcePoints:GetSize(), ResourcePoint.kPointMapName)
        end
        
        local team1TechPoint = nil
        local team2TechPoint = nil
        if Server.spawnSelectionOverrides then
        
            local selectedSpawn = self.techPointRandomizer:random(1, #Server.spawnSelectionOverrides)
            selectedSpawn = Server.spawnSelectionOverrides[selectedSpawn]
            
            for t = 1, #techPoints do
            
                local techPointName = string.lower(techPoints[t]:GetLocationName())
                if techPointName == selectedSpawn.marineSpawn then
                    team1TechPoint = techPoints[t]
                elseif techPointName == selectedSpawn.alienSpawn then
                    team2TechPoint = techPoints[t]
                end
                
            end
            
        else
        
            // Reset teams (keep players on them)
            team1TechPoint = self:ChooseTechPoint(techPoints, kTeam1Index)
            team2TechPoint = self:ChooseTechPoint(techPoints, kTeam2Index)
            
        end
        
        self.team1:ResetPreservePlayers(team1TechPoint)
        self.team2:ResetPreservePlayers(team2TechPoint)
        
        assert(self.team1:GetInitialTechPoint() ~= nil)
        assert(self.team2:GetInitialTechPoint() ~= nil)
        
        // Save data for end game stats later.
        self.startingLocationNameTeam1 = team1TechPoint:GetLocationName()
        self.startingLocationNameTeam2 = team2TechPoint:GetLocationName()
        self.startingLocationsPathDistance = GetPathDistance(team1TechPoint:GetOrigin(), team2TechPoint:GetOrigin())
        self.initialHiveTechId = nil
        
        self.worldTeam:ResetPreservePlayers(nil)
        self.spectatorTeam:ResetPreservePlayers(nil)    
        
        // Replace players with their starting classes with default loadouts at spawn locations
        self.team1:ReplaceRespawnAllPlayers()
        self.team2:ReplaceRespawnAllPlayers()
        
        // Create team specific entities
        local commandStructure1 = self.team1:ResetTeam()
        local commandStructure2 = self.team2:ResetTeam()
        
        // login the commanders again
        local function LoginCommander(commandStructure, team, clientIndex)
            if commandStructure and clientIndex then
                for i,player in ipairs(team:GetPlayers()) do
                    if player.clientIndex == clientIndex then
                        // make up for not manually moving to CS and using it
                        commandStructure.occupied = true
                        player:SetOrigin(commandStructure:GetDefaultEntryOrigin())
                        commandStructure:LoginPlayer(player)
                        break
                    end
                end 
            end
        end
        
        LoginCommander(commandStructure1, self.team1, team1CommanderClientIndex)
        LoginCommander(commandStructure2, self.team2, team2CommanderClientIndex)
        
        // Create living map entities fresh
        CreateLiveMapEntities()
        
        self.forceGameStart = false
        self.losingTeam = nil
        self.preventGameEnd = nil
        // Reset banned players for new game
        self.bannedPlayers = {}
        
        // Send scoreboard update, ignoring other scoreboard updates (clearscores resets everything)
        for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            Server.SendCommand(player, "onresetgame")
            //player:SetScoreboardChanged(false)
        end
        
        self.team1:OnResetComplete()
        self.team2:OnResetComplete()
        
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
		
		return success, newPlayer
	
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
	
	// We may need to add some more logic here.
	function GenericGamerules:OnClientDisconnect(client)
		NS2Gamerules.OnClientDisconnect(self, client)
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