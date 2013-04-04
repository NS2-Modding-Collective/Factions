//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Factions_GUIMarineBuyMenu.lua

Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/Factions/Factions_UpgradeMixin.lua")

class 'Factions_GUIMarineBuyMenu' (GUIAnimatedScript)

Factions_GUIMarineBuyMenu.kBuyMenuTexture = "ui/marine_buy_textures.dds"
Factions_GUIMarineBuyMenu.kBuyHUDTexture = "ui/marine_buy_icons.dds"
Factions_GUIMarineBuyMenu.kRepeatingBackground = "ui/menu/grid.dds"
Factions_GUIMarineBuyMenu.kContentBgTexture = "ui/menu/repeating_bg.dds"
Factions_GUIMarineBuyMenu.kContentBgBackTexture = "ui/menu/repeating_bg_black.dds"
Factions_GUIMarineBuyMenu.kResourceIconTexture = "ui/pres_icon_big.dds"
Factions_GUIMarineBuyMenu.kSmallIconTexture = "ui/combat_marine_buildmenu.dds"
Factions_GUIMarineBuyMenu.kBigIconTexture = "ui/marine_buy_bigicons.dds"
Factions_GUIMarineBuyMenu.kButtonTexture = "ui/marine_buymenu_button.dds"
Factions_GUIMarineBuyMenu.kMenuSelectionTexture = "ui/marine_buymenu_selector.dds"
Factions_GUIMarineBuyMenu.kScanLineTexture = "ui/menu/scanLine_big.dds"
Factions_GUIMarineBuyMenu.kArrowTexture = "ui/menu/arrow_horiz.dds"

Factions_GUIMarineBuyMenu.kFont = "fonts/AgencyFB_small.fnt"
Factions_GUIMarineBuyMenu.kFont2 = "fonts/AgencyFB_small.fnt"

Factions_GUIMarineBuyMenu.kDescriptionFontName = "MicrogrammaDBolExt"
Factions_GUIMarineBuyMenu.kDescriptionFontSize = GUIScale(20)

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
local function GetSmallIconPixelCoordinates(itemTechId)

    if not kCombatMarineTechIdToMaterialOffset then
    
        // Init marine offsets
        kCombatMarineTechIdToMaterialOffset = {} 
        
        // class 
        kCombatMarineTechIdToMaterialOffset[kTechId.Jetpack] = 40
        kCombatMarineTechIdToMaterialOffset[kTechId.Exosuit] = 76
        kCombatMarineTechIdToMaterialOffset[kTechId.DualMinigunExosuit] = 35
        
        // weapons        
        kCombatMarineTechIdToMaterialOffset[kTechId.LayMines] = 80
        kCombatMarineTechIdToMaterialOffset[kTechId.Welder] = 34
        kCombatMarineTechIdToMaterialOffset[kTechId.Shotgun] = 48
        kCombatMarineTechIdToMaterialOffset[kTechId.GrenadeLauncher] = 72
        kCombatMarineTechIdToMaterialOffset[kTechId.Flamethrower] = 42
		kCombatMarineTechIdToMaterialOffset[kTechId.Mine] = 80
        
        // tech        
        kCombatMarineTechIdToMaterialOffset[kTechId.Armor1] = 49
        kCombatMarineTechIdToMaterialOffset[kTechId.Armor2] = 50
        kCombatMarineTechIdToMaterialOffset[kTechId.Armor3] = 51
        kCombatMarineTechIdToMaterialOffset[kTechId.Weapons1] = 55
        kCombatMarineTechIdToMaterialOffset[kTechId.Weapons2] = 56
        kCombatMarineTechIdToMaterialOffset[kTechId.Weapons3] = 57        
        kCombatMarineTechIdToMaterialOffset[kTechId.MedPack] = 37
        kCombatMarineTechIdToMaterialOffset[kTechId.Scan] = 41
        kCombatMarineTechIdToMaterialOffset[kTechId.MACEMP] = 62
		kCombatMarineTechIdToMaterialOffset[kTechId.CatPack] = 45
		// fast reload
		kCombatMarineTechIdToMaterialOffset[kTechId.RifleUpgrade] = 71
    
    end
    
    local index = kCombatMarineTechIdToMaterialOffset[itemTechId]
    if not index then
        index = 0
    end
        
    local columns = 12    
    local textureOffset_x1 = index % columns
    local textureOffset_y1 = math.floor(index / columns)
    
    local pixelXOffset = textureOffset_x1 * smallIconWidth
    local pixelYOffset = textureOffset_y1 * smallIconHeight
        
    return pixelXOffset, pixelYOffset, pixelXOffset + smallIconWidth, pixelYOffset + smallIconHeight

