//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'LaserSightUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
LaserSightUpgrade.cost = { 100, 200, 400, 600, 600 }                              		// Cost of the upgrade in xp
LaserSightUpgrade.upgradeName = "lasersight"                     						// Text code of the upgrade if using it via console
LaserSightUpgrade.upgradeTitle = "Laser Sight"			               					// Title of the upgrade, e.g. Submachine Gun
LaserSightUpgrade.upgradeDesc = "Improves the accuracy of your weapon"					// Description of the upgrade
LaserSightUpgrade.upgradeTechId = kTechId.LaserSight									// TechId of the upgrade, default is kTechId.Move cause its the first entry
LaserSightUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam

function LaserSightUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.hideUpgrade = true
	self.cost = LaserSightUpgrade.cost
	self.upgradeName = LaserSightUpgrade.upgradeName
	self.upgradeTitle = LaserSightUpgrade.upgradeTitle
	self.upgradeDesc = LaserSightUpgrade.upgradeDesc
	self.upgradeTechId = LaserSightUpgrade.upgradeTechId
	self.teamType = LaserSightUpgrade.teamType
	
end

function LaserSightUpgrade:GetClassName()
	return "LaserSightUpgrade"
end

function LaserSightUpgrade:OnAdd(player)
	if HasMixin(player, "WeaponUpgrade") then
		player:UpdateLaserSightLevel(self:GetCurrentLevel())
		player:SendDirectMessage("Laser Sight Upgraded to level " .. self:GetCurrentLevel() .. ".")
		local accuracyBoost = math.round(self:GetCurrentLevel()*LaserSightMixin.accuracyBoostPerLevel / LaserSightMixin.baseAccuracy * 100)
		player:SendDirectMessage("Your weapon spread is reduced by " .. accuracyBoost .. "%")
	end
end