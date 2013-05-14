//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'DamageUpgrade' (LevelTiedUpgrade)

// Define these statically so we can easily access them without instantiating too.
DamageUpgrade.upgradeType = kFactionsUpgradeTypes.Attribute        					// the type of the upgrade
DamageUpgrade.upgradeName = "damage"                     							// Text code of the upgrade if using it via console
DamageUpgrade.upgradeTitle = "Damage Upgrade"		               					// Title of the upgrade, e.g. Submachine Gun
DamageUpgrade.upgradeDesc = "Upgrade your damage"									// Description of the upgrade
DamageUpgrade.upgradeTechId = kTechId.Weapons1										// TechId of the upgrade, default is kTechId.Move cause its the first entry

function DamageUpgrade:Initialize()

	LevelTiedUpgrade.Initialize(self)

	self.upgradeType = DamageUpgrade.upgradeType
	self.upgradeName = DamageUpgrade.upgradeName
	self.upgradeTitle = DamageUpgrade.upgradeTitle
	self.upgradeDesc = DamageUpgrade.upgradeDesc
	self.upgradeTechId = DamageUpgrade.upgradeTechId
	
end

function DamageUpgrade:GetClassName()
	return "DamageUpgrade"
end

function DamageUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") then
		return "Entity needs WeaponUpgrade mixin"
	else
		return ""
	end
end

function DamageUpgrade:OnAdd(player)
	player:UpdateDamageLevel(self:GetCurrentLevel())
end

function DamageUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Damage Upgraded to level " .. self:GetCurrentLevel() .. ".")
	local damageBoost = math.round(self:GetCurrentLevel()*WeaponUpgradeMixin.damageBoostPerLevel / WeaponUpgradeMixin.baseDamage * 100)
	player:SendDirectMessage("You will do " .. damageBoost .. "% more damage.")
end