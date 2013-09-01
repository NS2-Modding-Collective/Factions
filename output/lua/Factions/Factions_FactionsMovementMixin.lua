//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FactionsMovementMixin.lua

Script.Load("lua/FunctionContracts.lua")

FactionsMovementMixin = CreateMixin( FactionsMovementMixin )
FactionsMovementMixin.type = "FactionsMovement"

FactionsMovementMixin.expectedMixins =
{
	 WallMovement = "Needed for processing the wall walking.",
	 FactionsClass = "Needed for changing the movement speed depending on class.",
	 MagnoBootsWearer = "Needed for detecting whether the player has Magno Boots",
	 SpeedUpgrade = "Needed to calculate the upgraded speed based on player upgrades",
}

FactionsMovementMixin.expectedCallbacks =
{
	GetUpgradedMaxSprintSpeed = "The speed that the player runs",
	GetUpgradedSprintAcceleration = "The speed that the player runs",
	GetUpgradedMaxSpeed = "The speed that the player walks",
	GetUpgradedAcceleration = "The speed that the player walks",
	
	GetAirFriction = "The force of Air Friction for this entity",
}

/*
	kJumpRepeatTime = "Minimum amount of time between jumps",
	kWallJumpInterval = "Minimum amount of time between wall jumps",

	kAcceleration = "Default acceleration",
	kGroundFriction = "Friction values when on ground",
	kGroundWalkFriction = "Friction values when ground walking",
	
	kWallWalkCheckInterval = "How often to check for wall walking",
	kWallWalkNormalSmoothRate = "This is how quickly the 3rd person model will adjust to the new normal",

	kNormalWallWalkFeelerSize = "How big the spheres are that are casted out to find walls, 'feelers'",
	kNormalWallWalkRange = "The max range away from the wall at which wall walking is applied",

	kJumpWallRange = "jump is valid when you are close to a wall but not attached yet at this range",
	kJumpWallFeelerSize = "The length of the 'feelers' at the end of the wall jump range",

	kWallStickFactor = "when we slow down to less than 97% of previous speed we check for walls to attach to",

	kWallJumpYBoost = "The boost along the Y direction when wall jumping",
	kWallJumpYDirection = "The boost along the Y direction when wall jumping",

	kMaxVerticalAirAccel = "The maximum vertical acceleration",

	kWallJumpForce = "The initial force of any wall jump",
	kMinWallJumpSpeed = "The player's initial speed after a wall jump",

	kAirZMoveWeight = "The amount of weight to place on movement in the Z plane",
	kAirStrafeWeight = "The amount of weight to place on strafe movement",
	kAirAccelerationFraction = "Air acceleration friction",

	kAirMoveMaxVelocity = "The minimum speed at which GetAirMoveScalar is set to 1.0",
*/

FactionsMovementMixin.expectedConstants =
{
}

FactionsMovementMixin.networkVars =
{
	wallWalking = "compensated boolean",
	timeLastWallWalkCheck = "private compensated time",
	wallWalkingNormalGoal = "private compensated vector (-1 to 1 by 0.001)",
	wallWalkingNormalCurrent = "private compensated vector (-1 to 1 by 0.001 [ 8 ], -1 to 1 by 0.001 [ 9 ])",
	
	wallWalkingEnabled = "private compensated boolean",
	timeStartedWallWalking = "private compensated time",
	timeOfLastJumpLand = "private compensated time",
	timeLastWallJump = "private compensated time",
	jumpLandSpeed = "private compensated float",
}

// These should completely override any existing function defined in the class.
FactionsMovementMixin.overrideFunctions =
{
	"GetAcceleration",
	"GetAirAcceleration",
	"GetMoveSpeedIs2D",
	"GetRecentlyWallJumped",
	"GetCanWallJump",
	"GetIsOnLadder",
	"GetCanJump",
	"GetIsWallWalking",
	"GetIsWallWalkingPossible",
	"PreUpdateMove",
	"GetDesiredAngles",
	"GetHeadAngles",
	"GetAngleSmoothingMode",
	"GetIsUsingBodyYaw",
	"GetSmoothAngles",
	"UpdatePosition",
	"GetMaxSpeed",
	"OverrideUpdateOnGround",
	"GetRecentlyJumped",
	"ModifyVelocity",
	"ConstrainMoveVelocity",
	"GetGroundFriction",
	"GetCanStep",
	"ModifyGravityForce",
	"GetIsOnSurface",
	"AdjustGravityForce",
	"GetMoveDirection",
	"GetIsCloseToGround",
	"GetPlayFootsteps",
	"GetIsOnGround",
	"GetPerformsVerticalMove",
	"GetJumpVelocity",
	"GetPlayJumpSound",
	"HandleJump",
	"OnClampSpeed",
	"ComputeForwardVelocity",
	
}

