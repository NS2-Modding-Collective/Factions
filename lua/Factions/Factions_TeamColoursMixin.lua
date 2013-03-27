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

TeamColoursMixin.expectedConstants =
{
}

TeamColoursMixin.networkVars =
{
	factionsArmorColour = "vector",
	factionsBadassColour  = "boolean",
}

function TeamColoursMixin:__initmixin()
	
end

function TeamColoursMixin:CopyPlayerDataFrom(player)

	self.factionsArmorColour = player.factionsArmorColour
	self.factionsBadassColour = player.factionsBadassColour

end


// Set the colour for the objects based on the team colours.
function TeamColoursMixin:OnUpdateRender()
	
	// Special thanks to double_hex for showing us how to do this!
	// Use an emissive map set in a material.
	local model = self:GetRenderModel()
	if model then
	
		// Set the colours
		local teamColours = nil
		if self.factionsBadassColour then
			teamColours = Color(math.random(), math.random(), math.random())
		elseif self.factionsArmorColour ~= nil and (self.factionsArmorColour.x > 0 or self.factionsArmorColour.y > 0 or self.factionsArmorColour.z > 0) then
			teamColours = Color(self.factionsArmorColour.x, self.factionsArmorColour.y, self.factionsArmorColour.z)
		else
			if self:GetTeamNumber() == kTeam2Index then
				teamColours = kAlienTeamColorFloat
			else
				teamColours = kMarineTeamColorFloat
			end
		end
		
		if not self.teamColourMaterial then
			self.teamColourMaterial = AddMaterial(model, "materials/test.material")
		end
		
		self.teamColourMaterial:SetParameter("colourR", teamColours.r)
		self.teamColourMaterial:SetParameter("colourG", teamColours.g)
		self.teamColourMaterial:SetParameter("colourB", teamColours.b)
		self.teamColourMaterial:SetParameter("intensity", TeamColoursMixin.intensity)
		
		if not self:GetIsAlive() and self.teamColourMaterial then
			if RemoveMaterial(model, self.teamColourMaterial) then
				self.teamColourMaterial = nil
			end
		end
			
	end

end