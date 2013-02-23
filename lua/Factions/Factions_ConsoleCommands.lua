//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ConsoleCommands.lua

if Server then

    function OnCommandGiveMagnoBoots(client)

        local player = client:GetControllingPlayer()
        if (HasMixin(player, "MagnoBootsWearer")) then
            player:GiveMagnoBoots()
        end

    end


    function OnCommandGiveXp(client, amount)

        local player = client:GetControllingPlayer()
        if player and  Shared.GetCheatsEnabled() then
            if not amount then
                amount = 10
            end	        
            player:AddScore(amount)
        end

    end

    function OnCommandGiveUpgrade(client, upgradeName)

        local player = client:GetControllingPlayer()
        if player and Shared.GetCheatsEnabled() and upgradeName then
            if HasMixin(player, "Upgrade") then
                local upgrade = player:GetUpgradeByName(upgradeName)
                // cause it's cheats 1 you just get the upgrade without paying
                player:BuyUpgrade(upgrade, true)
            end
        end
        
    end
	
	function OnCommandClass(client, newClass)
		
		local player = client:GetControllingPlayer()
		if player and HasMixin(player, "FactionsClass") then
		
			// If a class is specified then change the class.
			if newClass then
				local success = player:ChangeFactionsClassFromString(newClass)
				if success then 
					player:SendDirectMessage("Changed your class to " .. player:GetFactionsClassString())
				else
					player:SendDirectMessage("Invalid class name: " .. newClass)
				end
			else
				player:SendDirectMessage("Your class is a: " .. player:GetFactionsClassString())
			end
			
		end
		
	end

    Event.Hook("Console_magnoboots", OnCommandGiveMagnoBoots) 
    Event.Hook("Console_givexp", OnCommandGiveXp) 
	Event.Hook("Console_class", OnCommandClass) 
    Event.Hook("Console_factions_give", OnCommandGiveUpgrade) 
end