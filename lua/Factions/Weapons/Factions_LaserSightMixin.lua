//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LaserSightMixin.lua

Script.Load("lua/FunctionContracts.lua")

Script.Load("lua/LaserMixin.lua")

LaserSightMixin = CreateMixin( LaserSightMixin )
LaserSightMixin.type = "LaserSight"

LaserSightMixin.baseAccuracy = 1
LaserSightMixin.accuracyBoostPerLevel = -0.1

LaserSightMixin.expectedMixins =
{
}

LaserSightMixin.expectedCallbacks =
{
}

LaserSightMixin.overrideFunctions =
{
}

LaserSightMixin.expectedConstants =
{
	kLaserSightAttachPoint = "The name of the node to attach the laser to",
}

LaserSightMixin.networkVars =
{
	laserSightAccuracyScalar = "float",
	laserSightLevel = "integer (0 to " .. #LaserSightUpgrade.cost .. ")",
}

function LaserSightMixin:__initmixin()

	self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy
	self.laserSightLevel = 0
	
end

if Client then
    
    function LaserSightMixin:CheckLaser()
        local startPoint = self:GetOrigin()          
        local endPoint = self:GetCoords().yAxis * self:OverrideLaserLength()
        local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOne(self))
        //DebugLine(startPoint, endPoint, 3, 1,1,1,1)
        if trace.entity then        
            self:OnTriggerEntered(trace.entity)
        end
    end
end

function LaserSightMixin:GetLaserSightActive()

	local player = self:GetParent()
	if player and HasMixin(player, "WeaponUpgrade") and player:GetLaserSightLevel() > 0 then
		return true
	end
	
	return false
	
end

// Switch on the laser
function LaserSightMixin:OnUpdateRender() 

	if self:GetLaserSightActive() and not self.laserActive then
		self:InitializeLaser()
		self.laserActive = true
	end
	
end

function LaserSightMixin:UpdateLaserSightLevel()

	local player = self:GetParent()
    if player and HasMixin(player, "WeaponUpgrade") and self.laserSightLevel ~= player:GetLaserSightLevel() then
	
		Shared.Message("NEW LASER SIGHT LEVEL" .. player:GetLaserSightLevel())
		self:SetLaserSightLevel(player:GetLaserSightLevel())
		
    end

end

function LaserSightMixin:SetLaserSightLevel(newLevel)

	self.laserSightLevel = newLevel
	self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy * (self.laserSightLevel * LaserSightMixin.accuracyBoostPerLevel)

end

function LaserSightMixin:GetLaserAttachCoords()

	local mixinConstants = self:GetMixinConstants()    
	local laserSightAttachPoint = mixinConstants.kLaserSightAttachPoint
	local coords = self:GetAttachPointOrigin(laserSightAttachPoint)
    local tempCoords = coords
    coords.xAxis = tempCoords.yAxis
    coords.yAxis = tempCoords.zAxis
    coords.zAxis = tempCoords.xAxis
	
	return coords
		
end

function LaserSightMixin:GetIsLaserActive()
    return self:GetLaserSightActive()
end

function LaserSightMixin:OverrideLaserLength()
	return 10
end

function LaserSightMixin:GetLaserMaxLength()
    return 100
end

function LaserSightMixin:GetLaserWidth()
    return 0.1
end

function LaserSightMixin:SetEndPoint()

    local coords = self:GetLaserAttachCoords()    
    local maxLength = self:GetLaserMaxLength()
    
    local trace = Shared.TraceRay(coords.origin, coords.origin + coords.zAxis * maxLength, CollisionRep.Default, PhysicsMask.Bullets, EntityFilterAll())
    local length = math.abs( (trace.endPoint - coords.origin):GetLength() )

    if length < 1 then
        // start a bit away from the mine
        local newStart = coords.origin
        newStart.z = newStart.z + 0.3
        
        trace = Shared.TraceRay(newStart, coords.origin + coords.zAxis * maxLength, CollisionRep.Default, PhysicsMask.Bullets, EntityFilterAll())
        length = math.abs( (trace.endPoint - coords.origin):GetLength() )
    end
    
    self.endPoint = trace.endPoint
    self.length = length 
	
end

// Laser things (laser mixin hasnt worked like it should)
function LaserSightMixin:InitializeLaser()

    self:SetEndPoint()
    
    if not self.dynamicMesh1 then
        self.dynamicMesh1 = DynamicMesh_Create()
        self.dynamicMesh1:SetMaterial(LaserMixin.kLaserMaterial)
    end
    
    if not self.dynamicMesh2 then
        self.dynamicMesh2 = DynamicMesh_Create()
        self.dynamicMesh2:SetMaterial(LaserMixin.kLaserMaterial)
    end

    local coords = self:GetLaserAttachCoords()    
    local width = self:GetLaserWidth()
    
    local coordsLeft = Coords.GetIdentity()
    coordsLeft.origin = coords.origin
    coordsLeft.zAxis = coords.zAxis
    coordsLeft.yAxis = coords.xAxis
    coordsLeft.xAxis = -coords.yAxis

    local coordsRight = Coords.GetIdentity()
    coordsRight.origin = coords.origin
    coordsRight.zAxis = coords.zAxis
    coordsRight.yAxis = -coords.xAxis
    coordsRight.xAxis = coords.yAxis

    local startColor = Color(1, 0, 0, 0.7)
    local endColor = Color(1, 0, 0, 0.07)

    DynamicMesh_SetLine(self.dynamicMesh1, coordsLeft, width, self.length, startColor, endColor)
    DynamicMesh_SetLine(self.dynamicMesh2, coordsRight, width, self.length, startColor, endColor)
    
end

function LaserSightMixin:UninitializeLaser()

    if self.dynamicMesh1 then
        DynamicMesh_Destroy(self.dynamicMesh1)
    end    
    
    if self.dynamicMesh2 then
        DynamicMesh_Destroy(self.dynamicMesh2)
    end
    
    if self.laserLight then        
        Client.DestroyRenderLight(self.laserLight)            
    end
    
end