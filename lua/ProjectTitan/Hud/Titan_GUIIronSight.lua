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
Titan_GUIIronSight.kMaskTexture = PrecacheAsset("ui/ProjectTitan/white.png")

Titan_GUIIronSight.kBackgroundWidth = GUIScale(1500)
Titan_GUIIronSight.kBackgroundHeight = GUIScale(1500)
Titan_GUIIronSight.kBackgroundOffsetX = GUIScale(0)
Titan_GUIIronSight.kBackgroundOffsetY = GUIScale(0)

Titan_GUIIronSight.kMaxAlpha = 1
Titan_GUIIronSight.kMinAlpha = 0

function Titan_GUIIronSight:Initialize()

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Top, GUIItem.Top)
    self.background:SetPosition( Vector(0, 0, 0) ) 
	self.background:SetColor( Color(1, 1, 1, 0) )
    self.background:SetTexture(Titan_GUIIronSight.kBackgroundTexture)
    //self.background:SetLayer(kGUILayerDebugText)    
    //self.background:SetShader("shaders/GUIWavy.surface_shader")
    //self.background:SetAdditionalTexture("wavyMask", Titan_GUIIronSight.kMaskTexture)
    self.background:SetIsVisible(false)
	
	// Control logic for fade in/out
	self.transitionTime = Rifle.kIronSightActivateTime
	
end
	
function Titan_GUIIronSight:Uninitialize()    

    GUI.DestroyItem(self.background)
	
end

// Set the texture. All iron sight weapons should call this via IronSightMixin.
function Titan_GUIIronSight:SetTexture(texture)

	self.background:SetTexture(texture)
	
end

// Calculate the transition rate for the zoom in/out effect.
function Titan_GUIIronSight:SetTransitionTime(seconds)

	self.transitionTime = seconds

end

function Titan_GUIIronSight:ShowIronSight()

	self.background:SetIsVisible(true)
	self.background:FadeIn(self.transitionTime, nil, AnimateLinear, nil)
	
end

function Titan_GUIIronSight:HideIronSight()

	local hideFunc = function() self.background:SetIsVisible(false) end
	self.background:FadeOut(self.transitionTime, nil, AnimateLinear, hideFunc)
	
end
