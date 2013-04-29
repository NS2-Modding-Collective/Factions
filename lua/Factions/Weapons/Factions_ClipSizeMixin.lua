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
ClipSizeMixin.type = "VariableClipSize"

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
	self:CalculateNewClipSize(0)
		
end

function ClipSizeMixin:UpdateClipSizeLevel(newValue)
	
	if Server then
		local player = self:GetParent()
		if player and HasMixin(player, "WeaponUpgrade") then
		
			self:CalculateNewClipSize(newValue)
			
		end
	end
	
end

function ClipSizeMixin:CalculateNewClipSize(newLevel)

	local mixinConstants = self:GetMixinConstants()
	self.clipSize = mixinConstants.kBaseClipSize + newLevel * mixinConstants.kClipSizeIncrease
	self:UpdateClipSizeGUI()
	
end

function ClipSizeMixin:OnSetActive()

	self:UpdateClipSizeGUI()
	
end

function ClipSizeMixin:UpdateClipSizeGUI()

	// Update global variable for the GUI
	if Client then
		local player = Client.GetLocalPlayer()
		local activeWeapon = player:GetActiveWeapon()
		
		if activeWeapon == self then
			kClipSize = self:GetClipSize()
		end
	end

end

function ClipSizeMixin:GetClipSize()

	return self.clipSize
	
end