function FactionsMovementMixin:__initmixin()

	// Wall walking stuff
	self.wallWalking = false
    self.wallWalkingNormalCurrent = Vector.yAxis
    self.wallWalkingNormalGoal = Vector.yAxis
	
    // Note: This needs to be initialized BEFORE calling SetModel() below
    // as SetModel() will call GetHeadAngles() through SetPlayerPoseParameters()
    // which will cause a script error if the Skulk is wall walking BEFORE
    // the Skulk is initialized on the client.
    self.currentWallWalkingAngles = Angles(0.0, 0.0, 0.0)
    
    if Client then
    
        self.currentCameraRoll = 0
        self.goalCameraRoll = 0
        
    end
    
    self.timeLastWallJump = 0
	
end

function FactionsMovementMixin:GetAcceleration()

    local acceleration = self:GetUpgradedAcceleration()
    
    if self:GetIsSprinting() then
        acceleration = self:GetUpgradedAcceleration() + (self:GetUpgradedSprintAcceleration() - self:GetUpgradedAcceleration()) * self:GetSprintingScalar()
    end

    // Disable slow speed.... 
	//acceleration = acceleration * self:GetSlowSpeedModifier()
    acceleration = acceleration * self:GetInventorySpeedScalar()

    /*
    if self.timeLastSpitHit + Marine.kSpitSlowDuration > Shared.GetTime() then
        acceleration = acceleration * 0.5
    end
    */

	if self.GetCatalystMoveSpeedModifier then
	    return acceleration * self:GetCatalystMoveSpeedModifier()
	else
		return acceleration 
	end

end

function FactionsMovementMixin:GetAirAcceleration()

	if self:GetHasMagnoBoots() then
		return 9
	else
		return 6
	end
	
end

// The movement should factor in the vertical velocity
// only when wall walking.
function FactionsMovementMixin:GetMoveSpeedIs2D()

	return not self:GetIsWallWalking()
	
end

function FactionsMovementMixin:GetRecentlyWallJumped()

	return self.timeLastWallJump + Marine.kWallJumpInterval > Shared.GetTime()
	
end

function FactionsMovementMixin:GetCanWallJump()

	return self:GetHasMagnoBoots() and (self:GetIsWallWalking() or (not self:GetIsOnGround() and self:GetAverageWallWalkingNormal(Marine.kJumpWallRange, Marine.kJumpWallFeelerSize) ~= nil))
	
end

// Players with magno boots don't need ladders
function FactionsMovementMixin:GetIsOnLadder()

	if self:GetHasMagnoBoots() then
		return false
	else
		return LadderMoveMixin.GetIsOnLadder(self)
	end

end

function FactionsMovementMixin:GetCanJump()

	return Player.GetCanJump(self) or self:GetCanWallJump()    
	
end

function FactionsMovementMixin:GetIsWallWalking()

	return self.wallWalking

end

function FactionsMovementMixin:GetIsWallWalkingPossible() 

	// Can only wall walk if you have magno boots
	return self:GetHasMagnoBoots() and not self:GetRecentlyJumped() /* and not self.crouching */ 
	
end

