//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ResupplyUpgrade' (FactionsTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
ResupplyUpgrade.cost = { 100, 200, 400 }                              					// Cost of the upgrade in xp
ResupplyUpgrade.levels = 3																// How many levels are there to this upgrade
ResupplyUpgrade.upgradeName = "resupply"                     							// Text code of the upgrade if using it via console
ResupplyUpgrade.upgradeTitle = "Resupply"               								// Title of the upgrade, e.g. Submachine Gun
ResupplyUpgrade.upgradeDesc = "Periodically stock up on health and ammo"				// Description of the upgrade
ResupplyUpgrade.upgradeTechId = kTechId.Resupply										// TechId of the upgrade, default is kTechId.Move cause its the first entry
ResupplyUpgrade.triggerInterval	= { 12, 10, 8 } 										// Specify the timer interval (in seconds) per level.

function ResupplyUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ResupplyUpgrade.cost
	self.levels = ResupplyUpgrade.levels
	self.upgradeName = ResupplyUpgrade.upgradeName
	self.upgradeTitle = ResupplyUpgrade.upgradeTitle
	self.upgradeDesc = ResupplyUpgrade.upgradeDesc
	self.upgradeTechId = ResupplyUpgrade.upgradeTechId
	self.triggerInterval = ResupplyUpgrade.triggerInterval
	
end

function ResupplyUpgrade:GetClassName()
	return "ResupplyUpgrade"
end

function ResupplyUpgrade:GetTimerDescription()
	return "Resupply will happen every "
end

local function NeedsResupply(player)
        
	// Ammo packs give ammo to clip as well (so pass true to GetNeedsAmmo())
	// check every weapon the player got
	local weapon = player:GetActiveWeapon()
	local needsHealth = not GetIsVortexed(player) and player:GetHealth() < player:GetMaxHealth()
	local needsAmmo = false

	for i = 0, player:GetNumChildren() - 1 do
	
		local child = player:GetChildAtIndex(i)
		if child:isa("ClipWeapon") then
			
			needsAmmo = child ~= nil and child:GetNeedsAmmo(false) and not GetIsVortexed(player)
			if needsAmmo then
				break
			end      
				
		end
		
	end
		
	return needsAmmo or needsHealth

end

local function GiveAllAmmo(player)

	for i = 0, player:GetNumChildren() - 1 do

		local child = player:GetChildAtIndex(i)
		if child:isa("ClipWeapon") then
			
			if child:GetNeedsAmmo(false) then
				child:GiveAmmo(AmmoPack.kNumClips, false)
			end
				
		end
		
	end

	StartSoundEffectAtOrigin(AmmoPack.kPickupSound, player:GetOrigin())

end

local function ResupplyNow(player)

	local success = false
	local mapNameHealth = LookupTechData(kTechId.MedPack, kTechDataMapName) 
	local position = player:GetOrigin()

	if (mapNameHealth) then
	
		local droppackHealth = CreateEntity(mapNameHealth, position, player:GetTeamNumber())
		// dont drop a ammo pack, give ammo via a new function
		GiveAllAmmo(player)
		
		StartSoundEffectAtOrigin(MedPack.kHealthSound, player:GetOrigin())
		success = true
		
		//Destroy them so they can't be used by somebody else (if they are unused)
		DestroyEntity(droppackHealth)		
	end

	return success

end

function ResupplyUpgrade:OnTrigger(player)
	if (NeedsResupply(player)) then
		ResupplyNow(player)
	end
end