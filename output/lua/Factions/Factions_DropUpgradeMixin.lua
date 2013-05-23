//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_DropUpgradeMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

DropUpgradeMixin = CreateMixin( DropUpgradeMixin )
DropUpgradeMixin.type = "DropUpgrade"

DropUpgradeMixin.dropBoostPerLevel = 1

DropUpgradeMixin.expectedMixins =
{
	FactionsClass = "For getting the base drop values",
}

DropUpgradeMixin.expectedCallbacks =
{
}

DropUpgradeMixin.expectedConstants =
{
}

DropUpgradeMixin.networkVars =
{
	upgradeDropsLevel = "integer (0 to " .. #DropCountUpgrade.cost .. ")",
}

function DropUpgradeMixin:__initmixin()

	if Server then
		self.upgradeDropsLevel = 0
	end

end

function DropUpgradeMixin:CopyPlayerDataFrom(player)

	if Server then
		self.upgradeDropsLevel = player.upgradeDropsLevel
	end

end

function DropUpgradeMixin:GetDropCount()

	local baseDrops = self:GetBaseDropCount()
	return baseDrops + self.upgradeDropsLevel*DropUpgradeMixin.dropBoostPerLevel

end