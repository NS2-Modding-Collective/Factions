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

function Marine:GetShowGhostModel()
    
	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon:GetShowGhostModel()
	end
	
	return false
	
end    

function Marine:GetGhostModelTechId()

	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon:GetGhostModelTechId()
	end
	
end

function Marine:GetGhostModelCoords()

	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon:GetGhostModelCoords()
	end

end

function Marine:GetLastClickedPosition()

	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon.lastClickedPosition
	end
	
end

function Marine:GetIsPlacementValid()

	local weapon = self:GetActiveWeapon()
	if weapon and weapon:isa("MarineStructureAbility") then
		return weapon:GetIsPlacementValid()
	end

end

