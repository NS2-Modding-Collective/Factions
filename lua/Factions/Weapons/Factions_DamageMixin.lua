//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_DamageMixin.lua

Script.Load("lua/FunctionContracts.lua")

DamageMixin = CreateMixin( DamageMixin )
DamageMixin.type = "VariableDamage"

DamageMixin.expectedMixins =
{
}

DamageMixin.expectedCallbacks =
{
}

DamageMixin.overrideFunctions =
{
}

DamageMixin.expectedConstants =
{
}

DamageMixin.networkVars =
{
	damageScalar = "decimal",
}

function DamageMixin:__initmixin()

    self.damageScalar = 1.0
    
end

function DamageMixin:UpdateDamageLevel(newDamage)

	self.damageScalar = newDamage

end