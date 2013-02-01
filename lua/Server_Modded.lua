// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Server_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/PreLoadMod.lua")

Script.Load("lua/Shared.lua")
Script.Load("lua/ClassUtility.lua")
Script.Load("lua/Shared_Modded.lua")

Script.Load("lua/Server.lua")

// Hooks for files that are not in Shared.lua need to go here.

Script.Load("lua/PostLoadMod.lua")