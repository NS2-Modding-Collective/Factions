//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_InkMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

InkMixin = CreateMixin( InkMixin )
InkMixin.type = "InkMixin"

InkMixin.expectedMixins =
{
	Upgrade = "To power the upgrades",
	Timer = "For managing the timer",
}

InkMixin.expectedCallbacks =
{
}

InkMixin.expectedConstants =
{
}

InkMixin.networkVars =
{
	lastInkTime = "time"
}

function InkMixin:__initmixin()

	self.lastInkTime = 0

end

function InkMixin:CopyPlayerDataFrom(player)

	self.lastInkTime = player.lastInkTime

end

function InkMixin:GetCanTriggerInk()
	return true
end

function InkMixin:TriggerInk()

        // Create ShadeInk entity in world at this position with a small offset
        local shadeInk = CreateEntity(ShadeInk.kMapName, self:GetOrigin() + Vector(0, 0.2, 0), self:GetTeamNumber())
		StartSoundEffectOnEntity("sound/NS2.fev/alien/structures/shade/cloak_triggered", shadeInk)
		self.lastInkTime = Shared.GetTime()

    end