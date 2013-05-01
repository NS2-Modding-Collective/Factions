//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NS2Gamerules.lua

Script.Load("lua/Factions/Factions_GamerulesPicker.lua")

local networkVars = {
}

// Link to the original function here so we can use it in GenericGamerules.
originalNS2GamerulesOnCreate = NS2Gamerules.OnCreate
function NS2Gamerules:OnCreate()

	if not GetHasGamerulesPicker() then
		Server.CreateEntity(GamerulesPicker.kMapName)
	end
	
	local gamerulesPicker = GetGamerulesPicker()
	// Work out what entity we need to use as the gamerules.
	Server.CreateEntity(gamerulesPicker:GetGamerulesMapName())
	
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