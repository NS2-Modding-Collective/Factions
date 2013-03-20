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
ScoutClass.baseHealth 				= kMarineHealth	- 20									     		// the base health value of this class
ScoutClass.baseArmor 				= kMarineArmor - 20										     		// the base armor value of this class
ScoutClass.baseWalkSpeed 			= 6.5                												// the initial walk speed of this class
ScoutClass.baseRunSpeed 			= 10.0             													// the initial run speed of this class
ScoutClass.icon						= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
ScoutClass.picture					= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen
ScoutClass.initialUpgrades			= { }																// the upgrades that you start the game with
ScoutClass.allowedUpgrades			= { }																// the upgrades that you are allowed to buy

function ScoutClass:Initialize()
	self.type = ScoutClass.type
	self.name = ScoutClass.name
	self.description = ScoutClass.description
	self.baseHealth = ScoutClass.baseHealth
	self.baseArmor = ScoutClass.baseArmor
	self.baseWalkSpeed = ScoutClass.baseWalkSpeed
	self.baseRunSpeed = ScoutClass.baseRunSpeed
	self.icon = ScoutClass.icon
	self.picture = ScoutClass.picture
	self.initialUpgrades = ScoutClass.initialUpgrades
	self.allowedUpgrades = ScoutClass.allowedUpgrades
end

// Build the actual tech tree
function ScoutClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function ScoutClass:OnApplyClass(player)
end

