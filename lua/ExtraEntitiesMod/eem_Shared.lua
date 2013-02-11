//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// fsfod hooker files
Script.Load("lua/ExtraEntitiesMod/PathUtil.lua")
Script.Load("lua/ExtraEntitiesMod/fsfod_scripts.lua")

// add every new class (entity based) here

Script.Load("lua/ExtraEntitiesMod/eem_Globals.lua")

LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/eem_Utility.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/TeleportTrigger.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/FuncTrain.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/FuncTrainWaypoint.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/FuncMoveable.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/FuncDoor.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/PushTrigger.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/PortalGunTeleport.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicTimer.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicMultiplier.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicWeldable.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicFunction.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicCounter.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicTrigger.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/LogicLua.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/MapSettings.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/NobuildArea.lua", nil)


LoadTracker:LoadScriptAfter("lua/weapons/Marine/Rifle.lua", "lua/ExtraEntitiesMod/PortalGun.lua", nil)

// file overrides
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/ExtraEntitiesMod/eem_MovementModifier.lua", nil)


if Client then
//	Script.Load("lua/ExtraEntitiesMod/eem_Player_Client.lua")
//	Script.Load("lua/ExtraEntitiesMod/Hud/GUIFuncTrain.lua")
end


