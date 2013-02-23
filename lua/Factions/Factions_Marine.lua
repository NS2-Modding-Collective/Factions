//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Marine.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")
Script.Load("lua/Factions/Factions_MagnoBootsWearerMixin.lua")
Script.Load("lua/Factions/Factions_CombatMovementMixin.lua")
Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")
Script.Load("lua/Factions/Factions_IronSightViewerMixin.lua")
Script.Load("lua/Factions/Factions_SpawnProtectMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(MagnoBootsWearerMixin, networkVars)
AddMixinNetworkVars(CombatMovementMixin, networkVars)
AddMixinNetworkVars(SpawnProtectMixin, networkVars)
AddMixinNetworkVars(FactionsClassMixin, networkVars)


// Balance, movement, animation
Marine.kSprintAcceleration = 180
Marine.kSprintInfestationAcceleration = 150
Marine.kAcceleration = 120
Marine.kGroundFriction = 13
Marine.kGroundWalkFriction = 22

Marine.kCrouchSpeedScalar = 0.4

Marine.kWalkMaxSpeed = 5.0                // Four miles an hour = 6,437 meters/hour = 1.8 meters/second (increase for FPS tastes)
Marine.kRunMaxSpeed = 9.0               // 10 miles an hour = 16,093 meters/hour = 4.4 meters/second (increase for FPS tastes)
Marine.kRunInfestationMaxSpeed = Marine.kRunMaxSpeed - 0.5
Marine.kWalkBackwardSpeedScalar = 0.75

Marine.kJumpHeight = 2.5

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

// Override the marine extents for physics purposes.
//Marine.kXExtents = .55
//Marine.kYExtents = .65
//Marine.kZExtents = .55
//SetCachedTechData(kTechId.Marine, kTechDataMaxExtents, Vector(Marine.kXExtents, Marine.kYExtents, Marine.kZExtents))

// Use the new Mixins here.
local overrideOnCreate = Marine.OnCreate
function Marine:OnCreate()

	overrideOnCreate(self)

	// Init mixins
    InitMixin(self, WallMovementMixin)
	InitMixin(self, MagnoBootsWearerMixin)
	InitMixin(self, CombatMovementMixin)
	InitMixin(self, TeamColoursMixin)
	InitMixin(self, IronSightViewerMixin)
	InitMixin(self, SpawnProtectMixin)
	InitMixin(self, FactionsClassMixin)
	InitMixin(self, XpMixin)
	InitMixin(self, UpgradeMixin)
	
	assert(HasMixin(self, "MagnoBootsWearer"))
	assert(HasMixin(self, "CombatMovement"))
	assert(HasMixin(self, "TeamColours"))
	assert(HasMixin(self, "IronSightViewer"))
	assert(HasMixin(self, "SpawnProtect"))
	assert(HasMixin(self, "FactionsClass"))
	assert(HasMixin(self, "Xp"))
	assert(HasMixin(self, "Upgrade"))
	
end

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
    return Marine.kJumpHeight - Marine.kJumpHeight * self.slowAmount * 0.8
end

if Client then
    // this ist just dummy to get it fast working
    function Combat_ResolveString(string)
        return string
    end
    // Terrible Terrible hack. Yuck.
    local g_MarineBuyMenu = nil
    
    // starting the custom buy menu for marines
    function Marine:Buy()

       // Don't allow display in the ready room, or as phantom
        if Client.GetLocalPlayer() == self then
            if self:GetTeamNumber() ~= 0 then
            
                if not self.buyMenu then
                    // open the buy menu
                    self.combatBuy = true
                    self.buyMenu = GetGUIManager():CreateGUIScript("Factions/Hud/combat_GUIMarineBuyMenu")
                    g_MarineBuyMenu = self.buyMenu
                    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
                else
                    self.combatBuy = false
                    self:CloseMenu()
                end               

            end            
        end
    end
    
    // dont close the menu
    local overrideCloseMenu = Marine.CloseMenu
    function Marine:CloseMenu(buyMenu) 
        if buyMenu then
            overrideCloseMenu(self)
        end
    end
end

Class_Reload("Marine", networkVars)