//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UpgradeList.lua

class 'UpgradeList'

function UpgradeList:CreateUpgradeFromNetwork(techNodeBaseTable)
    
    local techNode = TechNode()
    
    ParseTechNodeBaseMessage(techNode, techNodeBaseTable)
    
    self:AddNode(techNode)
    
end

function TechTree:UpdateUpgradeFromNetwork(techNodeUpdateTable)

    local techId = techNodeUpdateTable.techId
    local techNode = self:GetTechNode(techId)
    
    if techNode ~= nil then
        ParseTechNodeUpdateMessage(techNode, techNodeUpdateTable)
    else
        Print("UpdateTechNodeFromNetwork(): Couldn't find technode with id %s, skipping update.", ToString(techId))
    end
    
    
end