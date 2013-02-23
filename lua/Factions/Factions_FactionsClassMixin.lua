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

FactionsClassMixin = CreateMixin( FactionsClassMixin )
FactionsClassMixin.type = "FactionsClass"

kFactionsClass = enum ( { 'NoneSelected', 'Assault', 'Support', 'Scout' } )
local kFactionsClassStrings = {}
kFactionsClassStrings[kFactionsClass.NoneSelected] = "None Selected"
kFactionsClassStrings[kFactionsClass.Assault] = "Assault"
kFactionsClassStrings[kFactionsClass.Support] = "Support"
kFactionsClassStrings[kFactionsClass.Scout] = "Scout"

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
	factionsClass = "enum kFactionsClass"
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

    self.factionsClass = kFactionsClass.NoneSelected

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

function FactionsClassMixin:ChangeFactionsClassFromString(newClassString)

	local newClass = StringToFactionsClass(newClassString)
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