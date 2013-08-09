//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ClipSizeUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
ClipSizeUpgrade.cost = { 200, 400, 600, 600, 600 }                              		// Cost of the upgrade in xp
ClipSizeUpgrade.upgradeName = "clipsize"                     							// Text code of the upgrade if using it via console
ClipSizeUpgrade.upgradeTitle = "Clip Size Upgrade"               						// Title of the upgrade, e.g. Submachine Gun
ClipSizeUpgrade.upgradeDesc = "Upgrade your clip size"									// Description of the upgrade
ClipSizeUpgrade.upgradeTechId = kTechId.Speed1											// TechId of the upgrade, default is kTechId.Move cause its the first entry
ClipSizeUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam							// Team Type
ClipSizeUpgrade.uniqueSlot = kUpgradeUniqueSlot.LessReloads								// Unique slot
ClipSizeUpgrade.mutuallyExclusive = true												// Cannot buy another upgrade in this slot when you have this one.

function ClipSizeUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ClipSizeUpgrade.cost
	self.upgradeName = ClipSizeUpgrade.upgradeName
	self.upgradeTitle = ClipSizeUpgrade.upgradeTitle
	self.upgradeDesc = ClipSizeUpgrade.upgradeDesc
	self.upgradeTechId = ClipSizeUpgrade.upgradeTechId
	self.teamType = ClipSizeUpgrade.teamType
	self.uniqueSlot = ClipSizeUpgrade.uniqueSlot
	self.mutuallyExclusive = ClipSizeUpgrade.mutuallyExclusive
	
end

function ClipSizeUpgrade:GetClassName()
	return "ClipSizeUpgrade"
end

function ClipSizeUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") then
		return "Entity needs WeaponUpgrade mixin"
	else
		return ""
	end
end

function ClipSizeUpgrade:OnAdd(player)
	player:UpdateClipSizeLevel(self:GetCurrentLevel())
end

function ClipSizeUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Clip Size Upgraded to level " .. self:GetCurrentLevel() .. ".")
end