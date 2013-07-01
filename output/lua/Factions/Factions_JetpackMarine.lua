//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_JetpackMarine.lua

local networkVars = {
}

// Balance, movement, animation
JetpackMarine.kJetpackFuelReplenishDelay = .4
JetpackMarine.kJetpackGravity = -9
JetpackMarine.kVerticalThrustAccelerationMod = 3
JetpackMarine.kVerticalFlyAccelerationMod = 1.6
JetpackMarine.kJetpackAcceleration = 20
JetpackMarine.kFlySpeed = 10

function JetpackMarine:GetAirFriction()
    return 0.2
end

Class_Reload("JetpackMarine", networkVars)