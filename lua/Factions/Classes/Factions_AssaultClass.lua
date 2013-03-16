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
AssaultClass.baseHealth 			= kMarineHealth											     		// the base health value of this class
AssaultClass.baseArmor 				= kMarineArmor											     		// the base armor value of this class
AssaultClass.baseWalkSpeed 			= 5.0                												// the initial walk speed of this class
AssaultClass.baseRunSpeed 			= 7.0                												// the initial run speed of this class
AssaultClass.baseAcceleration		= 100																// the initial walk acceleration of this class
AssaultClass.baseSprintAcceleration = 170																// the initial sprint acceleration of this class
AssaultClass.icon					= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
AssaultClass.picture				= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen

// Build the actual tech tree
function AssaultClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function AssaultClass:OnApplyClass(player)
end

