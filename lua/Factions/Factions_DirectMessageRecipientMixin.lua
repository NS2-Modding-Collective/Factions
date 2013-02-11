//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_DirectMessageRecipientMixin.lua

Script.Load("lua/FunctionContracts.lua")

DirectMessageRecipientMixin = CreateMixin( DirectMessageRecipientMixin )
DirectMessageRecipientMixin.type = "DirectMessageRecipient"

DirectMessageRecipientMixin.expectedMixins =
{
}

DirectMessageRecipientMixin.expectedCallbacks =
{
}

DirectMessageRecipientMixin.expectedConstants =
{
}

DirectMessageRecipientMixin.networkVars =
{
}

DirectMessageRecipientMixin.kFadeTime = 8
DirectMessageRecipientMixin.kNumVisible = 9

function DirectMessageRecipientMixin:__initmixin()

	// Initialise direct message queue
	if (self.directMessageQueue == nil) then
		self.directMessageQueue = {}
		self.timeOfLastDirectMessage = 0
		self.directMessagesActive = 0
	end
	
end


function DirectMessageRecipientMixin:SendDirectMessage(message)

	// Queue messages that have been sent if there are too many...
	if (Shared.GetTime() - self.timeOfLastDirectMessage < DirectMessageRecipientMixin.kFadeTime and self.directMessagesActive + 1 > DirectMessageRecipientMixin.kNumVisible) then
		table.insert(self.directMessageQueue, message)
	else
		// Otherwise we're good to send the message normally.
		self:BuildAndSendDirectMessage(message)
	end
	
	// Update the last sent timer if this is the first message sent.
	if (self.directMessagesActive == 0) then
		self.timeOfLastDirectMessage = Shared.GetTime()
	end
	self.directMessagesActive = self.directMessagesActive + 1
	
end
	
function DirectMessageRecipientMixin:BuildAndSendDirectMessage(message)

	local playerName = "Factions: "
	local playerLocationId = -1
	local playerTeamNumber = kTeamReadyRoom
	local playerTeamType = kNeutralTeamType

	Server.SendNetworkMessage(self, "Chat", BuildChatMessage(true, playerName, playerLocationId, playerTeamNumber, playerTeamType, message), true)

end

function DirectMessageRecipientMixin:ProcessQueuedDirectMessages()

	// Handle queued direct messages.
	if self.directMessagesActive > 0 then
		if Shared.GetTime() - self.timeOfLastDirectMessage > DirectMessageRecipientMixin.kFadeTime then
		
			// After the fade time has passed, clear old messages from the queue.
			for msgIndex = 1, math.min(self.directMessagesActive, DirectMessageRecipientMixin.kNumVisible) do
				self.directMessagesActive = self.directMessagesActive - 1
			end
			
			// Send any waiting messages, up to DirectMessageRecipientMixin.kNumVisible.
			if (#self.directMessageQueue > 0) then
				for msgIndex = 1, math.min(#self.directMessageQueue, DirectMessageRecipientMixin.kNumVisible) do
					local message = table.remove(self.directMessageQueue, 1)
					self:BuildAndSendDirectMessage(message)
				end
				
				self.timeOfLastDirectMessage = Shared.GetTime()
			end
			
		end
	end

	return true

end