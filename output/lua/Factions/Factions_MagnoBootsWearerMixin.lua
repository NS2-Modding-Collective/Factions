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

// These should completely override any existing function defined in the class.
MagnoBootsWearerMixin.overrideFunctions =
{
	"GetFuel",
}

MagnoBootsWearerMixin.networkVars =
{
	hasMagnoBoots = "private boolean",
	
	// jetpack fuel is dervived from the three variables jetpacking, timeJetpackingChanged and jetpackFuelOnChange
    // time since change has the kJetpackFuelReplenishDelay subtracted if not jetpacking
    // jpFuel = Clamp(jetpackFuelOnChange + time since change * gain/loss rate, 0, 1)
    // If jetpack is currently active and affecting our movement. If active, use loss rate, if inactive use gain rate
    // when we last changed state of magno boots
    timeMagnoBootsChanged = "time",
    // amount of fuel when we last changed wall-walking state
    magnoBootsFuelOnChange = "float (0 to 1 by 0.01)",
}

function MagnoBootsWearerMixin:__initmixin()

	if self.hasMagnoBoots == nil then
		self.hasMagnoBoots = false
	end
	
	self.magnoBootsFuelRate = kJetpackUseFuelRate
    self.magnoBootsFuelOnChange = 1
	self.lastWallWalkingState = false

end

function MagnoBootsWearerMixin:GiveMagnoBoots()

	if not self:GetHasMagnoBoots() then
		self.hasMagnoBoots = true
	end
	
end

function MagnoBootsWearerMixin:GetHasMagnoBoots()

	return self.hasMagnoBoots
	
end

function MagnoBootsWearerMixin:OnUpdate()
	if Server then
		local wallWalking = self:GetIsWallWalking()
		if wallWalking ~= self.lastWallWalkingState then
			self.timeMagnoBootsChanged = Shared.GetTime()
			self.lastWallWalkingState = wallWalking
			self.magnoBootsFuelOnChange = self:GetFuel()
		end
	end
end

function MagnoBootsWearerMixin:GetFuel()
	
	local originalFuel = self.magnoBootsFuelOnChange
	// Magno boots and jetpack fuel stacks!
	if self:isa("JetpackMarine") then
		originalFuel = originalFuel - (1 - JetpackMarine.GetFuel(self))
	end
	
    local dt = Shared.GetTime() - self.timeMagnoBootsChanged
    local rate = -self.magnoBootsFuelRate
    if not self:GetIsWallWalking() then
        rate = kJetpackReplenishFuelRate
        dt = math.max(0, dt - JetpackMarine.kJetpackFuelReplenishDelay)
    end
    return Clamp(originalFuel + rate * dt, 0, 1)
    
end