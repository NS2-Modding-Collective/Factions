//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Axe.lua

local networkVars = {
}

function Axe:GetHUDSlot()
    return kAxeHUDSlot
end

Class_Reload("Axe", networkVars)