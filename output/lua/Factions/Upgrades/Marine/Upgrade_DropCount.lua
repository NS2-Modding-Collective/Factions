//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'DropCountUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
DropCountUpgrade.upgradeType = kFactionsUpgradeTypes.Attribute        									// the type of the upgrade
DropCountUpgrade.cost = { 250, 250, 400 }                              									// Cost of the upgrade in xp
DropCountUpgrade.upgradeName = "drops"                     												// Text code of the upgrade if using it via console
DropCountUpgrade.upgradeTitle = "Drop Count Upgrade"               										// Title of the upgrade, e.g. Submachine Gun
DropCountUpgrade.upgradeDesc = "Upgrade the number of packs you drop when dropping health/ammo"			// Description of the upgrade
DropCountUpgrade.upgradeTechId = kTechId.AmmoPack														// TechId of the upgrade, default is kTechId.Move cause its the first entry

function DropCountUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.upgradeType = DropCountUpgrade.upgradeType
	self.cost = DropCountUpgrade.cost
	self.upgradeName = DropCountUpgrade.upgradeName
	self.upgradeTitle = DropCountUpgrade.upgradeTitle
	self.upgradeDesc = DropCountUpgrade.upgradeDesc
	self.upgradeTechId = DropCountUpgrade.upgradeTechId
	
end

function DropCountUpgrade:GetClassName()
	return "DropCountUpgrade"
end

function DropCountUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "DropUpgrade") then
		return "Entity needs DropUpgrade mixin"
	else
		return ""
	end
end

function DropCountUpgrade:OnAdd(player)
	player.upgradeDropsLevel = self:GetCurrentLevel()
end

function DropCountUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Drops upgraded to level " .. self:GetCurrentLevel() .. ".")
	player:SendDirectMessage("You will drop " .. player:GetBaseDropCount() + self:GetCurrentLevel()*DropUpgradeMixin.dropBoostPerLevel .. " packs per drop")
end