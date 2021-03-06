// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Marine\LayLaserMines.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/Weapon.lua")
Script.Load("lua/PickupableWeaponMixin.lua")
Script.Load("lua/Weapons/Marine/LayMines.lua")

class 'LayLaserMines' (LayMines)

LayLaserMines.kMapName = "lasermine"

local kDropModelName = PrecacheAsset("models/marine/mine/mine_pile.model")
local kHeldModelName = PrecacheAsset("models/marine/mine/mine_3p.model")

local kViewModelName = PrecacheAsset("models/marine/mine/mine_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/mine/mine_view.animation_graph")

local kPlacementDistance = 2

function LayLaserMines:OnInitialized()

    LayMines.OnInitialized(self)
    
    self:SetModel(kHeldModelName)
    
end

function LayLaserMines:GetIsValidRecipient(recipient)

    if self:GetParent() == nil and recipient and not GetIsVortexed(recipient) and recipient:isa("Marine") then
    
        local laymines = recipient:GetWeapon(LayLaserMines.kMapName)
        return laymines == nil
        
    end
    
    return false
    
end

function LayLaserMines:GetDropStructureId()
    return kTechId.LaserMine
end

function LayLaserMines:GetViewModelName()
    return kViewModelName
end

function LayLaserMines:GetAnimationGraphName()
    return kAnimationGraph
end

function LayLaserMines:GetSuffixName()
    return "mine"
end

function LayLaserMines:GetDropClassName()
    return "LaserMine"
end

function LayLaserMines:GetDropMapName()
    return LaserMine.kMapName
end

function LayLaserMines:GetHUDSlot()
    return kMinesHUDSlot
end
local function DropStructure(self, player)

    if Server then
    
        local showGhost, coords, valid = self:GetPositionForStructure(player)
        if valid then
        
            // Create mine.
            local mine = CreateEntity(self:GetDropMapName(), coords.origin, player:GetTeamNumber())
            if mine then
            
                mine:SetOwner(player)
                
                // Check for space
                if mine:SpaceClearForEntity(coords.origin) then
                
                    local angles = Angles()
                    angles:BuildFromCoords(coords)
                    mine:SetAngles(angles)
                    
                    player:TriggerEffects("create_" .. self:GetSuffixName())
                    
                    // Jackpot.
                    return true
                    
                else
                
                    player:TriggerInvalidSound()
                    DestroyEntity(mine)
                    
                end
                
            else
                player:TriggerInvalidSound()
            end
            
        else
        
            if not valid then
                player:TriggerInvalidSound()
            end
            
        end
        
    elseif Client then
        return true
    end
    
    return false
    
end

function LayLaserMines:PerformPrimaryAttack(player)

    local success = true
    
    if self.minesLeft > 0 then
    
        player:TriggerEffects("start_create_" .. self:GetSuffixName())
        
        local viewAngles = player:GetViewAngles()
        local viewCoords = viewAngles:GetCoords()
        
        success = DropStructure(self, player)
        
        if success then
            self.minesLeft = Clamp(self.minesLeft - 1, 0, kNumMines)
        end
        
    end
    
    return success
    
end

function LayLaserMines:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    // Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
    self.droppingMine = false
    
    self:SetModel(kHeldModelName)
    
end

function LayLaserMines:Dropped(prevOwner)

    Weapon.Dropped(self, prevOwner)
    
    self:SetModel(kDropModelName)
    
end

function LayMines:GetGhostModelName()
    return LookupTechData(self:GetDropStructureId(), kTechDataModel)
end

if Client then
	    
    function LayLaserMines:GetUIDisplaySettings()
        return { xSize = 256, ySize = 417, script = "lua/GUIMineDisplay.lua", textureNameOverride = "mine" }
    end
    
end

Shared.LinkClassToMap("LayLaserMines", LayLaserMines.kMapName, networkVars)
