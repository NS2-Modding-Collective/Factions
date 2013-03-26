//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")
Script.Load("lua/PathingMixin.lua")
Script.Load("lua/TargetCacheMixin.lua")

NpcMixin = CreateMixin( NpcMixin )
NpcMixin.type = "Npc"

NpcMixin.lowHealthFactor = 0.2 // if health is 20% we need to do something
NpcMixin.armorySearchRange = 60 // armory will be searched in this range
NpcMixin.kPlayerFollowDistance = 3
NpcMixin.kMaxOrderDistance = 2

// update rates to increase performance
NpcMixin.kUpdateRate = 0.01
NpcMixin.kTargetUpdateRate = 1



NpcMixin.expectedMixins =
{
}

NpcMixin.expectedCallbacks =
{
}


NpcMixin.optionalCallbacks =
{
    AiSpecialLogic = "Called OnUpdate, needed that lerks fly etc.",
}


NpcMixin.networkVars =  
{
}


function NpcMixin:__initmixin() 

    if Server and self.isaNpc then
        InitMixin(self, PathingMixin) 
        InitMixin(self, TargetCacheMixin) 
        
        // configure how targets are selected and validated
        //attacker, range, visibilityRequired, targetTypeList, filters, prioritizers
        self.targetSelector = TargetSelector():Init(
            self,
            Sentry.kRange, 
            false,
            self:GetTargets(),
            { self.FilterTarget(self) },
            { function(target) return target:isa("Player") end })

        InitMixin(self, StaticTargetMixin)
        
        self.active = false  
        if self.startsActive then
            self.active = true
        end
    
        if self.name1 then
            self:SetName(self.name1)
        end
        
        self:SetTeamNumber(self.team)
        table.insert(self:GetTeam().playerIds, self:GetId())
        self:DropToFloor()
        
        if self:isa("Marine") then
            self.weapon1OutOfAmmo = false
            self.weapon2OutOfAmmo = false 
        end

    end
    
end


function NpcMixin:GetTargets()

    local targets = {}
    if self:GetTeam() == 1 then
        targets = {    
                kMarineStaticTargets, 
                kMarineMobileTargets}        
    else
        targets = {    
            kAlienStaticTargets, 
            kAlienMobileTargets}  
    end

    return targets
end


function NpcMixin:FilterTarget()
    local attacker = self
    return  function (target, targetPosition)
                // dont attack power points or team members
                if not target:GetCanTakeDamage() or target:GetTeamNumber() == self:GetTeamNumber() or target:isa("PowerPoint") then
                    return false
                else
                    local minePos = self:GetEngagementPoint()
                    local weapon = self:GetActiveWeapon()
                    if weapon then
                        minePos = weapon:GetEngagementPoint()
                    end
                    local targetPos = target:GetEngagementPoint()
                    
                    // Make sure we can see target
                    local filter = EntityFilterAll()
                    local trace = Shared.TraceRay(minePos, targetPos , CollisionRep.Damage, PhysicsMask.Bullets, filter)
                    return ((trace.entity == target) or not GetWallBetween(minePos, targetPos, target) or GetCanSeeEntity(self, target))
                end
            end
end
    

function NpcMixin:Reset() 
    if self.startsActive then
        self.active = true
    else
        self.active = false
    end
end

function NpcMixin:OnLogicTrigger(player) 
    self.active = not self.active
end

// Brain of the npc
// 1. generate move
// 2. check special logic
// 3. check important events like health is low, getting attacked etc.
// 4. if no waypoint check if we get one
// 5. process the order, generate a forward move, shoot etc.Accept
// 6. send the move to OnProcessMove(move)
function NpcMixin:OnUpdate(deltaTime)
  
    if self.isaNpc then
        if Server then    
        
            // this will generate an input like a normal client so the bot can move
            local updateOK = not self.timeLastUpdate or ((Shared.GetTime() - self.timeLastUpdate) > NpcMixin.kUpdateRate) 
            local move = self:GenerateMove(deltaTime)
            if self.active and updateOK and self:GetIsAlive() then
                if self.AiSpecialLogic then
                    self:AiSpecialLogic(move)
                end
                // not working atm
                //self:CheckImportantEvents(move) 
                self:ChooseOrder()
                self:ProcessOrder(move)         
                // Update order values for client
                self:UpdateOrderVariables()                                 
                self.timeLastUpdate = Shared.GetTime()
            end
            
            self:OnProcessMove(move)
        end
    else
        // controlled by a client, do nothing
    end

end


// Npc things, choses order etc

