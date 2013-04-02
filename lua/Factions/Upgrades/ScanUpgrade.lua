//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ScanUpgrade' (FactionsTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
ScanUpgrade.cost = { 100, 100, 100, 100, 100 }                              	// Cost of the upgrade in xp
ScanUpgrade.levels = 5															// How many levels are there to this upgrade
ScanUpgrade.upgradeName = "scan"	                     						// Text code of the upgrade if using it via console
ScanUpgrade.upgradeTitle = "Scanner"	               							// Title of the upgrade, e.g. Submachine Gun
ScanUpgrade.upgradeDesc = "Periodically scan for nearby enemies"				// Description of the upgrade
ScanUpgrade.upgradeTechId = kTechId.Scan										// TechId of the upgrade, default is kTechId.Move cause its the first entry
ScanUpgrade.triggerInterval	= { 20, 17, 13, 10, 8 } 							// Specify the timer interval (in seconds) per level.

function ScanUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ScanUpgrade.cost
	self.levels = ScanUpgrade.levels
	self.upgradeName = ScanUpgrade.upgradeName
	self.upgradeTitle = ScanUpgrade.upgradeTitle
	self.upgradeDesc = ScanUpgrade.upgradeDesc
	self.upgradeTechId = ScanUpgrade.upgradeTechId
	self.triggerInterval = ScanUpgrade.triggerInterval
	
end

function ScanUpgrade:GetClassName()
	return "ScanUpgrade"
end

function ScanUpgrade:GetTimerDescription()
	return "Scan will happen every "
end

function ScanUpgrade:OnTrigger(player)

	if player then
		CreateEntity(Scan.kMapName, player:GetOrigin(), player:GetTeamNumber())
		StartSoundEffectAtOrigin(Observatory.kScanSound, position)  
	end

end