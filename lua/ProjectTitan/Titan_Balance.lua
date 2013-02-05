//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Balance.lua

// Version number
kTitanVersion = "0.1"

// Sprinting
SprintMixin.kMaxSprintTime = 6 // 1 sec
SprintMixin.kSprintRecoveryRate = .5 // 0.5 sec

// MARINE DAMAGE
kRifleDamage = 10
kRifleDamageType = kDamageType.Normal
kRifleClipSize = 50


kRifleMeleeDamage = 20
kRifleMeleeDamageType = kDamageType.Normal


kPistolDamage = 25
kPistolDamageType = kDamageType.Light
kPistolClipSize = 10

kPistolAltDamage = 40


kWelderDamagePerSecond = 30
kWelderDamageType = kDamageType.Flame
kWelderFireDelay = 0.2

kAxeDamage = 25
kAxeDamageType = kDamageType.Structural


kGrenadeLauncherGrenadeDamage = 130
kGrenadeLauncherGrenadeDamageType = kDamageType.Structural
kGrenadeLauncherClipSize = 4
kGrenadeLauncherGrenadeDamageRadius = 6
kGrenadeLifetime = 2.0

kShotgunDamage = 11
kShotgunDamageType = kDamageType.Normal
kShotgunClipSize = 8
kShotgunBulletsPerShot = 17
kShotgunRange = 30

kNadeLauncherClipSize = 4

kFlamethrowerDamage = 7.5
kFlamethrowerDamageType = kDamageType.Flame
kFlamethrowerClipSize = 30

kBurnDamagePerStackPerSecond = 3
kFlamethrowerMaxStacks = 20
kFlamethrowerBurnDuration = 6
kFlamethrowerStackRate = 0.4
kFlameRadius = 1.8
kFlameDamageStackWeight = 0.5

kMinigunDamage = 25
kMinigunDamageType = kDamageType.Heavy
kMinigunClipSize = 250

kClawDamage = 50
kClawDamageType = kDamageType.Structural

kRailgunDamage = 50
kRailgunChargeDamage = 100
kRailgunDamageType = kDamageType.Puncture

kMACAttackDamage = 5
kMACAttackDamageType = kDamageType.Normal
kMACAttackFireDelay = 0.6


kMineDamage = 125
kMineDamageType = kDamageType.Light

kSentryAttackDamageType = kDamageType.Normal
kSentryAttackBaseROF = .15
kSentryAttackRandROF = 0.0
kSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 2.0

kSentryDamage = 5

kARCDamage = 450
kARCDamageType = kDamageType.Splash // splash damage hits friendly arcs as well
kARCRange = 26
kARCMinRange = 7

kWeapons1DamageScalar = 1.1
kWeapons2DamageScalar = 1.2
kWeapons3DamageScalar = 1.3

kNanoShieldDamageReductionDamage = 0.5