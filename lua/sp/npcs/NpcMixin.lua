//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")
Script.Load("lua/ExtraEntitiesMod/LogicMixin.lua")

NpcMixin = CreateMixin( NpcMixin )
NpcMixin.type = "Npc"

NpcMixin.kPlayerFollowDistance = 3


NpcMixin.expectedMixins =
{
}

NpcMixin.expectedCallbacks =
{
}


NpcMixin.optionalCallbacks =
{
}


NpcMixin.networkVars =  
{
}

AddMixinNetworkVars(LogicMixin, NpcMixin.networkVars)

function NpcMixin:__initmixin() 
    self.active = false  
    
    if Server then
        InitMixin(self, LogicMixin)        
        if self.name1 then
            self:SetName(self.name1)    
        end   
        
        self:SetTeamNumber(self.team)
        table.insert(self:GetTeam().playerIds, self:GetId())
        self:DropToFloor()
        if self.startsActive then
            self.active = true
        end
    end
    
end

function NpcMixin:Reset() 
end

function NpcMixin:OnLogicTrigger(player) 
    self.active = not self.active
end

function NpcMixin:OnUpdate(deltaTime)   
    if Server then    
        
        if self.active then        
            if not self:GetHasOrder() then 
                self:ChooseOrder()
            end            
        end
        
        local move = self:GenerateMove(deltaTime)        
        if move then
            self:OnProcessMove(move)
        end
        
    end
end

function NpcMixin:OnTakeDamage(damage, attacker, doer, point)
    if Server then
        if not self:GetCurrentOrder() then
            // attack him
             self:GiveOrder(kTechId.Attack, attacker:GetId(), (attacker:GetEngagementPoint() or attacker:GetOrigin()), nil, true, true)
        end
    end
end


// Npc things, choses order etc

function NpcMixin:ChooseOrder()

    local order = self:GetCurrentOrder()   
    
    // If we have no order or are attacking, acquire possible new target
    if GetGamerules():GetGameStarted() then
    
        if self.active and ( order == nil or (order:GetType() == kTechId.Attack)) then
        
            // Get nearby visible target
            self:AttackVisibleTarget()
            order = self:GetCurrentOrder()
            
        end
        
    end

    // If we aren't attacking, try something else    
    if self.active and order == nil then
    
        // Get healed at armory, pickup health/ammo on ground, move towards other player    
        if not self:GoToNearbyEntity() then
    
            // Move to random tech point or nozzle on map
            self:ChooseRandomDestination()

        end
            
    end

    // Update order values for client
    self:UpdateOrderVariables()
    
end

function NpcMixin:UpdateOrderVariables()

    self.orderType = kTechId.None
    
    if self:GetHasOrder() then
    
        local order = self:GetCurrentOrder()
        self.orderPosition = Vector(order:GetLocation())
        self.orderType = order:GetType()

    end
    
end

function NpcMixin:AttackVisibleTarget()

    // Are there any visible enemy players or structures nearby?
    local success = false
    
    if not self.timeLastTargetCheck or (Shared.GetTime() - self.timeLastTargetCheck > 2) then
    
        local nearestTarget = nil
        local nearestTargetDistance = nil
        
        local targets = GetEntitiesWithMixinForTeamWithinRange("Live", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), 60)
        for index, target in pairs(targets) do
        
            // for sp, dont attack buildings
            if (not HasMixin(target, "Construct") and target:GetIsAlive() and target:GetIsVisible() and target:GetCanTakeDamage() and target ~= self ) then                     
                local minePos = self:GetEngagementPoint()
                local weapon = self:GetActiveWeapon()
                if weapon then
                    minePos = weapon:GetEngagementPoint()
                end
                local targetPos = target:GetEngagementPoint()
                
                // Make sure we can see target
                local activeWeapon = self:GetActiveWeapon()
                local filter = EntityFilterTwo(self, activeWeapon)
                local trace = Shared.TraceRay(self:GetEyePos(), target:GetModelOrigin(), CollisionRep.LOS, PhysicsMask.AllButPCs, filter)
                if trace.entity == target or not GetWallBetween(minePos, targetPos, target) then  
            
                    // Prioritize players over non-players
                    local dist = (target:GetEngagementPoint() - self:GetModelOrigin()):GetLength()
                    
                    local newTarget = (not nearestTarget) or (target:isa("Player") and not nearestTarget:isa("Player"))
                    if not newTarget then
                    
                        if dist < nearestTargetDistance then
                            newTarget = not nearestTarget:isa("Player") or target:isa("Player")
                        end
                        
                    end
                    
                    if newTarget then
                    
                        nearestTarget = target
                        nearestTargetDistance = dist
                        
                    end
                    
                end
                
            end
            
        end
        
        if nearestTarget then
        
            local name = SafeClassName(nearestTarget)
            if nearestTarget:isa("Player") then
                name = nearestTarget:GetName()
            end
            
            self:GiveOrder(kTechId.Attack, nearestTarget:GetId(), nearestTarget:GetEngagementPoint(), nil, true, true)
            
            success = true
        end
        
        self.timeLastTargetCheck = Shared.GetTime()
        
    end
    
    return success
    
end

function NpcMixin:GoToNearbyEntity(move)
    return false    
end

function NpcMixin:MoveRandomly(move)

    // Jump up and down crazily!
    if self.active and Shared.GetRandomInt(0, 100) <= 5 then
        move.commands = bit.bor(move.commands, Move.Jump)
    end
    
    return true
    
