//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'DropMedpackUpgrade' (FactionsDropUpgrade)

DropMedpackUpgrade.upgradeType 			= kFactionsUpgradeTypes.Ability        	// the type of the upgrade
DropMedpackUpgrade.cost 				= { 50 }                          		// cost of the upgrade in xp
DropMedpackUpgrade.upgradeName			= "medpack"	                       	 	// text code of the upgrade if using it via console
DropMedpackUpgrade.upgradeTitle 		= "Med Pack Drop"      					// Title of the upgrade, e.g. Submachine Gun
DropMedpackUpgrade.upgradeDesc 			= "Drops some Med Packs"           		// Description of the upgrade
DropMedpackUpgrade.upgradeTechId 		= kTechId.MedPack	  					// techId of the upgrade, default is kTechId.Move cause its the first entry
DropMedpackUpgrade.count	 			= 3										// How many to drop?
DropMedpackUpgrade.teamType				= kFactionsUpgradeTeamType.MarineTeam	// Team Type

function DropMedpackUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.upgradeType = DropAmmoUpgrade.upgradeType
	self.cost = DropAmmoUpgrade.cost
	self.upgradeName = DropAmmoUpgrade.upgradeName
	self.upgradeTitle = DropAmmoUpgrade.upgradeTitle
	self.upgradeDesc = DropAmmoUpgrade.upgradeDesc
	self.upgradeTechId = DropAmmoUpgrade.upgradeTechId
	self.hudSlot = DropAmmoUpgrade.hudSlot
	self.count = DropAmmoUpgrade.count
	self.teamType = DropAmmoUpgrade.teamType
	
end

function DropMedpackUpgrade:GetClassName()
	return "DropMedpackUpgrade"
end