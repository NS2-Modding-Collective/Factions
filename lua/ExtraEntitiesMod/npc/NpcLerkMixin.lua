//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

NpcLerkMixin = CreateMixin( NpcLerkMixin )
NpcLerkMixin.type = "NpcLerk"

NpcLerkMixin.expectedMixins =
{
    Npc = "Required to work"
}

NpcLerkMixin.expectedCallbacks =
{
}


NpcLerkMixin.networkVars =  
{
}


function NpcLerkMixin:__initmixin()   
end

// let lerk hover over the ground
function NpcLerkMixin:AiSpecialLogic()
    assert(self.move ~= nil)
    if not self.fly and not self.inTargetRange then
        self.move.commands = bit.bor(self.move.commands, Move.Jump)   
        self.fly = true
    else
        self.fly = false
    end  

end

function NpcLerkMixin:GetAttackDistanceOverride()
    return 1.2
end

function NpcLerkMixin:GetIsFlying()
    return true
end

function NpcLerkMixin:GetHoverHeight()    
    return MAC.kHoverHeight
end

function NpcLerkMixin:CheckImportantEvents()
end





