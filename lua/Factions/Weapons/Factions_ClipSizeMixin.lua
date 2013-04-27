//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ClipSizeMixin.lua

Script.Load("lua/FunctionContracts.lua")

ClipSizeMixin = CreateMixin( SpreadMixin )
ClipSizeMixin.type = "ClipSize"

ClipSizeMixin.expectedMixins =
{
}

ClipSizeMixin.expectedCallbacks =
{
}

ClipSizeMixin.overrideFunctions =
{
}

ClipSizeMixin.expectedConstants =
{
	kBaseClipSize = "The vector defining the initial spread",
	kClipSizeIncrease = "The amount the clip size increases each level",
}

ClipSizeMixin.networkVars =
{
	clipSize = "integer (1 to 100)",
}

function ClipSizeMixin:__initmixin()

	local mixinConstants = self:GetMixinConstants()    
	self.spreadScalar = mixinConstants.kBaseSpread
		
end

function SpreadMixin:UpdateSpreadScalar()
	
	if self.primaryAttacking or self.secondaryAttacking then
		if self.spreadScalar ~= self:GetWorstSpread() then
		 
			self.spreadScalar = self.spreadScalar + dt * mixinConstants.kSpreadIncreaseRate
		
			if self.spreadScalar > self.GetWorstSpread() then
				self.spreadScalar = self.GetWorstSpread()
			end
		end
		
	elseif self.spreadScalar =~ self:GetBaseSpread() then
	
		self.spreadScalar = self.spreadScalar - dt * mixinConstants.kSpreadDecreaseRate
		
		if self.spreadScalar < self:GetBaseSpread() then
			self.spreadScalar = self:GetBaseSpread()
		end
		
	end
end

// Adjust the spread
// TODO: make the increase happen OnFire
function SpreadMixin:OnUpdate(dt) 

	self:UpdateSpreadScalar()
	
end

function SpreadMixin:OnUpdateRender(dt) 

	self:UpdateSpreadScalar()
	
end

function SpreadMixin:GetDefaultBaseSpread()
	local mixinConstants = self:GetMixinConstants()
	return mixinConstants.kBaseSpread
end

function SpreadMixin:GetBaseSpread()
	return self.baseSpread
end

function SpreadMixin:GetDefaultWorstSpread()
	local mixinConstants = self:GetMixinConstants()
	return mixinConstants.kWorstSpread
end

function SpreadMixin:GetWorstSpread()
	return self.worstSpread
end

function SpreadMixin:ApplyLaserSightSpreadScalar(scalarValue)
	self.baseSpread = self:GetDefaultBaseSpread()*scalarValue
	self.worstSpread = self:GetDefaultWorstSpread()*scalarValue
end

function SpreadMixin:GetSpreadScalar()
	return self.spreadScalar
end

function SpreadMixin:GetSpread()
	return _G[self:GetClassName()].GetSpread(self) * self:GetSpreadScalar()
end