end

                            
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
	self.player.combatBuy = false
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
    self:_InitializeItemButtons()
    self:_InitializeResourceDisplay()
    self:_InitializeCloseButton()
    self:_InitializeEquipped()    
    // note: items buttons get initialized through SetHostStructure()
    MarineBuy_OnOpen()
    
end

function Factions_GUIMarineBuyMenu:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

	self.player = Client.GetLocalPlayer()
    self:_UpdateBackground(deltaTime)
    self:_UpdateEquipped(deltaTime)
    self:_UpdateItemButtons(deltaTime)
    self:_UpdateContent(deltaTime)
    self:_UpdateResourceDisplay(deltaTime)
    self:_UpdateCloseButton(deltaTime)
    
end

function Factions_GUIMarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    self:_UninitializeItemButtons()
    self:_UninitializeBackground()
    self:_UninitializeContent()
    self:_UninitializeResourceDisplay()
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

function Factions_GUIMarineBuyMenu:_InitializeEquipped()

    self.equippedBg = GetGUIManager():CreateGraphicItem()
    self.equippedBg:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.equippedBg:SetPosition(Vector( Factions_GUIMarineBuyMenu.kPadding, -Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.equippedBg:SetSize(Vector(Factions_GUIMarineBuyMenu.kEquippedWidth, Factions_GUIMarineBuyMenu.kBackgroundHeight + Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.equippedBg:SetColor(Color(0,0,0,0))
    self.content:AddChild(self.equippedBg)
    
    self.equippedTitle = GetGUIManager():CreateTextItem()
    self.equippedTitle:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.equippedTitle:SetFontIsBold(true)
    self.equippedTitle:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.equippedTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.equippedTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.equippedTitle:SetColor(Factions_GUIMarineBuyMenu.kEquippedColor)
    self.equippedTitle:SetPosition(Vector(0, Factions_GUIMarineBuyMenu.kResourceDisplayHeight / 2, 0))
    self.equippedTitle:SetText(Combat_ResolveString("EQUIPPED"))
    self.equippedBg:AddChild(self.equippedTitle)
    
    
        self.equipped = { }
    
    local equippedTechIds = self.player:GetUpgrades()
    local selectorPosX = -Factions_GUIMarineBuyMenu.kSelectorSize.x + Factions_GUIMarineBuyMenu.kPadding
    
    for k, itemTechId in ipairs(equippedTechIds) do
    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(Factions_GUIMarineBuyMenu.kSmallIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2, Factions_GUIMarineBuyMenu.kEquippedIconTopOffset + (Factions_GUIMarineBuyMenu.kSmallIconSize.y) * k - Factions_GUIMarineBuyMenu.kSmallIconSize.y, 0))
        graphicItem:SetTexture(Factions_GUIMarineBuyMenu.kSmallIconTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))
        
        self.equippedBg:AddChild(graphicItem)
        table.insert(self.equipped, { Graphic = graphicItem, TechId = itemTechId } )
    
    end
    
end

local function GetLevelText(upgrade)
	if upgrade:GetMaxLevels() > 1 then
		return upgrade:GetCurrentLevel() .. " / " .. upgrade:GetMaxLevels()
	else
		return ""
	end
end

function Factions_GUIMarineBuyMenu:_InitializeItemButtons()
    
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
    self.menuHeaderTitle:SetText(Combat_ResolveString("BUY"))
    self.menuHeader:AddChild(self.menuHeaderTitle)    
    
    self.itemButtons = { }
	
    local selectorPosX = -Factions_GUIMarineBuyMenu.kSelectorSize.x + Factions_GUIMarineBuyMenu.kPadding
    local fontScaleVector = Vector(0.8, 0.8, 0)
    local k = 1
    xOffset  = 0
	
	for upgradeTypeIndex, upgradeTypeName in ipairs(kFactionsUpgradeTypes) do
	
		local itemNr = 1
		
		if upgradeTypeIndex > 1 then
			xOffset = xOffset + Factions_GUIMarineBuyMenu.kSmallIconOffset_x
		end
		
		// set the headline
		local graphicItemHeading = GUIManager:CreateTextItem()
		graphicItemHeading:SetFontName(Factions_GUIMarineBuyMenu.kFont)
		graphicItemHeading:SetFontIsBold(true)
		graphicItemHeading:SetAnchor(GUIItem.Middle, GUIItem.Top)
		graphicItemHeading:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2) + xOffset, 5, 0))
		graphicItemHeading:SetTextAlignmentX(GUIItem.Align_Min)
		graphicItemHeading:SetTextAlignmentY(GUIItem.Align_Min)
		graphicItemHeading:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
		graphicItemHeading:SetText(upgradeTypeName)
		self.menu:AddChild(graphicItemHeading)
		
		local allUps = self.player:GetAvailableUpgradesByType(upgradeTypeName)
		
		for index, upgrade in ipairs(allUps) do

			if not upgrade:GetHideUpgrade() then
					// only 6 icons per column
					// Shuffle the column forward if we need more room.
					if itemNr > 1 and itemNr % 6 then
						xOffset = xOffset + Factions_GUIMarineBuyMenu.kSmallIconOffset_x
						itemNr = 1
					end
				
					local itemTechId = upgrade:GetUpgradeTechId()

					if itemTechId then         
						
						local graphicItem = GUIManager:CreateGraphicItem()
						graphicItem:SetSize(Factions_GUIMarineBuyMenu.kSmallIconSize)
						graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
						graphicItem:SetPosition(Vector((-Factions_GUIMarineBuyMenu.kSmallIconSize.x/ 2) + xOffset, Factions_GUIMarineBuyMenu.kIconTopOffset + (Factions_GUIMarineBuyMenu.kSmallIconSize.y) * itemNr - Factions_GUIMarineBuyMenu.kSmallIconSize.y, 0))
						// set the tecture file for the icons
						graphicItem:SetTexture(Factions_GUIMarineBuyMenu.kSmallIconTexture)
						 // set the pixel coordinate for the icon
						graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))

						local graphicItemActive = GUIManager:CreateGraphicItem()
						graphicItemActive:SetSize(Factions_GUIMarineBuyMenu.kSelectorSize)          
						graphicItemActive:SetPosition(Vector(selectorPosX, -Factions_GUIMarineBuyMenu.kSelectorSize.y / 2, 0))
						graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
						graphicItemActive:SetTexture(Factions_GUIMarineBuyMenu.kMenuSelectionTexture)
						graphicItemActive:SetIsVisible(false)
						
						graphicItem:AddChild(graphicItemActive)
						
						local costIcon = GUIManager:CreateGraphicItem()
						costIcon:SetSize(Vector(Factions_GUIMarineBuyMenu.kResourceIconWidth * 0.8, Factions_GUIMarineBuyMenu.kResourceIconHeight * 0.8, 0))
						costIcon:SetAnchor(GUIItem.Left, GUIItem.Bottom)
						costIcon:SetPosition(Vector(5, -Factions_GUIMarineBuyMenu.kResourceIconHeight, 0))
						costIcon:SetTexture(Factions_GUIMarineBuyMenu.kResourceIconTexture)
						costIcon:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
						
						local selectedArrow = GUIManager:CreateGraphicItem()
						selectedArrow:SetSize(Vector(Factions_GUIMarineBuyMenu.kArrowWidth, Factions_GUIMarineBuyMenu.kArrowHeight, 0))
						selectedArrow:SetAnchor(GUIItem.Left, GUIItem.Center)
						selectedArrow:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kArrowWidth - Factions_GUIMarineBuyMenu.kPadding, -Factions_GUIMarineBuyMenu.kArrowHeight * 0.5, 0))
						selectedArrow:SetTexture(Factions_GUIMarineBuyMenu.kArrowTexture)
						selectedArrow:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
						selectedArrow:SetTextureCoordinates(unpack(Factions_GUIMarineBuyMenu.kArrowTexCoords))
						selectedArrow:SetIsVisible(false)
						
						graphicItem:AddChild(selectedArrow) 
						
						local itemCost = GUIManager:CreateTextItem()
						itemCost:SetFontName(Factions_GUIMarineBuyMenu.kFont)
						itemCost:SetFontIsBold(true)
						itemCost:SetAnchor(GUIItem.Right, GUIItem.Center)
						itemCost:SetPosition(Vector(0, 0, 0))
						itemCost:SetTextAlignmentX(GUIItem.Align_Min)
						itemCost:SetTextAlignmentY(GUIItem.Align_Center)
						itemCost:SetScale(fontScaleVector)
						itemCost:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
						itemCost:SetText(ToString(upgrade:GetCostForNextLevel()))
						
				
						local level = GUIManager:CreateTextItem()
						level:SetFontName(Factions_GUIMarineBuyMenu.kFont)
						level:SetFontIsBold(true)
						level:SetAnchor(GUIItem.Left, GUIItem.Top)
						level:SetPosition(Vector(Factions_GUIMarineBuyMenu.kSmallIconSize.x - Factions_GUIMarineBuyMenu.kLevelOffsetX, Factions_GUIMarineBuyMenu.kLevelOffsetY, 0))
						level:SetTextAlignmentX(GUIItem.Align_Max)
						level:SetTextAlignmentY(GUIItem.Align_Center)
						level:SetScale(fontScaleVector)
						level:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
						level:SetText(GetLevelText(upgrade))
						graphicItem:AddChild(level)
						
						costIcon:AddChild(itemCost)  
						
						graphicItem:AddChild(costIcon)   
						
						self.menu:AddChild(graphicItem)
						table.insert(self.itemButtons, { Button = graphicItem, Highlight = graphicItemActive, TechId = itemTechId, Cost = itemCost, ResourceIcon = costIcon, Arrow = selectedArrow, Level = level, Upgrade = upgrade} )
						  
						itemNr = itemNr +1
					end
				end
			end
		end
		
	end
    
    // to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

