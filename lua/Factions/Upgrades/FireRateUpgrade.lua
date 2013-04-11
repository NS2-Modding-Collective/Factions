//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'FireRateUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
FireRateUpgrade.cost = { 100, 200, 400, 600, 600 }                              	// Cost of the upgrade in xp
FireRateUpgrade.levels = 5															// How many levels are there to this upgrade
FireRateUpgrade.upgradeName = "firerate"                     						// Text code of the upgrade if using it via console
FireRateUpgrade.upgradeTitle = "Fire Rate Upgrade"		               				// Title of the upgrade, e.g. Submachine Gun
FireRateUpgrade.upgradeDesc = "Upgrade your fire rate"								// Description of the upgrade
FireRateUpgrade.upgradeTechId = kTechId.Weapons1									// TechId of the upgrade, default is kTechId.Move cause its the first entry

function FireRateUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.hideUpgrade = true
	self.cost = FireRateUpgrade.cost
	self.levels = FireRateUpgrade.levels
	self.upgradeName = FireRateUpgrade.upgradeName
	self.upgradeTitle = FireRateUpgrade.upgradeTitle
	self.upgradeDesc = FireRateUpgrade.upgradeDesc
	self.upgradeTechId = FireRateUpgrade.upgradeTechId
	
end

function FireRateUpgrade:GetClassName()
	return "FireRateUpgrade"
end

function FireRateUpgrade:OnAdd(player)
	if HasMixin(player, "WeaponUpgrade") then
		player:UpdateFireRateLevel(self:GetCurrentLevel())
		player:SendDirectMessage("Fire Rate upgraded to level " .. self:GetCurrentLevel() .. ".")
		local fireRateBoost = math.round(self:GetCurrentLevel()*WeaponUpgradeMixin.fireRateBoostPerLevel / WeaponUpgradeMixin.baseFireRate * 100)
		player:SendDirectMessage("You will do " .. fireRateBoost .. "% more damage.")
	end
end