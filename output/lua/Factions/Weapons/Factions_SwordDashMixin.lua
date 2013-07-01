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

SwordDashMixin.networkVars =
{
	swordDashing = "boolean",
	swordDashStartTime = "time",
}

function SwordDashMixin:__initmixin()

	if Server then
		self.swordDashing = false
	end
	
	self.shadowStepAttackCooldowns = {}

end

function SwordDashMixin:GetSwordDashLevel()
	return self.swordDashLevel
end

function SwordDashMixin:SetSwordDashLevel(newValue)
	self.swordDashLevel = newValue
end

function SwordDashMixin:GetIsSwordDashing()
	return self.swordDashing
end

function SwordDashMixin:SetIsSwordDashing(newValue)
	self.swordDashing = newValue
end

function SwordDashMixin:GetTimeBetweenAutoAttacks()

	return SwordDashMixin.kBaseTimeBetweenAttacks - SwordDashMixin.kTimeBetweenAttacksDecrease * self:GetShadowStepLevel()

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
		// Show blink effect, slightly toned down
	end
end

function SwordDashMixin:OnUpdate(deltaTime)
	// Update sprint bar

	// Detect nearby enemies
	
	// Hit them and play swing animation!
end