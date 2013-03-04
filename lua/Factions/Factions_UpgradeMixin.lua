//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UpgradeMixin.lua

// Detail about the different kinds of upgrades.
kUpgradeTypes = enum({'Ability', 'Attribute', 'Tech', 'Weapons'})
kAllFactionsUpgrades = {}
kAllFactionsUpgradesByType = {}
for index, upgradeType in ipairs(kUpgradeTypes) do
	kAllFactionsUpgradesByType[upgradeType] = {}
end

kUpgradeTypeStrings = {}
kUpgradeTypeStrings[kUpgradeTypes.Ability] = "Abilities"
kUpgradeTypeStrings[kUpgradeTypes.Ability] = "Attributes"
kUpgradeTypeStrings[kUpgradeTypes.Ability] = "Tech"
kUpgradeTypeStrings[kUpgradeTypes.Ability] = "Weapons"

// Kinds of triggers
kTriggerTypes = enum({'NoTrigger', 'ByTime', 'ByKey'})

// Load utility functions
Script.Load("lua/Factions/Factions_Utility.lua")

// Load the upgrade base classes
Script.Load("lua/Factions/Factions_Upgrade.lua")
Script.Load("lua/Factions/Factions_WeaponUpgrade.lua")

local function RegisterNewUpgrade(upgradeType, className)
	table.insert(kAllFactionsUpgrades, className)
	table.insert(kAllFactionsUpgradesByType[upgradeType], className)
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
		for index, classType in ipairs(Script.GetDerivedClasses("FactionsWeaponUpgrade")) do
			RegisterNewUpgrade(classType, _G[classType].name)
		end
    end
    
end

if #kAllFactionsUpgrades == 0 then
    BuildAllUpgrades()
end
  
UpgradeMixin = CreateMixin(UpgradeMixin)
UpgradeMixin.type = "Upgrade"

UpgradeMixin.networkVars =
{
}

UpgradeMixin.expectedMixins =
{
}

UpgradeMixin.expectedCallbacks =
{
}


function UpgradeMixin:__initmixin()
    if not self.UpgradeList then
        self.UpgradeList = {}
    end
end


function UpgradeMixin:Reset()
    // reset all upgrades 
    //self:ClearUpgrades()
end

