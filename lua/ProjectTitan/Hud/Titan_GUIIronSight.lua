//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_GUIIronSight.lua

Script.Load("lua/GUIAnimatedScript.lua")

class 'GUIIronSight' (GUIAnimatedScript)

GUIIronSight.kBackgroundTexture = PrecacheAsset("ui/ProjectTitan/testing_ironsights.png")
GUIIronSight.kMaskTexture = PrecacheAsset("ui/white.png")

GUIIronSight.kBackgroundWidth = GUIScale(1500)
GUIIronSight.kBackgroundHeight = GUIScale(1500)
GUIIronSight.kBackgroundOffsetX = GUIScale(0)
GUIIronSight.kBackgroundOffsetY = GUIScale(0)


function GUIIronSight:Initialize()

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Top, GUIItem.Top)
    self.background:SetPosition( Vector(0, 0, 0) ) 
    self.background:SetTexture(GUIIronSight.kBackgroundTexture)
    //self.background:SetLayer(kGUILayerDebugText)    
    self.background:SetShader("shaders/GUIWavy.surface_shader")
    self.background:SetAdditionalTexture("wavyMask", GUIIronSight.kMaskTexture)
    self.background:SetIsVisible(true)
	
    self:Update(0)
	
end
	
function GUIIronSight:Uninitialize()    

    GUI.DestroyItem(self.background)
	
end

function GUIIronSight:Update(deltaTime)

	local player = Client.GetLocalPlayer()
	
		if player.ironSightActive then
			self.background:SetIsVisible(true)
		else
			self.background:SetIsVisible(false)
		end
	
	end

end

function GUIIronSight:SetIronSightTexture(texture)

	self.background:SetTexture(texture)
	
end