function NpcMixin:GenerateMove(deltaTime)

    local move = Move()    
    // keep the current yaw/pitch as default
    move.yaw = self:GetAngles().yaw
    move.pitch = self:GetAngles().pitch    
    move.time = deltaTime

    return move
    
end

function NpcMixin:CheckImportantEvents(move)
    // if health is low and we have no order, got to an armory if near
    local healthFactor = self:GetHealth() / self:GetMaxHealth()
    local order = self:GetCurrentOrder() 
    local origin = self:GetOrigin()
    
    // If we're inside an egg, hatch
    if self:isa("AlienSpectator") then
        move.commands = Move.PrimaryAttack
    end
    
    if healthFactor <= NpcMixin.lowHealthFactor then
        // only go healing when no order or no attack order and armory will help us 
        if not order or order:GetType() ~= kTechId.Attack then
        
            local armorys = GetEntitiesWithinRange("Armory",  origin , NpcMixin.armorySearchRange )
            if armorys then
                // search nearest armory
                local nearestArmory = nil
                local distance = nil
                // check if an armory would heal us
                if armory[1]:GetShouldResupplyPlayer(self) then
                    for i, armory in ipairs(armorys) do
                        if not nearestArmory then
                            nearestArmory = armory
                            distance = origin:GetDistanceTo(armory:GetOrigin())
                        else
                            if origin:GetDistanceTo(armory:GetOrigin()) < distance then
                                nearestArmory = armory
                                distance = origin:GetDistanceTo(armory:GetOrigin())  
                            end
                        end
                    end
                end                
            end
            if nearestArmory then
                self:GiveOrder(kTechId.Move , nearestArmory:GetId(), nearestArmory:GetOrigin())
            end            
        end
    end

end

function NpcMixin:ChooseOrder()

    // don't search for targets if neutral
    if self:GetTeam() ~= 0 then
        self:AttackVisibleTarget()
    end
    
    order = self:GetCurrentOrder()
    // try to reach the mapWaypoint
    if not order and self.mapWaypoint then
        local waypoint = Shared.GetEntity(self.mapWaypoint)
        if waypoint then
            self:GiveOrder(kTechId.Move , waypoint:GetId(), waypoint:GetOrigin(), nil, true, true)
        end
    end   
    
    
end


function NpcMixin:ProcessOrder(move)

    self:UpdateWeaponMove(move)  
    local order = self:GetCurrentOrder() 
    if order then 
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
        
        self:MoveToPoint(orderLocation , move)
        
    end

end


function NpcMixin:UpdateOrderVariables()
    local order = self:GetCurrentOrder() 
    if order then
        self.orderPosition = Vector(order:GetLocation())
        self.orderType = order:GetType()   
    end
end

function NpcMixin:GoToNearbyEntity()
    return false
end

function NpcMixin:AttackVisibleTarget()

    // Are there any visible enemy players or structures nearby?
    local success = false

    if not self.timeLastTargetCheck or (Shared.GetTime() - self.timeLastTargetCheck > NpcMixin.kTargetUpdateRate) then
        
        self.target = self.targetSelector:AcquireTarget()  
    
        /*
    
        local nearestTarget = nil
        local nearestTargetDistance = nil
        
        local targets = GetEntitiesWithMixinForTeamWithinRange("Live", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), 60)
        for index, target in pairs(targets) do
        
            // for sp, dont attack power nodes
            if (not HasMixin(target, "PowerSourceMixin") and target:GetIsAlive() and target:GetIsVisible() and target:GetCanTakeDamage() and target ~= self ) then                     
                local minePos = self:GetEngagementPoint()
                local weapon = self:GetActiveWeapon()
                if weapon then
                    minePos = weapon:GetEngagementPoint()
                end
                local targetPos = target:GetEngagementPoint()
                
                // Make sure we can see target
                local filter = EntityFilterAll()
                local trace = Shared.TraceRay(minePos, targetPos , CollisionRep.Damage, PhysicsMask.Bullets, filter)
                if trace.entity == target or not GetWallBetween(minePos, targetPos, target) or GetCanSeeEntity(self, target) then  
            
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
        */
        if self.target then
        
            local name = SafeClassName(self.target)
            if self.target:isa("Player") then
                name = self.target:GetName()
            end
            
            self:GiveOrder(kTechId.Attack, self.target:GetId(), self.target:GetEngagementPoint(), nil, true, true)
            
            success = true
        end
        
        self.timeLastTargetCheck = Shared.GetTime()
        
    end
    
    return success
    
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

