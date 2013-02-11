//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_IronSightViewerMixin.lua

Script.Load("lua/FunctionContracts.lua")

IronSightViewerMixin = CreateMixin( IronSightViewerMixin )
IronSightViewerMixin.type = "IronSightViewer"

IronSightViewerMixin.expectedMixins =
{
}

IronSightViewerMixin.expectedCallbacks =
{
}

IronSightViewerMixin.expectedConstants =
{
}

IronSightViewerMixin.networkVars =
{
}

function IronSightViewerMixin:__initmixin()

    if Client and Client.GetLocalPlayer() == self then
        self.ironSightGUI = GetGUIManager():CreateGUIScript("Factions/Hud/Factions_GUIIronSight")
    end

end

function IronSightViewerMixin:OnKillClient()

	if self.ironSightGUI then
    
        GetGUIManager():DestroyGUIScript(self.ironSightGUI)
        self.ironSightGUI = nil
        
    end

end

function IronSightViewerMixin:OnDestroy()

	if self.ironSightGUI then
    
        GetGUIManager():DestroyGUIScript(self.ironSightGUI)
        self.ironSightGUI = nil
        
    end

end