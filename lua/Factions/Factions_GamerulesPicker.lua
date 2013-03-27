//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GamerulesPicker.lua

Script.Load("lua/Factions/Factions_GamerulesPicker_Global.lua")
Script.Load("lua/Entity.lua")

class 'GamerulesPicker' (Entity)

GamerulesPicker.kMapName = "factions_gamerules_picker"

local networkVars =
{
}

if Server then
	
	function GamerulesPicker:OnCreate()
		// Set global gamerules picker whenever gamerules pickers are built
        SetGamerulesPicker(self)
	end
	
	function GamerulesPicker:GetGameType()
		if self.gameType == nil then
			return kFactionsGameType.CombatDeathmatch
		else
			return self.gameType
		end
	end
	
	function GamerulesPicker:GetGamerulesMapName()
		if self.gameType == nil then
			return CombatDeathmatchGamerules.kMapName
		else
			if self.gameType == kFactionsGameType.CombatDeathmatch then
				return CombatDeathmatchGamerules.kMapName
			elseif self.gameType == kFactionsGameType.Horde then
				return HordeGamerules.kMapName
			end
		end
	end
	
end

Shared.LinkClassToMap("GamerulesPicker", GamerulesPicker.kMapName, networkVars)