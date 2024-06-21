local AddonName = ...

SLASH_GRM1 = '/grm'
SLASH_GRM2 = '/guildrecruitermax'

local MAX_CHARS = 483
local MAX_LEVEL = 70

local also_invite = false

SlashCmdList['GRM'] = function(msg)
	local f = CreateFrame('Frame', nil, UIParent, 'BasicFrameTemplateWithInset')
  f:SetSize(300, 300)
  f:SetPoint('CENTER')
  f:SetMovable(true)
  f:EnableMouse(true)
  f:SetFrameStrata('HIGH')
  f:RegisterForDrag('LeftButton')
  f:SetScript('OnDragStart', f.StartMoving)
  f:SetScript('OnDragStop', f.StopMovingOrSizing)
 
  local t = f:CreateFontString(nil, 'OVERLAY')
  t:SetFontObject('GameFontHighlight')
  t:SetPoint('LEFT', f.TitleBg, 5, 0)
  t:SetText(AddonName)

	local inf = CreateFrame('Frame', nil, f)
	inf:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, -10)
	inf:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -3, 60)

	local tl = inf:CreateFontString(nil, 'OVERLAY')
	tl:SetFontObject('GameFontHighlight')
  tl:SetPoint('TOPLEFT', f.TitleBg, 8, -29)
  tl:SetText('Invite message:')
 
  local eb = CreateFrame('EditBox', nil, inf, 'InputBoxTemplate')
  eb:SetPoint('TOPLEFT', inf, 'TOPLEFT', 8, -30)
	eb:SetMultiLine(false)
	eb:SetHeight(40)
	eb:SetWidth(265)
	if not LastUsedText then
		eb:SetText('<guild recruitment message>')
	else
		eb:SetText(LastUsedText)
	end
  eb:SetAutoFocus(true)
	eb:SetMaxLetters(MAX_CHARS)

	local check = CreateFrame("CheckButton", 'checkName', inf, "UICheckButtonTemplate")
	check:SetPoint('CENTER', inf, 'CENTER', -30, 0)
	check:SetScript('OnClick', function (this)
		also_invite = not also_invite
	end)
	getglobal(check:GetName() .. 'Text'):SetText("Invite to guild")

	local count = f:CreateFontString(nil, 'OVERLAY')
	count:SetFontObject('GameFontHighlight')
	count:SetPoint('BOTTOMLEFT', f, 8, 8)
	count:SetText('0/' .. MAX_CHARS)
	eb:SetScript('OnTextChanged', function(self)
		count:SetText(string.len(eb:GetText()) .. '/' .. MAX_CHARS)
		LastUsedText = eb:GetText()
	end)
 
  local ib = CreateFrame('Button', nil, f, 'GameMenuButtonTemplate')
  ib:SetPoint('CENTER', f, 'BOTTOM', 0, 40)
  ib:SetSize(120, 30)
  ib:SetText('Invite')
  ib:SetNormalFontObject('GameFontNormal')
  ib:SetHighlightFontObject('GameFontHighlight')

	ib:SetScript('OnClick', function(self)
		C_FriendList.SendWho('1-' .. MAX_LEVEL)
		local n = C_FriendList.GetNumWhoResults()
		local i = 1
		while( i < n + 1 ) do
			c, g = C_FriendList.GetWhoInfo(i)
			if (g == '') then
				SendChatMessage('Hi ' .. c .. ', ' .. eb:GetText(), 'WHISPER', 'COMMON', c)
				if also_invite then
					GuildInvite(c)
				end
			end
			i = i + 1
		end
	end)
  
	f:Show()
end