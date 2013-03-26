// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Alien\StructureAbility.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Entity.lua")

class 'MarineStructureDrop' (Entity)

function MarineStructureDrop:GetIsPositionValid(position)
    return true
end

function MarineStructureDrop:GetDropRange()
    return kGorgeCreateDistance
end

function MarineStructureDrop:OnUpdateHelpModel(ability, abilityHelpModel, coords)
    abilityHelpModel:SetIsVisible(false)
end

function MarineStructureDrop:GetStoreBuildId()
    return false
end    

// Child should override
function MarineStructureDrop:GetEnergyCost(player)
    assert(false)
end

// Child should override
function MarineStructureDrop:GetDropStructureId()
    assert(false)
end

function MarineStructureDrop:GetGhostModelName(ability)
    assert(false)
end

// Child should override ("hydra", "cyst", etc.). 
function MarineStructureDrop:GetSuffixName()
    assert(false)
end

// Child should override ("Hydra")
function MarineStructureDrop:GetDropClassName()
    assert(false)
end

// Child should override 
function MarineStructureDrop:GetDropMapName()
    assert(false)
end

function MarineStructureDrop:CreateStructure()
	return false
end

function MarineStructureDrop:IsAllowed(player)

    return true
	
end

