//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Marine.lua

Script.Load("lua/Factions/Factions_MagnoBootsWearerMixin.lua")
Script.Load("lua/Factions/Factions_TimerMixin.lua")
Script.Load("lua/Factions/Factions_SpeedUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_WeaponUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_HealthUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_ArmorUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_FactionsMovementMixin.lua")
Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")
Script.Load("lua/Factions/Factions_IronSightViewerMixin.lua")
Script.Load("lua/Factions/Factions_SpawnProtectMixin.lua")
Script.Load("lua/Factions/Factions_BuyMenuMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(MagnoBootsWearerMixin, networkVars)
AddMixinNetworkVars(SpeedUpgradeMixin, networkVars)
AddMixinNetworkVars(WeaponUpgradeMixin, networkVars)
AddMixinNetworkVars(HealthUpgradeMixin, networkVars)
AddMixinNetworkVars(ArmorUpgradeMixin, networkVars)
AddMixinNetworkVars(FactionsMovementMixin, networkVars)
AddMixinNetworkVars(TeamColoursMixin, networkVars)
AddMixinNetworkVars(SpawnProtectMixin, networkVars)

function Marine:SetupFactionsMovement()

	// Balance, movement, animation
	Marine.kSprintAcceleration = 220
	Marine.kSprintInfestationAcceleration = 150
	Marine.kAcceleration = 140
	Marine.kLadderAcceleration = 50
	Marine.kGroundFriction = 13
	Marine.kGroundWalkFriction = 20

	Marine.kCrouchSpeedScalar = 0.4
	Marine.kWallWalkSpeedScalar = 0.5
	Marine.kWallWalkSlowdownTime = 1.0

	Marine.kWalkMaxSpeed = 5.0                // Four miles an hour = 6,437 meters/hour = 1.8 meters/second (increase for FPS tastes)
	Marine.kRunMaxSpeed = 9.0               // 10 miles an hour = 16,093 meters/hour = 4.4 meters/second (increase for FPS tastes)
	Marine.kRunInfestationMaxSpeed = Marine.kRunMaxSpeed - 0.5
	Marine.kWalkBackwardSpeedScalar = 0.75

	Marine.kJumpHeight = 2.3

	// Wall walking logic.
	Marine.kJumpRepeatTime = 0.1
	Marine.kWallJumpInterval = 0.3

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
	Marine.kVerticalAcceleration = 7

	Marine.kWallJumpForce = 1.2
	Marine.kMinWallJumpSpeed = 9

	Marine.kAirZMoveWeight = 5
	Marine.kAirStrafeWeight = 2.5
	Marine.kAirAccelerationFraction = 0.6

	Marine.kAirMoveMinVelocity = 8
	
	// Set up the Combat Movement mixin
	InitMixin(self, FactionsMovementMixin)
	assert(HasMixin(self, "FactionsMovement"))

end

// Use the new Mixins here.
local overrideOnCreate = Marine.OnCreate
function Marine:OnCreate()

	overrideOnCreate(self)

	// Init mixins
    InitMixin(self, WallMovementMixin)
	InitMixin(self, MagnoBootsWearerMixin)
	InitMixin(self, SpeedUpgradeMixin)
	InitMixin(self, WeaponUpgradeMixin)
	InitMixin(self, HealthUpgradeMixin)
	InitMixin(self, ArmorUpgradeMixin)
	InitMixin(self, CloakableMixin)
	InitMixin(self, IronSightViewerMixin)
	InitMixin(self, SpawnProtectMixin)
	InitMixin(self, BuyMenuMixin)
	
	assert(HasMixin(self, "FactionsClass"))
	assert(HasMixin(self, "WallMovement"))
	assert(HasMixin(self, "MagnoBootsWearer"))
	assert(HasMixin(self, "SpeedUpgrade"))
	assert(HasMixin(self, "WeaponUpgrade"))
	assert(HasMixin(self, "HealthUpgrade"))
	assert(HasMixin(self, "ArmorUpgrade"))
	assert(HasMixin(self, "Cloakable"))
	assert(HasMixin(self, "IronSightViewer"))
	assert(HasMixin(self, "SpawnProtect"))
	assert(HasMixin(self, "BuyMenu"))
	assert(HasMixin(self, "Xp"))
	assert(HasMixin(self, "FactionsUpgrade"))
	
	// Server-only mixins
	if Server then
		InitMixin(self, TimerMixin)
		assert(HasMixin(self, "Timer"))
	end
	
	// Factions movement
	if GetGamerulesInfo():GetIsFactionsMovement() then
		self:SetupFactionsMovement()
	end
	
	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
end

// Dont' drop weapons after getting killed, but destroy them!
local originalOnKill = Marine.OnKill
function Marine:OnKill(damage, attacker, doer, point, direction)

    self:DestroyWeapons()
	originalOnKill(self, damage, attacker, doer, point, direction)
	
end

// Weapons can't be dropped anymore
function Marine:Drop(weapon, ignoreDropTimeLimit, ignoreReplacementWeapon)

	// Just do nothing
	// Drop code for replacement weapons is handled in our upgrade system.

end

//if GetGamerulesInfo():GetIsFactionsMovement() then
// TODO: Fix how this is controlled. Move it to FactionsMovementMixin!
if false then
	// Functions to control movement, angles.
	function Marine:GetAngleSmoothRate()

		if self:GetIsWallWalking() then
			return 1.5
		end    

		return 7
		
	end

	function Marine:GetCrouchSpeedScalar()
		return Marine.kCrouchSpeedScalar
	end

	function Marine:GetRollSmoothRate()
		return 4
	end

	function Marine:GetPitchSmoothRate()
		return 3
	end

	function Marine:GetAirFrictionForce()
		return 0.2
	end 

	function Marine:GetJumpHeight()
		//return Marine.kJumpHeight - Marine.kJumpHeight * self.slowAmount * 0.8
		return Marine.kJumpHeight
	end
end

Class_Reload("Marine", networkVars)