//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ReloadSpeedMixin.lua

Script.Load("lua/FunctionContracts.lua")

ReloadSpeedMixin = CreateMixin( ReloadSpeedMixin )
ReloadSpeedMixin.type = "VariableReloadSpeed"

ReloadSpeedMixin.baseReloadSpeed = 1.15
ReloadSpeedMixin.reloadSpeedBoostPerLevel = 0.2

ReloadSpeedMixin.expectedMixins =
{
}

ReloadSpeedMixin.expectedCallbacks =
{
}

ReloadSpeedMixin.overrideFunctions =
{
}

ReloadSpeedMixin.expectedConstants =
{
}

ReloadSpeedMixin.networkVars =
{
	reloadSpeedScalar = "float",
	reloadSpeedLevel = "integer (0 to " .. ReloadSpeedUpgrade.levels .. ")",
}

function ReloadSpeedMixin:__initmixin()

    self.reloadSpeedScalar = ReloadSpeedMixin.baseReloadSpeed
	self.reloadSpeedLevel = 0
    
end

function ReloadSpeedMixin:OnUpdateAnimationInput(modelMixin)
   
    local player = self:GetParent()
    if player then
    
        modelMixin:SetAnimationInput("reload_time", self.reloadSpeedScalar)
        
    end
            
end

function ReloadSpeedMixin:SetReloadSpeedLevel(newLevel)

	self.reloadSpeedLevel = newLevel
	self.reloadSpeedScalar = ReloadSpeedMixin.baseReloadSpeed + (self.reloadSpeedLevel * ReloadSpeedMixin.reloadSpeedBoostPerLevel)

end