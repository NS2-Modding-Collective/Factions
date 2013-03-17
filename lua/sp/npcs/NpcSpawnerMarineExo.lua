//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

// base class for spawning npcs
Script.Load("lua/sp/npcs/NpcSpawner.lua")

class 'NpcSpawnerMarineExo' (NpcSpawner)

NpcSpawnerMarineExo.kMapName = "npc_spawner_marine_exo"
  
local networkVars =
{
}

if Server then

    function NpcSpawnerMarineExo:OnCreate()
        NpcSpawner.OnCreate(self)
    end

    function NpcSpawnerMarineExo:OnInitialized()
        NpcSpawner.OnInitialized(self)
    end
    
    function NpcSpawnerMarineExo:GetTechId()
        return kTechId.Marine
    end    

    function NpcSpawnerMarineExo:Spawn()
        local values = self:GetValues()                    
        values.weapons = self.weapons
        
        local entity = Server.CreateEntity(NpcMarineExo.kMapName, values)
    end
    
end

Shared.LinkClassToMap("NpcSpawnerMarineExo", NpcSpawnerMarineExo.kMapName, networkVars)

