//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AttachModel.lua

Script.Load("lua/TeamMixin.lua")

class 'AttachModel' (ScriptActor)

AttachModel.kMapName = "attach_model"

AttachModel.arcadeGorge =  PrecacheAsset("models/props/descent/descent_arcade_gorgetoy_01.model")

local networkVars =
{   
    offset = "vector",
    scale = "vector",
    rotation = "angles",
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)

function AttachModel:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)    
  
    self:SetUpdates(true)    
end

function AttachModel:OnInitialized()  

    ScriptActor.OnInitialized(self)  
    
    if self.model then
        if self.animationGraph then
            self:SetModel(self.model, self.animationGraph)
        else
            self:SetModel(self.model)
        end
    end

end


function AttachModel:OnDestroy()   
    ScriptActor.OnDestroy(self)    
end


function AttachModel:GetPhysicsModelAllowedOverride()
    return false
end


/**
 * Only visible when the parent Marine is visible.
 */
function AttachModel:OnGetIsVisible(visibleTable, viewerTeamNumber)

    local parent = self:GetParent()
    if parent then
        visibleTable.Visible = parent:GetIsVisible()
    end
    
end

function AttachModel:OnAdjustModelCoords(modelCoords)
    
    if self.scale:GetLength() ~= 0 then
        modelCoords.xAxis = modelCoords.xAxis * self.scale.x
        modelCoords.yAxis = modelCoords.yAxis * self.scale.y
        modelCoords.zAxis = modelCoords.zAxis * self.scale.z
    end

    local rotationCoords = self.rotation:GetCoords()    
    // change the origin directly would orbit it around the model (rotation point would be still the same
    rotationCoords.origin = rotationCoords.origin + self.offset
    
    modelCoords = modelCoords * rotationCoords

    return modelCoords
end


function AttachModel:OnProcessMove(input)
end

// only getting updated when the model has an animation graph
function AttachModel:OnUpdateAnimationInput(modelMixin)
    local alive = false
    local parent = self:GetParent()
    if parent then
        alive = parent:GetIsAlive()
    end
    modelMixin:SetAnimationInput("alive", alive)
end


Shared.LinkClassToMap("AttachModel", AttachModel.kMapName, networkVars)