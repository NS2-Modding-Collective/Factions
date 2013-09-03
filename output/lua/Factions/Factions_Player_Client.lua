//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Player_Client.lua

// Close the menu when a player dies.
local overrideAddTakeDamageIndicator = Player.AddTakeDamageIndicator
function Player:AddTakeDamageIndicator(damagePosition)    
    if not self:GetIsAlive() and not self.deathTriggered then    
		self:CloseMenu(true)        
    end
	
	overrideAddTakeDamageIndicator(self, damagePosition)
end


local overrideUpdateCrossHairText
overrideUpdateCrossHairText = Class_ReplaceMethod( "Player", "UpdateCrossHairText", 
	function(self, entity)
        if self.classSelectMenu ~= nil then
            self.crossHairText = nil
            self.crossHairHealth = 0
            self.crossHairMaturity = 0
            self.crossHairBuildStatus = 0
            return
        else
            return overrideUpdateCrossHairText(self, entity) 
        end
	end
)


function PlayerUI_GetIsUsingIronSight()

	local player = Client.GetLocalPlayer()
    local ironSightActive = false
    
    if player then
    
        if HasMixin(player, "IronSightViewer") then
			local weapon = player:GetActiveWeapon()
			if weapon and HasMixin(weapon, "IronSight") then
				ironSightActive = player:GetActiveWeapon():GetIronSightActive()
			end
        end
        
    end
    
    return ironSightActive

end

/**
 * Get the Y position of the crosshair image in the atlas.
 * Listed in this order:
 *   Rifle, Pistol, Axe, Shotgun, Minigun, Rifle with GL, Flamethrower
 */
function PlayerUI_GetCrosshairY()

    local player = Client.GetLocalPlayer()

    if(player and not player:GetIsThirdPerson()) then  
      
        local weapon = player:GetActiveWeapon()
        if(weapon ~= nil) then
        
            // Get class name and use to return index
            local index 
            local mapname = weapon:GetMapName()
            
            if mapname == Rifle.kMapName then 
                index = 0
			elseif mapname == LightMachineGun.kMapName then 
                index = 0
            elseif mapname == Pistol.kMapName then
                index = 1
            elseif mapname == Shotgun.kMapName then
                index = 3
            elseif mapname == Minigun.kMapName then
                index = 4
            elseif mapname == Flamethrower.kMapName then
                index = 5
            // All alien crosshairs are the same for now
            elseif mapname == LerkBite.kMapName or mapname == Spores.kMapName or mapname == LerkUmbra.kMapName or mapname == Parasite.kMapName then
                index = 6
            elseif mapname == SpitSpray.kMapName or mapname == BabblerAbility.kMapName then
                index = 7
            // Blanks (with default damage indicator)
            else
                index = 8
            end
        
            return index * 64
            
        end
        
    end

end

function PlayerUI_GetTeamType()

	local player = Client.GetLocalPlayer()
    if player then
    
    	local teamNumber = player:GetTeamNumber()
        return GetGamerulesInfo():GetTeamType(teamNumber)
        
    end
    
    return kNeutralTeamType

end

function PlayerUI_GetPlayerJetpackFuel()

    local player = Client.GetLocalPlayer()
    
	if player:isa("Marine") then
		return player:GetFuel()
	end
    
    return 0
    
end

local function LocalIsFriendlyCommander(player, unit)
    return player:isa("Commander") and ( unit:isa("Player") or (HasMixin(unit, "Selectable") and unit:GetIsSelected(player:GetTeamNumber())) )
end

local kUnitStatusDisplayRange = 13
local kUnitStatusCommanderDisplayRange = 50
local kDefaultHealthOffset = 1.2

