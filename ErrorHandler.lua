local BUGS, SEEN = {}, {}
local FORMAT = 'Error:\n%s\n\nStack:\n%s\n\nLocals:\n%s'

seterrorhandler(function(error)
	if(not SEEN[error]) then
		table.insert(BUGS, string.format(FORMAT, error, debugstack(4), debuglocals(4)))

		print('|cffff8080Console:|r |cff00ff00['..#BUGS..']|r', error)
		SEEN[error] = true
	end
end)

local function Popup(text)
	local dialog = StaticPopup_Show('Console')
	if(dialog) then
		dialog.editBox:SetText(text)
		dialog.editBox:SetFocus()
		dialog.editBox:HighlightText()
	end
end

SLASH_ReloadUI1 = '/rl'
SlashCmdList.ReloadUI = ReloadUI

SLASH_Console1 = '/bugs'
SlashCmdList.Console = function(str)
	if(BUGS[tonumber(str)]) then
		Popup(BUGS[tonumber(str)])
	elseif(#BUGS ~= 0) then
		Popup(BUGS[#BUGS])
	else
		print('|cffff8080Console:|r Na na na na na na BATMAN!')
	end
end

StaticPopupDialogs.Console = {
	text = 'Copy to Clipboard',
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	hasEditBox = 1,
	whileDead = 1,
	timeout = 0
}
