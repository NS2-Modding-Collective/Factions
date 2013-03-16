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
	//factionsClassType = "enum kFactionsClassType"
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

function FactionsClassMixin:__initmixin()

    self.factionsClassType = kFactionsClassType.NoneSelected

end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	if player.factionsClassType then		
		self.factionsClassType = player.factionsClassType
		self.factionsClass = self:GetClassByType(player.factionsClassType)
	end

end

function FactionsClassMixin:GetFactionsClass()

	return self.factionsClass

end

function FactionsClassMixin:GetFactionsClassType()

	return self.factionsClassType

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
            return allClasses[classType]
        end
    end
end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	if self.factionsClassType ~= newClass then
		self.factionsClassType = newClass
		self.factionsClass = self:GetClassByType(newClass)
		
		if Server then
			Server.SendNetworkMessage(self, "ChangeFactionsClass", BuildChangeFactionsClassMessage(newClass), true)
		end
		
		// Kill the player if they do this while playing.
		if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
			self:Kill(nil, nil, self:GetOrigin())
		end
	end

end

function FactionsClassMixin:GetBaseSprintAcceleration()

	if self:GetHasFactionsClass() then
		return self.factionsClass.baseSprintAcceleration
	else
		return Marine.kSprintAcceleration
	end

end

function FactionsClassMixin:GetBaseAcceleration()

	if self:GetHasFactionsClass() then
		return self.factionsClass.baseAcceleration
	else
		return Marine.kAcceleration
	end

end

function FactionsClassMixin:GetBaseMaxSprintSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass.baseRunSpeed
	else
		return Marine.kRunMaxSpeed
	end

end

function FactionsClassMixin:GetBaseMaxSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass.baseWalkSpeed	
	else
		return Marine.kWalkMaxSpeed
	end

end