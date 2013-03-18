//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

// base class for spawning npcs
Script.Load("lua/sp/npcs/NpcSpawner.lua")

class 'NpcSpawnerSkulk' (NpcSpawner)

NpcSpawnerSkulk.kMapName = "npc_spawner_skulk"
  
local networkVars =
{
}

if Server then

    function NpcSpawnerSkulk:OnCreate()
        NpcSpawner.OnCreate(self)
    end

    function NpcSpawnerSkulk:OnInitialized()
        NpcSpawner.OnInitialized(self)
    end
    
    function NpcSpawnerSkulk:GetTechId()
        return kTechId.Marine
    end    

    function NpcSpawnerSkulk:Spawn()
        local values = self:GetValues() 
        local entity = Server.CreateEntity(NpcSkulk.kMapName, values)
    end
    
end

Shared.LinkClassToMap("NpcSpawnerSkulk", NpcSpawnerSkulk.kMapName, networkVars)

