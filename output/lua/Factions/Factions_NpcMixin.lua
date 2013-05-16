//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NpcMixin.lua

Script.Load("lua/ExtraEntitiesMod/npc/NpcMixin.lua")

if Server then

	function NpcMixin:SetBaseDifficulty()
		local baseDifficulty = 0
		if self.baseDifficulty then 
			baseDifficulty = self.baseDifficulty
		end
		
		local gameDifficulty = 0
		if GetGamerules().GetDifficulty then
			gameDifficulty = GetGamerules():GetDifficulty()
		end	
		
		self.difficulty = baseDifficulty + gameDifficulty
		Shared.Message("Spawned a " .. self:GetClassName() .. " at base difficulty " .. baseDifficulty)
		Shared.Message("Spawned a " .. self:GetClassName() .. " at base + game (actual) difficulty " .. self.difficulty)
		if HasMixin(self, "Xp") then
			self:SetLevel(self.difficulty)
			// Apply any new level tied upgrades.
			self:ApplyLevelTiedUpgrades()
		end
	end

	function NpcMixin:ApplyNpcUpgrades()
		if self.npcUpgrades and HasMixin(self, "UpgradeMixin") then
			Shared.Message("npc Upgrades: " .. self.npcUpgrades)
			for index, upgradeName in ipairs(self:ParseNpcUpgrades(self.npcUpgrades)) do
				local upgrade = self:GetUpgradeByName(upgradeName)
				if upgrade then
					Shared.Message("Gave the " .. upgradeName .. " upgrade")
					player:BuyUpgrade(upgrade:GetId(), true)
				end
			end
		end
	end
	
	function NpcMixin:ParseNpcUpgrades(upgradeString)
		upgradeList = {}
		for word in upgradeString:gmatch("%S+") do
			table.insert(upgradeList, word) 
		end
		return upgradeList
	end

end