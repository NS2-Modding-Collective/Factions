// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\LightMachineGun.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LightMachineGun.lua

Script.Load("lua/Weapons/Marine/ClipWeapon.lua")
Script.Load("lua/PickupableWeaponMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/Weapons/ClientWeaponEffectsMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_IronSightMixin.lua")

class 'LightMachineGun' (ClipWeapon)

LightMachineGun.kMapName = "lmg"

LightMachineGun.kModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun.model")
local kViewModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.animation_graph")

LightMachineGun.kIronSightTexture = "ui/Factions/testing_ironsights.png"
LightMachineGun.kIronSightZoomFOV = 45
LightMachineGun.kIronSightActivateTime = 0.1

local kRange = 250
// 4 degrees in NS1
local kSpread = ClipWeapon.kCone3Degrees

local kButtRange = 1.1

local kNumberOfVariants = 3

local kSingleShotSounds = { "sound/NS2.fev/marine/rifle/fire_single", "sound/NS2.fev/marine/rifle/fire_single_2", "sound/NS2.fev/marine/rifle/fire_single_3" }
for k, v in ipairs(kSingleShotSounds) do PrecacheAsset(v) end

local kAttackSoundName = PrecacheAsset("sound/NS2.fev/marine/structures/sentry_fire_loop")
local kEndSound = PrecacheAsset("sound/NS2.fev/marine/structures/sentry_spin_down")

local kMuzzleCinematics = {
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash.cinematic"),
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash2.cinematic"),
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash3.cinematic"),
}

local networkVars =
{
    soundType = "integer (1 to 9)"
}

local kMuzzleEffect = PrecacheAsset("cinematics/marine/rifle/muzzle_flash.cinematic")
local kMuzzleAttachPoint = "fxnode_riflemuzzle"

local function DestroyMuzzleEffect(self)

    if self.muzzleCinematic then
        Client.DestroyCinematic(self.muzzleCinematic)            
    end
    
    self.muzzleCinematic = nil
    self.activeCinematicName = nil

end

local function CreateMuzzleEffect(self)

    local player = self:GetParent()

    if player then

        local cinematicName = kMuzzleCinematics[math.ceil(self.soundType / 3)]
        self.activeCinematicName = cinematicName
        self.muzzleCinematic = CreateMuzzleCinematic(self, cinematicName, cinematicName, kMuzzleAttachPoint, nil, Cinematic.Repeat_Endless)
        self.firstPersonLoaded = player:GetIsLocalPlayer() and player:GetIsFirstPerson()
    
    end

end

function LightMachineGun:OnCreate()

    ClipWeapon.OnCreate(self)
    
    InitMixin(self, PickupableWeaponMixin)
    InitMixin(self, EntityChangeMixin)
    
    if Client then
        InitMixin(self, ClientWeaponEffectsMixin)
		
		local ironSightParameters = { kIronSightTexture = LightMachineGun.kIronSightTexture,
									  kIronSightZoomFOV = LightMachineGun.kIronSightZoomFOV,
									  kIronSightActivateTime = LightMachineGun.kIronSightActivateTime }
		InitMixin(self, IronSightMixin, ironSightParameters)
		
		assert(HasMixin(self, "IronSight"))
		
    elseif Server then
        self.soundVariant = Shared.GetRandomInt(1, kNumberOfVariants)
        self.soundType = self.soundVariant
    end
    
end

function LightMachineGun:OnDestroy()

    ClipWeapon.OnDestroy(self)
    
    DestroyMuzzleEffect(self)
    
end

local function UpdateSoundType(self, player)

    local upgradeLevel = 0
    
    if player.GetWeaponUpgradeLevel then
        upgradeLevel = math.max(0, player:GetWeaponUpgradeLevel() - 1)
    end

    self.soundType = self.soundVariant + upgradeLevel * kNumberOfVariants

end

function LightMachineGun:OnPrimaryAttack(player)

    if not self:GetIsReloading() then
    
        if Server then
            UpdateSoundType(self, player)
        end
        
        ClipWeapon.OnPrimaryAttack(self, player)
        
    end    

end

function LightMachineGun:OnHolster(player)

    DestroyMuzzleEffect(self)    
    ClipWeapon.OnHolster(self, player)
    
end

function LightMachineGun:GetHasSecondary(player)
    return false
end

function LightMachineGun:GetAnimationGraphName()
    return kAnimationGraph
end

