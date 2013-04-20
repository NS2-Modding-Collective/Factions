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

Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_ReloadSpeedMixin.lua")

WeaponUpgradeMixin = CreateMixin( WeaponUpgradeMixin )
WeaponUpgradeMixin.type = "WeaponUpgrade"

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
	reloadSpeedLevel = "integer (0 to " .. #ReloadSpeedUpgrade.cost .. ")",
	fireRateLevel = "integer (0 to " .. #FireRateUpgrade.cost .. ")",
	damageLevel = "integer (0 to " .. #DamageUpgrade.cost .. ")",
	laserSightLevel = "integer (0 to " .. #LaserSightUpgrade.cost .. ")",
}

function WeaponUpgradeMixin:__initmixin()

	self.reloadSpeedLevel = 0
	self.fireRateLevel = 0
	self.damageLevel = 0
	self.laserSightLevel = 0

end

function WeaponUpgradeMixin:CopyPlayerDataFrom(player)

	self.reloadSpeedLevel = player.reloadSpeedLevel
	self.fireRateLevel = player.fireRateLevel
	self.damageLevel = player.damageLevel
	self.laserSightLevel = player.laserSightLevel

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
    
end

function WeaponUpgradeMixin:UpdateLaserSightLevel(newLevel)

	self.laserSightLevel = newLevel
	local weapon = self:GetActiveWeapon()
	if weapon and HasMixin(weapon, "LaserSight") then
		weapon:SetLaserSightLevel(newLevel)
	end

	
end

function WeaponUpgradeMixin:GetReloadSpeedLevel()

	return self.reloadSpeedLevel

end

function WeaponUpgradeMixin:GetFireRateLevel()

	return self.fireRateLevel

end

function WeaponUpgradeMixin:GetDamageScalar()

	return WeaponUpgradeMixin.baseDamage + (self.damageLevel * WeaponUpgradeMixin.damageBoostPerLevel)

end

function WeaponUpgradeMixin:GetLaserSightLevel()

	return self.laserSightLevel

end