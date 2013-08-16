//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FactionsClassMixin.lua

Script.Load("lua/FunctionContracts.lua")

if kFactionsClassType == nil then
	kFactionsClassType = enum({'NoneSelected'})
	kAllFactionsClasses = {}
	kFactionsClassStrings = {}
	kFactionsClassStrings[kFactionsClassType.NoneSelected] = "None Selected"
end

// load the Factions Class base classes
Script.Load("lua/Factions/Factions_FactionsClass.lua")
Script.Load("lua/Factions/Factions_UpgradeList.lua")

local function RegisterNewClass(classType, className, classEntity)
	
	// We have to reconstruct the kFactionsClassType enum to add values.
	local enumTable = {}
	for index, value in ipairs(kFactionsClassType) do
		table.insert(enumTable, value)
	end
	
	table.insert(enumTable, classType)
	
	kFactionsClassType = enum(enumTable)
	kFactionsClassStrings[kFactionsClassType[classType]] = className
	kAllFactionsClasses[kFactionsClassType[classType]] = classEntity
	
end

// build the FactionsClass list
local function BuildAllFactionsClasses()

    if #kAllFactionsClasses == 0 then
        // load all FactionsClass files
        local factionsClassFiles = { }
        local factionsClassDirectory = "lua/Factions/Classes/"
        Shared.GetMatchingFileNames( factionsClassDirectory .. "*.lua", false, factionsClassFiles)

        for _, factionsClassFile in pairs(factionsClassFiles) do
            Script.Load(factionsClassFile)      
        end
		
		// Build the enums for the Type field and save all FactionsClasses in a table
		for index, classType in ipairs(Script.GetDerivedClasses("FactionsClass")) do
			RegisterNewClass(classType, _G[classType].name, _G[classType])
		end
    end
    
end

if #kAllFactionsClasses == 0 then
    BuildAllFactionsClasses()
end

FactionsClassMixin = CreateMixin( FactionsClassMixin )
FactionsClassMixin.type = "FactionsClass"

FactionsClassMixin.expectedMixins =
{
}

FactionsClassMixin.expectedCallbacks =
{
}

FactionsClassMixin.expectedConstants =
{
}

// These should completely override any existing function defined in the class.
FactionsClassMixin.overrideFunctions =
{
	"GetMaxBackwardSpeedScalar",
}

FactionsClassMixin.networkVars =
{
	factionsClassType = "enum kFactionsClassType"
}

// Conversion functions for ease of output/input
local function FactionsClassToString(enumValue)
	return kFactionsClassStrings[enumValue]
end

local function StringToFactionsClass(stringValue)
	for enumValue, className in pairs(kFactionsClassStrings) do
		if className:upper() == stringValue:upper() then
			return enumValue
		end
	end
	
	return nil
end

// Maintain a local type variable so that the calculations are sane until ChangeFactionsClass is triggered.
function FactionsClassMixin:__initmixin()

    self.factionsClassType = kFactionsClassType.NoneSelected
	self.factionsClassLocalType = kFactionsClassType.NoneSelected

end

function FactionsClassMixin:GiveStartingUpgrades()

	// TODO: Reenable when this is fixed.
	if self.GetHasFactionsClass and self:GetHasFactionsClass() and self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
		for index, upgradeClassName in ipairs(self.factionsClass:GetInitialUpgrades()) do
			local upgrade = self:GetUpgradeByClassName(upgradeClassName)
			if upgrade then
				self:BuyUpgrade(upgrade:GetId(), true)
			else
				Shared.Message("Could not find initial upgrade " .. upgradeClassName .. " for player " .. self:GetName())
			end
		end
	end
	
end

function FactionsClassMixin:CopyPlayerDataFrom(player)

	if player.factionsClassType then		
		self.factionsClassType = player.factionsClassType
		self.factionsClassLocalType = player.factionsClassLocalType
		self.factionsClass = self:GetClassByType(player.factionsClassType)
		self.factionsClassInitialised = true
	end
	
	// At this point we have enough info to give the player their starting equipment
	if Server and self.factionsClassInitialised and self.factionsUpgradesInitialised then
		self:GiveStartingUpgrades()
    end

end

function FactionsClassMixin:GetFactionsClass()

	return self.factionsClass

end

function FactionsClassMixin:GetFactionsClassType()

	return self.factionsClassLocalType

