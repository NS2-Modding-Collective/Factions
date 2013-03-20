//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ArmorUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
ArmorUpgrade.cost = { 100, 200, 400 }                              					// Cost of the upgrade in xp
ArmorUpgrade.levels = 3																// How many levels are there to this upgrade
ArmorUpgrade.upgradeName = "armor"                     								// Text code of the upgrade if using it via console
ArmorUpgrade.upgradeTitle = "Armor Upgrade"               							// Title of the upgrade, e.g. Submachine Gun
ArmorUpgrade.upgradeDesc = "Upgrade your player's armor"							// Description of the upgrade
ArmorUpgrade.upgradeTechId = { kTechId.Armor1, kTechId.Armor2, kTechId.Armor3 }		// TechId of the upgrade, default is kTechId.Move cause its the first entry

function ArmorUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ArmorUpgrade.cost
	self.levels = ArmorUpgrade.levels
	self.upgradeName = ArmorUpgrade.upgradeName
	self.upgradeTitle = ArmorUpgrade.upgradeTitle
	self.upgradeDesc = ArmorUpgrade.upgradeDesc
	self.upgradeTechId = ArmorUpgrade.upgradeTechId
	
end

function ArmorUpgrade:GetClassName()
	return "ArmorUpgrade"
end

function ArmorUpgrade:OnAdd(player)
	if HasMixin(player, "ArmorUpgrade") then
		player.upgradeArmorLevel = self:GetCurrentLevel()
		player:UpgradeArmor()
		player:SendDirectMessage("Armor Upgraded to level " .. self:GetCurrentLevel() .. ".")
	end
end