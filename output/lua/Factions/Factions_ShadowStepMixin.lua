//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ShadowStepMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

ShadowStepMixin = CreateMixin( ShadowStepMixin )
ShadowStepMixin.type = "ShadowStepMixin"

ShadowStepMixin.expectedMixins =
{
}

ShadowStepMixin.expectedCallbacks =
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