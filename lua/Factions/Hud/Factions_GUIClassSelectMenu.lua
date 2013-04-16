//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GUIMarineBuyMenu.lua

Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/Factions/Factions_UpgradeMixin.lua")

class 'Factions_GUIClassSelectMenu' (GUIAnimatedScript)

Factions_GUIMarineBuyMenu.kBuyMenuTexture = "ui/marine_buy_textures.dds"
Factions_GUIMarineBuyMenu.kBuyHUDTexture = "ui/marine_buy_icons.dds"
Factions_GUIMarineBuyMenu.kRepeatingBackground = "ui/menu/grid.dds"
Factions_GUIMarineBuyMenu.kContentBgTexture = "ui/menu/repeating_bg.dds"
Factions_GUIMarineBuyMenu.kContentBgBackTexture = "ui/menu/repeating_bg_black.dds"
Factions_GUIMarineBuyMenu.kButtonTexture = "ui/marine_buymenu_button.dds"
Factions_GUIMarineBuyMenu.kMenuSelectionTexture = "ui/marine_buymenu_selector.dds"
Factions_GUIMarineBuyMenu.kScanLineTexture = "ui/menu/scanLine_big.dds"
Factions_GUIMarineBuyMenu.kArrowTexture = "ui/menu/arrow_horiz.dds"

Factions_GUIMarineBuyMenu.kFont = "fonts/AgencyFB_small.fnt"
Factions_GUIMarineBuyMenu.kFont2 = "fonts/AgencyFB_small.fnt"

Factions_GUIMarineBuyMenu.kDescriptionFontName = "fonts/AgencyFB_tiny.fnt"

Factions_GUIMarineBuyMenu.kScanLineHeight = GUIScale(256)
Factions_GUIMarineBuyMenu.kScanLineAnimDuration = 5

Factions_GUIMarineBuyMenu.kArrowWidth = GUIScale(32)
Factions_GUIMarineBuyMenu.kArrowHeight = GUIScale(32)
Factions_GUIMarineBuyMenu.kArrowTexCoords = { 1, 1, 0, 0 }

// Small Item Icons

Factions_GUIMarineBuyMenu.kSmallIconSize = GUIScale( Vector(80, 80, 0) )
Factions_GUIMarineBuyMenu.kSelectorSize = GUIScale( Vector(100, 100, 0) )

// x-offset
Factions_GUIMarineBuyMenu.kSmallIconOffset_x = GUIScale(120)

Factions_GUIMarineBuyMenu.kIconTopOffset = 40
Factions_GUIMarineBuyMenu.kItemIconYOffset = {}

Factions_GUIMarineBuyMenu.kEquippedIconTopOffset = 58

local smallIconHeight = 80
local smallIconWidth = 80
// max Icon per row
local smallIconRows = 4

local gSmallIconIndex = nil
                            
Factions_GUIMarineBuyMenu.kTextColor = Color(kMarineFontColor)

Factions_GUIMarineBuyMenu.kMenuWidth = GUIScale(128)
Factions_GUIMarineBuyMenu.kPadding = GUIScale(8)

Factions_GUIMarineBuyMenu.kEquippedWidth = GUIScale(128)

Factions_GUIMarineBuyMenu.kEquippedColor = Color(0.6, 0.6, 0.6, 0.6)

Factions_GUIMarineBuyMenu.kBackgroundWidth = GUIScale(600)
Factions_GUIMarineBuyMenu.kBackgroundHeight = GUIScale(520)
// We want the background graphic to look centered around the circle even though there is the part coming off to the right.
Factions_GUIMarineBuyMenu.kBackgroundXOffset = GUIScale(0)

Factions_GUIMarineBuyMenu.kPlayersTextSize = GUIScale(24)
Factions_GUIMarineBuyMenu.kResearchTextSize = GUIScale(24)

Factions_GUIMarineBuyMenu.kResourceDisplayHeight = GUIScale(64)

Factions_GUIMarineBuyMenu.kResourceIconWidth = GUIScale(32)
Factions_GUIMarineBuyMenu.kResourceIconHeight = GUIScale(32)

Factions_GUIMarineBuyMenu.kLevelOffsetX = GUIScale(5)
Factions_GUIMarineBuyMenu.kLevelOffsetY = GUIScale(13)

Factions_GUIMarineBuyMenu.kMouseOverInfoTextSize = GUIScale(20)
Factions_GUIMarineBuyMenu.kMouseOverInfoOffset = Vector(GUIScale(-30), GUIScale(-20), 0)
Factions_GUIMarineBuyMenu.kMouseOverInfoResIconOffset = Vector(GUIScale(-40), GUIScale(-60), 0)

