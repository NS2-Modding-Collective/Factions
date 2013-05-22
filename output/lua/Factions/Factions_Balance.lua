//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Balance.lua

// Game rules
kInitialTimeLeft = 25
kInitialTokenValue = 500

// Sprinting
SprintMixin.kMaxSprintTime = 7 // 1 sec
SprintMixin.kSprintRecoveryRate = .5 // 0.5 sec

// Spawning logic
kRespawnTimer = 8
kSpawnMaxRetries = 50
kSpawnMinDistance = 2
kSpawnMaxDistance = 70
kSpawnMaxVertical = 30
kSpawnProtectDelay = 0.1
kSpawnProtectTime = 2
kNanoShieldDamageReductionDamage = 0.1

// MARINE DAMAGE VALUES
kRifleDamage = 18
kRifleDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Rifle, kTechDataDamageType, kRifleDamageType)
kRifleClipSize = 30

kLightMachineGunWeight = 0.05
kLightMachineGunDamage = 15
kLightMachineGunClipSize = 50
kLightMachineGunDamageType = kDamageType.Light
kLightMachineGunCost = 10

kPistolDamage = 30
kPistolDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Pistol, kTechDataDamageType, kPistolDamageType)
kPistolClipSize = 8

kWelderDamagePerSecond = 60
kWelderDamageType = kDamageType.Flame
SetCachedTechData(kTechId.Welder, kTechDataDamageType, kWelderDamageType)
kWelderFireDelay = 0.2

kAxeDamage = 45
kAxeDamageType = kDamageType.Structural
SetCachedTechData(kTechId.Axe, kTechDataDamageType, kAxeDamageType)

kKnifeWeight = 0.05
kKnifeDamage = 65
kKnifeRange = 30
kKnifeDamageType = kDamageType.Normal
kKnifeCost = 10

kSwordWeight = 0.05
kSwordDamage = 65
kSwordRange = 30
kSwordDamageType = kDamageType.Normal
kSwordCost = 10

kGrenadeLauncherGrenadeDamage = 100
kGrenadeLauncherClipSize = 4
kGrenadeLauncherGrenadeDamageRadius = 8
kGrenadeLifetime = 2.0

kShotgunDamage = 16
kShotgunClipSize = 5
kShotgunBulletsPerShot = 15
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

kMineDamage = 150

// Power points
kPowerPointHealth = 1000	
kPowerPointArmor = 400	
kPowerPointPointValue = 0

kSentryAttackBaseROF = .15
kSentryAttackRandROF = 0.0
kSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 2.0

// Building
kNumSentriesPerPlayer = 2
kSentryCost = 150
kSentryDamage = 15
kPhaseGateCost = 350
kNumPhasegatesPerPlayer = 2
kArmoryCost = 250
kNumArmoriesPerPlayer = 1
kObservatoryCost = 150
kNumObservatoriesPerPlayer = 1

kWeapons1DamageScalar = 1.1
kWeapons2DamageScalar = 1.2
kWeapons3DamageScalar = 1.3

kNanoShieldDamageReductionDamage = 0.5

// The rate at which players gain XP for healing... relative to damage dealt.
kHealXpRate = 1
// Rate at which players gain XP for healing other players...
kPlayerHealXpRate = 0