//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FactionsClassMixin.lua

Script.Load("lua/FunctionContracts.lua")

if kFactionsClassType == nil then
	kFactionsClassType = enum({'NoneSelected'})
	kAllFactionsClasses = {}
	kFactionsClassStrings = {}
	kFactionsClassStrings[kFactionsClassType.NoneSelected] = "None Selected"
end

// load the Factions Class base classes
Script.Load("lua/Factions/Factions_FactionsClass.lua")
Script.Load("lua/Factions/Factions_UpgradeList.lua")

local function RegisterNewClass(classType, className, classEntity)
	
	// We have to reconstruct the kFactionsClassType enum to add values.
	local enumTable = {}
	for index, value in ipairs(kFactionsClassType) do
		table.insert(enumTable, value)
	end
	
	table.insert(enumTable, classType)
	
	kFactionsClassType = enum(enumTable)
	kFactionsClassStrings[kFactionsClassType[classType]] = className
	kAllFactionsClasses[kFactionsClassType[classType]] = classEntity
	
end

// build the FactionsClass list
local function BuildAllFactionsClasses()

    if #kAllFactionsClasses == 0 then
        // load all FactionsClass files
        local factionsClassFiles = { }
        local factionsClassDirectory = "lua/Factions/Classes/"
        Shared.GetMatchingFileNames( factionsClassDirectory .. "*.lua", false, factionsClassFiles)

        for _, factionsClassFile in pairs(factionsClassFiles) do
            Script.Load(factionsClassFile)      
        end
		
		// Build the enums for the Type field and save all FactionsClasses in a table
		for index, classType in ipairs(Script.GetDerivedClasses("FactionsClass")) do
			RegisterNewClass(classType, _G[classType].name, _G[classType])
		end
    end
    
end

if #kAllFactionsClasses == 0 then
    BuildAllFactionsClasses()
end

FactionsClassMixin = CreateMixin( FactionsClassMixin )
FactionsClassMixin.type = "FactionsClass"

FactionsClassMixin.expectedMixins =
{
}

FactionsClassMixin.expectedCallbacks =
{
}

FactionsClassMixin.expectedConstants =
{
}

FactionsClassMixin.networkVars =
{
	factionsClassType = "enum kFactionsClassType"
}

// Conversion functions for ease of output/input
local function FactionsClassToString(enumValue)
	return kFactionsClassStrings[enumValue]
end

local function StringToFactionsClass(stringValue)
	for enumValue, className in pairs(kFactionsClassStrings) do
		if className:upper() == stringValue:upper() then
			return enumValue
		end
	end
	
	return nil
end

// Maintain a local type variable so that the calculations are sane until ChangeFactionsClass is triggered.
function FactionsClassMixin:__initmixin()

    self.factionsClassType = kFactionsClassType.NoneSelected
	self.factionsClassLocalType = kFactionsClassType.NoneSelected

end

function FactionsClassMixin:GiveStartingUpgrades()

	// TODO: Reenable when this is fixed.
	/*if self:GetHasFactionsClass() and self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
		for index, upgradeClassName in ipairs(self.factionsClass:GetInitialUpgrades()) do
			local upgrade = self:GetUpgradeByClassName(upgradeClassName)
			if upgrade then
				self:BuyUpgrade(upgrade:GetId(), true)
			else
				Shared.Message("Could not find initial upgrade " .. upgradeClassName .. " for player " .. self:GetName())
			end
		end
	end*/
	
end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	if player.factionsClassType then		
		self.factionsClassType = player.factionsClassType
		self.factionsClassLocalType = player.factionsClassLocalType
		self.factionsClass = self:GetClassByType(player.factionsClassType)
	end
	
	// At this point we have enough info to give the player their starting equipment
	if Server then
		self:GiveStartingUpgrades()
	end

end

function FactionsClassMixin:GetFactionsClass()

	return self.factionsClass

end

function FactionsClassMixin:GetFactionsClassType()

	return self.factionsClassLocalType

end

function FactionsClassMixin:GetFactionsClassString()

	return FactionsClassToString(self:GetFactionsClassType())

end

function FactionsClassMixin:GetHasFactionsClass()

	local hasClass = true
	if self:GetFactionsClassType() == kFactionsClassType.NoneSelected then
		hasClass = false
	end
	
	return hasClass
	
end

function FactionsClassMixin:ChangeFactionsClassFromString(newClassString)

	local newClass = StringToFactionsClass(newClassString)
	local success = false
	if newClass then
		self:ChangeFactionsClass(newClass)
		success = true
	end
	
	return success

end

function FactionsClassMixin:GetAllClasses()
    return kAllFactionsClasses
end

function FactionsClassMixin:GetClassByType(classType)
    if classType then
        local allClasses = self:GetAllClasses()
        if allClasses[classType] then
			local gotClass = allClasses[classType]()
			gotClass:Initialize()
            return gotClass
        end
    end
end

function FactionsClassMixin:OnUpdatePlayer()
	if self.factionsClassType ~= self.factionsClassLocalType then
		self:ChangeFactionsClass(self.factionsClassType)
	end
end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	if GetGamerulesInfo():GetIsClassBased() then
		if self.factionsClassLocalType ~= newClass then
			self.factionsClassType = newClass
			self.factionsClassLocalType = newClass
			self.factionsClass = self:GetClassByType(newClass)
			
			if Server then
				// Kill the player if they do this while playing.
				if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
					self:Kill(nil, nil, self:GetOrigin())
				end
			end
		end
	else
		self:SendDirectMessage("You cannot change class in this gamemode!")
	end

end

function FactionsClassMixin:GetBaseMaxSprintSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseSprintSpeed()
	else
		return _G[self:GetClassName()].kRunMaxSpeed
	end

end

function FactionsClassMixin:GetBaseMaxSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseSpeed()
	else
		return _G[self:GetClassName()].kWalkMaxSpeed
	end

end

function FactionsClassMixin:GetBaseHealth()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseHealth()
	else
		return self:GetOriginalMaxHealth()
	end

end

function FactionsClassMixin:GetBaseArmor()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseArmor()
	else
		return self:GetOriginalMaxArmor()
	end

end