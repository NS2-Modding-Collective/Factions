//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Sentry.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Sentry
local overrideOnCreate = Sentry.OnCreate
function Sentry:OnCreate()

	overrideOnCreate(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
	self.isGhostStructure = false
	
end

local overrideOnInitialized = Sentry.OnInitialized
function Sentry:OnInitialized()

	overrideOnInitialized(self)

	if not HasMixin(self, "MapBlip") then
        InitMixin(self, MapBlipMixin)
    end
end

if Server then
	// check for spores in our way every 0.3 seconds
    local function UpdateConfusedState(self, target)

        if not self.confused and target then
            
            if not self.timeCheckedForSpores then
                self.timeCheckedForSpores = Shared.GetTime() - 0.3
            end
            
            if self.timeCheckedForSpores + 0.3 < Shared.GetTime() then
            
                self.timeCheckedForSpores = Shared.GetTime()
            
                local eyePos = self:GetEyePos()
                local toTarget = target:GetOrigin() - eyePos
                local distanceToTarget = toTarget:GetLength()
                toTarget:Normalize()
                
                local stepLength = 3
                local numChecks = math.ceil(Sentry.kRange/stepLength)
                
                // check every few meters for a spore in the way, min distance 3 meters, max 12 meters (but also check sentry eyepos)
                for i = 0, numChecks do
                
                    // stop when target has reached, any spores would be behind
                    if distanceToTarget < (i * stepLength) then
                        break
                    end
                
                    local checkAtPoint = eyePos + toTarget * i * stepLength
                    if self:GetFindsSporesAt(checkAtPoint) then
                        self:Confuse(Sentry.kConfuseDuration)
                        break
                    end
                
                end
            
            end
            
        elseif self.confused then
        
            if self.timeConfused < Shared.GetTime() then
                self.confused = false
            end
        
        end

    end

	function Sentry:OnUpdate(deltaTime)
    
        PROFILE("Sentry:OnUpdate")
        
        ScriptActor.OnUpdate(self, deltaTime)  
        
        self.attachedToBattery = true
        
        if self.timeNextAttack == nil or (Shared.GetTime() > self.timeNextAttack) then
        
            local initialAttack = self.target == nil
            
            local prevTarget = nil
            if self.target then
                prevTarget = self.target
            end
            
            self.target = nil
            
            if GetIsUnitActive(self) and self.attachedToBattery and self.deployed then
                self.target = self.targetSelector:AcquireTarget()
            end
            
            if self.target then
            
                local previousTargetDirection = self.targetDirection
                self.targetDirection = GetNormalizedVector(self.target:GetEngagementPoint() - self:GetAttachPointOrigin(Sentry.kMuzzleNode))
                
                // Reset damage ramp up if we moved barrel at all                
                if previousTargetDirection then
                    local dotProduct = previousTargetDirection:DotProduct(self.targetDirection)
                    if dotProduct < .99 then
                    
                        self.timeLastTargetChange = Shared.GetTime()
                        
                    end    
                end

                // Or if target changed, reset it even if we're still firing in the exact same direction
                if self.target ~= prevTarget then
                    self.timeLastTargetChange = Shared.GetTime()
                end            
                
                // don't shoot immediately
                if not initialAttack then
                
                    self.attacking = true
                    self:FireBullets()
                    
                end    
                
            else
            
                self.attacking = false
                self.timeLastTargetChange = Shared.GetTime()

            end
            
            UpdateConfusedState(self, self.target)
            // slower fire rate when confused
            local confusedTime = ConditionalValue(self.confused, kConfusedSentryBaseROF, 0)
            
            // Random rate of fire so it can't be gamed

            if initialAttack and self.target then
                self.timeNextAttack = Shared.GetTime() + Sentry.kTargetAcquireTime
            else
                self.timeNextAttack = confusedTime + Shared.GetTime() + Sentry.kBaseROF + math.random() * Sentry.kRandROF
            end    
            
            if not GetIsUnitActive() or self.confused or not self.attacking or not self.attachedToBattery then
            
                if self.attackSound:GetIsPlaying() then
                    self.attackSound:Stop()
                end
                
            elseif self.attacking then
            
                if not self.attackSound:GetIsPlaying() then
                    self.attackSound:Start()
                end

            end 
        
        end
    
    end
end

Class_Reload("Sentry", networkVars)