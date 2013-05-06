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
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LightMachineGun.lua

Script.Load("lua/Weapons/Marine/Rifle.lua")
Script.Load("lua/Factions/Weapons/Factions_IronSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_ClipSizeMixin.lua")

class 'LightMachineGun' (Rifle)

LightMachineGun.kMapName = "lmg"

LightMachineGun.kModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun.model")
local kViewModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.animation_graph")

LightMachineGun.kIronSightTexture = "ui/Factions/testing_ironsights.png"
LightMachineGun.kIronSightZoomFOV = 80
LightMachineGun.kIronSightActivateTime = 0.1

LightMachineGun.kLaserSightWorldModelAttachPoint = "fxnode_riflemuzzle"
LightMachineGun.kLaserSightViewModelAttachPoint = "fxnode_riflemuzzle"

// 4 degrees in NS1
local kSpread = ClipWeapon.kCone5Degrees

local kNumberOfVariants = 3

local kAttackSoundName = PrecacheAsset("sound/NS2.fev/marine/structures/sentry_fire_loop")
local kEndSound = PrecacheAsset("sound/NS2.fev/marine/structures/sentry_spin_down")

local kMuzzleCinematics = {
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash.cinematic"),
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash2.cinematic"),
    PrecacheAsset("cinematics/marine/rifle/muzzle_flash3.cinematic"),
}

local networkVars =
{
}

AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(IronSightMixin, networkVars)
AddMixinNetworkVars(LaserSightMixin, networkVars)
AddMixinNetworkVars(ClipSizeMixin, networkVars)

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

// Don't inherit this from Rifle. We are going to initialise mixins our own way
function LightMachineGun:OnCreate()

    ClipWeapon.OnCreate(self)
    
    InitMixin(self, PickupableWeaponMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LiveMixin)
    
    if Client then
        InitMixin(self, ClientWeaponEffectsMixin)
    elseif Server then
        self.soundVariant = Shared.GetRandomInt(1, kNumberOfVariants)
        self.soundType = self.soundVariant
	end
	
	local ironSightParameters = { kIronSightTexture = LightMachineGun.kIronSightTexture,
								  kIronSightZoomFOV = LightMachineGun.kIronSightZoomFOV,
								  kIronSightActivateTime = LightMachineGun.kIronSightActivateTime }
	InitMixin(self, IronSightMixin, ironSightParameters)
		
	assert(HasMixin(self, "IronSight"))
		
	local laserSightParameters = { kLaserSightWorldModelAttachPoint = LightMachineGun.kLaserSightWorldModelAttachPoint,
								   kLaserSightViewModelAttachPoint = LightMachineGun.kLaserSightViewModelAttachPoint }
	InitMixin(self, LaserSightMixin, laserSightParameters)
	
	assert(HasMixin(self, "LaserSight"))
	
	local clipSizeParameters = { kBaseClipSize = kLightMachineGunClipSize,
								 kClipSizeIncrease = 10, }
	InitMixin(self, ClipSizeMixin, clipSizeParameters)

	assert(HasMixin(self, "VariableClipSize"))	
    
end

function LightMachineGun:GetAnimationGraphName()
    return kAnimationGraph
end

function LightMachineGun:GetViewModelName()
    return kViewModelName
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

function LightMachineGun:GetWeight()
    return kLightMachineGunWeight
end

function LightMachineGun:GetBarrelSmokeEffect()
    return LightMachineGun.kBarrelSmokeEffect
end

function LightMachineGun:GetShellEffect()
    return chooseWeightedEntry ( LightMachineGun.kShellEffectTable )
end

function LightMachineGun:OverrideWeaponName()
    return "rifle"
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
    
    function LightMachineGun:OnClientPrimaryAttackEnd()
    
        // Just assume the looping sound is playing.
        Shared.StopSound(self, kAttackSoundName)
        Shared.PlaySound(self, kEndSound)
        
        if self.muzzleCinematic then
            self.muzzleCinematic:SetIsVisible(false)
        end
        
    end
    function Rifle:GetUIDisplaySettings()
        return { xSize = 256, ySize = 417, script = "lua/GUIRifleDisplay.lua" }
    end
end

Shared.LinkClassToMap("LightMachineGun", LightMachineGun.kMapName, networkVars)