Factions_GUIMarineBuyMenu.kDisabledColor = Color(0.5, 0.5, 0.5, 0.5)
Factions_GUIMarineBuyMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
Factions_GUIMarineBuyMenu.kEnabledColor = Color(1, 1, 1, 1)

Factions_GUIMarineBuyMenu.kCloseButtonColor = Color(1, 1, 0, 1)

Factions_GUIMarineBuyMenu.kButtonWidth = GUIScale(160)
Factions_GUIMarineBuyMenu.kButtonHeight = GUIScale(64)

Factions_GUIMarineBuyMenu.kItemNameOffsetX = GUIScale(28)
Factions_GUIMarineBuyMenu.kItemNameOffsetY = GUIScale(256)

Factions_GUIMarineBuyMenu.kItemDescriptionOffsetY = GUIScale(300)
Factions_GUIMarineBuyMenu.kItemDescriptionSize = GUIScale( Vector(450, 180, 0) )

function Factions_GUIMarineBuyMenu:SetHostStructure(hostStructure)

    self.hostStructure = hostStructure
    self:_InitializeItemButtons()
    self.selectedItem = nil
    
end


function Factions_GUIMarineBuyMenu:OnClose()

    // Check if GUIMarineBuyMenu is what is causing itself to close.
	self.player.classSelect = false
    if not self.closingMenu then
        // Play the close sound since we didn't trigger the close.
        self.player:CloseMenu(true)
    end


end

function Factions_GUIMarineBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)
    
    self.player = Client.GetLocalPlayer()    

    self.mouseOverStates = { }
    self.selectedUpgrades = { }
    self.equipped = { }
    
    self.selectedItemCinematic = nil
    self.selectedItem = nil
    
    self:_InitializeBackground()
    self:_InitializeContent()
    self:_InitializeClassButtons()
    self:_InitializeCloseButton()
    
end

function Factions_GUIMarineBuyMenu:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

	self.player = Client.GetLocalPlayer()
    self:_UpdateBackground(deltaTime)
    self:_UpdateClassButtons(deltaTime)
    self:_UpdateContent(deltaTime)
    self:_UpdateCloseButton(deltaTime)
    
end

function Factions_GUIMarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    self:_UninitializeClassButtons()
    self:_UninitializeBackground()
    self:_UninitializeContent()
    self:_UninitializeCloseButton()

end

local function MoveDownAnim(script, item)

    item:SetPosition( Vector(0, -Factions_GUIMarineBuyMenu.kScanLineHeight, 0) )
    item:SetPosition( Vector(0, Client.GetScreenHeight() + Factions_GUIMarineBuyMenu.kScanLineHeight, 0), Factions_GUIMarineBuyMenu.kScanLineAnimDuration, "MARINEBUY_SCANLINE", AnimateLinear, MoveDownAnim)

end

function Factions_GUIMarineBuyMenu:_InitializeBackground()

    // This invisible background is used for centering only.
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(Color(0.05, 0.05, 0.1, 0.7))
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)
    
    self.repeatingBGTexture = GUIManager:CreateGraphicItem()
    self.repeatingBGTexture:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.repeatingBGTexture:SetTexture(Factions_GUIMarineBuyMenu.kRepeatingBackground)
    self.repeatingBGTexture:SetTexturePixelCoordinates(0, 0, Client.GetScreenWidth(), Client.GetScreenHeight())
    self.background:AddChild(self.repeatingBGTexture)
    
    self.content = GUIManager:CreateGraphicItem()
    self.content:SetSize(Vector(Factions_GUIMarineBuyMenu.kBackgroundWidth, Factions_GUIMarineBuyMenu.kBackgroundHeight, 0))
    self.content:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.content:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kBackgroundWidth / 2) + Factions_GUIMarineBuyMenu.kBackgroundXOffset, -Factions_GUIMarineBuyMenu.kBackgroundHeight / 2, 0))
    self.content:SetTexture(Factions_GUIMarineBuyMenu.kContentBgTexture)
    self.content:SetTexturePixelCoordinates(0, 0, Factions_GUIMarineBuyMenu.kBackgroundWidth, Factions_GUIMarineBuyMenu.kBackgroundHeight)
    self.background:AddChild(self.content)
    
    self.scanLine = self:CreateAnimatedGraphicItem()
    self.scanLine:SetSize( Vector( Client.GetScreenWidth(), Factions_GUIMarineBuyMenu.kScanLineHeight, 0) )
    self.scanLine:SetTexture(Factions_GUIMarineBuyMenu.kScanLineTexture)
    self.scanLine:SetLayer(kGUILayerPlayerHUDForeground4)
    self.scanLine:SetIsScaling(false)
    
    self.scanLine:SetPosition( Vector(0, -Factions_GUIMarineBuyMenu.kScanLineHeight, 0) )
    self.scanLine:SetPosition( Vector(0, Client.GetScreenHeight() + Factions_GUIMarineBuyMenu.kScanLineHeight, 0), Factions_GUIMarineBuyMenu.kScanLineAnimDuration, "MARINEBUY_SCANLINE", AnimateLinear, MoveDownAnim)

