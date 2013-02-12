// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Client_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/PreLoadMod.lua")

Script.Load("lua/Shared.lua")
Script.Load("lua/ClassUtility.lua")
Script.Load("lua/Shared_Modded.lua")

Script.Load("lua/Client.lua")

// Client-specific code goes here
Script.Load("lua/Factions/Factions_Player_Client.lua")
Script.Load("lua/Factions/Factions_Marine_Client.lua")
Script.Load("lua/Factions/Factions_NetworkMessages_Client.lua")

Script.Load("lua/PostLoadMod.lua")