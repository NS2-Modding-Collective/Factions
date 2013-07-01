//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SwordHolderMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

SwordDashMixin = CreateMixin( SwordDashMixin )
SwordDashMixin.type = "SwordDash"

SwordDashMixin.kBaseSpeedScalar = 1.2
SwordDashMixin.kSpeedScalarIncrease = 0.1
SwordDashMixin.kBaseTimeBetweenAttacks = 0.4
SwordDashMixin.kTimeBetweenAttacksDecrease = 0.07
SwordDashMixin.kBaseStaminaDrainRate = 0.5
SwordDashMixin.kStaminaDrainRateDecrease = 0.15

SwordDashMixin.expectedMixins =
{
}

SwordDashMixin.expectedCallbacks =
{
}

SwordDashMixin.expectedConstants =
{
}

SwordDashMixin.overrideFunctions =
{
    "GetHasSecondary",
	"OnSecondaryAttack",
	"OnSecondaryAttackEnd",
}

SwordDashMixin.networkVars =
{
	swordDashing = "boolean",
	swordDashStartTime = "time",
}

function SwordDashMixin:__initmixin()

	if Server then
		self.swordDashing = false
	end
	
	self.swordDashAttackCooldowns = {}

end

function SwordDashMixin:GetSwordDashLevel()

	local dashLevel
	local player = self:GetOwner()
	if player and HasMixin(player, "SwordHolder") then
		dashLevel = player:GetIsSwordDashAvailable()
	else
		dashLevel = 0
	end
	
	return dashLevel
	
end

function SwordDashMixin:GetIsSwordDashAvailable()

	local isAvailable
	local player = self:GetOwner()
	if player and HasMixin(player, "SwordHolder") then
		isAvailable = player:GetIsSwordDashAvailable()
	else
		isAvailable = false
	end
	
	return isAvailable
	
end

function SwordDashMixin:GetIsSwordDashing()
	return self.swordDashing
end

function SwordDashMixin:SetIsSwordDashing(newValue)
	self.swordDashing = newValue
	local player = self:GetOwner()
	if player and HasMixin(player, "SwordHolder") then
		player:SetIsSwordDashing(newValue)
	end
end

function SwordDashMixin:GetTimeBetweenAutoAttacks()

	return SwordDashMixin.kBaseTimeBetweenAttacks - SwordDashMixin.kTimeBetweenAttacksDecrease * self:GetShadowStepLevel()

end

function SwordDashMixin:GetHasSecondary(player)

    return self:GetIsSwordDashAvailable()
    
end

function SwordDashMixin:OnSecondaryAttack()
	// Copy Shadow Step code here
	if self:GetShadowStepLevel() > 0 then
		self:SetIsShadowStepping(true)
		self.shadowStepStartTime = Shared.GetTime()
	end
end

function SwordDashMixin:OnSecondaryAttackEnd()
	self:SetIsShadowStepping(false)
	self.shadowStepStartTime = nil
end

function SwordDashMixin:OnSetActive()
	self:SetIsSwordDashing(false)
end

function SwordDashMixin:OnHolster()
	self:SetIsSwordDashing(false)
end

function SwordDashMixin:OnUpdateRender(deltaTime)
	// Update visual effect
	if self:GetIsSwordDashing() then
	end
end

function SwordDashMixin:OnUpdate(deltaTime)
	// Detect nearby enemies
	// Trace a box in front of the player's velocity vector.
	
	// Hit them and play swing animation!
	if trace > 0 then
	end
end