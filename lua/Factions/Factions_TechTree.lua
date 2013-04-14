//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TechTree.lua

local networkVars = 
{
}

// Unlock all abilities.
function TechTree:ResearchAll(dontResearchTech)

	for index, node in pairs(self.nodeList) do
		if not dontResearchTech[node:GetTechId()] then		
			node:SetResearched(true)
			node.available = true
			self:SetTechNodeChanged(node)
		end
	end
	
	self:ComputeAvailability()
	
end

Class_Reload("TechTree", networkVars)