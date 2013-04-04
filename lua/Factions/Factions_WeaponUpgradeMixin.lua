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
WeaponUpgradeMixin.reloadSpeedBoostPerLevel = 0.1

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
	reloadSpeedLevel = "integer (0 to " .. ReloadSpeedUpgrade.levels .. ")"
}

function WeaponUpgradeMixin:__initmixin()

	self.reloadSpeedLevel = 0

end

function WeaponUpgradeMixin:CopyPlayerDataFrom(player)

	self.reloadSpeedLevel = player.reloadSpeedLevel

end

function WeaponUpgradeMixin:UpdateReloadSpeed()

    // Set the reload speed on the weapon based on the player's level
    local weapon = self:GetActiveWeapon()
    if weapon and HasMixin(weapon, "VariableReloadSpeed") then
    end
    
end

function WeaponUpgradeMixin:GetReloadSpeed()

	return WeaponUpgradeMixin.baseReloadSpeed + (self.reloadSpeedLevel * WeaponUpgradeMixin.reloadSpeedBoostPerLevel)

end