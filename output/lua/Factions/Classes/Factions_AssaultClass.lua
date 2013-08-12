//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AssaultClass.lua

// Assault Class
							
class 'AssaultClass' (FactionsClass)

AssaultClass.type 					= "Assault"						     								// the type of the FactionsClass
AssaultClass.name 					= "Assault"     													// the friendly name of the FactionsClass
AssaultClass.description 			= "A regular dude"										     		// the description of the FactionsClass
AssaultClass.baseHealth 			= kMarineHealth	+ 20										     	// the base health value of this class
AssaultClass.baseArmor 				= kMarineArmor + 20										     		// the base armor value of this class
AssaultClass.baseWalkSpeed 			= 4.5                												// the initial walk speed of this class
AssaultClass.baseRunSpeed 			= 8.0                												// the initial run speed of this class
AssaultClass.baseDropCount 			= 2	                												// how many packs get dropped when you drop health/ammo
AssaultClass.maxBackwardSpeedScalar = 0.6																// the scalar for walking backwards
AssaultClass.icon					= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
AssaultClass.picture				= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen
AssaultClass.initialUpgrades		= { "ResupplyUpgrade",
										"AxeUpgrade",
										"WelderUpgrade",
										"RifleUpgrade", }																// the upgrades that you start the game with
AssaultClass.disallowedUpgrades		= { "SpeedUpgrade", 												// the upgrades that you are not allowed to buy
										"BuilderUpgrade",
										"DropMedpackUpgrade", }

function AssaultClass:Initialize()
	self.type = AssaultClass.type
	self.name = AssaultClass.name
	self.description = AssaultClass.description
	self.baseHealth = AssaultClass.baseHealth
	self.baseArmor = AssaultClass.baseArmor
	self.baseWalkSpeed = AssaultClass.baseWalkSpeed
	self.baseRunSpeed = AssaultClass.baseRunSpeed
	self.baseDropCount = AssaultClass.baseDropCount
	self.maxBackwardSpeedScalar = AssaultClass.maxBackwardSpeedScalar
	self.icon = AssaultClass.icon
	self.picture = AssaultClass.picture
	self.initialUpgrades = AssaultClass.initialUpgrades
	self.disallowedUpgrades = AssaultClass.disallowedUpgrades
end

// Build the actual tech tree
function AssaultClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function AssaultClass:OnApplyClass(player)
end

