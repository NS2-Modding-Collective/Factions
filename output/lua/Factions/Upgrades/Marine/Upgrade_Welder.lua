//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// WelderUpgrade.lua
						
class 'WelderUpgrade' (FactionsWeaponUpgrade)

WelderUpgrade.cost			= { 50 }                           						// Cost of the upgrade in xp
WelderUpgrade.upgradeName 	= "welder"                       						// Text code of the upgrade if using it via console
WelderUpgrade.upgradeTitle	= "Welder"               								// Title of the upgrade, e.g. Submachine Gun
WelderUpgrade.upgradeDesc 	= "Weld stuff"											// Description of the upgrade
WelderUpgrade.upgradeTechId = kTechId.Welder 	    								// TechId of the upgrade, default is kTechId.Move cause its the first entry
WelderUpgrade.hudSlot		= kWelderHUDSlot										// Is this a primary weapon?

function WelderUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = WelderUpgrade.cost
	self.upgradeName = WelderUpgrade.upgradeName
	self.upgradeTitle = WelderUpgrade.upgradeTitle
	self.upgradeDesc = WelderUpgrade.upgradeDesc
	self.upgradeTechId = WelderUpgrade.upgradeTechId
	self.hudSlot = WelderUpgrade.hudSlot
	
end

// Give the weapon to the player when they buy the upgrade.
// Welders are special - do not destroy what's already in the slot because of logic in Marine:GiveItem
function WelderUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
	if mapName then
		player:GiveItem(mapName)
	end          

end

function WelderUpgrade:GetClassName()
	return "WelderUpgrade"
end