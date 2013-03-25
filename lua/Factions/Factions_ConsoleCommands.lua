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

	function OnCommandBadass(client)
		local player = client:GetControllingPlayer()
        if player and Shared.GetCheatsEnabled() then
        	// Toggle random colours
            if HasMixin(player, "TeamColours") then
                player.randomColour = not player.randomColour
                player:SendDirectMessage("You are badass!")
            end
        end
	end

	function OnCommandSetColour(client, red, green, blue)
		local player = client:GetControllingPlayer()
		if player and Shared.GetCheatsEnabled() then
			local intRed = tonumber(red)
			local intGreen = tonumber(green)
			local intBlue = tonumber(blue)
			if intRed and intGreen and intBlue then
				if HasMixin(player, "TeamColours") then
					   player.armorColour = Vector(intRed, intGreen, intBlue)
				end			
			else
				player:SendDirectMessage("Usage: setcolour <red> <green> <blue>")
				player:SendDirectMessage("Where red, green and blue are numbers between 0 and 255")
			end
    	end
	end

	function OnCommandDebugUpgrades(client)
		for list, victim in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
			Shared.Message("Player: " .. victim:GetName())
			if HasMixin(victim, "Upgrade") then
				for index, upgrade in victim:GetAllUpgrades() do
					if upgrade:GetCurrentLevel() > 0 then
						Shared.Message("Upgrade: " .. upgrade:GetClassName() .. " Level: " .. upgrade:GetCurrentLevel())
					end
				end
			end
		end
	end

    function OnCommandGiveXp(client, amount)

        local player = client:GetControllingPlayer()
        if player and  Shared.GetCheatsEnabled() then
            if not amount then
                amount = 10
            end	        
            player:AddResources(amount)
        end

    end

    function OnCommandGiveUpgrade(client, upgradeName)

        local player = client:GetControllingPlayer()
        if player and Shared.GetCheatsEnabled() and upgradeName then
            if HasMixin(player, "Upgrade") then
                local upgrade = player:GetUpgradeByName(upgradeName)
                // cause it's cheats 1 you just get the upgrade without paying
                player:BuyUpgrade(upgrade:GetId(), true)
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
	
	function OnCommandForceGiveUpgrade(client, playerName, newUpgrade)
	
		if Shared.GetCheatsEnabled() then
		
			local found = FindPlayerByName(playerName)
			if found ~= nil then
			
				if HasMixin(found, "Upgrade") then
				
					// If a class is specified then change the class.
					if newUpgrade then
				        if found and Shared.GetCheatsEnabled() and newUpgrade then
							if HasMixin(found, "Upgrade") then
								local upgrade = found:GetUpgradeByName(newUpgrade)
								// cause it's cheats 1 you just get the upgrade without paying
								found:BuyUpgrade(upgrade:GetId(), true)
								SendGlobalChatMessage(found:GetName() .. " has been given a " .. upgrade:GetUpgradeTitle() .. " upgrade.")
							end
						end
					end
					
				end
				
			else
				SendGlobalChatMessage("Failed to find player matching name")
			end
		end
			
	end
	
	function OnCommandForceClass(client, playerName, newUpgrade)
	
		if Shared.GetCheatsEnabled() then
		
			local found = FindPlayerByName(playerName)
			if found ~= nil then
			
				if HasMixin(found, "FactionsClass") then
				
					// If a class is specified then change the class.
					if newClass then
						local success = found:ChangeFactionsClassFromString(newClass)
						if success then 
							SendGlobalChatMessage("Changed " .. found:GetName() .. "'s class to " .. found:GetFactionsClassString())
						else
							SendGlobalChatMessage("Invalid class name: " .. newClass)
						end
					else
						SendGlobalChatMessage(found:GetName() .. "'s class is a: " .. found:GetFactionsClassString())
					end
					
				end
				
			else
				SendGlobalChatMessage("Failed to find player matching name")
			end
		end
			
	end
	
	local function SwitchClass(client, newClass)
		
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
	
	function OnCommandAssault(client)
		SwitchClass(client, "Assault")
	end
	
	function OnCommandScout(client)
		SwitchClass(client, "Scout")
	end
	
	function OnCommandSupport(client)
		SwitchClass(client, "Support")
	end
	
	Event.Hook("Console_badass", OnCommandBadass)
	Event.Hook("Console_setcolour", OnCommandSetColour)

    Event.Hook("Console_givexp", OnCommandGiveXp) 
	Event.Hook("Console_assault", OnCommandAssault) 
	Event.Hook("Console_scout", OnCommandScout) 
	Event.Hook("Console_support", OnCommandSupport) 
    Event.Hook("Console_giveupgrade", OnCommandGiveUpgrade) 
	
	Event.Hook("Console_debugupgrades", OnCommandDebugUpgrades)
	Event.Hook("Console_forceclass", OnCommandForceClass) 
	Event.Hook("Console_forcegivexp", OnCommandGiveXp) 
	Event.Hook("Console_forcegiveupgrade", OnCommandForceGiveUpgrade) 
end