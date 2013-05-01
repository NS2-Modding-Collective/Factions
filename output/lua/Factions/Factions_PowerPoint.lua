//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_PowerPoint.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

// Do this on a delay so GetIsBuilt is ready.
local function SwitchOffNodes(self)

	// Start socketed but unbuilt
	// TODO: allow the mapper to define the default power mode!
	if not self:GetIsBuilt() then
		self.lightMode = kLightMode.NoPower
		self.powerState = PowerPoint.kPowerState.socketed
	end
	
	return false

end

// Team Colours
local overrideOnInitialized = PowerPoint.OnInitialized
function PowerPoint:OnInitialized()

	overrideOnInitialized(self)
	
	if GetGamerulesInfo():GetLightsStartOff() then
		self:AddTimedCallback(SwitchOffNodes, 0.2)
	end

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end

end

local overrideReset = PowerPoint.Reset
function PowerPoint:Reset()
	
	overrideReset(self)
	
	if GetGamerulesInfo():GetLightsStartOff() then
		self:AddTimedCallback(SwitchOffNodes, 0.2)
	end
	
end

function PowerPoint:PowerPointGetCanTakeDamageOverride(self)
    return false
end

Class_Reload("PowerPoint", networkVars)