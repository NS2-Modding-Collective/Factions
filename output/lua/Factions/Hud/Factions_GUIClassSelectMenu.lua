//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Marine_Client.lua

class 'Factions_GUIClassSelectMenu' (GUIScript)

local kFont = "fonts/AgencyFB_small.fnt"
local kLargeFont = "fonts/AgencyFB_large.fnt"

Factions_GUIClassSelectMenu.kContentBgTexture = "ui/menu/repeating_bg.dds"

Factions_GUIClassSelectMenu.kBackgroundWidth = GUIScale(1000)
Factions_GUIClassSelectMenu.kBackgroundHeight = GUIScale(800)
// We want the background graphic to look centered around the circle even though there is the part coming off to the right.
Factions_GUIClassSelectMenu.kBackgroundXOffset = GUIScale(0)

// close button
Factions_GUIClassSelectMenu.kButtonWidth = GUIScale(160)
Factions_GUIClassSelectMenu.kButtonHeight = GUIScale(64)
Factions_GUIClassSelectMenu.kCloseButtonColor = Color(1, 1, 0, 1)
Factions_GUIClassSelectMenu.kPadding = GUIScale(8)
Factions_GUIClassSelectMenu.kButtonTexture =  "ui/marine_buymenu_button.dds"

// class buttons
Factions_GUIClassSelectMenu.kClassButtonSize = GUIScale( Vector(128, 512, 0) )
Factions_GUIClassSelectMenu.kClassButtonTexture =  "ui/class.jpg"
Factions_GUIClassSelectMenu.kClassButtonXOffset = GUIScale(64)
Factions_GUIClassSelectMenu.kClassButtonYOffset = GUIScale(64)

function Factions_GUIClassSelectMenu:Initialize()

    self.mouseOverStates = { }
    self.player = Client.GetLocalPlayer()
    
    // This invisible background is used for centering only.
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(Color(0.05, 0.05, 0.1, 0.7))
    // 1 above main menu,    
    self.background:SetLayer(kGUILayerMainMenu - 1)
    
    self.content = GUIManager:CreateGraphicItem()
    self.content:SetSize(Vector(Factions_GUIClassSelectMenu.kBackgroundWidth, Factions_GUIClassSelectMenu.kBackgroundHeight, 0))
    self.content:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.content:SetPosition(Vector((-Factions_GUIClassSelectMenu.kBackgroundWidth / 2) + Factions_GUIClassSelectMenu.kBackgroundXOffset, -Factions_GUIClassSelectMenu.kBackgroundHeight / 2, 0))
    self.content:SetTexture(Factions_GUIClassSelectMenu.kContentBgTexture)
    self.content:SetTexturePixelCoordinates(0, 0, Factions_GUIClassSelectMenu.kBackgroundWidth, Factions_GUIClassSelectMenu.kBackgroundHeight)
    self.content:SetColor( Color(1,1,1,0.8) )
    self.background:AddChild(self.content)
    
    self.selectClassText = GUIManager:CreateTextItem()
    self.selectClassText:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.selectClassText:SetFontName(kLargeFont)
    self.selectClassText:SetPosition(Vector(0, Factions_GUIClassSelectMenu.kClassButtonYOffset / 2, 0))
    self.selectClassText:SetTextAlignmentX(GUIItem.Align_Center)
    self.selectClassText:SetTextAlignmentY(GUIItem.Align_Center)
    self.selectClassText:SetText("Choose your class")
    self.selectClassText:SetFontIsBold(true)
    //self.selectClassText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
    self.content:AddChild(self.selectClassText)
    
    // close button    
    self.closeButton = GUIManager:CreateGraphicItem()
    self.closeButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.closeButton:SetSize(Vector(Factions_GUIClassSelectMenu.kButtonWidth, Factions_GUIClassSelectMenu.kButtonHeight, 0))
    self.closeButton:SetPosition(Vector(-Factions_GUIClassSelectMenu.kButtonWidth, Factions_GUIClassSelectMenu.kPadding, 0))
    self.closeButton:SetTexture(Factions_GUIClassSelectMenu.kButtonTexture)
    self.closeButton:SetLayer(kGUILayerMainMenu - 1)
    self.closeButton:SetIsVisible(self.player.factionsClassType ~= kFactionsClassType.NoneSelected)
    self.content:AddChild(self.closeButton)
    
    self.closeButtonText = GUIManager:CreateTextItem()
    self.closeButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    //self.closeButtonText:SetFontName(Factions_GUIClassSelectMenu.kFont)
    self.closeButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.closeButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.closeButtonText:SetText(Locale.ResolveString("EXIT"))
    self.closeButtonText:SetFontIsBold(true)
    self.closeButtonText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
    self.closeButton:AddChild(self.closeButtonText)

    self:AddClassButtons()
end


function Factions_GUIClassSelectMenu:AddClassButtons()

    // Create classes buttons        
    self.buttons = {}
    local classes = self.player:GetAllClasses()
    local xOffset = 0
    
    for _, class in pairs(classes) do    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(Factions_GUIClassSelectMenu.kClassButtonSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-xOffset, Factions_GUIClassSelectMenu.kClassButtonYOffset, 0))
        graphicItem:SetTexture(Factions_GUIClassSelectMenu.kClassButtonTexture)
        graphicItem.classType = class.type
        //graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))    
        self.content:AddChild(graphicItem)
        table.insert(self.buttons, graphicItem)
        
        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetAnchor(GUIItem.Middle, GUIItem.Top)
        //self.closeButtonText:SetFontName(Factions_GUIClassSelectMenu.kFont)
        buttonText:SetPosition(Vector(0, 20, 0))
        buttonText:SetTextAlignmentX(GUIItem.Align_Center)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetText(class.type)
        buttonText:SetFontIsBold(true)
        buttonText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
        graphicItem:AddChild(buttonText) 
        xOffset = xOffset + Factions_GUIClassSelectMenu.kClassButtonSize.x + Factions_GUIClassSelectMenu.kClassButtonXOffset
    end
  
end



function Factions_GUIClassSelectMenu:Uninitialize()
    GUI.DestroyItem(self.background)
    self.background = nil
    
    GUI.DestroyItem(self.closeButton)
    self.closeButton = nil
    
    self.buttons = nil
end


function Factions_GUIClassSelectMenu:Update(deltaTime)
/*
    for i = 1, #self.buttons do        
        local item = self.buttons[i]
        if self:GetIsMouseOver(item) then 
            // hover            
        else
            // not hover
        end
    end
  */  
end


function Factions_GUIClassSelectMenu:GetIsMouseOver(overItem)
    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
         MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver
end


function Factions_GUIClassSelectMenu:SendKeyEvent(key, down)

    // only register key events when everythings loaded
    if self.background then
        if self:GetIsMouseOver(self.closeButton) then
            if self.closeButton:GetIsVisible() and key == InputKey.MouseButton0 and down then
                self.player:CloseClassSelectMenu()
            end
        else
            if self.buttons then
                for i, item in ipairs(self.buttons) do        
                    if self:GetIsMouseOver(item) then 
                        if key == InputKey.MouseButton0 and down then
                            // change it to client and server (so the ui will dissappear
                            self.player:ChangeFactionsClassFromString(item.classType)
                            Shared.ConsoleCommand("class " .. item.classType)
                            self.player:CloseClassSelectMenu()  
                        end
                    end            
                end
            end
        end
    end
    
end

function Factions_GUIClassSelectMenu:OnClose()
end