function FactionsMovementMixin:PreUpdateMove(input, runningPrediction)

	PROFILE("Marine:PreUpdateMove")

	GroundMoveMixin.PreUpdateMove(self, input, runningPrediction)
	
	self.moveButtonPressed = input.move:GetLength() ~= 0
	
	if not self.wallWalkingEnabled or not self:GetIsWallWalkingPossible() then
	
		self.wallWalking = false
		
	else

		// Don't check wall walking every frame for performance    
		if (Shared.GetTime() > (self.timeLastWallWalkCheck + Marine.kWallWalkCheckInterval)) then

			// Most of the time, it returns a fraction of 0, which means
			// trace started outside the world (and no normal is returned)           
			local goal = self:GetAverageWallWalkingNormal(Marine.kNormalWallWalkRange, Marine.kNormalWallWalkFeelerSize)
			
			if goal ~= nil then
			
				self.wallWalkingNormalGoal = goal
				self.wallWalking = true
				self.timeStartedWallWalking = Shared.GetTime()
					   
			else
				self.wallWalking = false                
			end
			
			self.timeLastWallWalkCheck = Shared.GetTime()
			
		end 
	
	end
	
	if not self:GetIsWallWalking() then
		// When not wall walking, the goal is always directly up (running on ground).
	  
		self.wallWalkingNormalGoal = Vector.yAxis
		
		if self:GetIsOnGround() then        
			self.wallWalkingEnabled = false            
		end
	end
	
	local fraction = input.time * Marine.kWallWalkNormalSmoothRate
	self.wallWalkingNormalCurrent = self:SmoothWallNormal(self.wallWalkingNormalCurrent, self.wallWalkingNormalGoal, fraction)
    self.currentWallWalkingAngles = self:GetAnglesFromWallNormal(self.wallWalkingNormalCurrent, 1) or self.currentWallWalkingAngles
	
end

function FactionsMovementMixin:GetDesiredAngles(deltaTime)

	if self:GetIsWallWalking() then    
		return self.currentWallWalkingAngles      
	end
	
	return Player.GetDesiredAngles(self)
	
end 

function FactionsMovementMixin:GetHeadAngles()

    if self:GetIsWallWalking() then
        return self.currentWallWalkingAngles
    else
        return self:GetViewAngles()
    end

end

function FactionsMovementMixin:GetAngleSmoothingMode()

    if self:GetIsWallWalking() then
        return "quatlerp"
    else
        return "euler"
    end

end

function FactionsMovementMixin:GetIsUsingBodyYaw()
    return not self:GetIsWallWalking()
end

function FactionsMovementMixin:GetSmoothAngles()

	return not self:GetIsWallWalking()	
	
end

local function GetIsCloseToGround(self, distance)

    local onGround = false
    local normal = Vector()
    local completedMove, hitEntities = nil
    
    if self.controller == nil then
        onGround = true
    
    elseif self.timeGroundAllowed <= Shared.GetTime() then
    
        // Try to move the controller downward a small amount to determine if
        // we're on the ground.
        local offset = Vector(0, -distance, 0)
        // need to do multiple slides here to not get traped in V shaped spaces
        completedMove, hitEntities, normal = self:PerformMovement(offset, 3, nil, false)
        
        if normal and normal.y >= 0.5 then
            onGround = true
        end
    
    end
    
    return onGround, normal
    
end

/* **** CODE FROM GROUNDMOVEMIXIN **** */

local kDownSlopeFactor = math.tan(math.rad(60))
local kStepHeight = 0.5
local kAirGroundTransistionTime = 0.2

local function FlushCollisionCallbacks(self, velocity)

    if not self.onGround and self.storedNormal then

        local onGround, normal = GetIsCloseToGround(self, 0.15)
        
        if self.OverrideUpdateOnGround then
            onGround = self:OverrideUpdateOnGround(onGround)
        end

        if onGround then
        
            self.onGround = true
            
            // dont transistion for only short in air durations
            if self.timeGroundTouched + kAirGroundTransistionTime <= Shared.GetTime() then
                self.timeGroundTouched = Shared.GetTime()
            end

            if self.OnGroundChanged then
                self:OnGroundChanged(self.onGround, self.storedImpactForce, normal, velocity)
            end
            
        end
    
    end
    
    self.storedNormal = nil
    self.storedImpactForce = nil

end