Factions_GUIMarineBuyMenu.kEquippedMouseoverColor = Color(1,1,1,1)
Factions_GUIMarineBuyMenu.kEquippedColor = Color(0.5, 0.5, 0.5, 0.5)

function Factions_GUIMarineBuyMenu:_UpdateEquipped(deltaTime)

    self.hoverItem = nil
    for i, equipped in ipairs(self.equipped) do
    
        if self:_GetIsMouseOver(equipped.Graphic) then
            self.hoverItem = equipped.TechId
            equipped.Graphic:SetColor(Factions_GUIMarineBuyMenu.kEquippedMouseoverColor)
        else
            equipped.Graphic:SetColor(Factions_GUIMarineBuyMenu.kEquippedColor)
        end    
    
    end
    
end

local gResearchToWeaponIds = nil
local function GetItemTechId(researchTechId)

    if not gResearchToWeaponIds then
    
        gResearchToWeaponIds = {}
        gResearchToWeaponIds[kTechId.ShotgunTech] = kTechId.Shotgun
        gResearchToWeaponIds[kTechId.GrenadeLauncherTech] = kTechId.GrenadeLauncher
        gResearchToWeaponIds[kTechId.WelderTech] = kTechId.Welder
        gResearchToWeaponIds[kTechId.MinesTech] = kTechId.LayMines
        gResearchToWeaponIds[kTechId.FlamethrowerTech] = kTechId.Flamethrower
        gResearchToWeaponIds[kTechId.JetpackTech] = kTechId.Jetpack
        gResearchToWeaponIds[kTechId.ExosuitTech] = kTechId.Exosuit
    
    end
    
    return gResearchToWeaponIds[researchTechId]

