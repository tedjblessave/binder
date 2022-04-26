local encoding = require 'encoding'
local lanes = require('lanes').configure()
local sp  = require 'lib.samp.events'
local se = require "samp.events"
local weapons = require 'game.weapons'
local mem = require "memory" 
local memory = require 'memory'
local as_action = require('moonloader').audiostream_state
local inicfg = require 'inicfg'
local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local effil = require("effil")
local vkeys = require 'vkeys'
local dlstatus = require('moonloader').download_status
local wm = require 'lib.windows.message'
local rkeys = require 'rkeys'

encoding.default = 'CP1251'
u8 = encoding.UTF8
local poss = false 
local captureon = false
local anticheat = false

local fixbike = false
local dotmoney = true
local Arial = renderCreateFont("Tahoma", 17, 0x4)
local ArialKo = renderCreateFont("Tahoma", 11, 0x4)
local activeextra = false 

update_state = false 
 
local script_vers = 51
local script_vers_text = "26.04.2022"


local reweextra = true


--[[ local rewedhits = true
local reweautoc = true
local rewesl = true
local bott = true
local trott = true ]]

local rewedhits = false
local reweautoc = false
local rewesl = false
local bott = false
local trott = false


local update_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/update.ini" -- ��� ���� ���� ������
local update_path = getWorkingDirectory() .. "\\config\\update.ini" -- � ��� ���� ������

local script_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/bind_menu.lua" -- ��� ���� ������
local script_path = thisScript().path


textures = {
	['cs_rockdetail2'] = 1,  -- ������
	['ab_flakeywall'] = 2,   -- ������
	['metalic128'] = 3,      -- �������
	['Strip_Gold'] = 4,	     -- ������
	['gold128'] = 5          -- ������
}

resNames = {{'������', 0xFFFFFFFF}, {'������', 0xFF808080}, {'�������', 0xFF00BFFF}, {'������', 0xFF654321}, {'������', 0xFFFFFF00}}

resources = {}


local fontALT = renderCreateFont("Tahoma", 14, 0x4)

local fontVR = renderCreateFont("Arial", 10, 9)

local statesl = false
local debugMode = false

local health = 0xBAB22C

local settings = {
	max_distance = 65,
	field_of_search = 1, 
	show_circle = false,
	key_activation = 57,
	miss_ratio = 15,
    through_walls = false
}


renderlist = [[
    {8B4513}˸�: {33EA0D}���������: {7B68EE}/len
    {008000}������: {33EA0D}���������: {7B68EE}/hlop
    {00FFFF}�������: {33EA0D}���������: {7B68EE}/waxta
    {EE82EE}��������: {33EA0D}���������: {7B68EE}/gn
    {d3940d}�������: {33EA0D}���������: {7B68EE}/pr
    {20B2AA}������ �����: {33EA0D}���������: {7B68EE}/semena
    {110dd3}������: {33EA0D}���������: {7B68EE}/ms
    {BC8F8F}�����: {33EA0D}���������: {7B68EE}/olenina
    {f3ab12}�������� �������: {33EA0D}���������: {7B68EE}/trees
    {7faa09}�����: {33EA0D}���������: {7B68EE}/grib
    {d166be}���� ����: {33EA0D}���������: {7B68EE}/laa
    {808080}����� ������ � ���� ������: {33EA0D}���������: {7B68EE}/mnk (id)
    {ff1493}�������� ����: {33EA0D}���������: {7B68EE}/graf {ffffff}| ������� ������ '{ff1493}77{ffffff}' ��� ���-���
    {00FF00}������� {87CEEB}������ ���������� ���������� �� �������.
    {9932CC}��������� {87CEEB}����� �� �������.
    {ffffff}����� {87CEEB}���������� �������� � ���� ������.
]]

buttonslist = [[
            LBUTTON (1) - ����� ������ ����
	RBUTTON (2) - ������ ������ ����
	MBUTTON (3) - ������ ���� (�������)
	XBUTTON1 (5) - ���.������ ���� �1
	XBUTTON2 (6) - ���.������ ���� �2

	BACK (8) - 'Backspace'
	TAB (9) - 'Tab'
	RETURN (13) - 'Enter'

	CAPITAL (20) - 'Caps Lock'
	ESCAPE (27) - 'Esc'
	SPACE (32) - 'Space'
	PRIOR (33) - 'Page Up'
	NEXT (34) - 'Page Down'
	END (35) - 'End'
	HOME (36) - 'Home'

	LEFT (37) - 'Arrow Left'
	UP (38) - 'Arrow Up'
	RIGHT (39) - 'Arrow Right'
	DOWN (40) - 'Arrow Down'

	PRINT - 'Print'
	INSERT (45) - 'Insert'
	DELETE (46) - 'Delete'


	0 (58) - '0'
	1 (49) - '1'
	2 (50) - '2'
	3 (51) - '3'
	4 (52) - '4'
	5 (53) - '5'
	6 (54) - '6'
	7 (55) - '7'
	8 (56) - '8'
	9 (57) - '9'


	A (65) - 'A'
	B (66) - 'B'
	C (67) - 'C'
	D (68) - 'D'
	E - 'E'
	F - 'F'
	G - 'G'
	H - 'H'
	I - 'I'
	J - 'J'
	K (75) - 'K'
	L - 'L'
	M - 'M'
	N - 'N'
	O - 'O'
	P - 'P'
	Q - 'Q'
	R (82) - 'R'
	S - 'S'
	T - 'T'
	U - 'U'
	V - 'V'
	W - 'W'
	X - 'X'
	Y - 'Y'
	Z (90) - 'Z'


	NUMPAD0 - 'Numpad 0'
	NUMPAD1 - 'Numpad 1'
	NUMPAD2 - 'Numpad 2'
	NUMPAD3 - 'Numpad 3'
	NUMPAD4 - 'Numpad 4'
	NUMPAD5 - 'Numpad 5'
	NUMPAD6 - 'Numpad 6'
	NUMPAD7 - 'Numpad 7'
	NUMPAD8 - 'Numpad 8'
	NUMPAD9 - 'Numpad 9'
	MULTIPLY - 'Numpad *'
	ADD - 'Numpad +'
	SEPARATOR - 'Separator'
	SUBTRACT - 'Num -'
	DECIMAL - 'Numpad .'
	DIVIDE - 'Numpad /'


	F1 - 'F1'
	F2 - 'F2'
	F3 - 'F3'
	F4 - 'F4'
	F5 - 'F5'
	F6 - 'F6'
	F7 - 'F7'
	F8 - 'F8'
	F9 - 'F9'
	F10 - 'F10'
	F11 - 'F11'
	F12 - 'F12'
	F13 - 'F13'
	F14 - 'F14'
	F15 - 'F15'
	F16 - 'F16'
	F17 - 'F17'
	F18 - 'F18'
	F19 - 'F19'
	F20 - 'F20'
	F21 - 'F21'
	F22 - 'F22'
	F23 - 'F23'
	F24 - 'F24'

	LSHIFT - ����� ����
	RSHIFT - ������ ����
	LCONTROL - ����� ������
	RCONTROL - ������ ������
	LMENU - ����� ����
	RMENU - ������ ����
]]

local file = getWorkingDirectory() .. "\\config\\binds.bind"
local tEditData = {
   id = -1,
   inputActive = false 
}

local chat = {''}
local lastmsg = {'', ''}

local tBindList = {}
if doesFileExist(file) then
   local f = io.open(file, "r")
   if f then
      tBindList = decodeJson(f:read("a*"))
      f:close()
   end
else
   tBindList = {
      [1] = {
         text = "/lock[enter]",
         v = {vkeys.VK_L}
      },
      [2] = {
         text = "/armour[enter]",
         v = {vkeys.VK_4}
      },
      [3] = {
         text = "/time[enter]",
         v = {vkeys.VK_B}
      },
      [4] = {
         text = "/mask[enter]",
         v = {vkeys.VK_5}
      },
      [5] = {
         text = "/usedrugs 3[enter]",
         v = {vkeys.VK_X}
      },
      [6] = { 
         text = "/anim 3[enter]",
         v = {vkeys.VK_MENU, vkeys.VK_C}
      },
      [7] = {
         text = "/anim 9[enter]",
         v = {vkeys.VK_3}
      },
      [8] = {
         text = "/style[enter]",
         v = {vkeys.VK_J}
      },
      [9] = {
         text = "/key[enter]",
         v = {vkeys.VK_K}
      },
      [10] = {
         text = "/fillcar[enter]",
         v = {17, vkeys.VK_2}
      },
      [11] = {
         text = "/repcar[enter]",
         v = {17, vkeys.VK_1}
      },
      [12] = {
         text = "/usemed[enter]",
         v = {vkeys.VK_6}
      },
      [13] = {
         text = "/cars[enter]",
         v = {vkeys.VK_O}
      },
      [14] = {
         text = "q[enter]",
         v = {vkeys.VK_8}
      }
   }
end

local mainini = inicfg.load({
    helper = {
        password="��������",
        user_id="602252621",
        bankpin="123456"
    },
    sunduk = {
        checkbox_donate=false,
        checkbox_mask=false,
        checkbox_platina=false,
        checkbox_standart=false,
        checkbox_tainik=false,
        waiting=5
    },
    functions = {
        colorchat=false,
        offrabchat=false,
        offfrachat=false,
        activement=true,
        fastnosoft="CAPITAL",
        binder = false,
        arecc = false,
        famkv = false,
        uvedomusora = false
    },
    lidzamband = { 
        devyatka = false,
        naborgtext="/vr ����� � �� 'The Rifa'. /smug /port | �������� ��� �� ��������.",
        naborgwait="180",
        band="The Rifa",
        minlvl=2,
        minrank=5,
        fltext1="/f 123",
        flwait1="10",
        fltext2="/f 123",
        flwait2="10",
        fltext3="/f 123",
        flwait3="10",
        fltext4="/f 123",
        flwait4="10",
        fltext5="/f 123",
        flwait5="10",
        fltext6="/f 123",
        flwait6="10",
        fltext7="/f 123",
        flwait7="10",
        fltext8="/f 123",
        flwait8="10",
        fltext9="/f 123",
        flwait9="10",
    },
    lidzammafia = {
        devyatka = false,
    },
    config = {
        allsbiv="V",
        sbiv="Z",
        suicide="F10",
        wh="MBUTTON",
        shook="1",
    },
    flood = {
        fltext3="/j ���������",
        flwait2="180",
        flwait1="180",
        flwait3="15",
        flwait4="180",
        flwait5="10",
        fltext1="/vr ����� �������� �����-������� � �������� full ����� nuestra. 18+, 60+fps fullHD. vk: @blessave",
        fltext2="/vr �������",
        fltext4="/vr �������",
        fltext5="/vr �������"
    },
    oboss = {
        piss1 = false,
        piss2 = true,
        piss3 = false,
        obossactiv = "Q",
        animactiv = "1",
        pissactiv = "2",
        pisstext = "/me ������� ������ ������� ������� �� ������ %s"
    },
    target = {
        cure = "J",
        free = "H",
        kiss = "U",
        trunk = "0"
    },
    autoeda = {
        eda = false,
        meatbag = false,
        comeda = "/jmeat"
    },
    stsw = {
        Weather = 3,
        Time = 19,
        Static = false
    },
    afk = {
        uvedomleniya = false,
        antiafk = false,
    }
}, 'bd')
inicfg.save(mainini, 'bd')

--------------------------

function convertSettingsToString(settings_table)
	local output = ''
	for k, v in pairs(settings_table) do
		output = output .. k .. '=' .. tostring(v) .. ','
	end
	return output:sub(0, -2)
end

function convertStringToSettings(str)
	local output = {}
	for par in str:gmatch('[^,]+') do
		local field, value = par:match('(.+)=(.+)')
		if value == 'true' then value = true
		elseif value == 'false' then value = false
		else value = tonumber(value) end
		output[field] = value
	end
	return output
end


function debugSay(msg)
	if debugMode then sampAddChatMessage('[SHOT] ' .. msg, -1) end
end



local cx = representIntAsFloat(readMemory(0xB6EC10, 4, false))
local cy = representIntAsFloat(readMemory(0xB6EC14, 4, false))
local w, h = getScreenResolution()
local xc, yc = w * cy, h * cx

function getpx()
	return ((w / 2) / getCameraFov()) * settings.field_of_search
end

function canPedBeShot(ped)
	local ax, ay, az = convertScreenCoordsToWorld3D(xc, yc, 0) -- getCharCoordinates(1)
	local bx, by, bz = getCharCoordinates(ped)
	return not select(1, processLineOfSight(ax, ay, az, bx, by, bz + 0.7, true, true, false, true, false, true, false, false))
end

function getcond(ped)
	if settings.through_walls then return true --   or isKeyDown(keys.VK_E)
	else return canPedBeShot(ped) end
end

function getDistanceFromPed(ped)
	local ax, ay, az = getCharCoordinates(1)
	local bx, by, bz = getCharCoordinates(ped)
	return math.sqrt( (ax - bx) ^ 2 + (ay - by) ^ 2 + (az - bz) ^ 2 )
end

function getClosestPlayerFromCrosshair()
	local R1, target = getCharPlayerIsTargeting(0)
	local R2, player = sampGetPlayerIdByCharHandle(target)
	if R2 then return player, target end
	local minDist = getpx()
	local closestId, closestPed = -1, -1
	for i = 0, 999 do
		local res, ped = sampGetCharHandleBySampPlayerId(i)
		if res then
			if getDistanceFromPed(ped) < settings.max_distance then
			local xi, yi = convert3DCoordsToScreen(getCharCoordinates(ped))
			local dist = math.sqrt( (xi - xc) ^ 2 + (yi - yc) ^ 2 )
			if dist < minDist then
				minDist = dist
				closestId, closestPed = i, ped
			end
			end
		end
	end
	return closestId, closestPed
end

function rand() return math.random(-50, 50) / 100 end

function getDamage(weap)
	local damage = {
		[22] = 8.25,
		[23] = 13.2,
		[24] = 46.200000762939,
		[28] = 6.6,
        [25] = 30,
        [26] = 30,
        [27] = 30,
        [28] = 6.6,
        [29] = 8.25,	
        [30] = 9.9,
        [31] = 9.9000005722046,
        [32] = 6.6,
        [34] = 30,
        [33] = 25,
        [38] = 46.2
	}
	return (damage[weap] or 0) + math.random(1e9)/1e15
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
local fontt = renderCreateFont('Arial', 10, 9)
local fo0nt = renderCreateFont('Tahoma', 9, 5)

local sukazaebalmutit = 0

bike = {[481] = true, [509] = true, [510] = true, [14914] = true, [14916] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true, [3196] = true, [3194] = true}

local fam = {'Family', 'Empire', 'Squad', 'Dynasty', 'Corporation', 'Crew', 'Brotherhood'}


notkey = false
local locked = false

floodon1 = false
floodon2 = false
floodon3 = false
floodon4 = false
floodon5 = false

naborgon = false

floodong1 = false
floodong2 = false
floodong3 = false
floodong4 = false
floodong5 = false
floodong6 = false
floodong7 = false
floodong8 = false
floodong9 = false
---------------
----------



local vknotf = {
	ispaydaystate = false,
	ispaydayvalue = 0,
	ispaydaytext = '',
    chatc = false,
    chatf = false,
    chatadv = false,
    dialogs = false,
}


local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- ��������� effil ������ ��� ����������
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner() -- �������� effil ������ � �������� https �������
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(threadHandle,runner, url, args, resolve, reject)
end

local vkerr, vkerrsend -- ��������� � ������� ������, nil ���� ��� ��
function tblfromstr(str)
	local a = {}
	for b in str:gmatch('%S+') do
		a[#a+1] = b
	end
	return a
end
function longpollResolve(result)
	if result then
		if result:sub(1,1) ~= '{' then
			vkerr = '������!\n�������: ��� ���������� � VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and v.object.message and tonumber(v.object.message.from_id) == tonumber(mainini.helper.user_id) then
					if v.object.message.payload then
						local pl = decodeJson(v.object.message.payload)
						if pl.button then
							if pl.button == 'getinfo' then
								getPlayerInfo()                            
                            elseif pl.button == 'getstats' then
                                getPlayerArzStats()
                            elseif pl.button == 'chatchat' then
								chatchatVK()
                            elseif pl.button == 'famchat' then
								famchatVK()                         
                            elseif pl.button == 'advchat' then
                                    advchatVK()
                            elseif pl.button == 'razgovor' then
								razgovorVK()
                            elseif pl.button == 'alldialogs' then
								alldialogsVK()
							end
						end
						return
					end
					if v.object.message.text then
						local text = v.object.message.text .. ' ' --������� �� ������ ���� ���� ������� �������� ���������� ������ (!d � !dc ��� ������)
						if text:match('^%s-%d+%s') then
							text = text:gsub(text:match('^%s-%d+%s*'), '')
					end
                    if text:match('^!d') then
						text = text:sub(1, text:len() - 1)
						local style = sampGetCurrentDialogType()
						if style == 2 or style > 3 then
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, tonumber(u8:decode(text:match('^!d (%d*)'))) - 1, -1)
						elseif style == 1 or style == 3 then
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, u8:decode(text:match('^!d (.*)')))
						else
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1)
						end
						closeDialog()
					elseif text:match('^!dc') then
						closeDialog()
					else
						textvk = text:sub(1, text:len() - 1)
						sampProcessChatInput(u8:decode(textvk))
					end
                end
				end
			end
		end
	end
end



function longpollGetKey()
		async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=198601953&access_token=3544140c860f6dd414cbd45aa355e61fbd4f4010620ea75a3ec682a01bee7e6b5fb9bf01524df709b1090&v=5.131', '', function (result)
        if result then
			if not result:sub(1,1) == '{' then
				vkerr = '������!\n�������: ��� ���������� � VK!'
				return
			end
			local t = decodeJson(result)
			if t then
				if t.error then
					vkerr = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
					return
				end
				server = t.response.server
				ts = t.response.ts
				key = t.response.key
				vkerr = nil
			end
		end
	end)
end



math.randomseed(os.time())


function sendvknotf0(msg)
	host = host or sampGetCurrentServerName()
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
	msg = msg:gsub('{......}', '')
	msg = msg
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if mainini.helper.user_id ~= '' then
        local rnd = math.random(-2147483648, 2147483647)
        async_http_request('https://api.vk.com/method/messages.send', 'peer_id=' .. mainini.helper.user_id .. '&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=3544140c860f6dd414cbd45aa355e61fbd4f4010620ea75a3ec682a01bee7e6b5fb9bf01524df709b1090&v=5.131',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function sendvknotf(msg, host)
	host = host or sampGetCurrentServerName()
    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
	msg = msg:gsub('{......}', '')
    msg = ''..host..' | Online:' .. sampGetPlayerCount(false) ..' | '..acc..'\n'..msg
    msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if mainini.helper.user_id ~= '' then
        local rnd = math.random(-2147483648, 2147483647)
		async_http_request('https://api.vk.com/method/messages.send', 'peer_id=' .. mainini.helper.user_id .. '&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=3544140c860f6dd414cbd45aa355e61fbd4f4010620ea75a3ec682a01bee7e6b5fb9bf01524df709b1090&v=5.131',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function vkKeyboard() 
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
    keyboard.buttons[2] = {}
	keyboard.buttons[3] = {}
	local row = keyboard.buttons[1]
    local row2 = keyboard.buttons[2]
	local row3 = keyboard.buttons[3]
    row[1] = {}
	row[1].action = {}
	row[1].color = 'secondary'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = 'Status'
    row[2] = {}
	row[2].action = {}
	row[2].color = 'secondary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "getstats"}'
	row[2].action.label = 'Stats'
    row2[1] = {}
	row2[1].action = {}
	row2[1].color = trubka and 'secondary' or 'primary'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "razgovor"}'
	row2[1].action.label = trubka and 'PHONE OFF' or 'PHONE ON'
    row3[1] = {}
	row3[1].action = {}
	row3[1].color = vklchat and 'negative' or 'positive'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "chatchat"}'
	row3[1].action.label = vklchat and 'Chat' or 'Chat'
    row3[2] = {}
	row3[2].action = {}
	row3[2].color = vklchatfam and 'positive' or 'negative'
	row3[2].action.type = 'text'
	row3[2].action.payload = '{"button": "famchat"}'
	row3[2].action.label = vklchatfam and 'Fam' or 'Fam'
    row3[3] = {}
	row3[3].action = {}
	row3[3].color = vklchatadv and 'negative' or 'positive'
	row3[3].action.type = 'text'
	row3[3].action.payload = '{"button": "advchat"}'
	row3[3].action.label = vklchatadv and 'Job' or 'Job'
    row3[4] = {}
	row3[4].action = {}
	row3[4].color = vklchatdialog and 'negative' or 'positive'
	row3[4].action.type = 'text'
	row3[4].action.payload = '{"button": "alldialogs"}'
	row3[4].action.label = vklchatdialog and 'Dialogs' or 'Dialogs'
	return encodeJson(keyboard)
end
function char_to_hex(str)
	return string.format("%%%02X", string.byte(str))
  end
  
function url_encode(str)
    local str = string.gsub(str, "\\", "\\")
    local str = string.gsub(str, "([^%w])", char_to_hex)
    return str
end
function getPlayerInfo()
    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if isSampLoaded() and isSampAvailable() and sampGetGamestate() == 3 then
	local response = ''
	local x, y, z = getCharCoordinates(PLAYER_PED)
	response = response .. 'Coords: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
	response = response .. '\nHP: '.. getCharHealth(PLAYER_PED)
	response = response .. '\nPing: '..sampGetPlayerPing(id)
	sendvknotf(response)
	else
		sendvknotf('�� �� ���������� � �������!')
	end
end 

function vkget()
	longpollGetKey()
	local reject, args = function() end, ''
	while not key do 
		wait(1)
	end
	local runner = requestRunner()
	while true do
		while not key do wait(0) end
		url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --������ url ������ ����� ������ �����a, ��� ��� server/key/ts ����� ����������
		threadHandle(runner, url, args, longpollResolve, reject)
		wait(100)
	end
end

sendstatsstate = false
function getPlayerArzStats()
	if sampIsLocalPlayerSpawned() then
    sendstatsstate = true
    sampSendChat('/stats')
    local timesendrequest = os.clock()
    while os.clock() - timesendrequest <= 10 do
        wait(0)
        if sendstatsstate ~= true then
            timesendrequest = 0
        end 
    end
    sendvknotf(sendstatsstate == true and '������! � ������� 10 ������ ������ �� ������� ����������!' or tostring(sendstatsstate))
    sendstatsstate = false
    closeDialog()
else
    sendvknotf("�� �� ����������!")
end
end
   
local health = 0xBAB22C

-- // ������������ ����� �������� ����� �������� �������� �� ������ (���� �� ���������� ��� ��� ��������)
-- // �� ������������� ������� ��������� ��������, �� ������� ������� ����� �������� ����� ���
local TIMEOUT = 1.00

-- // ID ������ ������� ���������
local page = { 
	[1] = 2107,
	[2] = 2108,
	[3] = 2109,
	["cur"] = 1
}

-- // ������� � ������ ���������� � ���������� ������ (������, ���� �������� � ��������)
local Weapon = {
	["co"] 	= { model = 346, x = 0, y = 20, z = 189, name = "Colts" },
	["de"] 	= { model = 348, x = 0, y = 32, z = 189, name = "Desert Eagle" },
	["sg"] 	= { model = 349, x = 0, y = 23, z = 140, name = "ShotGun" },
	["uz"] 	= { model = 352, x = 0, y = 360, z = 188, name = "Micro Uzi" },
	["mp5"] 	= { model = 353, x = 0, y = 17, z = 181, name = "MP5" },
	["ak"] 	= { model = 355, x = 0, y = 27, z = 134, name = "AK-47" },
	["ma"] 	= { model = 356, x = 0, y = 27, z = 134, name = "M4" },
	["mo"] 	= { model = 344, x = 0, y = 0, z = 70, name = "Molotov" },
	["rf"] 	= { model = 357, x = 0, y = 13, z = 120, name = "Rifle" }
}

