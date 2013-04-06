//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FireRateMixin.lua

Script.Load("lua/FunctionContracts.lua")

FireRateMixin = CreateMixin( FireRateMixin )
FireRateMixin.type = "VariableDamage"

FireRateMixin.expectedMixins =
{
}

FireRateMixin.expectedCallbacks =
{
}

FireRateMixin.overrideFunctions =
{
}

FireRateMixin.expectedConstants =
{
}

FireRateMixin.networkVars =
{
	fireRateScalar = "float",
}

function FireRateMixin:__initmixin()

    self.fireRateScalar = 1.0
    
end

function FireRateMixin:UpdateFireRate(newFireRate)

	self.fireRateScalar = newFireRate

end