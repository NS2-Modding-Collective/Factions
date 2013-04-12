//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_BuyMenuMixin.lua

BuyMenuMixin = CreateMixin( BuyMenuMixin )
BuyMenuMixin.type = "BuyMenu"

BuyMenuMixin.expectedMixins =
{
}

BuyMenuMixin.expectedCallbacks =
{
}

BuyMenuMixin.expectedConstants =
{
}

BuyMenuMixin.networkVars =
{
}


// These should completely override any existing function defined in the class.
BuyMenuMixin.overrideFunctions =
{
	"Buy",
	"CloseMenu",
}

function BuyMenuMixin:__initmixin()

	self.combatBuyMenu = nil
	self.combatBuy = false

end

if Client then
    // starting the custom buy menu for marines
    function BuyMenuMixin:Buy()

       // Don't allow display in the ready room, or as phantom
       if Client.GetLocalPlayer() == self then
            if self:GetTeamNumber() ~= 0 then
            
                if not self.buyMenu then
                    // open the buy menu
                    self.combatBuy = true
                    self.buyMenu = GetGUIManager():CreateGUIScript("Factions/Hud/Factions_GUIMarineBuyMenu")
                    self.combatBuyMenu = self.buyMenu
                    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
                else
                    self.combatBuy = false
                    self:CloseMenu()
                end               

            end            
        end
    end
    
    // dont close the menu
    local overrideCloseMenu = Marine.CloseMenu
    function BuyMenuMixin:CloseMenu(buyMenu) 
        if buyMenu then
            overrideCloseMenu(self)
        end
    end
end