for name, _ in pairs(Weapon) do
	setmetatable(Weapon[name], {
		__call = function(self, count)
			return {
				step = 0,
				model = self.model,
				rot = { x = self.x, y = self.y, z = self.z },
				count = count,
				clock = os.clock()
			}
		end
	})
end

function getHelpText()
	result = "{EEEEEE}��������\t{EEEEEE}�������\n"
	for cmd, info in pairs(Weapon) do
		result = result .. string.format("{AAAAAA}%s:\t{EEEEEE}/%s {FFAA80}[���-��]\n", info.name, cmd)
	end
	return result
end

function close_inventory()
	for i = 0, 1 do
		if i <= info.step then sampSendClickTextdraw(0xFFFF) end
	end
	info = nil
end

local ScriptState = false
local ScriptState2 = false
local ScriptStateSliva = false
local ScriptStateKo = false
local ScriptState3 = false
local ScriptState4 = false
local ScriptStateGrib = false
local autoaltrend = false
local enabled = false
local olenina = false
local status = false
local graffiti = false

local on = false


local x, y, z = 0, 0, 0


local use = false
local close = false
local use1 = false
local close1 = false


local work = false



local textdraw = {
    [1] = {_, _, 1000},
    [2] = {_, _, 1000},
    [3] = {_, _, 1000},
    [4] = {_, _, 1000},
	[5] = {_, _, 1000},
} 

local Counter = 0

local automeatbag = false

local fix = false
local sundukwork = false


function sp.onSetPlayerDrunk(drunkLevel)
    return {1}
end 
 
local chatlog = true
--local defString = ""
local fpath = getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt'
local fpapka = getGameDirectory().."/moonloader/config/chatlogs"
createDirectory(fpapka)
if not doesFileExist(fpath) then 
	local fw = io.open(fpath, 'w+')
	if fw then fw:write():close() end
end

local baza = true
--local defString = ""
local bazafpath = getWorkingDirectory()..'\\config\\baza.txt'
local bazafpapka = getGameDirectory().."/moonloader/config"
createDirectory(bazafpapka)
if not doesFileExist(bazafpath) then 
	local bazafw = io.open(bazafpath, 'w+')
	if bazafw then bazafw:write():close() end
end

local icons = {
    markers = 0,
    cords = {
    }
}
 



local props = { 
	[0716] = true, [0733] = true, [0737] = true, [0792] = true, [1211] = true, [1216] = true, [1220] = true,
	[1223] = true, [1224] = true, [1226] = true, [1229] = true, [1230] = true, [1231] = true, [1232] = true,
	[1233] = true, [1257] = true, [1258] = true, [1280] = true, [1283] = true, [1284] = true, [1285] = true,
	[1286] = true, [1287] = true, [1288] = true, [1289] = true, [1290] = true, [1291] = true, [1293] = true,
	[1294] = true, [1297] = true, [1300] = true, [1315] = true, [1350] = true, [1351] = true, [1352] = true,
	[1373] = true, [1374] = true, [1375] = true, [1408] = true, [1411] = true, [1412] = true, [1413] = true,
	[1418] = true, [1438] = true, [1440] = true, [1447] = true, [1460] = true, [1461] = true, [1468] = true,
	[1478] = true, [1568] = true, [3276] = true, [3460] = true, [3516] = true, [3853] = true, [3855] = true
}

local cx = representIntAsFloat(readMemory(0xB6EC10, 4, false))
local cy = representIntAsFloat(readMemory(0xB6EC14, 4, false))
local wwe, h = getScreenResolution()
local xc, yc = wwe * cy, h * cx

function getCarDrivenByPlayer(ped)
	if isCharInAnyCar(ped) then
		local car = storeCarCharIsInNoSave(ped)
		return (getDriverOfCar(car) == ped), car
	end
	return false
end
local Arial1g = renderCreateFont("Tahoma", 14, 0x4)

function menu()
	sampShowDialog(2138, 'off: {ff0000}SHIFT+F5 {ffffff}| update: {C71585}/ub {ffffff}| vers: {EE82EE}'..script_vers, string.format([[
{00FA9A}�������� ������ ��� {ff0000}����-������
{AFEEEE}�������� {ff0000}���-��� {AFEEEE}��� �����
{DA70D6}��������
{1E90FF}����� ������/�����������
{9ACD32}������ binds.bind
{ff0000}�������
{C0C0C0}����-���
{DEB887}���-���
{17ab92}�������
{ff4500}�����������
{E9967A}������
{00ff00}�������, ����� � �������
���������� ����� ������ ������ �� ������ ���.�������� %s
{ffffff}���������: {ff4500}/hrec {ffffff}| ����-��������� %s
{BC8F8F}������ ��� ���������. �������� (id)
{FFE4E1}��������� ����������
��������� ���-����������
C��� ������. ���������:{00ffff} %s
������� ����� � ����������. ���������:{00ffff} %s
������������. ���������:{00ffff} %s
SprintHook. ���������:{00ffff} %s
{ffffff}legal: {8A2BE2}SHIFT+F2 {ffffff}| crash: {ff4500}SHIFT+F9 {ffffff}| anticheat: {ff4500}SHIFT+F12
]], 
    mainini.functions.famkv and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.arecc and '{00ff00}ON' or '{777777}OFF',
    mainini.config.sbiv,
    mainini.config.allsbiv,
    mainini.config.suicide,
    mainini.config.shook), 
    '�������', '�������', 2)
end

function afk_menu()
	sampShowDialog(2956, '{fff000}����-���', string.format([[
�������� �������� ID {00ffff}VK 
���������� ��������� ����������� %s {ffffff}(������ ��� ��������)
����-��� %s
{c0c0c0}p.s. ��� ������ ����-��� �� �������� ����� ����.����� - {808000}#AntiAFK_1.4_byAIR.asi
]],
mainini.afk.uvedomleniya and '{00ff00}ON' or '{777777}OFF',
mainini.afk.antiafk and '{00ff00}ON' or '{777777}OFF'),  
    '�������', '�������', 2)
end

function chatlog_menu()
    sampShowDialog(10647, "{fff000}���-���", string.format([[
{ffffff}/ch
{ffffff}/ch �����
{ffffff}/chh
]]), "�����", _, 0)
end


function drugoenosoft_menu()
	sampShowDialog(2938, '{fff000}����������', string.format([[
{ffffff}1. ���������� ������ ��������� - {DDA0DD}/de /ma /rf /sg /mp5 /pst /ak
{ffffff}3. ����������� �������: {DDA0DD}/members -> /mb, /findihouse -> /fh, /findibiz -> /fbiz, /fam -> /k
{ffffff}4. ������� ������ ���� ������ - {DDA0DD}/cln
{ffffff}5. ������� �������� ���� ���� /home - ALT � ���� (��� ����� 20, 46, 47, 48, 57, 61)
{ffffff}6. �������� ������� ������� ������ �� ����
{ffffff}7. ������� ����� � ����, ��� �������, ��� �������
{ffffff}8. ����-{DDA0DD}/key
{ffffff}9. ����������� - {DDA0DD}/calc
{ffffff}10. ����-������ ������� �������� �������� - {DDA0DD}/fpay
{ffffff}11. ����-�������� ��� �������� ��������� � {DDA0DD}/vr
{ffffff}12. ����-��������� �������� � ��������� - {DDA0DD}/rlt + {ffffff}���� ��������� � ������ ����
{ffffff}13. ������ � ���� � ������������ - {DDA0DD}/eathome
{ffffff}14. ������� ������� � ������ ��� {DDA0DD}/jail
{ffffff}15. ������� ������� � ������ ��� {DDA0DD}/mute
{ffffff}16. ������ ���� ���� �� ��� �� /dl - /getcolor
{ffffff}17. ������� ���� - {DDA0DD}/cchat
{ffffff}18. ����� � �������� {DDA0DD}/sms
{ffffff}19. ����������� �� ������ �������, ���� �� ������
{ffffff}20. ����-������ ����, ������, �����������
{ffffff}21. ���������� ���� ��������� - {DDA0DD}/rabchat
{ffffff}22. ���������� ���� ����� - {DDA0DD}/frachat
{ffffff}23. ��������� ���� �� ������ ������ - {DDA0DD}/colorchat
{ffffff}24. ������ ����� ���� ��� ������ (����� �������) - {FF7F50}/probiv
{ffffff}25. {ff0000}CamHack {ffffff}- ��������: {DDA0DD}C+1{ffffff}, ���������: {DDA0DD}�+2{ffffff}, ��������: {DDA0DD}+{ffffff}, ���������: {DDA0DD}-{ffffff}, �������� ���: {DDA0DD}F12

]]),  
    '�������', _, 0)
end

function drugoesoft_menu()
	sampShowDialog(2939, '{fff000}����������', string.format([[
{ffffff}1. ������ ������� ���� c ����-������ - {FF7F50}/rend
{ffffff}2. ����-������ ��� �������� � ���������� - ������ {ff0000}SHIFT
{ffffff}3. �������� GM-car - ������ {ff0000}����� SHIFT
{ffffff}4. ����-���� ����: ������ ������/������� - ������ {ff0000}1{ffffff}, ������ �� ������/���� - ������ {ff0000}SHIFT{ffffff}, ������� ������ �� ������ - {ff0000}C
{ffffff}5. ����-�����
{ffffff}6. ����-����� - {ff0000}��� � ������
{ffffff}7. ������� ��������� - {ff0000}��� � ������
{ffffff}8. ����������� ���
{ffffff}9. �������� ����-������� � ����������/���� - ������ {ff0000}SHIFT. {ffffff}����������: � ���� ������ �� ��������
{ffffff}10.�������� ����-�������� �������� �� ������� (����-����) - ������ {ff0000}����� CTRL
]]),  
    '�������', _, 0)
end

function lidzam_menu()
    sampShowDialog(2741, '{fff000}����� ������/����', string.format([[
����� ������/���� ��� ����� %s
���������
����� ������/���� ��� ����� %s
��������� (� ����������)]], 
    mainini.lidzamband.devyatka and '{00ff00}ON' or '{777777}OFF',
    mainini.lidzammafia.devyatka and '{00ff00}ON' or '{777777}OFF'),
        '�������', '�������', 2)
end

function lidzamband_menu()
    sampShowDialog(2790, '{fff000}����� ������/���� �����', string.format([[
�����: {B0C4DE}%s
{ffffff}� ������ ��� ���������: {00ffff}%s
{ffffff}�� ����� ���� ��������� ��������: {00ff00}%s
{ff0000}��������
���� ������ %s
{C71585}%s ���.
{7FFFD4}%s
{ffffff}������� � ����� �� 5 ���� - {ADFF2F}���+[
{ffffff}������� � ����� �� 8 ���� - {ADFF2F}���+]
{ffffff}������� ���� - {ADFF2F}���+= {ffffff}��� {90EE90}/gs id skinid
{ffffff}�������� ���� - {ADFF2F}���+- {ffffff}��� {90EE90}/gr id rank
{ffffff}������� �� ����� � �������� "�������" - {CD5C5C}/fu id]],
    mainini.lidzamband.band,
    mainini.lidzamband.minlvl,
    mainini.lidzamband.minrank,
    naborgon and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzamband.naborgwait,
    mainini.lidzamband.naborgtext),
        '�������', '�������', 2)
end

function lidzammafia_menu()
    sampShowDialog(2791, '{fff000}����� ������/���� �����', string.format([[
����� ������/���� %s
�����: %s
|
���� ������ %s
{C71585}%s ���.
{7FFFD4}%s
|
������� � ����� �� 5 ���� - ���+[
������� � ����� �� 8 ���� - ���+]
������� ���� - ���+= ��� /gs id skinid
�������� ���� - ���+- ��� /gr id rank]], 
    mainini.lidzam.devyatka and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzam.band,
    nabormon and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzamband.nabormwait,
    mainini.lidzamband.nabormtext),
        '�������', '�������', 2)
end

function flood_menu()
    sampShowDialog(2787, '{fff000}��������', string.format([[
Flood 1 %s
{C71585}%s ���.
{7FFFD4}%s
Flood 2 %s
{C71585}%s ���.
{7FFFD4}%s
Flood 3 %s
{C71585}%s ���.
{7FFFD4}%s
Flood 4 %s
{C71585}%s ���.
{7FFFD4}%s
Flood 5 %s
{C71585}%s ���.
{7FFFD4}%s]], 
    floodon1 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait1,
    mainini.flood.fltext1, 
    floodon2 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait2,
    mainini.flood.fltext2, 
    floodon3 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait3,
    mainini.flood.fltext3, 
    floodon4 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait4,
    mainini.flood.fltext4, 
    floodon5 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait5,
    mainini.flood.fltext5),
        '�������', '�������', 2)
end

function ghetto_lidzam_flood()
    sampShowDialog(22487, '{fff000}Ghetto ��������', string.format([[
Flood 1 %s
Flood 2 %s
Flood 3 %s
Flood 4 %s
Flood 5 %s
Flood 6 %s
Flood 7 %s
Flood 8 %s
Flood 9 %s
{ffffff}FL1: {C71585}%s ���.
{ffffff}FL1: {7FFFD4}%s
{ffffff}FL2: {C71585}%s ���.
{ffffff}FL2: {7FFFD4}%s
{ffffff}FL3: {C71585}%s ���.
{ffffff}FL3: {7FFFD4}%s
{ffffff}FL4: {C71585}%s ���.
{ffffff}FL4: {7FFFD4}%s
{ffffff}FL5: {C71585}%s ���.
{ffffff}FL5: {7FFFD4}%s
{ffffff}FL6: {C71585}%s ���.
{ffffff}FL6: {7FFFD4}%s
{ffffff}FL7: {C71585}%s ���.
{ffffff}FL7: {7FFFD4}%s
{ffffff}FL8: {C71585}%s ���.
{ffffff}FL8: {7FFFD4}%s
{ffffff}FL9: {C71585}%s ���.
{ffffff}FL9: {7FFFD4}%s]], 
    floodong1 and '{00ff00}ON' or '{777777}OFF',
    floodong2 and '{00ff00}ON' or '{777777}OFF',
    floodong3 and '{00ff00}ON' or '{777777}OFF',
    floodong4 and '{00ff00}ON' or '{777777}OFF',
    floodong5 and '{00ff00}ON' or '{777777}OFF',
    floodong6 and '{00ff00}ON' or '{777777}OFF',
    floodong7 and '{00ff00}ON' or '{777777}OFF',
    floodong8 and '{00ff00}ON' or '{777777}OFF',
    floodong9 and '{00ff00}ON' or '{777777}OFF',
    mainini.lidzamband.flwait1,
    mainini.lidzamband.fltext1, 
    mainini.lidzamband.flwait2,
    mainini.lidzamband.fltext2, 
    mainini.lidzamband.flwait3,
    mainini.lidzamband.fltext3, 
    mainini.lidzamband.flwait4,
    mainini.lidzamband.fltext4, 
    mainini.lidzamband.flwait5,
    mainini.lidzamband.fltext5, 
    mainini.lidzamband.flwait6,
    mainini.lidzamband.fltext6, 
    mainini.lidzamband.flwait7,
    mainini.lidzamband.fltext7, 
    mainini.lidzamband.flwait8,
    mainini.lidzamband.fltext8, 
    mainini.lidzamband.flwait9,
    mainini.lidzamband.fltext9),
        '�������', '�������', 2)
end

function piss_menu()
    sampShowDialog(4169, '{fff000}�����������', string.format([[
{ff0000}[�����] {ffffff}�� ������ ���� ����� ������� ���-�� ����
������������ {c0c0c0}��� %s
������������ {c0c0c0}��� ������� %s
������������ {c0c0c0}���_������� %s
{ff4500}����� �����������
��������� �����������: {9370DB}��� + {00ffff}%s
��������� �� /anim 85:{00ffff} %s
��������� ����� /piss: {00ffff}%s]], 
    mainini.oboss.piss1 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.piss2 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.piss3 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.obossactiv,
    mainini.oboss.animactiv,
    mainini.oboss.pissactiv),
        '�������', '�������', 2)
end

function target_menu()
    sampShowDialog(4119, '{fff000}�������', string.format([[
�������� ��������� ��� /cure. ������: %s
�������� ��������� ��� /free. ������: %s
�������� ��������� ��� /kiss. ������: %s
��� �������������� � ����������. ������ %s]], 
    mainini.target.cure,
    mainini.target.free,
    mainini.target.kiss,
    mainini.target.trunk),
        '�������', '�������', 2)
end

function eda_menu()
    sampShowDialog(4969, '{fff000}����-���', string.format([[
{ff0000}[�����] {ffffff}�� ������ ���� ����� ������� ���-�� ����
������� ����-��� %s
����-��� ��� �������, ��� ����� ����� � ����� %s
������� ��� ������� ����-���. ������: {ff4500}%s]], 
    mainini.autoeda.eda and '{00ff00}ON' or '{777777}OFF', 
    mainini.autoeda.meatbag and '{00ff00}ON' or '{777777}OFF', 
    mainini.autoeda.comeda),
        '�������', '�������', 2)
end

function sunduk_menu()
    sampShowDialog(9079, '{fff000}����-���������� ��������', string.format([[{ff0000}[�����] {ffffff}������� ����������� ����� ��� �� ������� � ��������� {4682B4}%s{ffffff} ���.
{ffffff}��������� %s {ffffff}��� {00ffff}/rlt
{4682B4}�������� ��������
{ffffff}��������� ������� ������ %s
{ffffff}��������� ���������� ������ %s
{ffffff}��������� ������ ����� ����� %s
{ffffff}��������� ����� ������ %s
{ffffff}��������� ������ ���-������� %s]], 
    mainini.sunduk.waiting,
    work and '{00ff00}ON' or '{777777}OFF',
    mainini.sunduk.checkbox_standart and '{00ff00}ON' or '{777777}OFF', 
    mainini.sunduk.checkbox_platina and '{00ff00}ON' or '{777777}OFF', 
    mainini.sunduk.checkbox_mask and '{00ff00}ON' or '{777777}OFF', 
    mainini.sunduk.checkbox_donate and '{00ff00}ON' or '{777777}OFF', 
    mainini.sunduk.checkbox_tainik and '{00ff00}ON' or '{777777}OFF'),
        '�������', '�������', 2)
end

function binder_menu()
	sampShowDialog(23388, '{fff000}������ ����', string.format([[
������ %s
����������]], 
	mainini.functions.binder and '{00ff00}ON' or '{777777}OFF'),
    '�������', '�������', 2)
end

function binder_info()
	sampShowDialog(2338, '{Fff000}������', string.format([[
{ffffff}� ������� ������� {fff000}\\moonloader\\config\\binds.bind {ffffff}��������� ���������:
����� �������� ������ ����� � ����� ������ ��������� ������� ����� ����������� ���������� ������� � �������:
{FFA07A}{"text":"��� ��� ��� - �� ��� ������� ���[enter]","v":[82]}
{ffffff}�����: ����� ����� ��� "��� ��� ��� - �� ��� ������� ���" ([enter] - ��������� �����, ���� �� ������ �� ������ ������ �������� � ����), 82 - ��� ID �������. � ������ ������ ������� R.

����� �������� ������ �� ������� ����� ������ �������� ���� "\" ����� ����� ��������:
{FFA07A}{"text":"\/mask[enter]","v":[82]}

        {9ACD32}������� �� ���������:
            {ffffff}/lock - {9370DB}L
            {ffffff}/armour - {9370DB}4
            {ffffff}/time - {9370DB}B
            {ffffff}/mask - {9370DB}5
            {ffffff}/usedrugs 3 - {9370DB}X
            {ffffff}/anim 3 - {9370DB}ALT+C
            {ffffff}/anim 9 - {9370DB}3
            {ffffff}/style - {9370DB}J
            {ffffff}/key - {9370DB}K
            {ffffff}/fillcar - {9370DB}CTRL+2
            {ffffff}/repcar - {9370DB}CTRL+1
            {ffffff}/usemed - {9370DB}6
            {ffffff}/cars - {9370DB}O
            {ffffff}������������ (q) - {9370DB}R

]]),  
    '�������', _, 0)
end


function wh_cops_pidors()
	sampShowDialog(2859, '{fff000}{c0c0c0}WallHack. {0000ff}Cops.', string.format([[WallHack. ���������:{00ffff} %s
�������� ������� %s {ffffff}(������ FPS)
����������� �� ������ � ���, ��� � ���� ������ ���� ������ %s
������� ������� ���� �������� � �� � ������. ������: {00ffff}%s
{ffffff}������ �������]], 
    mainini.config.wh,
	mainini.functions.activement and '{00ff00}ON' or '{777777}OFF', 
	mainini.functions.uvedomusora and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.fastnosoft),
    '�������', '�������', 2)
end

function edit_wh()
	sampShowDialog(2250, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.wh), 
'���������', '�������', 1)
end

function edit_suicide()
	sampShowDialog(2251, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.suicide), 
'���������', '�������', 1)
end

function edit_shook()
	sampShowDialog(2293, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.shook), 
'���������', '�������', 1)
end

function edit_allsbiv()
	sampShowDialog(2252, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.allsbiv), 
'���������', '�������', 1)
end


function edit_sbiv()
	sampShowDialog(2253, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ID: {00ffff}%s]], 
mainini.config.sbiv), 
'���������', '�������', 1)
end



function edit_userid()
	sampShowDialog(2139, '{fff000}���������', string.format([[
{ffffff}��� ������ ������ ������� {ff4500}ble$$ave {ffffff}����������:
{ffffff}������� � ������ {00FF00}https://vk.com/blessavesoft. {ffffff}�������� � �������� � ������ ��������� ������.
{ffffff}�������� � {FF1493}���� {ffffff}���������� ���� ������������� �������� ID ������ VK.
{ffffff}���� �� �� ������� ��������� �� ��� ������ ��������� � ������ {F5DEB3}�������� ���������{ffffff}.
������� ID: {00ffff}%s]], 
mainini.helper.user_id), 
'���������', '�������', 1)
end

function edit_pass()
	sampShowDialog(21391, '{fff000}���������', string.format([[
{ffffff}������� ���� ������ �� ��������.
{ffffff}������� ������: {00ffff}%s]], 
mainini.helper.password), 
'���������', '�������', 1)
end
function edit_bank()
	sampShowDialog(21392, '{fff000}���������', string.format([[
{ffffff}������� ���� ���������� ���-���.
{ffffff}������� ���-���: {00ffff}%s]], 
mainini.helper.bankpin), 
'���������', '�������', 1)
end

local policeSkins = {[163] = true, [164] = true, [165] = true, [166] = true, [286] = true, [285] = true, [265] = true, [266] = true,[295] = true, [267] = true, [280] = true, [281] = true, [282] = true, [283] = true, [284] = true, [288] = true, [302] = true, [301] = true, [300] = true, [305] = true, [306] = true, [309] = true, [310] = true, [311] = true}
--local policeSkins = {[174] = true, [175] = true}
local policeCounter = 0
local pidorCounter = 0
local fontment = renderCreateFont('Tahoma', 10, 13)
local fontment1 = renderCreateFont('Tahoma', 9, 13)
local detectedFont = renderCreateFont('Tahoma', 14, 13)

local w, h = getScreenResolution()
local warningment = '207E9E'
local warningpidor = '34d408'

function isVisible(myPosX, myPosY, myPosZ, posX, posY, posZ)
	if isLineOfSightClear(myPosX, myPosY, myPosZ, posX, posY, posZ, true) then
		--renderFontDrawText(detectedFont, '{AB1126}warning', w/1.350, h/1.690, 0xFFFFFFFF)
        warningment = 'AB1126'
    else
        warningment = '207E9E'
	end
end