function UpgradeMixin:CopyPlayerDataFrom(player)
    self.UpgradeList = player.UpgradeList
    Print(#player.UpgradeList)
        // give upgrades back
    if self:GetIsAlive() and self:GetTeamNumber() ~= kNeutralTeamType then
        for i, entry in ipairs(self.UpgradeList) do
            self:BuyUpgrade(self:GetUpgradeById(entry.upgrade), true)
        end
    end
end

function UpgradeMixin:BuyUpgrade(upgrade, giveBack)
    if Server then
        local upgradeOk = self:CheckUpgradeAvailability(upgrade) or giveBack
        if upgradeOk then        
			local success = upgrade:OnAdd(self)
		
            if success and not giveBack then
                self:SetUpgrade(upgrade, 1)
            end
        else
            self:SendDirectMessage("Upgrade not available")
        end
    elseif Client then
        // Send buy message to server
        Client.SendNetworkMessage("BuyUpgrade", BuildBuyUpgradeMessage(upgrade), true)
    end
end

function UpgradeMixin:SetUpgrade(upgrade, level)
    local upgradeId = upgrade:GetId()
    table.insert(self.UpgradeList, {
                                upgrade = upgradeId,
                                level = level})
    if Server then
        self:AddResources(-upgrade:GetCost())
        // send update to the client
        Server.SendNetworkMessage(self, "UpdateUpgrade",  BuildUpdateUpgradeMessage(upgradeId, level), true)  
    end 
   
end

function UpgradeMixin:ClearUpgrades()
    self.UpgradeList = {}
end


function UpgradeMixin:CheckUpgradeAvailability(upgrade)
    local hasUpgrade = self:HasUpgrade(upgrade)
    if not hasUpgrade or (hasUpgrade and (self:GetUpgradeLevel(upgrade, hasUpgrade) < upgrade:GetLevels()) )then
        // upgrade is ok, enough res?
        if self:GetResources() - upgrade:GetCost() > 0 then
            return true
        end
    end      
    return false  
end

// returns the entry in the table or nil if not
function UpgradeMixin:HasUpgrade(upgrade)
    local hasUpgrade = nil
        for i, entry in ipairs(self.UpgradeList) do
            if entry.upgrade == upgrade:GetId() then
                hasUpgrade = i
                break
            end
        end    
    return hasUpgrade
end

function UpgradeMixin:GetUpgradeLevel(upgrade, number)
    if number then
        if self.UpgradeList[number] then
            return self.UpgradeList[number].level
        end
    else
        for i, entry in ipairs(self.UpgradeList) do
            if entry.upgrade == upgrade then
                return entry.level
            end
        end
    end
end

function UpgradeMixin:GetUpgradeByName(upgradeName)
    if upgradeName then
        for i, upgrade in ipairs(self:GetAllUpgrades()) do
            if _G[upgrade] and _G[upgrade]:GetUpgradeName() == upgradeName then
                return _G[upgrade]                
            end
        end
    end
end


function UpgradeMixin:GetUpgradeById(id)
    if id then
        local allUpgrades = self:GetAllUpgrades()
        if allUpgrades[id] and _G[allUpgrades[id]] then
            return _G[allUpgrades[id]]
        end
    end
end

function UpgradeMixin:GetUpgradeByClassName(className)
    if className then
        local allUpgrades = self:GetAllUpgrades()
        for i, upgradeClassName in ipairs(allUpgrades) do
            if className == upgradeClassName then
                return _G[allUpgrades[i]]
            end
        end
    end
end

function UpgradeMixin:GetAllUpgrades()
    return kAllFactionsUpgrades
end

function UpgradeMixin:spendlvlHints(hint, type)
// sends a hint to the player if co_spendlvl fails

    if not type then type = "" end

    if hint == "spectator" then
        self:SendDirectMessage("You can only apply upgrades once you've joined a team!")
        
    elseif hint == "dead" then
        self:SendDirectMessage("You cannot apply upgrades if you are dead!")
        
    elseif hint == "no_type" then
        self:SendDirectMessage("Usage: /buy upgradeName or co_spendlvl upgradeName - All upgrades for your team:")
        Server.ClientCommand(self, "co_upgrades")
               
    elseif hint == "wrong_type_marine" then        
        self:SendDirectMessage(  type .. " is not known. All upgrades for your team:")        
        Server.ClientCommand(self, "co_upgrades")
        
    elseif hint == "wrong_type_alien" then
        self:SendDirectMessage(  type .. " is not known. All upgrades for your team:")
        Server.ClientCommand(self, "co_upgrades")
        
    elseif hint == "neededOtherUp" then
        self:SendDirectMessage( "You need " .. type .. " first")       
    
    elseif hint == "neededLvl" then
        self:SendDirectMessage("You got only " .. self:GetLvlFree().. " but you need at least ".. type .. " free Lvl")
        
    elseif hint == "already_owned" then
        // Suppress this now as most people buy via the menus.
        //self:SendDirectMessage("You already own the upgrade " .. type)
        
    elseif hint == "no_room" then
        self:SendDirectMessage( type .." upgrade failed, maybe not enough room")  

    elseif hint == "not_in_techrange" then
        local techType = ""
        
        if type == "Alien" then
            techType = "Hive to evolve to an Onos"
        else
            techType = "Command Station to get an Exosuit"
        end
        self:SendDirectMessage("You have to be near the " .. techType .. "!")
        
    elseif hint == "wrong_team" then
        local teamtext = ""
        if type == "Alien" then
            teamtext = "an Alien"
        else
            teamtext = "a Marine"
        end
        self:SendDirectMessage( "Cannot take this upgrade. You are not " .. teamtext .. "!" )   
        
    elseif hint == "mutuallyExclusive" then
        self:SendDirectMessage( "Cannot buy this upgrade when you have the " .. type .. " upgrade!")
        
    elseif hint == "hardCapped" then
        self:SendDirectMessage( "Cannot buy this upgrade.")
        self:SendDirectMessage( "Only 1 player may take this upgrade for every 5 players in your team." )
        
    elseif hint == "freeLvl" then
        local lvlFree = self:GetLvlFree()
        local upgradeWord = (lvlFree > 1) and "upgrades" or "upgrade"
        self:SendDirectMessage("You have " .. lvlFree .. " " .. upgradeWord .. " to spend. Use \"/buy <upgrade>\" in chat to buy upgrades.")   
    
    end
end

