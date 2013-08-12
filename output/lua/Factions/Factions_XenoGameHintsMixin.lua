//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_XenoGameHintsMixin.lua

XenoGameHintsMixin = CreateMixin( XenoGameHintsMixin )
XenoGameHintsMixin.type = "XenoGameHints"

XenoGameHintsMixin.expectedMixins =
{
}

XenoGameHintsMixin.expectedCallbacks =
{
}

XenoGameHintsMixin.expectedConstants =
{
}

XenoGameHintsMixin.networkVars =
{
}

function XenoGameHintsMixin:__initmixin()

end

function XenoGameHintsMixin:CopyPlayerDataFrom(player)

	// If the player was dead and is now alive then display hints
	if Server then
		local gameRules = GetGamerules()
		if gameRules:isa("XenoswarmGamerules") and not player:GetIsAlive() then
			local isSupport = false
			if HasMixin(self, "FactionsClass") then
				if player:GetFactionsClassString() == "Support" then
					isSupport = true
				end
			end
			
			local hintText = gameRules:GetGameHintText()
			for index, text in ipairs(hintText) do
				self:SendDirectMessage(text)
			end
		end
	end

end