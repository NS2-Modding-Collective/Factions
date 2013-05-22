//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UpgradeList.lua

// Detail about the different kinds of upgrades.
kAllFactionsUpgrades = {}
kFactionsUpgrade = {}

// Load utility functions
Script.Load("lua/Factions/Factions_Utility.lua")

// Load the upgrade base classes
Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_AlienClassUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_AlienUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_UnlockUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_WeaponUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_TimedUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_DropUpgrade.lua")
Script.Load("lua/Factions/BaseUpgrades/Factions_LevelTiedUpgrade.lua")

// Used to merge all values from one table into another.
local function RegisterNewUpgrades(newValuesTable)

	for index, value in ipairs(newValuesTable) do
		// Save the factions upgrades in a regular table
		// Don't register the base classes.
		local instantiatedUpgrade = _G[value]()
		instantiatedUpgrade:Initialize()
		if not instantiatedUpgrade:GetIsBaseUpgrade() then
			table.insert(kAllFactionsUpgrades, value)
		end
		
		// Also save them in an enum so that we can refer to them directly by ID
		local enumTable = {}
		for index, value in ipairs(kFactionsUpgrade) do
			table.insert(enumTable, value)
		end
		table.insert(enumTable, value)
		kFactionsUpgrade = enum(enumTable)
	end

end

// build the upgrade list
local function BuildAllUpgrades()

    if #kAllFactionsUpgrades == 0 then
        // load all upgrade files
        local upgradeFiles = { }
        local upgradeDirectory = "lua/Factions/Upgrades/"
        Shared.GetMatchingFileNames( upgradeDirectory .. "*.lua", true, upgradeFiles)

        for _, upgradeFile in pairs(upgradeFiles) do
            Script.Load(upgradeFile)      
        end
        
        // save all upgrades in a table
        kAllFactionsUpgrades = {}
        RegisterNewUpgrades(Script.GetDerivedClasses("AlienClassUpgrade"))
        RegisterNewUpgrades(Script.GetDerivedClasses("FactionsAlienUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsWeaponUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsUnlockUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsTimedUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsDropUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("LevelTiedUpgrade"))
    end
    
end

if #kAllFactionsUpgrades == 0 then
    BuildAllUpgrades()
end

class 'UpgradeList'

function UpgradeList:Initialize()
	self.UpgradeTable = {}

	for i, upgrade in ipairs(kAllFactionsUpgrades) do
		local newUpgrade = _G[upgrade]()
		newUpgrade:Initialize()
		self.UpgradeTable[newUpgrade:GetId()] = newUpgrade
    end
end

function UpgradeList:GetUpgradeById(upgradeId)
    if upgradeId then
        return self.UpgradeTable[upgradeId]
    end
end

// TODO: Implement a cache here.
function UpgradeList:GetUpgradeByClassName(upgradeClassName)
    if upgradeClassName then
        for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
            if upgrade:GetClassName() == upgradeClassName then
                return upgrade
            end
        end
    end
end

// TODO: Implement a cache here.
function UpgradeList:GetUpgradeByName(upgradeName)
    if upgradeName then
        for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
            if upgrade:GetUpgradeName() == upgradeName then
                return upgrade
            end
        end
    end
end

// Todo: Caching
function UpgradeList:GetUpgradesBySlot(upgradeSlot)
	local upgradeSlotList = {}

    if upgradeSlot then
        for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
            if upgradeSlot == upgrade:GetUniqueSlot() then
                table.insert(upgradeSlotList, upgrade)
            end
        end
    end
	
	return upgradeSlotList
end


function UpgradeList:GetAvailableUpgradesByType(playerClass, playerTeamNumber, upgradeType)
	local upgradeClassList = {}

    if upgradeType then
        for upgradeId, upgrade in pairs(self:GetAvailableUpgrades(playerClass, playerTeamNumber)) do
            if upgradeType == kFactionsUpgradeTypes[upgrade:GetUpgradeType()] then
                table.insert(upgradeClassList, upgrade)
            end
        end
    end
	
	return upgradeClassList
end

function UpgradeList:GetAllUpgrades()
	return self.UpgradeTable
end

function UpgradeList:SetUpgradeLevel(upgradeId, upgradeLevel)
	local upgrade = self:GetUpgradeById(upgradeId)
	local success = false
	if upgrade then
		upgrade:SetLevel(upgradeLevel)
		success = true
	end
	
	return success	
end

function UpgradeList:GetHasUpgrade(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
	if upgrade and upgrade:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end

function UpgradeList:GetUpgradeLevel(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
	if upgrade then 
		return upgrade:GetCurrentLevel()
	else
		return 0
	end
end

function UpgradeList:GetHasPrerequisites(upgrade)
	local requirements = upgrade:GetRequirements()
	for index, requirement in ipairs(requirements) do
		local requirementId = self:GetUpgradeByClassName(requirement):GetId()
		if not self:GetHasUpgrade(requirementId) then
			return false
		end
	end
	
	return true
end

function UpgradeList:GetAvailableUpgrades(playerClass, playerTeamNumber)
	local availableUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if  (playerClass and playerClass:GetIsUpgradeAllowed(upgrade)
		    or
			(playerClass == nil))
			and self:GetHasPrerequisites(upgrade)
			and upgrade:GetIsAllowedForTeam(playerTeamNumber) then
			
			table.insert(availableUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return availableUpgrades
end

// Get all the upgrades which are tied to the player's level and automatically increase.
function UpgradeList:GetLevelTiedUpgrades(playerClass, playerTeamNumber)
	local levelTiedUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAvailableUpgrades(playerClass, playerTeamNumber)) do
	
		if  upgrade:GetIsTiedToPlayerLvl() then
			
			table.insert(levelTiedUpgrades, upgrade)
			
		end
		
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return levelTiedUpgrades
end

function UpgradeList:GetActiveUpgrades()
	local activeUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 then
			table.insert(activeUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return activeUpgrades
end

function UpgradeList:CopyUpgradeDataFrom(cloneList)
	if cloneList then
		table.clear(self.UpgradeTable)
		table.copy(cloneList.UpgradeTable, self.UpgradeTable)
		table.clear(cloneList.UpgradeTable)
	end
end

function UpgradeList:GetActiveUpgrades()
	local activeUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 then
			table.insert(activeUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return activeUpgrades
end