//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TechTreeConstants.lua

local function addTechId(techIdName)
	
	// We have to reconstruct the kTechId enum to add values.
	local enumTable = {}
	for index, value in ipairs(kTechId) do
		table.insert(enumTable, value)
	end
	
	table.remove(enumTable, #enumTable)
	table.insert(enumTable, techIdName)
	table.insert(enumTable, 'Max')
	
	kTechId = enum(enumTable)
	kTechIdMax = kTechId.Max
	
end

addTechId("LightMachineGun")
addTechId("LayLaserMines")
addTechId("MarineStructureAbility")
addTechId("MiniArmory")
addTechId("Speed1")
addTechId("Health1")
addTechId("Resupply")
addTechId("LaserSight")
addTechId("LaserMine")
addTechId("IronSight")
addTechId("Knife")