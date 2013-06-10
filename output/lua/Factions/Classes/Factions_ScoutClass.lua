//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ScoutClass.lua

// Scout Class
							
class 'ScoutClass' (FactionsClass)

ScoutClass.type 					= "Scout"						     								// the type of the FactionsClass
ScoutClass.name 					= "Scout"     														// the friendly name of the FactionsClass
ScoutClass.description				= "Attacks faster and can cloak"						     		// the description of the FactionsClass
<<<<<<< HEAD
ScoutClass.baseHealth 				= kMarineHealth								     		// the base health value of this class
ScoutClass.baseArmor 				= kMarineArmor									     		// the base armor value of this class
ScoutClass.baseWalkSpeed 			= 6.5                												// the initial walk speed of this class
ScoutClass.baseRunSpeed 			= 10.0             													// the initial run speed of this class
=======
ScoutClass.baseHealth 				= kMarineHealth	- 20									     		// the base health value of this class
ScoutClass.baseArmor 				= kMarineArmor - 20										     		// the base armor value of this class
ScoutClass.baseWalkSpeed 			= 6.7                												// the initial walk speed of this class
ScoutClass.baseRunSpeed 			= 10.5             													// the initial run speed of this class
>>>>>>> refs/remotes/origin/master
ScoutClass.baseDropCount 			= 1	                												// how many packs get dropped when you drop health/ammo
ScoutClass.maxBackwardSpeedScalar 	= 0.9																// the scalar for walking backwards
ScoutClass.icon						= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
ScoutClass.picture					= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen
ScoutClass.initialUpgrades			= { "SMGUpgrade", "KnifeUpgrade" }												// the upgrades that you start the game with
ScoutClass.disallowedUpgrades		= { "BuilderUpgrade", 												// the upgrades that you are not allowed to buy
										"UnlockGrenadeLauncherUpgrade", 
										"UnlockFlamethrowerUpgrade", }										


function ScoutClass:Initialize()
	self.type = ScoutClass.type
	self.name = ScoutClass.name
	self.description = ScoutClass.description
	self.baseHealth = ScoutClass.baseHealth
	self.baseArmor = ScoutClass.baseArmor
	self.baseWalkSpeed = ScoutClass.baseWalkSpeed
	self.baseRunSpeed = ScoutClass.baseRunSpeed
	self.baseDropCount = ScoutClass.baseDropCount
	self.maxBackwardSpeedScalar = ScoutClass.maxBackwardSpeedScalar
	self.icon = ScoutClass.icon
	self.picture = ScoutClass.picture
	self.initialUpgrades = ScoutClass.initialUpgrades
	self.disallowedUpgrades = ScoutClass.disallowedUpgrades
end

// Build the actual tech tree
function ScoutClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function ScoutClass:OnApplyClass(player)
end

