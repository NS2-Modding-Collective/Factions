//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Titan_GUIIronSight.lua

Script.Load("lua/GUIAnimatedScript.lua")

class 'Titan_GUIIronSight' (GUIAnimatedScript)

Titan_GUIIronSight.kBackgroundTexture = PrecacheAsset("ui/ProjectTitan/testing_ironsights.png")
Titan_GUIIronSight.kMaskTexture = PrecacheAsset("ui/white.png")

Titan_GUIIronSight.kBackgroundWidth = GUIScale(1500)
Titan_GUIIronSight.kBackgroundHeight = GUIScale(1500)
Titan_GUIIronSight.kBackgroundOffsetX = GUIScale(0)
Titan_GUIIronSight.kBackgroundOffsetY = GUIScale(0)


function Titan_GUIIronSight:Initialize()

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Top, GUIItem.Top)
    self.background:SetPosition( Vector(0, 0, 0) ) 
    self.background:SetTexture(Titan_GUIIronSight.kBackgroundTexture)
    //self.background:SetLayer(kGUILayerDebugText)    
    self.background:SetShader("shaders/GUIWavy.surface_shader")
    self.background:SetAdditionalTexture("wavyMask", Titan_GUIIronSight.kMaskTexture)
    self.background:SetIsVisible(true)
	
    self:Update(0)
	
end
	
function Titan_GUIIronSight:Uninitialize()    

    GUI.DestroyItem(self.background)
	
end

function Titan_GUIIronSight:Update(deltaTime)

	local player = Client.GetLocalPlayer()
	
	if player.ironSightStatus == kIronSightStatus.Active then
		self.background:SetIsVisible(true)
	else
		self.background:SetIsVisible(false)
	end

end

function Titan_GUIIronSight:SetIronSightTexture(texture)

	self.background:SetTexture(texture)
	
end