end

function Factions_GUIMarineBuyMenu:_UpdateBackground(deltaTime)

    // TODO: create some fancy effect (screen of structure is projecting rays in our direction?)
    
end

function Factions_GUIMarineBuyMenu:_UninitializeBackground()
    
    GUI.DestroyItem(self.background)
    self.background = nil
    
    self.content = nil

end

function _InitializeClassButton(index, factionsClass)
	local graphicItem = GUIManager:CreateGraphicItem()
					graphicItem:SetSize(Factions_GUIMarineBuyMenu.kSmallIconSize)
					graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
					graphicItem:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2) + xOffset, Factions_GUIMarineBuyMenu.kIconTopOffset + (Factions_GUIMarineBuyMenu.kSmallIconSize.y) * itemNr - Factions_GUIMarineBuyMenu.kSmallIconSize.y, 0))
					// set the tecture file for the icons
					graphicItem:SetTexture(factionsClass:GetIcon())
					 // set the pixel coordinate for the icon
					graphicItem:SetTexturePixelCoordinates(factionsClass:GetIconTextureCoords())

					local graphicItemActive = GUIManager:CreateGraphicItem()
					graphicItemActive:SetSize(Factions_GUIMarineBuyMenu.kSelectorSize)          
					graphicItemActive:SetPosition(Vector(selectorPosX, -Factions_GUIMarineBuyMenu.kSelectorSize.y / 2, 0))
					graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
					graphicItemActive:SetTexture(Factions_GUIMarineBuyMenu.kMenuSelectionTexture)
					graphicItemActive:SetIsVisible(false)
					
					graphicItem:AddChild(graphicItemActive)
					
					self.menu:AddChild(graphicItem)
					table.insert(self.itemButtons, { Button = graphicItem, Highlight = graphicItemActive, TechId = itemTechId, Cost = itemCost, ResourceIcon = costIcon, Arrow = selectedArrow, Level = level, Upgrade = upgrade} )
					
end

