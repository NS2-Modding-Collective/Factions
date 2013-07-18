//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Welder.lua

local networkVars = {
}

function Welder:GetHUDSlot()
    return kWelderHUDSlot
end

Class_Reload("Welder", networkVars)