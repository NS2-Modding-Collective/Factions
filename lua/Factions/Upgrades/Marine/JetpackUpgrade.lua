//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'JetpackUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
JetpackUpgrade.upgradeType = kFactionsUpgradeTypes.Class	       					// The type of the upgrade
JetpackUpgrade.cost = { 800 }                              							// Cost of the upgrade in xp
JetpackUpgrade.upgradeName = "jetpack"                     							// Text code of the upgrade if using it via console
JetpackUpgrade.upgradeTitle = "Jetpack"               								// Title of the upgrade, e.g. Submachine Gun
JetpackUpgrade.upgradeDesc = "Allows you to fly like an eagle"						// Description of the upgrade
JetpackUpgrade.upgradeTechId = kTechId.Jetpack										// TechId of the upgrade, default is kTechId.Move cause its the first entry
JetpackUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam						// Team Type

function JetpackUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.upgradeType = JetpackUpgrade.upgradeType
	self.cost = JetpackUpgrade.cost
	self.upgradeName = JetpackUpgrade.upgradeName
	self.upgradeTitle = JetpackUpgrade.upgradeTitle
	self.upgradeDesc = JetpackUpgrade.upgradeDesc
	self.upgradeTechId = JetpackUpgrade.upgradeTechId
	self.teamType  = JetpackUpgrade.teamType
	
end

function JetpackUpgrade:GetClassName()
	return "JetpackUpgrade"
end

function JetpackUpgrade:OnAdd(player)
	if not player:isa("JetpackMarine") then
		player:GiveJetpack()
	end
end