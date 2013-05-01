//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MagnoBootsWearerMixin.lua

Script.Load("lua/FunctionContracts.lua")

MagnoBootsWearerMixin = CreateMixin( MagnoBootsWearerMixin )
MagnoBootsWearerMixin.type = "MagnoBootsWearer"

MagnoBootsWearerMixin.expectedMixins =
{
	 WallMovement = "Needed for processing the wall walking.",
}

MagnoBootsWearerMixin.expectedCallbacks =
{
}

MagnoBootsWearerMixin.expectedConstants =
{
}

MagnoBootsWearerMixin.networkVars =
{
	hasMagnoBoots = "private boolean"
}

function MagnoBootsWearerMixin:__initmixin()

	if self.hasMagnoBoots == nil then
		self.hasMagnoBoots = false
	end

end

function MagnoBootsWearerMixin:GiveMagnoBoots()

	if not self:GetHasMagnoBoots() then
		self.hasMagnoBoots = true
	end
	
end
AddFunctionContract(MagnoBootsWearerMixin.GiveMagnoBoots, { Arguments = { "Entity" }, Returns = { } })

function MagnoBootsWearerMixin:GetHasMagnoBoots()

	return self.hasMagnoBoots
	
end
AddFunctionContract(MagnoBootsWearerMixin.GetHasMagnoBoots, { Arguments = { "Entity" }, Returns = { "boolean" } })