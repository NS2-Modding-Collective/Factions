//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

LogicMixin = CreateMixin( LogicMixin )
LogicMixin.type = "Logic"

// table with all logic entities in it
local kLogicEntityList = {}
local kLogicEntitiesSearched = false

LogicMixin.expectedMixins =
{
}

LogicMixin.expectedCallbacks =
{
    OnLogicTrigger = "Called when the entity is output of a timer etc."
}


LogicMixin.optionalCallbacks =
{
    GetOutputNames = "Gives the names of the output entities back which should be triggered."
}


LogicMixin.networkVars =  
{
}

local function searchEntities(self)
    // clear the entity list and rewrite it
    kLogicEntityList = {}
    for index, entity in ipairs(GetEntitiesWithMixin("Logic")) do
        table.insert(kLogicEntityList, {
                                    name = entity.name,
                                    id = entity:GetId(),
                                    } )
    end
    kLogicEntitiesSearched = true
end


function LogicMixin:__initmixin() 
    self.initialEnabled = self.enabled
    table.insert(kLogicEntityList, {
                                    name = self.name,
                                    id = self:GetId(),
                                    } )
                                    
    if self.GetOutputNames and #self:GetOutputNames() == 0 then
        Print("Error: " .. self.name .. ": No Output-Entity declared")
    end
end

function LogicMixin:Reset() 
    self.enabled = self.initialEnabled
    kLogicEntitiesSearched = false
end

function LogicMixin:TriggerOutputs(names)   
 
    local retryTriggerEntities = {}
    for i, name in ipairs(names or self:GetOutputNames()) do 
        local entity
        for l, logicEntity in ipairs(kLogicEntityList) do
            if name == logicEntity.name then
                entity = Shared.GetEntity(logicEntity.id)
                break
            end
        end    
        if entity then
            if  HasMixin(entity, "Logic") then
                entity:OnLogicTrigger()
            else
                Print("Error: Entity " .. name .. " has no Logic function!")
            end
        else
            if kLogicEntitiesSearched then
                Print("Error: Can't find " .. name .. " !")
            else
                // Try to search the entities again (doors sometimes change their id)
               searchEntities(self) 
               table.insert(retryTriggerEntities, name)
            end
        end
    end

    if #retryTriggerEntities > 0 then
        self:TriggerOutputs(retryTriggerEntities)
    end
end

function LogicMixin:SetFindEntity()
    table.insert(kFindEntitiesAfterLoad, self:GetId())
end

// needed when we have more than 1 output
function LogicMixin:GetUsedOutputs()
    local outputs = {}
    for i, output in ipairs(self.possibleOutputs) do
        if output ~= "" then
            table.insert(outputs, output)
        end
    end
    
    return outputs
end