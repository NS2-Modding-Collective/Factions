// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// Based on:
// lua\Weapons\Alien\HydraAbility.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// Gorge builds PhaseGate.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'PhaseGateAbility' (Entity)

function PhaseGateAbility:GetIsPositionValid(position)
    return true
end

function PhaseGateAbility:AllowBackfacing()
    return false
end

function PhaseGateAbility:GetDropRange()
    return kGorgeCreateDistance
end

function PhaseGateAbility:GetStoreBuildId()
    return false
end

function PhaseGateAbility:GetEnergyCost(player)
    return kDropStructureEnergyCost
end

function PhaseGateAbility:GetGhostModelName(ability)
    return PhaseGate.kModelName
end

function PhaseGateAbility:GetDropStructureId()
    return kTechId.PhaseGate
end

function PhaseGateAbility:GetSuffixName()
    return "PhaseGate"
end

function PhaseGateAbility:GetDropClassName()
    return "PhaseGate"
end

function PhaseGateAbility:GetDropMapName()
    return PhaseGate.kMapName
end

function PhaseGateAbility:CreateStructure()
	return false
end

function PhaseGateAbility:IsAllowed(player)
    return true
end
