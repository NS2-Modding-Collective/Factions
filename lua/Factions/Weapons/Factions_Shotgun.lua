//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Shotgun.lua

local networkVars = {
}

function Shotgun:GetNumStartClips()
	return 7
end

Class_Reload("Shotgun", networkVars)