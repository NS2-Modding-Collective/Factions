//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_DamageEffects.lua

// Add bullet holes to the LMG.
local kLMGBulletHole = {decal = "cinematics/vfx_materials/decals/bullet_hole_01.material", scale = 0.125, doer = "LightMachineGun", alt_mode = false, done = true}

table.insert(kDamageEffects.damage_decal.damageDecals, kLMGBulletHole)