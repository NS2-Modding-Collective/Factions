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

LaserSightMixin.kWorldMaxRange = 100
LaserSightMixin.kViewMaxRange = 10

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
	kLaserSightViewModelAttachPoint = "The name of the node to attach the laser to on the view model",
	kLaserSightWorldModelAttachPoint = "The name of the node to attach the laser to on the world model",
}

LaserSightMixin.networkVars =
{
	laserSightAccuracyScalar = "float",
	laserSightActive = "boolean",
}

function LaserSightMixin:__initmixin()

	self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy
	self.laserSightLevel = 0
	self.laserSightActive = true
	
	self:InitializeLaser()
	self.laserActive = true
	
end

function LaserSightMixin:GetLaserSightActive()

	return self.laserActive
	
end

function LaserSightMixin:GetLaserMaxLength()
	local player = self:GetOwner()
	if player and player:GetIsLocalPlayer() and not player:GetIsThirdPerson() then
		return LaserSightMixin.kViewMaxRange
	else
		return LaserSightMixin.kWorldMaxRange
	end
end

function LaserSightMixin:GetLaserWidth()
    return 0.05
end

// Switch on the laser
function LaserSightMixin:OnUpdateRender() 

	if self:GetLaserSightActive() 
		self:InitialiseLaser()
	
		if not self.laserActive then
			self.laserActive = true
		end
	else
		if laserActive then
			self:UninitializeLaser()
			self.laserActive = false
		end
	end
	
end

function LaserSightMixin:UpdateLaserSightLevel()

	if Server then
		local player = self:GetParent()
		if player and HasMixin(player, "WeaponUpgrade") and self.laserSightLevel ~= player:GetLaserSightLevel() then
		
			self:SetLaserSightLevel(player:GetLaserSightLevel())
			
		end
	end

end

function LaserSightMixin:SetLaserSightLevel(newLevel)

	if Server then
		self.laserSightLevel = newLevel
		self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy * (self.laserSightLevel * LaserSightMixin.accuracyBoostPerLevel)
		if self.laserSightLevel > 0 then
			self.laserSightActive = true
		else
			self.laserSightActive = false
		end
	end

end

function LaserSightMixin:GetLaserAttachCoords()

	local mixinConstants = self:GetMixinConstants()    
	local player = self:GetOwner()
	assert(player)
	
	local laserSightAttachPoint = nil
	if player:GetIsLocalPlayer() and not player:GetIsThirdPerson() then
		laserSightAttachPoint = mixinConstants.kLaserSightViewModelAttachPoint
	else
		laserSightAttachPoint = mixinConstants.kLaserSightWorldModelAttachPoint
	end
	
	return self:GetAttachPointCoords(laserSightAttachPoint)
		
end

function LaserSightMixin:SetEndPoint()

	local player = self:GetOwner()
	assert(player)
	
	local attachCoords = self:GetLaserAttachCoords()
	local startPoint = self:GetLaserAttachCoords().origin
	
	// Maybe adjust this so that the laser points at the target?
	/*local viewAngles = player:GetViewAngles()
	local shootCoords = viewAngles:GetCoords()*/
	
	local shootCoords = self:GetLaserAttachCoords()
    
	local range = self:GetLaserMaxLength()
	
    // Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
	local endPoint = startPoint + shootCoords * range
	
	local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.LOS, PhysicsMask.All, filter)
    local length = math.abs( (trace.endPoint - weaponCoords.origin):GetLength() )
    
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