function isVisiblep(myPosX, myPosY, myPosZ, posX, posY, posZ)
	if isLineOfSightClear(myPosX, myPosY, myPosZ, posX, posY, posZ, true) then
		--renderFontDrawText(detectedFont, '{ddec0e}warning', w/1.350, h/1.390, 0xFFFFFFFF)
        warningpidor = 'ddec0e'
    else
        warningpidor = '34d408'
	end
end

function getNearCarToCenter(radius)
    local arr = {}
    local sx, sy = getScreenResolution()
    for _, car in ipairs(getAllVehicles()) do
        if isCarOnScreen(car) and getDriverOfCar(car) ~= playerPed then
            local carX, carY, carZ = getCarCoordinates(car)
            local cX, cY = convert3DCoordsToScreen(carX, carY, carZ)
            local distBetween2d = getDistanceBetweenCoords2d(sx / 2, sy / 2, cX, cY)
            if distBetween2d <= tonumber(radius and radius or sx) then
                table.insert(arr, {distBetween2d, car})
            end
        end
    end
    if #arr > 0 then
        table.sort(arr, function(a, b) return (a[1] < b[1]) end)
        return arr[1][2]
    end
    return nil
end

function applySampfuncsPatch()
    local memory = memory or require 'memory'
    local module = getModuleHandle("SAMPFUNCS.asi")
    if module ~= 0 and memory.compare(module + 0xBABD, memory.strptr('\x8B\x43\x04\x8B\x5C\x24\x20\x8B\x48\x34\x83\xE1'), 12) then
        memory.setuint16(module + 0x83349, 0x01ac, true)
        memory.setuint16(module + 0x8343c, 0x01b0, true)
        memory.setuint16(module + 0x866dd, 0x00f4, true)
        memory.setuint16(module + 0x866e9, 0x0306, true)
        memory.setuint8(module + 0x8e754, 0x40, true)
    end
end

local showa = false
local mainadm = inicfg.load({
	a = {
        "Kevin_Sweezy",
        "Diana_Mironova",
    },
    p = {
        "Thomas_Trump",
        "Looney_Revenge",
    }
}, 'a')
inicfg.save(mainadm, 'a')

function mySort(a,b)
    if  a[2] < b [2] then
        return true
    end
    return false
end 

local dd1 = false

function dd(arg)
	dd1 = not dd1
	if dd1 then
		printStyledString("~n~~n~~n~~n~~n~~n~~n~~n~~w~STREAM-CLEANER - ~g~activated", 2000, 4)
		alldell()
	else
		printStyledString("~n~~n~~n~~n~~n~~n~~n~~n~~w~STREAM-CLEANER - ~r~deactivated", 2000, 4)
	end
end

function sp.onVehicleStreamIn()
	if dd1 then
		return false
	end
end

function sp.onPlayerStreamIn()
	if dd1 then
		return false
	end
end

function alldell()
	for player = 0, 1000 do
		local _, hPed = sampGetCharHandleBySampPlayerId(player)
		if _ then
			RakNet = raknetNewBitStream()
			raknetBitStreamWriteInt16(RakNet, player)
			raknetEmulRpcReceiveBitStream(163, RakNet)
			raknetDeleteBitStream(RakNet)
		end
	end	
	local cars = getAllVehicles()
	for c = 1, #cars do
		if doesVehicleExist(cars[c]) and not isCharInCar(PLAYER_PED, cars[c]) then
			local _, cid = sampGetVehicleIdByCarHandle(cars[c])
			if _ then
				RakNet = raknetNewBitStream()
				raknetBitStreamWriteInt16(RakNet, cid)
				raknetEmulRpcReceiveBitStream(165, RakNet)
				raknetDeleteBitStream(RakNet)
			end
		end
	end
end

function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end 
local PI = 3.14159
--thisScript():unload() 
if not doesFileExist("moonloader\\config\\udpate.ini") then
    downloadUrlToFile("https://raw.githubusercontent.com/tedjblessave/binder/main/udpate.ini", "moonloader\\config\\udpate.ini", function(id, statuss, p1, p2)
        if statuss == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage("�������� ���� {c0c0c0}udpate.ini {ffffff}��� ������ �������." , -1)
        end 
    end)
end
local _, ider = sampGetPlayerIdByCharHandle(PLAYER_PED)
local nicker = sampGetPlayerNickname(ider)
local nickker = string.match(nicker, '(.*)_')
--printStringNow("~B~Script ~Y~/blessave ~G~ON ~P~for "..nickker, 1500, 5)
if mainini.afk.antiafk then
    workpaus(true)
end
lAA = lua_thread.create(lAA)
renderr = lua_thread.create(renderr)



downloadUrlToFile(update_url, update_path, function(id, status)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        updateini = inicfg.load(nil, update_path)
        if tonumber(updateini.info.vers) > script_vers then
            sampAddChatMessage("���� ����������! ������ �� {FA8072}" .. updateini.info.vers_text.. " {ffffff}�����. {c0c0c0}��������: {ff4500}/ub", -1)
            update_state = true
        end
        --os.remove(update_path)
    end
end)

sampRegisterChatCommand("cr", dd)
sampRegisterChatCommand("/sm", setStatic)
sampRegisterChatCommand("/t", setTime)
sampRegisterChatCommand("/w", setWeather)

sampRegisterChatCommand('bind', binder_menu)
sampRegisterChatCommand('flood', flood_menu)

local fontSF = renderCreateFont("Arial", 8, 5) --creating font
sampfuncsRegisterConsoleCommand("deletetd", del)    --registering command to sampfuncs console, this will call delete function
sampfuncsRegisterConsoleCommand("showtdid", show)   --registering command to sampfuncs console, this will call function that shows textdraw id's
sampfuncsRegisterConsoleCommand("getdialoginfo", dialoginfo) --registering sf console command

sampRegisterChatCommand('calc', function(arg) 
if #arg > 0 then 
local k = calc(arg)
if k then 
sampAddChatMessage('[Calculator] {FFFFFF}�������� ������: {FFFF00}' ..arg.. ' = ' .. k,0xff4500)  
end 
else sampAddChatMessage("[Calculator] {FFFFFF}����� ������ ������� ����� ������" , 0xff4500)
end
end)

lua_thread.create(vkget)


    for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
    end



tormoz = lua_thread.create(tormoz)
dHits = lua_thread.create(dHits)
autoC = lua_thread.create(autoC)


timeweat = lua_thread.create(timeweat)

autoshar = lua_thread.create(autoshar)
targetfunc = lua_thread.create(targetfunc)


fastrun = lua_thread.create(fastrun)
hphud = lua_thread.create(hphud)

proops = lua_thread.create(proops)


rltao = lua_thread.create(rltao)

camhack = lua_thread.create(camhack)

thr = lua_thread.create_suspended(thread_func)
thr2 = lua_thread.create_suspended(thread_func2)



flymode = 0  
speed = 0.2
radarHud = 0
time = 0
keyPressed = 0




while true do


if autoaltrend then
    renderFontDrawText(fontment, "{ffffff}Auto{ff0000}ALT", w/4, h/2.550, 0xDD6622FF)
end
--[[ 
if isKeyDown(VK_Z) and isKeyCheckAvailable() then
    for _,carii in pairs(getAllVehicles()) do
        if isCarOnScreen(carii) then
            local a,b,c = getCarCoordinates(carii)
            local myPosX, myPosY, myPosZ = getCharCoordinates(PLAYER_PED)
            local distance = getDistanceBetweenCoords3d(myPosX, myPosY, myPosZ, a, b, c)
            local x,y = convert3DCoordsToScreen(a,b,c)
            local resofget, vehid = sampGetVehicleIdByCarHandle(carii)
            if resofget then
                if distance <= 5 then
                    local infcar = select(2, sampGetVehicleIdByCarHandle(carii))
                    renderFontDrawText(fontment, infcar, x, y, -1)
                end
            end
        end
    end
end ]]
applySampfuncsPatch()

 
wait(0)
--[[ if isKeyDown(VK_K) then 
    for i = 0, 300 do
        sampSendClickTextdraw(2134) 
        wait(100)
        sampSendDialogResponse(3082, 1, 0, nil)
    wait(100)
        sampSendDialogResponse(0, 1, 0, nil) 
        wait(1200)
    
    end
end ]]

if showa then
	local resX, resY = getScreenResolution()
    local admtbl = {}
    for ida = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(ida) then
            local namea = sampGetPlayerNickname(ida)
            local founda = false
            for _,vva in pairs(mainadm.a) do
                if vva == namea and not founda then
                    founda = true
                end
            end
            if founda == true then table.insert(admtbl,{namea,ida}) end
        end
    end
    for _,va in pairs(admtbl) do
        renderFontDrawText(fontment, '{0f96b8}������:', resX-(resX/20*3), (resY/3.25), 0xFFFFFFFF)
        renderFontDrawText(fontment, '{16c0ac}'..va[1]..'{ffffff}['..va[2]..']', resX-(resX/20*3), (resY/3.25)+_*15, 0xFFFFFFFF)
    end
end



if actmentpidor then
    if mainini.functions.activement then
        policeCounter = 0
        Yposm = 3.250
        for i = 0, sampGetMaxPlayerId(true) do
            local resultm, pedm = sampGetCharHandleBySampPlayerId(i)
            if resultm then
                local myPosX, myPosY, myPosZ = getCharCoordinates(PLAYER_PED)
                local posX, posY, posZ = getCharCoordinates(pedm)
                local distance = getDistanceBetweenCoords3d(myPosX, myPosY, myPosZ, posX, posY, posZ)


                if distance <= 701.0  then --and (colorment == 23486046 or colorment == 2147502591) 
                    local playerSkinId = getCharModel(pedm)
                    if policeSkins[playerSkinId] then 
                        _, idment = sampGetPlayerIdByCharHandle(pedm)
                        namement = sampGetPlayerNickname(idment)
                        colorment = sampGetPlayerColor(idment)
                        if colorment == 23486046 or colorment == 2147502591 then
                            policeCounter = policeCounter + 1
                            isVisible(myPosX, myPosY, myPosZ, posX, posY, posZ)
                            Yposm = Yposm - 0.140
                            renderFontDrawText(fontment, '{0000ff}�����a: {FFFFFF}'..policeCounter, w/50, h/3.350, 0xFFFFFFFF)
                            renderFontDrawText(fontment, '{'..warningment..'}'..namement..'{ffffff}['..idment..'] {18cd58}lvl: {ffffff}'..sampGetPlayerScore(idment), w/50, h/Yposm, 0xFFFFFFFF)
                        end
                    end    
                end
            end
        end
        if not isPauseMenuActive() and policeCounter == 0 then
            renderFontDrawText(fontment1, '����� ��� ��� �������.', w/50, h/3.350, 0xFFFFFFFF)
        end
    end

    if mainini.functions.uvedomusora then
        policeCounter = 0
        --Yposm = 3.250
        for i = 0, sampGetMaxPlayerId(true) do
            local resultm, pedm = sampGetCharHandleBySampPlayerId(i)
            if resultm then
                local myPosX, myPosY, myPosZ = getCharCoordinates(PLAYER_PED)
                local posX, posY, posZ = getCharCoordinates(pedm)
                local distance = getDistanceBetweenCoords3d(myPosX, myPosY, myPosZ, posX, posY, posZ)


                if distance <= 501.0  then --and (colorment == 23486046 or colorment == 2147502591) 
                    local playerSkinId = getCharModel(pedm)
                    if policeSkins[playerSkinId] then 
                        _, idment = sampGetPlayerIdByCharHandle(pedm)
                        namement = sampGetPlayerNickname(idment)
                        colorment = sampGetPlayerColor(idment)
                        if colorment == 23486046 or colorment == 2147502591 then
                            policeCounter = policeCounter + 1
                           -- isVisible(myPosX, myPosY, myPosZ, posX, posY, posZ)
                           -- Yposm = Yposm - 0.140
                           -- renderFontDrawText(fontment, '{0000ff}�����a: {FFFFFF}'..policeCounter, w/6, h/3.350, 0xFFFFFFFF)
                            --renderFontDrawText(fontment, '{'..warningment..'}'..namement..'{ffffff}['..idment..'] {18cd58}lvl: {ffffff}'..sampGetPlayerScore(idment), w/6, h/Yposm, 0xFFFFFFFF)
                            printStyledString("~R~MUSORA:~B~ "..policeCounter, 330, 5)
                           -- printString("~R~MUSORA:~B~ "..policeCounter, 330)
                        end
                    end    
                end
            end
        end
    end
end


dialogsMenu()
dialogsFloodMenu()
 

if toggle then --params that not declared has a nil value that same as false
    for a = 0, 2304	do --cycle trough all textdeaw id
        if sampTextdrawIsExists(a) then --if textdeaw exists then
            x, y = sampTextdrawGetPos(a) --we get it's position. value returns in game coords
            x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y) --so we convert it to screen cuz render needs screen coords
            renderFontDrawText(fontSF, a, x1, y1, 0xFFBEBEBE) --and then we draw it's id on textdeaw position
        end
    end
end

if bott and trott then
    if isKeyDown(VK_RBUTTON) then
        if getCurrentCharWeapon(playerPed) == 24 or getCurrentCharWeapon(playerPed) == 33 or getCurrentCharWeapon(playerPed) == 35 then
            local cam_x, cam_y, cam_z = getActiveCameraCoordinates()
            local width, heigth = convertGameScreenCoordsToWindowScreenCoords(339.1, 179.1)
            local aim_x, aim_y, aim_z = convertScreenCoordsToWorld3D(width, heigth, 100)
            local result, colPoint = processLineOfSight(cam_x, cam_y, cam_z, aim_x, aim_y, aim_z, false, false, true, false, false, false, false) 
            if result then
                if isLineOfSightClear(cam_x, cam_y, cam_z, colPoint.pos[1], colPoint.pos[2], colPoint.pos[3], true, true, false, true, true) then
                    if colPoint.entityType == 3 then
                        if getCharPointerHandle(colPoint.entity) ~= playerPed then
                            writeMemory(0xB7347A, 4, 255, 0)
                        end
                    end
                end
            end
        end
    end
end

if rewesl and isKeyJustPressed(57) and isKeyCheckAvailable() and not isKeyDown(18) and not isKeyDown(16) and not isKeyDown(17) and not captureon then statesl = not statesl end



if isKeyDown(18) and isKeyJustPressed(57) and isKeyCheckAvailable() then trott = not trott end
if trott then 
    --local clr = join_argb(0, 220, 20, 60)
    local clr = join_argb(0, 178, 34, 34)
    local r,g,b = 178, 34, 34
    --writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
    --changeRadarColor(("0xFF%06X"):format(clr))
    changeCrosshairColor(("0xFF%06X"):format(clr))
else
    --local clr1 = join_argb(0, 178, 34, 34)
    local clr = join_argb(0, 255, 255, 255)
    local r,g,b = 178, 34, 34
    --writeMemory(health, 4, ("0xFF%06X"):format(clr1), true)
    --changeRadarColor(("0xFF%06X"):format(clr))
    changeCrosshairColor(("0xFF%06X"):format(clr))
end

if reweextra then
    if isKeyDown(16) and isKeyJustPressed(57) and isKeyCheckAvailable() and not captureon then 
        activeextra = not activeextra
        if activeextra then
            cameraRestorePatch(true)
            --sampAddChatMessage('123', -1)
        else
            cameraRestorePatch(false)
            --sampAddChatMessage('123456', -1)
            activeextra = false
        end
    end
    if isCharDead(playerPed) then cameraRestorePatch(false) wait(200) activeextra = false end
    local extraheal = getCharHealth(PLAYER_PED)
    if extraheal <= 5 then cameraRestorePatch(false) wait(200) activeextra = false end
end







local texthome = sampTextdrawGetString(2054)
if texthome:match("House~g~ 20") or texthome:match("House~g~ 85") or texthome:match("House~g~ 132") or texthome:match("House~g~ 61") or texthome:match("House~g~ 62") or texthome:match("House~g~ 47") or texthome:match("House~g~ 46") or texthome:match("House~g~ 48") or texthome:match("House~g~ 57") then
    menuhome = true
end
if menuhome and not sampTextdrawIsExists(2054) then menuhome = false end

if sampTextdrawIsExists(2103) and not act then
-- addOneOffSound(0.0, 0.0, 0.0, 23000)
    local text = sampTextdrawGetString(2103)
    if text:find('Incoming') and mainini.afk.uvedomleniya then
        local nick = text:gsub('(%s)(%w_%w)(.+)', '%2')
        sendvknotf(';-) ���� ������ '..nick) -- output
        
    end
    act = true
end
if act and not sampTextdrawIsExists(2103) then act = false end

while isPauseMenuActive() do -- � ���� ����� ��������� ������, ���� �� �������
    if cursorEnabled then
        showCursor(false)
    end
    wait(100)
end

local _, id_my = sampGetPlayerIdByCharHandle(PLAYER_PED)
local anim = sampGetPlayerAnimationId(id_my)

--[[ for i=0, 2048 do
    if sampIs3dTextDefined(i) then
        local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(i)
        if color == 4291611852 and playerId >= 0 then sampDestroy3dText(i) end
    end
end ]]
--�������� �������




doKeyCheck()

arec()


if isKeyJustPressed(_G['VK_'..mainini.target.trunk]) and isKeyCheckAvailable() and not isCharInAnyCar(PLAYER_PED) then
    local cartrunk = getNearCarToCenter(100)
    if cartrunk then
        local cartrId = select(2, sampGetVehicleIdByCarHandle(cartrunk))
        sampSendChat('/trunk '..cartrId, -1)
    else -- nil
        sampAddChatMessage('�������� ���� ������ �� ����', -1)
    end
end



if isKeyJustPressed(78) and isCharInAnyCar(PLAYER_PED) then
    notkey = true
end


if isKeyDown(16) and isKeyJustPressed(116)  then
    --printStringNow("~B~Script ~Y~/blessave ~R~OFF ~P~for "..nickker, 1500, 5)
    thisScript():unload() 
end
if isKeyDown(16) and isKeyJustPressed(120) and isKeyCheckAvailable() then
    callFunction(0x823BDB , 3, 3, 0, 0, 0)
end
if isKeyDown(16) and isKeyJustPressed(123) and isKeyCheckAvailable() and not isCharInAnyCar(PLAYER_PED) then
    anticheat = not anticheat
    if anticheat then
        for i = 0, 50 do
            sampSendChat("/vr �������")
        end
        anticheat = false
    end
end
if isKeyDown(16) and isKeyJustPressed(187) and isKeyCheckAvailable() then
    actmentpidor = not actmentpidor
    ScriptStateKo = not ScriptStateKo
    ScriptState4 = not ScriptState4
    showa = not showa
end
if isKeyJustPressed(_G['VK_'..mainini.functions.fastnosoft]) and isKeyCheckAvailable() then
    if wh then
        nameTagOff()
        wh = false
        actmentpidor = false
        ScriptState = false
        ScriptState2 = false
        ScriptStateSliva = false
        ScriptState3 = false
        ScriptState4 = false
        ScriptStateKo = false
        ScriptStateGrib = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false
        on = false
        showa = false
    else
        wh = false
        actmentpidor = false
        ScriptState = false
        ScriptState2 = false
        ScriptState3 = false
        ScriptStateSliva = false
        ScriptState4 = false
        ScriptStateKo = false
        ScriptStateGrib = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false
        on = false
        showa = false
    end
end

if isKeyDown(16) and isKeyJustPressed(113) and isKeyCheckAvailable() then
    captureon = not captureon 
    if captureon and wh then
        printStringNow("~P~LEGAL ~G~ON", 1500, 5)
        nameTagOff()
        wh = false
        actmentpidor = false
        sound = false
        sound1 = false
        statesl = false
        cameraRestorePatch(false)
        activeextra = false
        ScriptState = false
        ScriptState2 = false
        ScriptStateSliva = false
        ScriptState3 = false
        ScriptState4 = false
        ScriptStateKo = false
        ScriptStateGrib = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false
        showa = false

        on = false
    elseif captureon then
        printStringNow("~P~LEGAL ~G~ON", 1500, 5)
        wh = false
        sound = false
        sound1 = false
        statesl = false
       actmentpidor = false
        cameraRestorePatch(false)
        activeextra = false
        ScriptState = false
        ScriptState2 = false
        ScriptStateKo = false
        ScriptStateSliva = false
        ScriptStateGrib = false
        ScriptState3 = false
        ScriptState4 = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false
        showa = false

        on = false
    else
        printStringNow("~P~LEGAL ~R~OFF", 1500, 5)
    end
end


if isPlayerPlaying(PLAYER_HANDLE) and isCharOnFoot(PLAYER_PED) and isKeyCheckAvailable() then
    if isKeyJustPressed(_G['VK_'..mainini.config.sbiv]) and not captureon then  taskPlayAnim(playerPed, "HANDSUP", "PED", 4.0, false, false, false, false, 4) 
    end 
end
if isKeyCheckAvailable() then
    if isKeyJustPressed(_G['VK_'..mainini.config.allsbiv]) then  wait(100) clearCharTasksImmediately(PLAYER_PED) 
    end 
end
if isKeyJustPressed(_G['VK_'..mainini.config.suicide]) and not isPlayerDead(playerHandle) then setCharHealth(playerPed, 0) 
end
if  isKeyJustPressed(_G['VK_'..mainini.config.wh]) and isKeyCheckAvailable() and not captureon then
   -- musorasosat = not musorasosat
    --onfp = not onfp
   -- actmentpidor = not actmentpidor
    wh = not wh
    if wh then
        nameTagOn()
        addOneOffSound(0.0, 0.0, 0.0, 1139)
    else 
        nameTagOff()
        addOneOffSound(0.0, 0.0, 0.0, 1138)
    end
end
if isKeyDown(119) then
    if wh then 
        nameTagOff()
        wait(1000)
        nameTagOn()
    end
end

if rewesl and statesl then 
    local clr = join_argb(0, 133, 17, 17)
    local r,g,b = 133, 17, 17
    writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
else
    local clr = join_argb(0, 128, 46, 46)
    local r,g,b = 128, 46, 46
    writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
end

if rewesl and statesl and settings.show_circle and isKeyDown(2) and isCharOnFoot(1) and getDamage(getCurrentCharWeapon(1)) then
    local px = getpx()
    local step = px / 1e4
    for i = 0, 6.28, step do
        if
            i > PI * 1.875 or i < PI * 0.125 or
            i > PI * 0.875 and i < PI * 1.125 or
            i > PI * 0.375 and i < PI * 0.625 or
            i > PI * 1.375 and i < PI * 1.625
        then
            renderDrawBox(xc + math.cos(i) * px, yc + math.sin(i) * px, 3, 3, 0x55007FFF)
        end
    end
end


    end
end

--[[ function sp.onSendClickTextDraw(id)
    local x, y = sampTextdrawGetPos(id)
    model, rotX, rotY, rotZ, zoom, clr1, clr2 = sampTextdrawGetModelRotationZoomVehColor(id)
    posX,  posY = sampTextdrawGetPos(id)
    sampAddChatMessage(("SendClick ID: %s, Model: %s, x : %s, y: %s, z: %s | x : %s, y: %s"):format(id, sampTextdrawGetModelRotationZoomVehColor(id), rotX, rotY, rotZ, posX, posY), 0xCC0000)
end ]]



