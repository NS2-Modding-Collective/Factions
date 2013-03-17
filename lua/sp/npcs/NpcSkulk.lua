//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/sp/npcs/NpcMixin.lua")
Script.Load("lua/OrdersMixin.lua")


class 'NpcSkulk' (Skulk)

NpcSkulk.kMapName = "npc_skulk"
  
local networkVars =
{
    name1 = "string(64)",   
}

AddMixinNetworkVars(NpcMixin, networkVars)
AddMixinNetworkVars(OrdersMixin, networkVars)

function NpcSkulk:OnCreate()
    Skulk.OnCreate(self)
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
end

function NpcSkulk:OnInitialized()
    Skulk.OnInitialized(self)    
    InitMixin(self, NpcMixin)   
end

Shared.LinkClassToMap("NpcSkulk", NpcSkulk.kMapName, networkVars)