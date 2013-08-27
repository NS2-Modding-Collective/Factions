// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// Based on:
// lua\Weapons\Alien\HydraAbility.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// Gorge builds Sentry.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'RailgunSentryAbility' (Entity)

function RailgunSentryAbility:GetIsPositionValid(position)
    return true
end

function RailgunSentryAbility:AllowBackfacing()
    return false
end

function RailgunSentryAbility:GetDropRange()
    return kGorgeCreateDistance
end

function RailgunSentryAbility:GetStoreBuildId()
    return false
end

function RailgunSentryAbility:GetEnergyCost(player)
    return kDropStructureEnergyCost
end

function RailgunSentryAbility:GetGhostModelName(ability)
    return RailgunSentry.kModelName
end

function RailgunSentryAbility:GetDropStructureId()
    return kTechId.RailgunSentry
end

function RailgunSentryAbility:GetSuffixName()
    return "RailgunSentry"
end

function RailgunSentryAbility:GetDropClassName()
    return "RailgunSentry"
end

function RailgunSentryAbility:GetDropMapName()
    return RailgunSentry.kMapName
end

function RailgunSentryAbility:CreateStructure()
	return false
end

function RailgunSentryAbility:IsAllowed(player)
    return true
end