function sp.onSendBulletSync(data)
    if rewesl then
        if getCurrentCharWeapon(playerPed) == 24 then
            math.randomseed(os.clock())
            if not statesl then return end
            local weap = getCurrentCharWeapon(1)
            if not getDamage(weap) then return end
            local id, ped = getClosestPlayerFromCrosshair()
            if id == -1 then return debugSay('� ���� ������ ������� �� ���� ������� �������') end
            local vmes =	sampGetPlayerNickname(id) .. ' > ' .. math.floor(getDistanceFromPed(ped)) .. 'm > ' ..
                    math.floor(getCharSpeed(1) * 3) .. ' vs ' .. math.floor(getCharSpeed(ped) * 3) .. ' > '
            if data.targetType == 1 then return debugSay(vmes .. '{008000}��� ������ ����') end
            if math.random(1, 100) < settings.miss_ratio and not isKeyDown(VK_Q) then return debugSay(vmes .. '{40E0D0}�������� ��������') end
            if not getcond(ped) then return debugSay(vmes .. '{FFA500}����� �� ����������') end
            debugSay(vmes .. '{FF0000}�������� ���')
            data.targetType = 1
            local px, py, pz = getCharCoordinates( ped )
            data.targetId = id

            data.target = { x = px + rand(), y = py + rand(), z = pz + rand() }
            data.center = { x = rand(), y = rand(), z = rand() }

            lua_thread.create(function ()
                wait(1)
                sampSendGiveDamage(id, getDamage(weap), weap, 3)
                addBlood(px, py, pz, 0.0, 0.0, 0.0, 5, 1)
            end)
        end
        if getCurrentCharWeapon(playerPed) == 23 or getCurrentCharWeapon(playerPed) == 22 or getCurrentCharWeapon(playerPed) == 28 then
            math.randomseed(os.clock())
            if not statesl then return end
            local weap = getCurrentCharWeapon(1)
            if not getDamage(weap) then return end
            local id, ped = getClosestPlayerFromCrosshair()
            if id == -1 then return debugSay('� ���� ������ ������� �� ���� ������� �������') end
            local vmes =	sampGetPlayerNickname(id) .. ' > ' .. math.floor(getDistanceFromPed(ped)) .. 'm > ' ..
                    math.floor(getCharSpeed(1) * 3) .. ' vs ' .. math.floor(getCharSpeed(ped) * 3) .. ' > '
            if data.targetType == 1 then return debugSay(vmes .. '{008000}��� ������ ����') end
            if math.random(1, 100) < 0 and not isKeyDown(VK_Q) then return debugSay(vmes .. '{40E0D0}�������� ��������') end
            if not getcond(ped) then return debugSay(vmes .. '{FFA500}����� �� ����������') end
            debugSay(vmes .. '{FF0000}�������� ���')
            data.targetType = 1
            local px, py, pz = getCharCoordinates( ped )
            data.targetId = id

            data.target = { x = px + rand(), y = py + rand(), z = pz + rand() }
            data.center = { x = rand(), y = rand(), z = rand() }

            lua_thread.create(function ()
                wait(1)
                sampSendGiveDamage(id, getDamage(weap), weap, 3)
                addBlood(px, py, pz, 0.0, 0.0, 0.0, 5, 1)
            end)
        end
    end
end

--[[ 
local logging = false
function sp.onPlayerJoin(playerId, color, isNpc, nickname)
    if logging then
    lua_thread.create(function()
        wait(15000)
         
	if sampGetPlayerScore(playerId) < 4 then
        wait(5000)
    sampSendChat("/id "..nickname)
        --sampAddChatMessage('�������� ������� '..nickname.."("..playerId..") ����� � ����.", -1)
        --notf.addNotification(string.format("%s \n�����-�� ��� � �������� Nuestra\n\n"..nickname.."("..playerId..") ����� � ����." , os.date()), 10)
	end
end)
end
end 

function sp.onPlayerJoin(playerId, color, isNpc, nickname)
    if nickname == "Chief_Cannon" then
        sendvknotf0("��� � ����!")
    end
end

function sp.onPlayerQuit(playerId, reason)
	if logginggh then
		if reason == 0 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") ����� �� ����.", -1)
		elseif reason == 1 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") ����� �� ����.", -1)
		elseif reason == 2 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") ����� �� ����.", -1)
		end
	end
end]]

function gopay()
    lua_thread.create(function()
        sampSendChat('/fammenu')
        wait(100) sampSendClickTextdraw(2073)
        wait(10) sampSendDialogResponse(2763, 1, 9, -1)
    end)    
end


function join_argb(a, b, g, r)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

function onHotKey(id, keys)
	local sKeys = tostring(table.concat(keys, " "))
	for k, v in pairs(tBindList) do
		if sKeys == tostring(table.concat(v.v, " ")) and isKeyCheckAvailable() and mainini.functions.binder then
			if tostring(v.text):len() > 0 then
				local bIsEnter = string.match(v.text, "(.)%[enter%]$") ~= nil
				if bIsEnter then
					sampSendChat(v.text:gsub("%[enter%]$", ""))
				else
					sampSetChatInputText(u8(v.text))
					sampSetChatInputEnabled(true)
				end
			end
		end
	end
end

addEventHandler("onWindowMessage", function (msg, wparam, lparam)
	if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
		if tEditData.id > -1 then
			if wparam == vkeys.VK_ESCAPE then
				tEditData.id = -1
				consumeWindowMessage(true, true)
			elseif wparam == vkeys.VK_TAB then
				bIsEnterEdit.v = not bIsEnterEdit.v
				consumeWindowMessage(true, true)
			end
		end
	end
end)

function onScriptTerminate(scr, quitgame)
    if scr == thisScript() then
        if marker or checkpoint or mark or dtext then
            removeUser3dMarker(mark)
            deleteCheckpoint(marker)
            removeBlip(checkpoint)
            sampDestroy3dText(dtext)
        end 
        if wh then
            nameTagOff()
        end
        sendvknotf(":-( ������ ������������ ��� ���������...")
    end 
end

tblclosetest = {['50.83'] = 50.84, ['49.9'] = 50, ['49.05'] = 49.15, ['48.2'] = 48.4, ['47.4'] = 47.6, ['46.5'] = 46.7, ['45.81'] = '45.84',
['44.99'] = '45.01', ['44.09'] = '44.17', ['43.2'] = '43.4', ['42.49'] = '42.51', ['41.59'] = '41.7', ['40.7'] = '40.9', ['39.99'] = 40.01,
['39.09'] = 39.2, ['38.3'] = 38.4, ['37.49'] = '37.51', ['36.5'] = '36.7', ['35.7'] = '35.9', ['34.99'] = '35.01', ['34.1'] = '34.2';}
tblclose = {}
sendcloseinventory = function()
	sampSendClickTextdraw(tblclose[1])
end

function numberToTable(int)
    local t = {}
    local int = tostring(int)
    for i = 1, #int do
        table.insert(t, tonumber(int:sub(i, i)))
    end
    return t
end

function onReceiveRpc(id, bs)
	if info ~= nil and id == 83 then -- // SelectTextDraw RPC
		return false -- // �� ��� ������� ��������
	end
    if sundukwork and id == 83 then -- // SelectTextDraw RPC
		return false -- // �� ��� ������� ��������
	end
end

function sp.onShowTextDraw(id, data)

--[[ 
        if id == 527 or id == 528 or id == 521 or id == 523 or id == 524 or id == 525 or id == 526 or id == 522 or id == 520 then
            return false
        end ]]

        --fast gun
        if info ~= nil then
            if info.step == 0 then
                if data.modelId == info.model then
                    local rot = data.rotation
                    if rot.x == info.rot.x and rot.y == info.rot.y and rot.z == info.rot.z then
                        sampSendClickTextdraw(id)
                        info.clock = os.clock()
                        info.step = 1
                    end
                end
            elseif info.step == 1 then
                if id == 2302 then
                    sampSendClickTextdraw(id)
                    sampSendClickTextdraw(0xFFFF)
                    info.clock = os.clock()
                    info.step = 3
                end
            end
            return false
        end

	--sampAddChatMessage("ID: "..id.."\nData_modelId: "..data.modelId..'\nData_Pos_X: '..data.position.x..'\nData_Pos_Y: '..data.position.y, -1)
	if data.modelId == mod and cmd == 1 then
		cmd = 0
		sampSendClickTextdraw(id)
		thr2:run()	
end

for w, q in pairs(tblclosetest) do
    if data.lineWidth >= tonumber(w) and data.lineWidth <= tonumber(q) and data.text:find('^LD_SPAC:white$') then
        for i=0, 2 do rawset(tblclose, #tblclose + 1, id) end
    end
end

if automeatbag then
    lua_thread.create(function()
        if data.modelId == 2805 then
          wait(111)
          sampSendClickTextdraw(id)
          usembag = true
        end
        if data.text == 'PUT' and usembag then
            clickID = id + 1
            sampSendClickTextdraw(clickID)
            usembag = false
            close = true
        end
        if close then
            wait(111)
            sampSendClickTextdraw(65535)
            close = false
            automeatbag = false
            wait(500)
            sampSendChat("/meatbag")
          end
    end)
end 

if work and sundukwork then
    if mainini.sunduk.checkbox_standart and data.modelId == 19918 then textdraw[1][1] = id  end
    if mainini.sunduk.checkbox_platina and data.modelId == 1353 then textdraw[2][1] = id  end
    if mainini.sunduk.checkbox_mask and data.modelId == 1733 then textdraw[3][1] = id  end
    if mainini.sunduk.checkbox_donate and data.modelId == 19613 then textdraw[4][1] = id  end
    if mainini.sunduk.checkbox_tainik and data.modelId == 2887 then textdraw[5][1] = id  end
    if data.text == 'USE' or data.text == '�C�O���O�A��' then 
        textdraw[1][2] = id + 1
        textdraw[2][2] = id + 1
        textdraw[3][2] = id + 1
        textdraw[4][2] = id + 1
        textdraw[5][2] = id + 1
    end
    return false
end

end



function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function separator(text)
	if text:find("$") then
	    for S in string.gmatch(text, "%$%d+") do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, "%d+%$") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function doKeyCheck()
    if not isKeyCheckAvailable() then return end
    local isInVeh = isCharInAnyCar(playerPed)
    local veh = nil
    if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
      if isKeyDown(16) and isInVeh and not captureon then setCarProofs(veh, true, true, true, true, true) end
    doCheatWork()
  end  
  function doCheatWork()
    local isInVeh = isCharInAnyCar(playerPed)
    local veh = nil
    if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
    if gmcar == true and isInVeh then
      setCarProofs(veh, true, true, true, true, true)
    end
  end
	function sp.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
        if dotmoney then
		    text = separator(text)
		    return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
        end
	end
    function se.onSetObjectMaterialText(id, data)
        local object = sampGetObjectHandleBySampId(id)
        if object and doesObjectExist(object) then
            if getObjectModel(object) == 18663 then
                if string.find(data.text, "��������: [A-z0-9_]+") then
                    last = {
                        vehicle = nil,
                        price = nil,
                        tuning = nil
                    }
    
                    local tuning = string.match(data.text, "\n\n\n([^\n]+)\n\n��������: [A-z0-9_]+\n{%x+}id: %d+")
                    if tuning and last ~= nil then
                        last.tuning = string.gsub(tuning, "{%x+}", "")
                    end
                end
                
                local vehicle, color, price = string.match(data.text, "([^\n]+)\n({%x+})%$(%d+)")
                if vehicle and color and price and last ~= nil then
                    last.vehicle = vehicle
                    last.price = sum_format(price)
                    data.text = string.format("%s\n%s$%s\n\n\n\n", last.vehicle, color, last.price)
    

    
                    return { id, data }
                end
            end
        end
    end

    function sum_format(sum)
        sum = tostring(sum)
        if sum ~= nil and #sum > 3 then
            local b, e = ('%d'):format(sum):gsub('^%-', '')
            local c = b:reverse():gsub('%d%d%d', '%1.')
            local d = c:reverse():gsub('^%.', '')
            return (e == 1 and '-' or '')..d
        end
        return sum
    end

function sp.onSendPlayerSync(data)
    if bit.band(data.keysData, 0x28) == 0x28 then
        data.keysData = bit.bxor(data.keysData, 0x20)
    end
end



function ClearChat()
    local memory = require "memory"
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function arec()
    if mainini.functions.arecc then
        local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." or chatstring == "������ ������ ����������." or chatstring == "Wrong server password." or chatstring == "Use /quit to exit or press ESC and select Quit Game" then
        sampDisconnectWithReason(false)
        
    sendvknotf("�������� �������������...")
        wait(3000)
        --printStringNow("~B~AUTORECONNECT", 3000)
            wait(20000) -- ��������
            sampSetGamestate(1)
        end 
    end
end 

function timeweat()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
    if mainini.stsw.Static then
        if mainini.stsw.Time ~= memory.read(0xB70153, 1, false) then memory.write(0xB70153, mainini.stsw.Time, 1, false) end
        if mainini.stsw.Weather ~= memory.read(0xC81320, 2, false) then memory.write(0xC81320, mainini.stsw.Weather, 2, false) end
    end
end
end

function reconnect()
  lua_thread.create(function ()
  sampDisconnectWithReason(quit)
  wait(3000)
  --printStringNow("~B~RECONNECT", 3000)
  wait(2000) -- ��������
  sampSetGamestate(1) end)
end


function autoshar()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
    local text = sampTextdrawGetString(2069)
    if text:match("%[ ~p~%u+~w~ %]") then
    setGameKeyState(16, 255)
    setGameKeyState(21, 255)
    setGameKeyState(9, 255)
    wait(100)
    setGameKeyState(16, 0)
    setGameKeyState(21, 0)
    setGameKeyState(9, 0)
    end
end
end

function targetfunc()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        
local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
if valid and doesCharExist(ped) then
    local result, id = sampGetPlayerIdByCharHandle(ped)
    if result then
        local name = sampGetPlayerNickname(id)
        local nickk = string.match(name, '(.*)_')
        local nickkk = string.match(name, '_(.*)')
        local namee = string.gsub(name, "_", " ");
        local lvlped = sampGetPlayerScore(id)
        if isKeyJustPressed(_G['VK_'..mainini.target.cure]) and isKeyCheckAvailable() then 
            sampSendChat(string.format('/cure %s', id))
        end        
        if isKeyJustPressed(_G['VK_'..mainini.target.kiss]) and isKeyCheckAvailable() then 
            sampSendChat(string.format('/kiss %s', id))
        end
        if isKeyJustPressed(_G['VK_'..mainini.target.free]) and isKeyCheckAvailable() then 
            sampSetChatInputText(string.format("/free %s ", id))
            sampSetChatInputEnabled(true)
        end
        if mainini.oboss.piss1 then
            if isKeyJustPressed(_G['VK_'..mainini.oboss.obossactiv]) and isKeyCheckAvailable() then 
                sampSendChat(string.format(mainini.oboss.pisstext, nickk))
                poss = true
            end
        elseif mainini.oboss.piss2 then
            if isKeyJustPressed(_G['VK_'..mainini.oboss.obossactiv]) and isKeyCheckAvailable() then 
                sampSendChat(string.format(mainini.oboss.pisstext, namee))
                poss = true
            end
        elseif mainini.oboss.piss3 then
            if isKeyJustPressed(_G['VK_'..mainini.oboss.obossactiv]) and isKeyCheckAvailable() then 
                sampSendChat(string.format(mainini.oboss.pisstext, name))
                poss = true
            end
        end

        if mainini.lidzamband.devyatka and isKeyJustPressed(219) and isKeyCheckAvailable() then
            if sampGetPlayerScore(id) >= mainini.lidzamband.minlvl then
                sampSendChat(string.format("/todo ������ ��� ��� �� ����*����� � ���� %s ���������� ������� %s", namee, mainini.lidzamband.band))
                wait(500)
                sampSendChat(string.format('/invite %s', name))
                wait(3000)
                sampSendChat(string.format('/giverank %s %s', name, mainini.lidzamband.minrank))
            else
                sampSendChat(string.format("%s, � ���� ����� %s �������� ����� � %s ��� ���������� � �����", namee, mainini.lidzamband.band, mainini.lidzamband.minlvl))
            end
        end
        if mainini.lidzamband.devyatka and isKeyJustPressed(221) and isKeyCheckAvailable() then
            sampSendChat(string.format("/todo ������ ��� ��� �� ����*����� � ���� %s ����������� ������� %s", namee, mainini.lidzamband.band))
            wait(500)
            sampSendChat(string.format('/invite %s', name))
            wait(3000)
            sampSendChat(string.format('/giverank %s 8', name))
            -- ������ ���� ����������� �������� � ��� � �����������

        end
        if mainini.lidzamband.devyatka and isKeyJustPressed(187) and isKeyCheckAvailable() then
            sampSetChatInputText(string.format('/giveskin %s ', id))
            sampSetChatInputEnabled(true)
        end
        if mainini.lidzamband.devyatka and isKeyJustPressed(189) and isKeyCheckAvailable() then
            sampSetChatInputText(string.format('/giverank %s ', id))
            sampSetChatInputEnabled(true)
        end
    end
end


if poss and isKeyJustPressed(_G['VK_'..mainini.oboss.pissactiv]) and isKeyCheckAvailable() then 
    sampSetSpecialAction(68)
    poss = false
end
if poss and isKeyJustPressed(_G['VK_'..mainini.oboss.animactiv]) and isKeyCheckAvailable() then 
    sampSendChat('/anim 85')
    poss = false
end
    end
end
        



function dHits()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
    if rewedhits then
        if getCurrentCharWeapon(playerPed) == 24 and getAmmoInClip() ~= 1 then
    if isKeyJustPressed(VK_E) and isKeyCheckAvailable() and isCharOnFoot(PLAYER_PED) then
            setVirtualKeyDown(1, true)
            wait(100)
            setVirtualKeyDown(1, false)
            wait(50)
            setVirtualKeyDown(2, true)
            wait(126)
            setVirtualKeyDown(vkeys.VK_C, true)
            wait(44)
            setVirtualKeyDown(vkeys.VK_C, false)
            wait(5)
            setVirtualKeyDown(1, true)
            wait(50)
            setVirtualKeyDown(1, false)
            wait(20)
            setVirtualKeyDown(2, false)
            wait(50)
            setVirtualKeyDown(vkeys.VK_C, true)
            wait(50)
            setVirtualKeyDown(vkeys.VK_C, false)
        end
        if getAmmoInClip() == 1 then
            setCurrentCharWeapon(PLAYER_PED, 0) -- �������� �� ����
            sampForceOnfootSync() -- ���������� ������������� ��� ���� ����� � ��� ������ ����� � ���� �� ��� �� ��������� �� ������ ����
            wait(200) -- ���� �������� �������, ��� ������������ � �������������, �.� 1000�� = 1�, ����� ����������� �������� 200-300 ��
            setCurrentCharWeapon(PLAYER_PED, 24) -- �������� ������� �� ����
        end
    end
    end
end
    end

    function cameraRestorePatch(qqq) 
        if qqq then
            if not patch_cameraRestore then
                patch_cameraRestore1 = memory.read(0x5109AC, 1, true)
                patch_cameraRestore2 = memory.read(0x5109C5, 1, true)
                patch_cameraRestore3 = memory.read(0x5231A6, 1, true)
                patch_cameraRestore4 = memory.read(0x52322D, 1, true)
                patch_cameraRestore5 = memory.read(0x5233BA, 1, true)
            end
            memory.write(0x5109AC, 235, 1, true)
            memory.write(0x5109C5, 235, 1, true)
            memory.write(0x5231A6, 235, 1, true)
            memory.write(0x52322D, 235, 1, true)
            memory.write(0x5233BA, 235, 1, true)
        elseif patch_cameraRestore1 ~= nil then
            memory.write(0x5109AC, patch_cameraRestore1, 1, true)
            memory.write(0x5109C5, patch_cameraRestore2, 1, true)
            memory.write(0x5231A6, patch_cameraRestore3, 1, true)
            memory.write(0x52322D, patch_cameraRestore4, 1, true)
            memory.write(0x5233BA, patch_cameraRestore5, 1, true)
            patch_cameraRestore1 = nil
        end
    end



function tormoz()
    while true do wait(0)
        if not captureon then
--[[             if isCharInAnyCar(PLAYER_PED) and isKeyDown(90) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
                local veh = storeCarCharIsInNoSave(PLAYER_PED)
                repeat
                    local speed = getCarSpeed(veh)
                    setCarForwardSpeed(veh, speed - 0.5)
                    wait(0)
                until speed > 0
            end ]]
            if isCharInAnyCar(playerPed) then 
                local car = storeCarCharIsInNoSave(playerPed)
                local speed = getCarSpeed(car)
               -- isCarInAirProper(car)
                setCarCollision(car, true)
                    if isKeyDown(VK_LMENU) and isVehicleOnAllWheels(car) and doesVehicleExist(car) and speed > 5.0 then
                   setCarCollision(car, false)
                        if isCarInAirProper(car) then setCarCollision(car, true)
                        if isKeyDown(VK_A)
                        then 
                        addToCarRotationVelocity(car, 0, 0, 0.13)
                        end
                        if isKeyDown(VK_D)
                        then 			
                        addToCarRotationVelocity(car, 0, 0, -0.13)	
                        end
                    end
                end
            end
            if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() and not isCharOnAnyBike(PLAYER_PED) then
                if isKeyJustPressed(56) and isKeyCheckAvailable() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then cruise = not cruise end
                if cruise then
                    local veh = storeCarCharIsInNoSave(PLAYER_PED)
                    setCarCruiseSpeed(veh, 60.0)
                    setGameKeyState(16, 255)
                end  
            end 
            if isCharInAnyCar(PLAYER_PED) and isKeyJustPressed(_G['VK_'..mainini.config.tramp]) and isKeyCheckAvailable() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
                local veh = storeCarCharIsInNoSave(PLAYER_PED)
                local vle = getCarHeading(veh)
                local ofX, ofY, ofZ = getOffsetFromCarInWorldCoords(veh, 0.0, 24.5, -1.3)
                local object = createObject(1634, ofX, ofY, ofZ) 
                local ole = getObjectHeading(object)
                setObjectHeading(object, vle)
                wait(3500)
                deleteObject(object)
            end
            if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() then
                local veh = storeCarCharIsInNoSave(PLAYER_PED)
                local speed = getCarSpeed(veh)
                if speed >= 0 and not isCarInAirProper(veh) and isKeyDown(87) and isKeyDown(2) and isKeyCheckAvailable() then
                    setCarForwardSpeed(veh, speed + 3.8)
                    wait(100)
                end	  
            end
        end
    end
end

function autoC()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        if reweautoc then
            if getCurrentCharWeapon(playerPed) == 24 and getAmmoInClip() ~= 1 then
                if isKeyDown(2) and isKeyJustPressed(VK_XBUTTON2) then
                setCharAnimSpeed(playerPed, "python_fire", 1.337)
                setGameKeyState(17, 255)
                wait(55)
                setGameKeyState(6, 0)
                setGameKeyState(18, 255)
                setCharAnimSpeed(playerPed, "python_fire", 1.0)
                end
            end
        end
    end
end


function getAmmoInClip()
    return memory.getuint32(getCharPointer(PLAYER_PED) + 0x5A0 + getWeapontypeSlot(getCurrentCharWeapon(PLAYER_PED)) * 0x1C + 0x8)
end

