//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Player.lua

local networkVars = {
}

Script.Load("lua/Factions/Factions_DirectMessageRecipientMixin.lua")
Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")
Script.Load("lua/Factions/Factions_XpMixin.lua")
Script.Load("lua/Factions/Factions_UpgradeMixin.lua")

AddMixinNetworkVars(FactionsClassMixin, networkVars)
AddMixinNetworkVars(XpMixin, networkVars)
AddMixinNetworkVars(UpgradeMixin, networkVars)

// Mixin to allow players to receive direct messages.
local overrideOnCreate = Player.OnCreate
function Player:OnCreate()

	overrideOnCreate(self)
	InitMixin(self, FactionsClassMixin)
	InitMixin(self, XpMixin)
	InitMixin(self, UpgradeMixin)

	assert(HasMixin(self, "FactionsClass"))
	assert(HasMixin(self, "Xp"))
	assert(HasMixin(self, "Upgrade"))

    if Server then

        // Init mixins
        InitMixin(self, DirectMessageRecipientMixin)
        
        assert(HasMixin(self, "DirectMessageRecipient"))
    end
    
end

if Server then
	local function UpdateChangeToSpectator(self)

		if not self:GetIsAlive() and not self:isa("Spectator") then
		
			local time = Shared.GetTime()
			if self.timeOfDeath ~= nil and (time - self.timeOfDeath > kFadeToBlackTime) then
			
				// Destroy the existing player and create a spectator in their place (but only if it has an owner, ie not a body left behind by Phantom use)#
				local owner  = Server.GetOwner(self)
				if owner then
				
					// Get the team number
					local teamNumber = self:GetTeamNumber()
					
					// Queue up the spectator for respawn.
					local spectator = self:Replace(self:GetDeathMapName())
					spectator.teamNumber = teamNumber
					spectator:GetTeam():PutPlayerInRespawnQueue(spectator)
					
				end
				
			end
			
		end
		
	end

	function Player:OnUpdatePlayer(deltaTime)

		UpdateChangeToSpectator(self)
		
		local gamerules = GetGamerules()
		self.gameStarted = gamerules:GetGameStarted()
		if self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index then
			self.countingDown = gamerules:GetCountingDown()
		else
			self.countingDown = false
		end
		
	end
	
end

Class_Reload("Player", networkVars)