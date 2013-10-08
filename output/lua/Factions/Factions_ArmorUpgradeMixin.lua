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

ArmorUpgrade.armorBoostPerLevel = 0.07
ArmorUpgrade.botArmorBoostPerLevel = 0.10

ArmorUpgradeMixin.expectedMixins =
{
	Live = "For setting the armor values",
	FactionsClass = "For getting the base armor and armor values",
}

ArmorUpgradeMixin.expectedCallbacks =
{
}

ArmorUpgradeMixin.expectedConstants =
{
}

ArmorUpgradeMixin.networkVars =
{
	upgradeArmorLevel = "integer (0 to " .. #ArmorUpgrade.cost .. ")",
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
		local armorBoost = ArmorUpgrade.armorBoostPerLevel
		if HasMixin(self, "Npc") then
			armorBoost = ArmorUpgrade.botArmorBoostPerLevel
		end
		local newMaxArmor = baseMaxArmor + baseMaxArmor*math.max(0, self.upgradeArmorLevel - 1)*armorBoost
		self:SetMaxArmor(newMaxArmor)
		
		// Add the difference to the player's current armor
		local armorDifference = self:GetMaxArmor() - oldMaxArmor
		local currentArmor = self:GetArmor()
		self:SetArmor(currentArmor + armorDifference)
	end
	
end