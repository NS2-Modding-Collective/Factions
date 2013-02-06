//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Pistol.lua

local networkVars = {
}

function Pistol:GetNumStartClips()
	return 6
end

function Pistol:GetClipSize()
	return kPistolClipSize
end

Class_Reload("Pistol", networkVars)