function fastrun()
    while true do
        wait(0)
        for i = 0, sampGetMaxPlayerId(false) do
			if sampIsPlayerConnected(i) then
				local result, id = sampGetCharHandleBySampPlayerId(i)
				if result then
					if doesCharExist(id) then
						local x, y, z = getCharCoordinates(id)
						local mX, mY, mZ = getCharCoordinates(playerPed)
						if 0.4 > getDistanceBetweenCoords3d(x, y, z, mX, mY, mZ) then
							setCharCollision(id, false)
						end
					end
				end
			end
        end
    mem.setint8(0xB7CEE4, 1)
    if isKeyDown(16) and isCharOnAnyBike(PLAYER_PED) and not captureon then
        setCharCanBeKnockedOffBike(PLAYER_PED, true)
    else
        setCharCanBeKnockedOffBike(PLAYER_PED, false)
    end
    if isCharOnAnyBike(PLAYER_PED) and isCarInWater(storeCarCharIsInNoSave(PLAYER_PED)) then
        setCharCanBeKnockedOffBike(PLAYER_PED, false)
    end

        if isKeyDown(46) and isCharInAnyCar(PLAYER_PED) and isKeyCheckAvailable() then
            addToCarRotationVelocity(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.2, 0.0)
        end
        if isKeyDown(123) and isCharInAnyCar(PLAYER_PED) and isKeyCheckAvailable() then
            addToCarRotationVelocity(storeCarCharIsInNoSave(PLAYER_PED), 0.0, -0.2, 0.0)
        end
        if isCharInAnyCar(playerPed) then
			local myCar = storeCarCharIsInNoSave(playerPed)
			local iAm = getDriverOfCar(myCar)
			if iAm == playerPed then
				if isKeyDown(1) and isKeyCheckAvailable() and not sampIsCursorActive() and not captureon then
					giveNonPlayerCarNitro(myCar)
					while isKeyDown(1) do
						wait(0)
						mem.setfloat(getCarPointer(myCar) + 0x08A4, -0.5)
					end
					removeVehicleMod(myCar, 1008)
					removeVehicleMod(myCar, 1009)
					removeVehicleMod(myCar, 1010)
				end
			else
				 while isCharInAnyCar(playerPed) do
					 wait(0)
				 end
			end 
	 	end

        if isCharOnAnyBike(PLAYER_PED) and isKeyCheckAvailable() then
			local bike = {[481] = true, [509] = true, [510] = true, [14914] = true, [14916] = true}
			if bike[getCarModel(storeCarCharIsInNoSave(PLAYER_PED))] and isKeyJustPressed(67) and not isKeyDown(18) then
				setVirtualKeyDown(0x11, true)
				wait(300)
				setVirtualKeyDown(0x11, false)
				local veh = storeCarCharIsInNoSave(PLAYER_PED)
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
				if not isCarInAirProper(veh) and cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.44, 0.0, 0.0, 0.0)
                end
            end
        end
    if isCharOnFoot(playerPed) and isKeyDown(_G['VK_'..mainini.config.shook]) and isKeyCheckAvailable() then -- onFoot&inWater SpeedUP [[1]] --
        setGameKeyState(16, 256)
        wait(10)
        setGameKeyState(16, 0)
    elseif isCharInWater(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then
        setGameKeyState(16, 256)
        wait(10)
        setGameKeyState(16, 0)
    end
    if isCharOnAnyBike(playerPed) and isKeyCheckAvailable() and isKeyDown(87) and isKeyDown(16) then	-- onBike&onMoto SpeedUP [[LSHIFT]] --
        if bike[getCarModel(storeCarCharIsInNoSave(playerPed))] then
            setGameKeyState(16, 255)
            wait(10)
            setGameKeyState(16, 0)
        elseif moto[getCarModel(storeCarCharIsInNoSave(playerPed))] then
            setGameKeyState(1, -128)
            wait(10)
            setGameKeyState(1, 0)
        end
    end
end
end
function naborg(arg)
	while true do wait(0)
		if naborgon then
			sampSendChat(mainini.lidzamband.naborgtext)
			wait(mainini.lidzamband.naborgwait * 1000)
		end
	end
end
function floodg1(arg)
	while true do wait(0)
		if floodong1 then
			sampSendChat(mainini.lidzamband.fltext1)
			wait(mainini.lidzamband.flwait1 * 1000)
		end
	end
end
function floodg2(arg)
	while true do wait(0)
		if floodong2 then
			sampSendChat(mainini.lidzamband.fltext2)
			wait(mainini.lidzamband.flwait2 * 1000)
		end
	end
end
function floodg3(arg)
	while true do wait(0)
		if floodong3 then
			sampSendChat(mainini.lidzamband.fltext3)
			wait(mainini.lidzamband.flwait3 * 1000)
		end
	end
end
function floodg4(arg)
	while true do wait(0)
		if floodong4 then
			sampSendChat(mainini.lidzamband.fltext4)
			wait(mainini.lidzamband.flwait4 * 1000)
		end
	end
end
function floodg5(arg)
	while true do wait(0)
		if floodong5 then
			sampSendChat(mainini.lidzamband.fltext5)
			wait(mainini.lidzamband.flwait5 * 1000)
		end
	end
end
function floodg6(arg)
	while true do wait(0)
		if floodong6 then
			sampSendChat(mainini.lidzamband.fltext6)
			wait(mainini.lidzamband.flwait6 * 1000)
		end
	end
end
function floodg7(arg)
	while true do wait(0)
		if floodong7 then
			sampSendChat(mainini.lidzamband.fltext7)
			wait(mainini.lidzamband.flwait7 * 1000)
		end
	end
end
function floodg8(arg)
	while true do wait(0)
		if floodong8 then
			sampSendChat(mainini.lidzamband.fltext8)
			wait(mainini.lidzamband.flwait8 * 1000)
		end
	end
end
function floodg9(arg)
	while true do wait(0)
		if floodong9 then
			sampSendChat(mainini.lidzamband.fltext9)
			wait(mainini.lidzamband.flwait9 * 1000)
		end
	end
end
function flood1(arg)
	while true do wait(0)
		if floodon1 then
			sampSendChat(mainini.flood.fltext1)
			wait(mainini.flood.flwait1 * 1000)
		end
	end
end
function flood2(arg)
	while true do wait(0)
		if floodon2 then
			sampSendChat(mainini.flood.fltext2)
			wait(mainini.flood.flwait2 * 1000)
		end
	end
end
function flood3(arg)
	while true do wait(0)
		if floodon3 then
			sampSendChat(mainini.flood.fltext3)
			wait(mainini.flood.flwait3 * 1000)
		end
	end
end
function flood4(arg)
	while true do wait(0)
		if floodon4 then
			sampSendChat(mainini.flood.fltext4)
			wait(mainini.flood.flwait4 * 1000)
		end
	end
end
function flood5(arg)
	while true do wait(0)
		if floodon5 then
			sampSendChat(mainini.flood.fltext5)
			wait(mainini.flood.flwait5 * 1000)
		end
	end
end


function chatchatVK()
    vklchat = not vklchat
    if vklchat then
        vknotf.chatc = true
    else
        vknotf.chatc = false
    end
    sendvknotf('���� ��� '..(vklchat and '�������!' or '��������!'))
end
function famchatVK()
    vklchatfam = not vklchatfam
    if vklchatfam then
        vknotf.chatf = true
    else
        vknotf.chatf = false
    end
    sendvknotf('Fam ��� '..(vklchatfam and '�������!' or '��������!'))
end
function advchatVK()
    vklchatadv = not vklchatadv
    if vklchatadv then
        vknotf.chatadv = true
    else
        vknotf.chatadv = false
    end
    sendvknotf('����������� ��� '..(vklchatadv and '�������!' or '��������!'))
end
function alldialogsVK()
    vklchatdialog = not vklchatdialog
    if vklchatdialog then
        vknotf.dialogs = true
    else
        vknotf.dialogs = false
    end
    sendvknotf('������� '..(vklchatdialog and '��������!' or '���������!'))
end
function razgovorVK()
    trubka = not trubka
    if trubka then
        sampSendClickTextdraw(2108)
        sendvknotf('�������� �����!')
    else
        sampSendChat('/phone')
        sendvknotf('������ �������!')
    end
end
--[[ function poddVK()
    podderjk = not podderjk
    if podderjk then
        sendvknotf(supsettings)
    else
        sendvknotf(supsettings2)
    end
end ]]

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	NTdist = mem.getfloat(pStSet + 39) -- ���������
	NTwalls = mem.getint8(pStSet + 47) -- ��������� ����� �����
	NTshow = mem.getint8(pStSet + 56) -- ��������� �����
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
end
function nameTagOff()
    local pStSet = sampGetServerSettingsPtr()
    mem.setfloat(pStSet + 39, NTdist)
    mem.setint8(pStSet + 47, NTwalls)
    mem.setint8(pStSet + 56, NTshow)
end
function onExitScript()
	if NTdist then
		nameTagOff()
	end
end

function hphud()
	while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        useRenderCommands(true)
        setTextCentre(true) -- set text centered
        setTextScale(0.2, 0.7) -- x y size
        setTextColour(255--[[r]], 255--[[g]], 255--[[b]], 255--[[a]])
        setTextEdge(1--[[outline size]], 0--[[r]], 0--[[g]], 0--[[b]], 255--[[a]])
        displayTextWithNumber(578.0, 67.9, 'NUMBER', getCharHealth(PLAYER_PED))
        if getCharArmour(PLAYER_PED) > 0 then
            setTextCentre(true) -- set text centered
            setTextScale(0.2, 0.7) -- x y size
            setTextColour(255--[[r]], 255--[[g]], 255--[[b]], 255--[[a]])
            setTextEdge(1--[[outline size]], 0--[[r]], 0--[[g]], 0--[[b]], 255--[[a]])
            displayTextWithNumber(578.0, 46.0, 'NUMBER', getCharArmour(PLAYER_PED))
        end
    end
end
function proops()
	while true do
        if isKeyDown(16) and isCharInAnyCar(PLAYER_PED) and not captureon then
		local isDriver, car = getCarDrivenByPlayer(PLAYER_PED)
		if doesVehicleExist(car) and getCarSpeed(car) >= 10 then
			for i, object in ipairs(getAllObjects()) do
				local model = getObjectModel(object)
				if props[model] == true then
					sortOutObjectCollisionWithCar(object, car)
					if isVehicleTouchingObject(car, object) then
					 	breakObject(object, 0); break
					end
				end
			end
		end
    end 
		wait(0)
end
end
function camhack()
    while true do wait(0)
        if not captureon then
            time = time + 1
            if isKeyDown(VK_R) and isKeyDown(VK_1) then
                if flymode == 0 then
                    --setPlayerControl(playerchar, false)
                    displayRadar(false)
                    displayHud(false)	    
                    posX, posY, posZ = getCharCoordinates(playerPed)
                    angZ = getCharHeading(playerPed)
                    angZ = angZ * -1.0
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                    angY = 0.0
                    --freezeCharPosition(playerPed, false)
                    --setCharProofs(playerPed, 1, 1, 1, 1, 1)
                    --setCharCollision(playerPed, false)
                    lockPlayerControl(true)
                    flymode = 1
                --	sampSendChat('/anim 35')
                end
            end
            if flymode == 1 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
                offMouX, offMouY = getPcMouseMovement()  
                
                offMouX = offMouX / 4.0
                offMouY = offMouY / 4.0
                angZ = angZ + offMouX
                angY = angY + offMouY

                if angZ > 360.0 then angZ = angZ - 360.0 end
                if angZ < 0.0 then angZ = angZ + 360.0 end

                if angY > 89.0 then angY = 89.0 end
                if angY < -89.0 then angY = -89.0 end   

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0        
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                curZ = angZ + 180.0
                curY = angY * -1.0      
                radZ = math.rad(curZ) 
                radY = math.rad(curY)                   
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 10.0     
                cosZ = cosZ * 10.0       
                sinY = sinY * 10.0                       
                posPlX = posX + sinZ 
                posPlY = posY + cosZ 
                posPlZ = posZ + sinY              
                angPlZ = angZ * -1.0
                --setCharHeading(playerPed, angPlZ)

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0        
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_W) then      
                    radZ = math.rad(angZ) 
                    radY = math.rad(angY)                   
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)      
                    sinY = math.sin(radY)
                    cosY = math.cos(radY)       
                    sinZ = sinZ * cosY      
                    cosZ = cosZ * cosY 
                    sinZ = sinZ * speed      
                    cosZ = cosZ * speed       
                    sinY = sinY * speed  
                    posX = posX + sinZ 
                    posY = posY + cosZ 
                    posZ = posZ + sinY      
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)      
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0         
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_S) then  
                    curZ = angZ + 180.0
                    curY = angY * -1.0      
                    radZ = math.rad(curZ) 
                    radY = math.rad(curY)                   
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)      
                    sinY = math.sin(radY)
                    cosY = math.cos(radY)       
                    sinZ = sinZ * cosY      
                    cosZ = cosZ * cosY 
                    sinZ = sinZ * speed      
                    cosZ = cosZ * speed       
                    sinY = sinY * speed                       
                    posX = posX + sinZ 
                    posY = posY + cosZ 
                    posZ = posZ + sinY      
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0        
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2)
                
                if isKeyDown(VK_A) then  
                    curZ = angZ - 90.0
                    radZ = math.rad(curZ)
                    radY = math.rad(angY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    posX = posX + sinZ
                    posY = posY + cosZ
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0        
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)       

                if isKeyDown(VK_D) then  
                    curZ = angZ + 90.0
                    radZ = math.rad(curZ)
                    radY = math.rad(angY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)       
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    posX = posX + sinZ
                    posY = posY + cosZ      
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0        
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2)   

                if isKeyDown(VK_SPACE) then  
                    posZ = posZ + speed
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0       
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2) 

                if isKeyDown(VK_SHIFT) then  
                    posZ = posZ - speed
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end 

                radZ = math.rad(angZ) 
                radY = math.rad(angY)             
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)      
                sinY = math.sin(radY)
                cosY = math.cos(radY)       
                sinZ = sinZ * cosY      
                cosZ = cosZ * cosY 
                sinZ = sinZ * 1.0      
                cosZ = cosZ * 1.0     
                sinY = sinY * 1.0       
                poiX = posX
                poiY = posY
                poiZ = posZ      
                poiX = poiX + sinZ 
                poiY = poiY + cosZ 
                poiZ = poiZ + sinY      
                pointCameraAtPoint(poiX, poiY, poiZ, 2) 

                if keyPressed == 0 and isKeyDown(VK_F12) then
                    keyPressed = 1
                    if radarHud == 0 then
                        displayRadar(true)
                        displayHud(true)
                        radarHud = 1
                    else
                        displayRadar(false)
                        displayHud(false)
                        radarHud = 0
                    end
                end

                if wasKeyReleased(VK_F12) and keyPressed == 1 then keyPressed = 0 end

                if isKeyDown(187) then 
                    speed = speed + 0.01
                    printStringNow(speed, 1000)
                end 
                            
                if isKeyDown(189) then 
                    speed = speed - 0.01 
                    if speed < 0.01 then speed = 0.01 end
                    printStringNow(speed, 1000)
                end   

                if isKeyDown(VK_R) and isKeyDown(VK_2) then
                    --setPlayerControl(playerchar, true)
                    displayRadar(true)
                    displayHud(true)
                    radarHud = 0	    
                    angPlZ = angZ * -1.0
                    --setCharHeading(playerPed, angPlZ)
                    --freezeCharPosition(playerPed, false)
                    lockPlayerControl(false)
                    --setCharProofs(playerPed, 0, 0, 0, 0, 0)
                    --setCharCollision(playerPed, true)
                    restoreCameraJumpcut()
                    setCameraBehindPlayer()
                    flymode = 0     
                end
            end
        end
    end
end
function sp.onPlayerChatBubble(id, col, dist, dur, msg)
	if flymode == 1 then
		return {id, col, 1488, dur, msg}
	end
end

function rltao()
	while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        if sampTextdrawGetString(2103) and work then
            local textdrawtelefon = sampTextdrawGetString(2103)
            if (textdrawtelefon:find('Incoming') or textdrawtelefon:find('Outcoming')) then
                teleact = false
            elseif not (textdrawtelefon:find('Incoming') or textdrawtelefon:find('Outcoming')) then
                teleact = true
            end
        end

        if work then 
            if teleact then
                sampSendClickTextdraw(65535)
                wait(355)
                sundukwork = true
                fix = true
                sampSendChat("/donate")
                wait(3000)
                fix = false
                sampSendChat('/invent')
                wait(400)
                for i = 1, 5 do
                    if not work then break end
                    sampSendClickTextdraw(textdraw[i][1])
                    wait(textdraw[i][3])
                    sampSendClickTextdraw(textdraw[i][2])
                    wait(textdraw[i][3])
                end
                wait(100)
                sampSendClickTextdraw(65535)
                sundukwork = false
                wait(mainini.sunduk.waiting*60000)
            end
        end
    end
end

    ---- aafk vksend
    function workpaus(bool)
        if bool then
            mem.setuint8(7634870, 1)
            mem.setuint8(7635034, 1)
            mem.fill(7623723, 144, 8)
            mem.fill(5499528, 144, 6)
        else 
            mem.setuint8(7634870, 0)
            mem.setuint8(7635034, 0)
            mem.hex2bin('5051FF1500838500', 7623723, 8)
            mem.hex2bin('0F847B010000', 5499528, 6)
        end
    end
    close = false

    function sp.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
        if mainini.afk.uvedomleniya then
            sendvknotf('�� ������������ � �������!', hostName)
        end
    end
    function findDialog(id, dialog)
        for k, v in pairs(savepass[id][3]) do
            if v.id == dialog then
                return k
            end
        end
        return -1
    end
    function findAcc(nick, ip)
        for k, v in pairs(savepass) do
            if nick == v[1] and ip == v[2] then
                return k
            end
        end
        return -1
    end    

function sampGetListboxItemByText(text, plain)
    --if not sampIsDialogActive() then return -1 end
        plain = not (plain == false)
    for i = 0, sampGetListboxItemsCount() - 1 do
        if sampGetListboxItemText(i):find(text, 1, plain) then
            return i
        end
    end
    return -1
end
-----autopin
function sp.onShowDialog(id, style, title, button1, button2, text)

    if sendstatsstate and id == 235 then
		sampSendDialogResponse(id,0,0,'')
		sendstatsstate = text
		return false
	end

    --fast gun
    if info ~= nil then
		if info.step == 3 and string.find(text, "������� ����������") then
			sampSendDialogResponse(id, 1, nil, info.count)
			info = nil
			return false
		end
	end
   

    if fix and text:find("���� ���������� �����") then
		sampSendDialogResponse(id, 0, 0, "")
		sampAddChatMessage("{ffffff} inventory {ff0000}fixed{ffffff}!",-1)
       -- sendvknotf0("������� ������� �������")
        
		return false
        --fix = false
	end
    if text:find("�� ���� ������� �� ����������") and mainini.afk.uvedomleniya then
        sendvknotf0(text)
	--return false
        --fix = false
	end
    if id == 2 then
        if mainini.helper.password ~= "��������" then
            sampSendDialogResponse(id, 1, _, mainini.helper.password)
            return false
        end
    end
    if id == 15252 then
        if title:find('������ ���� �������') then	
            if text:find('� ����� �� ��') then
                text = '{ff0000}�� ������ ��������� �� �������� ��������!\n'..text .. '\n' .. ' '
            end
        end
    end

    if id == 9989 then
        if text:find('����� �� �����') and text:find('����� � �����') then
            text = text .. '\n{00ffff}���� ����'
        elseif text:find('����� �� �����') and not text:find('����� � �����') then
            text = text .. '\n' .. ' '
            text = text .. '\n{00ffff}���� ����'
        end
    end

    if id == 162 and fixbike then
        lua_thread.create(function()
            local index = sampGetListboxItemByText('Mountain')
            --local index = sampGetListboxItemByText('%Mountain.-%a+', false)
            sampSendDialogResponse(162,1, index,nil)
            sampSendDialogResponse(163,1,9,nil)
            --sampSendDialogResponse(�� �������, �� ������ (0 / 1) , ����� �������� ������ (�� 0), ����� ��������� � ����)
            fixbike = false
        end)
    end

    if vknotf.dialogs then
		if style == 2 or style == 4 then
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if line:find(tostring(count)) then
					new = new .. line
				else
					new = new .. '[' .. count .. '] ' .. line
				end
				count = count + 1
			end
			text = new
		end
		if style == 5 then
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if count > 1 then
					if line:find(tostring(count - 1)) then
						new = new .. line
					else
						new = new .. '[' .. count - 1 .. '] ' .. line
					end
				else
					new = new .. '[HEAD] ' .. line
				end
				count = count + 1
			end
			text = new
		end
		sendvknotf0('[D' .. id .. '] ' .. title .. '\n' .. text)
    end

    lua_thread.create(function()
		if id == 15247 then dotmoney = false
        if text:find('{ffff00}$(%d+){f') and activefpay then
			wait(0) nalog = text:match('{ffff00}$(%d+){f')
			if nalog == '0' and activefpay then
                sampCloseCurrentDialogWithButton(0)
                sampSendClickTextdraw(-1)
                activefpay = false        
            else
                wait(300)
				sampSetCurrentDialogEditboxText(nalog)
				wait(0) sampCloseCurrentDialogWithButton(1)
                sampSendClickTextdraw(-1)            
                activefpay = false
                dotmoney = true
            end
		end
    end
    end)    

--[[     if id == 162 and mainini.afk.uvedomleniya then
        sendvknotf(text)
       -- return false
    end ]]

      if id == 8928 and mainini.afk.uvedomleniya then
        sendvknotf0(text)
       -- return false
    end
    if id == 7782 and mainini.afk.uvedomleniya then
        sendvknotf0(text)
       -- return false
    end
    if id == 1333 and mainini.afk.uvedomleniya then
        sendvknotf0(text)
        sampSendDialogResponse(id, 0, 0, "")
		return false
    end
    if id == 1332 then
		sampSendDialogResponse(id, 0, 0, "")
		return false
    end
    if text:find('�� �������� ��� ��������') and mainini.afk.uvedomleniya then
        local svk = text:gsub('\n','') 
        svk = svk:gsub('\t','') 
        sendvknotf('(warning | dialog) '..svk)
    end
    
        if text:find('������������� (.+) ������� ���') and mainini.afk.uvedomleniya then
            local svk = text:gsub('\n','') 
            svk = svk:gsub('\t','') 
            sendvknotf('(warning | dialog) '..svk)
        end
    --/eathome
	if gotoeatinhouse then
		local linelist = 0
		for n in text:gmatch('[^\r\n]+') do
			if id == 174 and n:find('���� ����') then
				sampSendDialogResponse(174, 1, linelist, false)
			elseif id == 2431 and n:find('�����������') then
				sampSendDialogResponse(2431, 1, linelist, false)
			elseif id == 185 and n:find('����������� ����') then
				sampSendDialogResponse(185, 1, linelist-1, false)
				gotoeatinhouse = false
			end
			linelist = linelist + 1
		end
		return false
	end
    
    if id == 991 then 
        sampSendDialogResponse(id, 1, _, mainini.helper.bankpin)
    end
    --skipzz
	if text:find("� ���� ����� ���������") then
		sampSendDialogResponse(id, 0, 0, "")
		return false
	end
    --dotmoney
    if dotmoney then
        text = separator(text)
        title = separator(title)
        return {id, style, title, button1, button2, text}
    end
end

function sp.onSendDialogResponse(DialogId, DialogButton, DialogList, DialogInput)
    if DialogId == 9989 and DialogList == 4 and DialogButton == 1 then
        sampSendChat("/home")
    end
end

function PressAlt()
    time = os.time()
	repeat wait(500)
		local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local data = allocateMemory(68)
		sampStorePlayerOnfootData(id, data)
		setStructElement(data, 4, 2, 1024, false)
		sampSendOnfootData(data)
		freeMemory(data)
    until os.time() >= time+5
end
---- �������, ������� � ���, ���� ��
function sp.onDisplayGameText(style, time, text)
    if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
        local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
        return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
    end
    if text:find("%-400%$") then
        return false
    end

    if text:find('You are hungry!') then    
        return false
    end
    if text:find('You are very hungry!') then    
        if mainini.autoeda.eda then
            sampSendChat(mainini.autoeda.comeda)
        elseif mainini.autoeda.meatbag then
            sampSendChat("/meatbag")
        end
        return false
    end
--[[ if text:find('Attention') then
    return false
end
if text:find('GPS: ON') then
    return false
end
if text:find('pursuit') then
    return false
end ]]
end

function lAA()
    while true do wait(0)
		if status then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            local result, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 2, "���")
            
            local result1, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 2, "����� ���������")
            wait(100)
            if result or result1 then
                setGameKeyState(21, 255)
                wait(5)
                setGameKeyState(21, 0)
                result = false
                result1 = false
            end
        end
