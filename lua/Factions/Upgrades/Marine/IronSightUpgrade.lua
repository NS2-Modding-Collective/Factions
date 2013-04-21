//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'IronSightUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
IronSightUpgrade.cost = { 250 }                              						// Cost of the upgrade in xp
IronSightUpgrade.upgradeName = "ironsight"                     						// Text code of the upgrade if using it via console
IronSightUpgrade.upgradeTitle = "iron sight"			               				// Title of the upgrade, e.g. Submachine Gun
IronSightUpgrade.upgradeDesc = "Improves the accuracy of your weapon"				// Description of the upgrade
IronSightUpgrade.upgradeTechId = kTechId.IronSight									// TechId of the upgrade, default is kTechId.Move cause its the first entry
IronSightUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam

function IronSightUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.hideUpgrade = true
	self.cost = IronSightUpgrade.cost
	self.upgradeName = IronSightUpgrade.upgradeName
	self.upgradeTitle = IronSightUpgrade.upgradeTitle
	self.upgradeDesc = IronSightUpgrade.upgradeDesc
	self.upgradeTechId = IronSightUpgrade.upgradeTechId
	self.teamType = IronSightUpgrade.teamType
	
end

function IronSightUpgrade:GetClassName()
	return "IronSightUpgrade"
end

function IronSightUpgrade:CanApplyUpgrade(player)
	if Server then
		if not HasMixin(player, "WeaponUpgrade") then
			return "entity must implement WeaponUpgrade!"
		end
	end
	return ""
end

function IronSightUpgrade:OnAdd(player)
	player:UpdateIronSightLevel(self:GetCurrentLevel())
end

function IronSightUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Iron Sight Upgrade purchased!")
	player:SendDirectMessage("Use right mouse to zoom by " .. self:GetCurrentLevel())
end