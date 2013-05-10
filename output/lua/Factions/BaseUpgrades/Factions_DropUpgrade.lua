//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UnlockUpgrade.lua

// Base class for all upgrades that unlock another upgrade

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsDropUpgrade' (FactionsUpgrade)

FactionsDropUpgrade.upgradeType 	= kFactionsUpgradeTypes.Tech        	// the type of the upgrade
FactionsDropUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsDropUpgrade.permanent		= false									// Controls whether you get the upgrade back when you respawn
FactionsDropUpgrade.count 			= 1

function FactionsDropUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsDropUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = FactionsDropUpgrade.upgradeType
	self.triggerType = FactionsDropUpgrade.triggerType
	self.permanent = FactionsDropUpgrade.permanent
	self.count = FactionsDropUpgrade.count
	
end

function FactionsDropUpgrade:GetClassName()
	return "FactionsDropUpgrade"
end

// Give the weapon to the player when they buy the upgrade.
function FactionsDropUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
	if mapName then
		for index = 1,self.count,1 do
			local origin = player:GetOrigin() + Vector(math.random() * 2 - 1, 0, math.random() * 2 - 1) 
			local values = { 
			    origin = origin,
				angles = player:GetAngles(),
				team = player:GetTeamNumber(),
				startsActive = true,
				}
			Server.CreateEntity(mapName, values)
		end
	end

end

function FactionsDropUpgrade:SendAddMessage(player)
	local upgradeTitle = Locale.ResolveString(LookupTechData(self:GetUpgradeTechId(), kTechDataDisplayName))
	player:SendDirectMessage("Dropped " .. upgradeTitle .. "!")
end