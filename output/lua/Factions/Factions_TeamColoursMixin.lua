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
	teamColoursOwnerId = "entityid"
}

function TeamColoursMixin:__initmixin()
	self.teamColoursOwnerId = Entity.invalidId
end

function TeamColoursMixin:CopyPlayerDataFrom(player)

	self.factionsArmorColour = player.factionsArmorColour
	self.factionsBadassColour = player.factionsBadassColour

end

function TeamColoursMixin:OnOwnerChanged(oldOwner, newOwner)
    self.teamColoursOwnerId = Entity.invalidId
    if newOwner ~= nil then
        self.teamColoursOwnerId = newOwner:GetId()    
    end    
end


// Set the colour for the objects based on the team colours.
function TeamColoursMixin:OnUpdateRender()
	
	// Special thanks to double_hex for showing us how to do this!
	// Use an emissive map set in a material.
	local model = self:GetRenderModel()
	if model then

		// Added 
		if self.teamColoursOwnerId ~= Entity.invalidId then
			entity = Shared.GetEntity(self.teamColoursOwnerId)
		else
			entity = self
		end
		
		// Set the colours
		local teamColours = nil
		if entity.factionsBadassColour then
			teamColours = Color(math.random(), math.random(), math.random())
		elseif entity.factionsArmorColour ~= nil and (entity.factionsArmorColour.x > 0 or entity.factionsArmorColour.y > 0 or entity.factionsArmorColour.z > 0) then
			teamColours = Color(entity.factionsArmorColour.x, entity.factionsArmorColour.y, entity.factionsArmorColour.z)
		else
			if entity:GetTeamNumber() == kTeam2Index then
				teamColours = kAlienTeamColorFloat
			else
				teamColours = kMarineTeamColorFloat
			end
		end
		
		if not self.teamColourMaterial then
			self.teamColourMaterial = AddMaterial(model, "materials/team_colours.material")
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