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
							  baseOffset = Vector(0.5,0,0),
							  baseScale = Vector(0.4,0.4,0.4),
							  baseAngles = Angles(0,0,-90), })

HatMixin.expectedMixins =
{
}

HatMixin.expectedCallbacks =
{
}

HatMixin.expectedConstants =
{
	kAttachPoint = "The attach point for hats",
	kOffset = "The offset of the hat using Marine scale as a baseline",
	kScale = "The scale of the hat using Marine scale as a baseline",
	kAngles = "The angle of the hat using Marine scale as a baseline",
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
		self:SetupHat()
	end

end

function HatMixin:GetHatModelParams()
	return kHatModels[self.hatType]
end

if Server then
	function HatMixin:SetHatType(hatType)
		self.hatType = hatType
		self:SetupHat()
	end

	function HatMixin:SetupHat()
		local hatParams = self:GetHatModelParams()
		local mixinConstants = self:GetMixinConstants()
	
		if hatParams then
			local attachPointName = mixinConstants.kAttachPoint
			local model = hatParams.model
			local animationGraph = hatParams.animationGraph
			local offset = hatParams.baseOffset + mixinConstants.kOffset
			local scale = hatParams.baseScale * mixinConstants.kScale
			local angles = hatParams.baseAngles + mixinConstants.kAngles
		
			self:AddAttachedModel(model, animationGraph, attachPointName, offset, scale, angles)
			self.hatModel = lastAttachedModel
		else
			self:RemoveHat()
		end
		
	end
end

function HatMixin:RemoveHat()
	self.hatType = HatType.None
	if self.hatModel then
		DestroyEntity(self.hatModel)
		self.hatModel = nil
	end
end

// TODO: Allow hats to fall off!
function HatMixin:CreateDroppedHat()
end