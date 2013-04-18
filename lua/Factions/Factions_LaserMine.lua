//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LaserMine.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

class 'LaserMine' (Mine)

LaserMine.kMapName = "laser_mine"

LaserMine.kModelName = PrecacheAsset("models/marine/mine/mine.model")

Script.Load("lua/LaserMixin.lua")

local networkVars =
{
    laserActive = "boolean",
}


local originalMineOnInitialized
function LaserMine:OnInitialized()
	
	Mine.OnInitialized(self)

	if Client then        
		self:InitializeLaser()
		self.laserActive = true  
	end

end

if Server then
	function LaserMine:OnUpdate(dt)
	
		// call the original update first
		Mine.OnUpdate(self, dt)
		
		// at Init no angles are set, so set this here
		if not self.laserTriggerSet then
			self:CreateLaserTrigger()   
		end
		
	end
    
    function LaserMine:CheckLaser()
        local startPoint = self:GetOrigin()          
        local endPoint = self:GetCoords().yAxis * self:OverrideLaserLength()
        local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOne(self))
        //DebugLine(startPoint, endPoint, 3, 1,1,1,1)
        if trace.entity then        
            self:OnTriggerEntered(trace.entity)
        end
    end
end

function LaserMine:OnDestroy()
    ScriptActor.OnDestroy(self)
    self:UninitializeLaser()
end

function LaserMine:GetLaserAttachCoords()

    local coords = self:GetCoords()
    local tempCoords = coords
    coords.xAxis = tempCoords.yAxis
    coords.yAxis = tempCoords.zAxis
    coords.zAxis = tempCoords.xAxis

    return coords   
end

function LaserMine:GetIsLaserActive()
    return true
end

function LaserMine:OverrideLaserLength()
	return 100
end

function LaserMine:GetLaserMaxLength()
    return 100
end

function LaserMine:GetLaserWidth()
    return 0.15
end

function LaserMine:SetEndPoint()

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

local function CreateTrigger(self, endPoint, coords, length)
    
    if self.triggerBody then
        Shared.DestroyCollisionObject(self.triggerBody)
        self.triggerBody = nil        
    end

    //local coords = Coords.GetTranslation((self:GetOrigin() - endPoint) * .5 + endPoint)
    local width = self:GetLaserWidth()
    local extents = Vector(width + 0.2, width + 0.2, width + 0.2)
    extents.y = length

    //DebugLine(coords.origin, self.endPoint, 20, 0,0,1,1)  

    self.triggerBody = Shared.CreatePhysicsBoxBody(false, extents, 0, coords)
    self.triggerBody:SetTriggerEnabled(true)
    self.triggerBody:SetCollisionEnabled(true)
    
    self.triggerBody:SetEntity(self)    
    
end

function LaserMine:CreateLaserTrigger()
    self:SetEndPoint()
    local coords = self:GetCoords()
    CreateTrigger(self, self.endPoint, coords, self.length)
    self.laserTriggerSet = true
end


// Laser things (laser mixin hasnt worked like it should)

function LaserMine:InitializeLaser()

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

function LaserMine:UninitializeLaser()

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

Shared.LinkClassToMap("LaserMine", LaserMine.kMapName, networkVars)