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

local networkVars = {
}

local overrideOnUpdateRender = Marine.OnUpdateRender
function Marine:OnUpdateRender()

	overrideOnUpdateRender(self)
	
	if not GetGamerulesInfo():GetIsCompetitive() then
		HiveVision_SetEnabled( true )
		HiveVision_SyncCamera( gRenderCamera, self:isa("Commander") )
	end
	
end

function Marine:OverrideInput(input)

	// Always let the MarineStructureAbility override input, since it handles client-side-only build menu

	local buildAbility = self:GetWeapon(MarineStructureAbility.kMapName)

	if buildAbility then
		input = buildAbility:OverrideInput(input)
	end
	
	return Player.OverrideInput(self, input)
        
end

function Marine:UpdateGhostModel()

    self.currentTechId = nil
    self.ghostStructureCoords = nil
    self.ghostStructureValid = false
    self.showGhostModel = false
    
    local weapon = self:GetActiveWeapon()
	
	if weapon then
		if weapon:isa("MarineStructureAbility") then
		
			self.currentTechId = weapon:GetGhostModelTechId()
			self.ghostStructureCoords = weapon:GetGhostModelCoords()
			self.ghostStructureValid = weapon:GetIsPlacementValid()
			self.showGhostModel = weapon:GetShowGhostModel()

			return weapon:GetShowGhostModel()
			
		elseif weapon:isa("LayMines") then
    
			self.currentTechId = kTechId.Mine
			self.ghostStructureCoords = weapon:GetGhostModelCoords()
			self.ghostStructureValid = weapon:GetIsPlacementValid()
			self.showGhostModel = weapon:GetShowGhostModel()
    
		end	
	end

end

function Marine:GetShowGhostModel()
    return self.showGhostModel
end    

function Marine:GetGhostModelTechId()
    return self.currentTechId
end

function Marine:GetGhostModelCoords()
    return self.ghostStructureCoords
end

function Marine:GetIsPlacementValid()
    return self.ghostStructureValid
end

function Marine:GetLastClickedPosition()

	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon.lastClickedPosition
	end
	
end

Class_Reload("Marine", networkVars)