end

function FactionsClassMixin:GetFactionsClassString()

	return FactionsClassToString(self:GetFactionsClassType())

end

function FactionsClassMixin:GetHasFactionsClass()

	local hasClass = true
	if self:GetFactionsClassType() == kFactionsClassType.NoneSelected then
		hasClass = false
	end
	
	return hasClass
	
end

function FactionsClassMixin:ChangeFactionsClassFromString(newClassString)

	local newClass = StringToFactionsClass(newClassString)
	local success = false
	if newClass then
		self:ChangeFactionsClass(newClass)
		success = true
	end
	
	return success

end

function FactionsClassMixin:GetAllClasses()
    return kAllFactionsClasses
end

function FactionsClassMixin:GetClassByType(classType)
    if classType then
        local allClasses = self:GetAllClasses()
        if allClasses[classType] then
			local gotClass = allClasses[classType]()
			gotClass:Initialize()
            return gotClass
        end
    end
end

function FactionsClassMixin:OnUpdatePlayer()
	if self.factionsClassType ~= self.factionsClassLocalType then
		self:ChangeFactionsClass(self.factionsClassType)
	end
	
    if Client then	
        // open the menu
        if GetGamerulesInfo():GetIsClassBased() and self.factionsClassType == kFactionsClassType.NoneSelected and self.factionsClassLocalType == kFactionsClassType.NoneSelected and not self.classSelectMenuClosed then
            self:OpenClassSelectMenu()
        end
    end
	
end

function FactionsClassMixin:ChangeFactionsClass(newClass)

	if GetGamerulesInfo():GetIsClassBased() then
		if self.factionsClassLocalType ~= newClass then
			self.factionsClassType = newClass
			self.factionsClassLocalType = newClass
			self.factionsClass = self:GetClassByType(newClass)
			
			if Server then
				// Kill the player if they do this while playing.
				if self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
					self:Kill(nil, nil, self:GetOrigin(), nil, true)
				end
			end
		end
	else
		self:SendDirectMessage("You cannot change class in this gamemode!")
	end

end

function FactionsClassMixin:GetBaseMaxSprintSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseSprintSpeed()
	else
		return _G[self:GetClassName()].kRunMaxSpeed
	end

end

function FactionsClassMixin:GetBaseMaxSpeed()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseSpeed()
	else
		return _G[self:GetClassName()].kWalkMaxSpeed
	end

end

function FactionsClassMixin:GetBaseHealth()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseHealth()
	else
		return self:GetOriginalMaxHealth()
	end

end

function FactionsClassMixin:GetBaseArmor()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseArmor()
	else
		return self:GetOriginalMaxArmor()
	end

end

function FactionsClassMixin:GetBaseHealth()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseHealth()
	else
		return self:GetOriginalMaxHealth()
	end

end

function FactionsClassMixin:GetBaseDropCount()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetBaseDropCount()
	else
		return 3
	end

end

function FactionsClassMixin:GetMaxBackwardSpeedScalar()

	if self:GetHasFactionsClass() then
		return self.factionsClass:GetMaxBackwardSpeedScalar()
	else
		if _G[self:GetClassName()].GetMaxBackwardSpeedScalar then
			return _G[self:GetClassName()].GetMaxBackwardSpeedScalar(self)
		else
			return Player.kWalkBackwardSpeedScalar
		end
	end

end

if Client then
    function FactionsClassMixin:OpenClassSelectMenu()
        
        // Don't allow display in the ready room
        if Client.GetLocalPlayer() == self and self:GetTeamNumber() ~= 0 and not self:isa("ReadyRoomPlayer") then   
            if not g_classSelectMenu then                            
                g_classSelectMenu = GetGUIManager():CreateGUIScript("Factions/Hud/Factions_GUIClassSelectMenu")
                MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
            end            
        end
        
    end

    function FactionsClassMixin:CloseClassSelectMenu()   
     
        if g_classSelectMenu then
            GetGUIManager():DestroyGUIScript(g_classSelectMenu)
            g_classSelectMenu = nil
            MouseTracker_SetIsVisible(false)
            // Quick work-around to not fire weapon when closing menu.
            self.timeClosedMenu = Shared.GetTime()
            self.classSelectMenuClosed = true
        end   
        
    end    
end
