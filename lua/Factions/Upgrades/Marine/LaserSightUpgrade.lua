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
LaserSightUpgrade.levels = 5																// How many levels are there to this upgrade
LaserSightUpgrade.upgradeName = "reloadspeed"                     							// Text code of the upgrade if using it via console
LaserSightUpgrade.upgradeTitle = "Reload Speed Upgrade"               						// Title of the upgrade, e.g. Submachine Gun
LaserSightUpgrade.upgradeDesc = "Upgrade your reload speed"								// Description of the upgrade
LaserSightUpgrade.upgradeTechId = kTechId.Speed1											// TechId of the upgrade, default is kTechId.Move cause its the first entry
LaserSightUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam

function LaserSightUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = LaserSightUpgrade.cost
	self.levels = LaserSightUpgrade.levels
	self.upgradeName = LaserSightUpgrade.upgradeName
	self.upgradeTitle = LaserSightUpgrade.upgradeTitle
	self.upgradeDesc = LaserSightUpgrade.upgradeDesc
	self.upgradeTechId = LaserSightUpgrade.upgradeTechId
	
end

function ReloadSpeedUpgrade:GetClassName()
	return "LaserSightUpgrade"
end

function ReloadSpeedUpgrade:OnAdd(player)
	if HasMixin(player, "WeaponUpgrade") then
		player:UpdateLaserSightLevel(self:GetCurrentLevel())
		player:SendDirectMessage("Laser Sight Upgraded to level " .. self:GetCurrentLevel() .. ".")
		local accuracyBoost = math.round(self:GetCurrentLevel()*LaserSightMixin.accuracyBoostPerLevel / LaserSightMixin.baseAccuracy * 100)
		player:SendDirectMessage("Your weapon spread is reduced by " .. accuracyBoost .. "%")
	end
end