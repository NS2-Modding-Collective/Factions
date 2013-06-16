//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SoundEffect.lua

kFactionsTriggerSoundType = enum({ 'Taunt', 'Health', 'Ammo' })

local kFactionsTriggerSounds =
{
    "sound/NS2.fev/alien/skulk/taunt" = kFactionsTriggerSoundType.Taunt,
    "sound/NS2.fev/alien/gorge/taunt" = kFactionsTriggerSoundType.Taunt,
    "sound/NS2.fev/alien/lerk/taunt" = kFactionsTriggerSoundType.Taunt,
    "sound/NS2.fev/alien/fade/taunt" = kFactionsTriggerSoundType.Taunt,
    "sound/NS2.fev/alien/onos/taunt" = kFactionsTriggerSoundType.Taunt,
    "sound/NS2.fev/alien/common/swarm" = kFactionsTriggerSoundType.Taunt,
	"sound/NS2.fev/marine/voiceovers/taunt" = kFactionsTriggerSoundType.Taunt,
	"sound/NS2.fev/marine/voiceovers/medpack" = kFactionsTriggerSoundType.Health,
	"sound/NS2.fev/marine/voiceovers/weld" = kFactionsTriggerSoundType.Health,
	"sound/NS2.fev/marine/voiceovers/ammo" = kFactionsTriggerSoundType.Ammo,
}

local originalStartSoundEffectOnEntity = StartSoundEffectOnEntity
function StartSoundEffectOnEntity(soundName, player, volume, player2)
	local soundEffectEntity = originalStartSoundEffectOnEntity(soundName, player, volume, player2)
	
	local tauntSoundType = kFactionsTriggerSounds[soundName]
	if tauntSoundType ~= nil then
	
		// Check whether the sound is a taunt sound
		if (tauntSoundType == kFactionsTriggerSoundType.Taunt) then
			
			// Now check whether the player has taunted recently and fire taunt abilities.
			//onEntity:ProcessTauntAbilities()
			
		end
		
		// Check whether the sound is a taunt sound
		if (tauntSoundType == kFactionsTriggerSoundType.Health) then
			
			// Xenoswarm: Fire the health pack upgrade buy logic
			
		end
		
		// Check whether the sound is a taunt sound
		if (tauntSoundType == kFactionsTriggerSoundType.Ammo) then
			
			// Xenoswarm: Fire the ammo pack upgrade buy logic
			
		end
		
	end
end