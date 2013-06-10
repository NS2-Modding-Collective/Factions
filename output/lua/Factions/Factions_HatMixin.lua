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

kHatType = enum({ 'None' })

local kHatModels = {}

// Used by mods and the below code to add new and exciting hats!
function HatMixin.AddHatModel(newHatType, params)
	kHatModels = AddToEnum(kHatModels, newHatType)
	local hatEnumType = kHatModels.newHatType
	kHatModels[hatEnumType] = params
end

HatMixin.AddHatModel("Cyst", { model = Cyst.kModelName,
							  animationGraph = Cyst.kAnimationGraph,
							  offset = Vector(0,0,0),
							  baseScale = Vector(1,1,1),
							  baseAangles = Vector(0,0,0), })

HatMixin.expectedMixins =
{
}

HatMixin.expectedCallbacks =
{
	GetHatAttachPoint = "Gets the attach point for hats",
	GetHatScale = "Gets the scale of the hat using Marine scale as a baseline",
	GetHatOffset = "Gets the offset of the hat using Marine scale as a baseline",
	GetHatAngles = "Gets the angle of the hat using Marine scale as a baseline",
}

HatMixin.expectedConstants =
{
}

HatMixin.networkVars =
{
	hatType = "enum kHatType",
}

function HatMixin:__initmixin()

	if Server then
		self.hatType = kHatType.None
	end

end

function HatMixin:CopyPlayerDataFrom(player)

	if Server then
		self.hatType = player.hatType
	end

end

function HatMixin:GetHatModelParams()
end

function HatMixin:SetHatType(hatType)
	self.hatType = hatType
end

function HatMixin:SetupHat()
	local attachPointName = self:GetHatAttachPoint()
	
end

function HatMixin:RemoveHat()

end