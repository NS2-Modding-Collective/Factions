//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineChops.lua

Script.Load("lua/Marine.lua")
Script.Load("lua/Factions/Factions_AttachModel.lua")

class 'MarineChops' (Marine)

MarineChops.kMapName = "marine_chops"

MarineChops.kModelName =  PrecacheAsset("models/marine/male/male_new.model")
MarineChops.kStrippedModelName =  PrecacheAsset("models/marine/male/male_stripped.model")
MarineChops.kHelmetModelName =  PrecacheAsset("models/marine/male/armor_helmet1.model")

/* Attach points
Ice: attach_point"JetPack"
attach_point"RHand_Weapon"
attach_point"LArm_ShldrPad1"
attach_point"RArm_ShldrPad1"
attach_point"LArm_ForearmPad"
attach_point"RArm_ForearmPad"
attach_point"LArm_Wrist01"
attach_point"RArm_Wrist01"
attach_point"Head"
attach_point"Spine3"
attach_point"Crotch"
attach_point"LLeg_Hip"
attach_point"RLeg_Hip"
attach_point"LLeg_Knee"
attach_point"RLeg_Knee"
attach_point"LLeg_Kneecap"
attach_point"RLeg_Kneecap"
attach_point"LLeg_Ankle"
attach_point"RLeg_Ankle"
attach_point"RLeg_Pack"

*/


local networkVars = 
{
}


function MarineChops:OnCreate()
    Marine.OnCreate(self)
end


function MarineChops:OnInitialized()
    Marine.OnInitialized(self)
    self:SetModel(MarineChops.kStrippedModelName, Marine.kMarineAnimationGraph)
    if Server then
    
        // skulk backpack , scaled etc so it looks good^^
        //self:AddAttachedModel(Skulk.kModelName, Jetpack.kAttachPoint, Vector(0,0.5,-0.5) , Vector(0.5,0.5,0.5), Angles(90,0,0))   

        // turret on shoulder
        //self:AddAttachedModel(Sentry.kModelName, nil, "LArm_ShldrPad1", nil , Vector(0.5,0.5,0.5), Angles(0,90,-90))   
        
        // cyst head
        //self:AddAttachedModel(Cyst.kModelName , Cyst.kAnimationGraph, "Head", Vector(0.5,0,0) , Vector(0.4,0.4,0.4), Angles(0,0,-90))
        
        // turret also at head, more models are posible
        //self:AddAttachedModel(Sentry.kModelName , nil, "Head", Vector(0.5,0,0) , Vector(0.4,0.4,0.4), Angles(0,0,-90))
        
        // flamethrower on back
        //self:AddAttachedModel(Flamethrower.kModelName , nil, "Spine3", Vector(0,-0.2,-0.18) , Vector(0.5, 0.5, 0.5), Angles( math.pi / 2, math.pi,180))   
        
        // gorge plushi on hip
        //self:AddAttachedModel(AttachModel.arcadeGorge , nil, "LLeg_Hip", Vector(0.2, 0.2, 0), Vector(1.2 ,1.2, 1.2), Angles(4,3,6))
        
        self:AddAttachedModel(MarineChops.kHelmetModelName , nil, "Head", Vector(0, -0.1, 0), nil, Angles(0, 3, 1.5))               
        
    end
end


function MarineChops:MakeSpecialEdition()
end


Shared.LinkClassToMap("MarineChops", MarineChops.kMapName, networkVars)

