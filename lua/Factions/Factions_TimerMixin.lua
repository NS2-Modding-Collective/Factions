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
	local currentTime = Shared.GetTime()
	for name, timer in pairs(self.timers) do
		if timer.lastTrigger + timer.interval <= currentTime then
			// Uncomment this for debug
			//Shared.Message("Triggered timer " .. name .. ". Next trigger " .. timer.lastTrigger + timer.interval .. " currentTime = " .. currentTime)
			timer.func(timer.object, self)
			timer.lastTrigger = currentTime
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

function TimerMixin:RemoveTimer(name)
	self.timers[name] = nil
end