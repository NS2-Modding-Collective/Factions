//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'Tier3Upgrade' (FactionsUpgrade)

Tier3Upgrade.cost 				= { 500 }                          	// cost of the upgrade in xp
Tier3Upgrade.upgradeName		= "tier3"	                        // text code of the upgrade if using it via console
Tier3Upgrade.upgradeTitle 		= "Tier 3"       					// Title of the upgrade, e.g. Submachine Gun
Tier3Upgrade.upgradeDesc 		= "Get tier 3 abilities for your lifeform"             		// Description of the upgrade
Tier3Upgrade.upgradeTechId 		= kTechId.ThreeHives  				// techId of the upgrade, default is kTechId.Move cause its the first 
Tier3Upgrade.teamType			= kFactionsUpgradeTeamType.AlienTeam	// Team Type

function Tier3Upgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = Tier3Upgrade.cost
	self.upgradeName = Tier3Upgrade.upgradeName
	self.upgradeTitle = Tier3Upgrade.upgradeTitle
	self.upgradeDesc = Tier3Upgrade.upgradeDesc
	self.upgradeTechId = Tier3Upgrade.upgradeTechId
	self.teamType = Tier3Upgrade.teamType
	
end

function Tier3Upgrade:GetClassName()
	return "Tier3Upgrade"
end

function Tier3Upgrade:OnAdd(player)
	player:SendDirectMessage("Unlocked Tier 3 abilities!")
	if player:isa("Alien") then
		player:SetHasThreeHives(true)
	end
end