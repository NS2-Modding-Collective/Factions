//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_TeamColoursMixin.lua

Script.Load("lua/FunctionContracts.lua")

Shared.PrecacheSurfaceShader("shaders/team_colours.surface_shader")

TeamColoursMixin = CreateMixin( TeamColoursMixin )
TeamColoursMixin.type = "TeamColours"

TeamColoursMixin.intensity = 0.25

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
	
	local model = self:GetRenderModel()
	if model then
	
		local teamColours = nil
		if self:GetTeamNumber() == kTeam2Id then
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
			
	end

end