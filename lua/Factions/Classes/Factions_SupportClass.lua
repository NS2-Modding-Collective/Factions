//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AssaultClass.lua

// Support Class
							
class 'SupportClass' (FactionsClass)

SupportClass.type 					= "Support"						     								// the type of the FactionsClass
SupportClass.name 					= "Support"     													// the friendly name of the FactionsClass
SupportClass.description 			= "Heals and welds and builds"										// the description of the FactionsClass
SupportClass.baseHealth 			= kMarineHealth											     		// the base health value of this class
SupportClass.baseArmor 				= kMarineArmor											     		// the base armor value of this class
SupportClass.baseWalkSpeed 			= 6.0                												// the initial walk speed of this class
SupportClass.baseRunSpeed 			= 9.0                												// the initial run speed of this class
SupportClass.icon					= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
SupportClass.picture				= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen
SupportClass.initialUpgrades		= { SMGUpgrade.name }												// the upgrades that you start the game with
SupportClass.allowedUpgrades		= { }																// the upgrades that you are allowed to buy


function SupportClass:Initialize()
	self.type = SupportClass.type
	self.name = SupportClass.name
	self.description = SupportClass.description
	self.baseHealth = SupportClass.baseHealth
	self.baseArmor = SupportClass.baseArmor
	self.baseWalkSpeed = SupportClass.baseWalkSpeed
	self.baseRunSpeed = SupportClass.baseRunSpeed
	self.icon = SupportClass.icon
	self.picture = SupportClass.picture
	self.initialUpgrades = SupportClass.initialUpgrades
	self.allowedUpgrades = SupportClass.allowedUpgrades
end

// Build the actual tech tree
function SupportClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function SupportClass:OnApplyClass(player)
end

