//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GenericGamerules.lua

class 'GenericGamerules' (NS2Gamerules)

GenericGamerules.kMapName = "factions_generic_gamerules"

local networkVars =
{
}

if Server then

	function GenericGamerules:OnCreate()
	
        // Calls SetGamerules()
        Gamerules.OnCreate(self)

        self.sponitor = ServerSponitor()
        self.sponitor:Initialize(self)
        
        self.techPointRandomizer = Randomizer()
        self.techPointRandomizer:randomseed(Shared.GetSystemTime())
        
        // Create team objects
        self.team1 = self:BuildTeam(kTeam1Type)
        self.team1:Initialize(kTeam1Name, kTeam1Index)
        self.sponitor:ListenToTeam(self.team1)
        
        self.team2 = self:BuildTeam(kTeam2Type)
        self.team2:Initialize(kTeam2Name, kTeam2Index)
        self.sponitor:ListenToTeam(self.team2)
        
        self.worldTeam = ReadyRoomTeam()
        self.worldTeam:Initialize("World", kTeamReadyRoom)
        
        self.spectatorTeam = SpectatingTeam()
        self.spectatorTeam:Initialize("Spectator", kSpectatorIndex)
        
        self.gameInfo = Server.CreateEntity(GameInfo.kMapName)
        
        self:SetGameState(kGameState.NotStarted)
        
        self.allTech = false
        self.orderSelf = false
        self.autobuild = false
        
        self:SetIsVisible(false)
        self:SetPropagate(Entity.Propagate_Never)
        
        // Used to keep track of the amount of resources a player has when they
        // reconnect so we can award them the res back if they reconnect soon.
        self.disconnectedPlayerResources = { }
        
        self.justCreated = true
		
		assert(GetGamerules() == self)
        
    end
	
	// Make sure to override these in your child class
	function GenericGamerules:GetGameModeName()
		return "No mode name"
	end
	
	function GenericGamerules:GetGameModeText()
		return "No mode description"
	end
	
	local overrideOnClientConnect = NS2Gamerules.OnClientConnect
	// Send a message to players when they connect.
	function GenericGamerules:OnClientConnect(client)

		overrideOnClientConnect(self, client)
		local player = client:GetControllingPlayer()
		
		player:BuildAndSendDirectMessage("Welcome to Factions v" .. kFactionsVersion .. "!")
		player:BuildAndSendDirectMessage("Current Game Mode: " .. self:GetGameModeName())
		player:BuildAndSendDirectMessage(self:GetGameModeText())
		
	end

end

Shared.LinkClassToMap("GenericGamerules", GenericGamerules.kMapName, networkVars)