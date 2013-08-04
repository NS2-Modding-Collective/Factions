//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NS2Utility.lua

/**
 * Returns the spawn point on success, nil on failure.
 */
local function ValidateSpawnPoint(spawnPoint, capsuleHeight, capsuleRadius, filter, origin)

    local center = Vector(0, capsuleHeight * 0.5 + capsuleRadius + 1, 0)
    local spawnPointCenter = spawnPoint + center
    
    // Make sure capsule isn't interpenetrating something.
    local spawnPointBlocked = Shared.CollideCapsule(spawnPointCenter, capsuleRadius, capsuleHeight, CollisionRep.Default, PhysicsMask.AllButPCs, nil)
    if not spawnPointBlocked then

        // Trace capsule to ground, making sure we're not on something like a player or structure
        local trace = Shared.TraceCapsule(spawnPointCenter, spawnPoint - Vector(0, 10, 0), capsuleRadius, capsuleHeight, CollisionRep.Move, PhysicsMask.AllButPCs)            
        if trace.fraction < 1 and (trace.entity == nil or not trace.entity:isa("ScriptActor")) then
        
            VectorCopy(trace.endPoint, spawnPoint)
            
            local endPoint = trace.endPoint + Vector(0, (capsuleHeight / 2) - 1, 0)
            // Trace in both directions to make sure no walls are being ignored.
            trace = Shared.TraceRay(endPoint, origin, CollisionRep.Move, PhysicsMask.AllButPCs, filter)
            local traceOriginToEnd = Shared.TraceRay(origin, endPoint, CollisionRep.Move, PhysicsMask.AllButPCs, filter)
            
            if trace.fraction == 1 and traceOriginToEnd.fraction == 1 then
                return spawnPoint - Vector(0, (capsuleHeight / 2) - 1, 0)
            end
            
        end
        
    end
    
    return nil
    
end

// Find place for player to spawn, within range of origin. Makes sure that a line can be traced between the two points
// without hitting anything, to make sure you don't spawn on the other side of a wall. Returns nil if it can't find a 
// spawn point after a few tries.
function GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, origin, minRange, maxRange, filter, validationFunc)

    ASSERT(capsuleHeight > 0)
    ASSERT(capsuleRadius > 0)
    ASSERT(origin ~= nil)
    ASSERT(type(minRange) == "number")
    ASSERT(type(maxRange) == "number")
    ASSERT(maxRange > minRange)
    ASSERT(minRange > 0)
    ASSERT(maxRange > 0)
    
    for i = 0, kSpawnMaxRetries do
    
        local spawnPoint = nil
		local points = GetRandomPointsWithinRadius(origin, minRange, minRange*2 + ((maxRange-minRange*2) * i / kSpawnMaxRetries), kSpawnMaxVertical, 1, 1, nil, validationFunc)
        if #points == 1 then
            spawnPoint = points[1]
        elseif Server then
            Print("GetRandomPointsWithinRadius() failed inside of GetRandomSpawnForCapsule()")
        end
        
        if spawnPoint then
        
            // The spawn point returned by GetRandomPointsWithinRadius() may be too close to the ground.
            // Move it up a bit so there is some "wiggle" room. ValidateSpawnPoint() traces down anyway.
            spawnPoint = spawnPoint + Vector(0, 0.5, 0)
            local validSpawnPoint = ValidateSpawnPoint(spawnPoint, capsuleHeight, capsuleRadius, filter, origin)
            if validSpawnPoint then
                return validSpawnPoint
            end
            
        end
        
    end
    
    return nil
    
end

local overrideCanEntityDoDamageTo = CanEntityDoDamageTo
function CanEntityDoDamageTo(attacker, target, cheats, devMode, friendlyFire, damageType)
	
	// Check and apply Factions damage modifier here.
	// We put the code here because this is the first time we can access kDamageTypeGlobalRules
	Factions_CheckAndApplyDamageModifierRules()
	
	return overrideCanEntityDoDamageTo(attacker, target, cheats, devMode, friendlyFire, damageType)
	
end

// melee targets must be in front of the player
local function IsNotBehind(fromPoint, hitPoint, forwardDirection)

    local startPoint = fromPoint + forwardDirection * 0.1

    local toHitPoint = hitPoint - startPoint
    toHitPoint:Normalize()

    return forwardDirection:DotProduct(toHitPoint) > 0

