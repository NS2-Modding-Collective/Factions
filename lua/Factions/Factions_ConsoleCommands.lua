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
                player.factionsBadassColour = not player.factionsBadassColour
				local badassString = "You are badass!"
				if not player.factionsBadassColour then
					badassString = "You are not badass any more! Sorry!" 
				end
                player:SendDirectMessage(badassString)
            end
        end
	end

	// Set your player's colour based on an rgb value.
	// At some point we will put this into the class menu.
	// Only allowed in non-competitive games like Xenoswarm.
	function OnCommandSetColour(client, red, green, blue)
		local player = client:GetControllingPlayer()
		if player and not GetGamerulesInfo():GetIsCompetitive() then
			local dblRed = tonumber(red) / 255
			local dblGreen = tonumber(green) / 255
			local dblBlue = tonumber(blue) / 255
			if dblRed and dblGreen and dblBlue then
				if HasMixin(player, "TeamColours") then
					player.factionsArmorColour = Vector(dblRed, dblGreen, dblBlue)
				end			
			else
				player:SendDirectMessage("Usage: setcolour <red> <green> <blue>")
				player:SendDirectMessage("Where red, green and blue are numbers between 0 and 255")
			end
    	end
	end

	function OnCommandDebugUpgrades(client)
		for list, victim in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
			Shared.Message("Player: " .. victim:GetName() .. " Team: " .. victim:GetTeamNumber())
			if HasMixin(victim, "FactionsUpgrade") then
				for index, upgrade in ipairs(victim:GetActiveUpgrades()) do
					Shared.Message("Upgrade: " .. upgrade:GetClassName() .. " Level: " .. upgrade:GetCurrentLevel())
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

    function OnCommandBuy(client, upgradeName)

        local player = client:GetControllingPlayer()
        if player and upgradeName then
            if HasMixin(player, "FactionsUpgrade") then
				local cheats = Shared.GetCheatsEnabled()
                local upgrade = player:GetUpgradeByName(upgradeName)
				if upgrade then
					// if it's cheats 1 you just get the upgrade without paying
					player:BuyUpgrade(upgrade:GetId(), cheats)
					player:SendDirectMessage("You have bought a " .. upgrade:GetUpgradeTitle() .. " upgrade.")
				else
					player:SendDirectMessage("Cannot find upgrade " .. upgradeName .. ".")
				end
            end
        end
        
    end
	
	 function OnCommandRefundAllUpgrades(client)

        local player = client:GetControllingPlayer()
        if player and HasMixin(player, "FactionsUpgrade") then
            player:RefundAllUpgrades()
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
	
	function OnCommandForceBuy(client, playerName, upgradeName)
	
		if Shared.GetCheatsEnabled() then
		
			local found = FindPlayerByName(playerName)
			if found ~= nil then
			
				if HasMixin(found, "FactionsUpgrade") then
				
					// If a class is specified then change the class.
					if upgradeName then
				        if found and upgradeName then
							if HasMixin(found, "FactionsUpgrade") then
								local cheats = Shared.GetCheatsEnabled()
								local upgrade = found:GetUpgradeByName(upgradeName)
								if upgrade then
									// if it's cheats 1 you just get the upgrade without paying
									local upgradeMessage = found:GetCanBuyUpgradeMessage(upgrade:GetId(), true)
									if upgradeMessage == "" then
										found:BuyUpgrade(upgrade:GetId(), cheats)
										SendGlobalChatMessage(found:GetName() .. " has been given a " .. upgrade:GetUpgradeTitle() .. " upgrade.")
									else
										SendGlobalChatMessage(found:GetName() .. " could not be given a " .. upgrade:GetUpgradeTitle() .. " upgrade.")
										SendGlobalChatMessage("Reason: " .. upgradeMessage)
									end
								else
									SendGlobalChatMessage("Cannot find upgrade " .. upgradeName .. " to give to " .. found:GetName())
								end
							end
						end
					end
					
				end
				
			else
				SendGlobalChatMessage("Failed to find player matching name")
			end
		end
			
	end
	
	function OnCommandForceClass(client, playerName, newClass)
	
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
		
		if GetGamerulesInfo():GetIsClassBased() then
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
		else
			player:SendDirectMessage("You cannot change class in this gamemode!")
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
    Event.Hook("Console_buy", OnCommandBuy) 
	Event.Hook("Console_refundall", OnCommandRefundAllUpgrades) 
	
	Event.Hook("Console_debugupgrades", OnCommandDebugUpgrades)
	Event.Hook("Console_forceclass", OnCommandForceClass) 
	Event.Hook("Console_forcegivexp", OnCommandGiveXp) 
	Event.Hook("Console_forcebuy", OnCommandForceBuy) 
end