function PlayerUI_GetUnitStatusInfo()

    local unitStates = { }
    
    local player = Client.GetLocalPlayer()
    
    if player and not player:GetBuyMenuIsDisplaying() and (not player.GetDisplayUnitStates or player:GetDisplayUnitStates()) then
    
        local eyePos = player:GetEyePos()
        local crossHairTarget = player:GetCrossHairTarget()
        
        local range = kUnitStatusDisplayRange
         
        if player:isa("Commander") then
            range = kUnitStatusCommanderDisplayRange
        end
        
        local healthOffsetDirection = player:isa("Commander") and Vector.xAxis or Vector.yAxis
		healthOffsetDirection = Vector(healthOffsetDirection.x, healthOffsetDirection.y, healthOffsetDirection.z)
        for index, unit in ipairs(GetEntitiesWithMixinWithinRange("UnitStatus", eyePos, range)) do
        
            // checks here if the model was rendered previous frame as well
            local status = unit:GetUnitStatus(player)
            if unit:GetShowUnitStatusFor(player) then       

                // Get direction to blip. If off-screen, don't render. Bad values are generated if 
                // Client.WorldToScreen is called on a point behind the camera.
                local origin = nil
                local getEngagementPoint = unit.GetEngagementPoint
                if getEngagementPoint then
                    origin = getEngagementPoint(unit)
                else
                    origin = unit:GetOrigin()
                end
				origin = Vector(origin.x, origin.y, origin.z)
                
                local normToEntityVec = GetNormalizedVector(origin - eyePos)
                local normViewVec = player:GetViewAngles():GetCoords().zAxis
               
                local dotProduct = normToEntityVec:DotProduct(normViewVec)
                
                if dotProduct > 0 then

                    local statusFraction = unit:GetUnitStatusFraction(player)
                    local description = unit:GetUnitName(player)
                    local action = unit:GetActionName(player)
                    local hint = unit:GetUnitHint(player)
                    local distance = (origin - eyePos):GetLength()
                    
                    local healthBarOffset = kDefaultHealthOffset
                    
                    local getHealthbarOffset = unit.GetHealthbarOffset
					// Fix for NpcManagerTunnel
					if unit:isa("NpcManagerTunnel") then
						healthBarOffset = 1
                    elseif getHealthbarOffset then
                        healthBarOffset = getHealthbarOffset(unit)
					end
                    
                    local healthBarOrigin = origin + healthOffsetDirection * healthBarOffset
                    
                    local worldOrigin = Vector(origin.x, origin.y, origin.z)
                    origin = Client.WorldToScreen(origin)
                    healthBarOrigin = Client.WorldToScreen(healthBarOrigin)
                    
                    if unit == crossHairTarget then
                    
                        healthBarOrigin.y = math.max(GUIScale(180), healthBarOrigin.y)
                        healthBarOrigin.x = Clamp(healthBarOrigin.x, GUIScale(320), Client.GetScreenWidth() - GUIScale(320))
                        
                    end

                    local health = 0
                    local armor = 0

                    local visibleToPlayer = true                        
                    if HasMixin(unit, "Cloakable") and GetAreEnemies(player, unit) then
                    
                        if unit:GetIsCloaked() or (unit:isa("Player") and unit:GetCloakFraction() > 0.2) then                    
                            visibleToPlayer = false
                        end
                        
                    end
                    
                    // Don't show tech points or nozzles if they are attached
                    if (unit:GetMapName() == TechPoint.kMapName or unit:GetMapName() == ResourcePoint.kPointMapName) and unit.GetAttached and (unit:GetAttached() ~= nil) then
                        visibleToPlayer = false
                    end
                    
                    if HasMixin(unit, "Live") and (not unit.GetShowHealthFor or unit:GetShowHealthFor(player)) then
                    
                        health = unit:GetHealthFraction()                
                        if unit:GetArmor() == 0 then
                            armor = 0
                        else 
                            armor = unit:GetArmorScalar()
                        end

                    end
                    
                    local badge = ""
                    
                    if HasMixin(unit, "Badge") then
                        badge = unit:GetBadgeIcon() or ""
                    end
                    
                    local hasWelder = false 
                    if distance < 10 then    
                        hasWelder = unit:GetHasWelder(player)
                    end
                    
                    local unitState = {
                        
                        Position = origin,
                        WorldOrigin = worldOrigin,
                        HealthBarPosition = healthBarOrigin,
                        Status = status,
                        Name = description,
                        Action = action,
                        Hint = hint,
                        StatusFraction = statusFraction,
                        HealthFraction = health,
                        ArmorFraction = armor,
                        IsCrossHairTarget = (unit == crossHairTarget and visibleToPlayer) or LocalIsFriendlyCommander(player, unit),
                        TeamType = kNeutralTeamType,
                        ForceName = unit:isa("Player") and not GetAreEnemies(player, unit),
                        BadgeTexture = badge,
                        HasWelder = hasWelder
                    
                    }
                    
                    if unit.GetTeamNumber then
                        unitState.IsFriend = (unit:GetTeamNumber() == player:GetTeamNumber())
                    end
                    
                    if unit.GetTeamType then
                        unitState.TeamType = unit:GetTeamType()
                    end
                    
                    table.insert(unitStates, unitState)
                
                end
                
            end
         
         end
        
    end
    
    return unitStates

end