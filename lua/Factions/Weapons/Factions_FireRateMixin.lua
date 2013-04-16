//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FireRateMixin.lua

Script.Load("lua/FunctionContracts.lua")

FireRateMixin = CreateMixin( FireRateMixin )
FireRateMixin.type = "VariableFireRate"

FireRateMixin.baseFireRate = 1.0
FireRateMixin.fireRateBoostPerLevel = 0.15

FireRateMixin.expectedMixins =
{
}

FireRateMixin.expectedCallbacks =
{
}

FireRateMixin.overrideFunctions =
{
}

FireRateMixin.expectedConstants =
{
}

FireRateMixin.networkVars =
{
	fireRateScalar = "float",
	fireRateLevel = "integer (0 to " .. FireRateUpgrade.levels .. ")",
}

function FireRateMixin:__initmixin()

    self.fireRateScalar = FireRateMixin.baseFireRate
	self.fireRateLevel = 0
    
end

function FireRateMixin:SetParent()

	self:UpdateFireRateLevel()
	
end

function FireRateMixin:OnUpdateAnimationInput(modelMixin)
   
	local attackSpeed = modelMixin:GetAnimationInput("attack_speed")
	local newAttackSpeed = attackSpeed * self.fireRateScalar
    modelMixin:SetAnimationInput("attack_speed", newAttackSpeed)
            
end

function FireRateMixin:UpdateFireRateLevel()

	local player = self:GetParent()
    if player and HasMixin("WeaponUpgrade") and self.fireRateLevel ~= player:GetFireRateLevel() then
	
		self:SetFireRateLevel(player:GetFireRateLevel())
		
    end

end

function FireRateMixin:SetFireRateLevel(newLevel)

	self.fireRateLevel = newLevel
	self.fireRateScalar = FireRateMixin.baseFireRate + (self.fireRateLevel * FireRateMixin.fireRateBoostPerLevel)

end