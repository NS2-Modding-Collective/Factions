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

FactionsClass.type 			= "Assault"						     								// the type of the FactionsClass
FactionsClass.name 			= "Assault"     													// the friendly name of the FactionsClass
FactionsClass.description 	= "A regular dude"										     		// the description of the FactionsClass
FactionsClass.baseHealth 	= kMarineHealth											     		// the base health value of this class
FactionsClass.baseArmor 	= kMarineArmor											     		// the base armor value of this class
FactionsClass.baseWalkSpeed = 5.0                												// the initial walk speed of this class
FactionsClass.baseRunSpeed 	= 9.0                												// the initial run speed of this class
FactionsClass.icon			= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
FactionsClass.picture		= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen

// Build the actual tech tree
function FactionsClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function FactionsClass:OnApplyClass(player)
end

