local BUGS, SEEN = {}, {}
local FORMAT = '|cffff8080Error:|r\n%s\n\n|cffff8080Stack:|r\n%s\n|cffff8080Locals:|r\n%s'

BINDING_NAME_CONSOLE = 'Reload UI'
BINDING_HEADER_CONSOLE = 'Console'

seterrorhandler(function(error)
	if(not SEEN[error]) then
		table.insert(BUGS, string.format(FORMAT, error, debugstack(4), debuglocals(4)))

		print('|cffff8080Console:|r |cff00ff00['..#BUGS..']|r', error)
		SEEN[error] = true
	end
end)

SLASH_Console1 = '/bugs'
SlashCmdList.Console = function(str)
	if(BUGS[tonumber(str)]) then
		_G['ConsoleScrollBox']:SetText(BUGS[tonumber(str)])
	elseif(#BUGS ~= 0) then
		_G['ConsoleScrollBox']:SetText(BUGS[#BUGS])
	else
		print('|cffff8080Console:|r Na na na na na na BATMAN!')
	end
end
