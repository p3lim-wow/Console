do
	local frame = CreateFrame('Frame', 'Console', UIParent)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:CreateTitleRegion():SetAllPoints()

	frame:SetPoint('CENTER')
	frame:SetSize(300, 500)
	frame:Hide()

	frame:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1})
	frame:SetBackdropColor(0, 0, 0, 0.5)
	frame:SetBackdropBorderColor(1, 1, 1, 0.5)

	local scroll = CreateFrame('ScrollFrame', 'ConsoleScroll', frame)
	scroll:SetPoint('TOPLEFT', 12, -12)
	scroll:SetPoint('BOTTOMRIGHT', -12, 12)

	local editbox = CreateFrame('EditBox', 'ConsoleBox', scroll)
	editbox:SetPoint('TOP')
	editbox:SetSize(276, 400)
	editbox:SetMultiLine(true)
	editbox:SetAutoFocus(true)
	editbox:SetFontObject(GameFontHighlightSmall)

	editbox:SetScript('OnTextSet', function() frame:Show() end)
	editbox:SetScript('OnEscapePressed', function(self)
		self:SetText('')
		frame:Hide()
	end)

	scroll:SetScrollChild(editbox)
	scroll:EnableMouseWheel(true)
	scroll:SetScript('OnMouseWheel', function(self, delta)
		local scroll = self:GetVerticalScroll()
		if(delta > 0) then
			self:SetVerticalScroll(math.max(0, scroll - 20))
		else
			self:SetVerticalScroll(math.min(self:GetVerticalScrollRange(), scroll + 20))
		end
	end)
end

do
	local addon = CreateFrame('Frame')
	addon:RegisterEvent('ADDON_LOADED')
	addon:SetScript('OnEvent', function(self, event, name)
		if(name == 'Blizzard_DebugTools') then
			local function Override_Write(self, msg)
				self.buffer = self.buffer .. msg .. '\n'
				_G['ConsoleBox']:SetText(self.buffer)
			end

			local orig = DevTools_RunDump
			function DevTools_RunDump(value, context)
				context.buffer = ''
				context.Write = Override_Write

				orig(value, context)
			end
		end
	end)
end

do
	local BUGS, SEEN = {}, {}
	local FORMAT = '|cffff8080Error:|r\n%s\n\n|cffff8080Stack:|r\n%s\n|cffff8080Locals:|r\n%s'

	seterrorhandler(function(error)
		if(not SEEN[error]) then
			-- XXX: Get a proper depth value. DevTools is using 4 as a default value, so I'll use that for now
			table.insert(BUGS, string.format(FORMAT, error, debugstack(DEBUGLOCALS_LEVEL), debuglocals(DEBUGLOCALS_LEVEL)))

			print('|cffff8080Console:|r |cff00ff00['..#BUGS..']|r', error)
			SEEN[error] = true
		end
	end)

	SLASH_Console1 = '/bugs'
	SlashCmdList.Console = function(str)
		local box = _G['ConsoleBox']
		if(BUGS[tonumber(str)]) then
			box:SetText(BUGS[tonumber(str)])
		elseif(#BUGS ~= 0) then
			box:SetText(BUGS[#BUGS])
		else
			print('|cffff8080Console:|r Na na na na na na BATMAN!')
		end
	end
end
