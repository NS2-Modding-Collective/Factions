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
	reloadSpeedLevel = "integer (0 to " .. #ReloadSpeedUpgrade.cost .. ")",
	fireRateLevel = "integer (0 to " .. #FireRateUpgrade.cost .. ")",
	damageLevel = "integer (0 to " .. #DamageUpgrade.cost .. ")",
	laserSightLevel = "integer (0 to " .. #LaserSightUpgrade.cost .. ")",
	ironSightLevel = "integer (0 to " .. #IronSightUpgrade.cost .. ")",
	clipSizeLevel = "integer (0 to " .. #ClipSizeUpgrade.cost .. ")",
}

function WeaponUpgradeMixin:__initmixin()

	self.reloadSpeedLevel = 0
	self.fireRateLevel = 0
	self.damageLevel = 0
	self.laserSightLevel = 0
	self.ironSightLevel = 0
	self.clipSizeLevel = 0

end

function WeaponUpgradeMixin:CopyPlayerDataFrom(player)

	self.reloadSpeedLevel = player.reloadSpeedLevel
	self.fireRateLevel = player.fireRateLevel
	self.damageLevel = player.damageLevel
	self.laserSightLevel = player.laserSightLevel
	self.ironSightLevel = player.ironSightLevel
	self.clipSizeLevel = player.clipSizeLevel

end

function WeaponUpgradeMixin:GetAvailableWeapons()

	local allWeapons = { }
    for i = 0, self:GetNumChildren() - 1 do
    
        local child = self:GetChildAtIndex(i)
        if child:isa("Weapon") then
            table.insert(allWeapons, child)
        end
        
    end
    
	return allWeapons

end

function WeaponUpgradeMixin:UpdateReloadSpeedLevel(newLevel)
	
	self.reloadSpeedLevel = newLevel
	local allWeapons = self:GetAvailableWeapons()
	for i, weapon in ipairs(allWeapons) do
        if HasMixin(weapon, "VariableReloadSpeed") then
			weapon:SetReloadSpeedLevel(newLevel)
		end
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
	local allWeapons = self:GetAvailableWeapons()
	for i, weapon in ipairs(allWeapons) do
        if HasMixin(weapon, "LaserSight") then
			weapon:SetLaserSightLevel(newLevel)
		end
    end
	
end

function WeaponUpgradeMixin:UpdateIronSightLevel(newLevel)

	self.ironSightLevel = newLevel
	local allWeapons = self:GetAvailableWeapons()
	for i, weapon in ipairs(allWeapons) do
        if HasMixin(weapon, "IronSight") then
			weapon:SetIronSightAvailable(true)
		end
    end
	
end

function WeaponUpgradeMixin:UpdateClipSizeLevel(newLevel)

	self.clipSizeLevel = newLevel
	local allWeapons = self:GetAvailableWeapons()
	for i, weapon in ipairs(allWeapons) do
        if HasMixin(weapon, "VariableClipSize") then
			weapon:SetClipSizeLevel(newLevel)
		end
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

function WeaponUpgradeMixin:GetIronSightLevel()

	return self.ironSightLevel

end

function WeaponUpgradeMixin:GetClipSizeLevel()

	return self.clipSizeLevel

end