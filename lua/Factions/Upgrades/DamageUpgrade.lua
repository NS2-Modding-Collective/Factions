//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'DamageUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
DamageUpgrade.cost = { 100, 200, 400, 600, 600 }                              		// Cost of the upgrade in xp
DamageUpgrade.levels = 5															// How many levels are there to this upgrade
DamageUpgrade.upgradeName = "damage"                     							// Text code of the upgrade if using it via console
DamageUpgrade.upgradeTitle = "Damage Upgrade"		               					// Title of the upgrade, e.g. Submachine Gun
DamageUpgrade.upgradeDesc = "Upgrade your damage"									// Description of the upgrade
DamageUpgrade.upgradeTechId = kTechId.Weapons1										// TechId of the upgrade, default is kTechId.Move cause its the first entry

function DamageUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = DamageUpgrade.cost
	self.levels = DamageUpgrade.levels
	self.upgradeName = DamageUpgrade.upgradeName
	self.upgradeTitle = DamageUpgrade.upgradeTitle
	self.upgradeDesc = DamageUpgrade.upgradeDesc
	self.upgradeTechId = DamageUpgrade.upgradeTechId
	
end

function DamageUpgrade:GetClassName()
	return "DamageUpgrade"
end

function DamageUpgrade:OnAdd(player)
	if HasMixin(player, "WeaponUpgrade") then
		player:UpdateDamageLevel(self:GetCurrentLevel())
		player:SendDirectMessage("Damage Upgraded to level " .. self:GetCurrentLevel() .. ".")
		local damageBoost = math.round(self:GetCurrentLevel()*WeaponUpgradeMixin.damageBoostPerLevel / WeaponUpgradeMixin.baseDamage * 100)
		player:SendDirectMessage("You will do " .. damageBoost .. "% more damage.")
	end
end