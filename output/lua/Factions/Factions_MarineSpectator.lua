//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineSpectator.lua

local networkVars = {
}
	
function MarineSpectator:OnCreate()

    TeamSpectator.OnCreate(self)
    //self:SetTeamNumber(1)
    
    InitMixin(self, ScoringMixin, { kMaxScore = kMaxScore })
    
    if Client then
        InitMixin(self, TeamMessageMixin, { kGUIScriptName = "GUIMarineTeamMessage" })
    end
    
end

function MarineSpectator:OnInitialized()

    TeamSpectator.OnInitialized(self)
    
    //self:SetTeamNumber(1)
    
end

Class_Reload("MarineSpectator", networkVars)