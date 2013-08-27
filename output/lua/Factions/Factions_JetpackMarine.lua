//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_JetpackMarine.lua

local networkVars = {
}

// Balance, movement, animation
JetpackMarine.kJetpackFuelReplenishDelay = .4
JetpackMarine.kJetpackGravity = -9
JetpackMarine.kVerticalThrustAccelerationMod = 3
JetpackMarine.kVerticalFlyAccelerationMod = 1.6
JetpackMarine.kJetpackAcceleration = 20
JetpackMarine.kFlySpeed = 10

function SetupFactionsMovementJetpackMarine()
	// Copy all the values from the Marine.
	JetpackMarine.kSprintAcceleration = Marine.kSprintAcceleration
	JetpackMarine.kSprintInfestationAcceleration = Marine.kSprintInfestationAcceleration
	JetpackMarine.kAcceleration = Marine.kAcceleration
	JetpackMarine.kLadderAcceleration = Marine.kLadderAcceleration
	JetpackMarine.kGroundFriction = Marine.kGroundFriction
	JetpackMarine.kGroundWalkFriction = Marine.kGroundWalkFriction
	JetpackMarine.kCrouchSpeedScalar = Marine.kCrouchSpeedScalar
	JetpackMarine.kWallWalkSpeedScalar = Marine.kWallWalkSpeedScalar
	JetpackMarine.kWallWalkSlowdownTime = Marine.kWallWalkSlowdownTime
	JetpackMarine.kWalkMaxSpeed = Marine.kWalkMaxSpeed
	JetpackMarine.kRunMaxSpeed = Marine.kRunMaxSpeed
	JetpackMarine.kRunInfestationMaxSpeed = Marine.kRunInfestationMaxSpeed
	JetpackMarine.kWalkBackwardSpeedScalar = Marine.kWalkBackwardSpeedScalar
	JetpackMarine.kJumpHeight = Marine.kJumpHeight
	JetpackMarine.kJumpRepeatTime = Marine.kJumpRepeatTime
	JetpackMarine.kWallJumpInterval = Marine.kWallJumpInterval
	JetpackMarine.kWallWalkCheckInterval = Marine.kWallWalkCheckInterval
	JetpackMarine.kWallWalkNormalSmoothRate = Marine.kWallWalkNormalSmoothRate
	JetpackMarine.kNormalWallWalkFeelerSize = Marine.kNormalWallWalkFeelerSize
	JetpackMarine.kNormalWallWalkRange = Marine.kNormalWallWalkRange
	JetpackMarine.kJumpWallRange = Marine.kJumpWallRange
	JetpackMarine.kJumpWallFeelerSize = Marine.kJumpWallFeelerSize
	JetpackMarine.kWallStickFactor = Marine.kWallStickFactor
	JetpackMarine.kWallJumpYBoost = Marine.kWallJumpYBoost
	JetpackMarine.kWallJumpYDirection = Marine.kWallJumpYDirection
	JetpackMarine.kMaxVerticalAirAccel = Marine.kMaxVerticalAirAccel
	JetpackMarine.kVerticalAcceleration = Marine.kVerticalAcceleration
	JetpackMarine.kWallJumpForce = Marine.kWallJumpForce
	JetpackMarine.kMinWallJumpSpeed = Marine.kMinWallJumpSpeed
	JetpackMarine.kAirZMoveWeight = Marine.kAirZMoveWeight
	JetpackMarine.kAirStrafeWeight = Marine.kAirStrafeWeight
	JetpackMarine.kAirAccelerationFraction = Marine.kAirAccelerationFraction
	JetpackMarine.kAirMoveMinVelocity = Marine.kAirMoveMinVelocity
end

function JetpackMarine:GetAirFriction()
    return 0.2
end

Class_Reload("JetpackMarine", networkVars)