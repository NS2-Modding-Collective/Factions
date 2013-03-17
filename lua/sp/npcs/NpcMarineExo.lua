//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/sp/npcs/NpcMixin.lua")

class 'NpcMarineExo' (Exo)

NpcMarineExo.kMapName = "npc_marine_exo"
  
local networkVars =
{
    name1 = "string(64)",   
}

AddMixinNetworkVars(NpcMixin, networkVars)

function NpcMarineExo:OnCreate()
    Exo.OnCreate(self)
end

function NpcMarineExo:OnInitialized()

    // this need to be called before
    if Server then 
        local items = {}     
      
        if self.weapons == 0 then
            self.layout = "ClawMinigun"
        elseif self.weapons == 1 then
            self.layout = "MinigunMinigun"             
        elseif self.weapons == 2 then
            self.layout = "ClawRailgun"
        elseif self.weapons == 3 then
            self.layout = "RailgunRailgun"
        end
    end

    Exo.OnInitialized(self)    
    InitMixin(self, NpcMixin)
    
end

Shared.LinkClassToMap("NpcMarineExo", NpcMarineExo.kMapName, networkVars)