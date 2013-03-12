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

SupportClass.type 			= "Support"						     								// the type of the FactionsClass
SupportClass.name 			= "Support"     													// the friendly name of the FactionsClass
SupportClass.description 	= "Heals and welds and builds"										// the description of the FactionsClass
SupportClass.baseHealth 	= kMarineHealth											     		// the base health value of this class
SupportClass.baseArmor 		= kMarineArmor											     		// the base armor value of this class
SupportClass.baseWalkSpeed 	= 4.0                												// the initial walk speed of this class
SupportClass.baseRunSpeed 	= 7.0                												// the initial run speed of this class
SupportClass.icon			= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
SupportClass.picture		= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen

// Build the actual tech tree
function SupportClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function SupportClass:OnApplyClass(player)
end

