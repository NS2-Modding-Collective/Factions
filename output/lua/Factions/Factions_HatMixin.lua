//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_HatMixin.lua

HatMixin = CreateMixin( HatMixin )
HatMixin.type = "Hat"

kHatType = enum({ 'None', 'Clog'})

HatMixin.stepDistance = kFadeShadowStepDistance

HatMixin.expectedMixins =
{
}

HatMixin.expectedCallbacks =
{
}

HatMixin.expectedConstants =
{
}

HatMixin.networkVars =
{
	shadowStepLevel = "integer (0 to " .. #ShadowStepUpgrade.cost .. ")",
}

function ShadowStepMixin:__initmixin()

	if Server then
		self.shadowStepLevel = 0
	end

end

function ShadowStepMixin:CopyPlayerDataFrom(player)

	if Server then
		self.shadowStepLevel = player.shadowStepLevel
	end

end

function ShadowStepMixin:OnSprint()
	// Copy Shadow Step code here
	
end