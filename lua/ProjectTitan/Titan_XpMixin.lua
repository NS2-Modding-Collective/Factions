//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_ScoringMixin.lua

// change the score value of the things

/*
    Classes (base xp you get when you kill someone, 
    will be multiplied by the XpMultiplier from his level)
    TODO: Also include every new class
*/

kMarinePointValue = 60
kJetpackPointValue = 80
kExosuitPointValue = 120

// Buildings
// only get 80 % xp of what the building has cost when you destroy it
local buildingXpFactor = 0.8
kArmoryPointValue = kArmoryCost * buildingXpFactor
kObservatoryPointValue = kObservatoryCost * buildingXpFactor
kPhaseGatePointValue = kPhaseGateCost * buildingXpFactor
kSentryPointValue = kSentryCost * buildingXpFactor
kPowerPointPointValue = 0

kMinePointValue =  kMineCost * buildingXpFactor

// default start xp
kStartXp = 0

// How much lvl you will lose when you rejoin the same team
kPenaltyLevel = 1

// list will all level names, given xp, needed xp for next lvl etc.
kXpList = {}
//              Level       NeededXp    LevelName                       XpMultiplier (the killer gets)                
kXpList[1] = { Level=1, 		XP=0,		MarineName="Private", 				XpMultiplier=1}
kXpList[2] = { Level=2, 		XP=100, 	MarineName="Private First Class", 	XpMultiplier=1.1}
kXpList[3] = { Level=3, 		XP=250, 	MarineName="Corporal", 				XpMultiplier=1.2}
kXpList[4] = { Level=4, 		XP=500, 	MarineName="Sergeant", 				XpMultiplier=1.3}
kXpList[5] = { Level=5, 		XP=800, 	MarineName="Lieutenant", 			XpMultiplier=1.4}
kXpList[6] = { Level=6, 		XP=1100, 	MarineName="Captain", 				XpMultiplier=1.5}
kXpList[7] = { Level=7, 		XP=1450, 	MarineName="Commander", 			XpMultiplier=1.6}
kXpList[8] = { Level=8, 		XP=1900, 	MarineName="Major", 				XpMultiplier=1.7}
kXpList[9] = { Level=9, 		XP=2300, 	MarineName="Field Marshal", 		XpMultiplier=1.8}
kXpList[10] = { Level=10, 	XP=2800, 	MarineName="General", 				XpMultiplier=1.9}
kXpList[11] = { Level=11, 	XP=3500, 	MarineName="President", 			XpMultiplier=2.0}
kXpList[12] = { Level=12, 	XP=4500, 	MarineName="Badass", 				XpMultiplier=2.1}
kXpList[13] = { Level=13, 	XP=6000, 	MarineName="Rambo", 				XpMultiplier=2.2}
kMaxLvl = table.maxn(kXpList)
kMaxXp = kXpList[kMaxLvl]["XP"]
