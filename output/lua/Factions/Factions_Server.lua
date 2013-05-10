// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Server_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

/**
 * Map entities with a higher priority are loaded first.
 */
Script.Load("lua/Factions/Factions_Shared.lua")

// Hooks for files that are not in Shared.lua need to go here.
Script.Load("lua/Factions/Factions_NS2Utility.lua")
Script.Load("lua/Factions/Factions_MarineTeam.lua")
Script.Load("lua/Factions/Factions_TeamMessenger.lua")
Script.Load("lua/Factions/Factions_ConsoleCommands.lua")
Script.Load("lua/Factions/Factions_NetworkMessages_Server.lua")