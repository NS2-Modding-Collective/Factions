//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_PlayingTeam.lua

local networkVars = {
}

if Server then

	function PlayingTeam:ResetSpawnTimer()

		// Reset the spawn timer
		self.timeSinceLastSpawn = 0
		self.nextSpawnTime = Shared.GetTime() + kRespawnTimer
				
	end

	function PlayingTeam:SpawnPlayer(player)

		local success = false

		player.isRespawning = true
		SendPlayersMessage({ player }, kTeamMessageTypes.Spawning)

		if Server then
			
			if player.SetSpectatorMode then
				player:SetSpectatorMode(Spectator.kSpectatorMode.Following)
			end        
	 
		end

		// Spawn normally		
		success, newPlayer = player:GetTeam():ReplaceRespawnPlayer(player, nil, nil)
		
		if success then
			// Make a nice effect when you spawn.
			if newPlayer:isa("Marine") or newPlayer:isa("Exo") then
				newPlayer:TriggerEffects("infantry_portal_spawn")
			end
			newPlayer:TriggerEffects("spawnSoundEffects")
			newPlayer:GetTeam():RemovePlayerFromRespawnQueue(newPlayer)
			newPlayer:SetCameraDistance(0)
			
			//give him spawn Protect (dont set the time here, just that spawn protect is active)
			if HasMixin(newPlayer, "SpawnProtect") then
				newPlayer:SetSpawnProtect()
			end
		end

		return success

	end

	function PlayingTeam:Update(timePassed)

		if self.timeSinceLastSpawn == nil then 
			PlayingTeam:ResetSpawnTimer(self)
		end
		
		// Increment the spawn timer
		self.timeSinceLastSpawn = self.timeSinceLastSpawn + timePassed
		
		// check if there are really no Spectators (should fix the spawnbug)
		local players = GetEntitiesForTeam("Spectator", self:GetTeamNumber())
		
		// Spawn all players in the queue once every 10 seconds or so.
		if (#self.respawnQueue > 0) or (#players > 0)  then
			
			// Are we ready to spawn? This is based on the time since the last spawn wave...
			local timeToSpawn = (self.timeSinceLastSpawn >= kRespawnTimer)
			
			if timeToSpawn then
				// Reset the spawn timer.
				PlayingTeam:ResetSpawnTimer(self)
				
				// Loop through the respawn queue and spawn dead players.
				// Also handle the case where there are too many players to spawn all of them - do it on a FIFO basis.
				local lastPlayer = nil
				local thisPlayer = self:GetOldestQueuedPlayer()
				
				if thisPlayer then
					while (lastPlayer == thisPlayer) or (thisPlayer ~= nil) do
						local success = PlayingTeam:SpawnPlayer(thisPlayer)
						// Don't crash the server when no more players can spawn...
						if not success then break end
						
						lastPlayer = thisPlayer
						thisPlayer = self:GetOldestQueuedPlayer()
					end
				else
					// somethings wrong, spawn all Spectators
					for i, player in ipairs(players) do
						local success = PlayingTeam:SpawnPlayer(player)
						// Don't crash the server when no more players can spawn...
						if not success then break end
					end
				end
				
				// If there are any players left, send them a message about why they didn't spawn.
				if (#self.respawnQueue > 0) then
					for i, player in ipairs(self.respawnQueue) do
						player:SendDirectMessage("Could not find a valid spawn location for you... You will spawn in the next wave instead!")
					end
				elseif (#players > 0) then
					for i, player in ipairs(players) do
						player:SendDirectMessage("Could not find a valid spawn location for you... You will spawn in the next wave instead!")
					end
				end
				
			else
				// Send any 'waiting to respawn' messages (normally these only go to AlienSpectators)
				for index, player in pairs(self:GetPlayers()) do				
					if not player.waitingToSpawnMessageSent then
						if player:GetIsAlive() == false then
							SendPlayersMessage({ player }, kTeamMessageTypes.SpawningWait)
							player.waitingToSpawnMessageSent = true

							// TODO: Update the GUI so that marines can get the 'ready to spawn in ... ' message too.
							// After that is done, remove the AlienSpectator check here.
							if (player:isa("AlienSpectator")) then
								player:SetWaveSpawnEndTime(nextSpawnTime)
							end
						end
					end
				end
			end
		end
	end

	// Another copy job I'm afraid...
	// The default spawn code just isn't strong enough for us. Give it a dose of coffee.
	// Call with origin and angles, or pass nil to have them determined from team location and spawn points.
	function PlayingTeam:RespawnPlayer(player, origin, angles)

		local success = false
		local initialTechPoint = Shared.GetEntity(self.initialTechPointId)
		
		if origin ~= nil and angles ~= nil then
			success = Team.RespawnPlayer(self, player, origin, angles)
		elseif initialTechPoint ~= nil then
		
			// Compute random spawn location
			local capsuleHeight, capsuleRadius = player:GetTraceCapsule()
			local spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, initialTechPoint:GetOrigin(), kSpawnMinDistance, kSpawnMaxDistance, EntityFilterAll())
			if spawnOrigin ~= nil then
			
				// Orient player towards tech point
				local lookAtPoint = initialTechPoint:GetOrigin() + Vector(0, 5, 0)
				local toTechPoint = GetNormalizedVector(lookAtPoint - spawnOrigin)
				success = Team.RespawnPlayer(self, player, spawnOrigin, Angles(GetPitchFromVector(toTechPoint), GetYawFromVector(toTechPoint), 0))
				
			else
			
				player:SendDirectMessage("No room to spawn. You should spawn in the next wave instead!")
				Print("PlayingTeam:RespawnPlayer: Couldn't compute random spawn for player. Will retry at next wave...\n")
				// Escape the player's name here... names like Sandwich% cause a crash to appear here!
				local escapedPlayerName = string.gsub(player:GetName(), "%%", "")
				Print("PlayingTeam:RespawnPlayer: Name: " .. escapedPlayerName .. " Class: " .. player:GetClassName())
				
			end
			
		else
			Print("PlayingTeam:RespawnPlayer(): No initial tech point.")
		end
		
		return success
		
	end

	Class_Reload("PlayingTeam", networkVars)
end