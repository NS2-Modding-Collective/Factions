//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ClipWeapon.lua

local networkVars = {
}

Script.Load("lua/Factions/Weapons/Factions_ReloadSpeedMixin.lua")

AddMixinNetworkVars(ReloadSpeedMixin, networkVars)

// Reload Speed etc.
local overrideOnCreate = ClipWeapon.OnCreate
function ClipWeapon:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, ReloadSpeedMixin)
	
	assert(HasMixin(self, "VariableReloadSpeed"))
	
end

function ClipWeapon:SetupIronSight()

	local player = self:GetParent()
	if player and HasMixin(player, "WeaponUpgrade") and player:GetIronSightLevel() > 0 then
		if self.GetIronSightParameters then
			InitMixin(self, IronSightMixin, self:GetIronSightParameters())
			assert(HasMixin(self, "IronSight"))
		end
	end

end

Class_Reload("ClipWeapon", networkVars)