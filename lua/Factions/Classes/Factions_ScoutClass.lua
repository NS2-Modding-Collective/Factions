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

ScoutClass.type 			= "Scout"						     								// the type of the FactionsClass
ScoutClass.name 			= "Scout"     														// the friendly name of the FactionsClass
ScoutClass.description 		= "Attacks faster and can cloak"						     		// the description of the FactionsClass
ScoutClass.baseHealth 		= kMarineHealth	- 20									     		// the base health value of this class
ScoutClass.baseArmor 		= kMarineArmor - 20										     		// the base armor value of this class
ScoutClass.baseWalkSpeed 	= 7.0                												// the initial walk speed of this class
ScoutClass.baseRunSpeed 	= 9.0             													// the initial run speed of this class
ScoutClass.icon				= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
ScoutClass.picture			= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen

// Build the actual tech tree
function ScoutClass:BuildTechTree()
end

// Special actions to perform when the class is selected.
function ScoutClass:OnApplyClass(player)
end