end
    end

    function renderr()
        local Arial = renderCreateFont("Tahoma", 17, 0x4)
        local Arial1 = renderCreateFont("Tahoma", 8, 0x4)
        local font = renderCreateFont("Tahoma", 13, 0x4)
        while true do wait(0)
            if testCheat("77") then
                for i = 0, 30 do
                  wait(34)
                  setGameKeyState(17,255)
                end
              end
            if coordmy then
                local x, y, z = getCharCoordinates(PLAYER_PED)
                renderFontDrawText(Arial, '{7CFC00}X: ' .. x .. ' {ffffff}| {FFFF00}Y: ' .. y .. ' {ffffff}| {00ffff}Z: ' .. z, 1100, 950, 0xDD6622FF)
            end
            if ScriptStateSliva then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
   --[[                      if text:find("�������� ������") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{008000}����� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                            end
                        end ]]
                        if text:find("���������� ����� �����:") or text:find("�� ������") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                --renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                --text = string.format("{8B4513}˸� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                --renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                renderFontDrawText(fontment, ""..text.."\n{f3ab12}���������: {ffffff}"..distance, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{f3ab12}������� �����: {FFFFFF}'..Counter, w/5, h/3.150, 0xDD6622FF)
            end
            if ScriptState then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("������� 'ALT'") and text:find("������") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{008000}������ {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find("������") and text:find("�������� %d+:%d+")  then
                            timerr = text:match("%d+:%d+")
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                --distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                --renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                --text = string.format("{8B4513}˸� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                --renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                renderFontDrawText(fontment, "{2E8B57}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{008000}������: {FFFFFF}'..Counter, w/5, h/3.350, 0xDD6622FF)
            end
            if ScriptState2 then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("������� 'ALT'") and text:find("˸�")  then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                --local timerr = "�������� %d+"
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{8B4513}˸� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, text, wposX, wposY, 0xDD6622FF)
                                --renderFontDrawText(Arial, timerr, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find("˸�") and text:find("�������� %d+:%d+")  then
                            timerr = text:match("%d+:%d+")
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                              wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, "{D2B48C}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{8B4513}˸�: {FFFFFF}'..Counter, w/5, h/3.150, 0xDD6622FF)
            end
            if ScriptState3 then
                
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if (text:find("������� 'ALT'") or text:find("�������'ALT'")) and text:find("������������� ��������") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)	
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{00FFFF}������ {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, text, wposX, wposY, 0xDD6622FF)
                           end
                        end
                    end
                end

                renderFontDrawText(fontment, '{00FFFF}�e�����: {ffffff}'..Counter, w/5, h/3.350, 0xDD6622FF)

                for _, v in pairs(getAllObjects()) do
                    local asd
                    if sampGetObjectSampIdByHandle(v) ~= -1 then
                        asd = sampGetObjectSampIdByHandle(v)
                    end
                    for k, v in pairs(resources) do
                        local object = sampGetObjectHandleBySampId(k)
                        if isObjectOnScreen(object) then
                            local bool, ox, oy, oz = getObjectCoordinates(object)
                            local x1, y1 = convert3DCoordsToScreen(ox, oy, oz)
                            local mx, my, mz = getCharCoordinates(PLAYER_PED)
                            local x2, y2 = convert3DCoordsToScreen(mx, my, mz)
                            --local distance = string.format("%.1f", getDistanceBetweenCoords3d(ox, oy, oz, mx, my, mz))
                            --renderDrawLine(x1, y1, x2, y2, 5.0, resNames[v][2])
                            renderFontDrawText(fontment, resNames[v][1], x1, y1, -1) 
                        end
                    end
                end
            end
            if enabled then
                Counter = 0
                for _, v in pairs(getAllObjects()) do
                    local asd
                    if sampGetObjectSampIdByHandle(v) ~= -1 then
                        asd = sampGetObjectSampIdByHandle(v)
                    end
                    
                    if isObjectOnScreen(v) then
                        local result, oX, oY, oZ = getObjectCoordinates(v)
                        local x1, y1 = convert3DCoordsToScreen(oX,oY,oZ)
                        local objmodel = getObjectModel(v)
                        local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        distance = string.format("%.0f", getDistanceBetweenCoords3d(oX,oY,oZ, x2, y2, z2))
                        if objmodel == 859 then
                            
                    Counter = Counter + 1
                        renderDrawLine(x10, y10, x1, y1, 2, 0xDD6622FF)
                        renderDrawPolygon(x10, y10, 10, 10, 7, 0, 0xDD6622FF) 
                        renderFontDrawText(fontment,"{20B2AA}������ {00ff00}"..distance, x1, y1, -1)
                        end
                    end
                end
                
                renderFontDrawText(fontment, '{20B2AA}������: {ffffff}'..Counter, w/5, h/2.950, 0xDD6622FF)
            end
            if olenina then
                olenk = 0
                for _, v in pairs(getAllObjects()) do
                    local asd
                    if sampGetObjectSampIdByHandle(v) ~= -1 then
                        asd = sampGetObjectSampIdByHandle(v)
                    end
                local _, x, y, z = getObjectCoordinates(v)
                local x1, y1 = convert3DCoordsToScreen(x,y,z)
                local model = getObjectModel(v)
                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                distance = string.format("%.0f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
                --sampAddChatMessage(model,-1)--.."; distance: "..distance, x1, y1, -1)
              
                if model == 19315 then
                    olenk = olenk + 1
                    if isPointOnScreen(x, y, z, 0.3) then

                        renderDrawLine(x10, y10, x1, y1, 2, 0xDD6622FF)
                        renderDrawPolygon(x1, y1, 10, 10, 7, 0, 0xDD6622FF)	
                        textole = string.format("{BC8F8F}����� {00ff00}"..distance)	
                        wposX = x1 + 5
                        wposY = y1 - 7					
                    renderFontDrawText(fontment, textole, wposX, wposY, -1)
                    end
                end
            end
                    renderFontDrawText(fontment, '{BC8F8F}�����: {ffffff}'..olenk, w/5, h/2.950, 0xDD6622FF)
            end
            if graffiti then
                    for id = 0, 2048 do
                              if sampIs3dTextDefined(id) then
                                  local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                                  if text:find('Grove Street') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {228B22}Grove Street")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {228B22}Grove Street {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('The Rifa') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {4682B4}The Rifa")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {4682B4}The Rifa {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('East Side Ballas') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {EE82EE}Ballas")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {EE82EE}Ballas {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Varrios Los Aztecas') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {00BFFF}Los-Aztecas")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {00BFFF}Los-Aztecas {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Night Wolves') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {DCDCDC}Night Wolves")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {DCDCDC}Night Wolves {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Los Santos Vagos') and text:find('����� ���������') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('�����') then 
                              text = string.format("{B0E0E6}[Graffiti] {FFD700}Vagos")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {FFD700}Vagos {FFFAFA}[+]")
                            end
                            renderFontDrawText(fontment, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                      end
                    end
                  end
            if ScriptState4 then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find('��������') and text:find('����� ���������') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{EE82EE}�������� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{EE82EE}��������:{ffffff} '..Counter, w/5, h/3.350, 0xDD6622FF)
            end

            if ScriptStateGrib then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find('������� ����') and text:find('������� ALT') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{7faa09}���� {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(fontment, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{7faa09}�����:{ffffff} '..Counter, w/5, h/3.350, 0xDD6622FF)
            end

            if ScriptStateKo then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find('�������') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{d3940d}����� {00ff00}")
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(ArialKo, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find('��������� �������') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{d3940d}������� {00ff00}")
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(ArialKo, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find('������� �������') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{d3940d}������ {00ff00}")
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(ArialKo, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                    end
                end
                renderFontDrawText(fontment, '{d3940d}�������:{ffffff} '..Counter, w/5, h/3.150, 0xDD6622FF)
            end
           

    end
        end

        function sp.onSetObjectMaterial(id, data)
            local object, bool = sampGetObjectHandleBySampId(id), true
            if doesObjectExist(object) and getObjectModel(object) == 3930 then
                if textures[data.textureName] then
                    local _, x, y, z = getObjectCoordinates(object)
                    for k, v in pairs(resources) do
                        local _, ox, oy, oz = getObjectCoordinates(sampGetObjectHandleBySampId(k))
                        if getDistanceBetweenCoords3d(x, y, z, ox, oy, oz) < 1 then
                            bool = false
                            if textures[data.textureName] > v then
                                resources[k], bool = nil, true
                                break
                            end
                        end
                    end
                    if bool then
                        resources[id] = textures[data.textureName]
                    end
                end
            end
        end     
        
function sp.onDestroyObject(id)
	if resources[id] then
		resources[id] = nil
	end
end

function Search3Dtext(x, y, z, radius, patern) -- https://www.blast.hk/threads/13380/post-119168
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function sp.onSendCommand(input)
    local result = input:match("^/vr (.+)")
	if result ~= nil and not anticheat then 
		process, finished, try = nil, false, 0
		message = tostring(result)
		process = lua_thread.create(function()
			while not finished do
				if sampGetGamestate() ~= 3 then
					finished = true; break
				end
				if not sampIsChatInputActive() then
					local rotate = math.sin(os.clock() * 3) * 90 + 90
			        local el = getStructElement(sampGetInputInfoPtr(), 0x8, 4)
			        local X, Y = getStructElement(el, 0x8, 4), getStructElement(el, 0xC, 4)
                        renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, rotate, 0xFFFFFFFF)
        			    renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, -1 * rotate, 0xFF0090FF)
    		        	renderFontDrawText(fontVR, message, X + 25, Y, -1)
		        end
		        wait(0)
			end
		end)
	end
    if input:find('/rlt') then
        rlton = not rlton
        if rlton then
            sendvknotf0("�������� �������� � ���� ��������� ���")
            sampAddChatMessage("{ffffff}��������� ������� � ���� ��� {00FF00}���{ffffff}. ��������: {00ffff}"..mainini.sunduk.waiting,-1)
--[[             checkbox_standart = true
            checkbox_donate   = true
            checkbox_tainik   = true
            checkbox_mask     = true
            checkbox_platina  = true ]]
            work = true
            else
            sendvknotf0("�������� �������� � ���� ��������� ����")
            sampAddChatMessage("{ffffff}��������� ������� � ���� ��� {ff0000}����",-1)
--[[             checkbox_standart = false
            checkbox_donate   = false
            checkbox_tainik   = false
            checkbox_mask     = false
            checkbox_platina  = false ]]
            work = false
        end
        return false
    end
    if input:find('/cln') then
        CleanMemory()
        return false
    end
    if input:find('/g9') then
        mainini.lidzamband.devyatka = not mainini.lidzamband.devyatka
        if mainini.lidzamband.devyatka then
            sampAddChatMessage("����� ����������� � ����� {228b22}on {ffffff}| /h9 - ������ ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("����� ����������� � ����� {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if input:find('/m9') then
        mainini.lidzammafia.devyatka = not mainini.lidzammafia.devyatka
        if mainini.lidzammafia.devyatka then
            sampAddChatMessage("����� ����������� � ����� {228b22}on {ffffff}| /h9 - ������ ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("����� ����������� � ����� {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if input:find("/h9") and mainini.lidzamband.devyatka then
        lidzamband_menu()
        return false
    end
    if input:find("/h9") and mainini.lidzammafia.devyatka then
        lidzammafia_menu()
        return false
    end
    if input:find('/nabor') and mainini.lidzamband.devyatka then
        naborgon = not naborgon
		if naborgon then 
            sampAddChatMessage('{ff4500}nabor ghetto {228b22}on',-1)
			naborgka = lua_thread.create(naborg) 
		else
            sampAddChatMessage('{ff4500}nabor ghetto {ff0000}off',-1)
			lua_thread.terminate(naborgka) 
		end
        return false
    end
    if input:find('/fu') and mainini.lidzamband.devyatka then 
        local arguninv = input:match('/fu (.+)')
        sampSendChat('/uninvite '..arguninv..' �������.')
        return false
    end
--[[     if input:find('/fc') and mainini.lidzamband.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 4, -1)
        return false
    end
    if input:find('/sc') and mainini.lidzamband.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 3, -1)
        return false
    end ]]
    if input:find('/gr') and not input:find('/graf') and not input:find('/grib') and mainini.lidzamband.devyatka then 
        local argidgr = input:match('/gr (.+)')
        sampSendChat('/giverank '..argidgr)
        return false
    end
    if input:find('/gs') and mainini.lidzamband.devyatka then 
        local argskin = input:match('/gs (.+)')
        sampSendChat('/giveskin '..argskin)
        return false
    end
--[[     if input:find("/animki") then
        sampAddChatMessage("47 51 56 57 58 62 66 74 77 84 85 99", -1)
        return false
    end ]]
    if input:find('/spb') then
        lua_thread.create(function()
            sampSendChat("/cars")
            wait(500)
            local index = sampGetListboxItemByText('Mountain')
            --local index = sampGetListboxItemByText('%Mountain.-%a+', false)
            sampSendDialogResponse(162,1, index,nil)
            sampSendDialogResponse(163,1,9,nil)
            wait(300)
            closeDialog()
        end)
        return false
    end
    if input:find('/sliv') then
        lua_thread.create(function()
            for i = 0, 300 do
                setVirtualKeyDown(vkeys.VK_LSHIFT, true)
                wait(50)
            setVirtualKeyDown(vkeys.VK_LSHIFT, false)
            wait(500)
            sampSendDialogResponse(216, 1, 0, nil)
            sampSendDialogResponse(217, 1, 3, nil)
            sampSendDialogResponse(221, 1, 0, "500")
            sampCloseCurrentDialogWithButton(1)
            end 
        end)
        return false
    end
    if input:find('^/probiv') then
        lua_thread.create(function()
            sampSendChat("/id "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(1000)
            sampSendChat("/cl "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(1000)
            setVirtualKeyDown(116, true)
            wait(2500)
            setVirtualKeyDown(116, false)
            wait(100)
            sampSetChatInputText("������ �������� ������")
            sampSetChatInputEnabled(true)
            wait(500)
            setVirtualKeyDown(45, true)
            wait(500)
            setVirtualKeyDown(45, false)
            wait(500)
            setVirtualKeyDown(45, true)
            wait(500)
            setVirtualKeyDown(45, false)
            wait(1000)
            setVirtualKeyDown(13, false)
            wait(100)
            sampSendChat("/time")
            wait(500)
            sampSendChat("/invent")
            wait(1000)
            sampSendClickTextdraw(2073)
            wait(1000)
            sampSendClickTextdraw(0xFFFF)
            wait(1000)
            sampSendChat("/stats")
            wait(1000)
            sampSendChat("/donate")
            wait(1000)            
            sampSendChat("/skill")
            wait(1000)
            closeDialog()
            wait(1000)
            setVirtualKeyDown(9, false)
            wait(2000)
            setVirtualKeyDown(9, false)
            wait(1000)
            setVirtualKeyDown(192, false)
        end)
        return false
    end

    if input:find('/colorchat') then
        mainini.functions.colorchat = not mainini.functions.colorchat
		if mainini.functions.colorchat then 
            sampAddChatMessage('������� chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('������� chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if input:find('/rabchat') then
        mainini.functions.offrabchat = not mainini.functions.offrabchat
		if not mainini.functions.offrabchat then 
            sampAddChatMessage('�������-chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('�������-chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if input:find('/frachat') then
        mainini.functions.offfrachat = not mainini.functions.offfrachat
		if not mainini.functions.offfrachat then 
            sampAddChatMessage('�����������-chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('�����������-chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end

    if input:find('/ch') and not input:find('/ch (.+)') and not input:find('/chh') then
        tbl = {}
        for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt') do 
            if l ~= "" then
                table.insert(tbl, string.sub(l, 1, 325)) 
            end
        end
        if #tbl <= 2000 then    
            sampShowDialog(1007, "���������: "..#tbl, table.concat(tbl, "\n"), "�����", _, 4)
        elseif #tbl > 2000 then
            local warningch = "{ffffff}� ���-���� ����� {ff0000}"..#tbl.." {ffffff}�����, ����� ���� ������ ������ �� �����. \n���������� ������������ ����� �� �����/����� - {00ffff}/ch (�����) \n{ffffff}���� ������ ������� ���-��� ������� ����� - {fff000}/chh"
            sampShowDialog(1047, "{ff0000}��������������", warningch, "�����", _, 0)
        end
        return false
    end
    if input:find('/chh') then
        tbl = {}
        for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt') do 
            if l ~= "" then
                table.insert(tbl, string.sub(l, 1, 325)) 
            end
        end   
        sampShowDialog(1007, "���������: "..#tbl, table.concat(tbl, "\n"), "�����", _, 4)
        return false
    end
    if input:find('/ch (.+)') then
        local param = input:match('/ch (.+)')
        tbl = {}
        for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt') do 
            if l ~= "" then
                if param ~= 0 then
                    if string.find(l, param) ~= nil then
                    table.insert(tbl, string.sub(l, 1, 325)) 
                    end
                else
                    table.insert(tbl, string.sub(l, 1, 325))
                end	
            end
        end
        sampShowDialog(1007, "����: "..param.." | ���������: "..#tbl, table.concat(tbl, "\n"), "�����", _, 4)
        return false
    end
    if input:find('/eathome') then
        gotoeatinhouse = true; sampSendChat('/home')
        return false
    end
    ---
    if input:find('/piss') then
        sampSetSpecialAction(68)
        --addOneOffSound(0.0, 0.0, 0.0, 1185)
        return false
    end
    if input:find('/cchat') then
        ClearChat()
        return false
    end
    if input:find('/hrec') then
        reconnect()
        return false
    end
    if input:find('/fpay') then
        activefpay = not activefpay gopay()
        return false
    end
    if input:find('/mb') then
        sampSendChat('/members')
        return false
    end
    if input:find('/k (.+)') then
        local arg = input:match('/k (.+)')
         sampSendChat("/fam "..arg)
        return false
    end
    if input:find('/getcolor (.+)') then
        local id = input:match('/getcolor (.+)')
        if tonumber(id) then
            local res, car = sampGetCarHandleBySampVehicleId(tonumber(id))
            if res then
                local clr1, clr2 = getCarColours(car)
                sampAddChatMessage(string.format('���� ���������:{FFFFFF} %s | %s', clr1, clr2), 0xFF4500)
            else
                sampAddChatMessage('���������� � ����� ID ��� � ���� ����������!', 0xFFF000)
            end
        end
        return false
    end
--[[     if input:find('/flood') and not (input:find('/flood1') or input:find('/flood2') or input:find('/flood3') or input:find('/flood4') or input:find('/flood5')) then
        flood_menu()
        return false
    end ]]

    if input:find('^/gflood') then
        ghetto_lidzam_flood()
        return false
    end
    if input:find('^/blessave') then
        menu()
        return false
    end

    if input:find('/flood1') then
        floodon1 = not floodon1
		if floodon1 then 
            sampAddChatMessage('{ff4500}flood1 {228b22}on',-1)
			floodka1 = lua_thread.create(flood1) 
		else
            sampAddChatMessage('{ff4500}flood1 {ff0000}off',-1)
			lua_thread.terminate(floodka1) 
		end
        return false
    end
    if input:find('/flood2') then
        floodon2 = not floodon2 
        if floodon2 then 
            sampAddChatMessage('{ff4500}flood2 {228b22}on',-1)
            floodka2 = lua_thread.create(flood2) 
        else
            sampAddChatMessage('{ff4500}flood2 {ff0000}off',-1)
            lua_thread.terminate(floodka2) 
        end
        return false
    end
    if input:find('/flood3') then
        floodon3 = not floodon3
		if floodon3 then 
            sampAddChatMessage('{ff4500}flood3 {228b22}on',-1)
			floodka3 = lua_thread.create(flood3) 
		else
            sampAddChatMessage('{ff4500}flood3 {ff0000}off',-1)
			lua_thread.terminate(floodka3) 
		end
        return false
    end
    if input:find('/flood4') then
        floodon4 = not floodon4
		if floodon4 then 
            sampAddChatMessage('{ff4500}flood4 {228b22}on',-1)
			floodka4 = lua_thread.create(flood4) 
		else
            sampAddChatMessage('{ff4500}flood4 {ff0000}off',-1)
			lua_thread.terminate(floodka4) 
		end
        return false
    end
    if input:find('/flood5') then
        floodon5 = not floodon5
		if floodon5 then 
            sampAddChatMessage('{ff4500}flood5 {228b22}on',-1)
			floodka5 = lua_thread.create(flood5) 
		else
            sampAddChatMessage('{ff4500}flood5 {ff0000}off',-1)
			lua_thread.terminate(floodka5) 
		end
        return false
    end
----------------------------------------------------------------

if input:find('^/mnk (.+)') then
    local arg = input:match('/mnk (.+)')
        if sampIsPlayerConnected(arg) then
            arg = sampGetPlayerNickname(arg)
        else
            sampAddChatMessage('������ ��� �� �������!', -1)
            return
        end
        on = not on
        if on then
            sampAddChatMessage('����: '..arg..'!', -1)
            
            lua_thread.create(function()

            while on do
                wait(0)
                local id = sampGetPlayerIdByNickname(arg)
                if id ~= nil and id ~= -1 and id ~= false then
                    local res, handle = sampGetCharHandleBySampPlayerId(id)
                    if res then

                        

                        local screen_text = '�����!'
                        x, y, z = getCharCoordinates(handle)
                        local mX, mY, mZ = getCharCoordinates(playerPed)
                        local x1, y1 = convert3DCoordsToScreen(x,y,z)
                        local x2, y2 = convert3DCoordsToScreen(mX, mY, mZ)
                        if isPointOnScreen(x,y,z,0) then
                            renderDrawLine(x2, y2, x1, y1, 2.0, 0xDD6622FF)
                           -- renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                        else
                            screen_text = '���-�� �����!'
                        end
                        printStringNow(conv(screen_text),1)
                    end
                end
            end
    
        end)
    end
    return false
end
    
    ----
    if input:find('^/fh (.+)') then
        local arg = input:match('/fh (.+)')
        sampSendChat("/findihouse "..arg)
        return false
    end
    if input:find('^/fbiz (.+)') then
        local arg = input:match('/fbiz (.+)')
        sampSendChat("/findibiz "..arg)
        return false
    end

    if input:find('^/gn') then
		ScriptState4 = not ScriptState4
        return false
    end  
    if input:find('^/adm') then
		showa = not showa
        return false
    end 




    if input:find('^/pr') and not input:find('/premium') then
		ScriptStateKo = not ScriptStateKo
        return false
    end  
    if input:find('^/ms') then
		actmentpidor = not actmentpidor
        return false
    end  

    if input:find('^/gh') then
		actmentpidor = not actmentpidor
		ScriptStateKo = not ScriptStateKo
		ScriptState4 = not ScriptState4
		showa = not showa
        return false
    end  

    if input:find("/coords") then
        coordmy = not coordmy
        return false
    end
 
    if input:find("^/fid") then
        lua_thread.create(function()
            for b = 0, 1004 do
                if b > sampGetMaxPlayerId(false) then
                    break
                end
                sampSendChat("/id "..b)
                wait(200)
            end
        end)
    end

    if input:find("^/fnum") then
        lua_thread.create(function()
            for b = 0, 1004 do
                if b > sampGetMaxPlayerId(false) then
                    break
                end
                sampSendChat("/number "..b)
                wait(200)
            end
        end)
    end
  
    if input:find('^/ub') and update_state then  
        lua_thread.create(function()
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������!", -1)
                    thisScript():reload()
                end
            end)
            update_state = false
        end)
        return false
    end  
    ---

    if input:find('/semena') then
		enabled = not enabled 
        return false
    end
    if input:find('/len') then
		ScriptState2 = not ScriptState2
        return false
    end
    if input:find('^/trees') then
        ScriptStateSliva = not ScriptStateSliva
        return false
    end
    if input:find('^/grib') then
        ScriptStateGrib = not ScriptStateGrib
        return false
    end
    if input:find('^/olenina') then
		olenina = not olenina
        return false
    end 
    if input:find('/graf') then
		graffiti = not graffiti
        return false
    end
    if input:find('/waxta') then
        ScriptState3 = not ScriptState3
        return false
    end
    if input:find('/hlop') then
		ScriptState = not ScriptState
        return false
    end
    if input:find('/laa') then
		status = not status
		if status then
            autoaltrend = true
		else
            autoaltrend = false
		end
        return false
    end
    ----------------------------------------------------------------
    local cmd, args = string.match(input, "^/([^%s]+)"), {}
	local cmd_len = string.len("/" .. cmd)
	local arg_text = string.sub(input, cmd_len + 2, string.len(input))
	for arg in string.gmatch(arg_text, "[^%s]+") do args[#args + 1] = arg end

	if cmd == "fg" then
		local text = getHelpText()
		sampShowDialog(0, "{FFAA80}������� ��� ������ ������", text, "�����", "", 5)
		return false
	end
    

	if Weapon[cmd] ~= nil then
		if info ~= nil then
			sampAddChatMessage("� ��������� �������!", 0xAA3030)
			return false
		end

		local count = tonumber(args[1]) or 50
		if count > 500 then
			sampAddChatMessage("� ������ ��������� ����� 500 ��. �� ���!", 0xAA3030)
			return false
		elseif count < 1 then
			sampAddChatMessage("� ������� ������������ ����������!", 0xAA3030)
			return false
		end

		page.cur = 1
		lua_thread.create(function()
			while true do wait(0)
				if info ~= nil then
					--printStringNow("~w~Wait a moment...", 50)
					if os.clock() - info.clock >= TIMEOUT then
						if info.step == 0 and page.cur < 3 then
							page.cur = page.cur + 1
							info.clock = os.clock()
							sampSendClickTextdraw(page[page.cur])
						elseif page.cur > 1 then
							sampAddChatMessage("� � ����� ��������� �� ������� ��� ������!", 0xAA3030)
							close_inventory()
						else
							sampAddChatMessage("� ����� ����� ��������, ���������� ��� ���!", 0xAA3030)
							close_inventory()
						end
					end
				end
			end
		end)

		info = Weapon[cmd](count)
		return { "/invent" }
	end
end


function CleanMemory()
	-- ������ ������ ����� ����� ��� https://github.com/DK22Pac/plugin-sdk/blob/master/plugin_sa/game_sa/CGame.cpp
	local cln1 = callFunction(0x53C500, 2, 2, true, true)
	local cln2 = callFunction(0x53C810, 1, 1, true)
	local cln3 = callFunction(0x53BED0, 0, 0)
	local cln4 = callFunction(0x40CF80, 0, 0)
	local cln5 = callFunction(0x53C440, 0, 0)
	local cln6 = callFunction(0x707770, 0, 0)
	local cln7 = callFunction(0x5A18B0, 0, 0)
	local cln8 = callFunction(0x53C4A0, 0, 0)
	local cln9 = callFunction(0x53C240, 0, 0)
	local cln10 = callFunction(0x4090A0, 0, 0)
	local cln11 = callFunction(0x409760, 0, 0)
	local cln12 = callFunction(0x409210, 0, 0)
	local cln13 = callFunction(0x40D7C0, 1, 1, -1)
	local cln14 = callFunction(0x40E4E0, 0, 0)
	local cln15 = callFunction(0x70C950, 0, 0)
	local cln16 = callFunction(0x408CB0, 0, 0)
	local cln17 = callFunction(0x40E460, 0, 0)
	local cln18 = callFunction(0x407A10, 0, 0)
	local cln19 = callFunction(0x40B3A0, 0, 0)
	local detectX, detectY, detectZ = getCharCoordinates(PLAYER_PED)
	requestCollision(detectX, detectY)
	loadScene(detectX, detectY, detectZ)
    sampAddChatMessage("������� ������ ���� ����������� � ������ �������." , -1)
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function conv(text)
    local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
    local result = {}
    for i = 1, #text do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end

function sp.onServerMessage(color, text)
    --print(text, color)
    --[[          if  text:find('�������:') then
            print('{'..bit.tohex(bit.rshift(color, 8), 6)..'}'..text)
            print('======')
            print('%X', color)
            print(bit.tohex(bit.rshift(color, 8), 6))
            end ]]

            if info ~= nil and string.find(text, "� ��� ��� ��������� ����� �� ���� ��������!") then
                sampAddChatMessage("� � ����� ��������� �� ������� ��� ������!", 0xAA3030)
                close_inventory()
                return false
            end
    if text:find('���� �����') and text:find('� ���� ������') and color == -1178486529 and mainini.afk.uvedomleniya then
        sendvknotf0(text..' <3')
    end
    if text:find("� ��� ��� ����� � �����") and color ==  -10270721 then
        if not isCharInAnyCar(PLAYER_PED) then
            lua_thread.create(function()
                automeatbag = true
                wait(500)
                sampSendChat("/invent") 
            end)
        end
    end
    if chatlog then
		if doesFileExist(fpath) then
			local fa = io.open(fpath, 'a+')
			if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
		end
	end
    if baza then
        if string.find(text,'%a+_%a+%[%d+%]:%s%s%s%s') then
            if doesFileExist(bazafpath) then
                local bazafa = io.open(bazafpath, 'a+')
                if bazafa then bazafa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
            end
        end
        if text:find("UID") and text:find("�������") and color == -1 then
            if doesFileExist(bazafpath) then
                local bazafa = io.open(bazafpath, 'a+')
                if bazafa then bazafa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
            end
        end
	end
    if menuhome then
        if text:find('����� �������, ���������� �����') and color == -10270721 then
            sampSendChat("/home")
        end
    end
    if color == 1118842111 and text:find('�� ������������') and mainini.afk.uvedomleniya then
        sendvknotf0(text)
    end

    if text:find('��� ������� ��������') and color == 1941201407 and mainini.afk.uvedomleniya  then
        sendvknotf0(text)
    end
    if text:match('{73B461}%[���%]:')  and mainini.afk.uvedomleniya then
        sendvknotf0(text)
        text = text:gsub('^{73B461}%[���%]', '{2FAA5B}[���]') --b800a2
        return { 0xFFFFFFFF, text }
    end
    if color == -1347440641 and text:find('������ �������') and text:find('����������') and text:find('����� ���������') and mainini.afk.uvedomleniya  then
        sendvknotf(text)
    end
    if vknotf.chatc  and mainini.afk.uvedomleniya then 
		sendvknotf0(text)
	end 
    if not vknotf.chatf  and mainini.afk.uvedomleniya then 
        if text:find('%[�����') or text:find('%[������ ') or text:find('%[������� �����%]') then
			sendvknotf0(text)
		end
	end 
    if vknotf.chatadv  and mainini.afk.uvedomleniya then 
        if text:find('%[�������%] ') then
			sendvknotf0(text)
		end
	end 
    if color == -1347440641 and text:find('����� � ���') and text:find('�� �������') and text:find('��������')  and mainini.afk.uvedomleniya then
        sendvknotf0(text)
    end
    if color == -1347440641 and text:find('�� ������') and text:find('� ������')  and mainini.afk.uvedomleniya then
        sendvknotf0(text)
    end
    if color == 1941201407 and text:find('����������� � �������� ������������� ��������') and mainini.afk.uvedomleniya  then
        sendvknotf0('����������� � �������� ������������� ��������')
    end
    if text:find("��� ������ ����� ���������!") and not text:find("�������") and not text:find('- |') then
        sampAddChatMessage("{fff000}��� ������ ����� {FFFFFF}SMS{fff000}-���������!", -1)
        addOneOffSound(0.0, 0.0, 0.0, 1055)
        printStringNow("~Y~SMS", 3000)
        return false
    end
    if text:find('�������:') then
            local idd = text:match('%d+')
        local colorr = sampGetPlayerColor(idd)
            sampAddChatMessage(text,colorr)
            return false 
    end
    if text:find('%[������ ') then
        return { 0x9c15c1ff, text }
    end
    if text:find('^������������� (.+) ������� ���')  and mainini.afk.uvedomleniya then
        sendvknotf('(warning | chat) '..text)
    end
    if color == -10270721 and text:find('�������������')  and mainini.afk.uvedomleniya then
        local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if res then 
            local mname = sampGetPlayerNickname(mid)
            if text:find(mname) then
                    sendvknotf(text)
            end 
        end
    end
    if text:find("�������������") and color == -10270721 and (text:find('��������') or text:find('��������� � ��������') or text:find('�������') or text:find('�������') or text:find('�����')  or text:find('��������') or text:find('������') or text:find('���� ��������')) and not text:find('SaintRoseBot') and not text:find('AntiBot') then
		local nick = string.match(text,"%a+_%a+")
		local found = false
		for _,v in pairs(mainadm.a) do
			if v == nick and not found then
				found = true
			end
		end
		if found == false then
			--sampAddChatMessage("����� �����! ��� - "..nick,-255)
			table.insert(mainadm.a,nick)
			inicfg.save(mainadm, 'a')
		end
	end
    if color == -10270721 and text:find('�������������') and text:find('������') then
        local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if res then 
            local mname = sampGetPlayerNickname(mid)
            if text:find(mname) then
                thisScript():reload()
            end 
        end
    end
    if color == -10270721 and text:find('�� ������ ����� �� ��������������� ��������') and mainini.afk.uvedomleniya  then
            sendvknotf(text)
    end
    if text:find('���������� ���') and color == 1941201407 then
       lua_thread.create(function()
        wait(10*1000)
        if mainini.functions.famkv then
        sampSendChat('/fam [notf.] �� ��������� ���������� ������ �� ���������! (/fammenu - �������� ��������)')
        end
        sampAddChatMessage('�� ������� ���������� ������ �� ���������!', 0xea5362)      
        wait(600*1000)
        sampAddChatMessage('�� ������� ���������� ������ �� ���������!', 0xea5362)    
        wait(1500*1000)
        sampAddChatMessage('�� ������� ���������� ������ �� ���������!', 0xea5362)    
       end)
    end
    if text:find('�� �������� ��� ������ �� �����') and color == 1941201407 then
        lua_thread.create(function()
        wait(150)
        sampAddChatMessage('{ffffff}�� ������ �������� ������ �� {ff4500}���.�������� {800080}(/fpay)', 0xff0000)   
        end)
    end
    if text:find('���������� ���')  and mainini.afk.uvedomleniya then
        vknotf.ispaydaystate = true
        vknotf.ispaydaytext = ''
    end
    if vknotf.ispaydaystate  and mainini.afk.uvedomleniya then
        if text:find('������� � �����') then 
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text 
        elseif text:find('����� � �������') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text 
        elseif text:find('������� ����� � �����') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text
        elseif text:find('������� ����� �� ��������') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text
        elseif text:find('� ������ ������ � ���') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
        --elseif text:find('�������� ���������') then
            --vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
            sendvknotf('\n ��������: ' .. getPlayerMoney(PLAYER_HANDLE) ..vknotf.ispaydaytext..'\n <3 �� ������� ���������� ������ �� ���������!')
            vknotf.ispaydaystate = false
            vknotf.ispaydaytext = ''
        end
    end
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)
    if isCharInAnyCar(PLAYER_PED) then
        lua_thread.create(function()
            if text:find("���������� �������� ����� � ���������") and not text:find("�������") and not text:find('- |') and notkey == true then
                sampSendChat("/key")
                wait(240)
                setVirtualKeyDown(vkeys.VK_N, true)
                wait(44)
                setVirtualKeyDown(vkeys.VK_N, false)
                notkey = false
            end
        end)
        if text:find(nick) and text:find ("��������") and text:find ("���������") and not text:find("�������") and not text:find('- |')  then
            sampSendChat("/key")
        end
    end

    if text:find('� ��� �������� ������� �����') or text:find('������ ��������� ����� �������') then return false end

    --- ������� � �� ��� �� ������� ����
    if text:match('^%s+$') then return false end

    if (text:find("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~") or text:find("�������� ������� �������:") or text:find("�������� ����� � ������") or text:find("��� ����:"))  and color == -89368321 then return false end

    if (text:find("� ����� �������� �� ������ ���������� ������ ���������� ������� ����� � ���������") or text:find("�� �� �������� �����") or text:find("����� ������� �����������") or text:find("����� ������ ������������") or text:find("����� ���������� ������") or text:find("������� ������� ���� �� �����")) and color == 1687547391 then return false end

    -- if text:find("����� ��� ������� �������� ������ � ��� �������") and color == -1104335361 then return false end

    if (text:find("����� ������ ����� ����������") or text:find('�� ������� �������� ������')) and color == -1800355329 then return false end

    if (text:find("News LS") or text:find("News LV") or text:find("News SF")) and color == 1941201407 then return false end

    if text:find('������ �������') and color == -1800355329 then return false end

    if text:find('������ ������ � ���������') and color == -89368321 then return false end

    if (text:find('�� ������� ���� ���������') or text:find('�� ������ ������ ������ � ����') or text:find('����� ��������� �������') or text:find('����� �������� ����� �')) and text:find('���������') then return false end

    if (text:find('����� ������� ��������� �������') or text:find('����� �������� ����� ����������� ������') or text:find('����� ������������ �����') or text:find('��� ���������� ������������� �����������') or text:find('� ���������� ������������ �����') or text:find('�������� ���� ���')) and text:find('���������') then return false end

    if text:find('��������� ������ ���� ������') and text:find('����������') and not text:find('�������') and not text:find('- |') then return false end
    if text:find('���������� ������� �� �������') and text:find('����������� /gps') and not text:find('�������') and not text:find('- |') then return false end
    if text:find('��������� ������ ����') and text:find('���������') and not text:find('�������') and not text:find('- |') and color == -10270721 then return false end
    if text:find('���������� �� �������') and not text:find('�������') and not text:find('- |') and color == -1 then return false end

    if (text:find('��������� ������ �����') or text:find('� ������ ������ �������� �������������') or text:find('��� ���������� ���������� �������')) and color == 73381119 then return false end

    if (text:find("���������� ������������ �����") or text:find("�������") or text:find("��������� ������") or text:find("������ ������")  or text:find("�����") or text:find("����������� �������")  or text:find("������ ������� �������") or text:find("������ ��������� ��������������� �����:")) or text:find("������ �� �������� ����� ������������")  and not text:find('�������') and not text:find('- |') and color == -1 then return false end
    if text:find("������ ��������� ��������������� �����") and not text:find('�������') and not text:find('- |')  and color == 1687547391 then return false end
    if text:find('������ ����� ��������� ��� � ���� ��������') and text:find('���������') and color == -1347440641 then return false end
    --      if text:find('��� ��� �������� �������') and text:find('�����������') and color == -65281 then return false end

    if (text:find('������� ����') or text:find('������������� �� ��� ���������') or text:find('�� �����������')) and text:find('��������') and color == -1104335361 then return false end
              if (text:find('���������� ������� �������� � ���������� ���������') or text:find('���� ��� ������� ���-�� �������') or text:find('��������!') or text:find('����� 10 ����� ��������� �������� ������� �������� � ����������') or text:find('����� ������� ��� ����� ������ ������ � ����� � ��������� ��� �����') or text:find('������ ������ � ������������� � ����') or text:find('������ ������ � ������������� � ����') or text:find('��� ����� ����� ������������� �� ���')) and color == -10270721 then return false end
    if (text:find('���� ��� ������� ���-�� �������') or text:find('��������� ��� � �����')) and color == -10270721 then return false end
    if (text:find('����� �� ���� �������� ������� � ��������� ���� ����� ��������� ��� �����������') or text:find('������ ������� � ������������� � ���� ��� ������ �����')) and color == -10270721 then return false end
    if (text:find('� ���� ��� ��������� ������� ������� � ��������� � ��������� �����') or text:find('������� ������� ��� ����� ������, ���� �� �� ������ ������')) and color == -10270721 then return false end
   
      if (text:find('��������� ����������� ����:') and text:find('�������� �����������') and text:find('�����������')) and color == 1687547391 then return false end

    if text:find("���.�������:") and color == 73381119 then return false end

     if text:find('�����������') and text:find('�������� ������') and color ==  -1178486529 then return false end

    if (text:find('�����') or text:find('�������')) and color == -1697828097 then return false end

    --if text:find('�� ������') and text:find('�������:') and color == -1077886209 then return false end

    if text:find('� ������� �������� ����� �������� �����') and text:find('���������') and color == -170229249 then return false end

    -----------------------------------------------------ajksdhfjsdjkfhsdjkfhsdjkf
    if not finished and not anticheat then
        if text:find("^%[������%].*����� ���������� ��������� � ���� ���� ����� ���������") then
            lua_thread.create(function()
                wait(0.5 * 1000);
                sampSendChat("/vr " .. message)
                try = try + 1
            end)
            return false
        end
        local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
        if text:match("%[%u+%] {%x+}[A-z0-9_]+%[" .. id .. "%]:") then
            finished = true
        end
    end
    if text:find("^�� ���������") or text:find("��� ����������� ��������� �������� ��������� � ���� ���") then
        finished = true
    end
    if text:find ('�� ���������. ���������� �����') then
        sukazaebalmutit = text:match('%d+')
        hvatitmutitbliat = sukazaebalmutit/60
        sampAddChatMessage('�� ���������. ���������� ����� ' .. math.floor(hvatitmutitbliat) .. ' �����(�) = '..sukazaebalmutit.. ' ������(�).', -1347440641)
        return false
    end
    if text:match('^{6495ED}%[VIP%]') and mainini.functions.colorchat then
        text = text:gsub('^{6495ED}%[VIP%]', '{b800a2}[VIP]')   
        return { 0xFFFFFFFF, text }
    end
    if text:match('^{F345FC}%[PREMIUM%]') and mainini.functions.colorchat then
        text = text:gsub('^{F345FC}%[PREMIUM%]', '{FFAA00}[PREMIUM]')
        return { 0xFFFFFFFF, text }
    end
    if text:match('^{FCC645}%[ADMIN%]') and mainini.functions.colorchat then
        text = text:gsub('^{FCC645}%[ADMIN%]', '{38fcff}[ADMIN]')
        return { 0xffffffff, text }
    end
    if mainini.functions.colorchat then
        if color == 0x73B461FF then
            local ad, tel = text:match('^����������:%s(.+)%.%s��������:%s[A-z0-9_]+%[%d+%]%s���%.%s(%d+)')
            if ad ~= nil then
                local outstring = string.format('AD: {73B461}%s {D5A457}| ���: %s', ad, tel)
                return { 0xD5A457FF, outstring }
            elseif text:find('�������������� ���������') then
                return false
            end
        end                
        if color == -1 then
            local ad, tel = text:match('^{%x+}%[VIP%]%s����������:%s(.+)%.%s��������:%s[A-z0-9_]+%[%d+%]%s���%.%s(%d+)')
            if ad ~= nil then
                local outstring = string.format('VIP AD: {73B461}%s {D5A457}| ���: %s', ad, tel)
                return { 0xD5A457FF, outstring }
            elseif text:find('�������������� ���������') then
                return false
            end
        end

        if text:find('�������������') or text:find('�������') or text:find('BOT') and not text:find('�������') then
            if color == -10270721 then -- �������� FF6347FF
                return { 0xb22222ff, text }
            elseif color == -2686721 then -- /ao FFD700FF
                return { 0xc8b451ff, text }
            end
        end
--[[         if text:find("������� �����") and text:find("�������� ��������� ������� ������") then
            sampProcessChatInput("/fconnect 0 7000")
        end ]]
        if text:find("����� ��� ������� �������� ������ � ��� �������") and color == -1104335361 then 
            return { 0x6f6d6fff, text }
        end
        if text:find('%[�������%] ') then
            if mainini.functions.offrabchat then
                return false
            else
                local advtext = text:match('%[�������%] (.+)')
                --sampAddChatMessage("{ffffff} ������� "..advtext, 0x5F9EA0)
                return { 0x5f9ea0ff, "{ff4500}[J] {5f9ea0}"..advtext }
            end
        end
        if text:find('%[F%] ') and color == 766526463 then
            if mainini.functions.offfrachat then
                return false
            else
                local bandtext = text:match('%[F%] (.+)')
                return { 0x2db043ff, "{ff4500}[F] {2db043}"..bandtext }
            end
        end
    end 
    if text:find('%[F%] ') and color == 766526463 and mainini.functions.offfrachat then
        return false
    end
    if text:find('%[�������%] ') and mainini.functions.offrabchat then
        return false
    end
    if text:find("�������������� ��������� ���") and color == 1941201407 then return false end
    if text:find("�������������� ��������� ���") and not text:find('�������:') then return false end

    if dotmoney then
        text = separator(text)
        return {color, text}
    end
end
function calc(m) 
    local func = load('return '..tostring(m)) 
    local a = select(2, pcall(func)) 
    return type(a) == 'number' and a
end
function isKeyCheckAvailable() -- �������� �� ����������� �������
    if not isSampfuncsLoaded() then
      return not isPauseMenuActive()
    end
    local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
    if isSampLoaded() and isSampAvailable() then
      result = result and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsCursorActive()
    end
    return result
end
function changeCrosshairColor(rgba)
    local a = bit.band(bit.rshift(rgba, 24), 0xFF)
    local b = bit.band(bit.rshift(rgba, 16), 0xFF)
    local g = bit.band(bit.rshift(rgba, 8), 0xFF)
    local r = bit.band(rgba, 0xFF)

    memory.setuint8(0x58E301, r, true)
    memory.setuint8(0x58E3DA, r, true)
    memory.setuint8(0x58E433, r, true)
    memory.setuint8(0x58E47C, r, true)

    memory.setuint8(0x58E2F6, g, true)
    memory.setuint8(0x58E3D1, g, true)
    memory.setuint8(0x58E42A, g, true)
    memory.setuint8(0x58E473, g, true)

    memory.setuint8(0x58E2F1, b, true)
    memory.setuint8(0x58E3C8, b, true)
    memory.setuint8(0x58E425, b, true)
    memory.setuint8(0x58E466, b, true)

    memory.setuint8(0x58E2EC, a, true)
    memory.setuint8(0x58E3BF, a, true)
    memory.setuint8(0x58E420, a, true)
    memory.setuint8(0x58E461, a, true)
end
function dialoginfo() --this function will be called as console command typed
    dtx = sampGetDialogText() --geting last dialog text
    dtp = sampGetCurrentDialogType() --and type
    did = sampGetCurrentDialogId() --and id
    dcp = sampGetDialogCaption() --and caption
    --[[and then, we format string, and put it to console log.]]
    sampfuncsLog(string.format("{00BEFC}Current dialog info:\nDialog ID:{FFFFFF} %d \n{00BEFC}Dialog Type:{FFFFFF} %d \n{00BEFC}Dialog Caption:{FFFFFF}\n%s\n{00BEFC}Dialog text:{FFFFFF}\n%s", did, dtp, dcp, dtx))
end --end of function�
--functions can be declared at any part of code unlike it usually works in lua
function del(n) --this function simly delete textdeaw with a number that we give with command
    sampTextdrawDelete(n)
end
function show() --this function sets toggle param from false to true and vise versa
    toggle = not toggle
end

function setTime(time)
	local time = tonumber(time)
	if time < 0 or time > 23 then sampAddChatMessage("���������� ����: {F7E937}//t [0-23]", -1) else
		
		if mainini.stsw.Static then
            sampAddChatMessage("����� ����������� �� {F7E937}"..time, -1)
			mainini.stsw.Time = time
			inicfg.save(mainini, "bd.ini")
		--else memory.write(0xB70153, time, 1, false)
		end
	end
end
function setWeather(weather)
	local weather = tonumber(weather)
	if weather < 0 or weather > 45 then sampAddChatMessage("���������� ����: {F7E937}//w [0-45]", -1) else
			
		if mainini.stsw.Static then
            sampAddChatMessage("������ ����������� �� {F7E937}"..weather, -1)
			memory.write(0xC81320, weather, 2, false)
			memory.write(0xC81318, weather, 2, false)
			mainini.stsw.Weather = weather
			inicfg.save(mainini, "bd.ini")
        --else memory.write(0xC81320, weather, 2, false)
		end
	end
end

function setStatic(static)
	if static == "true" then
		sampAddChatMessage("Static state: {F7E937}true", -1)
		mainini.stsw.Static = true
		inicfg.save(mainini, "bd.ini")
	elseif static == "false" then
		sampAddChatMessage("Static state: {F7E937}false", -1)
		mainini.stsw.Static = false
		inicfg.save(mainini, "bd.ini")
	end
end

function dialogsFloodMenu()
    local result, button, _, lop = sampHasDialogRespond(27417)
    if result and button == 1 then
        mainini.lidzamband.naborgtext = lop
        inicfg.save(mainini, 'bd')
        lidzamband_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27411)
    if result and button == 1 then
        mainini.lidzamband.band = lop
        inicfg.save(mainini, 'bd')
        lidzamband_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(21411)
    if result and button == 1 then
        mainini.lidzamband.minlvl = lop
        inicfg.save(mainini, 'bd')
        lidzamband_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(22411)
    if result and button == 1 then
        mainini.lidzamband.minrank = lop
        inicfg.save(mainini, 'bd')
        lidzamband_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27418)
    if result and button == 1 then
        mainini.lidzamband.naborgwait = lop
        inicfg.save(mainini, 'bd')
        lidzamband_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(2911)
    if result and button == 1 then
        mainini.lidzamband.flwait1 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2912)
    if result and button == 1 then
        mainini.lidzamband.flwait2 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2913)
    if result and button == 1 then
        mainini.lidzamband.flwait3 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2914)
    if result and button == 1 then
        mainini.lidzamband.flwait4 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2915)
    if result and button == 1 then
        mainini.lidzamband.flwait5 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2916)
    if result and button == 1 then
        mainini.lidzamband.flwait6 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2917)
    if result and button == 1 then
        mainini.lidzamband.flwait7 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2918)
    if result and button == 1 then
        mainini.lidzamband.flwait8 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2919)
    if result and button == 1 then
        mainini.lidzamband.flwait9 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2811)
    if result and button == 1 then
        mainini.lidzamband.fltext1 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2812)
    if result and button == 1 then
        mainini.lidzamband.fltext2 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2813)
    if result and button == 1 then
        mainini.lidzamband.fltext3 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2814)
    if result and button == 1 then
        mainini.lidzamband.fltext4 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2815)
    if result and button == 1 then
        mainini.lidzamband.fltext5 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2816)
    if result and button == 1 then
        mainini.lidzamband.fltext6 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2817)
    if result and button == 1 then
        mainini.lidzamband.fltext7 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2818)
    if result and button == 1 then
        mainini.lidzamband.fltext8 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(2819)
    if result and button == 1 then
        mainini.lidzamband.fltext9 = lop
        inicfg.save(mainini, 'bd')
        ghetto_lidzam_flood()
    end

    local result, button, _, lop = sampHasDialogRespond(28599)
    if result and button == 1 then
        mainini.functions.fastnosoft = lop
        inicfg.save(mainini, 'bd')
        wh_cops_pidors()
    end

    -----
    local result, button, _, lop = sampHasDialogRespond(27871)
    if result and button == 1 then
        mainini.flood.flwait1 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27872)
    if result and button == 1 then
        mainini.flood.fltext1 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27873)
    if result and button == 1 then
        mainini.flood.flwait2 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27874)
    if result and button == 1 then
        mainini.flood.fltext2 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27875)
    if result and button == 1 then
        mainini.flood.flwait3 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27876)
    if result and button == 1 then
        mainini.flood.fltext3 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27885)
    if result and button == 1 then
        mainini.flood.flwait4 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27886)
    if result and button == 1 then
        mainini.flood.fltext4 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27895)
    if result and button == 1 then
        mainini.flood.flwait5 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end

    local result, button, _, lop = sampHasDialogRespond(27896)
    if result and button == 1 then
        mainini.flood.fltext5 = lop
        inicfg.save(mainini, 'bd')
        flood_menu()
    end
