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
	"GetClipSize",
	"GetMaxAmmo",
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
	self.clipSize = mixinConstants.kBaseClipSize
	self.clipSizeLevel = 0
	if Server then
		self:UpdateClipSizeLevel()
	elseif Client then
		self.cachedClipSize = self.clipSize
	end
		
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

	local mixinConstants = self:GetMixinConstants()
	local player = self:GetParent()
	// Increase the clip size
	self.clipSizeLevel = newLevel
	self.clipSize = mixinConstants.kBaseClipSize + newLevel * mixinConstants.kClipSizeIncrease
	// Give a little ammo
	self:GiveAmmo(1, false)
	// Trigger effects to update the display
	if Server then
		self:TriggerEffects("armory_ammo", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
		player:Reload()
	elseif Client then
		self:UpdateClipSizeGUI()
	end
	
end

function ClipSizeMixin:OnSetActive()

	self:UpdateClipSizeGUI()
	
end

function ClipSizeMixin:OnUpdateRender()

	if self.cachedClipSize ~= self.clipSize then
		self.cachedClipSize = self.clipSize
		self:UpdateClipSizeGUI()
	end
	
end

function ClipSizeMixin:UpdateClipSizeGUI()

	// Update global variable for the GUI
	if Client then
		local player = Client.GetLocalPlayer()
		local activeWeapon = player:GetActiveWeapon()
		
		if activeWeapon == self then
			if self.ammoDisplayUI then
				self.ammoDisplayUI:SetGlobal("weaponMaxAmmo", self:GetMaxAmmo())
				self.ammoDisplayUI:SetGlobal("weaponClipSize", self:GetClipSize())
			end
		end
	end

end

function ClipSizeMixin:GetMaxAmmo()

	local mixinConstants = self:GetMixinConstants()
	return mixinConstants.kBaseClipSize * 4
	
end

function ClipSizeMixin:GetClipSize()

	return self.clipSize
	
end