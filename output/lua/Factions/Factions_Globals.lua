//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Globals.lua

local function AddMinimapBlipType(blipType)
	
	// We have to reconstruct the kTechId enum to add values.
	local enumTable = {}
	for index, value in ipairs(kMinimapBlipType) do
		table.insert(enumTable, value)
	end
	
	table.insert(enumTable, blipType)
	
	kMinimapBlipType = enum(enumTable)
	
end

AddMinimapBlipType("InjuredPlayer")

// HUD Slots
kAxeHUDSlot = 3
kWelderHUDSlot = 4
kMinesHUDSlot = 4
kBuilderHUDSlot = 5

// Version number
kFactionsVersion = "12"