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
UpgradeMixin.type = "FactionsUpgrade"

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

function UpgradeMixin:ResetUpgrades()
	self:BuildNewUpgradeList()
end

function UpgradeMixin:BuildNewUpgradeList()
	self.UpgradeList = UpgradeList()
	self.UpgradeList:Initialize()
end

local function ReapplyUpgrades(self)
	if self:GetIsDestroyed() then
        return false
    end
	
	local owner = Server.GetOwner(self)
	if owner == nil then
		owner = self
	end

	for upgradeId, upgrade in pairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 and upgrade:GetIsPermanent() then
			if owner ~= nil then
				Server.SendNetworkMessage(owner, "UpdateUpgrade",  BuildUpdateUpgradeMessage(upgradeId, upgrade:GetCurrentLevel()), true)
			end
			
			// give upgrades back when the player respawns
			if self:GetIsAlive() and self:GetTeamNumber() ~= kNeutralTeamType then
				local errorMessage = self:GetCanBuyUpgradeMessage(upgradeId, freeUpgrade, true)
				if errorMessage == "" then
					upgrade:OnAdd(self)
				end
			end
		end
	end
	return false
end

function UpgradeMixin:CopyPlayerDataFrom(player)
	if HasMixin(player, "FactionsUpgrade") then
		if player.UpgradeList then 
			self.UpgradeList:CopyUpgradeDataFrom(player.UpgradeList)
			self:AddTimedCallback(ReapplyUpgrades, 0.1)
		end
	end
end

// Remove code duplication and possible differences in logic by combining logic and messages here
function UpgradeMixin:GetCanBuyUpgradeMessage(upgradeId, freeUpgrade, reapplyUpgrade)
	local upgrade = self:GetUpgradeById(upgradeId)
	local factionsClass = self:GetFactionsClass()
	
    if upgrade == nil then
		return "Cannot find upgrade with ID " .. upgradeId
	elseif upgrade:GetIsAtMaxLevel() and not reapplyUpgrade then
		return "Upgrade is already at max level!"
	elseif not self:GetHasPrerequisites(upgrade) then
		return "You are missing some requirements for this upgrade..."
	elseif not freeUpgrade and not (self:GetResources() >= upgrade:GetCostForNextLevel()) then
		return "Cannot afford upgrade"
	elseif self:GetLvl() < upgrade:GetMinPlayerLvl() then
		return "Cannot get upgrade until level " .. upgrade:GetMinPlayerLevel()
	elseif factionsClass and not factionsClass:GetIsUpgradeAllowed(upgrade) then
		return "Your class cannot buy this upgrade"
	elseif not upgrade:GetIsAllowedForThisGameMode() then
		return "Upgrade cannot be bought in this game mode"
	elseif not upgrade:GetIsAllowedForTeam(self:GetTeamNumber()) then
		return "Upgrade is not allowed for your team"
	elseif not upgrade:CanApplyUpgrade(self) == "" then
		return upgrade:CanApplyUpgrade(self)
	else
        return ""
    end
end

// For when you just need a true/false value!
function UpgradeMixin:GetCanBuyUpgrade(upgradeId, freeUpgrade, reapplyUpgrade)
	return self:GetCanBuyUpgradeMessage(upgradeId, freeUpgrade, reapplyUpgrade) == ""
end


