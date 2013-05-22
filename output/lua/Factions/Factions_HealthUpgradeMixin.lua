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
HealthUpgrade.botHealthBoostPerLevel = 0.05

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
	upgradeHealthLevel = "integer (0 to " .. #HealthUpgrade.cost .. ")",
	originalMaxHealth = string.format("float (0 to %f by 1)", LiveMixin.kMaxHealth),
}

function HealthUpgradeMixin:__initmixin()

	if Server then
		self.upgradeHealthLevel = 0
	end

end

function HealthUpgradeMixin:CopyPlayerDataFrom(player)

	if Server then
		self.upgradeHealthLevel = player.upgradeHealthLevel
	end

end

function HealthUpgradeMixin:OnInitialized()
	if Server then
		self.originalMaxHealth = self:GetMaxHealth()
		self:UpgradeHealth()
	end
end

function HealthUpgradeMixin:GetOriginalMaxHealth()
	return self.originalMaxHealth
end

function HealthUpgradeMixin:UpgradeHealth()

	if Server then
		// Calculate the new max health
		local oldMaxHealth = self:GetMaxHealth()
		local baseMaxHealth = self:GetBaseHealth()
		local healthboost = HealthUpgrade.healthBoostPerLevel
		if HasMixin(self, "Npc") then
			HealthUpgrade.botHealthBoostPerLevel
		end
		local newMaxHealth = baseMaxHealth + baseMaxHealth*self.upgradeHealthLevel*healthboost
		self:SetMaxHealth(newMaxHealth)
		
		// Add the difference to the player's current health
		local healthDifference = self:GetMaxHealth() - oldMaxHealth
		local currentHealth = self:GetHealth()
		self:SetHealth(currentHealth + healthDifference)
	end
	
end