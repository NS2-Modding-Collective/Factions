//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_HealthUpgradeMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

HealthUpgradeMixin = CreateMixin( HealthUpgradeMixin )
HealthUpgradeMixin.type = "HealthUpgrade"

HealthUpgrade.healthBoostPerLevel = 0.1

HealthUpgradeMixin.expectedMixins =
{
	Live = "For setting the health values",
	FactionsClass = "For getting the base health and armor values",
}

HealthUpgradeMixin.expectedCallbacks =
{
}

HealthUpgradeMixin.expectedConstants =
{
}

HealthUpgradeMixin.networkVars =
{
	upgradeHealthLevel = "integer (0 to " .. HealthUpgrade.levels .. ")"
}

function HealthUpgradeMixin:__initmixin()

	self.upgradeHealthLevel = 0

end

function HealthUpgradeMixin:CopyPlayerDataFrom(player)

	self.upgradeHealthLevel = player.upgradeHealthLevel

end

function HealthUpgradeMixin:UpgradeHealth()
	local baseMaxHealth = self:GetBaseHealth()
	local newMaxHealth = baseMaxHealth + baseMaxHealth*self.upgradeHealthLevel*HealthUpgrade.healthBoostPerLevel
	
	self:SetMaxHealth(newMaxHealth)
end