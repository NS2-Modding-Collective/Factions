//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'MagnoBootsUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
MagnoBootsUpgrade.upgradeType = kFactionsUpgradeTypes.Ability		       				// The type of the upgrade
MagnoBootsUpgrade.cost = { 500 }                              							// Cost of the upgrade in xp
MagnoBootsUpgrade.upgradeName = "magnoboots"                     						// Text code of the upgrade if using it via console
MagnoBootsUpgrade.upgradeTitle = "Magno Boots"               							// Title of the upgrade, e.g. Submachine Gun
MagnoBootsUpgrade.upgradeDesc = "Allows you to walk on walls"							// Description of the upgrade
MagnoBootsUpgrade.upgradeTechId = kTechId.Speed1										// TechId of the upgrade, default is kTechId.Move cause its the first entry
MagnoBootsUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam						// Team Type

function MagnoBootsUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.upgradeType = MagnoBootsUpgrade.upgradeType
	self.cost = MagnoBootsUpgrade.cost
	self.upgradeName = MagnoBootsUpgrade.upgradeName
	self.upgradeTitle = MagnoBootsUpgrade.upgradeTitle
	self.upgradeDesc = MagnoBootsUpgrade.upgradeDesc
	self.upgradeTechId = MagnoBootsUpgrade.upgradeTechId
	
end

function MagnoBootsUpgrade:GetClassName()
	return "MagnoBootsUpgrade"
end

function MagnoBootsUpgrade:OnAdd(player)
	if HasMixin(player, "MagnoBootsWearer") then
		player:GiveMagnoBoots()
		player:SendDirectMessage("Magno Boots Enabled!")
	end
end