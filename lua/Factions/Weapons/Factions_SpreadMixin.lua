//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SpreadMixin.lua

Script.Load("lua/FunctionContracts.lua")

SpreadMixin = CreateMixin( SpreadMixin )
SpreadMixin.type = "Spread"

SpreadMixin.expectedMixins =
{
}

SpreadMixin.expectedCallbacks =
{
}

SpreadMixin.overrideFunctions =
{
}

SpreadMixin.expectedConstants =
{
	kBaseSpread = "The vector defining the initial spread",
	kSpreadIncreaseRate = "The rate of spread increase",
	kSpreadDecreaseRate = "The rate of spread increase",
	kWorstSpread = "The max spread vector"
}

SpreadMixin.networkVars =
{
	spreadScalar = "float",
}

function SpreadMixin:__initmixin()

	local mixinConstants = self:GetMixinConstants()    
	self.spreadScalar = mixinConstants.kBaseSpread
		
end

// Adjust the spread
// TODO: make the increase happen OnFire
function SpreadMixin:OnUpdateRender(dt) 

	local mixinConstants = self:GetMixinConstants()
	
	if self.primaryAttacking or self.secondaryAttacking
		 and self.spreadScalar.x ~= mixinConstants.kWorstSpread.x then
		 
		self.spreadScalar = self.spreadScalar + dt * mixinConstants.kSpreadIncreaseRate
		
		if self.spreadScalar.x > mixinConstants.kWorstSpread.x then
			self.spreadScalar = mixinConstants.kWorstSpread
		end
		
	elseif self.spreadScalar =~ mixinConstants.kBaseSpread then
	
		self.spreadScalar = self.spreadScalar - dt * mixinConstants.kSpreadDecreaseRate
		
		if self.spreadScalar.x < mixinConstants.kBaseSpread.x then
			self.spreadScalar = mixinConstants.kBaseSpread
		end
		
	end
	
end

function SpreadMixin:GetSpreadScalar()
	return self.spreadScalar
end