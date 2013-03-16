//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_CombatMovementMixin.lua

Script.Load("lua/FunctionContracts.lua")

CombatMovementMixin = CreateMixin( CombatMovementMixin )
CombatMovementMixin.type = "CombatMovement"

CombatMovementMixin.expectedMixins =
{
	 WallMovement = "Needed for processing the wall walking.",
	 FactionsClass = "Needed for changing the movement speed depending on class.",
	 MagnoBootsWearer = "Needed for detecting whether the player has Magno Boots"
}

CombatMovementMixin.expectedCallbacks =
{
	GetAngleSmoothRate = "The smooth rate for the angle changes as the player moves from wall to wall",
	GetRollSmoothRate = "The smooth rate for the angle changes as the player moves from wall to wall",
	GetPitchSmoothRate = "The smooth rate for the angle changes as the player moves from wall to wall",
	GetUpgradedMaxSprintSpeed = "The speed that the player runs",
	GetUpgradedSprintAcceleration = "The speed that the player runs",
	GetUpgradedMaxSpeed = "The speed that the player walks",
	GetUpgradedAcceleration = "The speed that the player walks",
	
	GetAirFrictionForce = "The force of Air Friction for this entity",
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

CombatMovementMixin.expectedConstants =
{
}

CombatMovementMixin.networkVars =
{
	wallWalking = "compensated boolean",
	timeLastWallWalkCheck = "private compensated time",
	wallWalkingNormalGoal = "private compensated vector (-1 to 1 by 0.001)",
	wallWalkingNormalCurrent = "private compensated vector (-1 to 1 by 0.001 [ 8 ], -1 to 1 by 0.001 [ 9 ])",
	
	wallWalkingEnabled = "private compensated boolean",
	timeOfLastJumpLand = "private compensated time",
	timeLastWallJump = "private compensated time",
	jumpLandSpeed = "private compensated float",
}

// These should completely override any existing function defined in the class.
CombatMovementMixin.overrideFunctions =
{
	"GetAcceleration",
	"GetAirMoveScalar",
	"GetIsJumping",
	"GetMoveSpeedIs2D",
	"GetRecentlyWallJumped",
	"GetCanWallJump",
	"GetIsOnLadder",
	"GetCanJump",
	"GetIsWallWalking",
	"GetIsWallWalkingPossible",
	"PreUpdateMove",
	"GetDesiredAngles",
	"GetSmoothAngles",
	"UpdatePosition",
	"GetMaxSpeed",
	"GetRecentlyJumped",
	"ModifyVelocity",
	"ConstrainMoveVelocity",
	"GetGroundFrictionForce",
	"GetFrictionForce",
	"GetGravityAllowed",
	"GetIsOnSurface",
	"GetIsAffectedByAirFriction",
	"AdjustGravityForce",
	"GetMoveDirection",
	"GetIsCloseToGround",
	"GetPlayFootsteps",
	"GetIsOnGround",
	"PerformsVerticalMove",
	"GetJumpVelocity",
	"GetPlayJumpSound",
	"HandleJump",
	"OnClampSpeed",
	
}

function CombatMovementMixin:__initmixin()

	// Wall walking stuff
	self.wallWalking = false
    self.wallWalkingNormalCurrent = Vector.yAxis
    self.wallWalkingNormalGoal = Vector.yAxis
    
    if Client then
    
        self.currentCameraRoll = 0
        self.goalCameraRoll = 0
        
    end
    
    self.timeLastWallJump = 0
	
end

function CombatMovementMixin:GetAcceleration()

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

    return acceleration * self:GetCatalystMoveSpeedModifier()

end

function CombatMovementMixin:GetAirMoveScalar()

	if self:GetVelocityLength() < self.kAirMoveMinVelocity then
		return 1.0
	else
		return 0
	end
	
end

// required to trigger wall walking animation
function CombatMovementMixin:GetIsJumping()

	return Player.GetIsJumping(self) and not self.wallWalking	
	
end

// The movement should factor in the vertical velocity
// only when wall walking.
function CombatMovementMixin:GetMoveSpeedIs2D()

	return not self:GetIsWallWalking()
	
end

function CombatMovementMixin:GetRecentlyWallJumped()

	return self.timeLastWallJump + Marine.kWallJumpInterval > Shared.GetTime()
	
end

function CombatMovementMixin:GetCanWallJump()

	return self:GetHasMagnoBoots() and (self:GetIsWallWalking() or (not self:GetIsOnGround() and self:GetAverageWallWalkingNormal(Marine.kJumpWallRange, Marine.kJumpWallFeelerSize) ~= nil))
	
end

// Players with magno boots don't need ladders
function CombatMovementMixin:GetIsOnLadder()

	if self:GetHasMagnoBoots() then
		return false
	else
		return Player.GetIsOnLadder(self)
	end

end

function CombatMovementMixin:GetCanJump()

	return Player.GetCanJump(self) or self:GetCanWallJump()    
	
end

function CombatMovementMixin:GetIsWallWalking()

	return self.wallWalking

end

function CombatMovementMixin:GetIsWallWalkingPossible() 

	// Can only wall walk if you have magno boots
	return self:GetHasMagnoBoots() and not self:GetRecentlyJumped() /* and not self.crouching */ 
	
end

function CombatMovementMixin:PreUpdateMove(input, runningPrediction)

	PROFILE("Marine:PreUpdateMove")
	
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
end

function CombatMovementMixin:GetDesiredAngles(deltaTime)

	if self:GetIsWallWalking() then    
		return self:GetAnglesFromWallNormal(self.wallWalkingNormalCurrent, 1)        
	end
	
	return Player.GetDesiredAngles(self)
	
end 

function CombatMovementMixin:GetSmoothAngles()

	return not self:GetIsWallWalking()	
	
end

local kUpVector = Vector(0, 1, 0)
function CombatMovementMixin:UpdatePosition(velocity, time)

	PROFILE("Marine:UpdatePosition")

	local yAxis = self.wallWalkingNormalGoal
	local requestedVelocity = Vector(velocity)
	local moveDirection = GetNormalizedVector(velocity)
	local storeSpeed = false
	local hitEntities = nil
	
	if self.adjustToGround then
		velocity.y = 0
		self.adjustToGround = false
	end
	
	local wasOnSurface = self:GetIsOnSurface()
	local oldSpeed = velocity:GetLengthXZ()
	
	velocity, hitEntities, self.averageSurfaceNormal = Player.UpdatePosition(self, velocity, time)
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

function CombatMovementMixin:GetMaxSpeed(possible)

	local maxRunSpeed = self:GetUpgradedMaxSprintSpeed()
	local maxWalkSpeed = self:GetUpgradedMaxSpeed()
	if possible then
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

	local adjustedMaxSpeed = maxSpeed * self:GetCatalystMoveSpeedModifier() * inventorySpeedScalar 
	//Print("Adjusted max speed => %.2f (without inventory: %.2f)", adjustedMaxSpeed, adjustedMaxSpeed / inventorySpeedScalar )
	return adjustedMaxSpeed
	
end

function CombatMovementMixin:GetRecentlyJumped()

	return not (self.timeOfLastJump == nil or (Shared.GetTime() > (self.timeOfLastJump + Marine.kJumpRepeatTime)))
	
end

function CombatMovementMixin:ModifyVelocity(input, velocity)

	if self:isa("JetpackMarine") then
	
		JetpackMarine.ModifyVelocity(self, input, velocity)
		
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


		Player.ModifyVelocity(self, input, velocity)


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
						
						VectorCopy(velocity - (xzVelocity * input.time * 2), velocity)
						
					end
					
				else
				
					redirectedVelocityZ = redirectedVelocityZ * input.time * Marine.kAirZMoveWeight + GetNormalizedVectorXZ(velocity)
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
				
				redirectedVelocityX = redirectedVelocityX * input.time * Marine.kAirStrafeWeight + GetNormalizedVectorXZ(velocity)
				
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
			
			local addAccel = GetNormalizedVectorXZ(velocity) * accelFraction * input.time * acceleration

			velocity.x = velocity.x + addAccel.x
			velocity.z = velocity.z + addAccel.z
			
		end
		
	end
	
end

function CombatMovementMixin:ConstrainMoveVelocity(moveVelocity)

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

function CombatMovementMixin:GetGroundFrictionForce()   

	return ConditionalValue(self.crouching or self.isUsing, Marine.kGroundWalkFriction, Marine.kGroundFriction) 

end

function CombatMovementMixin:GetFrictionForce(input, velocity)

	local friction = Player.GetFrictionForce(self, input, velocity)
	if self:GetIsWallWalking() then
		friction.y = -self:GetVelocity().y * self:GetGroundFrictionForce()
	end
	
	return friction

end

function CombatMovementMixin:GetGravityAllowed()

	return not self:GetIsOnLadder() and not self:GetIsOnGround() and not self:GetIsWallWalking()
	
end

function CombatMovementMixin:GetIsOnSurface()

	return Player.GetIsOnSurface(self) or self:GetIsWallWalking()
	
end

function CombatMovementMixin:GetIsAffectedByAirFriction()
	return not self:GetIsOnSurface()
end

function CombatMovementMixin:AdjustGravityForce(input, gravity)

	// No gravity when we're sticking to a wall.
	if self:GetIsWallWalking() then
		gravity = 0
	end
	
	if self:isa("JetpackMarine") then
		return JetpackMarine.AdjustGravityForce(self, input, gravity)
	end
	
	return gravity
	
end

function CombatMovementMixin:GetMoveDirection(moveVelocity)

	// Don't constrain movement to XZ so we can walk smoothly up walls
	if self:GetIsWallWalking() then
		return GetNormalizedVector(moveVelocity)
	end
	
	return Player.GetMoveDirection(self, moveVelocity)
	
end

function CombatMovementMixin:GetIsCloseToGround(distanceToGround)

	if self:GetIsWallWalking() then
		return false
	end
	
	return Player.GetIsCloseToGround(self, distanceToGround)
	
end

// Play footsteps when walking up a wall.
function CombatMovementMixin:GetPlayFootsteps()

	return self:GetVelocityLength() > .75 and self:GetIsOnSurface() and self:GetIsAlive()

end

function CombatMovementMixin:GetIsOnGround()

	return Player.GetIsOnGround(self) and not self:GetIsWallWalking()    
	
end

function CombatMovementMixin:PerformsVerticalMove()

	return self:GetIsWallWalking()
	
end

function CombatMovementMixin:GetJumpVelocity(input, velocity)

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
function CombatMovementMixin:GetPlayJumpSound()
	return false
end

function CombatMovementMixin:HandleJump(input, velocity)

	local success = Player.HandleJump(self, input, velocity)
	
	if success then
	
		self.wallWalking = false
		self.wallWalkingEnabled = false
	
	end
		
	return success
	
end

// Make sure we can't move faster than our max speed (esp. when holding
// down multiple keys, going down ramps, etc.)
function CombatMovementMixin:OnClampSpeed(input, velocity)

    PROFILE("CombatMovementMixin:OnClampSpeed")
    
    // Don't clamp speed when stunned, so we can go flying
    if HasMixin(self, "Stun") and self:GetIsStunned() then
        return velocity
    end
    
    if self:PerformsVerticalMove() then
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
        
        if not self:PerformsVerticalMove() then
            velocity.y = velocityY
        end
        
    end
    
end