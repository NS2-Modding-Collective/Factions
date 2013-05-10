//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'RegenerationUpgrade' (FactionsTimedUpgrade)

RegenerationUpgrade.kBaseRegenScalar = 0.05
RegenerationUpgrade.kBoostRegenScalarPerLevel = 0.02

// Define these statically so we can easily access them without instantiating too.
RegenerationUpgrade.cost = { 250, 250, 400, 400, 800 }                              	// Cost of the upgrade in xp
RegenerationUpgrade.upgradeName = "regen"                     							// Text code of the upgrade if using it via console
RegenerationUpgrade.upgradeTitle = "Regeneration"               						// Title of the upgrade, e.g. Submachine Gun
RegenerationUpgrade.upgradeDesc = "Periodically regenerate health and armor"			// Description of the upgrade
RegenerationUpgrade.upgradeTechId = kTechId.Regeneration								// TechId of the upgrade, default is kTechId.Move cause its the first entry
RegenerationUpgrade.triggerInterval	= { 3, 3, 2, 2, 1 } 								// Specify the timer interval (in seconds) per level.
RegenerationUpgrade.teamType = kFactionsUpgradeTeamType.AlienTeam						// Team Type

function RegenerationUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = RegenerationUpgrade.cost
	self.upgradeName = RegenerationUpgrade.upgradeName
	self.upgradeTitle = RegenerationUpgrade.upgradeTitle
	self.upgradeDesc = RegenerationUpgrade.upgradeDesc
	self.upgradeTechId = RegenerationUpgrade.upgradeTechId
	self.triggerInterval = RegenerationUpgrade.triggerInterval
	self.teamType = RegenerationUpgrade.teamType
	
end

function RegenerationUpgrade:GetClassName()
	return "RegenerationUpgrade"
end

function RegenerationUpgrade:GetRegenScalar()
	return RegenerationUpgrade.kBaseRegenScalar + self:GetCurrentLevel() * RegenerationUpgrade.kBoostRegenScalarPerLevel
end

function RegenerationUpgrade:GetRegenPercentString()
	return self:GetRegenScalar()*100 .. "%"
end

function RegenerationUpgrade:GetTimerDescription()
	return "You will regenerate by " .. self:GetRegenPercentString() .. " every "
end

function RegenerationUpgrade:NeedsRegenerate(player)
        
	// Ammo packs give ammo to clip as well (so pass true to GetNeedsAmmo())
	// check every weapon the player got
	local weapon = player:GetActiveWeapon()
	local needsHealth = player:GetHealth() < player:GetMaxHealth()
	local needsArmor = player:GetArmor() < player:GetMaxArmor()
		
	return needsArmor or needsHealth

end

function RegenerationUpgrade:RegenerateNow(player)

	local regenAmount = (player:GetMaxHealth() + player:GetMaxArmor()) * self:GetRegenScalar()
	local oldHealth = player:GetHealth()
	local oldArmor = player:GetArmor()
	
	// Health first, then Armor!
	local newHealth = math.min(player:GetHealth() + regenAmount, player:GetMaxHealth())
	player:SetHealth(newHealth)
	regenAmount = newHealth - oldHealth
	
	if regenAmount > 0 then
		local newArmor = math.min(player:GetArmor() + regenAmount, player:GetMaxArmor())
		player:SetArmor(newArmor)
	end

end

function RegenerationUpgrade:OnTrigger(player)
	if player and self:NeedsRegenerate(player) then
		self:RegenerateNow(player)
	end
end

function RegenerationUpgrade:CanApplyUpgrade(player)
	local baseText = FactionsTimedUpgrade.CanApplyUpgrade(self, player)
	
	if baseText ~= "" then
		return baseText
	elseif not player:isa("Alien") then
		return "Entity needs to be an Alien!"
	else
		return ""
	end
end