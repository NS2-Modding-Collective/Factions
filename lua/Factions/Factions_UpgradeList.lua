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
Script.Load("lua/Factions/Factions_Upgrade.lua")
Script.Load("lua/Factions/Factions_UnlockUpgrade.lua")
Script.Load("lua/Factions/Factions_WeaponUpgrade.lua")
Script.Load("lua/Factions/Factions_TimedUpgrade.lua")

// Used to merge all values from one table into another.
local function RegisterNewUpgrades(newValuesTable)

	for index, value in ipairs(newValuesTable) do
		// Save the factions upgrades in a regular table
		// Don't register the base classes.
		if not _G[value]:GetHideUpgrade() then
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
        Shared.GetMatchingFileNames( upgradeDirectory .. "*.lua", false, upgradeFiles)

        for _, upgradeFile in pairs(upgradeFiles) do
            Script.Load(upgradeFile)      
        end
        
        // save all upgrades in a table
        kAllFactionsUpgrades = {}
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsWeaponUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsUnlockUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("FactionsTimedUpgrade"))
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

function UpgradeList:GetAvailableUpgradesByType(playerClass, upgradeType)
	local upgradeClassList = {}

    if upgradeType then
        for upgradeId, upgrade in pairs(self:GetAvailableUpgrades(playerClass)) do
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

function UpgradeList:GetAvailableUpgrades(playerClass)
	local availableUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAvailableUpgradesByClass(playerClass)) do
		if self:GetHasPrerequisites(upgrade) then
			table.insert(availableUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return availableUpgrades
end

// TODO: Implement a cache here.
function UpgradeList:GetAvailableUpgradesByClass(playerClass)
	local availableUpgrades = {}
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if playerClass:GetIsUpgradeAllowed(upgrade) then
			table.insert(availableUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return availableUpgrades
end

function UpgradeList:CopyUpgradeDataFrom(cloneList)
	for index, upgrade in pairs(cloneList:GetAllUpgrades()) do
		local cloneUpgrade = self:GetUpgradeById(upgrade:GetId())
		cloneUpgrade:SetLevel(upgrade:GetCurrentLevel())
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