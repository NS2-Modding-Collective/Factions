//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Factions_GUIIronSight.lua

Script.Load("lua/GUIAnimatedScript.lua")

class 'Factions_GUIIronSight' (GUIAnimatedScript)

Factions_GUIIronSight.kBackgroundTexture = PrecacheAsset("ui/Factions/testing_ironsights.png")
Factions_GUIIronSight.kMaskTexture = PrecacheAsset("ui/Factions/white.png")

Factions_GUIIronSight.kBackgroundWidth = GUIScale(1500)
Factions_GUIIronSight.kBackgroundHeight = GUIScale(1500)
Factions_GUIIronSight.kBackgroundOffsetX = GUIScale(0)
Factions_GUIIronSight.kBackgroundOffsetY = GUIScale(0)

Factions_GUIIronSight.kMaxAlpha = 1
Factions_GUIIronSight.kMinAlpha = 0

function Factions_GUIIronSight:Initialize()

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Top, GUIItem.Top)
    self.background:SetPosition( Vector(0, 0, 0) ) 
	self.background:SetColor( Color(1, 1, 1, 0) )
    self.background:SetTexture(Factions_GUIIronSight.kBackgroundTexture)
    //self.background:SetLayer(kGUILayerDebugText)    
    //self.background:SetShader("shaders/GUIWavy.surface_shader")
    //self.background:SetAdditionalTexture("wavyMask", Factions_GUIIronSight.kMaskTexture)
    self.background:SetIsVisible(false)
	
	// Control logic for fade in/out
	self.transitionTime = Rifle.kIronSightActivateTime
	
end
	
function Factions_GUIIronSight:Uninitialize()    

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
	self.background = nil
	
end

// Set the texture. All iron sight weapons should call this via IronSightMixin.
function Factions_GUIIronSight:SetTexture(texture)

	self.background:SetTexture(texture)
	
end

// Calculate the transition rate for the zoom in/out effect.
function Factions_GUIIronSight:SetTransitionTime(seconds)

	self.transitionTime = seconds

end

function Factions_GUIIronSight:ShowIronSight()

	self.background:SetIsVisible(true)
	self.background:FadeIn(self.transitionTime, nil, AnimateLinear, nil)
	
end

function Factions_GUIIronSight:HideIronSight()

	local hideFunc = function() self.background:SetIsVisible(false) end
	self.background:FadeOut(self.transitionTime, nil, AnimateLinear, hideFunc)
	
end
