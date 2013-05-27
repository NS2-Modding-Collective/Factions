//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineSpectator.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

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
    
    // Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
    
end

Class_Reload("MarineSpectator", networkVars)