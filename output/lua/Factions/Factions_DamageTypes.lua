//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_DamageTypes.lua

// Use this function to change damage according to current upgrades
local function ApplyFactionsUpgradedDamageModifiers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType)

    local damageScalar = 1

    if attacker ~= nil then
    
        // Damage upgrades only affect weapons, not ARCs, Sentries, MACs, Mines, etc.
        if doer:isa("Weapon") or doer:isa("Grenade") or doer:isa("Sentry") or doer:isa("Hydra") then
        
            if HasMixin(attacker, "WeaponUpgrade") then
            
                damageScalar = attacker:GetDamageScalar()
                
			end
            
        end
        
    end
        
	damage = damage * damageScalar
	
    return damage, armorFractionUsed, healthPerArmor
    
end

// This function is called from CanEntityDoDamageTo in NS2Utility
// as this is the first place in the code we are able to access kDamageTypeGlobalRules
kFactionsDamageRulesApplied = false
function Factions_CheckAndApplyDamageModifierRules()
	
	if not kFactionsDamageRulesApplied then
		table.insert(kDamageTypeGlobalRules, ApplyFactionsUpgradedDamageModifiers)
		kFactionsDamageRulesApplied = true
	end

end