//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Marine.lua

Script.Load("lua/ProjectTitan/Titan_MagnoBootsWearerMixin.lua")
Script.Load("lua/ProjectTitan/Titan_CombatMovementMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(MagnoBootsWearerMixin, networkVars)
AddMixinNetworkVars(CombatMovementMixin, networkVars)

// There are also options you can pass to be able to access the return value and have multiple return arguments,
// but as they slow down the hooks mechanism slightly you have to set that up specifically.
local overrideOnCreate = Marine.OnCreate

function Marine:OnCreate()

	overrideOnCreate(self)

	// Init mixins
    InitMixin(self, WallMovementMixin)
	InitMixin(self, MagnoBootsWearerMixin)
	InitMixin(self, CombatMovementMixin)
	
	assert(HasMixin(self, "MagnoBootsWearer"))
	assert(HasMixin(self, "CombatMovement"))
	
end

// Balance, movement, animation
Marine.kJumpRepeatTime = 0.1
Marine.kWallJumpInterval = 0.3

Marine.kAcceleration = 100
Marine.kGroundFriction = 16
Marine.kGroundWalkFriction = 28

Marine.kWallWalkCheckInterval = .1
// This is how quickly the 3rd person model will adjust to the new normal.
Marine.kWallWalkNormalSmoothRate = 7
// How big the spheres are that are casted out to find walls, "feelers".
// The size is calculated so the "balls" touch each other at the end of their range
Marine.kNormalWallWalkFeelerSize = 0.25
Marine.kNormalWallWalkRange = 0.3

// jump is valid when you are close to a wall but not attached yet at this range
Marine.kJumpWallRange = 0.4
Marine.kJumpWallFeelerSize = 0.1

// when we slow down to less than 97% of previous speed we check for walls to attach to
Marine.kWallStickFactor = 1

// force added to Marine, depends on timing
Marine.kWallJumpYBoost = 2.5
Marine.kWallJumpYDirection = 5

Marine.kMaxVerticalAirAccel = 12

Marine.kWallJumpForce = 1.2
Marine.kMinWallJumpSpeed = 9

Marine.kAirZMoveWeight = 5
Marine.kAirStrafeWeight = 2.5
Marine.kAirAccelerationFraction = 0.5

Marine.kAirMoveMinVelocity = 8

// Override the marine extents for physics purposes.
//Marine.kXExtents = .55
//Marine.kYExtents = .65
//Marine.kZExtents = .55
//SetCachedTechData(kTechId.Marine, kTechDataMaxExtents, Vector(Marine.kXExtents, Marine.kYExtents, Marine.kZExtents))

function Marine:GetAngleSmoothRate()

	if self:GetIsWallWalking() then
		return 1.5
	end    

	return 7
	
end

function Marine:GetRollSmoothRate()
	return 4
end

function Marine:GetPitchSmoothRate()
	return 3
end

function Marine:GetAirFrictionForce()
	return 0.25
end 

Class_Reload("Marine", networkVars)