//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_WeaponUpgradeMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

Script.Load("lua/Factions/Weapons/Factions_ReloadSpeedMixin.lua")

WeaponUpgradeMixin = CreateMixin( WeaponUpgradeMixin )
WeaponUpgradeMixin.type = "WeaponUpgrade"

WeaponUpgradeMixin.baseFireRate = 1.0
WeaponUpgradeMixin.fireRateBoostPerLevel = 0.15

WeaponUpgradeMixin.baseDamage = 1.0
WeaponUpgradeMixin.damageBoostPerLevel = 0.2

WeaponUpgradeMixin.expectedMixins =
{
    FactionsUpgrade = "to detect the level of the upgrades"
}

WeaponUpgradeMixin.expectedCallbacks =
{
}

WeaponUpgradeMixin.expectedConstants =
{
}

WeaponUpgradeMixin.networkVars =
{
	reloadSpeedLevel = "integer (0 to " .. ReloadSpeedUpgrade.levels .. ")",
	fireRateLevel = "integer (0 to " .. ReloadSpeedUpgrade.levels .. ")",
	damageLevel = "integer (0 to " .. ReloadSpeedUpgrade.levels .. ")",
}

function WeaponUpgradeMixin:__initmixin()

	self.reloadSpeedLevel = 0
	self.fireRateLevel = 0
	self.damageLevel = 0

end

function WeaponUpgradeMixin:CopyPlayerDataFrom(player)

	self.reloadSpeedLevel = player.reloadSpeedLevel
	self.fireRateLevel = player.fireRateLevel
	self.damageLevel = player.damageLevel

end

function WeaponUpgradeMixin:UpdateReloadSpeedLevel(newLevel)
	
	self.reloadSpeedLevel = newLevel
	local weapon = self:GetActiveWeapon()
	if weapon and HasMixin(weapon, "VariableReloadSpeed") then
		weapon:SetReloadSpeedLevel(newLevel)
	end
    
end

function WeaponUpgradeMixin:UpdateDamageLevel(newLevel)
	
	self.damageLevel = newLevel
    
end

function WeaponUpgradeMixin:UpdateFireRateLevel(newLevel)

	self.fireRateLevel = newLevel

    // Set the reload speed on the weapon based on the player's level
    local weapon = self:GetActiveWeapon()
    if weapon and HasMixin(weapon, "VariableFireRate") then
    	weapon:UpdateFireRate(self:GetFireRateScalar())
    end
    
end

function WeaponUpgradeMixin:GetReloadSpeedLevel()

	return self.reloadSpeedLevel

end

function WeaponUpgradeMixin:GetFireRateScalar()

	return WeaponUpgradeMixin.baseFireRate + (self.fireRateLevel * WeaponUpgradeMixin.fireRateBoostPerLevel)

end

function WeaponUpgradeMixin:GetDamageScalar()

	return WeaponUpgradeMixin.baseDamage + (self.damageLevel * WeaponUpgradeMixin.damageBoostPerLevel)

end