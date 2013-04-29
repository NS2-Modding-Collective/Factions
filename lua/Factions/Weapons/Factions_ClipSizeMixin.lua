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
	clipSizeLevel = "integer (0 to " .. #ClipSizeUpgrade.cost .. ")",
}

function ClipSizeMixin:__initmixin()

	local mixinConstants = self:GetMixinConstants()
	self.clipSizeLevel = 0
	self:UpdateClipSizeLevel()
		
end

function ClipSizeMixin:UpdateClipSizeLevel()
	
	if Server then
		local player = self:GetParent()
		if player and HasMixin(player, "WeaponUpgrade") and self.clipSizeLevel ~= player:GetClipSizeLevel() then
		
			self:CalculateNewClipSize(player:GetClipSizeLevel())
			
		end
	end
	
end

function ClipSizeMixin:SetClipSizeLevel(newValue)

	self:CalculateNewClipSize(newValue)

end

function ClipSizeMixin:CalculateNewClipSize(newLevel)

	self.clipSizeLevel = newLevel
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
			weaponClipSize = self:GetClipSize()
		end
	end

end

function ClipSizeMixin:GetClipSize()

	return self.clipSize
	
end