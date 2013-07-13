//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Armory.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Team Colours
local overrideOnInitialized = Armory.OnInitialized
function Armory:OnInitialized()

	overrideOnInitialized(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
	if Server and not HasMixin(self, "MapBlip") then
        InitMixin(self, MapBlipMixin)
    end
	
	self.isGhostStructure = false
	
end

function Armory:GetRequiresPower()
   return false
end

function Armory:GetCanBeUsedConstructed()
    return false
end    

function Armory:GetShouldResupplyPlayer(player)

    if not player:GetIsAlive() then
        return false
    end
    
    local isVortexed = self:GetIsVortexed() or ( HasMixin(player, "VortexAble") and player:GetIsVortexed() )
    if isVortexed then
        return false
    end    
    
    local inNeed = false
    
    // Don't resupply when already full
    if (player:GetHealth() < player:GetMaxHealth()) or
	   (player:GetArmor() < player:GetMaxArmor()) then
        inNeed = true
    else

        // Do any weapons need ammo?
        for i, child in ientitychildren(player, "ClipWeapon") do
        
            if child:GetNeedsAmmo(false) then
                inNeed = true
                break
            end
            
        end
        
    end
    
    if inNeed then
    
        // Check player facing so players can't fight while getting benefits of armory
        local viewVec = player:GetViewAngles():GetCoords().zAxis

        local toArmoryVec = self:GetOrigin() - player:GetOrigin()
        
        if(GetNormalizedVector(viewVec):DotProduct(GetNormalizedVector(toArmoryVec)) > .75) then
        
            if self:GetTimeToResupplyPlayer(player) then
        
                return true
                
            end
            
        end
        
    end
    
    return false
    
end

function Armory:ResupplyPlayer(player)
    
    local resuppliedPlayer = false
    
    // Heal player first
    if (player:GetHealth() < player:GetMaxHealth()) or  
	   (player:GetArmor() < player:GetMaxArmor()) then

        // third param true = ignore armor
        player:AddHealth(Armory.kHealAmount, false, false)

        self:TriggerEffects("armory_health", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
        
        TEST_EVENT("Armory resupplied health")
        
        resuppliedPlayer = true
        /*
        if HasMixin(player, "ParasiteAble") and player:GetIsParasited() then
        
            player:RemoveParasite()
            TEST_EVENT("Armory removed Parasite")
            
        end
        */
        
        if player:isa("Marine") and player.poisoned then
        
            player.poisoned = false
            TEST_EVENT("Armory cured Poison")
            
        end
        
    end

    // Give ammo to all their weapons, one clip at a time, starting from primary
    local weapons = player:GetHUDOrderedWeaponList()
    
    for index, weapon in ipairs(weapons) do
    
        if weapon:isa("ClipWeapon") then
        
            if weapon:GiveAmmo(1, false) then
            
                self:TriggerEffects("armory_ammo", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
                
                resuppliedPlayer = true
                
                TEST_EVENT("Armory resupplied health/armor")
                
                break
                
            end 
                   
        end
        
    end
        
    if resuppliedPlayer then
    
        // Insert/update entry in table
        self.resuppliedPlayers[player:GetId()] = Shared.GetTime()
        
        // Play effect
        //self:PlayArmoryScan(player:GetId())

    end

end

Class_Reload("Armory", networkVars)