local function DoStepMove(self, input, velocity, deltaTime)
    
    local oldOrigin = Vector(self:GetOrigin())
    local oldVelocity = Vector(velocity)
    local success = false
    local stepAmount = 0
    local slowDownFraction = self.GetCollisionSlowdownFraction and self:GetCollisionSlowdownFraction() or 1
    local deflectMove = self.GetDeflectMove and self:GetDeflectMove() or false
    
    // step up at first
    self:PerformMovement(Vector(0, kStepHeight, 0), 1)
    stepAmount = self:GetOrigin().y - oldOrigin.y
    // do the normal move
    local startOrigin = Vector(self:GetOrigin())
    local completedMove, hitEntities, averageSurfaceNormal = self:PerformMovement(velocity * deltaTime, 3, velocity, true, slowDownFraction, deflectMove)
    local horizMoveAmount = (startOrigin - self:GetOrigin()):GetLengthXZ()
    
    if completedMove then
        // step down again
        local completedMove, hitEntities, averageSurfaceNormal = self:PerformMovement(Vector(0, -stepAmount - horizMoveAmount * kDownSlopeFactor, 0), 1)
        
        local onGround, normal = GetIsCloseToGround(self, 0.15)
        
        if onGround then
            success = true
        end

    end    
        
    // not succesful. fall back to normal move
    if not success then
    
        self:SetOrigin(oldOrigin)
        VectorCopy(oldVelocity, velocity)
        self:PerformMovement(velocity * deltaTime, 3, velocity, true, slowDownFraction, deflectMove)
        
    end

    return success

end

local function GroundMoveUpdatePosition(self, input, velocity, deltaTime)

    PROFILE("GroundMoveUpdatePosition")
    
    if self.controller then
    
        local oldVelocity = Vector(velocity)
        
        local stepAllowed = self.onGround and self:GetCanStep()
        local didStep = false
        local stepAmount = 0
        local hitObstacle = false
    
        // check if we are allowed to step:
        local completedMove, hitEntities, averageSurfaceNormal = self:PerformMovement(velocity * deltaTime * 2.5, 3, nil, false)
		if (averageSurfaceNormal) then
			self.averageSurfaceNormal = Vector(averageSurfaceNormal.x, averageSurfaceNormal.y, averageSurfaceNormal.z)
		else
			self.averageSurfaceNormal = nil
		end
  
        if stepAllowed and hitEntities then
        
            for i = 1, #hitEntities do
                if not self:GetCanStepOver(hitEntities[i]) then
                
                    hitObstacle = true
                    stepAllowed = false
                    break
                    
                end
            end
        
        end
        
        if not stepAllowed then
        
            if hitObstacle then

                if self.onGround then
                    velocity:Scale(0.22)    
                else
                    velocity:Scale(0.5)  
                end
    
                velocity.y = oldVelocity.y
                
            end
            
            local slowDownFraction = self.GetCollisionSlowdownFraction and self:GetCollisionSlowdownFraction() or 1
            local deflectMove = self.GetDeflectMove and self:GetDeflectMove() or false
            
            self:PerformMovement(velocity * deltaTime, 3, velocity, true, slowDownFraction, deflectMove)
            
        else        
            didStep, stepAmount = DoStepMove(self, input, velocity, deltaTime)            
        end
        
        FlushCollisionCallbacks(self, velocity)
        
        if self.OnPositionUpdated then
            self:OnPositionUpdated(self:GetOrigin() - self.prevOrigin, stepAllowed, input, velocity)
        end
        
    end
    
    SetSpeedDebugText("onGround %s", ToString(self.onGround))
	
	return velocity, hitEntities, self.averageSurfaceNormal

end

/* **** END CODE FROM GROUNDMOVEMIXIN **** */

