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
	kFactionsClassStrings[kFactionClassTypes["classType"]] = className
	
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

	self.factionsClass = player.factionsClass

end

function FactionsClassMixin:GetFactionsClass()

	return self.factionsClass

end

function FactionsClassMixin:GetFactionsClassString()

	return FactionsClassToString(self:GetFactionsClass())

end

function FactionsClassMixin:ChangeFactionsClassFromString(newClassestring)

	local newClass = StringToFactionsClass(newClassestring)
	local success = false
	if newClass then
		self:ChangeFactionsClass(newClass)
		success = true
	end
	
	return success

end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	if self.factionsClass ~= newClass then
		self.factionsClass = newClass
		
		// Kill the player if they do this while playing.
		if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
			self:Kill(nil, nil, self:GetOrigin())
		end
	end

end