end

function Factions_GUIMarineBuyMenu:_UpdateItemButtons(deltaTime)

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

function Factions_GUIMarineBuyMenu:_UninitializeItemButtons()

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
    //self.itemDescription:SetFontIsBold(true)
    self.itemDescription:SetFontSize(Factions_GUIMarineBuyMenu.kDescriptionFontSize)
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

function Factions_GUIMarineBuyMenu:_InitializeResourceDisplay()
    
    self.resourceDisplayBackground = GUIManager:CreateGraphicItem()
    self.resourceDisplayBackground:SetSize(Vector(Factions_GUIMarineBuyMenu.kBackgroundWidth, Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.resourceDisplayBackground:SetPosition(Vector(0, -Factions_GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.resourceDisplayBackground:SetTexture(Factions_GUIMarineBuyMenu.kContentBgBackTexture)
    self.resourceDisplayBackground:SetTexturePixelCoordinates(0, 0, Factions_GUIMarineBuyMenu.kBackgroundWidth, Factions_GUIMarineBuyMenu.kResourceDisplayHeight)
    self.content:AddChild(self.resourceDisplayBackground)
    
    self.resourceDisplayIcon = GUIManager:CreateGraphicItem()
    self.resourceDisplayIcon:SetSize(Vector(Factions_GUIMarineBuyMenu.kResourceIconWidth, Factions_GUIMarineBuyMenu.kResourceIconHeight, 0))
    self.resourceDisplayIcon:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.resourceDisplayIcon:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kResourceIconWidth * 2.2, -Factions_GUIMarineBuyMenu.kResourceIconHeight / 2, 0))
    self.resourceDisplayIcon:SetTexture(Factions_GUIMarineBuyMenu.kResourceIconTexture)
    self.resourceDisplayIcon:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    self.resourceDisplayBackground:AddChild(self.resourceDisplayIcon)

    self.resourceDisplay = GUIManager:CreateTextItem()
    self.resourceDisplay:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.resourceDisplay:SetFontIsBold(true)
    self.resourceDisplay:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.resourceDisplay:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kResourceIconWidth , 0, 0))
    self.resourceDisplay:SetTextAlignmentX(GUIItem.Align_Min)
    self.resourceDisplay:SetTextAlignmentY(GUIItem.Align_Center)
    
    self.resourceDisplay:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    //self.resourceDisplay:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    
    self.resourceDisplay:SetText("")
    self.resourceDisplayBackground:AddChild(self.resourceDisplay)
    
    self.currentDescription = GUIManager:CreateTextItem()
    self.currentDescription:SetFontName(Factions_GUIMarineBuyMenu.kFont)
    self.currentDescription:SetFontIsBold(true)
    self.currentDescription:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.currentDescription:SetPosition(Vector(-Factions_GUIMarineBuyMenu.kResourceIconWidth * 3 , Factions_GUIMarineBuyMenu.kResourceIconHeight, 0))
    self.currentDescription:SetTextAlignmentX(GUIItem.Align_Max)
    self.currentDescription:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentDescription:SetColor(Factions_GUIMarineBuyMenu.kTextColor)
    self.currentDescription:SetText(Combat_ResolveString("CURRENT"))
    
    self.resourceDisplayBackground:AddChild(self.currentDescription) 

end

function Factions_GUIMarineBuyMenu:_UpdateResourceDisplay(deltaTime)

    self.resourceDisplay:SetText(ToString(PlayerUI_GetPlayerResources()))
    
end

function Factions_GUIMarineBuyMenu:_UninitializeResourceDisplay()

    GUI.DestroyItem(self.resourceDisplay)
    self.resourceDisplay = nil
    
    GUI.DestroyItem(self.resourceDisplayIcon)
    self.resourceDisplayIcon = nil
    
    GUI.DestroyItem(self.resourceDisplayBackground)
    self.resourceDisplayBackground = nil
    
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