//________________________________
//
//  Last Stand Mod for NS2
//	Made by MCMLXXXIV, 2013
//  Concept by 
//________________________________

// LastStand_Server.lua

if Server then

	local overrideGetLoadSpecial = GetLoadSpecial
	local overrideGetCreateEntityOnStart = GetCreateEntityOnStart

	Server.armorySpawnPoints = table.array(20)
	Server.observatorySpawnPoints = table.array(20)
	Server.phaseGateSpawnPoints = table.array(20)
	Server.sentrySpawnPoints = table.array(20)

	// Post hook for GetCreateEntityOnStart
	function GetCreateEntityOnStart(mapName, groupName, values)

		return overrideGetCreateEntityOnStart(mapName, groupName, values)
		   and mapName ~= Armory.kMapName
		   and mapName ~= Observatory.kMapName
		   and mapName ~= PhaseGate.kMapName
		   and mapName ~= Sentry.kMapName
		
	end

	// Post hook for GetLoadSpecial
	function GetLoadSpecial(mapName, groupName, values)

		local success = overrideGetLoadSpecial(mapName, groupName, values)
		
		// Also check for observatories, prototype labs etc.
		if not success then
		
			if mapName == Armory.kMapName then
			
				table.insert(Server.armorySpawnPoints, values.origin)
				success = true
				
			elseif mapName == Observatory.kMapName then
			
				table.insert(Server.observatorySpawnPoints, values.origin)
				success = true
				
			elseif mapName == PhaseGate.kMapName then
			
				table.insert(Server.phaseGateSpawnPoints, values.origin)
				success = true
				
			elseif mapName == Sentry.kMapName then
			
				table.insert(Server.sentrySpawnPoints, values.origin)
				success = true
			
			end
			
		end
		
		return success
		
	end

end