end

function dialogsMenu()
    local result, button, list, _ = sampHasDialogRespond(2956)
if result and button == 1 then
    if list == 0 then
        edit_userid()
    end
    if list == 1 then
        mainini.afk.uvedomleniya = not mainini.afk.uvedomleniya
        inicfg.save(mainini, 'bd')
        afk_menu()
    end
    if list == 2 then
        mainini.afk.antiafk = not mainini.afk.antiafk
        inicfg.save(mainini, 'bd')
        afk_menu()
    end
end


            local result, button, list, _ = sampHasDialogRespond(2138)
			if result and button == 1 then
                if list == 0 then
                    edit_pass()
                end
                if list == 1 then
                    edit_bank()
                end
                if list == 2 then
                    flood_menu()
                end
                if list == 3 then
                    lidzam_menu()
                end
                if list == 4 then
                    binder_menu()
                end
                if list == 5 then
                    wh_cops_pidors()
                end
                if list == 6 then
                    afk_menu()
                end
                if list == 7 then
                    chatlog_menu()
                end
                if list == 8 then
                    target_menu()
                end
                if list == 9 then
                    piss_menu()
                end
                if list == 10 then
                    eda_menu()
                end
                if list == 11 then
                    sunduk_menu()
                end
                if list == 12 then
                    mainini.functions.famkv = not mainini.functions.famkv	
					inicfg.save(mainini, 'bd')
					menu()
                end
                if list == 13 then
					mainini.functions.arecc = not mainini.functions.arecc	
					inicfg.save(mainini, 'bd')
					menu()
				end
                if list == 14 then
                    sampShowDialog(3905, "{00CC00}������ ������ | �������", buttonslist, "�������", _, 2)
                end
                if list == 15 then 
                    drugoenosoft_menu()
                end
                if list == 16 then
                    drugoesoft_menu()
                end
                if list == 17 then
					edit_sbiv()
				end
                if list == 18 then
					edit_allsbiv()
				end
                if list == 19 then
					edit_suicide()
				end
                if list == 20 then
					edit_shook()
				end
			end

            local result, button, list, lop = sampHasDialogRespond(4969)
			if result and button == 1 then
                if list == 1 then
                    mainini.autoeda.eda = not mainini.autoeda.eda
					inicfg.save(mainini, 'bd')
					eda_menu()
                end
                if list == 2 then
                    mainini.autoeda.meatbag = not mainini.autoeda.meatbag
					inicfg.save(mainini, 'bd')
					eda_menu()
                end
                if list == 3 then
                    sampShowDialog(49169, '{fff000}���������', string.format([[
{ffffff}������� �������, � ������� ������� �������� ��������� ��������.
��������: /jmeat, /chips � �.�.
������� �������: {20B2AA}%s]], 
                        mainini.autoeda.comeda), 
                        '���������', '�������', 1)
                end
			end

            local result, button, list, lop = sampHasDialogRespond(9079)
			if result and button == 1 then
                if list == 1 then
                    work = not work
					sunduk_menu()
                end
                if list == 2 then
                    sampShowDialog(1080, '{fff000}���������', string.format([[
{ffffff}������� �������� � �������.
������� ��������: {20B2AA}%s ���.]], 
                        mainini.sunduk.waiting), 
                        '���������', '�������', 1)
                end
                if list == 3 then
                    mainini.sunduk.checkbox_standart = not mainini.sunduk.checkbox_standart
					inicfg.save(mainini, 'bd')
					sunduk_menu()
                end
                if list == 4 then
                    mainini.sunduk.checkbox_platina = not mainini.sunduk.checkbox_platina
					inicfg.save(mainini, 'bd')
					sunduk_menu()
                end
                if list == 5 then
                    mainini.sunduk.checkbox_mask = not mainini.sunduk.checkbox_mask
					inicfg.save(mainini, 'bd')
					sunduk_menu()
                end
                if list == 6 then
                    mainini.sunduk.checkbox_donate = not mainini.sunduk.checkbox_donate
					inicfg.save(mainini, 'bd')
					sunduk_menu()
                end
                if list == 7 then
                    mainini.sunduk.checkbox_tainik = not mainini.sunduk.checkbox_tainik
					inicfg.save(mainini, 'bd')
					sunduk_menu()
                end
			end

            local result, button, list, lop = sampHasDialogRespond(4169)
			if result and button == 1 then
                if list == 1 then
                    mainini.oboss.piss1 = not mainini.oboss.piss1
					inicfg.save(mainini, 'bd')
					piss_menu()
                end
                if list == 2 then
                    mainini.oboss.piss2 = not mainini.oboss.piss2
					inicfg.save(mainini, 'bd')
					piss_menu()
                end
                if list == 3 then
                    mainini.oboss.piss3 = not mainini.oboss.piss3
					inicfg.save(mainini, 'bd')
					piss_menu()
                end
                if list == 4 then
                    sampShowDialog(41691, '{fff000}���������', string.format([[
{ffffff}��� ����������� ���� ������ ����� ������ ���� �������� � ����� s
������� ����� �����������:
{20B2AA}%s]], 
                        mainini.oboss.pisstext), 
                        '���������', '�������', 1)
                end
                if list == 5 then
                    sampShowDialog(44169, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
                        mainini.oboss.obossactiv), 
                        '���������', '�������', 1)
                end
                if list == 6 then
                    sampShowDialog(43169, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
                        mainini.oboss.animactiv), 
                        '���������', '�������', 1)
                end
                if list == 7 then
                    sampShowDialog(42169, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
                        mainini.oboss.pissactiv), 
                        '���������', '�������', 1)
                end
			end

            local result, button, list, lop = sampHasDialogRespond(4119)
			if result and button == 1 then
                if list == 0 then
                    sampShowDialog(41191, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: ���+{00ffff}%s]], 
                        mainini.target.cure), 
                        '���������', '�������', 1)
                end
                if list == 1 then
                    sampShowDialog(41169, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: ���+{00ffff}%s]], 
                        mainini.target.free), 
                        '���������', '�������', 1)
                end
                if list == 2 then
                    sampShowDialog(41291, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: ���+{00ffff}%s]], 
                        mainini.target.kiss), 
                        '���������', '�������', 1)
                end
                if list == 3 then
                    sampShowDialog(43291, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
                        mainini.target.trunk), 
                        '���������', '�������', 1)
                end
			end

            local result, button, _, lop = sampHasDialogRespond(44169)
            if result and button == 1 then
                mainini.oboss.obossactiv = lop
                inicfg.save(mainini, 'bd')
                piss_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(49169)
            if result and button == 1 then
                mainini.autoeda.comeda = lop
                inicfg.save(mainini, 'bd')
                eda_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(1080)
            if result and button == 1 then
                mainini.sunduk.waiting = lop
                inicfg.save(mainini, 'bd')
                sunduk_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(43169)
            if result and button == 1 then
                mainini.oboss.animactiv = lop
                inicfg.save(mainini, 'bd')
                piss_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(41691)
            if result and button == 1 then
                mainini.oboss.pisstext = lop
                inicfg.save(mainini, 'bd')
                piss_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(42169)
            if result and button == 1 then
                mainini.oboss.pissactiv = lop
                inicfg.save(mainini, 'bd')
                piss_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(41191)
            if result and button == 1 then
                mainini.target.cure = lop
                inicfg.save(mainini, 'bd')
                target_menu()
            end
            local result, button, _, lop = sampHasDialogRespond(41291)
            if result and button == 1 then
                mainini.target.kiss = lop
                inicfg.save(mainini, 'bd')
                target_menu()
            end
            local result, button, _, lop = sampHasDialogRespond(43291)
            if result and button == 1 then
                mainini.target.trunk = lop
                inicfg.save(mainini, 'bd')
                target_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(41169)
            if result and button == 1 then
                mainini.target.free = lop
                inicfg.save(mainini, 'bd')
                target_menu()
            end

            local result, button, list, lop = sampHasDialogRespond(2787)
			if result and button == 1 then
                if list == 0 then
                    floodon1 = not floodon1
                    if floodon1 then 
                        floodka1 = lua_thread.create(flood1) 
                    else
                        lua_thread.terminate(floodka1) 
                    end
                    flood_menu()
                end
                if list == 1 then
                    sampShowDialog(27871, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.flood.flwait1), 
                        '���������', '�������', 1)
                end
                if list == 2 then
                    sampShowDialog(27872, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.flood.fltext1), 
                        '���������', '�������', 1)
                end
                if list == 3 then
                    floodon2 = not floodon2
                    if floodon2 then 
                        floodka2 = lua_thread.create(flood2) 
                    else
                        lua_thread.terminate(floodka2) 
                    end
                    flood_menu()
                end
                if list == 4 then
                    sampShowDialog(27873, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.flood.flwait2), 
                        '���������', '�������', 1)
                end
                if list == 5 then
                    sampShowDialog(27874, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.flood.fltext2), 
                        '���������', '�������', 1)
                end
                if list == 6 then
                    floodon3 = not floodon3
                    if floodon3 then 
                        floodka3 = lua_thread.create(flood3) 
                    else
                        lua_thread.terminate(floodka3) 
                    end
                    flood_menu()
                end
                if list == 7 then
                    sampShowDialog(27875, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.flood.flwait3), 
                        '���������', '�������', 1)
                end
                if list == 8 then
                    sampShowDialog(27876, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.flood.fltext3), 
                        '���������', '�������', 1)
                end
                if list == 9 then
                    floodon4 = not floodon4
                    if floodon4 then 
                        floodka4 = lua_thread.create(flood4) 
                    else
                        lua_thread.terminate(floodka4) 
                    end
                    flood_menu()
                end
                if list == 10 then
                    sampShowDialog(27885, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.flood.flwait4), 
                        '���������', '�������', 1)
                end
                if list == 11 then
                    sampShowDialog(27886, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.flood.fltext4), 
                        '���������', '�������', 1)
                end
                if list == 12 then
                    floodon5 = not floodon5
                    if floodon5 then 
                        floodka5 = lua_thread.create(flood5) 
                    else
                        lua_thread.terminate(floodka5) 
                    end
                    flood_menu()
                end
                if list == 13 then
                    sampShowDialog(27895, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.flood.flwait5), 
                        '���������', '�������', 1)
                end
                if list == 14 then
                    sampShowDialog(27896, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.flood.fltext5), 
                        '���������', '�������', 1)
                end
			end


            local result, button, _, lop = sampHasDialogRespond(2741)
            if result and button == 1 then
                if list == 0 then
                    mainini.lidzamband.devyatka = not mainini.lidzamband.devyatka 
                    inicfg.save(mainini, 'bd')
                    lidzam_menu()
                end
                if list == 1 then
                    lidzamband_menu()
                end
                if list == 2 then
                    mainini.lidzammafia.devyatka = not mainini.lidzammafia.devyatka 
                    inicfg.save(mainini, 'bd')
                    lidzam_menu()
                end
                if list == 3 then
                    lidzammafia_menu()
                end
            end
            
            local result, button, _, lop = sampHasDialogRespond(2790)
            if result and button == 1 then
                if list == 0 then
                    sampShowDialog(27411, '{fff000}���������', string.format([[
{ffffff}�������� �������� ����� �����
������� ��������: {F08080}%s]], 
                        mainini.lidzamband.band), 
                        '���������', '�������', 1)
                end
                if list == 1 then
                    sampShowDialog(21411, '{fff000}���������', string.format([[
{ffffff}�������� c ������ �������� ������ ��������� ��������� �� �����
������� �������: {F08080}%s lvl]], 
                        mainini.lidzamband.minlvl), 
                        '���������', '�������', 1)
                end
                if list == 2 then
                    sampShowDialog(22411, '{fff000}���������', string.format([[
{ffffff}�������� �� ����� ���� ��������� ������� � �����
������� ����: {F08080}%s rank]], 
                        mainini.lidzamband.minrank), 
                        '���������', '�������', 1)
                end
                if list == 3 then
                    ghetto_lidzam_flood()
                end
                if list == 4 then
                    naborgon = not naborgon
                    --inicfg.save(mainini, 'bd')
                    if naborgon then 
                        naborgka = lua_thread.create(naborg) 
                    else
                        lua_thread.terminate(naborgka) 
                    end
                    lidzamband_menu()
                end
                if list == 5 then
                    sampShowDialog(27418, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.naborgwait), 
                        '���������', '�������', 1)
                end
                if list == 6 then
                    sampShowDialog(27417, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� ����� � ������
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.naborgtext), 
                        '���������', '�������', 1)
                end

            end

            local result, button, list, lop = sampHasDialogRespond(22487)
			if result and button == 1 then
                if list == 0 then
                    floodong1 = not floodong1
                    if floodong1 then 
                        floodkag1 = lua_thread.create(floodg1) 
                    else
                        lua_thread.terminate(floodkag1) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 1 then
                    floodong2 = not floodong2
                    if floodong2 then 
                        floodkag2 = lua_thread.create(floodg2) 
                    else
                        lua_thread.terminate(floodkag2) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 2 then
                    floodong3 = not floodong3
                    if floodong3 then 
                        floodkag3 = lua_thread.create(floodg3) 
                    else
                        lua_thread.terminate(floodkag3) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 3 then
                    floodong4 = not floodong4
                    if floodong4 then 
                        floodkag4 = lua_thread.create(floodg4) 
                    else
                        lua_thread.terminate(floodkag4) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 4 then
                    floodong5 = not floodong5
                    if floodong5 then 
                        floodkag5 = lua_thread.create(floodg5) 
                    else
                        lua_thread.terminate(floodkag5) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 5 then
                    floodong6 = not floodong6
                    if floodong6 then 
                        floodkag6 = lua_thread.create(floodg6) 
                    else
                        lua_thread.terminate(floodkag6) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 6 then
                    floodong7 = not floodong7
                    if floodong7 then 
                        floodkag7 = lua_thread.create(floodg7) 
                    else
                        lua_thread.terminate(floodkag7) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 7 then
                    floodong8 = not floodong8
                    if floodong8 then 
                        floodkag8 = lua_thread.create(floodg8) 
                    else
                        lua_thread.terminate(floodkag8) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 8 then
                    floodong9 = not floodong9
                    if floodong9 then 
                        floodkag9 = lua_thread.create(floodg9) 
                    else
                        lua_thread.terminate(floodkag9) 
                    end
                    ghetto_lidzam_flood()
                end
                if list == 9 then
                    sampShowDialog(2911, '{fff000}��������� FL1', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait1), 
                        '���������', '�������', 1)
                end
                if list == 10 then
                    sampShowDialog(2811, '{fff000}��������� FL1', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext1), 
                        '���������', '�������', 1)
                end
                if list == 11 then
                    sampShowDialog(2912, '{fff000}��������� FL2', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait2), 
                        '���������', '�������', 1)
                end
                if list == 12 then
                    sampShowDialog(2812, '{fff000}��������� FL2', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext2), 
                        '���������', '�������', 1)
                end
                if list == 13 then
                    sampShowDialog(2913, '{fff000}��������� FL3', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait3), 
                        '���������', '�������', 1)
                end
                if list == 14 then
                    sampShowDialog(2813, '{fff000}��������� FL3', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext3), 
                        '���������', '�������', 1)
                end
                if list == 15 then
                    sampShowDialog(2914, '{fff000}��������� FL4', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait4), 
                        '���������', '�������', 1)
                end
                if list == 16 then
                    sampShowDialog(2814, '{fff000}��������� FL4', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext4), 
                        '���������', '�������', 1)
                end
                if list == 17 then
                    sampShowDialog(2915, '{fff000}��������� FL5', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait5), 
                        '���������', '�������', 1)
                end
                if list == 18 then
                    sampShowDialog(2815, '{fff000}��������� FL5', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext5), 
                        '���������', '�������', 1)
                end
                if list == 19 then
                    sampShowDialog(2916, '{fff000}��������� FL6', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait6), 
                        '���������', '�������', 1)
                end
                if list == 20 then
                    sampShowDialog(2816, '{fff000}��������� FL6', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext6), 
                        '���������', '�������', 1)
                end
                if list == 21 then
                    sampShowDialog(2917, '{fff000}��������� FL7', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait7), 
                        '���������', '�������', 1)
                end
                if list == 22 then
                    sampShowDialog(2817, '{fff000}��������� FL7', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext7), 
                        '���������', '�������', 1)
                end
                if list == 23 then
                    sampShowDialog(2918, '{fff000}��������� FL8', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait8), 
                        '���������', '�������', 1)
                end
                if list == 24 then
                    sampShowDialog(2818, '{fff000}��������� FL8', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext8), 
                        '���������', '�������', 1)
                end
                if list == 25 then
                    sampShowDialog(2919, '{fff000}��������� FL9', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzamband.flwait9), 
                        '���������', '�������', 1)
                end
                if list == 26 then
                    sampShowDialog(2819, '{fff000}��������� FL9', string.format([[
{ffffff}������� ����� ��� �����
������� �����:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext9), 
                        '���������', '�������', 1)
                end
                
			end

            local result, button, _, lop = sampHasDialogRespond(2859)
            if result and button == 1 then
                if list == 0 then
                    edit_wh()
                end
                if list == 1 then
                    mainini.functions.activement = not mainini.functions.activement	
					inicfg.save(mainini, 'bd')
					wh_cops_pidors()
                end
                if list == 2 then
                    mainini.functions.uvedomusora = not mainini.functions.uvedomusora	
					inicfg.save(mainini, 'bd')
					wh_cops_pidors()
                end
                if list == 3 then
                    sampShowDialog(28599, '{fff000}���������', string.format([[
{ffffff}������ ��� �������� ������� ���� �������� � �� � ������
������� �������: %s]], 
                        mainini.functions.fastnosoft), 
                        '���������', '�������', 1)
                end
                if list == 4 then
                    sampShowDialog(3905, "{00CC00}������ �������", renderlist, "�������", _, 2)
                end
            end

            local result, button, _, lop = sampHasDialogRespond(23388)
            if result and button == 1 then
                if list == 0 then
                    mainini.functions.binder = not mainini.functions.binder	
					inicfg.save(mainini, 'bd')
					binder_menu()
                end
                if list == 1 then
                    binder_info()
                end
            end  
            
            local result, button, _, lop = sampHasDialogRespond(2250)
            if result and button == 1 then
                mainini.config.wh = lop
                inicfg.save(mainini, 'bd')
                menu()
            end
            
            local result, button, _, lop = sampHasDialogRespond(2252)
            if result and button == 1 then
                mainini.config.allsbiv = lop
                inicfg.save(mainini, 'bd')
                menu()
            end


            local result, button, _, lop = sampHasDialogRespond(2293)
            if result and button == 1 then
                mainini.config.shook = lop
                inicfg.save(mainini, 'bd')
                menu()
            end

            local result, button, _, lop = sampHasDialogRespond(2299)
            if result and button == 1 then
                mainini.config.tramp = lop
                inicfg.save(mainini, 'bd')
                menu()
            end

            local result, button, _, lop = sampHasDialogRespond(2253)
            if result and button == 1 then
                mainini.config.sbiv = lop
                inicfg.save(mainini, 'bd')
                menu()
            end
            
            local result, button, _, lop = sampHasDialogRespond(2251)
            if result and button == 1 then
                mainini.config.suicide = lop
                inicfg.save(mainini, 'bd')
                menu()
            end

            local result, button, _, lop = sampHasDialogRespond(2139)
            if result and button == 1 then
                mainini.helper.user_id = lop
                inicfg.save(mainini, 'bd')
                afk_menu()
                sendvknotf('�������� ���������')
            end
            local result, button, _, lop = sampHasDialogRespond(21391)
            if result and button == 1 then
                mainini.helper.password = lop
                inicfg.save(mainini, 'bd')
                menu()
            end
            local result, button, _, lop = sampHasDialogRespond(21392)
            if result and button == 1 then
                mainini.helper.bankpin = lop
                inicfg.save(mainini, 'bd')
                menu()
            end
        end