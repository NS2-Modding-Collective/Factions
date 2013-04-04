//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ReloadSpeedMixin.lua

Script.Load("lua/FunctionContracts.lua")

ReloadSpeedMixin = CreateMixin( ReloadSpeedMixin )
ReloadSpeedMixin.type = "VariableReloadSpeed"

ReloadSpeedMixin.expectedMixins =
{
}

ReloadSpeedMixin.expectedCallbacks =
{
}

ReloadSpeedMixin.overrideFunctions =
{
}

ReloadSpeedMixin.expectedConstants =
{
}

ReloadSpeedMixin.networkVars =
{
	reloadSpeedScalar = "decimal",
}

function ReloadSpeedMixin:__initmixin()

    self.reloadSpeedScalar = 1.0
    
end

function ReloadSpeedMixin:UpdateReloadSpeed(newSpeed)

	self.reloadSpeedScalar = newSpeed

end