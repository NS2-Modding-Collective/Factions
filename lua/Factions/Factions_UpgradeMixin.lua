//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UpgradeMixin.lua

Script.Load("lua/Factions/Factions_UpgradeList.lua")
  
UpgradeMixin = CreateMixin(UpgradeMixin)
UpgradeMixin.type = "Upgrade"

UpgradeMixin.networkVars =
{
}

UpgradeMixin.expectedMixins =
{
	FactionsClass = "For specifying which upgrades are allowed",
}

UpgradeMixin.expectedCallbacks =
{
}


function UpgradeMixin:__initmixin()
	self:BuildNewUpgradeList()
end

function UpgradeMixin:Reset()
    self:BuildNewUpgradeList()
end

function UpgradeMixin:ClearUpgrades()
	self:BuildNewUpgradeList()
end

function UpgradeMixin:BuildNewUpgradeList()
	self.UpgradeList = UpgradeList()
	self.UpgradeList:Initialize()
end

function UpgradeMixin:CopyPlayerDataFrom(player)
    if player.UpgradeList then 
		self.UpgradeList = player.UpgradeList
	end
    
	// give upgrades back when the player respawns
    if self:GetIsAlive() and self:GetTeamNumber() ~= kNeutralTeamType then
		self:GiveBackPermanentUpgrades()
    end
end

function UpgradeMixin:GiveBackPermanentUpgrades()
	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 and upgrade:GetIsPermanent() then
			upgrade:OnAdd(self)
		end
	end
end

function UpgradeMixin:GetHasPrerequisites(upgrade)
	return self.UpgradeList:GetHasPrerequisites(upgrade)
end

function UpgradeMixin:GetIsAllowedToBuy(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
	if (not upgrade:GetIsAtMaxLevel()) 
		and self:GetResources() >= upgrade:GetCostForNextLevel()
		and self:GetFactionsClass():GetIsUpgradeAllowed(upgrade)
		and self:GetHasPrerequisites(upgrade) then
		return true
	else
		return false
	end
end

function UpgradeMixin:BuyUpgrade(upgradeId, freeUpgrade)
	local upgrade = self:GetUpgradeById(upgradeId)
	
    if Server then
        local upgradeOk = self:GetIsAllowedToBuy(upgradeId)
		
        if upgradeOk then     
			if upgrade:GetIsPermanent() then
				upgrade:AddLevel()
				Server.SendNetworkMessage(self, "UpdateUpgrade",  BuildUpdateUpgradeMessage(upgradeId, upgrade:GetCurrentLevel()), true)
			end		
			
			upgrade:OnAdd(self)
			
			if not freeUpgrade then
				self:AddResources(-upgrade:GetCostForNextLevel())
            end
        else
            self:SendDirectMessage("Upgrade not available")
        end
    elseif Client then
        // Send buy message to server
        Client.SendNetworkMessage("BuyUpgrade", BuildBuyUpgradeMessage(upgrade), true)
    end
end

function UpgradeMixin:SetUpgradeLevel(upgradeId, upgradeLevel)
	return self.UpgradeList:SetUpgradeLevel(upgradeId, upgradeLevel)
end

function UpgradeMixin:GetCanBuyUpgrade(upgradeId)
    local hasUpgrade = self:GetHasUpgrade(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
    if not hasUpgrade or (hasUpgrade and not upgrade:GetIsAtMaxLevel()) then
        // upgrade is ok, enough res?
        if self:GetResources() - upgrade:GetCostForNextLevel() >= 0 then
            return true
        end
    end      
    return false  
end

// returns the entry in the table or nil if not
function UpgradeMixin:GetHasUpgrade(upgradeId)
    return self.UpgradeList:GetHasUpgrade(upgradeId)
end

function UpgradeMixin:GetUpgradeLevel(upgradeId)
	return self.UpgradeList:GetUpgradeLevel(upgradeId)
end

function UpgradeMixin:GetUpgradeById(upgradeId)
	return self.UpgradeList:GetUpgradeById(upgradeId)
end

function UpgradeMixin:GetUpgradeByName(upgradeName)
    return self.UpgradeList:GetUpgradeByName(upgradeName)
end

function UpgradeMixin:GetAvailableUpgradesByType(upgradeType)
    return self.UpgradeList:GetAvailableUpgradesByType(self:GetFactionsClass(), upgradeType)
end

function UpgradeMixin:GetAllUpgrades()
	return self.UpgradeList:GetAllUpgrades()
end

function UpgradeMixin:GetAvailableUpgrades()
	return self.UpgradeList:GetAvailableUpgrades(self:GetFactionsClass())
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

