
BINDING_NAME_CONSOLE = 'Reload UI'
BINDING_HEADER_CONSOLE = 'Console'

-- It's your fault cogwheel!
SlashCmdList.SCRIPT = RunScript
SlashCmdList.DUMP = function(...)
	UIParentLoadAddOn('Blizzard_DebugTools')
	DevTools_DumpCommand(...)
end

--[[ ErrorHandler ]]
local BUGS, SEEN = {}, {}
local FORMAT = '|cffff8080Error:|r\n%s\n\n|cffff8080Stack:|r\n%s\n|cffff8080Locals:|r\n%s'

seterrorhandler(function(error)
	if(not SEEN[error]) then
		table.insert(BUGS, string.format(FORMAT, error, debugstack(4), debuglocals(4)))

		print('|cffff8080Console:|r |cff00ff00['..#BUGS..']|r', error)
		SEEN[error] = true
	end
end)

SLASH_Console1 = '/bugs'
SlashCmdList.Console = function(str)
	local box = _G['ConsoleScrollBox']
	if(BUGS[tonumber(str)]) then
		box:SetText(BUGS[tonumber(str)])
	elseif(#BUGS ~= 0) then
		box:SetText(BUGS[#BUGS])
	else
		print('|cffff8080Console:|r Na na na na na na BATMAN!')
	end
end

--[[ Dump ]]
local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', function(self, event, name)
	if(name == 'Blizzard_DebugTools') then
		local function Override_Write(self, msg)
			self.buffer = self.buffer .. msg .. '\n'
			_G.ConsoleScrollBox:SetText(self.buffer)
		end

		local orig = DevTools_RunDump
		function DevTools_RunDump(value, context)
			context.buffer = ''
			context.Write = Override_Write

			orig(value, context)
		end
	end
end)
