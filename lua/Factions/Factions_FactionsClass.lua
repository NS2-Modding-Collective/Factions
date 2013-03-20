//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FactionsClass.lua

// Base class for all FactionsClasss
							
class 'FactionsClass'

FactionsClass.type 						= "NoneSelected"				     								// the type of the FactionsClass
FactionsClass.name 						= kFactionsClassStrings[kFactionsClassType.NoneSelected]     		// the friendly name of the FactionsClass
FactionsClass.description 				= kFactionsClassStrings[kFactionsClassType.NoneSelected]     		// the description of the FactionsClass
FactionsClass.baseHealth 				= kMarineHealth											     		// the base health value of this class
FactionsClass.baseArmor 				= kMarineArmor											     		// the base armor value of this class
FactionsClass.baseWalkSpeed 			= 6.0                												// the initial walk speed of this class
FactionsClass.baseRunSpeed 				= 9.0                												// the initial run speed of this class
FactionsClass.icon						= "ui/Factions/badges/badge_assault.dds"							// the badge for this class
FactionsClass.picture					= "ui/Factions/badges/badge_assault.dds"							// the big picture for this class, used on the select screen
FactionsClass.initialUpgrades			= { }																// the upgrades that you start the game with
FactionsClass.allowedUpgrades			= { }																// the upgrades that you are allowed to buy

function FactionsClass:Initialize()
	self.type = FactionsClass.type
	self.name = FactionsClass.name
	self.description = FactionsClass.description
	self.baseHealth = FactionsClass.baseHealth
	self.baseArmor = FactionsClass.baseArmor
	self.baseWalkSpeed = FactionsClass.baseWalkSpeed
	self.baseRunSpeed = FactionsClass.baseRunSpeed
	self.icon = FactionsClass.icon
	self.picture = FactionsClass.picture
	self.initialUpgrades = FactionsClass.initialUpgrades
	self.allowedUpgrades = FactionsClass.allowedUpgrades
end

function FactionsClass:OnCreate()

	self:BuildTechTree()

end

function FactionsClass:BuildTechTree()
	// Override this in the actual class file to build the tech tree.
end

function FactionsClass:GetType()
    return self.type
end

function FactionsClass:GetName()
    return self.name
end

function FactionsClass:GetDescription()
    return self.description
end

function FactionsClass:GetBaseHealth()
    return self.baseHealth
end

function FactionsClass:GetBaseArmor()
    return self.baseArmor
end

function FactionsClass:GetBaseSprintSpeed()
    return self.baseRunSpeed
end

function FactionsClass:GetBaseSpeed()
    return self.baseWalkSpeed
end

function FactionsClass:GetIcon()
    return self.icon
end

function FactionsClass:GetPicture()
	return self.picture
end

function FactionsClass:GetInitialUpgrades()
    return self.initialUpgrades
end

function FactionsClass:GetAllowedUpgrades()
    return self.allowedUpgrades
end

if kFactionsClassIdCache == nil then
	kFactionsClassIdCache = {}
end

// Implement caching to speed up this function call.
function FactionsClass:GetId()
	local cachedId = kFactionsClassIdCache[self:GetName()]
	
	if cachedId == nil then
		for i, factionsClass in ipairs(kAllFactionsClasses) do
			if _G[factionsClass] and _G[factionsClass] == self then
				kFactionsClassIdCache[self:GetName()] = i
				cachedId = i
			end
		end
	end
	
	return cachedId
end

function FactionsClass:IsUpgradeAllowed(upgradeId)
	if self.allowedUpgrades[upgradeId] then
		return true
	else
		return false
	end
end

// called from the FactionsClassMixin when the FactionsClass is added to a player. Override if necessary.
function FactionsClass:OnApplyClass(player)
end

