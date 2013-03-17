//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

// base class for spawning npcs
Script.Load("lua/sp/npcs/NpcSpawner.lua")

class 'NpcSpawnerMarine' (NpcSpawner)

NpcSpawnerMarine.kMapName = "npc_spawner_marine"
  
local networkVars =
{
}

if Server then

    function NpcSpawnerMarine:OnCreate()
        NpcSpawner.OnCreate(self)
    end

    function NpcSpawnerMarine:OnInitialized()
        NpcSpawner.OnInitialized(self)
    end
    
    function NpcSpawnerMarine:GetTechId()
        return kTechId.Marine
    end    

    function NpcSpawnerMarine:Spawn()
        local values = self:GetValues()                    
        values.weapons = self.weapons
        
        local entity = Server.CreateEntity(NpcMarine.kMapName, values)
    end
    
end

Shared.LinkClassToMap("NpcSpawnerMarine", NpcSpawnerMarine.kMapName, networkVars)

