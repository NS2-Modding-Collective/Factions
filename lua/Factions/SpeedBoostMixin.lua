//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SpeedBoostMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

SpeedUpgradeMixin = CreateMixin( SpeedUpgradeMixin )
SpeedUpgradeMixin.type = "SpeedUpgrade"

SpeedUpgradeMixin.expectedMixins =
{
}

SpeedUpgradeMixin.expectedCallbacks =
{
}

SpeedUpgradeMixin.expectedConstants =
{
}

SpeedUpgradeMixin.networkVars =
{
	upgradeSpeedLevel = "integer (0 to " .. SpeedUpgrade.levels)
}

function FactionsClassMixin:__initmixin()

	self.upgradeSpeedLevel = 0

end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	self.upgradeSpeedLevel = player.upgradeSpeedLevel

end

function SpeedUpgradeMixin:GetRunMaxSpeed()

	if self:GetFactionsClassType() == kFactionsClassType.NoneSelected then
		return Marine.kRunMaxSpeed
	else
		return self.factionsClass.baseRunSpeed
	end

end

function SpeedUpgradeMixin:GetWalkMaxSpeed()

	if self:GetFactionsClassType() == kFactionsClassType.NoneSelected then
		return Marine.kWalkMaxSpeed
	else
		return self.factionsClass.baseWalkSpeed
	end
	
	if self.upgradeSpeedLevel > 0 then
		
	end

end