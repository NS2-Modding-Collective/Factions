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
FireRateUpgrade.upgradeName = "firerate"                     						// Text code of the upgrade if using it via console
FireRateUpgrade.upgradeTitle = "Fire Rate Upgrade"		               				// Title of the upgrade, e.g. Submachine Gun
FireRateUpgrade.upgradeDesc = "Upgrade your fire rate"								// Description of the upgrade
FireRateUpgrade.upgradeTechId = kTechId.Weapons1									// TechId of the upgrade, default is kTechId.Move cause its the first entry

function FireRateUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.hideUpgrade = true
	self.cost = FireRateUpgrade.cost
	self.upgradeName = FireRateUpgrade.upgradeName
	self.upgradeTitle = FireRateUpgrade.upgradeTitle
	self.upgradeDesc = FireRateUpgrade.upgradeDesc
	self.upgradeTechId = FireRateUpgrade.upgradeTechId
	
end

function FireRateUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") then
		return "Entity needs WeaponUpgrade mixin"
	else
		return ""
	end
end

function FireRateUpgrade:OnAdd(player)
	player:UpdateFireRateLevel(self:GetCurrentLevel())
end

function FireRateUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Fire Rate upgraded to level " .. self:GetCurrentLevel() .. ".")
	local fireRateBoost = math.round(self:GetCurrentLevel()*FireRateMixin.fireRateBoostPerLevel / FireRateMixin.baseFireRate * 100)
	player:SendDirectMessage("You will fire " .. fireRateBoost .. "% faster.")
end