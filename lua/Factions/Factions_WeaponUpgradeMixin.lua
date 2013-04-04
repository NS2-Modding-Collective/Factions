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

WeaponUpgradeMixin = CreateMixin( WeaponUpgradeMixin )
WeaponUpgradeMixin.type = "WeaponUpgrade"

WeaponUpgradeMixin.baseReloadSpeed = 1.0
WeaponUpgradeMixin.reloadSpeedBoostPerLevel = 0.2

WeaponUpgradeMixin.baseFireRate = 1.0
WeaponUpgradeMixin.fireRateBoostPerLevel = 0.15

WeaponUpgradeMixin.baseDamage = 1.0
WeaponUpgradeMixin.damageBoostPerLevel = 0.1

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

function WeaponUpgradeMixin:UpdateReloadSpeed()

    // Set the reload speed on the weapon based on the player's level
    local weapon = self:GetActiveWeapon()
    if weapon and HasMixin(weapon, "VariableReloadSpeed") then
    	weapon:UpdateReloadSpeed(self:GetReloadSpeedScalar())
    end
    
end

function WeaponUpgradeMixin:UpdateFireRate()

    // Set the reload speed on the weapon based on the player's level
    local weapon = self:GetActiveWeapon()
    if weapon and HasMixin(weapon, "VariableFireRate") then
    	weapon:UpdateFireRate(self:GetFireRateScalar())
    end
    
end

function WeaponUpgradeMixin:UpdateDamageLevel()

    // Set the reload speed on the weapon based on the player's level
    local weapon = self:GetActiveWeapon()
    if weapon and HasMixin(weapon, "VariableDamage") then
    	weapon:UpdateDamageLevel(self:GetDamageScalar())
    end
    
end

function WeaponUpgradeMixin:GetReloadSpeedScalar()

	return WeaponUpgradeMixin.baseReloadSpeed + (self.reloadSpeedLevel * WeaponUpgradeMixin.reloadSpeedBoostPerLevel)

end

function WeaponUpgradeMixin:GetFireRateScalar()

	return WeaponUpgradeMixin.baseFireRate + (self.fireRateLevel * WeaponUpgradeMixin.fireRateBoostPerLevel)

end

function WeaponUpgradeMixin:GetDamageScalar()

	return WeaponUpgradeMixin.baseDamage + (self.damageLevel * WeaponUpgradeMixin.damageBoostPerLevel)

end