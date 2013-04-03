//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ArmorUpgradeMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

ArmorUpgradeMixin = CreateMixin( ArmorUpgradeMixin )
ArmorUpgradeMixin.type = "ArmorUpgrade"

ArmorUpgrade.armorBoostPerLevel = 0.2

ArmorUpgradeMixin.expectedMixins =
{
	Live = "For setting the armor values",
	FactionsClass = "For getting the base health and armor values",
}

ArmorUpgradeMixin.expectedCallbacks =
{
}

ArmorUpgradeMixin.expectedConstants =
{
}

ArmorUpgradeMixin.networkVars =
{
	upgradeArmorLevel = "integer (0 to " .. ArmorUpgrade.levels .. ")"
}

function ArmorUpgradeMixin:__initmixin()

	self.upgradeArmorLevel = 0
	self:UpgradeArmor()

end

function ArmorUpgradeMixin:CopyPlayerDataFrom(player)

	self.upgradeArmorLevel = player.upgradeArmorLevel
	self:UpgradeArmor()

end

function ArmorUpgradeMixin:UpgradeArmor()
	
	// Calculate the new max armor
	local oldMaxArmor = self:GetMaxArmor()
	local baseMaxArmor = self:GetBaseArmor()
	local newMaxArmor = baseMaxArmor + baseMaxArmor*self.upgradeArmorLevel*ArmorUpgrade.armorBoostPerLevel
	self:SetMaxArmor(newMaxArmor)
	
	// Add the difference to the player's current armor
	local armorDifference = self:GetMaxArmor() - oldMaxArmor
	local currentArmor = self:GetArmor()
	self:SetArmor(currentArmor + armorDifference)
	
end