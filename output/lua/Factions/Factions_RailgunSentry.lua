//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_RailgunSentry.lua

Script.Load("lua/Sentry.lua")
Script.Load("lua/ExtraEntitiesMod/ScaledModelMixin.lua")

class 'RailgunSentry' (Sentry)

RailgunSentry.kMapName = "railgunsentry"

// Load the best model that we can (some servers may not have Assets2)
local kModelName = Sentry.kModelName
local kBestModelName = "models/marine/railgun_sentry/railgun_sentry.model"
local f=io.open(kBestModelName,"r")
if f ~= nil then
	io.close(f)
	f = nil
	kModelName = PrecacheAsset(kBestModelName)
end

RailgunSentry.kModelName = kModelName
local kAnimationGraph = PrecacheAsset("models/marine/sentry/sentry.animation_graph")
RailgunSentry.kScale = Vector(1.0, 1.0, 1.0)

local networkVars = 
{
}

AddMixinNetworkVars(ScaledModelMixin, networkVars)

function RailgunSentry:OnInitialized()
	Sentry.OnInitialized(self)

	InitMixin(self, ScaledModelMixin)
	
	self.scale = MiniArmory.kScale
	
	self:SetScaledModel(MiniArmory.kModelName, MiniArmory.kAnimationGraph)
end

if Server then
	function RailgunSentry:GetAcquireTime()
    	return Sentry.kTargetAcquireTime * 2
    end
    
    function RailgunSentry:GetBaseRateOfFire()
    	return kRailgunSentryAttackBaseROF
    end
    
    function RailgunSentry:GetRandomRateOfFire()
    	return kRailgunSentryAttackRandROF
    end
end

Shared.LinkClassToMap("RailgunSentry", RailgunSentry.kMapName, networkVars)