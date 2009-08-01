local bugs, recorded = {}, {}

seterrorhandler(function(error)
	if(not recorded[error]) then
		table.insert(bugs, error)
		print('|cffff8080Console:|r |cff00ff00['..#bugs..']|r', error)

		recorded[error] = true
	end
end)

local function pop(text)
	local dialog = StaticPopup_Show('Console')
	dialog.editBox:SetText(text)
	dialog.editBox:SetFocus()
	dialog.editBox:HighlightText()
end

SLASH_ReloadUI1 = '/rl'
SlashCmdList.ReloadUI = ReloadUI

SLASH_Console1 = '/bugs'
SlashCmdList.Console = function(str)
	if(bugs[tonumber(str)]) then
		pop(bugs[tonumber(str)])
	elseif(#bugs ~= 0) then
		pop(bugs[#bugs])
	else
		print('|cffff8080Console:|r Yatta, no errors!')
	end
end

StaticPopupDialogs.Console= {
	text = 'Press CTRL + C to copy the error below',
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	hasEditBox = 1,
	timeout = 0
}
