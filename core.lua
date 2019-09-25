AzeriteTraitTooltips = LibStub("AceAddon-3.0"):NewAddon("AzeriteTraitTooltips")

-----------------
-- Addon Setup --
-----------------c
local _M = {}
local _DB = {}
AzeriteTraitTooltipsFunction = _M
AzeriteTraitTooltipsDB = _DB

local AzeriteTraitTooltips_Version = GetAddOnMetadata("AzeriteTraitTooltips", "Version")
_DB.powerTable = {}

_M.AlreadyAdded = function(str1, tooltip)
	if str1 == nil then
		return false
	end

	for i = 1,15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local textRight = _G[tooltip:GetName().."TextRight"..i]
		local text
		local right
		if frame then text = frame:GetText() end
		if text and string.find(text, str1, 1, true) then return true end
		if textRight then right = textRight:GetText() end
		if right and string.find(right, str1, 1, true) then return true end
	  end
end

_M.ColorString = function(str, hex, alpha)
    if(str and hex) then
        if(alpha == nil) then
            alpha = 'FF'
        end
        return '|c' .. alpha .. hex .. str .. '|r'
    else
        return str
    end
end

_M.SpellTooltip = function(spellID, tooltip)
    powerID = _M.GetAzeritePowerID(spellID)
    if(powerID) then
        str = _M.ColorString("Azerite powerID ", 'EE6161') .. powerID
        if(not _M.AlreadyAdded(str, tooltip)) then
            tooltip:AddLine(str)
        end
    end
end

_M.GetAzeritePowerID = function(spellID)
    if(_DB.powerTable and _DB.powerTable[spellID]) then
        return _DB.powerTable[spellID]
    end
end

_M.OnTooltipSpell = function(self, tooltip)
	-- Case for linked spell
	local name,spellID = self:GetSpell()
	if spellID ~= nil then
		_M.SpellTooltip(spellID, tooltip)
	end
	tooltip:Show()
end

_M.RefreshPowerTable = function()
    local powerInfo = {}
    local powerID
    for powerID = 1, 1000 do
        powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
        if powerInfo and powerInfo.spellID then
            _DB.powerTable[powerInfo.spellID] = powerID
        end
    end
end

function AzeriteTraitTooltips:OnEnable()
	GameTooltip:HookScript("OnTooltipSetSpell", function(...) _M.OnTooltipSpell(..., GameTooltip) end)
	ItemRefTooltip:HookScript("OnTooltipSetSpell", function(...) _M.OnTooltipSpell(..., ItemRefTooltip) end)
    _M.RefreshPowerTable()
end
