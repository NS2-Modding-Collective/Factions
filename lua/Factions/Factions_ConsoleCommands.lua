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
	
	local function FindPlayerByName(playerName)
	
		local found = nil
		for list, victim in ientitylist(Shared.GetEntitiesWithClassname("Player")) do

			if victim:GetName():upper() == playerName:upper() then
			
				found = victim
				break
				
			end
			
		end
		
		return found
	
	end
	
	function OnCommandForceClass(client, playerName, newClass)
	
		if Shared.GetCheatsEnabled() then
		
			local found = FindPlayerByName(playerName)
			
			if found ~= nil then
			
				if HasMixin(found, "FactionsClass") then
		
					// If a class is specified then change the class.
					local player = client:GetControllingPlayer()
					if newClass then
						local success = found:ChangeFactionsClassFromString(newClass)
						if player then
							if success then 
								player:SendDirectMessage("Changed " .. found:GetName() .. "'s class to " .. found:GetFactionsClassString())
							else
								player:SendDirectMessage("Invalid class name: " .. newClass)
							end
						end
					else
						if player then
							player:SendDirectMessage(found:GetName() .. "'s class is a: " .. found:GetFactionsClassString())
						end
					end
					
				end
				
			else
				Shared.Message("Failed to find player matching name")
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
    Event.Hook("Console_giveupgrade", OnCommandGiveUpgrade) 
	
	Event.Hook("Console_forceclass", OnCommandForceClass) 
	Event.Hook("Console_forcegivexp", OnCommandGiveXp) 
	Event.Hook("Console_forcegiveupgrade", OnCommandGiveUpgrade) 
end