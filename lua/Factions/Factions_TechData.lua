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
   
end