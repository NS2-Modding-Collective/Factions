//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_WeaponUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsWeaponUpgrade' (FactionsUpgrade)

FactionsWeaponUpgrade.upgradeType 	= kFactionsUpgradeTypes.Weapon        	// the type of the upgrade
FactionsWeaponUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsWeaponUpgrade.permanent		= true									// Controls whether you get the upgrade back when you respawn
FactionsWeaponUpgrade.hudSlot		= 4										// Is this a primary weapon?
FactionsWeaponUpgrade.teamType		= kFactionsUpgradeTeamType.MarineTeam	// Team Type

function FactionsWeaponUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsWeaponUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = FactionsWeaponUpgrade.upgradeType
	self.triggerType = FactionsWeaponUpgrade.triggerType
	self.permanent = FactionsWeaponUpgrade.permanent
	self.hudSlot = FactionsWeaponUpgrade.hudSlot
	self.teamType = FactionsWeaponUpgrade.teamType
	
	assert(self.hudSlot)
	
end

function FactionsWeaponUpgrade:GetClassName()
	return "FactionsWeaponUpgrade"
end

function FactionsWeaponUpgrade:GetHUDSlot()
    return self.hudSlot
end

function FactionsWeaponUpgrade:GetUniqueSlot()
	// Calculate the unique slot here.
	// Allows e.g. Welder to replace Knife
	if self.uniqueSlot == kUpgradeUniqueSlot.None then
		if self.hudSlot == 1 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon1
		elseif self.hudSlot == 2 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon2
		elseif self.hudSlot == 3 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon3
		elseif self.hudSlot == 4 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon4
		elseif self.hudSlot == 5 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon5
		elseif self.hudSlot == 6 then
			self.uniqueSlot = kUpgradeUniqueSlot.Weapon6
		end
	end
	
	return self.uniqueSlot
end

function FactionsWeaponUpgrade:GetHideUpgrade()
	local hideUpgrade = FactionsUpgrade.GetHideUpgrade(self)
	if self:GetIsAtMaxLevel() then
		hideUpgrade = true
	end
	
	return hideUpgrade
end


// Give the weapon to the player when they buy the upgrade.
function FactionsWeaponUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
	if mapName then
		// Destroy the old weapon in this slot.
		local weapon = player:GetWeaponInHUDSlot(self:GetHUDSlot())
		// Remove the old weapon
		if weapon then
			player:RemoveWeapon(weapon)
			DestroyEntity(weapon)
		end
		
		// Refund the old upgrade if we have it
		for index, upgrade in ipairs(player:GetUpgradesBySlot(self:GetUniqueSlot())) do
			if upgrade ~= self then
				player:ResetUpgrade(upgrade:GetId())
			end
		end
	
		player:GiveItem(mapName)
	end          

end

function FactionsWeaponUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You bought a " .. self:GetUpgradeTitle() .. "!")
end