end

local kTraceOrder = { 4, 1, 3, 5, 7, 0, 2, 6, 8 }
 /**
  * Bullets are small and will hit exactly where you looked. 
  * Melee, however, is different. We select targets from a volume, and we expect the melee'er to be able
  * to basically select the "best" target from that volume. 
  * Right now, the Trace methods available is limited (spheres or world-axis aligned boxes), so we have to
  * compensate by doing multiple traces.
  * We specify the size of the width and base height and its range.
  * Then we split the space into 9 parts and trace/select all of them, choose the "best" target. If no good target is found,
  * we use the middle trace for effects.
  */
function CheckMeleeCapsuleMulti(weapon, player, damage, range, optionalCoords, traceRealAttack, scale, priorityFunc, filter, maxHits)

    scale = scale or 1
	maxHits = maxHits or 99

    local eyePoint = player:GetEyePos()
    
    if not teamNumber then
        teamNumber = GetEnemyTeamNumber( player:GetTeamNumber() )
    end
    
    local coords = optionalCoords or player:GetViewAngles():GetCoords()
    local axis = coords.zAxis
    local forwardDirection = Vector(coords.zAxis)
    forwardDirection.y = 0

    if forwardDirection:GetLength() ~= 0 then
        forwardDirection:Normalize()
    end
    
    local width, height = weapon:GetMeleeBase()
    width = scale * width
    height = scale * height
        
    // extents defines a world-axis aligned box, so x and z must be the same. 
    local extents = Vector(width / 6, height / 6, width / 6)
    if not filter then
        filter = EntityFilterOne(player)
    end
        
    local middleTrace,middleStart
    local hitEntities = {}
    local targets = {}
    local endPoints = {}
    local surfaces = {}
    local startPoints = {}
    
    if not priorityFunc then
        priorityFunc = IsBetterMeleeTarget
    end
    
    // Add each target to a big list
    for _, pointIndex in ipairs(kTraceOrder) do
    
        local dx = pointIndex % 3 - 1
        local dy = math.floor(pointIndex / 3) - 1
        local point = eyePoint + coords.xAxis * (dx * width / 3) + coords.yAxis * (dy * height / 3)
        local trace, sp, ep = TraceMeleeBox(weapon, point, axis, extents, range, PhysicsMask.Melee, filter)
        
        if dx == 0 and dy == 0 then
            middleTrace, middleStart = trace, sp
        end
        
        if trace.entity and not hitEntities[trace.entity:GetId()] and IsNotBehind(eyePoint, trace.endPoint, forwardDirection) then
        
        	hitEntities[trace.entity:GetId()] = true
            table.insert(targets, trace.entity)
            table.insert(startPoints, sp)
            table.insert(endPoints, trace.endPoint)
            table.insert(surfaces, trace.surface)
            
        end
        
    end
    
    // if we have not found a target, we use the middleTrace to possibly bite a wall (or when cheats are on, teammate)
    if #targets == 0 then
    	targets = { middleTrace.entity }
    	endPoints = { middleTrace.endPoint }
  	  surfaces = { middleTrace.surface }
 	   startPoints = { middleStart }
    end
    
    local directions = {}
    for index, target in ipairs(targets) do
    	local direction = target and (endPoints[index] - startPoints[index]):GetUnit() or coords.zAxis
    	table.insert(directions, direction)
    end
    return #targets > 0 or middleTrace.fraction < 1, targets, endPoints, directions, surfaces
    
end

/**
 * Does an attack with a melee capsule.
 */
function AttackMeleeCapsuleMulti(weapon, player, damage, range, optionalCoords, altMode, filter, maxHits)

    // Enable tracing on this capsule check, last argument.
    local didHit, targets, endPoints, directions, surfaces = CheckMeleeCapsuleMulti(weapon, player, damage, range, optionalCoords, true, 1, nil, filter, maxHits)
    
    if didHit then
    	for i, target in ipairs(targets) do
			//Shared.Message("Bashed " .. target:GetClassName() .. " " .. i .. " for " .. damage .. " damage!")
			weapon:DoDamage(damage, target, endPoints[i], directions[i], surfaces[i], altMode)
    	end
    end
    
    return didHit, targets, endPoints, surfaces
    
end