function NpcMixin:UpdateWeaponMove(move)

    local order = self:GetCurrentOrder()             
    local activeWeapon = self:GetActiveWeapon()

    if order ~= nil then
        if (order:GetType() == kTechId.Attack) then
        
            local target = Shared.GetEntity(order:GetParam())
            if target then
            
                if self:isa("Marine") and activeWeapon then
                    outOfAmmo = (activeWeapon:isa("ClipWeapon") and (activeWeapon:GetAmmo() == 0))            
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
                        self:SetWeaponOutOfAmmo(activeWeapon:GetHUDSlot(), true)
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
            
        elseif (order:GetType() == kTechId.Build or order:GetType() == kTechId.Construct) then
            // if we're near the build, look if we can build it
            if order:GetLocation() and (self:GetOrigin() - order:GetLocation()):GetLengthXZ() <= kPlayerUseRange then
                local targetEnt = Shared.GetEntity(order:GetParam())
                local ent = self:PerformUseTrace()            
                if ent and ent == targetEnt then
                    if not ent:GetIsBuilt() then
                        move.commands = bit.bor(move.commands, Move.Use)
                    else
                        self:DeleteCurrentOrder()
                    end
                end
            end
            // if not, do nothing, we will walk there
        end
    else
        // if were a marine a have currently the pistol selected, switch back to rifle

    end
    
    return move
    
end

function NpcMixin:MoveToPoint(toPoint, move)

    local order = self:GetCurrentOrder()
    if order:GetType() ~= kTechId.Attack then
        // if its the same point, lets look if we can still move there
        if self.oldPoint and self.oldPoint == toPoint then
            local startPoint = self:GetEyePos()
            local viewAngles = self:GetViewAngles()
            local fowardCoords = viewAngles:GetCoords()
            local trace = Shared.TraceRay(startPoint, startPoint + (fowardCoords.zAxis * 5), CollisionRep.LOS, PhysicsMask.AllButPCs, EntityFilterOne(self))        
            if (trace.endPoint - startPoint):GetLength() <= 0.5 then
                local groundLocation = GetGroundAt(self, toPoint, PhysicsMask.Movement)
                if not self:CheckTarget(groundLocation) then
                    // thers no path
                    self:DeleteCurrentOrder()
                end 
            end
        else
            // delete current path cause its a new point
            self.index = nil
            self.points = nil
            self.cursor = nil
            
            local groundLocation = GetGroundAt(self, toPoint, PhysicsMask.Movement)
            if not self:CheckTarget(groundLocation) then
                // thers no path
                self:DeleteCurrentOrder()
            end   

        end  
                   
        self.oldPoint = toPoint 
            
        if self.points and #self.points ~= 0 then            

            if not self.index then
                self.index = 1
            end
            
            if self.index <= #self.points then
                toPoint = self.points[self.index]
                if (self:GetOrigin() - toPoint):GetLengthXZ() <= NpcMixin.kMaxOrderDistance then
                    // next point
                    self.index = self.index + 1
                end
            else
                // end point is reached
                self:DeleteCurrentOrder()
            end
        end
        
    end
  
    // Fill in move to get to specified point
    local diff = (toPoint - self:GetEyePos())
    local direction = GetNormalizedVector(diff)
        
    // Look at target (needed for moving and attacking)
    move.yaw   = GetYawFromVector(direction) - self:GetBaseViewAngles().yaw
    move.pitch = GetPitchFromVector(direction)
    
    // Generate naive move towards point
    if not self.inAttackRange then
        move.move.z = 1        
    end
       
    return move

end


function NpcMixin:DeleteCurrentOrder()
    local order = self:GetCurrentOrder()
    if self.mapWaypoint == order:GetId() or self.mapWaypoint == order:GetParam() then
        self.mapWaypoint = nil
    end
    self:CompletedCurrentOrder()
    self.index = nil
    self.points = nil
    self.cursor = nil
end

function NpcMixin:OnTakeDamage(damage, attacker, doer, point)
    if Server then
        self.lastAttacker = attacker 
        local order = self:GetCurrentOrder()
        // if were getting attacked, attack back
        if not order or (order and order:GetType() ~= kTechId.Attack) then
            self:GiveOrder(kTechId.Attack, attacker:GetId(), attacker:GetEngagementPoint(), nil, true, true)       
        end
    end
end

// remember current weapon and set it as reloaded
function NpcMixin:Reload()
    local activeWeapon = self:GetActiveWeapon()
    self:SetWeaponOutOfAmmo(activeWeapon:GetHUDSlot(), false)
end

function NpcMixin:SetWeaponOutOfAmmo(weaponSlot, boolean)
    if weaponSlot == kPrimaryWeaponSlot then 
        self.weapon1OutOfAmmo = false
    else
        self.weapon2OutOfAmmo = false
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



