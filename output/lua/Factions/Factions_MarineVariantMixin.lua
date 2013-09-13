//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MarineVariantMixin.lua

if Server then

    // Usually because the client connected or changed their options
    function MarineVariantMixin:OnClientUpdated(client)

        Player.OnClientUpdated(self, client)

        local data = client.variantData
        if data == nil then
            return
        end

        local changed = data.isMale ~= self.isMale or data.marineVariant ~= self.variant

        self.isMale = data.isMale

        if GetHasVariant( kMarineVariantData, data.marineVariant, client ) then

            // cleared, pass info to clients
            self.variant = data.marineVariant
            assert( self.variant ~= -1 )
            local modelName = self:GetVariantModel()
            assert( modelName ~= "" )
			if self:isa("InjuredPlayer") then
				self:SetModel(modelName, InjuredPlayer.kMarineAnimationGraph)
			else
				self:SetModel(modelName, MarineVariantMixin.kMarineAnimationGraph)
			end

        else
            Print("ERROR: Client tried to request marine variant they do not have yet")
        end
            
        // set the highest level shoulder pad
        self.shoulderPadIndex = 0
        for padId = 1, #kShoulderPad2ProductId do

            if GetHasShoulderPad( padId, client ) then
                self.shoulderPadIndex = padId
            end

        end

        if changed then
            // trigger a weapon switch, to update the view model
            if self:GetActiveWeapon() ~= nil then
                self:GetActiveWeapon():OnDraw(self)
            end
        end

    end

end