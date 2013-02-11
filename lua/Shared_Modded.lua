// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Shared_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/ModUtility.lua")

// Locale hooks first
Script.Load("lua/Locale/OverrideLocale.lua")

// Then any files that adjust values go before the rest.
Script.Load("lua/Factions/Factions_TechTreeConstants.lua")
Script.Load("lua/Factions/Factions_Globals.lua")
Script.Load("lua/Factions/Factions_Balance.lua")

// Extra Entities
Script.Load("lua/ExtraEntitiesMod/eem_Globals.lua")
Script.Load("lua/ExtraEntitiesMod/eem_Utility.lua")
Script.Load("lua/ExtraEntitiesMod/NS2Gamerules_hook.lua")
Script.Load("lua/ExtraEntitiesMod/TeleportTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/FuncTrain.lua")
Script.Load("lua/ExtraEntitiesMod/FuncTrainWaypoint.lua")
Script.Load("lua/ExtraEntitiesMod/FuncMoveable.lua")
Script.Load("lua/ExtraEntitiesMod/FuncDoor.lua")
Script.Load("lua/ExtraEntitiesMod/PushTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/PortalGunTeleport.lua")
Script.Load("lua/ExtraEntitiesMod/LogicTimer.lua")
Script.Load("lua/ExtraEntitiesMod/LogicMultiplier.lua")
Script.Load("lua/ExtraEntitiesMod/LogicWeldable.lua")
Script.Load("lua/ExtraEntitiesMod/LogicFunction.lua")
Script.Load("lua/ExtraEntitiesMod/LogicCounter.lua")
Script.Load("lua/ExtraEntitiesMod/LogicTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/LogicLua.lua")
Script.Load("lua/ExtraEntitiesMod/MapSettings.lua")
Script.Load("lua/ExtraEntitiesMod/NobuildArea.lua")
Script.Load("lua/ExtraEntitiesMod/PortalGun.lua")

Script.Load("lua/ExtraEntitiesMod/eem_MovementModifier.lua")

// Class overrides here
Script.Load("lua/Factions/Factions_NS2Gamerules.lua")
Script.Load("lua/Factions/Factions_Player.lua")
Script.Load("lua/Factions/Factions_Marine.lua")
Script.Load("lua/Factions/Factions_JetpackMarine.lua")

Script.Load("lua/Factions/Weapons/Factions_Pistol.lua")
Script.Load("lua/Factions/Weapons/Factions_Rifle.lua")
Script.Load("lua/Factions/Weapons/Factions_Shotgun.lua")

// New classes here
Script.Load("lua/Factions/Factions_GenericGamerules.lua")
Script.Load("lua/Factions/Factions_CombatDeathmatchGamerules.lua")
Script.Load("lua/Factions/Factions_XpMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LightMachineGun.lua")

// TechData
Script.Load("lua/Factions/Factions_TechData.lua")