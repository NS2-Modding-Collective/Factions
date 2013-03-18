//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/sp/npcs/NpcMixin.lua")

class 'NpcMarine' (Marine)

NpcMarine.kMapName = "npc_marine"
  
local networkVars =
{
    name1 = "string(64)",   
}

AddMixinNetworkVars(NpcMixin, networkVars)

function NpcMarine:OnCreate()
    Marine.OnCreate(self)
end

function NpcMarine:OnInitialized()
    InitMixin(self, NpcMixin)
    Marine.OnInitialized(self)    
    
    if Server then

        local items = {}     
      
        if self.weapons == 0 then
            table.insert(items, Pistol.kMapName)
            table.insert(items, Axe.kMapName)  
            table.insert(items, Rifle.kMapName)     
        elseif self.weapons == 1 then
            table.insert(items, Axe.kMapName)  
            table.insert(items, Pistol.kMapName)                 
        elseif self.weapons == 2 then
            table.insert(items, Axe.kMapName)
        elseif self.weapons == 3 then
            table.insert(items, GrenadeLauncher.kMapName)
        elseif self.weapons == 4 then
            table.insert(items, Flamethrower.kMapName)
        end        
        
        for i, item in ipairs(items) do
            self:GiveItem(item)
        end

    end
    
end

Shared.LinkClassToMap("NpcMarine", NpcMarine.kMapName, networkVars)