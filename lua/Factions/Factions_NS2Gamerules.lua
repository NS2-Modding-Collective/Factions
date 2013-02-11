//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NS2Gamerules.lua

local networkVars = {
}

// There are also options you can pass to be able to access the return value and have multiple return arguments,
// but as they slow down the hooks mechanism slightly you have to set that up specifically
function NS2Gamerules:OnCreate()

	// Work out what entity we need to use as the gamerules.
	Server.CreateEntity(CombatDeathmatchGamerules.kMapName)
	
	// Commit harikari.
	DestroyEntity(self)
	
end

local overrideOnDestroy = NS2Gamerules.OnDestroy
function NS2Gamerules:OnDestroy()

	// Don't call the regular OnDestroy if we're destroying a NS2Gamerules.
	// Inheriting classes we do want to get destroyed.
	if not self:isa("NS2Gamerules") then
		overrideOnDestroy(self)
	end

end

Class_Reload("NS2Gamerules", networkVars)