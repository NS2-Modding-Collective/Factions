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
	upgradeArmorLevel = "integer (0 to " .. ArmorUpgrade.levels .. ")",
	originalMaxArmor = string.format("float (0 to %f by 1)", LiveMixin.kMaxArmor),
}

function ArmorUpgradeMixin:__initmixin()

	if Server then
		self.upgradeArmorLevel = 0
	end

end

function ArmorUpgradeMixin:CopyPlayerDataFrom(player)

	if Server then
		self.upgradeArmorLevel = player.upgradeArmorLevel
	end

end

function ArmorUpgradeMixin:OnInitialized()
	if Server then
		self.originalMaxArmor = self:GetMaxArmor()
		self:UpgradeArmor()
	end
end

function ArmorUpgradeMixin:GetOriginalMaxArmor()
	return self.originalMaxArmor
end

function ArmorUpgradeMixin:UpgradeArmor()
	
	if Server then
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
	
end