//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_CommandStructure.lua

local networkVars = {
}

// Call this to lock the command chair
function CommandStructure:LockCommandChair()

	self.lockCommandChair = true
            
end

local overrideUpdateCommanderLogin = CommandStructure.UpdateCommanderLogin
function CommandStructure:UpdateCommanderLogin(force)

	if self.lockCommandChair then
		self.occupied = true
		self.commanderId = Entity.invalidId
	else
		overrideUpdateCommanderLogin(self, force)
	end

end

// End the game when a team's CC is destroyed.
local overrideOnKill = CommandStructure.OnKill
function CommandStructure:OnKill(attacker, doer, point, direction)

	overrideOnKill(self, attacker, doer, point, direction)

    if not Shared.GetCheatsEnabled() and GetGamerules():GetGameStarted() then
		local team = self:GetTeam()
		local losingTeam = attacker:GetTeam()
		if team == GetGamerules().team1 then
			losingTeam = GetGamerules().team2 
		else
			losingTeam = GetGamerules().team1
		end
		
		GetGamerules():EndGame(losingTeam)
    end

end

// Call this to show the command structure's location to the opposing team.
function CommandStructure:RevealObjective()
	
	local attached = self:GetAttached()
	if attached then
		attached.showObjective = true
	end
	
end

Class_Reload("CommandStructure", networkVars)