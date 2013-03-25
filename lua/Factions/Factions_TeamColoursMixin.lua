//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TeamColoursMixin.lua

Script.Load("lua/FunctionContracts.lua")

Shared.PrecacheSurfaceShader("shaders/team_colours.surface_shader")

TeamColoursMixin = CreateMixin( TeamColoursMixin )
TeamColoursMixin.type = "TeamColours"

TeamColoursMixin.intensity = 0.2

TeamColoursMixin.expectedMixins =
{
	Team = "For checking which team the entity belongs to",
}

TeamColoursMixin.expectedCallbacks =
{
}

// TeamColoursMixin:GetHasSecondary should completely override any existing
// GetHasSecondary function defined in the object.
TeamColoursMixin.overrideFunctions =
{
}

TeamColoursMixin.expectedConstants =
{
}

TeamColoursMixin.networkVars =
{
}

function TeamColoursMixin:__initmixin()

end

// Set the colour for the objects based on the team colours.
function TeamColoursMixin:OnUpdateRender()
	
	// Special thanks to double_hex for showing us how to do this!
	// Use an emissive map set in a material.
	local model = self:GetRenderModel()
	if model then
	
		local teamColours = nil
		if self:GetTeamNumber() == kTeam2Index then
			teamColours = kAlienTeamColorFloat
		else
			teamColours = kMarineTeamColorFloat
		end
		
		if not self.teamColourMaterial then
			self.teamColourMaterial = AddMaterial(model, "materials/test.material")
			self.teamColourMaterial:SetParameter("colourR", teamColours.r)
			self.teamColourMaterial:SetParameter("colourG", teamColours.g)
			self.teamColourMaterial:SetParameter("colourB", teamColours.b)
			self.teamColourMaterial:SetParameter("intensity", TeamColoursMixin.intensity)
		end
		
		if not self:GetIsAlive() and self.teamColourMaterial then
			if RemoveMaterial(model, self.teamColourMaterial) then
				self.teamColourMaterial = nil
			end
		end
			
	end

end