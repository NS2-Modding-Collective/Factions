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

// class buttons
Factions_GUIClassSelectMenu.kColorPicker = GUIScale( Vector(32, 32, 0) )
Factions_GUIClassSelectMenu.kColorPickerYOffset = GUIScale(Factions_GUIClassSelectMenu.kClassButtonYOffset * 1.5)
Factions_GUIClassSelectMenu.ColorPickerTexture =  "ui/arrow.png"
Factions_GUIClassSelectMenu.kMaxColorButtons = 310
Factions_GUIClassSelectMenu.kColorTolerance = 5

function Factions_GUIClassSelectMenu:Initialize()

    self.mouseOverStates = { }
    
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
    self.selectClassText:SetText("Choose your class and color")
    self.selectClassText:SetFontIsBold(true)
    //self.selectClassText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
    self.content:AddChild(self.selectClassText)
    
    // OK button    
    self.okButton = GUIManager:CreateGraphicItem()
    self.okButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.okButton:SetSize(Vector(Factions_GUIClassSelectMenu.kButtonWidth, Factions_GUIClassSelectMenu.kButtonHeight, 0))
    self.okButton:SetPosition(Vector(-Factions_GUIClassSelectMenu.kButtonWidth, Factions_GUIClassSelectMenu.kPadding, 0))
    self.okButton:SetTexture(Factions_GUIClassSelectMenu.kButtonTexture)
    self.okButton:SetLayer(kGUILayerMainMenu - 1)
    self.content:AddChild(self.okButton)
    
    self.okButtonText = GUIManager:CreateTextItem()
    self.okButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    //self.okButtonText:SetFontName(Factions_GUIClassSelectMenu.kFont)
    self.okButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.okButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.okButtonText:SetText(Locale.ResolveString("OK"))
    self.okButtonText:SetFontIsBold(true)
    self.okButtonText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
    self.okButton:AddChild(self.okButtonText)
    
    // close button    
    self.closeButton = GUIManager:CreateGraphicItem()
    self.closeButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.closeButton:SetSize(Vector(Factions_GUIClassSelectMenu.kButtonWidth, Factions_GUIClassSelectMenu.kButtonHeight, 0))
    self.closeButton:SetPosition(Vector(-2 * Factions_GUIClassSelectMenu.kButtonWidth - Factions_GUIClassSelectMenu.kPadding, Factions_GUIClassSelectMenu.kPadding, 0))
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
    self:AddColorPicker()
    self:SetupColorPicker()
end


