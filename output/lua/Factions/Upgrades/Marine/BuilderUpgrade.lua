//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// BuilderUpgrade.lua
						
class 'BuilderUpgrade' (FactionsWeaponUpgrade)

BuilderUpgrade.cost 			= { 1 }                           											// Cost of the upgrade in xp
BuilderUpgrade.upgradeName 		= "builder"                       											// Text code of the upgrade if using it via console
BuilderUpgrade.upgradeTitle 	= "Builder"               													// Title of the upgrade, e.g. Submachine Gun
BuilderUpgrade.upgradeDesc 		= "Build Stuff"																// Description of the upgrade
BuilderUpgrade.upgradeTechId 	= kTechId.MarineStructureAbility 	    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
BuilderUpgrade.primaryWeapon 	= false																		// Is this a primary weapon?

function BuilderUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.hideUpgrade = true
	self.cost = BuilderUpgrade.cost
	self.upgradeName = BuilderUpgrade.upgradeName
	self.upgradeTitle = BuilderUpgrade.upgradeTitle
	self.upgradeDesc = BuilderUpgrade.upgradeDesc
	self.upgradeTechId = BuilderUpgrade.upgradeTechId
	self.primaryWeapon = BuilderUpgrade.primaryWeapon
	
end

function BuilderUpgrade:GetClassName()
	return "BuilderUpgrade"
end