local kUpVector = Vector(0, 1, 0)
function FactionsMovementMixin:UpdatePosition(input, velocity, time)

	PROFILE("Marine:UpdatePosition")

	local yAxis = self.wallWalkingNormalGoal
	// Unpack the velocity vector into a lua structure.
	local requestedVelocity = Vector(velocity.x, velocity.y, velocity.z)
	local moveDirection = GetNormalizedVector(velocity)
	local storeSpeed = false
	local hitEntities = nil
	
	if self.adjustToGround then
		velocity.y = 0
		self.adjustToGround = false
	end
	
	local wasOnSurface = self:GetIsOnSurface()
	local oldSpeed = velocity:GetLengthXZ()
	
	velocity, hitEntities, self.averageSurfaceNormal = GroundMoveUpdatePosition(self, input, velocity, time)
	local newSpeed = velocity:GetLengthXZ()

	if not self.wallWalkingEnabled then

		// we enable wallkwalk if we are no longer on ground but were the previous 
		if wereOnGround and not self:GetIsOnGround() then
			self.wallWalkingEnabled = self:GetIsWallWalkingPossible()
		else
			// we enable wallwalk if our new velocity is significantly smaller than the requested velocity
			if newSpeed < oldSpeed * Marine.kWallStickFactor then
				self.wallWalkingEnabled = self:GetIsWallWalkingPossible()
				if self.wallWalkingEnabled then
					storeSpeed = true
				end
			end
		end

	end
	
	if not wasOnSurface and self:GetIsOnSurface() then
		storeSpeed = true
	end
	
	if storeSpeed then

		self.timeOfLastJumpLand = Shared.GetTime()
		self.jumpLandSpeed = requestedVelocity:GetLengthXZ()

	end
	
	// prevent jumping against the same wall constantly as a method to ramp up speed
	local steepImpact = self.averageSurfaceNormal ~= nil and hitEntities == nil and moveDirection:DotProduct(self.averageSurfaceNormal) < -.6
	// never lose speed on ground
	local groundSurface = self.averageSurfaceNormal ~= nil and kUpVector:DotProduct(self.averageSurfaceNormal) > .4
	
	//Print("steepImpact %s, groundSurface %s ",ToString(steepImpact), ToString(groundSurface))

	if steepImpact and not groundSurface then
		SetSpeedDebugText("flup %s", ToString(Shared.GetTime()))
		return velocity
	else
		return requestedVelocity
	end

end

function FactionsMovementMixin:GetMaxSpeed(possible)

	local maxRunSpeed = self:GetUpgradedMaxSprintSpeed()
	local maxWalkSpeed = self:GetUpgradedMaxSpeed()
	if possible then
		// Sanity check
		if maxRunSpeed == nil then
			maxRunSpeed = Marine.kRunMaxSpeed
		end
		return maxRunSpeed
	end

	local onInfestation = self:GetGameEffectMask(kGameEffect.OnInfestation)
	local sprintingScalar = self:GetSprintingScalar()
	local maxSprintSpeed = maxWalkSpeed + (maxRunSpeed - maxWalkSpeed)*sprintingScalar
	local maxSpeed = ConditionalValue(self:GetIsSprinting(), maxSprintSpeed, maxWalkSpeed)
	
	// Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
	local inventorySpeedScalar = self:GetInventorySpeedScalar() + .17

	// Take into account crouching
	if not self:GetIsJumping() then
		maxSpeed = ( 1 - self:GetCrouchAmount() * self:GetCrouchSpeedScalar() ) * maxSpeed
	end
	
	// Take into account crouching
	if self:GetIsWallWalking() then
		maxSpeed = ( 1 - self:GetWallWalkSpeedScalar() ) * maxSpeed
	end

	local adjustedMaxSpeed = maxSpeed * inventorySpeedScalar 
	if self.GetCatalystMoveSpeedModifier then
	    adjustedMaxSpeed = adjustedMaxSpeed * self:GetCatalystMoveSpeedModifier()
	end
	
	// Proper speed for jetpack users
	if self:isa("JetpackMarine") then
		if self:GetIsJetpacking() or (not self:GetIsOnGround() and not self:GetIsWallWalking()) then
			adjustedMaxSpeed = JetpackMarine.kFlySpeed
		end
    end
	
	// Sanity check
	if adjustedMaxSpeed == nil then
		adjustedMaxSpeed = Marine.kWalkMaxSpeed
	end
	
	return adjustedMaxSpeed
	
end

function FactionsMovementMixin:OverrideUpdateOnGround(onGround)
    local isOnGround = onGround or self:GetIsWallWalking()
	if self:isa("JetpackMarine") then
		isOnGround = isOnGround and not self:GetIsJetpacking()
	end
	
	return isOnGround
end


function FactionsMovementMixin:GetRecentlyJumped()

	return not (self.timeOfLastJump == nil or (Shared.GetTime() > (self.timeOfLastJump + Marine.kJumpRepeatTime)))
	
end

