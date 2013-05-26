//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ConsoleCommandsClient.lua

if Client then

    function OnCommandClass(client, className)
        if not className then
            local player = Client.GetLocalPlayer()
            if player then
		        player:OpenClassSelectMenu()
            end
        end
	end

    Event.Hook("Console_class", OnCommandClass) 
end