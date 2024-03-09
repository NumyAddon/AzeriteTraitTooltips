local name = ...
AzeriteTraitTooltips = {}

-----------------
-- Addon Setup --
-----------------
local _M = {_DB = {powerTable = {}}}
local _DB = _M._DB
AzeriteTraitTooltip = _M

_M.OnTooltipSpell = function(tooltip)
	if not tooltip.GetSpell then return end

	local _, spellID = tooltip:GetSpell()
	if not spellID then return end

    local powerID = _DB.powerTable and _DB.powerTable[spellID]
    if not powerID then return end

    tooltip:AddLine("|cFFEE6161Azerite powerID|r " .. powerID)
    tooltip:Show()
end

_M.RefreshPowerTable = function()
    local powerInfo = {}
    for powerID = 1, 1000 do
        powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
        if powerInfo and powerInfo.spellID then
            _DB.powerTable[powerInfo.spellID] = powerID
        end
    end
end

EventUtil.ContinueOnAddOnLoaded(name, function()
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, _M.OnTooltipSpell)
    _M.RefreshPowerTable()
end)
