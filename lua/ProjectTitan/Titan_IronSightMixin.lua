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

IronSightMixin = CreateMixin( IronSightMixin )
IronSightMixin.type = "IronSight"

IronSightMixin.expectedMixins =
{
}

IronSightMixin.expectedCallbacks =
{
}

// IronSightMixin:GetHasSecondary should completely override any existing
// GetHasSecondary function defined in the object.
IronSightMixin.overrideFunctions =
{
    "GetHasSecondary",
	"OnSecondaryAttack",
	"OnSecondaryAttackEnd",
}

IronSightMixin.expectedConstants =
{
	kIronSightTexture = "The texture to use for the iron sight.",
	kIronSightZoomFOV = "The FOV to use when zoomed",
	kIronSightActivateTime = "The amount of time the iron sight takes to activate",
}

IronSightMixin.networkVars =
{
}

function IronSightMixin:__initmixin()

    self.secondaryAttacking = false
    self.lastSecondaryAttackTime = 0
	self.ironSightActive = false
	self.ironSightZoom = kDefaultFov
	self.ironSightZoomRate = (kDefaultFov - Rifle.kIronSightZoomFOV) / Rifle.kIronSightActivateTime

end

// Set the texture for the iron sight if defined by the weapon.
function IronSightMixin:OnSetActive() 

	local player = self:GetParent()
	local mixinConstants = self:GetMixinConstants()
	
	if player.ironSightGUI then
        
		player.ironSightGUI:SetTexture(mixinConstants.kIronSightTexture)
		player.ironSightGUI:SetTransitionTime(mixinConstants.kIronSightActivateTime)
		player.ironSightGUI:HideIronSight()
            
	end
	
	self.ironSightZoomRate = (kDefaultFov - mixinConstants.kIronSightZoomFOV) / mixinConstants.kIronSightActivateTime
	self.ironSightZoom = kDefaultFov
	player.ironSightActive = false
	
end

// Set the field of vision on each frame, only for the client...
function IronSightMixin:ProcessMoveOnWeapon(player, input)

	local newFov = kDefaultFov
	if Client and player.ironSightGUI then
	
		if player.ironSightActive then
			newFov = math.round(Slerp(self.ironSightZoom, self:GetMixinConstants().kIronSightZoomFOV, self.ironSightZoomRate*input.time))
		else
			newFov = math.round(Slerp(self.ironSightZoom, kDefaultFov, self.ironSightZoomRate*input.time))
		end
		
		self.ironSightZoom = newFov
		player:SetFov(newFov)
		
	end

end

function IronSightMixin:GetHasSecondary(player)
    return true
end

function IronSightMixin:OnSecondaryAttack(player)

	local player = self:GetParent()
	player.ironSightActive = true
	// Override any default secondary attacking behaviour here (e.g. rifle butt).
	player.secondaryAttacking = false
	
	if player.ironSightGUI then
		player.ironSightGUI:ShowIronSight()
	end
    
end

function IronSightMixin:OnSecondaryAttackEnd(player)
    
	player.ironSightActive = false
	player.secondaryAttacking = false
	
	if player.ironSightGUI then
		player.ironSightGUI:HideIronSight()
	end

end