function UpgradeMixin:BuyUpgrade(upgradeId, freeUpgrade)
	local upgrade = self:GetUpgradeById(upgradeId)
	
    if Server then
        local upgradeMessage = self:GetCanBuyUpgradeMessage(upgradeId, freeUpgrade)
		
        if upgradeMessage == "" then
        	// Refund any other upgrades in this slot
        	local upgradeSlot = upgrade:GetUniqueSlot()
        	if upgradeSlot ~= kUpgradeUniqueSlot.None then
        		local slotUpgrades = self:GetUpgradesBySlot(upgradeSlot)
				for index, slotUpgrade in ipairs(slotUpgrades) do
					if slotUpgrade:GetCurrentLevel() > 0 then
						Shared.Message("Refunding " .. slotUpgrade:GetUpgradeTitle() .. " for " .. self:GetName())
						self:RefundUpgradeComplete(slotUpgrade:GetId())
					end
				end
			end
        
        	local upgradeCost = upgrade:GetCostForNextLevel()
			if upgrade:GetIsPermanent() then
				upgrade:AddLevel()
				Server.SendNetworkMessage(self, "UpdateUpgrade",  BuildUpdateUpgradeMessage(upgradeId, upgrade:GetCurrentLevel()), true)
			end		
			
			upgrade:SendAddMessage(self)
			upgrade:OnAdd(self)
			
			if not freeUpgrade then
				self:AddResources(-upgradeCost)
            end
        else
            self:SendDirectMessage("Could not buy upgrade! " .. upgradeMessage)
        end
    elseif Client then
        // Send buy message to server
        Client.SendNetworkMessage("BuyUpgrade", BuildBuyUpgradeMessage(upgrade), true)
    end
end

// Refunds any upgrades that are no longer available because of team restrictions.
function UpgradeMixin:RefundUnavailableUpgrades()
	local refundAmount = 0
	for index, upgrade in ipairs(self:GetActiveUpgrades()) do
		local upgradeMessage = self:GetCanBuyUpgradeMessage(upgrade:GetId(), true)
		if upgradeMessage ~= "" then
			refundAmount = refundAmount + self:RefundUpgradeComplete(upgrade:GetId())
		end
	end
	
	if Server and refundAmount > 0 then
		self:SendDirectMessage("Some upgrades refunded because they are no longer available. You got back " .. refundAmount .. " XP.")
	end
end

function UpgradeMixin:RefundAllUpgrades()
	local refundAmount = 0
	for index, upgrade in ipairs(self:GetActiveUpgrades()) do
		refundAmount = refundAmount + self:RefundUpgradeComplete(upgrade:GetId())
	end
	
	if Server and refundAmount > 0 then
		self:SendDirectMessage("All upgrades refunded. You got back " .. refundAmount .. " XP.")
		// Kill the player if they do this while playing.
		if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
			self:Kill(nil, nil, self:GetOrigin())
		end
	end
end

function UpgradeMixin:RefundUpgradeComplete(upgradeId)

	local upgrade = self:GetUpgradeById(upgradeId)
	local refundAmount = upgrade:GetCompleteRefundAmount()
	self:AddResources(upgrade:GetCompleteRefundAmount())
	upgrade:SetLevel(0)
	return refundAmount
	
end

function UpgradeMixin:SetUpgradeLevel(upgradeId, upgradeLevel)
	return self.UpgradeList:SetUpgradeLevel(upgradeId, upgradeLevel)
end

function UpgradeMixin:GetHasUpgrade(upgradeId)
    return self.UpgradeList:GetHasUpgrade(upgradeId)
end

function UpgradeMixin:GetHasPrerequisites(upgrade)
	return self.UpgradeList:GetHasPrerequisites(upgrade)
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
    return self.UpgradeList:GetAvailableUpgradesByType(self:GetFactionsClass(), self:GetTeamNumber(), upgradeType)
end

function UpgradeMixin:GetUpgradesBySlot(upgradeSlot)
    return self.UpgradeList:GetUpgradesBySlot(upgradeSlot)
end

function UpgradeMixin:GetAllUpgrades()
	return self.UpgradeList:GetAllUpgrades()
end

function UpgradeMixin:GetAvailableUpgrades()
	return self.UpgradeList:GetAvailableUpgrades(self:GetFactionsClass(), self:GetTeamNumber())
end

function UpgradeMixin:GetActiveUpgrades()
	return self.UpgradeList:GetActiveUpgrades()
end