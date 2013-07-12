//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LayMines.lua

local networkVars = {
}

function LayMines:GetHUDSlot()
    return kMinesHUDSlot
end

Class_Reload("LayMines", networkVars)