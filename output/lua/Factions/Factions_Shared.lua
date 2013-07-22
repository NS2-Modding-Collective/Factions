// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Shared_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

// Locale hooks first
Script.Load("lua/Locale/OverrideLocale.lua")

// Then any files that adjust values go before the rest.
Script.Load("lua/Factions/Factions_TechTreeConstants.lua")
Script.Load("lua/Factions/Factions_Globals.lua")
Script.Load("lua/Factions/Factions_DamageTypes.lua")
Script.Load("lua/Factions/Factions_Balance.lua")

// Gamerules info
Script.Load("lua/Factions/Factions_GamerulesInfo.lua")

// Effects
Script.Load("lua/Factions/Effects/Factions_DamageEffects.lua")

// Classes, upgrades etc.
Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")
Script.Load("lua/Factions/Factions_XpMixin.lua")
Script.Load("lua/Factions/Factions_UpgradeMixin.lua")

// Weapons
Script.Load("lua/Factions/Weapons/Factions_ClipWeapon.lua")
Script.Load("lua/Factions/Weapons/Factions_Pistol.lua")
Script.Load("lua/Factions/Weapons/Factions_Rifle.lua")
Script.Load("lua/Factions/Weapons/Factions_Shotgun.lua")
Script.Load("lua/Factions/Weapons/Factions_GrenadeLauncher.lua")
Script.Load("lua/Factions/Weapons/Factions_Flamethrower.lua")
Script.Load("lua/Factions/Weapons/Factions_Axe.lua")
Script.Load("lua/Factions/Weapons/Factions_Welder.lua")
Script.Load("lua/Factions/Factions_Mine.lua")
Script.Load("lua/Factions/Weapons/Factions_LayMines.lua")
Script.Load("lua/Factions/Weapons/Factions_LayLaserMines.lua")
Script.Load("lua/Factions/Factions_LaserMine.lua")
Script.Load("lua/Factions/Weapons/Factions_MarineStructureAbility.lua")

// Class overrides here
Script.Load("lua/Factions/Factions_LiveMixin.lua")
Script.Load("lua/Factions/Factions_NS2Gamerules.lua")
Script.Load("lua/Factions/Factions_TechTree.lua")
Script.Load("lua/Factions/Factions_PlayingTeam.lua")
Script.Load("lua/Factions/Factions_Player.lua")
Script.Load("lua/Factions/Factions_Marine.lua")
Script.Load("lua/Factions/Factions_MarineSpectator.lua")
Script.Load("lua/Factions/Factions_JetpackMarine.lua")

// Alien Classes
Script.Load("lua/CamouflageMixin.lua")
Script.Load("lua/Factions/Factions_Alien.lua")

// Buildings
Script.Load("lua/Factions/Factions_CommandStructure.lua")
Script.Load("lua/Factions/Factions_StaticTargetMixin.lua")
Script.Load("lua/Factions/Factions_WeldableMixin.lua")
Script.Load("lua/Factions/Factions_MaturityMixin.lua")
Script.Load("lua/Factions/Factions_PowerConsumerMixin.lua")
Script.Load("lua/Factions/Factions_PowerPoint.lua")
Script.Load("lua/Factions/Factions_Sentry.lua")
Script.Load("lua/Factions/Factions_Armory.lua")
Script.Load("lua/Factions/Factions_MiniArmory.lua")
Script.Load("lua/Factions/Factions_Observatory.lua")
Script.Load("lua/Factions/Factions_PhaseGate.lua")
Script.Load("lua/Factions/Factions_InfantryPortal.lua")
Script.Load("lua/Factions/Factions_CommandStation.lua")
Script.Load("lua/Factions/Factions_Hive.lua")
Script.Load("lua/Factions/Factions_Extractor.lua")

// New classes here
Script.Load("lua/Factions/Factions_GenericGamerules.lua")
Script.Load("lua/Factions/Factions_CombatDeathmatchGamerules.lua")
Script.Load("lua/Factions/Factions_XenoswarmGamerules.lua")
Script.Load("lua/Factions/Factions_XpMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LightMachineGun.lua")
Script.Load("lua/Factions/Weapons/Factions_Knife.lua")
Script.Load("lua/Factions/Factions_InjuredPlayer.lua")

Script.Load("lua/Factions/Factions_AttachModel.lua")
Script.Load("lua/Factions/Factions_AttachModelUtility.lua")
Script.Load("lua/Factions/Factions_MarineChops.lua")

// Utility stuff
Script.Load("lua/Factions/Factions_NS2Utility.lua")

// NPC stuff
Script.Load("lua/Factions/Factions_NpcMixin.lua")

// TechData
Script.Load("lua/Factions/Factions_TechData.lua")

// NetworkMessages
Script.Load("lua/Factions/Factions_NetworkMessages.lua")