function Factions_GUIMarineBuyMenu:_InitializeClassButtons()
    
    self.menu = GetGUIManager():CreateGraphicItem()
    self.menu:SetPosition(Vector( -Factions_GUIMarineBuyMenu.kMenuWidth - Factions_GUIMarineBuyMenu.kPadding, 0, 0))
    self.menu:SetTexture(Factions_GUIMarineBuyMenu.kContentBgTexture)
    self.menu:SetSize(Vector(Factions_GUIMarineBuyMenu.kMenuWidth, Factions_GUIMarineBuyMenu.kBackgroundHeight, 0))
    self.menu:SetTexturePixelCoordinates(0, 0, Factions_GUIMarineBuyMenu.kMenuWidth, Factions_GUIMarineBuyMenu.kBackgroundHeight)
    self.content:AddChild(self.menu)
    
    self.menuHeader = GetGUIManager():CreateGraphicItem()
    self.menuHeader:SetSize(Vector(Factions_GUIMarineBuyMenu.kMenuWidth, Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetPosition(Vector(0, -Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetTexture(Factions_GUIMarineBuyMenu.kContentBgBackTexture)
    self.menuHeader:SetTexturePixelCoordinates(0, 0, Factions_GUIMarineBuyMenu.kMenuWidth, Factions_GUIMarineBuyMenu.kResourceDisplayHeight)
    self.menu:AddChild(self.menuHeader) 
    
    self.menuHeaderTitle = GetGUIManager():CreateTextItem()
    self.menuHeaderTitle:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.menuHeaderTitle:SetFontIsBold(true)
    self.menuHeaderTitle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.menuHeaderTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.menuHeaderTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.menuHeaderTitle:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    self.menuHeaderTitle:SetText(Locale.ResolveString("BUY"))
    self.menuHeader:AddChild(self.menuHeaderTitle)    
    
    self.itemButtons = { }
	
    local selectorPosX = -Factions_GUIMarineBuyMenu.kSelectorSize.x + Factions_GUIMarineBuyMenu.kPadding
    local fontScaleVector = Vector(0.8, 0.8, 0)
    local k = 1
    xOffset  = 0
	
	for index, classEntity in ipairs(kAllFactionsClasses) do
	
		local itemNr = 1
		
		if upgradeTypeIndex > 1 then
			xOffset = xOffset + Factions_GUIMarineBuyMenu.kSmallIconOffset_x
		end
		
		self:_InitializeClassButton(index, classEntity)
		
	end
    
    // to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

function Factions_GUIMarineBuyMenu:_UpdateClassButtons(deltaTime)

    if self and self.itemButtons then
        for i, item in ipairs(self.itemButtons) do
        
            if self:_GetIsMouseOver(item.Button) then	    
                item.Highlight:SetIsVisible(true)
                self.hoverItem = item.TechId
                self.hoverUpgrade = item.Upgrade
            else 
               item.Highlight:SetIsVisible(false)
           end
           
           local gotRequirements = self.player:GetCanBuyUpgrade(item.Upgrade:GetId())
           local useColor = Color(1,1,1,1)

            // set grey if player doesn'T have the needed other Up
            if not gotRequirements then
            
				useColor = Color(1, 0, 0, 1)
               
            // set it blink when we got the upp already
            elseif  item.Upgrade:GetIsAtMaxLevel() then
                
                local anim = math.cos(Shared.GetTime() * 9) * 0.4 + 0.6
                useColor = Color(1, 1, anim, 1)
                    
            // set red if can't afford
            elseif PlayerUI_GetPlayerResources() < item.Upgrade:GetCostForNextLevel() then
            
                useColor = Color(0.5, 0.5, 0.5, 1) 
               
            end
            
            item.Button:SetColor(useColor)
            item.Highlight:SetColor(useColor)
            item.Cost:SetColor(useColor)
            item.ResourceIcon:SetColor(useColor)
            item.Arrow:SetIsVisible(self.selectedItem == item.TechId)
			item.Level:SetText(GetLevelText(item.Upgrade))
            
        end
    end

end

function Factions_GUIMarineBuyMenu:_UninitializeClassButtons()

/*
    for i, item in ipairs(self.itemButtons) do
        GUI.DestroyItem(item.Button)
    end
    self.itemButtons = nil
    */

end

function Factions_GUIMarineBuyMenu:_InitializeContent()

    self.itemName = GUIManager:CreateTextItem()
    self.itemName:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.itemName:SetFontIsBold(true)
    self.itemName:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.itemName:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2) - 60, Factions_GUIMarineBuyMenu.kIconTopOffset + (Factions_GUIMarineBuyMenu.kSmallIconSize.y) * (smallIconRows + 1.5) - Factions_GUIMarineBuyMenu.kSmallIconSize.y, 0))
    self.itemName:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemName:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemName:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    self.itemName:SetText("no selection")
    
    self.content:AddChild(self.itemName)
    
    self.itemDescription = GetGUIManager():CreateTextItem()
    self.itemDescription:SetFontName(Factions_GUIMarineBuyMenu.kDescriptionFontName)
    self.itemDescription:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.itemDescription:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2) - 200, Factions_GUIMarineBuyMenu.kIconTopOffset + (Factions_GUIMarineBuyMenu.kSmallIconSize.y) * (smallIconRows + 1.8) - Factions_GUIMarineBuyMenu.kSmallIconSize.y, 0))
    self.itemDescription:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemDescription:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemDescription:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    self.itemDescription:SetTextClipped(true, Factions_GUIMarineBuyMenu.kItemDescriptionSize.x - 2* Factions_GUIMarineBuyMenu.kPadding, Factions_GUIMarineBuyMenu.kItemDescriptionSize.y - Factions_GUIMarineBuyMenu.kPadding)
    
    self.content:AddChild(self.itemDescription)
    
end

