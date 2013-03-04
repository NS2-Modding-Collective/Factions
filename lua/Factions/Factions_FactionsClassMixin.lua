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

local function RegisterNewClass(classType, className)
	
	// We have to reconstruct the kFactionsClassType enum to add values.
	local enumTable = {}
	for index, value in ipairs(kFactionsClassType) do
		table.insert(enumTable, value)
	end
	
	table.insert(enumTable, classType)
	
	kFactionsClassType = enum(enumTable)
	kFactionsClassStrings[kFactionsClassType[classType]] = className
	
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
        
        // save all FactionsClasses in a table
        kAllFactionsClasses = Script.GetDerivedClasses("FactionsClass")
		
		// build the enums for the Type field.
		for index, classType in ipairs(kAllFactionsClasses) do
			RegisterNewClass(classType, _G[classType].name)
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
	factionsClass = "enum kFactionsClassType"
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

    self.factionsClass = kFactionsClassType.NoneSelected

end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	self.factionsClassType = player.factionsClassType
	self.factionsClass = self:GetClassByType(player.factionsClassType)

end

function FactionsClassMixin:GetFactionsClass()

	return self.factionsClass

end

function FactionsClassMixin:GetFactionsClassString()

	return FactionsClassToString(self:GetFactionsClass())

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
        if allClasses[classType] and _G[allClasses[classType]] then
            return _G[allClasses[classType]]
        end
    end
end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	if self.factionsClassType ~= newClass then
		self.factionsClassType = newClass
		self.factionsClass = self:GetClassByType(newClass)
		
		// Kill the player if they do this while playing.
		if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
			self:Kill(nil, nil, self:GetOrigin())
		end
	end

end

function FactionsClassMixin:GetRunMaxSpeed()

	if self.factionsClassType == kFactionsClassType.NoneSelected then
		return Marine.kMaxRunSpeed
	else
		return self.factionsClass:GetBaseRunSpeed()
	end

end

function FactionsClassMixin:GetWalkMaxSpeed()

	if self.factionsClassType == kFactionsClassType.NoneSelected then
		return Marine.kMaxWalkSpeed
	else
		return self.factionsClass:GetBaseWalkSpeed()
	end

end