function FactionsMovementMixin:ModifyVelocity(input, velocity, deltaTime)

	if self:isa("JetpackMarine") then
	
		JetpackMarine.ModifyVelocity(self, input, velocity, deltaTime)
		GroundMoveMixin.ModifyVelocity(self, input, velocity, deltaTime)
		JumpMoveMixin.ModifyVelocity(self, input, velocity, deltaTime)
		
	else

		local viewCoords = self:GetViewCoords()

		if self.jumpLandSpeed and self.timeOfLastJumpLand + 0.3 > Shared.GetTime() and input.move:GetLength() ~= 0 then
		
			// check if the current move is in the same direction as the requested move
			local moveXZ = GetNormalizedVectorXZ( viewCoords:TransformVector(input.move) )
			
			if moveXZ:DotProduct(GetNormalizedVectorXZ(velocity)) > 0.5 then
			
				local currentSpeed = velocity:GetLength()
				local prevY = velocity.y
				
				local scale = math.max(1, self.jumpLandSpeed / currentSpeed)        
				velocity:Scale(scale)
				velocity.y = prevY
			
			end
		
		end


		GroundMoveMixin.ModifyVelocity(self, input, velocity, deltaTime)
		JumpMoveMixin.ModifyVelocity(self, input, velocity, deltaTime)


		if not self:GetIsOnSurface() and input.move:GetLength() ~= 0 then

			local moveLengthXZ = velocity:GetLengthXZ()
			local previousY = velocity.y
			local adjustedZ = false

			if input.move.z ~= 0 then
			
				local redirectedVelocityZ = GetNormalizedVectorXZ(self:GetViewCoords().zAxis) * input.move.z
				redirectedVelocityZ.y = 0
				redirectedVelocityZ:Normalize()
				
				if input.move.z < 0 then
				
					if viewCoords:TransformVector(input.move):DotProduct(velocity) > 0 then
					
						redirectedVelocityZ = redirectedVelocityZ + GetNormalizedVectorXZ(velocity) * 8
						redirectedVelocityZ:Normalize()
						
						local xzVelocity = Vector(velocity)
						xzVelocity.y = 0
						
						VectorCopy(velocity - (xzVelocity * deltaTime * 2), velocity)
						
					end
					
				else
				
					redirectedVelocityZ = redirectedVelocityZ * deltaTime * Marine.kAirZMoveWeight + GetNormalizedVectorXZ(velocity)
					redirectedVelocityZ:Normalize()                
					redirectedVelocityZ:Scale(moveLengthXZ)
					redirectedVelocityZ.y = previousY
					
					adjustedZ = true
					
					VectorCopy(redirectedVelocityZ,  velocity)
				
				end
			
			end
			
			if input.move.x ~= 0  then
			
				local redirectedVelocityX = GetNormalizedVectorXZ(self:GetViewCoords().xAxis) * input.move.x
				redirectedVelocityX.y = 0
				redirectedVelocityX:Normalize()
				
				redirectedVelocityX = redirectedVelocityX * deltaTime * Marine.kAirStrafeWeight + GetNormalizedVectorXZ(velocity)
				
				redirectedVelocityX:Normalize()            
				redirectedVelocityX:Scale(moveLengthXZ)
				redirectedVelocityX.y = previousY            
				VectorCopy(redirectedVelocityX,  velocity)
			
			end
			
		end
		
		// accelerate XZ speed when falling down
		if not self:GetIsOnSurface() and velocity:GetLengthXZ() < Marine.kMaxVerticalAirAccel then
		
			local acceleration = Marine.kVerticalAcceleration
			local accelFraction = Clamp( (-velocity.y - 3.5) / 7, 0, 1)
			
			local addAccel = GetNormalizedVectorXZ(velocity) * accelFraction * deltaTime * acceleration

			velocity.x = velocity.x + addAccel.x
			velocity.z = velocity.z + addAccel.z
			
		end
		
	end
	
end

function FactionsMovementMixin:ConstrainMoveVelocity(moveVelocity)

	// allow acceleration in air for skulks   
	if not self:GetIsOnSurface() then
	
		local speedFraction = Clamp(self:GetVelocity():GetLengthXZ() / self:GetMaxSpeed(), 0, 1)
		speedFraction = 1 - (speedFraction * speedFraction)
		moveVelocity:Scale(speedFraction * Marine.kAirAccelerationFraction)
		
		if self:GetVelocity():GetLengthXZ() > 30 then
			Print("system crash!")
		end
		
	end

end

