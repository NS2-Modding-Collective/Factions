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

// Load utility functions
Script.Load("lua/Factions/Factions_Utility.lua")

// Load the upgrade base classes
Script.Load("lua/Factions/Factions_Upgrade.lua")
Script.Load("lua/Factions/Factions_WeaponUpgrade.lua")

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
		//MergeToTable(kAllFactionsUpgrades, Script.GetDerivedClasses("FactionsUpgrade"))
		MergeToTable(kAllFactionsUpgrades, Script.GetDerivedClasses("FactionsWeaponUpgrade"))
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
function UpgradeList:GetUpgradeByName(upgradeName)
    if upgradeName then
        for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
            if upgrade:GetUpgradeName() == upgradeName then
                return upgrade
            end
        end
    end
end

// TODO: Implement a cache here.
function UpgradeList:GetUpgradesByType(upgradeType)
	local upgradeClassList = {}

    if upgradeType then
        for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
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

function UpgradeList:ResetNonPermanentUpgrades()
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if not upgrade:GetIsPermanent() then
			upgrade:ResetLevel()
		end
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

function UpgradeList:UpdateUpgradeFromNetwork(upgradeUpdateTable)

    local upgradeId = upgradeUpdateTable.upgradeId
    local upgrade = self:GetUpgrade(upgradeId)
    
    if techNode ~= nil then
        ParseUpgradeUpdateMessage(techNode, upgradeUpdateTable)
    else
        Print("UpdateTechNodeFromNetwork(): Couldn't find technode with id %s, skipping update.", ToString(techId))
    end
    
    
end