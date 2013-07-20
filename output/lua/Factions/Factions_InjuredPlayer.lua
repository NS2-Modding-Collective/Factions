// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =====
//
// lua\DevouredPlayer.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Factions/Factions_TimerMixin.lua")

class 'InjuredPlayer' (Marine)

InjuredPlayer.kMapName = "injured_player"

local networkVars =
{
}

AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(TimerMixin, networkVars)

function InjuredPlayer:OnCreate()

    Marine.OnCreate(self)
    InitMixin(self, ConstructMixin)
    
    assert(HasMixin(self, "Construct"))
    
end


function InjuredPlayer:OnInitialized()

    Marine.OnInitialized(self)
  
    // Remove physics
    self:DestroyController()
    
    // due to a bug with MarineActionFinder, this need to be called here
    if Client then
    
        self.actionIconGUI = GetGUIManager():CreateGUIScript("GUIActionIcon")
        self.actionIconGUI:SetColor(kMarineFontColor)
        self.lastMarineActionFindTime = 0
        
    end
    
    self:SetHealth(kInjuredPlayerInitialHealth)
    self:SetArmor(kInjuredPlayerInitialArmor)
    
    // Initialise the auto-damage process
    if Server then
    	self.lastAutoDamageTime = Shared.GetTime()
    end
	
	self:SetDesiredCamera(1.1, { follow = true, tweening = kTweeningFunctions.easeout7 })
	self:SetCameraDistance(kGestateCameraDistance)
    
end

// let the player chat, but but nove
function InjuredPlayer:OverrideInput(input)
  
    ClampInputPitch(input)
    
    // Completely override movement and commands
    input.move.x = 0
    input.move.y = 0
    input.move.z = 0
    
    // Only allow some actions like going to menu, chatting and Scoreboard (not jump, use, etc.)
    input.commands = bit.band(input.commands, Move.Exit) + bit.band(input.commands, Move.TeamChat) + bit.band(input.commands, Move.TextChat) + bit.band(input.commands, Move.Scoreboard) + bit.band(input.commands, Move.Minimap)
    
    return input
    
end


function InjuredPlayer:GetDeathPercentage()
    return self:GetHealth() / self:GetMaxHealth()
end

function InjuredPlayer:OnProcessMove(input)
    self:OnUpdatePlayer(input.time)
end

function InjuredPlayer:GetPlayFootsteps()
    return false
end

function InjuredPlayer:GetMovePhysicsMask()
    return PhysicsMask.All
end

function InjuredPlayer:GetCanTakeDamageOverride()
    return true
end

function InjuredPlayer:GetCanDieOverride()
    return true
end

function InjuredPlayer:AdjustGravityForce(input, gravity)
    return 0
end

function InjuredPlayer:GetMaxHealth()
	return kInjuredPlayerMaxHealth
end

function InjuredPlayer:GetMaxArmor()
	return kInjuredPlayerMaxArmor
end

-- ERASE OR REFACTOR
// Handle player transitions to egg, new lifeforms, etc.
function InjuredPlayer:OnEntityChange(oldEntityId, newEntityId)

    if oldEntityId ~= Entity.invalidId and oldEntityId ~= nil then
    
        if oldEntityId == self.specTargetId then
            self.specTargetId = newEntityId
        end
        
        if oldEntityId == self.lastTargetId then
            self.lastTargetId = newEntityId
        end
        
    end
    
end

function InjuredPlayer:GetPlayerStatusDesc()
    return kPlayerStatus.Rifle
end

function InjuredPlayer:GetTechId()
    return kTechId.Marine
end

// Every so often, damage the player!
function InjuredPlayer:OnUpdatePlayer(deltaTime)

	Player.OnUpdatePlayer(self, deltaTime)

	if Server then
		local timeNow = Shared.GetTime()
		// Do this in a while loop so laggy servers don't slow the drain rate
		while timeNow - self.lastAutoDamageTime > kInjuredPlayerHealthDrainInterval do
			local damage = kInjuredPlayerHealthDrainRate * kInjuredPlayerHealthDrainInterval
			self:TakeDamage(damage, nil, nil, nil, nil, 0, damage, kDamageType.Normal)
			self.lastAutoDamageTime = self.lastAutoDamageTime + kInjuredPlayerHealthDrainInterval
		end
	end
	
end

function InjuredPlayer:GetMaxViewOffsetHeight()
	return .2
end

if Client then

    function InjuredPlayer:UpdateClientEffects(deltaTime, isLocal)
    
        Marine.UpdateClientEffects(self, deltaTime, isLocal)
        
        self:SetIsVisible(false)
        
        local activeWeapon = self:GetActiveWeapon()
        if activeWeapon ~= nil then
            activeWeapon:SetIsVisible(false)
        end
        
        local viewModel = self:GetViewModelEntity()
        if viewModel ~= nil then
            viewModel:SetIsVisible(false)
        end
        
    end
        
end

Shared.LinkClassToMap("InjuredPlayer", InjuredPlayer.kMapName, networkVars)

if Server then
    local function OnCommandChangeClass(client)
        
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            player:Replace(InjuredPlayer.kMapName, player:GetTeamNumber(), false, player:GetOrigin())
        end
        
    end

    Event.Hook("Console_injured_player", OnCommandChangeClass)
end
