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
	lastInkTime = "time",
	inkAvailable = "boolean",
}

function InkMixin:__initmixin()

	self.lastInkTime = 0
	self.inkAvailable = false

end

function InkMixin:CopyPlayerDataFrom(player)

	self.lastInkTime = player.lastInkTime

end

function InkMixin:GetTimeUntilInkAvailable()
	return self:GetNextTriggerTime("InkUpgrade")
end

function InkMixin:GetLastInkTime()
	return self.lastInkTime
end

function InkMixin:GetInkAvailable()
	return self.inkAvailable
end

function InkMixin:SetInkAvailable(value)
	self.inkAvailable = value
end

function InkMixin:TriggerInk()

	if Server then
		if self:GetInkAvailable() then
		
			// Create ShadeInk entity in world at this position with a small offset
			local shadeInk = CreateEntity(ShadeInk.kMapName, self:GetOrigin() + Vector(0, 0.2, 0), self:GetTeamNumber())
			StartSoundEffectOnEntity("sound/NS2.fev/alien/structures/shade/cloak_triggered", shadeInk)
			self.lastInkTime = Shared.GetTime()
			self:SetInkAvailable(true)
		else
			local waitTime = self:GetTimeUntilInkAvailable()
			if waitTime ~= nil and waitTime > 0 then
				self:SendDirectMessage("Cannot trigger ink yet! Wait another " .. waitTime .. " seconds")
			end
		end
    end
end