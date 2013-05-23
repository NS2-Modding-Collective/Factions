// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// Based on:
// lua\Weapons\Alien\HydraAbility.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// Gorge builds Observatory.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'ObservatoryAbility' (Entity)

function ObservatoryAbility:GetIsPositionValid(position)
    return true
end

function ObservatoryAbility:AllowBackfacing()
    return false
end

function ObservatoryAbility:GetDropRange()
    return kGorgeCreateDistance
end

function ObservatoryAbility:GetStoreBuildId()
    return false
end

function ObservatoryAbility:GetEnergyCost(player)
    return kDropStructureEnergyCost
end

function ObservatoryAbility:GetGhostModelName(ability)
    return Observatory.kModelName
end

function ObservatoryAbility:GetDropStructureId()
    return kTechId.Observatory
end

function ObservatoryAbility:GetSuffixName()
    return "Observatory"
end

function ObservatoryAbility:GetDropClassName()
    return "Observatory"
end

function ObservatoryAbility:GetDropMapName()
    return Observatory.kMapName
end

function ObservatoryAbility:CreateStructure()
	return false
end

function ObservatoryAbility:IsAllowed(player)
    return true
end