function LightMachineGun:GetViewModelName()
    return kViewModelName
end

function LightMachineGun:GetDeathIconIndex()
    return kDeathMessageIcon.Rifle
end

function LightMachineGun:GetHUDSlot()
    return kPrimaryWeaponSlot
end

function LightMachineGun:GetClipSize()
    return kLightMachineGunClipSize
end

function LightMachineGun:GetSpread()
    return kSpread
end

function LightMachineGun:GetBulletDamage(target, endPoint)
    return kLightMachineGunDamage
end

function LightMachineGun:GetRange()
    return kRange
end

function LightMachineGun:GetWeight()
    return kLightMachineGunWeight
end

function LightMachineGun:GetBarrelSmokeEffect()
    return LightMachineGun.kBarrelSmokeEffect
end

function LightMachineGun:GetShellEffect()
    return chooseWeightedEntry ( LightMachineGun.kShellEffectTable )
end

function LightMachineGun:SetGunLoopParam(viewModel, paramName, rateOfChange)

    local current = viewModel:GetPoseParam(paramName)
    // 0.5 instead of 1 as full arm_loop is intense.
    local new = Clamp(current + rateOfChange, 0, 0.5)
    viewModel:SetPoseParam(paramName, new)
    
end

function LightMachineGun:UpdateViewModelPoseParameters(viewModel)

    viewModel:SetPoseParam("hide_gl", 1)
    viewModel:SetPoseParam("gl_empty", 1)
    
    local attacking = self:GetPrimaryAttacking()
    local sign = (attacking and 1) or 0
    
    self:SetGunLoopParam(viewModel, "arm_loop", sign)
    
end

function LightMachineGun:OnUpdateAnimationInput(modelMixin)

    PROFILE("LightMachineGun:OnUpdateAnimationInput")
    
    ClipWeapon.OnUpdateAnimationInput(self, modelMixin)
    
    modelMixin:SetAnimationInput("gl", false)
    
end

function LightMachineGun:OverrideWeaponName()
    return "rifle"
end

function LightMachineGun:GetAmmoPackMapName()
    return RifleAmmo.kMapName
end

if Client then

    function LightMachineGun:OnClientPrimaryAttackStart()
    
        Shared.PlaySound(self, kAttackSoundName)
        
        local player = self:GetParent()
        
        if not self.muzzleCinematic then            
            CreateMuzzleEffect(self)                
        elseif player then
        
            local cinematicName = kMuzzleCinematics[math.ceil(self.soundType / 3)]
            local useFirstPerson = player:GetIsLocalPlayer() and player:GetIsFirstPerson()
            
            if cinematicName ~= self.activeCinematicName or self.firstPersonLoaded ~= useFirstPerson then
            
                DestroyMuzzleEffect(self)
                CreateMuzzleEffect(self)
                
            end
            
        end
            
        // CreateMuzzleCinematic() can return nil in case there is no parent or the parent is invisible (for alien commander for example)
        if self.muzzleCinematic then
            self.muzzleCinematic:SetIsVisible(true)
        end
        
    end
    
    // needed for first person muzzle effect since it is attached to the view model entity: view model entity gets cleaned up when the player changes (for example becoming a commander and logging out again) 
    // this results in viewmodel getting destroyed / recreated -> cinematic object gets destroyed which would result in an invalid handle.
    function LightMachineGun:OnParentChanged(oldParent, newParent)
        
        ClipWeapon.OnParentChanged(self, oldParent, newParent)
        DestroyMuzzleEffect(self)
        
    end
    
    function LightMachineGun:OnClientPrimaryAttackEnd()
    
        // Just assume the looping sound is playing.
        Shared.StopSound(self, kAttackSoundName)
        Shared.PlaySound(self, kEndSound)
        
        if self.muzzleCinematic then
            self.muzzleCinematic:SetIsVisible(false)
        end
        
    end
    
    function LightMachineGun:GetPrimaryEffectRate()
        return 0.08
    end
    
    function LightMachineGun:GetBarrelPoint()
    
        local player = self:GetParent()
        if player then
        
            local origin = player:GetEyePos()
            local viewCoords= player:GetViewCoords()
            
            return origin + viewCoords.zAxis * 0.4 + viewCoords.xAxis * -0.15 + viewCoords.yAxis * -0.22
            
        end
        
        return self:GetOrigin()
        
    end
    
end

Shared.LinkClassToMap("LightMachineGun", LightMachineGun.kMapName, networkVars)