function FactionsMovementMixin:GetGroundFriction()   

	return ConditionalValue(self.crouching or self.isUsing, Marine.kGroundWalkFriction, Marine.kGroundFriction) 

end

function FactionsMovementMixin:GetCanStep()
    return not self:GetIsWallWalking()
end

function FactionsMovementMixin:ModifyGravityForce(gravityTable)

	if self:isa("JetpackMarine") then 
		gravityTable.gravity = JetpackMarine.kJetpackGravity
	end

    if self:GetIsWallWalking() and not self:GetCrouching() then
        gravityTable.gravity = 0

    elseif self:GetIsOnGround() then
        gravityTable.gravity = 0
    
	elseif self:GetIsOnLadder() then
		gravityTable.gravity = 0
		
    end

end

function FactionsMovementMixin:GetIsOnSurface()

	return GroundMoveMixin.GetIsOnSurface(self) or self:GetIsWallWalking()
	
end

function FactionsMovementMixin:AdjustGravityForce(input, gravity)

	// No gravity when we're sticking to a wall.
	if self:GetIsWallWalking() then
		gravity = 0
	end
	
	if self:isa("JetpackMarine") then
		return JetpackMarine.AdjustGravityForce(self, input, gravity)
	end
	
	return gravity
	
end

function FactionsMovementMixin:GetMoveDirection(moveVelocity)

	// Don't constrain movement to XZ so we can walk smoothly up walls
	if self:GetIsWallWalking() then
		return GetNormalizedVector(moveVelocity)
	end
	
	return GroundMoveMixin.GetMoveDirection(self, moveVelocity)
	
end

function FactionsMovementMixin:GetIsCloseToGround(distanceToGround)

	if self:GetIsWallWalking() then
		return false
	end
	
	return GroundMoveMixin.GetIsCloseToGround(self, distanceToGround)
	
end

// Play footsteps when walking up a wall.
function FactionsMovementMixin:GetPlayFootsteps()

	return self:GetVelocityLength() > .75 and self:GetIsOnSurface() and self:GetIsAlive()

end

function FactionsMovementMixin:GetIsOnGround()

	return GroundMoveMixin.GetIsOnGround(self) and not self:GetIsWallWalking()    
	
end

function FactionsMovementMixin:GetPerformsVerticalMove()

	return self:GetIsWallWalking()
	
end

function FactionsMovementMixin:GetJumpVelocity(input, velocity)

	local viewCoords = self:GetViewAngles():GetCoords()
	
	local soundEffectName = "jump"
	
	// we add the bonus in the direction the move is going
	local move = input.move
	move.x = move.x * 0.01
	
	if input.move:GetLength() ~= 0 then
		self.bonusVec = viewCoords:TransformVector(move)
	else
		self.bonusVec = viewCoords.zAxis
	end

	self.bonusVec.y = 0
	self.bonusVec:Normalize()
	
	if self:GetCanWallJump() then
	
		if not self:GetRecentlyWallJumped() then
		
			local previousVelLength = self:GetVelocityLength()
	
			velocity.x = velocity.x + self.bonusVec.x * Marine.kWallJumpForce
			velocity.z = velocity.z + self.bonusVec.z * Marine.kWallJumpForce
			
			local speedXZ = velocity:GetLengthXZ()
			if speedXZ < Marine.kMinWallJumpSpeed then
			
				velocity.y = 0
				velocity:Normalize()
				velocity:Scale(Marine.kMinWallJumpSpeed)
				
			end
			
			velocity.y = viewCoords.zAxis.y * Marine.kWallJumpYDirection + Marine.kWallJumpYBoost

		end
		
		// spamming jump against a wall wont help
		self.timeLastWallJump = Shared.GetTime()
		
	else
		
		velocity.y = math.sqrt(math.abs(2 * self:GetJumpHeight() * self:GetMixinConstants().kGravity))
		
	end
	
	self:TriggerEffects(soundEffectName, {surface = self:GetMaterialBelowPlayer()})
	
end

// Handle jump sounds ourselves
function FactionsMovementMixin:GetPlayJumpSound()
	return false
end

function FactionsMovementMixin:HandleJump(input, velocity)

	local success = GroundMoveMixin.HandleJump(self, input, velocity)
	
	if success then
	
		self.wallWalking = false
		self.wallWalkingEnabled = false
	
	end
		
	return success
	
