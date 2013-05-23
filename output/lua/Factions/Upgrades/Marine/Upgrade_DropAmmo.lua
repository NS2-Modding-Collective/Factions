//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'DropAmmoUpgrade' (FactionsDropUpgrade)

DropAmmoUpgrade.upgradeType 		= kFactionsUpgradeTypes.Ability        	// the type of the upgrade
DropAmmoUpgrade.cost 				= { 50 }                          		// cost of the upgrade in xp
DropAmmoUpgrade.upgradeName			= "ammo"	                        	// text code of the upgrade if using it via console
DropAmmoUpgrade.upgradeTitle 		= "Ammo Pack Drop"      				// Title of the upgrade, e.g. Submachine Gun
DropAmmoUpgrade.upgradeDesc 		= "Drops some ammo Packs"           	// Description of the upgrade
DropAmmoUpgrade.upgradeTechId 		= kTechId.AmmoPack  					// techId of the upgrade, default is kTechId.Move cause its the first entry
DropAmmoUpgrade.teamType			= kFactionsUpgradeTeamType.MarineTeam	// Team Type

function DropAmmoUpgrade:Initialize()

	FactionsDropUpgrade.Initialize(self)
	
	self.upgradeType = DropAmmoUpgrade.upgradeType
	self.cost = DropAmmoUpgrade.cost
	self.upgradeName = DropAmmoUpgrade.upgradeName
	self.upgradeTitle = DropAmmoUpgrade.upgradeTitle
	self.upgradeDesc = DropAmmoUpgrade.upgradeDesc
	self.upgradeTechId = DropAmmoUpgrade.upgradeTechId
	self.hudSlot = DropAmmoUpgrade.hudSlot
	self.teamType = DropAmmoUpgrade.teamType
	
end

function DropAmmoUpgrade:GetClassName()
	return "DropAmmoUpgrade"
end

function DropAmmoUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Dropped " .. player:GetDropCount() .. " Ammo Packs!")
end