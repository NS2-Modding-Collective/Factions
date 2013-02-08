//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_IronSightMixin.lua

Script.Load("lua/FunctionContracts.lua")

kIronSightStatus = enum({ 'Inactive', 'Activating', 'Active', 'Deactivating' })

IronSightMixin = CreateMixin( IronSightMixin )
IronSightMixin.type = "IronSight"

IronSightMixin.expectedMixins =
{
	ClientWeaponEffectsMixin = "Needed to detect whether the secondary fire is being triggered",
}

IronSightMixin.expectedCallbacks =
{
}

// IronSightMixin:GetHasSecondary should completely override any existing
// GetHasSecondary function defined in the object.
IronSightMixin.overrideFunctions =
{
    "GetHasSecondary",
}

IronSightMixin.expectedConstants =
{
	kIronSightTexture = "The texture to use for the iron sight.",
	kIronSightActivateTime = "The amount of time the iron sight takes to activate",
	kIronSightDeactivateTime = "The amount of time the iron sight takes to deactivate",
}

IronSightMixin.networkVars =
{
}

function IronSightMixin:__initmixin()

    self.secondaryAttacking = false
    self.lastSecondaryAttackTime = 0
	self.ironSightStatus = kIronSightStatus.Inactive

end

// Set the texture for the iron sight if defined by the weapon.
function IronSightMixin:OnSetActive() 

	local player = self:GetParent()
	
	if player.ironSightGUI and self:GetMixinConstants().kIronSightTexture then
        
		player.ironSightGUI = ironSightGUI:SetIronSightTexture(texture)
            
	end
	
end

function IronSightMixin:GetHasSecondary(player)
    return true
end

function IronSightMixin:OnSecondaryAttack(player)

    if player:GetSecondaryAttackLastFrame() then
		self.secondaryAttacking = true
		self.ironSightStatus = kIronSightStatus.Activating
	
		local enoughTimePassed = (Shared.GetTime() - self.lastSecondaryAttackTime) > self:GetSecondaryAttackDelay()
		if enoughTimePassed then
    
			self.ironSightStatus = kIronSightStatus.Active
		
		end

    end
    
end

function IronSightMixin:OnUpdateAnimationInput(modelMixin)

	local player = self:GetParent()
	// Set animation inputs for activating/deactivating here.
	if player.ironSightStatus ~= kIronSightStatus.Inactive then
	
		if player.ironSightStatus == kIronSightStatus.Activating then 
			
			modelMixin:SetAnimationInput("activity", "ironsightactivate")
		
		elseif player.ironSightStatus == kIronSightStatus.Deactivating
		
			modelMixin:SetAnimationInput("activity", "ironsightdeactivate")
		
		// Check whether player just released the button here and set the relevant status.
		elseif player.ironSightActive and not player:GetSecondaryAttackLastFrame() and player.ironSightStatus ~= kIronSightStatus.Deactivating then
			
			player.ironSightStatus = kIronSightStatus.Deactivating 
			modelMixin:SetAnimationInput("activity", "ironsightdeactivate")
		
		end
			
	end
	
end

function IronSightMixin:PerformSecondaryAttack(player)
    self.secondaryAttacking = true
end

function IronSightMixin:GetSecondaryAttackDelay()
    return self:GetMixinConstants().kIronSightActivateTime
end

function IronSightMixin:OnSecondaryAttackEnd(player)

    Ability.OnSecondaryAttackEnd(self, player)
    
	self.ironSightActive = false
	self.ironSightStatus = kIronSightStatus.Inactive
	modelMixin:SetAnimationInput("activity", "none")
    self.secondaryAttacking = false

end