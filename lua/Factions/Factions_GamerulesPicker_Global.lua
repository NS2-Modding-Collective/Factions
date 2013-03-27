// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =====
//
// Based on:
// lua\Gamerules_Global.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
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

// Factions_GamerulesPicker_Global.lua

kFactionsGameType = enum( { 'CombatDeathmatch', 'Horde' } )

// Global gamerules accessors. When gamerulesPicker is initialized by map they should call SetGamerules(). 
globalGamePicker = globalGamePicker or nil

function GetHasGamerulesPicker()
    return globalGamePicker ~= nil
end

function SetGamerulesPicker(gamerulesPicker)

    if gamerulesPicker ~= globalGamePicker then
        globalGamePicker = gamerulesPicker
    end
    
end

function GetGamerulesPicker()

    if Server then
        return globalGamePicker
    end
    
    return nil
    
end
