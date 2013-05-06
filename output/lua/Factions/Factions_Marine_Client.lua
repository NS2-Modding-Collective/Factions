//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Marine_Client.lua

Script.Load("lua/Factions/Hud/Factions_GUIExperienceBar.lua")

// New Xp bars
local overrideOnInitLocalClient = Marine.OnInitLocalClient
function Marine:OnInitLocalClient()

	overrideOnInitLocalClient(self)

    /*if self:GetTeamNumber() ~= kTeamReadyRoom then
        if self.marineXpBar == nil then
            self.marineXpBar = GetGUIManager():CreateGUIScript("Factions/Hud/Factions_GUIExperienceBar")
        end
    end*/
	
end

local overrideOnUpdateRender = Marine.OnUpdateRender
function Marine:OnUpdateRender()

	overrideOnUpdateRender(self)
	HiveVision_SetEnabled( true )
    HiveVision_SyncCamera( gRenderCamera, self:isa("Commander") )
	
end

local overrideOnKillClient = Marine.OnKillClient
function Marine:OnKillClient()

	overrideOnKillClient(self)

    /*if self.marineXpBar then        
        GetGUIManager():DestroyGUIScript(self.marineXpBar)
        self.marineXpBar = nil            
    end*/
	
end

