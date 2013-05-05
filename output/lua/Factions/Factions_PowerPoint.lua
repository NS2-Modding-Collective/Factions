//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_PowerPoint.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local kSocketedModelName = PrecacheAsset("models/system/editor/power_node.model")
local kSocketedAnimationGraph = PrecacheAsset("models/system/editor/power_node.animation_graph")
local kAuxPowerBackupSound = PrecacheAsset("sound/NS2.fev/marine/power_node/backup")

PowerPoint.kAutoRepairTime = 30

local networkVars = {
}

if Server then

	// Do this on a delay so GetIsBuilt is ready.
	local function SwitchOffNodes(self)

		// Start socketed but unbuilt
		// TODO: allow the mapper to define the default power mode!
		if not self:GetIsBuilt() then
			self:FactionsPowerUp()
			self:OnKill()
		end
		
		return false

	end

	function PowerPoint:FactionsPowerUp()

		self:SetModel(kSocketedModelName, kSocketedAnimationGraph)
		self:SetInternalPowerState(PowerPoint.kPowerState.socketed)
		self:SetConstructionComplete()
		self:SetLightMode(kLightMode.Normal)
		self:StopSound(kAuxPowerBackupSound)
		self:TriggerEffects("fixed_power_up")
		self:SetPoweringState(true)
		
	end

	local function AutoMagicRepair(self)
		self.health = kPowerPointHealth
		self.armor = kPowerPointArmor
		
		self.maxHealth = kPowerPointHealth
		self.maxArmor = kPowerPointArmor
		
		self.alive = true
		
		self:FactionsPowerUp()
		return false
	end

	function PowerPoint:FactionsSetUpPowerNodes()

		if GetGamerulesInfo():GetLightsStartOff() then
			self:AddTimedCallback(SwitchOffNodes, 0.2)
		elseif GetGamerulesInfo():GetIsCombatRules() then
			self:FactionsPowerUp()
		end

	end

	// Team Colours
	local overrideOnInitialized = PowerPoint.OnInitialized
	function PowerPoint:OnInitialized()

		overrideOnInitialized(self)
		
		self:FactionsSetUpPowerNodes()
		
		// Team Colours
		if GetGamerulesInfo():GetUsesMarineColours() then
			InitMixin(self, TeamColoursMixin)
			assert(HasMixin(self, "TeamColours"))
		end

	end

	local overrideReset = PowerPoint.Reset
	function PowerPoint:Reset()
		
		overrideReset(self)
		
		self:FactionsSetUpPowerNodes()
		
	end

	function PowerPoint:PowerPointGetCanTakeDamageOverride(self)
		return GetGamerulesInfo():GetPowerPointsTakeDamage()
	end

	local overrideOnKill = PowerPoint.OnKill
	// Add an auto-repair timer if needed.
	function PowerPoint:OnKill(attacker, doer, point, direction)

		overrideOnKill(self, attacker, doer, point, direction)
		
		if GetGamerulesInfo():GetPowerPointsTakeDamage() and attacker and attacker:isa("Player") then
			self:AddTimedCallback(AutoMagicRepair, PowerPoint.kAutoRepairTime)
		end
	end
end

Class_Reload("PowerPoint", networkVars)