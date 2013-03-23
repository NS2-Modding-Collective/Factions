//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TimerMixin.lua

TimerMixin = CreateMixin( TimerMixin )
TimerMixin.type = "Timer"

// Timed events can never trigger more quickly than this.
TimerMixin.baseInterval = 1

TimerMixin.expectedMixins =
{
}

TimerMixin.expectedCallbacks =
{
}

TimerMixin.expectedConstants =
{
}

TimerMixin.networkVars =
{
}

local function TriggerTimers(self)
	for name, timer in pairs(self.timers) do
		Shared.Message("Triggered timer " .. name .. ". Next trigger " .. timer.lastTrigger + timer.interval .. " currentTime = " .. Shared.GetTime())
		if timer.lastTrigger + interval <= baseTimer then
			timer.func(timer.object)
			timer.lastTrigger = Shared.GetTime()
		end
	end
	
	return true
end

function TimerMixin:__initmixin()

	self.timers = { }
	self:AddTimedCallback(TriggerTimers, TimerMixin.baseInterval)

end

function TimerMixin:AddTimer(name, object, func, interval)
	local timer = {}
	timer.object = object
	timer.func = func
	timer.lastTrigger = Shared.GetTime()
	timer.interval = interval
	
	self.timers[name] = timer
end