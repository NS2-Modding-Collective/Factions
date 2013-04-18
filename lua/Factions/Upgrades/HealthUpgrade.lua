//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'HealthUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
HealthUpgrade.upgradeType 		= kFactionsUpgradeTypes.Attribute        					// the type of the upgrade
HealthUpgrade.cost				= { 100, 200, 400 }                              			// Cost of the upgrade in xp
HealthUpgrade.upgradeName 		= "health"                     								// Text code of the upgrade if using it via console
HealthUpgrade.upgradeTitle 		= "Health Upgrade"               							// Title of the upgrade, e.g. Submachine Gun
HealthUpgrade.upgradeDesc 		= "Upgrade your player's health"							// Description of the upgrade
HealthUpgrade.upgradeTechId 	= kTechId.Health1											// TechId of the upgrade, default is kTechId.Move cause its the first entry

function HealthUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.upgradeType = HealthUpgrade.upgradeType
	self.cost = HealthUpgrade.cost
	self.upgradeName = HealthUpgrade.upgradeName
	self.upgradeTitle = HealthUpgrade.upgradeTitle
	self.upgradeDesc = HealthUpgrade.upgradeDesc
	self.upgradeTechId = HealthUpgrade.upgradeTechId
	
end

function HealthUpgrade:GetClassName()
	return "HealthUpgrade"
end

function HealthUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "HealthUpgrade") then
		return "Entity needs HealthUpgrade mixin"
	else
		return ""
	end
end

function HealthUpgrade:OnAdd(player)
	player.upgradeHealthLevel = self:GetCurrentLevel()
	player:UpgradeHealth()
end

function HealthUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Health Upgraded to level " .. self:GetCurrentLevel() .. ".")
	player:SendDirectMessage("New Max Health is: " .. player:GetMaxHealth())
end