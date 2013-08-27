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
	"HandleJetpackStart",
	"HandleJetpackEnd",
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
	
    self.magnoBootsFuelOnChange = 1
	self.timeMagnoBootsChanged = Shared.GetTime()
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
	local wallWalking = self:GetIsWallWalking()
	if wallWalking ~= self.lastWallWalkingState then
		local wallWalkingMessage = "False"
		if wallWalking then 
			wallWalkingMessage = "True"
		end
		Shared.Message("Changed state! Now " .. ToString(wallWalking))
		self.magnoBootsFuelOnChange = self:GetFuel()
		self.timeMagnoBootsChanged = Shared.GetTime()
		self.lastWallWalkingState = wallWalking
	end
end

function MagnoBootsWearerMixin:HandleJetpackStart()

	self.magnoBootsFuelOnChange = self:GetFuel()
	self.timeMagnoBootsChanged = Shared.GetTime()
	
	JetpackMarine.HandleJetpackStart(self)
    
end

function MagnoBootsWearerMixin:HandleJetPackEnd()

	self.magnoBootsFuelOnChange = self:GetFuel()
	self.timeMagnoBootsChanged = Shared.GetTime()
    
	JetpackMarine.HandleJetPackEnd(self)
    
end

function MagnoBootsWearerMixin:GetFuel()
	
	// Magno boots and jetpack fuel stacks!
	local newFuel = 1
	
    local jetpackRate = self.hasFuelUpgrade and -kUpgradedJetpackUseFuelRate or -kJetpackUseFuelRate
	local magnoBootsRate = self.hasFuelUpgrade and -kUpgradedJetpackUseFuelRate or -kJetpackUseFuelRate
	local totalRate = 0
	local dt = Shared.GetTime() - self.timeMagnoBootsChanged
	local fuelOnChange = self.magnoBootsFuelOnChange 
	
    if not self.jetpacking then
		jetpackRate = 0
	end
	
	if not self.lastWallWalkingState then
		magnoBootsRate = 0
		totalRate = jetpackRate + magnoBootsRate
	end
	
	// Replenish if we are not jetpacking or wall walking
	totalRate = jetpackRate + magnoBootsRate
	if not self.jetpacking and not self.lastWallWalkingState then
        totalRate = kJetpackReplenishFuelRate
        dt = math.max(0, dt - JetpackMarine.kJetpackFuelReplenishDelay)
	end
	
    local newFuel = Clamp(fuelOnChange + totalRate * dt, 0, 1)
	
    return newFuel
    
end