end

// Make sure we can't move faster than our max speed (esp. when holding
// down multiple keys, going down ramps, etc.)
function FactionsMovementMixin:OnClampSpeed(input, velocity)

    PROFILE("FactionsMovementMixin:OnClampSpeed")
    
    // Don't clamp speed when stunned, so we can go flying
    if HasMixin(self, "Stun") and self:GetIsStunned() then
        return velocity
    end
    
    if self:GetPerformsVerticalMove() then
        moveSpeed = velocity:GetLength()   
    else
        moveSpeed = velocity:GetLengthXZ()   
    end
    
	// TODO: Fix the speed inheritance from class then reenable here.
	//local maxSpeed = 9999
    local maxSpeed = self:GetMaxSpeed()
    
    // Players moving backwards can't go full speed.
    if input.move.z < 0 then
        maxSpeed = maxSpeed * self:GetMaxBackwardSpeedScalar()
    end
    
    if moveSpeed > maxSpeed then
    
        local velocityY = velocity.y
        velocity:Scale(maxSpeed / moveSpeed)
        
        if not self:GetPerformsVerticalMove() then
            velocity.y = velocityY
        end
        
    end
    
end

// MoveMixin callbacks.
// Compute the desired velocity based on the input. Make sure that going off at 45 degree angles
// doesn't make us faster.
function FactionsMovementMixin:ComputeForwardVelocity(input)

    local forwardVelocity = Vector(0, 0, 0)
    
    local move = GetNormalizedVector(input.move)
    local angles = self:ConvertToViewAngles(input.pitch, input.yaw, 0)
    local viewCoords = angles:GetCoords()
    
    local accel = ConditionalValue(self:GetIsOnLadder(), Marine.kLadderAcceleration, self:GetAcceleration())
    
    local moveVelocity = viewCoords:TransformVector(move) * accel
    if input.move.z < 0 and self:GetVelocity():GetLength() > self:GetMaxSpeed() * 0.4 then
        moveVelocity = moveVelocity * self:GetMaxBackwardSpeedScalar()
    end

    self:ConstrainMoveVelocity(moveVelocity)
    
    // The active weapon can also constain the move velocity.
    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon ~= nil then
        activeWeapon:ConstrainMoveVelocity(moveVelocity)
    end
    
    // Make sure that moving forward while looking down doesn't slow 
    // us down (get forward velocity, not view velocity)
    local moveVelocityLength = moveVelocity:GetLength()
    
    if moveVelocityLength > 0 then

        local moveDirection = self:GetMoveDirection(moveVelocity)
        
        // Trying to move straight down
        if not ValidateValue(moveDirection) then
            moveDirection = Vector(0, -1, 0)
        end
        
        forwardVelocity = moveDirection * moveVelocityLength
        
    end
    
    local pushVelocity = Vector( self.pushImpulse * ( 1 - Clamp( (Shared.GetTime() - self.pushTime) / Player.kPushDuration, 0, 1) ) )
    
    return forwardVelocity + pushVelocity * (self:GetGroundFriction()/7)

end

function FactionsMovementMixin:GetWallWalkSpeedScalar()
	local timeSinceLastWallWalk = Shared.GetTime() - self.timeStartedWallWalking
	local wallWalkTimeFraction = math.min(timeSinceLastWallWalk/Marine.kWallWalkSlowdownTime, 1)
	return Marine.kWallWalkSpeedScalar * wallWalkTimeFraction
end

// Functions to control movement, angles.
function FactionsMovementMixin:GetAngleSmoothRate()

	if self:GetIsWallWalking() then
		return 1.5
	end    

	return 7
	
end

function FactionsMovementMixin:GetCrouchSpeedScalar()
	return Marine.kCrouchSpeedScalar
end

function FactionsMovementMixin:GetRollSmoothRate()
	return 4
end

function FactionsMovementMixin:GetPitchSmoothRate()
	return 3
end

function FactionsMovementMixin:GetAirFriction()
	return 0.1
end 

function FactionsMovementMixin:GetJumpHeight()
	//return Marine.kJumpHeight - Marine.kJumpHeight * self.slowAmount * 0.8
	return Marine.kJumpHeight
end