function Factions_GUIClassSelectMenu:AddClassButtons()

    // Create classes buttons        
    self.buttons = {}
    self.selectedButton = nil
    
    local classes = Client.GetLocalPlayer():GetAllClasses()
    //local xOffset = 0
    
    local xOffset = -(Factions_GUIClassSelectMenu.kClassButtonSize.x) * (#classes / 2)
    if #classes % 2 ~= 0 then
        xOffset = xOffset + (Factions_GUIClassSelectMenu.kClassButtonSize.x)
    end

    for _, class in pairs(classes) do    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(Factions_GUIClassSelectMenu.kClassButtonSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(xOffset, Factions_GUIClassSelectMenu.kClassButtonYOffset, 0))
        graphicItem:SetTexture(Factions_GUIClassSelectMenu.kClassButtonTexture)
        graphicItem.classType = class.type
        //graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))    
        self.content:AddChild(graphicItem)
        table.insert(self.buttons, graphicItem)
        
        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetAnchor(GUIItem.Middle, GUIItem.Top)
        //self.closeButtonText:SetFontName(Factions_GUIClassSelectMenu.kFont)
        buttonText:SetPosition(GUIScale(Vector(0, 20, 0)))
        buttonText:SetTextAlignmentX(GUIItem.Align_Center)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetText(class.type)
        buttonText:SetFontIsBold(true)
        buttonText:SetColor(Factions_GUIClassSelectMenu.kCloseButtonColor)
        graphicItem:AddChild(buttonText) 
        xOffset = xOffset + Factions_GUIClassSelectMenu.kClassButtonSize.x + Factions_GUIClassSelectMenu.kClassButtonXOffset
    end
  
end


function Factions_GUIClassSelectMenu:AddColorPicker()
    
    self.colorButtons = {}

    local red = 255  
    local green = 0
    local blue = 0
    
    for i = 0, Factions_GUIClassSelectMenu.kMaxColorButtons , 1 do
    
        if red == 255 and blue < 255 and green == 0 then
            blue = blue + 5
        elseif red > 0 and blue == 255 and green < 255 then
            red = red - 5   
        elseif red == 0 and blue == 255 and green < 255 then
            green = green + 5
        elseif red == 0 and blue > 0 and green == 255 then
            blue = blue - 5
        elseif red < 255 and blue == 0 and green == 255 then
            red = red + 5
        elseif red == 255 and blue == 0 and green > 0 then
            green = green - 5
        end

    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(Factions_GUIClassSelectMenu.kColorPicker)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
        graphicItem:SetPosition(Vector(i - GUIScale(250), -Factions_GUIClassSelectMenu.kColorPickerYOffset, 0))
        graphicItem:SetColor(Color(red / 255, green / 255, blue / 255, 1))
        self.content:AddChild(graphicItem)
        table.insert(self.colorButtons, graphicItem)
    end    
    
    self.colorButtonsStart = self.colorButtons[1]:GetPosition()
    self.colorButtonsStart.x = self.colorButtonsStart.x - Factions_GUIClassSelectMenu.kColorPicker.x / 2
    
    self.colorButtonsEnd = self.colorButtons[#self.colorButtons]:GetPosition()
    self.colorButtonsEnd.x = self.colorButtonsEnd.x + Factions_GUIClassSelectMenu.kColorPicker.x / 2
    
    self.colorPickerArrow = GUIManager:CreateGraphicItem()
    self.colorPickerArrow:SetSize(Factions_GUIClassSelectMenu.kColorPicker)
    self.colorPickerArrow:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.colorPickerArrow:SetPosition(Vector(self.colorButtonsEnd.x, -Factions_GUIClassSelectMenu.kColorPickerYOffset - 40 , 0))
    self.colorPickerArrow:SetTexture(Factions_GUIClassSelectMenu.ColorPickerTexture)
    self.content:AddChild(self.colorPickerArrow)
    
    self.pickedColor = GUIManager:CreateGraphicItem()
    self.pickedColor:SetSize(GUIScale( Vector(100, 100, 0) ))
    self.pickedColor:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.pickedColor:SetPosition(Vector(GUIScale(150), -Factions_GUIClassSelectMenu.kColorPickerYOffset - GUIScale(68), 0))
    self.pickedColor:SetColor(self:GetColorForX(self.colorPickerArrow:GetPosition().x))
    self.content:AddChild(self.pickedColor)
    
end

function Factions_GUIClassSelectMenu:SetupColorPicker()

	local teamColours = nil
	local teamNumber = Client.GetLocalPlayer():GetTeamNumber()
	if teamNumber == kTeam2Index then
		teamColours = kAlienTeamColorFloat
	else
		teamColours = kMarineTeamColorFloat
	end
	
	local sliderPositionX = self:GetXForColor(teamColour)
	local arrowPosition = self.colorPickerArrow:GetPosition()
    arrowPosition.x = sliderPositionX
    self.colorPickerArrow:SetPosition(arrowPosition)
    self.pickedColor:SetColor(color)


function Factions_GUIClassSelectMenu:GetColorForX(xValue)

    local sliderEntrys = self.colorButtonsEnd.x - self.colorButtonsStart.x
    local colorButtonEntrys = #self.colorButtons - 1
    local i = math.round((colorButtonEntrys / sliderEntrys) * (xValue - self.colorButtonsStart.x)) +1 
    
    if i <= 0 then
        i = 1
    elseif i > #self.colorButtons then
        i = #self.colorButtons
    end
    
    if self.colorButtons[i] then
        return self.colorButtons[i]:GetColor()
    end
    
end

function Factions_GUIClassSelectMenu:GetXForColor(color)

    local sliderEntrys = self.colorButtonsEnd.x - self.colorButtonsStart.x
    local colorButtonEntrys = #self.colorButtons - 1
   
    // There might be a faster way of doing this but we only do it once!
    local red = 255  
    local green = 0
    local blue = 0
    
    for i = 0, Factions_GUIClassSelectMenu.kMaxColorButtons , 1 do
    
        if red == 255 and blue < 255 and green == 0 then
            blue = blue + 5
        elseif red > 0 and blue == 255 and green < 255 then
            red = red - 5   
        elseif red == 0 and blue == 255 and green < 255 then
            green = green + 5
        elseif red == 0 and blue > 0 and green == 255 then
            blue = blue - 5
        elseif red < 255 and blue == 0 and green == 255 then
            red = red + 5
        elseif red == 255 and blue == 0 and green > 0 then
            green = green - 5
        end
        
        if red - Factions_GUIClassSelectMenu.kColorTolerance >= color.r and
           green - Factions_GUIClassSelectMenu.kColorTolerance >= color.g and
           blue - Factions_GUIClassSelectMenu.kColorTolerance >= color.b and
           red + Factions_GUIClassSelectMenu.kColorTolerance <= color.r and
           green + Factions_GUIClassSelectMenu.kColorTolerance <= color.g and
           blue + Factions_GUIClassSelectMenu.kColorTolerance <= color.b then
        	
        	local sliderPosition = self.colorButtons[i]:GetPosition()
        	return sliderPosition.x
        	
        end
        
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


    if self.buttons then
        if self.selectedButton then
        
            for i, item in ipairs(self.buttons) do        
                if self.selectedButton == item then 
                    item:SetColor(Color(1, 1, 1, 1))
                else
                    item:SetColor(Color(0.5, 0.5, 0.5, 1))
                end 
            end
            
        end
    end
    
    if self.colorPickerArrowSelected then
        local mouseX, mouseY = Client.GetCursorPosScreen()  
        mouseX = mouseX - self.colorPickerArrow:GetScreenPosition( Client.GetScreenWidth(),  Client.GetScreenHeight()).x 

        local newPosition = Vector(self.colorPickerArrow:GetPosition().x + mouseX, self.colorPickerArrow:GetPosition().y, 0) 

        if newPosition.x < self.colorButtonsStart.x then
            newPosition.x = self.colorButtonsStart.x
        elseif newPosition.x > self.colorButtonsEnd.x then
            newPosition.x = self.colorButtonsEnd.x
        end

        self.colorPickerArrow:SetPosition(newPosition)
        self.pickedColor:SetColor(self:GetColorForX(newPosition.x)) 
    end  
  
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

	local player = Client.GetLocalPlayer()
    // only register key events when everythings loaded
    if self.background then
    
        if key == InputKey.MouseButton0 and down then   
            
            if (self:GetIsMouseOver(self.colorPickerArrow)) then
                self.colorPickerArrowSelected = true
                
            elseif self:GetIsMouseOver(self.okButton) then
                if self.selectedButton or self.closeButton:GetIsVisible() then
                    if self.selectedButton then
                        // change it to client and server (so the ui will dissappear
                        player:ChangeFactionsClassFromString(self.selectedButton.classType)
                        Shared.ConsoleCommand("class " .. self.selectedButton.classType)
                    end
                    
                    // set color
                    local color = self:GetColorForX(self.colorPickerArrow:GetPosition().x)
                    if color then
                        Shared.ConsoleCommand("setcolour " .. math.round(color.r * 255) .. " " .. math.round(color.g * 255) .. " " .. math.round(color.b * 255))
                    end
                    
                    player:CloseClassSelectMenu() 
                end
                 
            elseif self:GetIsMouseOver(self.closeButton) then
                if self.closeButton:GetIsVisible() and key == InputKey.MouseButton0 and down then
                    player:CloseClassSelectMenu()
                end
                
            else
                if self.buttons then
                    self.colorPickerArrowSelected = false
                    for i, item in ipairs(self.buttons) do        
                        if self:GetIsMouseOver(item) then 
                            self.selectedButton = item                             
                        end            
                    end
                end
            end
            
        else
            self.colorPickerArrowSelected = false
        end
    end
    
end

function Factions_GUIClassSelectMenu:OnClose()
end
