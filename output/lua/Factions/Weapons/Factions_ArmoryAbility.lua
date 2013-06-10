// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// Based on:
// lua\Weapons\Alien\HydraAbility.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// Gorge builds Armory.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'ArmoryAbility' (Entity)

function ArmoryAbility:GetIsPositionValid(position)
    return true
end

function ArmoryAbility:AllowBackfacing()
    return false
end

function ArmoryAbility:GetDropRange()
    return kGorgeCreateDistance
end

function ArmoryAbility:GetStoreBuildId()
    return false
end

function ArmoryAbility:GetEnergyCost(player)
    return kDropStructureEnergyCost
end

function ArmoryAbility:GetGhostModelName(ability)
    return Armory.kModelName
end

function ArmoryAbility:GetDropStructureId()
    return kTechId.MiniArmory
end

function ArmoryAbility:GetSuffixName()
    return "Armory"
end

function ArmoryAbility:GetDropClassName()
    return "MiniArmory"
end

function ArmoryAbility:GetDropMapName()
    return MiniArmory.kMapName
end

function ArmoryAbility:CreateStructure()
	return false
end

function ArmoryAbility:IsAllowed(player)
    return true
end