function Factions_GUIMarineBuyMenu:_UpdateContent(deltaTime)

    local techId = self.hoverItem
    if not self.hoverItem then
        techId = self.selectedItem
    end
    
    if techId then
    
        local researched = self.player:GetCanBuyUpgrade(self.hoverUpgrade:GetId())                
        local itemCost = ConditionalValue(self.hoverUpgrade, self.hoverUpgrade:GetCostForNextLevel(), 0)
        local upgradesCost = 0
        local canAfford = PlayerUI_GetPlayerResources() >= itemCost + upgradesCost

        // the discription text under the buttons
        self.itemName:SetText(self.hoverUpgrade:GetUpgradeTitle())
        self.itemDescription:SetText(self.hoverUpgrade:GetUpgradeDesc())
        self.itemDescription:SetTextClipped(true, Factions_GUIMarineBuyMenu.kItemDescriptionSize.x - 2* Factions_GUIMarineBuyMenu.kPadding, Factions_GUIMarineBuyMenu.kItemDescriptionSize.y - Factions_GUIMarineBuyMenu.kPadding)

    end
    
    local contentVisible = techId ~= nil and techId ~= kTechId.None

    self.itemName:SetIsVisible(contentVisible)
    self.itemDescription:SetIsVisible(contentVisible)
    
end

function Factions_GUIMarineBuyMenu:_UninitializeContent()

    GUI.DestroyItem(self.itemName)

end

function Factions_GUIMarineBuyMenu:_InitializeCloseButton()

    self.closeButton = GUIManager:CreateGraphicItem()
    self.closeButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.closeButton:SetSize(Vector(Factions_GUIMarineBuyMenu.kButtonWidth, Factions_GUIMarineBuyMenu.kButtonHeight, 0))
    self.closeButton:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kButtonWidth, Factions_GUIMarineBuyMenu.kPadding, 0))
    self.closeButton:SetTexture(Factions_GUIMarineBuyMenu.kButtonTexture)
    self.closeButton:SetLayer(kGUILayerPlayerHUDForeground4)
    self.content:AddChild(self.closeButton)
    
    self.closeButtonText = GUIManager:CreateTextItem()
    self.closeButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.closeButtonText:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.closeButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.closeButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.closeButtonText:SetText("EXIT")
    self.closeButtonText:SetFontIsBold(true)
    self.closeButtonText:SetColor(Factions_GUIMarineBuyMenu.kCloseButtonColor)
    self.closeButton:AddChild(self.closeButtonText)
    
end

function Factions_GUIMarineBuyMenu:_UpdateCloseButton(deltaTime)

    if self:_GetIsMouseOver(self.closeButton) then
        self.closeButton:SetColor(Color(1, 1, 1, 1))
    else
        self.closeButton:SetColor(Color(0.5, 0.5, 0.5, 1))
    end

end

function Factions_GUIMarineBuyMenu:_UninitializeCloseButton()
    
    GUI.DestroyItem(self.closeButton)
    self.closeButton = nil

end



/**
 * Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
 */
function Factions_GUIMarineBuyMenu:_GetIsMouseOver(overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver
    
end

function Factions_GUIMarineBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false
    
    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down
        
        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then
                    
            inputHandled, closeMenu = self:_HandleItemClicked(mouseX, mouseY) or inputHandled
            
            if not inputHandled then
            
                // Check if the close button was pressed.
                if self:_GetIsMouseOver(self.closeButton) then
                    closeMenu = true
                    inputHandled = true
                    self:OnClose()
                end
				
            end
        end
        
    end
    
    if InputKey.Escape == key and not down then
        closeMenu = true
        inputHandled = true
        self:OnClose()
    end

    if closeMenu then
        self.closingMenu = true
        self:OnClose()
    end
    
    return inputHandled
    
end

function Factions_GUIMarineBuyMenu:_SetSelectedItem(techId)

    self.selectedItem = techId
    MarineBuy_OnItemSelect(techId)

end

function Factions_GUIMarineBuyMenu:_HandleItemClicked(mouseX, mouseY)

    for i, item in ipairs(self.itemButtons) do
    
        if self:_GetIsMouseOver(item.Button) then
        
            local researched = self.player:GetCanBuyUpgrade(item.Upgrade:GetId())
            local itemCost = item.Upgrade:GetCostForNextLevel()
            local upgradesCost = self:_GetSelectedUpgradesCost()
            local canAfford = PlayerUI_GetPlayerResources() >= itemCost + upgradesCost 
            local hasItem = item.Upgrade:GetIsAtMaxLevel()
            
            if researched and canAfford and not hasItem then
            
                self.player:BuyUpgrade(item.Upgrade:GetId())
                self:OnClose()
                
                return true, true
                
            end
            
        end 
        
    end
    
    return false, false
    
end

function Factions_GUIMarineBuyMenu:_GetSelectedUpgradesCost()

    local upgradeCosts = 0
    
    for k, upgrade in ipairs(self.selectedUpgrades) do
    
        //upgradeCosts = upgradeCosts + MarineBuy_GetCosts(upgrade)
    
    end
    
    return upgradeCosts
    
end