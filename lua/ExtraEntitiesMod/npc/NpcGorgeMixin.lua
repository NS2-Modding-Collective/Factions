//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

NpcGorgeMixin = CreateMixin( NpcGorgeMixin )
NpcGorgeMixin.type = "NpcGorge"

NpcGorgeMixin.expectedMixins =
{
    Npc = "Required to work"
}

NpcGorgeMixin.expectedCallbacks =
{
}


NpcGorgeMixin.networkVars =  
{
}


function NpcGorgeMixin:__initmixin()   
end

function NpcGorgeMixin:GetAttackDistanceOverride()
    return 40
end

function NpcGorgeMixin:CheckImportantEvents()
    assert(self.move ~= nil)
    if self:GetHealth() < self:GetMaxHealth() then
        // heal us
        local activeWeapon = self:GetActiveWeapon()
        if activeWeapon and activeWeapon:isa("SpitSpray") then
            self.move.commands = bit.bor(self.move.commands, Move.SecondaryAttack)
        end
    end
    
    if self.lastAttacker then
        // jump sometimes if getting attacked
        if Shared.GetRandomInt(0, 100) <= 10 then
            self.move.commands = bit.bor(self.move.commands, Move.Jump)
        end
        self.lastAttacker = nil
    end
end






