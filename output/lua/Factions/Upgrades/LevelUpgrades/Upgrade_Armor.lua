//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ArmorUpgrade' (LevelTiedUpgrade)

// Define these statically so we can easily access them without instantiating too.
ArmorUpgrade.upgradeType 		= kFactionsUpgradeTypes.Attribute        				// the type of the upgrade
ArmorUpgrade.upgradeName 		= "armor"                     							// Text code of the upgrade if using it via console
ArmorUpgrade.upgradeTitle 		= "Armor Upgrade"               						// Title of the upgrade, e.g. Submachine Gun
ArmorUpgrade.upgradeDesc 		= "Upgrade your player's armor"							// Description of the upgrade
ArmorUpgrade.upgradeTechId		= kTechId.Armor1										// TechId of the upgrade, default is kTechId.Move cause its the first entry

function ArmorUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.upgradeType = ArmorUpgrade.upgradeType
	self.upgradeName = ArmorUpgrade.upgradeName
	self.upgradeTitle = ArmorUpgrade.upgradeTitle
	self.upgradeDesc = ArmorUpgrade.upgradeDesc
	self.upgradeTechId = ArmorUpgrade.upgradeTechId
	
end

function ArmorUpgrade:GetClassName()
	return "ArmorUpgrade"
end

function ArmorUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "ArmorUpgrade") then
		return "Entity needs ArmorUpgrade mixin"
	else
		return ""
	end
end

function ArmorUpgrade:OnAdd(player)
	player.upgradeArmorLevel = self:GetCurrentLevel()
	player:UpgradeArmor()
end

function ArmorUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Armor Upgraded to level " .. self:GetCurrentLevel() .. ".")
	player:SendDirectMessage("New Max Armor is: " .. player:GetMaxArmor())
end