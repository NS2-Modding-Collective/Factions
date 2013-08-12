//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SpawnProtectMixin.lua

Script.Load("lua/FunctionContracts.lua")

SpawnProtectMixin = CreateMixin( SpawnProtectMixin )
SpawnProtectMixin.type = "SpawnProtect"

SpawnProtectMixin.expectedMixins =
{
}

SpawnProtectMixin.expectedCallbacks =
{
}

SpawnProtectMixin.expectedConstants =
{
}

SpawnProtectMixin.networkVars =
{
	activeSpawnProtect = "boolean",
    gotSpawnProtect = "boolean",
	deactivateSpawnProtect = "time",
	spawnProtectActivateTime = "time",
}

function SpawnProtectMixin:__initmixin()

    self.activeSpawnProtect = false
    self.deactivateSpawnProtect = 0
	self.spawnProtectActivateTime = 0
	self.gotSpawnProtect = false

end

function SpawnProtectMixin:SetSpawnProtect()

	self.activeSpawnProtect = true
    self.deactivateSpawnProtect = Shared.GetTime() + kSpawnProtectTime
	self.spawnProtectActivateTime = Shared.GetTime() + kSpawnProtectDelay

end

function SpawnProtectMixin:OnUpdatePlayer()

	if self.activeSpawnProtect then
	
		if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
			
			if Shared.GetTime() >= self.deactivateSpawnProtect then
				// end spawn protect
				self:DeactivateSpawnProtect()
			else
				if not self.gotSpawnProtect then
					self:ActivateSpawnProtect()
				end
			end
			
		end
		
	end
	
end

function SpawnProtectMixin:ActivateSpawnProtect()

	// Only make the effects once. 
	if not self.gotSpawnProtect then 
	
		// Fire the effects on a slight delay because something in the NS2 code normally clears it first!
		if Shared.GetTime() >= self.spawnProtectActivateTime then

			if HasMixin(self, "NanoShieldAble") then	
			
				self:ActivateNanoShield()
				if self.nanoShielded then
					self.gotSpawnProtect = true
				end

			end
			
		end    
		
	end

end

function SpawnProtectMixin:DeactivateSpawnProtect()

	// Deactivate the nano shield by manipulating the time variable.
	self.timeNanoShieldInit = 0
	
    self:SetHealth( self:GetMaxHealth() )
	self:SetArmor( self:GetMaxArmor() )

	self.activeSpawnProtect = nil
	self.gotSpawnProtect = nil

end