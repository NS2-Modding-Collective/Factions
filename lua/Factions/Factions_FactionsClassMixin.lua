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

enum kFactionsClass = ( { Assault, Support, Scout } )

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

function FactionsClassMixin:__initmixin()

    factionsClass = kFactionsClass.Assault

end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	self.factionsClass = player.factionsClass

end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	self.factionsClass = newClass
	
	// Kill the player if they do this while playing.
	if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
		self:Kill(nil, nil, self:GetOrigin())
	end

end