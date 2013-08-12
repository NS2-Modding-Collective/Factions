//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ReloadSpeedUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
ReloadSpeedUpgrade.cost = { 200, 400, 600, 600, 600 }                              			// Cost of the upgrade in xp
ReloadSpeedUpgrade.upgradeName = "reloadspeed"                     							// Text code of the upgrade if using it via console
ReloadSpeedUpgrade.upgradeTitle = "Reload Speed Upgrade"               						// Title of the upgrade, e.g. Submachine Gun
ReloadSpeedUpgrade.upgradeDesc = "Upgrade your reload speed"								// Description of the upgrade
ReloadSpeedUpgrade.upgradeTechId = kTechId.Speed1											// TechId of the upgrade, default is kTechId.Move cause its the first entry
ReloadSpeedUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam							// Team Type
ReloadSpeedUpgrade.uniqueSlot = kUpgradeUniqueSlot.LessReloads								// Unique slot
ReloadSpeedUpgrade.mutuallyExclusive = true													// Cannot buy another upgrade in this slot when you have this one.

function ReloadSpeedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ReloadSpeedUpgrade.cost
	self.upgradeName = ReloadSpeedUpgrade.upgradeName
	self.upgradeTitle = ReloadSpeedUpgrade.upgradeTitle
	self.upgradeDesc = ReloadSpeedUpgrade.upgradeDesc
	self.upgradeTechId = ReloadSpeedUpgrade.upgradeTechId
	self.teamType = ReloadSpeedUpgrade.teamType
	self.uniqueSlot = ReloadSpeedUpgrade.uniqueSlot
	self.mutuallyExclusive = ReloadSpeedUpgrade.mutuallyExclusive
	
end

function ReloadSpeedUpgrade:GetClassName()
	return "ReloadSpeedUpgrade"
end

function ReloadSpeedUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") then
		return "Entity needs WeaponUpgrade mixin"
	else
		return ""
	end
end

function ReloadSpeedUpgrade:OnAdd(player)
	player:UpdateReloadSpeedLevel(self:GetCurrentLevel())
end

function ReloadSpeedUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Reload Speed Upgraded to level " .. self:GetCurrentLevel() .. ".")
	local reloadSpeedBoost = math.round(self:GetCurrentLevel()*ReloadSpeedMixin.reloadSpeedBoostPerLevel / ReloadSpeedMixin.baseReloadSpeed * 100)
	player:SendDirectMessage("You will reload " .. reloadSpeedBoost .. "% faster")
end