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
	
	// Create the gamerules info straight away.
	local gamerulesInfo = Server.CreateEntity(FactionsGamerulesInfo.kMapName)
	
	local gamerulesPicker = GetGamerulesPicker()
	// Work out what entity we need to use as the gamerules.
	local newGamerules = Server.CreateEntity(gamerulesPicker:GetGamerulesMapName())
	
	// Switch the lights off if the gamerulespicker has defined this.
	if newGamerules:isa("GenericGamerules") then
		if gamerulesPicker:GetPowerNodesStartDestroyed() then
			gamerulesInfo:SetLightsStartOff(true)
		end
	end
	
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