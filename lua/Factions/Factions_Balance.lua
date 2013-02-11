//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Balance.lua

// Game rules
kInitialTokenValue = 500

// Sprinting
SprintMixin.kMaxSprintTime = 6 // 1 sec
SprintMixin.kSprintRecoveryRate = .5 // 0.5 sec

// Spawning logic
kRespawnTimer = 12
kSpawnMaxRetries = 50
kSpawnMinDistance = 2
kSpawnMaxDistance = 70
kSpawnMaxVertical = 30
kSpawnProtectDelay = 0.1
kSpawnProtectTime = 2
kNanoShieldDamageReductionDamage = 0.1

// MARINE DAMAGE VALUES
kRifleDamage = 35
kRifleDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Rifle, kTechDataDamageType, kRifleDamageType)
kRifleClipSize = 30

kLightMachineGunWeight = 0.05
kLightMachineGunDamage = 20
kLightMachineGunClipSize = 50
kLightMachineGunDamageType = kDamageType.Light
kLightMachineGunCost = 10

kPistolDamage = 60
kPistolDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Pistol, kTechDataDamageType, kPistolDamageType)
kPistolClipSize = 8

kWelderDamagePerSecond = 50
kWelderDamageType = kDamageType.Flame
SetCachedTechData(kTechId.Welder, kTechDataDamageType, kWelderDamageType)
kWelderFireDelay = 0.2

kAxeDamage = 100
kAxeDamageType = kDamageType.Structural
SetCachedTechData(kTechId.Axe, kTechDataDamageType, kAxeDamageType)

kGrenadeLauncherGrenadeDamage = 150
kGrenadeLauncherClipSize = 4
kGrenadeLauncherGrenadeDamageRadius = 8
kGrenadeLifetime = 2.0

kShotgunDamage = 20
kShotgunClipSize = 5
kShotgunBulletsPerShot = 17
kShotgunRange = 40

kNadeLauncherClipSize = 4

kFlamethrowerDamage = 7.5
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

kMineDamage = 125

kSentryAttackBaseROF = .15
kSentryAttackRandROF = 0.0
kSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 2.0

kSentryDamage = 5

kWeapons1DamageScalar = 1.1
kWeapons2DamageScalar = 1.2
kWeapons3DamageScalar = 1.3

kNanoShieldDamageReductionDamage = 0.5