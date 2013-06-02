//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Hive.lua

local networkVars = {
}

local originalOnCreate = Hive.OnCreate
function Hive:OnCreate()

	originalOnCreate(self)
	self.hasBeenAttacked = false

end

local originalOnTakeDamage = Hive.OnTakeDamage
function Hive:OnTakeDamage(damage, attacker, doer, point)

	originalOnTakeDamage(self, damage, attacker, doer, point)
	
	if Server then
		if not self.hasBeenAttacked then
			self.hasBeenAttacked = true
			
			if GetGamerulesInfo():GetGameType() == kFactionsGameType.Xenoswarm then
				self:SpawnEmergencyDefenseNpcs()
			end
		end
		
	end

end

// Spawn some NPCs to defend the hive when it is under threat.
function Hive:SpawnEmergencyDefenseNpcs()
	
	local className = Hive.kDefenseNpcClass
    local origin = self:GetOrigin()
    local amount = Hive.kDefenseNpcAmount
	local values = { 
                    origin = origin,                    
                    team = self:GetTeamNumber(),
                    startsActive = true,
                    }
					
	for i = 1, amount do
		NpcUtility_Spawn(origin, className, values, nil)
	end
	
end

Class_Reload("Hive", networkVars)