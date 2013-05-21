// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\TechData_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TechData.lua

kModdedTechData =
{
    { [kTechDataId] = kTechId.LightMachineGun,  [kTechDataTooltipInfo] = "LMG_TOOLTIP", [kTechDataPointValue] = kWeaponPointValue,    [kTechDataMapName] = LightMachineGun.kMapName, [kTechDataDisplayName] = "LMG",         [kTechDataModel] = LightMachineGun.kModelName, [kTechDataDamageType] = kLightMachineGunDamageType, [kTechDataCostKey] = kLightMachineGunCost, },
    { [kTechDataId] = kTechId.MarineStructureAbility,  [kTechDataTooltipInfo] = "MARINE_BUILD_TOOLTIP", [kTechDataPointValue] = kWeaponPointValue,    [kTechDataMapName] = MarineStructureAbility.kMapName, [kTechDataDisplayName] = "MARINE_BUILD",         [kTechDataModel] = Welder.kModelName, [kTechDataDamageType] = kWelderDamageType, [kTechDataCostKey] = kWelderCost, },
    { [kTechDataId] = kTechId.LayLaserMines,  [kTechDataTooltipInfo] = "LASERMINES_TOOLTIP", [kTechDataPointValue] = kWeaponPointValue,    [kTechDataMapName] = LayLaserMines.kMapName, [kTechDataDisplayName] = "LASERMINES",         [kTechDataModel] = LaserMine.kModelName, [kTechDataDamageType] = kMineDamageType, [kTechDataCostKey] = kMineCost, },
	{ [kTechDataId] = kTechId.LaserMine,  [kTechDataMapName] = LaserMine.kMapName,             [kTechDataHint] = "MINE_HINT", [kTechDataDisplayName] = "MINE", [kTechDataEngagementDistance] = kMineDetonateRange, [kTechDataMaxHealth] = kMineHealth, [kTechDataTooltipInfo] = "MINE_TOOLTIP",  [kTechDataMaxArmor] = kMineArmor, [kTechDataModel] = LaserMine.kModelName, [kTechDataPointValue] = kMinePointValue, },
	{ [kTechDataId] = kTechId.Sentry, 	[kTechDataBuildMethodFailedMessage] = "COMMANDERERROR_TOO_MANY_SENTRIES",      [kTechDataHint] = "SENTRY_HINT", [kTechDataGhostModelClass] = "MarineGhostModel", [kTechDataMapName] = Sentry.kMapName,                   [kTechDataDisplayName] = "SENTRY_TURRET",       [kTechDataCostKey] = kSentryCost,         [kTechDataPointValue] = kSentryPointValue, [kTechDataModel] = Sentry.kModelName,            [kTechDataBuildTime] = kSentryBuildTime, [kTechDataMaxHealth] = kSentryHealth,  [kTechDataMaxArmor] = kSentryArmor, [kTechDataDamageType] = kSentryAttackDamageType, [kTechDataSpecifyOrientation] = true, [kTechDataHotkey] = Move.S, [kTechDataInitialEnergy] = kSentryInitialEnergy,      [kTechDataMaxEnergy] = kSentryMaxEnergy, [kTechDataNotOnInfestation] = true, [kTechDataEngagementDistance] = kSentryEngagementDistance, [kTechDataTooltipInfo] = "SENTRY_TOOLTIP", [kStructureBuildNearClass] = "SentryBattery", [kStructureAttachRange] = SentryBattery.kRange, [kTechDataBuildRequiresMethod] = GetCheckSentryLimit, [kTechDataAllowConsumeDrop] = true, [kTechDataMaxAmount] = kNumSentriesPerPlayer },
	{ [kTechDataId] = kTechId.Armory, 	[kTechDataHint] = "ARMORY_HINT", [kTechDataGhostModelClass] = "MarineGhostModel", [kTechDataRequiresPower] = true,      [kTechDataMapName] = Armory.kMapName,                   [kTechDataDisplayName] = "ARMORY",              [kTechDataCostKey] = kArmoryCost,              [kTechDataBuildTime] = kArmoryBuildTime, [kTechDataMaxHealth] = kArmoryHealth, [kTechDataMaxArmor] = kArmoryArmor, [kTechDataEngagementDistance] = kArmoryEngagementDistance, [kTechDataModel] = Armory.kModelName, [kTechDataPointValue] = kArmoryPointValue, [kTechDataInitialEnergy] = kArmoryInitialEnergy,   [kTechDataMaxEnergy] = kArmoryMaxEnergy, [kTechDataNotOnInfestation] = true, [kTechDataTooltipInfo] = "ARMORY_TOOLTIP", [kTechDataAllowConsumeDrop] = true, [kTechDataMaxAmount] = kNumArmoriesPerPlayer },
	{ [kTechDataId] = kTechId.MiniArmory, 	[kTechDataHint] = "ARMORY_HINT", [kTechDataGhostModelClass] = "MarineGhostModel", [kTechDataRequiresPower] = true,      [kTechDataMapName] = MiniArmory.kMapName,                   [kTechDataDisplayName] = "ARMORY",              [kTechDataCostKey] = kArmoryCost,              [kTechDataBuildTime] = kArmoryBuildTime, [kTechDataMaxHealth] = kArmoryHealth, [kTechDataMaxArmor] = kArmoryArmor, [kTechDataEngagementDistance] = kArmoryEngagementDistance, [kTechDataModel] = MiniArmory.kModelName, [kTechDataPointValue] = kArmoryPointValue, [kTechDataInitialEnergy] = kArmoryInitialEnergy,   [kTechDataMaxEnergy] = kArmoryMaxEnergy, [kTechDataNotOnInfestation] = true, [kTechDataTooltipInfo] = "ARMORY_TOOLTIP", [kTechDataAllowConsumeDrop] = true, [kTechDataMaxAmount] = kNumArmoriesPerPlayer },
    { [kTechDataId] = kTechId.PhaseGate, 	[kTechDataHint] = "PHASE_GATE_HINT", [kTechDataGhostModelClass] = "MarineGhostModel",    [kTechDataRequiresPower] = true,        [kTechDataMapName] = PhaseGate.kMapName,                    [kTechDataDisplayName] = "PHASE_GATE",  [kTechDataCostKey] = kPhaseGateCost,       [kTechDataModel] = PhaseGate.kModelName, [kTechDataBuildTime] = kPhaseGateBuildTime, [kTechDataMaxHealth] = kPhaseGateHealth,   [kTechDataEngagementDistance] = kPhaseGateEngagementDistance, [kTechDataMaxArmor] = kPhaseGateArmor,   [kTechDataPointValue] = kPhaseGatePointValue, [kTechDataHotkey] = Move.P, [kTechDataNotOnInfestation] = true, [kTechDataSpecifyOrientation] = true, [kTechDataTooltipInfo] = "PHASE_GATE_TOOLTIP", [kTechDataAllowConsumeDrop] = true, [kTechDataMaxAmount] = kNumPhasegatesPerPlayer },
    { [kTechDataId] = kTechId.Knife,  [kTechDataTooltipInfo] = "KNIFE_TOOLTIP", [kTechDataPointValue] = kWeaponPointValue,    [kTechDataMapName] = Knife.kMapName, [kTechDataDisplayName] = "KNIFE",         [kTechDataModel] = Knife.kModelName, [kTechDataDamageType] = kKnifeDamageType, [kTechDataCostKey] = kKnifeCost, },
    { [kTechDataId] = kTechId.Observatory, [kTechDataHint] = "OBSERVATORY_HINT", [kTechDataGhostModelClass] = "MarineGhostModel",  [kTechDataRequiresPower] = true,        [kTechDataMapName] = Observatory.kMapName,    [kTechDataDisplayName] = "OBSERVATORY",  [kVisualRange] = Observatory.kDetectionRange, [kTechDataCostKey] = kObservatoryCost,       [kTechDataModel] = Observatory.kModelName,            [kTechDataBuildTime] = kObservatoryBuildTime, [kTechDataMaxHealth] = kObservatoryHealth,   [kTechDataEngagementDistance] = kObservatoryEngagementDistance, [kTechDataMaxArmor] = kObservatoryArmor,   [kTechDataInitialEnergy] = kObservatoryInitialEnergy,      [kTechDataMaxEnergy] = kObservatoryMaxEnergy, [kTechDataPointValue] = kObservatoryPointValue, [kTechDataHotkey] = Move.O, [kTechDataNotOnInfestation] = true, [kTechDataTooltipInfo] = "OBSERVATORY_TOOLTIP", [kTechDataObstacleRadius] = 0.25, [kTechDataAllowConsumeDrop] = true, [kTechDataMaxAmount] = kNumObservatoriesPerPlayer },
}

local overrideBuildTechData = BuildTechData
function BuildTechData()

    local defaultTechData = overrideBuildTechData()
    local moddedTechData = {}
    local usedTechIds = {}
    
    for i = 1, #kModdedTechData do
        local techEntry = kModdedTechData[i]
        table.insert(moddedTechData, techEntry)
        table.insert(usedTechIds, techEntry[kTechDataId])
    end
    
    for i = 1, #defaultTechData do
        local techEntry = defaultTechData[i]
        if not table.contains(usedTechIds, techEntry[kTechDataId]) then
            table.insert(moddedTechData, techEntry)
        end
    end
    
    return moddedTechData

end

local overrideInitTechTreeMaterialOffsets = InitTechTreeMaterialOffsets
function InitTechTreeMaterialOffsets()

   overrideInitTechTreeMaterialOffsets()

   kTechIdToMaterialOffset[kTechId.LightMachineGun] = 81
   kTechIdToMaterialOffset[kTechId.LaserMine] = 8
   
end