end

function NpcMixin:ChooseRandomDestination(move)

    // Go to nearest unbuilt tech point or nozzle
    local className = ConditionalValue(math.random() < .5, "TechPoint", "ResourcePoint")

    local ents = Shared.GetEntitiesWithClassname(className)
    
    if ents:GetSize() > 0 then 
    
        local index = math.floor(math.random() * ents:GetSize())
        
        local destination = ents:GetEntityAtIndex(index)
        
        self:GiveOrder(kTechId.Move, 0, destination:GetEngagementPoint(), nil, true, true)
        
        return true
        
    end
    
    return false
    
end

function NpcMixin:GetAttackDistance()

    local activeWeapon = self:GetActiveWeapon()
    
    if activeWeapon then
        return math.min(activeWeapon:GetRange(), 15)
    end
    
    return nil
    
end


function NpcMixin:CanAttackTarget(targetOrigin)
    return (targetOrigin - self:GetModelOrigin()):GetLength() < (self:GetAttackDistance() or 0)
end

// this will generate an input like a normal client so the bot can move
function NpcMixin:GenerateMove(deltaTime)

    local move = Move()
    
    // keep the current yaw/pitch as default
    move.yaw = self:GetAngles().yaw
    move.pitch = self:GetAngles().pitch    
    move.time = deltaTime

    self.inAttackRange = false
    
    if self.active then
    
        // If we're inside an egg, hatch
        if self:isa("AlienSpectator") then
            move.commands = Move.PrimaryAttack
        else
        
            local order = self:GetCurrentOrder()

            // Look at order and generate move for it
            if order then
            
                self:UpdateWeaponMove(move)
            
                local orderLocation = order:GetLocation()
                
                // Check for moving targets. This isn't done inside Order:GetLocation
                // so that human players don't have special information about invisible
                // targets just because they have an order to them.
                if (order:GetType() == kTechId.Attack) then
                    local target = Shared.GetEntity(order:GetParam())
                    if (target ~= nil) then
                        orderLocation = target:GetEngagementPoint()
                    end
                end
                local moved = false
                
                  // player:MoveToTarget(PhysicsMask.AIMovement, orderLocation, Player.kWalkMaxSpeed, Shared.GetTime())
                
              //  if self:GetNumPoints() ~= 0 then
              //      self:MoveToPoint(player:GetNextPoint(Shared.GetTime(), Player.kWalkMaxSpeed), move)
               //     moved = true
              //  end
                
                if not moved then
                    // Generate naive move towards point
                    self:MoveToPoint(orderLocation, move)
                end
            end     
            
        end
    end
    
    return move

end


function NpcMixin:UpdateWeaponMove(move)

    // Switch to proper weapon for target
    local order = self:GetCurrentOrder()
    if order ~= nil and (order:GetType() == kTechId.Attack) then
    
        local target = Shared.GetEntity(order:GetParam())
        if target then
        
            local activeWeapon = self:GetActiveWeapon()
        
            if self:isa("Marine") and activeWeapon then
                local outOfAmmo = (activeWeapon:isa("ClipWeapon") and (activeWeapon:GetAmmo() == 0))
            
                // Some bots switch to axe to take down structures
                if (GetReceivesStructuralDamage(target) and self.prefersAxe and not activeWeapon:isa("Axe")) or outOfAmmo then
                    //Print("%s switching to axe to attack structure", self:GetName())
                    move.commands = bit.bor(move.commands, Move.Weapon3)
                elseif target:isa("Player") and not activeWeapon:isa("Rifle") then
                    //Print("%s switching to weapon #1", self:GetName())
                    move.commands = bit.bor(move.commands, Move.Weapon1)
                // If we're out of ammo in our primary weapon, switch to next weapon (pistol or axe)
                elseif outOfAmmo then
                    //Print("%s switching to next weapon", self:GetName())
                    move.commands = bit.bor(move.commands, Move.NextWeapon)
                end
                
            end
            
            // Attack target! TODO: We should have formal point where attack emanates from.
            local distToTarget = (target:GetEngagementPoint() - self:GetModelOrigin()):GetLength()
            local attackDist = self:GetAttackDistance()
            
            self.inAttackRange = false
            
            if activeWeapon and attackDist and (distToTarget < attackDist) then
            
                // Make sure we can see target
                local filter = EntityFilterTwo(self, activeWeapon)
                local trace = Shared.TraceRay(self:GetEyePos(), target:GetModelOrigin(), CollisionRep.LOS, PhysicsMask.AllButPCs, filter)
                if trace.entity == target then
                
                    move.commands = bit.bor(move.commands, Move.PrimaryAttack)
                    self.inAttackRange = true
                    
                end
                
            end
        
        end        
        
    end
    
end

function NpcMixin:MoveToPoint(toPoint, move)
  
    // Fill in move to get to specified point
    local diff = (toPoint - self:GetEyePos())
    local direction = GetNormalizedVector(diff)
        
    // Look at target (needed for moving and attacking)
    move.yaw   = GetYawFromVector(direction) - self:GetBaseViewAngles().yaw
    move.pitch = GetPitchFromVector(direction)
    
    if not self.inAttackRange then
        move.move.z = 1        
    end

end



if Server then

    function OnConsoleNpcActive(client)
        for i, npc in ipairs(GetEntitiesWithMixin("Npc")) do
            npc.active = true
        end
    end

    Event.Hook("Console_npc_active",  OnConsoleNpcActive)

end



