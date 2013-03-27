//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// SMGUpgrade.lua
						
class 'SMGUpgrade' (FactionsWeaponUpgrade)

SMGUpgrade.cost 			= { 50 }                           										// Cost of the upgrade in xp
SMGUpgrade.upgradeName 		= "smg"                       											// Text code of the upgrade if using it via console
SMGUpgrade.upgradeTitle 	= "Submachine Gun"               										// Title of the upgrade, e.g. Submachine Gun
SMGUpgrade.upgradeDesc 		= "Rapid firing, mini version of the rifle. Great at medium range."		// Description of the upgrade
SMGUpgrade.upgradeTechId 	= kTechId.LightMachineGun 	    										// TechId of the upgrade, default is kTechId.Move cause its the first entry
SMGUpgrade.primaryWeapon 	= true																	// Is this a primary weapon?

function SMGUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = SMGUpgrade.cost
	self.upgradeName = SMGUpgrade.upgradeName
	self.upgradeTitle = SMGUpgrade.upgradeTitle
	self.upgradeDesc = SMGUpgrade.upgradeDesc
	self.upgradeTechId = SMGUpgrade.upgradeTechId
	self.primaryWeapon = SMGUpgrade.primaryWeapon
	
end

function SMGUpgrade:GetClassName()
	return "SMGUpgrade"
end