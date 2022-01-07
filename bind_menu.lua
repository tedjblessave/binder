local encoding = require 'encoding'
local lanes = require('lanes').configure()
local sp  = require 'lib.samp.events'
local se = require "samp.events"
local weapons = require 'game.weapons'
local mem = require "memory" 
local memory = require 'memory'
local as_action = require('moonloader').audiostream_state
local inicfg = require 'inicfg'
local effil = require("effil")
local vkeys = require 'vkeys'
local dlstatus = require('moonloader').download_status
local wm = require 'lib.windows.message'
local rkeys = require 'rkeys'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local poss = false

local captureon = false

local fixbike = false

local fontvip = renderCreateFont("Arial", 10, 9)

local activeextra = false

update_state = false
 
local script_vers = 16
local script_vers_text = "16.00"

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
    functions = {
        dotmoney=true,
        dhits=false,
        fish=false,
        extra=false,
        bott=false,
        autoc=false,
        hphud=true,
        fastmap=false,
        chatvipka=false,
        colorchat=false,
        offrabchat=false,
        offfrachat=false,
        activement=true,
        activepidor=true,
        binder = false,
        autott = false,
        arecc = false
    },
    lidzam = { 
        devyatka = false,
        nabortext="/vr ����� � �� 'The Rifa'. /smug /port | �������� ��� �� ��������.",
        naborwait="180",
        band="The Rifa"
    },
    config = {
        allsbiv="V",
        sbiv="Z",
        suicide="F10",
        wh="MBUTTON",
        fmap="XBUTTON1",
        shook="1",
        tramp="7",
        autodhits="E",
        autoplusc="XBUTTON2"
    },
    flood = {
        fltext3="/j ���������",
        flwait2="180",
        flwait1="180",
        flwait3="15",
        fltext1="/vr ����� �������� �����-������� � �������� full ����� nuestra. 18+, 60+fps fullHD. vk: @blessave",
        fltext2="/vr �������"
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
    autoeda = {
        eda = false,
        meatbag = false,
        comeda = "/jmeat"
    },
    afk = {
        uvedomleniya = false,
    }
}, 'bd')
inicfg.save(mainini, 'bd.ini')


--local mainini = inicfg.load(nil, "settings")
--local maintxt = inicfg.load(nil, "pidorasi.txt")
   -- inicfg.save(mainini, 'moonloader\\config.ini') 
----------------------------------------------------------------------------------------------------------------------------------------------------------

local maintxt = inicfg.load({
    pidors = {    },
}, 'pidorasi')
--if not doesFileExist('moonloader/config/pidorasi.ini') then inicfg.save(maintxt, 'pidorasi.ini') end
------------------------------------------------------------------------------------------------------------------------------------------------------------
local fontt = renderCreateFont('Arial', 10, 9)
local fo0nt = renderCreateFont('Tahoma', 9, 5)

local sukazaebalmutit = 0

bike = {[481] = true, [509] = true, [510] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true, [3196] = true, [3194] = true}

local fam = {'Family', 'Empire', 'Squad', 'Dynasty', 'Corporation', 'Crew', 'Brotherhood'}


notkey = false
local locked = false

floodon1 = false
floodon2 = false
floodon3 = false

naboron = false


---------------
----------



local vknotf = {
	ispaydaystate = false,
	ispaydayvalue = 0,
	ispaydaytext = '',
    chatc = false,
    chatf = false,
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
                           elseif pl.button == 'openchest' then
								openchestrulletVK()
                            elseif pl.button == 'hungry' then
								getPlayerArzHun()
                            elseif pl.button == 'chatchat' then
								chatchatVK()
                            elseif pl.button == 'famchat' then
								famchatVK()
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
						text = text:sub(1, text:len() - 1)
						sampProcessChatInput(u8:decode(text))
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
    if sampIsLocalPlayerSpawned() then
	msg = ''..host..' | Online:' .. sampGetPlayerCount(false) ..'\n'..acc..' | Health: '.. getCharHealth(PLAYER_PED) ..' | Ping: '..sampGetPlayerPing(id)..'\n'..msg
	else
    msg = ''..host..' | Online:' .. sampGetPlayerCount(false) ..'\n'..acc..'\n'..msg
    end
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
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = '������'
    row2[1] = {}
	row2[1].action = {}
	row2[1].color = trubka and 'negative' or 'positive'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "razgovor"}'
	row2[1].action.label = trubka and '�������� ������' or '������� ������'
    row3[1] = {}
	row3[1].action = {}
	row3[1].color = vklchat and 'secondary' or 'primary'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "chatchat"}'
	row3[1].action.label = vklchat and '����. ���� ���' or '���. ���� ���'
    row3[2] = {}
	row3[2].action = {}
	row3[2].color = vklchatfam and 'primary' or 'secondary'
	row3[2].action.type = 'text'
	row3[2].action.payload = '{"button": "famchat"}'
	row3[2].action.label = vklchatfam and '���. fam ���' or '����. fam ���'
    row3[3] = {}
	row3[3].action = {}
	row3[3].color = vklchatdialog and 'secondary' or 'primary'
	row3[3].action.type = 'text'
	row3[3].action.payload = '{"button": "alldialogs"}'
	row3[3].action.label = vklchatdialog and '����. �������' or '���. �������'
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
	response = response .. '����������: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
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


   
local health = 0xBAB22C

-- fast gun
local anim_gun = 1369
local usee=2302
local next_page=2111
local d_id = 3011
local closegun = 2110
local dialog_exist = false

---Weapons---

local deagle = 348
local deagle_id = -1

local m4=356
local m4_id=-1

local ak=355
local ak_id= -1

local shotgun = 349
local shotgun_id = -1

local mp5 = 353
local mp5_id = -1

local rifle = 357
local rifle_id = -1

local pistol = 346
local pistol_id = -1

---Other---
local using = 0
local anim_play = 0
local mod = 0
local amount = 0
local cmd = 0
local random = 0 
local ammo = 1
local td_exist = 0

local ScriptState = false
local ScriptState2 = false
local ScriptState3 = false
local ScriptState4 = false
local autoaltrend = false
local enabled = false
local olenina = false
local status = false
local graffiti = false

local on = false
local draw_suka = false
local mark = nil
local dtext = nil

local x, y, z = 0, 0, 0


local use = false
local close = false
local use1 = false
local close1 = false



local checked_test = false
local checked_test2 = false
local checked_test3 = false
local checked_test4 = false
local zadervka = 5
local zadervka1 = 5
local zadervka2 = 5
local zadervka3 = 5 

local Counter = 0

local automeatbag = false

local fix = false
local activrsdf = false

local miningtool = true
local automining_status = false
local automining_getbtc = 0
local automining_startall = 0
local automining_fillall = 0

local oxladtime = 224 -- ����, �� ������� ������ ������

local INFO = { 
    0.029999,
    0.059999,
    0.09,
    0.11999,
    0.15,
    0.18,
	0.209999,
	0.239999,
	0.27,
	0.3
} -- ������� � ��� �� ���

local dtextm = {} 


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


local icons = {
    markers = 0,
    cords = {
    }
}
 
local mymark = {}
local active = true
local selected = nil
local configDir = getWorkingDirectory().."\\config\\waxta.json"
jsoncfg = {
    save = function(data, path)
        if doesFileExist(path) then os.remove(path) end
        if type(data) ~= 'table' then return end
        local f = io.open(path, 'a+')
        local writing_data = encodeJson(data)
        f:write(writing_data)
        f:close() 
    end,
    load = function(path)
        if doesFileExist(path) then
          local f = io.open(path, 'a+')
          local data = decodeJson(f:read('*a'))
          f:close()
          return data
        end
    end
}
if not doesDirectoryExist(getWorkingDirectory().."\\config") then createDirectory(getWorkingDirectory().."\\config") end
if doesFileExist(configDir) then icons = jsoncfg.load(configDir) end --jsoncfg.save(icons, configDir) else



reduceZoom = true


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


local trigbott = true

function sequent_async_http_request(method, url, args, resolve, reject)
    if not _G['lanes.async_http'] then
        local linda = lanes.linda()
        local lane_gen = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
            local requests = require 'requests'
            while true do
                local key, val = linda:receive(50 / 1000, 'request')
                if key == 'request' then
                    local ok, result = pcall(requests.request, val.method, val.url, val.args)
                    if ok then
                        result.json, result.xml = nil, nil
                        linda:send('response', result)
                    else
                        linda:send('error', result)
                    end
                end
            end
        end)
        _G['lanes.async_http'] = {lane = lane_gen(), linda = linda}
    end
    local lanes_http = _G['lanes.async_http']
    lanes_http.linda:send('request', {method = method, url = url, args = args})
    lua_thread.create(function(linda)
        while true do
            local key, val = linda:receive(0, 'response', 'error')
            if key == 'response' then
                return resolve(val)
            elseif key == 'error' then
                return reject(val)
            end
            wait(0)
        end
    end, lanes_http.linda)
end

function iin(list, what_find, mode) -- vk.com/fottes
    if what_find and type(what_find) ~= 'table' then
        local set = {}
        for _, l in ipairs(list) do set[l] = true end
        return set[what_find] and true or false
    elseif type(what_find) == 'table' then
        if not mode or mode == false then
            local set = {}
            for _, l in ipairs(list) do set[l] = true end
            for _, l in ipairs(what_find) do if set[l] then return true end end
        elseif mode == true then
            local set = {}
            local res = nil
            for _, l in ipairs(list) do set[l] = true end
            for k,v in pairs(what_find) do if set[v] then res = true else res = false end end
            return res
        end
    end
end


local dialogTabArr = {}
local dialogTabStr = ""
local keyl = 'AAF0rwwhGQ1-qPZL1sCP7s6rqCL7uuajy54' -- 



function menu()
	sampShowDialog(2138, 'off: {ff0000}SHIFT+F5 {ffffff}| update: {AFEEEE}/ub {ffffff}| legal: {8A2BE2}SHIFT+F2 {ffffff}| vers: {EE82EE}'..script_vers, string.format([[
{7CFC00}����������� �������
{DC143C}��������� �������
{DA70D6}��������
{1E90FF}����� ������/�����������
{9ACD32}������ binds.bind
{BC8F8F}������ ��� ���������. �������� (id)
{C0C0C0}����-���
{DEB887}���-���
{ff4500}�����������
{E9967A}����-���]]),  
    '�������', '�������', 2)
end
--[[ {ffffff}1. �������� ��������� ����������� (������, ��������� �� �������, ������ �� �������� � �.�.)
{ffffff}2. �������� �������� ��� ������� � ��������� ��� ����� VK. !d (text) !d (������ � �������)
{ffffff}3. �������� ���� ���
{ffffff}4. �������� �������� ���, �������
5. ����� ������������� �� �������� (���� �������� ������ �� ���������) ]]
function afk_menu()
	sampShowDialog(2956, '{fff000}����-���', string.format([[
�������� �������� ID {00ffff}VK 
�������� ����� (�� �������)
�������� �������� ID VK ������ (�� �������)
���������� ��������� ����������� %s {ffffff}(������ ��� ��������)
]],
mainini.afk.uvedomleniya and '{00ff00}ON' or '{777777}OFF'),  
    '�������', '�������', 2)
end

function chatlog_menu()
    sampShowDialog(10647, "{fff000}���-���", string.format([[
{ffffff}/ch
{ffffff}/ch �����
{ffffff}/chh
]]), "�����", _, 0)
end

function pidor_opis()
    sampShowDialog(28591, '{fff000}��������', string.format([[
{ffffff}�������� ���� ������ ��������� - {DDA0DD}/pidors
{ffffff}�������� ������ ��������� {2CFF00}������ {ffffff}- {DDA0DD}/onpidors
{ffffff}�������� ������ ��������� {ff0000}������� {ffffff}- {DDA0DD}/offpidors

{ffffff}�������� �������� � ������ - {DDA0DD}/addpidor (id) ��� (Nick_Name)
{ffffff}������� �� ������ - {DDA0DD}/delpidor (Nick_Name)
]]),  
    '�������', _, 0)
end

function drugoenosoft_menu()
	sampShowDialog(2938, '{fff000}����������', string.format([[
{ffffff}1. ���������� ������ ��������� - {DDA0DD}/de /m4 /rf /sg /mp5 /pst /ak
{ffffff}2. ������� ����������� ������� ������
{ffffff}3. ����������� �������: {DDA0DD}/members - /mb, /findihouse - /fh, /findibiz - /fbiz, /fam - /k
{ffffff}4. ������� ������ ���� ������ - /cln
{ffffff}5. ������� �������� ���� ���� /home - ALT � ���� (��� ����� 20, 46, 47, 48, 57)
{ffffff}6. �������� ������� ������� ������ �� ����
{ffffff}7. ������� ����� � ����, ��� �������, ��� �������
{ffffff}8. ����-/key
{ffffff}9. ����-���������
{ffffff}10. ����������� - {DDA0DD}/calc
{ffffff}11. ����-������ ������� �������� �������� - {DDA0DD}/fpay
{ffffff}12. ����-������ ������� �� ������� - {DDA0DD}/trpay
{ffffff}13. ����-�������� ��� �������� ��������� � /vr
{ffffff}14. ����-��������� �������� � ��������� - {DDA0DD}/rlt + {ffffff}���� ��������� � ������ ����
{ffffff}15. ������ � ���� � ������������ - {DDA0DD}/eathome
{ffffff}16. ������� ������� � ������ ��� /jail
{ffffff}17. ������� ������� � ������ ��� /mute
{ffffff}18. ����� ���� ���� ���� - /gcolors
{ffffff}19. ������ ���� ���� �� ��� �� /dl - /getcolor
{ffffff}20. ������� ���� - /cchat
{ffffff}21. ����-����� ������ � ������� - {DDA0DD}/ptguram
{ffffff}22. ����� � �������� /sms
{ffffff}23. ����������� �� ������ �������, ���� �� ������
{ffffff}24. ����-������ ����, ������, �����������
25. ��� ���������: ��� + CapsLock �� ����, ����� ���������� ������ ��������
]]),  
    '�������', _, 0)
end

function drugoesoft_menu()
	sampShowDialog(2939, '{fff000}����������', string.format([[
{ffffff}1. ��������� ���. ��������� ��� ��������� �������, ������� ����� ������� �� ������. �� ���� �������� ��, ��, �����, �� � �.�. - {FF7F50}SHIFT+F2
{ffffff}2. ������ ������� ���� c ����-������ - {FF7F50}/rend
{ffffff}3. ������ ����� ���� ��� ������ - {FF7F50}/probiv
{ffffff}4. ������ WallHack � �������� ������� � ���������
{ffffff}5. ��������� ������ ��������� {FF7F50}/pidors /addpidor /delpidor
{ffffff}6. ����-������ ��� �������� � ���������� - ������ {ff0000}SHIFT
{ffffff}7. �������� GM-car - ������ {ff0000}SHIFT
{ffffff}8. ����-���� ����: ������ ������/������� - ������ {ff0000}1{ffffff}, ������ �� ������/���� - ������ {ff0000}SHIFT{ffffff}, ������� ������ �� ������ - {ff0000}C
{ffffff}9. ����-�����
{ffffff}10. ��������� - {FF7F50}/hrec. {ffffff}����-���������
{ffffff}11. ����-����� - {ff0000}��� � ������
{ffffff}12. ������� ��������� - {ff0000}��� � ������
{ffffff}13. �������� - {FF7F50}7 � ������
{ffffff}14. ����������� ���
{ffffff}15. �������� ����-������� � ����������/���� - ������ {ff0000}SHIFT. {ffffff}����������: � ���� ������ �� ��������
{ffffff}16. ���-��� - C+1, C+2
{ffffff}17. ����-��� ���� �����
]]),  
    '�������', _, 0)
end

function lidzam_menu()
    sampShowDialog(2741, '{fff000}����� ������/����', string.format([[
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
    naboron and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzam.naborwait,
    mainini.lidzam.nabortext),
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
{7FFFD4}%s]], 
    floodon1 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait1,
    mainini.flood.fltext1, 
    floodon2 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait2,
    mainini.flood.fltext2, 
    floodon3 and '{00ff00}ON' or '{777777}OFF', 
    mainini.flood.flwait3,
    mainini.flood.fltext3),
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
{FFA07A}{"text":"���� ����[enter]","v":[82]}
{ffffff}�����: ����� ����� ��� ���� ���� ([enter] - ��������� �����, ���� �� ������ �� ������ ������ �������� � ����), 82 - ��� ID �������. � ������ ������ ������� R.

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

function whcoppidr_instr()
	sampShowDialog(2958, '{Fff000}����������', string.format([[
{ffffff}� ������� ������� {fff000}\\moonloader\\config\\binds.bind {ffffff}��������� ���������:
����� �������� ������ ����� � ����� ������ ��������� ������� ����� ����������� ���������� ������� � �������:
{FFA07A}{"text":"���� ����[enter]","v":[82]}
{ffffff}�����: ����� ����� ��� ���� ���� ([enter] - ��������� �����, ���� �� ������ �� ������ ������ �������� � ����), 82 - ��� ID �������. � ������ ������ ������� R.

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

function nosoft_menu()
	sampShowDialog(21381, '{fff000}����������� �������', string.format([[
��-��� %s
���������� ������� ����� %s
������� ���������� ����� %s
������� ���������� �����. ���������: {00ffff}%s
������� ��� %s
����������� VIP-chat %s
����������� ��� %s
������� ��� %s
����-��������� %s
�������� ������ ��� ����-������
�������� ���-��� ��� �����
{DAA520}��������� ����������]], 
	mainini.functions.hphud and '{00ff00}ON' or '{777777}OFF', 
	mainini.functions.dotmoney and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.fastmap and '{00ff00}ON' or '{777777}OFF',
    mainini.config.fmap,
    mainini.functions.colorchat and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.chatvipka and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.offfrachat and '{777777}OFF' or '{00ff00}ON',
    mainini.functions.offrabchat and '{777777}OFF' or '{00ff00}ON',
    mainini.functions.autott and '{00ff00}ON' or '{777777}OFF'),
    '�������', '�������', 2)
end

function soft_menu()
	sampShowDialog(21383, '{fff000}��������� �������', string.format([[����� ���� %s
����-���. ���������: {000fff}ALT+V. %s
������ WS. ���������: {000fff}SHIFT+9. %s
����-+� %s
��������� ����-+�
����-����-���� %s
��������� ����-����-����
C��� ������. ���������:{00ffff} %s
������� ����� � ����������. ���������:{00ffff} %s
������������. ���������:{00ffff} %s
{c0c0c0}WallHack. {0000ff}Cops. {da70d6}Pidors.
SprintHook. ���������:{00ffff} %s
��������. ���������:{00ffff} %s
{ffffff}���������: {ff4500}/hrec {ffffff}| ����-��������� %s
{DAA520}��������� ����������]], 
	mainini.functions.fish and '{00ff00}ON' or '{777777}OFF', 
	mainini.functions.bott and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.extra and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.autoc and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.dhits and '{00ff00}ON' or '{777777}OFF',
    mainini.config.sbiv,
    mainini.config.allsbiv,
    mainini.config.suicide,
    mainini.config.shook,
    mainini.config.tramp,
    mainini.functions.arecc and '{00ff00}ON' or '{777777}OFF'),
    '�������', '�������', 2)
end

function wh_cops_pidors()
	sampShowDialog(2859, '{fff000}{c0c0c0}WallHack. {0000ff}Cops. {da70d6}Pidors.', string.format([[���������� {ff0000}[�����]
WallHack. ���������:{00ffff} %s
�������� ������� %s
�������� ��������� %s
{DAA520}��������]], 
    mainini.config.wh,
	mainini.functions.activement and '{00ff00}ON' or '{777777}OFF', 
	mainini.functions.activepidor and '{00ff00}ON' or '{777777}OFF'),
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


function edit_tramp()
	sampShowDialog(2299, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.tramp), 
'���������', '�������', 1)
end

function edit_allsbiv()
	sampShowDialog(2252, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.allsbiv), 
'���������', '�������', 1)
end

function edit_autoc()
	sampShowDialog(22526, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.autoplusc), 
'���������', '�������', 1)
end

function edit_dhits()
	sampShowDialog(22527, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.autodhits), 
'���������', '�������', 1)
end

function edit_sbiv()
	sampShowDialog(2253, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ID: {00ffff}%s]], 
mainini.config.sbiv), 
'���������', '�������', 1)
end

function edit_fastmap()
	sampShowDialog(2141, '{fff000}���������', string.format([[
{ffffff}�������� � ���� ���� �������� ������ ��� ���������
������� ���������: {00ffff}%s]], 
mainini.config.fmap), 
'���������', '�������', 1)
end

function edit_userid()
	sampShowDialog(2139, '{fff000}���������', string.format([[
{ffffff}��� ������ ������ ������� {ff4500}ble$$ave {ffffff}����������:
{ffffff}������� � ������ {00FF00}https://vk.com/blessave1. {ffffff}�������� � �������� � ������ ��������� ������.
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

function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end 
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
printStringNow("~B~Script ~Y~/blessave ~G~ON ~P~for "..nickker, 1500, 5)
pidorsshow = true

workpaus(true)
lAA = lua_thread.create(lAA)
renderr = lua_thread.create(renderr)



downloadUrlToFile(update_url, update_path, function(id, status)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        updateini = inicfg.load(nil, update_path)
        if tonumber(updateini.info.vers) > script_vers then
            sampAddChatMessage("���� ����������! ������: " .. updateini.info.vers_text.. ". {c0c0c0}��������: {ff4500}/ub", -1)
            update_state = true
        end
        --os.remove(update_path)
    end
end)




sampRegisterChatCommand('bind', binder_menu)

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

FishEye = lua_thread.create(FishEye)


fastrun = lua_thread.create(fastrun)
hphud = lua_thread.create(hphud)

proops = lua_thread.create(proops)


rltao = lua_thread.create(rltao)
--ifixx = lua_thread.create(ifixx)

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
    renderFontDrawText(fontALT, "{ffffff}Auto{ff0000}ALT", 1400, 600, 0xDD6622FF)
end





if mainini.functions.chatvipka and not sampIsDialogActive() then
    rposX, rposY = 650, 800
                         
        for i = 15 - 1, 0, -1 do
            if chat[#chat - i] ~= nil then
                renderFontDrawText(fontvip, chat[#chat - i], rposX, rposY, 0xFFFFFFFF, 0x90000000)
                rposY = rposY + 18
            end
        end
    
end

wait(0)



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


                if distance <= 501.0  then --and (colorment == 23486046 or colorment == 2147502591) 
                    local playerSkinId = getCharModel(pedm)
                    if policeSkins[playerSkinId] then 
                        _, idment = sampGetPlayerIdByCharHandle(pedm)
                        namement = sampGetPlayerNickname(idment)
                        colorment = sampGetPlayerColor(idment)
                        if colorment == 23486046 or colorment == 2147502591 then
                            policeCounter = policeCounter + 1
                            isVisible(myPosX, myPosY, myPosZ, posX, posY, posZ)
                            Yposm = Yposm - 0.140
                            renderFontDrawText(fontment, '{0000ff}�����a: {FFFFFF}'..policeCounter, w/6, h/3.350, 0xFFFFFFFF)
                            renderFontDrawText(fontment, '{'..warningment..'}'..namement..'{ffffff}['..idment..'] {18cd58}lvl: {ffffff}'..sampGetPlayerScore(idment), w/6, h/Yposm, 0xFFFFFFFF)
                        end
                    end    
                end
            end
        end
        if not isPauseMenuActive() and policeCounter == 0 then
            renderFontDrawText(fontment1, '����� ��� ��� �������.', w/6, h/3.350, 0xFFFFFFFF)
        end
    end

    if mainini.functions.activepidor then
        pidorCounter = 0
        Yposp = 3.250
        for _,vv in pairs(maintxt.pidors) do
            idpidor = sampGetPlayerIdByNickname(vv)
            if idpidor ~= nil and idpidor ~= -1 and idpidor ~= false then
                resultp, handlep = sampGetCharHandleBySampPlayerId(idpidor)
                if resultp then
                    local myPosX, myPosY, myPosZ = getCharCoordinates(PLAYER_PED)
                    local posX, posY, posZ = getCharCoordinates(handlep)
                    local distance = getDistanceBetweenCoords3d(myPosX, myPosY, myPosZ, posX, posY, posZ)
                    _, idpidra = sampGetPlayerIdByCharHandle(handlep)
                    namepidra = sampGetPlayerNickname(idpidra)
                    if distance <= 501.0 then
                        pidorCounter = pidorCounter + 1
                        isVisiblep(myPosX, myPosY, myPosZ, posX, posY, posZ)  
                        Yposp = Yposp - 0.140
                        renderFontDrawText(fontment, '{c50fd2}��������: {FFFFFF}'..pidorCounter, w/50, h/3.350, 0xFFFFFFFF)
                        renderFontDrawText(fontment, '{'..warningpidor..'}'..namepidra..'{ffffff}['..idpidra..']', w/50, h/Yposp, 0xFFFFFFFF)
                    end
                end
            end
        end
        if not isPauseMenuActive() and pidorCounter == 0 then
            renderFontDrawText(fontment1, '����� ��� ��� ���������.', w/50, h/3.350, 0xFFFFFFFF)
        end
    end
end


local result, button, list, _ = sampHasDialogRespond(2956)
if result and button == 1 then
    if list == 0 then
        edit_userid()
    end
    if list == 1 then
        soft_menu()
    end
    if list == 2 then
        flood_menu()
    end
    if list == 3 then
        mainini.afk.uvedomleniya = not mainini.afk.uvedomleniya
        inicfg.save(mainini, 'bd')
        afk_menu()
    end
end


            local result, button, list, _ = sampHasDialogRespond(2138)
			if result and button == 1 then
                if list == 0 then
                    nosoft_menu()
                end
                if list == 1 then
                    soft_menu()
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
                    sampShowDialog(3905, "{00CC00}������ ������ | �������", buttonslist, "�������", _, 2)
                end
                if list == 6 then
                    afk_menu()
                end
                if list == 7 then
                    chatlog_menu()
                end
                if list == 8 then
                    piss_menu()
                end
                if list == 9 then
                    eda_menu()
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
			end

            local result, button, list, _ = sampHasDialogRespond(21383)
			if result and button == 1 then
				if list == 0 then
					mainini.functions.fish = not mainini.functions.fish	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 1 then
					mainini.functions.bott = not mainini.functions.bott	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 2 then
                    mainini.functions.extra = not mainini.functions.extra	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 3 then
                    mainini.functions.autoc = not mainini.functions.autoc	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 4 then
					edit_autoc()
				end
                if list == 5 then
                    mainini.functions.dhits = not mainini.functions.dhits	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 6 then
					edit_dhits()
				end
                if list == 7 then
					edit_sbiv()
				end
                if list == 8 then
					edit_allsbiv()
				end
                if list == 9 then
					edit_suicide()
				end
                if list == 10 then
					wh_cops_pidors()
				end
                if list == 11 then
					edit_shook()
				end
                if list == 12 then
					edit_tramp()
				end
                if list == 13 then
					mainini.functions.arecc = not mainini.functions.arecc	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 14 then
					drugoesoft_menu()
				end
			end

            local result, button, list, _ = sampHasDialogRespond(21381)
			if result and button == 1 then
				if list == 0 then
					mainini.functions.hphud = not mainini.functions.hphud	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 1 then
					mainini.functions.dotmoney = not mainini.functions.dotmoney	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 2 then
                    mainini.functions.fastmap = not mainini.functions.fastmap	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 3 then
					edit_fastmap()
				end
                if list == 4 then
                    mainini.functions.colorchat = not mainini.functions.colorchat	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 5 then
                    mainini.functions.chatvipka = not mainini.functions.chatvipka	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 6 then
                    mainini.functions.offfrachat = not mainini.functions.offfrachat	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 7 then
                    mainini.functions.offrabchat = not mainini.functions.offrabchat	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 8 then
                    mainini.functions.autott = not mainini.functions.autott	
					inicfg.save(mainini, 'bd')
					nosoft_menu()
				end
                if list == 9 then
                    edit_pass()
                end
                if list == 10 then
                    edit_bank()
                end
                if list == 11 then
                    drugoenosoft_menu()
                end
			end

            
            local result, button, _, lop = sampHasDialogRespond(2741)
            if result and button == 1 then
                if list == 0 then
                    mainini.lidzam.devyatka = not mainini.lidzam.devyatka 
                    inicfg.save(mainini, 'bd')
                    lidzam_menu()
                end
                if list == 1 then
                    sampShowDialog(27411, '{fff000}���������', string.format([[
{ffffff}�������� �������� ����� �����
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzam.band), 
                        '���������', '�������', 1)
                end
                if list == 3 then
                    naboron = not naboron
                    --inicfg.save(mainini, 'bd')
                    if naboron then 
                        naborka = lua_thread.create(nabor) 
                    else
                        lua_thread.terminate(naborka) 
                    end
                    lidzam_menu()
                end
                if list == 4 then
                    sampShowDialog(27418, '{fff000}���������', string.format([[
{ffffff}�������� ���������� ������ ��� ��������
������� ��������: {F08080}%s ���.]], 
                        mainini.lidzam.naborwait), 
                        '���������', '�������', 1)
                end
                if list == 5 then
                    sampShowDialog(27417, '{fff000}���������', string.format([[
{ffffff}������� ����� ��� ����� � ������
������� �����:
{20B2AA}%s]], 
                        mainini.lidzam.nabortext), 
                        '���������', '�������', 1)
                end

            end

            local result, button, _, lop = sampHasDialogRespond(2859)
            if result and button == 1 then
                if list == 0 then
                    whcoppidr_instr()
                end
                if list == 1 then
                    edit_wh()
                end
                if list == 2 then
                    mainini.functions.activement = not mainini.functions.activement	
					inicfg.save(mainini, 'bd')
					wh_cops_pidors()
                end
                if list == 3 then
                    mainini.functions.activepidor = not mainini.functions.activepidor	
					inicfg.save(mainini, 'bd')
					wh_cops_pidors()
                end
                if list == 4 then
                    pidor_opis()
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

            local result, button, _, lop = sampHasDialogRespond(27417)
            if result and button == 1 then
                mainini.lidzam.nabortext = lop
                inicfg.save(mainini, 'bd')
                lidzam_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(27411)
            if result and button == 1 then
                mainini.lidzam.band = lop
                inicfg.save(mainini, 'bd')
                lidzam_menu()
            end

            local result, button, _, lop = sampHasDialogRespond(27418)
            if result and button == 1 then
                mainini.lidzam.naborwait = lop
                inicfg.save(mainini, 'bd')
                lidzam_menu()
            end

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

            local result, button, _, lop = sampHasDialogRespond(2141)
            if result and button == 1 then
                mainini.config.fmap = lop
                inicfg.save(mainini, 'bd')
                menu()
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

            local result, button, _, lop = sampHasDialogRespond(22526)
            if result and button == 1 then
                mainini.config.autoplusc = lop
                inicfg.save(mainini, 'bd')
                menu()
            end

            local result, button, _, lop = sampHasDialogRespond(22527)
            if result and button == 1 then
                mainini.config.autodhits = lop
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
                nosoft_menu()
            end
            local result, button, _, lop = sampHasDialogRespond(21392)
            if result and button == 1 then
                mainini.helper.bankpin = lop
                inicfg.save(mainini, 'bd')
                nosoft_menu()
            end

 

if toggle then --params that not declared has a nil value that same as false
    for a = 0, 2304	do --cycle trough all textdeaw id
        if sampTextdrawIsExists(a) then --if textdeaw exists then
            x, y = sampTextdrawGetPos(a) --we get it's position. value returns in game coords
            x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y) --so we convert it to screen cuz render needs screen coords
            renderFontDrawText(fontSF, a, x1, y1, 0xFFBEBEBE) --and then we draw it's id on textdeaw position
        end
    end
end

if mainini.functions.bott and trigbott then
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

if isKeyDown(18) and isKeyJustPressed(57) and isKeyCheckAvailable() then trigbott = not trigbott end
if not trigbott then 
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

if mainini.functions.extra then
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


local texthome = sampTextdrawGetString(2054)
if texthome:match("House~g~ 20") or texthome:match("House~g~ 47") or texthome:match("House~g~ 46") or texthome:match("House~g~ 48") or texthome:match("House~g~ 57") then
    menuhome = true
end
if menuhome and not sampTextdrawIsExists(2054) then menuhome = false end

if sampTextdrawIsExists(2103) and not act then
-- addOneOffSound(0.0, 0.0, 0.0, 23000)
    local text = sampTextdrawGetString(2103)
    if text:find('Incoming') and mainini.afk.uvedomleniya then
        local nick = text:gsub('(%s)(%w_%w)(.+)', '%2')
        sendvknotf('<3 ���� ������ '..nick) -- output
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

for i=0, 2048 do
    if sampIs3dTextDefined(i) then
        local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(i)
        if color == 4291611852 and playerId >= 0 then sampDestroy3dText(i) end
    end
end

local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
if valid and doesCharExist(ped) then
    local result, id = sampGetPlayerIdByCharHandle(ped)
    if result then
        local name = sampGetPlayerNickname(id)
        local nickk = string.match(name, '(.*)_')
        local nickkk = string.match(name, '_(.*)')
        local namee = string.gsub(name, "_", " ");
        local lvlped = sampGetPlayerScore(id)
        if isKeyJustPressed(20) and isKeyCheckAvailable() then 
            sampSendChat(string.format('/free %s', id))
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

        if mainini.lidzam.devyatka and isKeyJustPressed(219) and isKeyCheckAvailable() then
            if sampGetPlayerScore(id) >= 5 then
                sampSendChat(string.format("/todo ������ ��� ��� �� ����*����� � ���� %s ����������(5) ������� %s", namee, mainini.lidzam.band))
                wait(500)
                sampSendChat(string.format('/invite %s', name))
                wait(3000)
                sampSendChat(string.format('/giverank %s 5', name))
            else
                sampSendChat(string.format("/todo ������ ��� ��� �� ����*����� � ���� %s ����������(1) ������� %s", namee, mainini.lidzam.band))
                wait(500)
                sampSendChat(string.format('/invite %s', name)) end
        end
        if mainini.lidzam.devyatka and isKeyJustPressed(221) and isKeyCheckAvailable() then
            sampSendChat(string.format("/todo ������ ��� ��� �� ����*����� � ���� %s �����������(8) ������� %s", namee, mainini.lidzam.band))
            wait(500)
            sampSendChat(string.format('/invite %s', name))
            wait(3000)
            sampSendChat(string.format('/giverank %s 8', name))
            -- ������ ���� ����������� �������� � ��� � �����������

        end
        if mainini.lidzam.devyatka and isKeyJustPressed(187) and isKeyCheckAvailable() then
            sampSetChatInputText(string.format('/giveskin %s ', id))
            sampSetChatInputEnabled(true)
        end
        if mainini.lidzam.devyatka and isKeyJustPressed(189) and isKeyCheckAvailable() then
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



doKeyCheck()

arec()







if isKeyJustPressed(78) and isCharInAnyCar(PLAYER_PED) then
    notkey = true
end


if isKeyDown(16) and isKeyJustPressed(116) and isKeyCheckAvailable() then
    --sampAddChatMessage("{ff4500}[ble$$ave] {4682B4}������ {FF0000}��������. {ffffff}�����: {800080}tedj",-1)
    printStringNow("~B~Script ~Y~/blessave ~R~OFF ~P~for "..nickker, 1500, 5)
    thisScript():unload() 
end
if isKeyDown(16) and isKeyJustPressed(113) and isKeyCheckAvailable() then
    captureon = not captureon 
    if captureon and wh then
        printStringNow("~P~LEGAL ~G~ON", 1500, 5)
        nameTagOff()
        wh = false
        actmentpidor = false
       -- musorasosat = false
        sound = false
        sound1 = false
        --onfp = false
        cameraRestorePatch(false)
        activeextra = false
        --musora = false
        --obideli = false
        ScriptState = false
        ScriptState2 = false
        ScriptState3 = false
        ScriptState4 = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false

        on = false
        draw_suka = false
        inicfg.save(mainini, 'bd') 
    elseif captureon then
        printStringNow("~P~LEGAL ~G~ON", 1500, 5)
        --nameTagOff()
        wh = false
       -- musorasosat = false
        sound = false
        sound1 = false
       -- onfp = false
       actmentpidor = false
        cameraRestorePatch(false)
        activeextra = false
       -- musora = false
        --obideli = false
        ScriptState = false
        ScriptState2 = false
        ScriptState3 = false
        ScriptState4 = false
        enabled = false
        olenina = false
        status = false
        graffiti = false
        autoaltrend = false

        on = false
        draw_suka = false
        inicfg.save(mainini, 'bd') 
    else
        printStringNow("~P~LEGAL ~R~OFF", 1500, 5)
        inicfg.save(mainini, 'bd') 
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
    actmentpidor = not actmentpidor
    wh = not wh
    if wh then
        nameTagOn()
        addOneOffSound(0.0, 0.0, 0.0, 1139)
    else 
        nameTagOff()
        addOneOffSound(0.0, 0.0, 0.0, 1138)
    end
    if pidorsshow then
        sampProcessChatInput("/pidors")
        pidorsshow = false
    end
end
if isKeyDown(119) then
    if wh then 
        nameTagOff()
        wait(1000)
        nameTagOn()
    end
end


local menuPtr = 0x00BA6748
if isPlayerPlaying(playerHandle) then 
        if isKeyCheckAvailable() and mainini.functions.fastmap and isKeyDown(_G['VK_'..mainini.config.fmap]) then
            writeMemory(menuPtr + 0x33, 1, 1, false) -- activate menu  and isKeyDown(VK_Z)
            -- wait for a next frame
            wait(0)
            writeMemory(menuPtr + 0x15C, 1, 1, false) -- textures loaded
            writeMemory(menuPtr + 0x15D, 1, 5, false) -- current menu
            if reduceZoom then
                writeMemory(menuPtr + 0x64, 4, representFloatAsInt(300.0), false)
                --wait(100)
                setVirtualKeyDown(90, true)
                wait(1500)
                setVirtualKeyDown(90, false)
            end
            while mainini.functions.fastmap and isKeyDown(_G['VK_'..mainini.config.fmap]) do
                wait(80)
            end
                writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
            end
        end
    end
end


function runToPoint(tox, toy)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    stopRun = false
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        --setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
        if stopRun then
           -- stopRun = false
            break
        end
    end
end

function msave()
	local mpX, mpY, mpZ = getCharCoordinates(PLAYER_PED)
	sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: Icon set!", -1)
    icons.markers = icons.markers + 1
    icons.cords[#icons.cords + 1] = { X = mpX, Y = mpY, Z = mpZ }
    mymark[icons.markers] = addSpriteBlipForCoord(mpX, mpY, mpZ, 37)
    jsoncfg.save(icons, configDir)
	addOneOffSound(0, 0, 0, 1057)
end
function mdelete(arg)
    if tonumber(arg) == nil then
        icons.cords[#icons.cords] = nil
        removeBlip(mymark[icons.markers])
        icons.markers = icons.markers - 1
        if icons.markers < 0 then icons.markers = 0 end
        jsoncfg.save(icons, configDir)
        sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: Icon {FF0000}"..icons.markers+1 ..'{FFFFFF} deleted!', -1)
    else
        if icons.cords[tonumber(arg)] == nil then sampAddChatMessage('[{00fc76}WAXTA{FFFFFF}]: Icon {FF0000}'..tonumber(arg)..' {FFFFFF}not found!', -1) return end
        table.remove(icons.cords, tonumber(arg))
        removeBlip(mymark[tonumber(arg)])
        icons.markers = icons.markers - 1
        if icons.markers < 0 then icons.markers = 0 end
        jsoncfg.save(icons, configDir)
        ReloadMarkers()
        sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: Icon {FF0000}"..tonumber(arg)..'{FFFFFF} deleted!', -1)
    end
end
function mlist()
    local dtext = 'Distance\tCoords \n'
    if checkpoint ~= nil then dtext = dtext..'\t \t{FF0000}Remove checkpoint' end
    local x, y, z = getCharCoordinates(playerPed)
    for k, v in pairs(icons.cords) do
         f1 = ("%0.2f"):format(v.X)
         f2 = ("%0.2f"):format(v.Y)
        f3 = ("%0.2f"):format(v.Z)
            dtext = dtext..'{FF0000}'..math.floor(getDistanceBetweenCoords3d(v.X, v.Y, v.Z, x, y, z))..'\t{FFFF00} '..tostring(f1)..', {ff00FF}'..tostring(f2)..', {fff000}'..tostring(f3)..'\n'
    end
    sampShowDialog(28246, "[{00fc76}WAXTA{FFFFFF}]: Icons list:", dtext, "Close", _, 0)
    --lua_thread.create(dialog_mlist)
end 

function LoadMarkers() 
    for k,v in pairs(icons.cords) do
        if type(v) ~= 'userdata' then mymark[#mymark+1] = addSpriteBlipForCoord(v.X, v.Y, v.Z, 37) end
    end
    sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: Loaded {FF0000}"..icons.markers.."{FFFFFF} icons!", -1)
end


function ReloadMarkers()
    for k,v in pairs(mymark) do
        removeBlip(mymark[k])
    end
    mymark = {}
    for k,v in pairs(icons.cords) do
        if type(v) ~= 'userdata' then mymark[#mymark+1] = addSpriteBlipForCoord(v.X, v.Y, v.Z, 37) end
    end
    if checkpoint ~= nil then deleteCheckpoint(checkpoint) checkpoint = nil end
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
end ]]

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
end
function gopay()
    lua_thread.create(function()
        sampSendChat('/fammenu')
        wait(100) sampSendClickTextdraw(2073)
        wait(10) sampSendDialogResponse(2763, 1, 9, -1)
    end)    
end
function trpay()
    lua_thread.create(function()
        sampSendChat('/trmenu')
        wait(500)
        sampSetCurrentDialogListItem(5)
        sampCloseCurrentDialogWithButton(1)
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
    if thisScript() == scr then
        for k,v in pairs(mymark) do
            removeBlip(mymark[k])
        end
        --print('{FFFFFF}[{00fc76}WAXTA{FFFFFF}]: {FF0000}All icons deleted!')
    end
    if s == thisScript() then
        if marker or checkpoint or mark or dtext then
            removeUser3dMarker(mark)
            deleteCheckpoint(marker)
            removeBlip(checkpoint)
            sampDestroy3dText(dtext)
        end 
    end 
    if scr == thisScript() then
        os.remove(getWorkingDirectory()..'\\config\\pidorasi.ini')
        cameraRestorePatch(false)
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


function sp.onShowTextDraw(id, data)

    if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 271  then bcal = id end--����� �
    if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 261  then bcal = id end--���� �������
	if math.floor(data.position.x) == 31 and math.floor(data.position.y) == 268  then bcal = id end--�������
    if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 272  then bcal = id end--c����

--[[ 	if PhoneColor=='Xiaomi Mi 8' then
		if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 272  then bcal = id end
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 185  then num1 = id end
		if math.floor(data.position.x) == 52 and math.floor(data.position.y) == 185  then num2 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 185  then num3 = id end
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 206  then num4 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 206  then num5 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 206  then num6 = id end
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 227  then num7 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 226  then num8 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 226  then num9 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 247  then num0 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 268  then bcal2 = id end
	end


	if PhoneColor=='IPhone X' then
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 185  then num1 = id end
		if math.floor(data.position.x) == 52 and math.floor(data.position.y) == 185  then num2 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 185  then num3 = id end
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 206  then num4 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 206  then num5 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 206  then num6 = id end
		if math.floor(data.position.x) == 33 and math.floor(data.position.y) == 227  then num7 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 226  then num8 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 226  then num9 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 247  then num0 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 268  then bcal2 = id end
	end ]]


	if PhoneColor=='Samsung Galaxy' then
		if math.floor(data.position.x) == 34 and math.floor(data.position.y) == 188  then num1 = id end
		if math.floor(data.position.x) == 53 and math.floor(data.position.y) == 188  then num2 = id end
		if math.floor(data.position.x) == 71 and math.floor(data.position.y) == 188  then num3 = id end
		if math.floor(data.position.x) == 34 and math.floor(data.position.y) == 209  then num4 = id end
		if math.floor(data.position.x) == 53 and math.floor(data.position.y) == 209  then num5 = id end
		if math.floor(data.position.x) == 71 and math.floor(data.position.y) == 209  then num6 = id end
		if math.floor(data.position.x) == 34 and math.floor(data.position.y) == 230  then num7 = id end
		if math.floor(data.position.x) == 53 and math.floor(data.position.y) == 230  then num8 = id end
		if math.floor(data.position.x) == 71 and math.floor(data.position.y) == 230  then num9 = id end
		if math.floor(data.position.x) == 53 and math.floor(data.position.y) == 251  then num0 = id end
		if math.floor(data.position.x) == 53 and math.floor(data.position.y) == 271  then bcal2 = id end
	end


--[[ 	if PhoneColor=='Google Pixel 3' then
		if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 191  then num1 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 191  then num2 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 191  then num3 = id end
		if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 213  then num4 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 213  then num5 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 213  then num6 = id end
		if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 233  then num7 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 233  then num8 = id end
		if math.floor(data.position.x) == 70 and math.floor(data.position.y) == 233  then num9 = id end
		if math.floor(data.position.x) == 51 and math.floor(data.position.y) == 254  then num0 = id end
		if math.floor(data.position.x) == 32 and math.floor(data.position.y) == 254  then bcal2 = id end
	end ]]

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
          end
    end)
end 

if checked_test and active then
    lua_thread.create(function()
      if data.modelId == 19918 then
        wait(111)
        sampSendClickTextdraw(id)
        use = true
      end
      if data.text == 'USE' or data.text == '�C�O���O�A��' and use then
        clickID = id + 1
        sampSendClickTextdraw(clickID)
        use = false
        close = true
      end
      if close then
        wait(111)
        sampSendClickTextdraw(65535)
        close = false
        active = false
      end
    end)
  end
  if checked_test2 and active1 then
    lua_thread.create(function()
      if data.modelId == 19613 then
        wait(111)
        sampSendClickTextdraw(id)
        use1 = true
      end
      if data.text == 'USE' or data.text == '�C�O���O�A��' and use1 then
        clickID = id + 1
        sampSendClickTextdraw(clickID)
        use1 = false
        close1 = true
      end
      if close1 then
        wait(111)
        sampSendClickTextdraw(65535)
        close1 = false
        active1 = false
      end
    end)
  end
  if checked_test3 and active2 then
    lua_thread.create(function()
      if data.modelId == 1353 then
        wait(111)
        sampSendClickTextdraw(id)
        use2 = true
      end
      if data.text == 'USE' or data.text == '�C�O���O�A��' and use2 then
        clickID = id + 1
        sampSendClickTextdraw(clickID)
        use2 = false
        close2 = true
      end
      if close2 then
        wait(111)
        sampSendClickTextdraw(65535)
        close2 = false
        active2 = false
      end
    end)
  end
  if checked_test4 and active3 then
    lua_thread.create(function()
      if data.modelId == 1733 then
        wait(111)
        sampSendClickTextdraw(id)
        use3 = true
      end
      if data.text == 'USE' or data.text == '�C�O���O�A��' and use3 then
        clickID = id + 1
        sampSendClickTextdraw(clickID)
        use3 = false
        close3 = true
      end
      if close3 then
        wait(111)
        sampSendClickTextdraw(65535)
        close3 = false
        active3 = false
      end
    end)
  end

end
function thread_func()
	cmd = 1
	sampSendChat("/invent")
	while not sampTextdrawIsExists(next_page) do
		wait(0)
	end
	wait(150)
	if cmd == 1 then
			sampSendClickTextdraw(next_page)
	end
	wait(300)
	cmd = 0
	sampSendClickTextdraw(closegun)
end

function thread_func2()
	wait(200)
	sampSendClickTextdraw(usee)
	wait(100)
	sampSendClickTextdraw(closegun)
	wait(100)
	--sampAddChatMessage(amount, -1)
	sampSendDialogResponse(d_id, 1, 1, amount)
	anim_play = 1
  wait(50)
	sampCloseCurrentDialogWithButton(0)
	wait(100)
	sampCloseCurrentDialogWithButton(0)
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
        if mainini.functions.dotmoney then
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
        wait(3000)
        printStringNow("~B~AUTORECONNECT", 3000)
            wait(100) -- ��������
            sampSetGamestate(1)
        end 
    end
end 

function reconnect()
  lua_thread.create(function ()
  sampDisconnectWithReason(quit)
  wait(3000)
  printStringNow("~B~RECONNECT", 3000)
  wait(100) -- ��������
  sampSetGamestate(1) end)
end

function FishEye()
    while true do
        wait(0)
        if mainini.functions.fish then 
            if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
                if not locked then 
                    cameraSetLerpFov(70.0, 70.0, 1000, 1)
                    locked = true
                end
            else
                cameraSetLerpFov(101.0, 101.0, 1000, 1)
                locked = false
            end
        end
    end
end




function dHits()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
    if mainini.functions.dhits then
        if getCurrentCharWeapon(playerPed) == 24 and getAmmoInClip() ~= 1 then
    if isKeyJustPressed(_G['VK_'..mainini.config.autodhits]) and isKeyCheckAvailable() and isCharOnFoot(PLAYER_PED) then
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
            if isCharInAnyCar(PLAYER_PED) and isKeyDown(90) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
                local veh = storeCarCharIsInNoSave(PLAYER_PED)
                repeat
                    local speed = getCarSpeed(veh)
                    setCarForwardSpeed(veh, speed - 0.5)
                    wait(0)
                until speed > 0
            end
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
        --[[      if isKeyJustPressed(56) and isKeyCheckAvailable() and isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
                local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
                if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.1, 0.0, 0.0, 0.0) 
                end
            end ]]
            if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() then
                local veh = storeCarCharIsInNoSave(PLAYER_PED)
                local speed = getCarSpeed(veh)
                if speed >= 0 and not isCarInAirProper(veh) and isKeyDown(87) and isKeyDown(2) and isKeyCheckAvailable() then
                    setCarForwardSpeed(veh, speed + 3.8)
                    wait(100)
                end	  
            end
    --[[             if isKeyDown(83) and isKeyCheckAvailable() and isCharInAnyCar(PLAYER_PED) and getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED)) > 5 and not isCharOnAnyBike(PLAYER_PED) then
                local data = samp_create_sync_data('vehicle')
                data.keysData = data.keysData+160
                data.send()
            end ]]
        end
    end
end

function autoC()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        if mainini.functions.autoc then
            if getCurrentCharWeapon(playerPed) == 24 and getAmmoInClip() ~= 1 then
                if isKeyDown(2) and isKeyJustPressed(_G['VK_'..mainini.config.autoplusc]) then
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
			local bike = {[481] = true, [509] = true, [510] = true}
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
function nabor(arg)
	while true do wait(0)
		if naboron then
			sampSendChat(mainini.lidzam.nabortext)
			wait(mainini.lidzam.naborwait * 1000)
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
    sendvknotf('Fam ��� '..(vklchat and '�������!' or '��������!'))
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
        if mainini.functions.hphud then
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
            if isKeyDown(VK_C) and isKeyDown(VK_1) then
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

                if isKeyDown(VK_C) and isKeyDown(VK_2) then
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
--[[ function ifixx()
    while true do wait(400*1000)
        if activrsdf then
            lua_thread.create(function() wait(0)
                fix = true
                sampSendChat("/donate")
                wait(3000)
                fix = false
               -- sampAddChatMessage("inv fix", -1)
                sendvknotf0("inv fix")
            end)
        end
    end
end ]]
function rltao()
	while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        if checked_test then
            sampSendClickTextdraw(65535)
            wait(355)
            fix = true
            sampSendChat("/donate")
            wait(3000)
            fix = false
            active = true
            sampSendChat("/invent")
            wait(zadervka*60000)
          end
          if checked_test2 then
            sampSendClickTextdraw(65535)
            wait(355)
            fix = true
            sampSendChat("/donate")
            wait(3000)
            fix = false
            active1 = true
            sampSendChat("/invent")
            wait(zadervka1*60000)
          end
          if checked_test3 then
            sampSendClickTextdraw(65535)
            wait(355)
            fix = true
            sampSendChat("/donate")
            wait(3000)
            fix = false
            active2 = true
            sampSendChat("/invent")
            wait(zadervka2*60000)
          end
          if checked_test4 then
            sampSendClickTextdraw(65535)
            wait(355)
            fix = true
            sampSendChat("/donate")
            wait(3000)
            fix = false
            active3 = true
            sampSendChat("/invent")
            wait(zadervka3*60000)
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
--[[     function sp.onSendTakeDamage(playerId, damage, weapon, bodypart)
        local killer = ''
            if sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(playerPed))) - damage <= 0 and sampIsLocalPlayerSpawned() then
                if playerId > -1 and playerId < 1001 then
                    killer = '\n������: '..sampGetPlayerNickname(playerId)..'['..playerId..']'
                end
                sendvknotf('��� �������� ����'..killer)
        end
    end ]]
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
--[[     function onReceiveRpc(id,bitStream)
        if (id == RPC_CONNECTIONREJECTED) then
            goaurc()
        end
    end
    function goaurc()
        sendclosenotf('�������� ���������� � ��������')
        ip, port = sampGetCurrentServerAddress()
        end
    function sendclosenotf(text)
        sendvknotf(text)
    end ]]
---- aafk vksend



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
    if miningtool then
	    if id == 15272 or id == 0 and title:find('����� ���� ���������') or title:find('�������� ����������') then
			local automining_btcoverall = 0
			local automining_btcoverallph = 0
			local automining_btcamountoverall = 0
			local automining_videocards = 0
			local automining_videocardswork = 0
			for line in text:gmatch("[^\n]+") do
                dtextm[#dtextm+1] = line 
            end
			
			if dtextm[1]:find('%(BTC%)') then
			    dtextm[1] = dtextm[1]:gsub('%(BTC%)', '%1 | �� 9 BTC')
			end
			
			for d = 1, #dtextm do
				if dtextm[d]:find('�����%s+�%d+%s+|%s+%{BEF781%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+%d+%p%d+%%') then	-- ������, �������� ��� ���
					automining_status = 1
					automining_statustext = '{BEF781}'
				else
					automining_status = 0
					automining_statustext = '{F78181}'
				end
				local automining_lvl = tonumber(dtextm[d]:match('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+(%d+)%s+�������%s+%d+%p%d+%%')) -- ������� ������
				local automining_fillstatus = tonumber(dtextm[d]:match('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%%')) -- ������ ������ � ���������
				local automining_btcamount = tonumber(dtextm[d]:match('�����%s+�%d+%s+|%s+%{......%}%W+%s+(%d+%p%d+)%s+BTC%s+%d+%s+�������%s+%d+%p%d+%%')) -- ����� ������ ������ � ������              						
				if automining_lvl ~= nil and automining_fillstatus ~= nil and automining_btcamount ~= nil then					    						
					automining_videocards = automining_videocards + 1
					automining_btctimetofull = math.ceil((9 - automining_btcamount) / INFO[automining_lvl])
					if automining_status == 1 then 
						automining_videocardswork = automining_videocardswork + 1
					end
					if automining_btcamount >= 1 then 
						automining_btcamountinfo = true	
					else 
						automining_btcamountinfo = false 
					end
                    					
					automining_fillstatushours = math.ceil(oxladtime * (automining_fillstatus / 100)) -- �� ������� ����� ������
					automining_fillstatusbtc = automining_fillstatushours * INFO[automining_lvl] -- ������� ������ ��� ���� BTC
					automining_btcoverall = automining_btcoverall + automining_fillstatusbtc -- ������� ������� ����� ����� ��� ������
					automining_btcamountoverall = automining_btcamountoverall + math.floor(automining_btcamount) -- ������� ������� �������� ��� ������
					if automining_fillstatus > 0 and automining_status == 1 then
						automining_btcoverallph = automining_btcoverallph + INFO[automining_lvl]
					end
					dtextm[d] = dtextm[d]:gsub('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+'..automining_lvl..'%s+�������', '%1 | '..automining_statustext..INFO[automining_lvl]..'/���')
					if automining_fillstatus > 0 then
						dtextm[d] = dtextm[d]:gsub('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+|%s+%{......%}%d+%p%d+/���%s+'..automining_fillstatus..'%A+', '%1 '..tostring(automining_status and '{BEF781}' or '{F78181}')..'- [~'..automining_fillstatushours..' ���(��)] {FFFFFF}|{81DAF5} [~'..string.format("%.1f", automining_fillstatusbtc)..' BTC]')
					else
						dtextm[d] = dtextm[d]:gsub('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+|%s+%{......%}%d+%p%d+/���%s+'..automining_fillstatus..'%A+', '%1 {F78181}(!)')
					end
					dtextm[d] = dtextm[d]:gsub('�����%s+�%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC', '%1 '..tostring(automining_btcamountinfo and '{BEF781}�' or '{F78181}�')..' {ffffff}| '..automining_statustext..'~'..automining_btctimetofull..'�')
				end				
			end
			
		if id == 15272 and title:find('�������� ����������') then
            if worktread ~= nil then
                worktread:terminate()
            end			
		    local automining_fillstatus1 = tonumber(text:match('����� �1 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%A'))
			local automining_fillstatus2 = tonumber(text:match('����� �2 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%A'))
			local automining_fillstatus3 = tonumber(text:match('����� �3 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%A'))
			local automining_fillstatus4 = tonumber(text:match('����� �4 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%A'))
			
			local automining_getbtcstatus1 = tonumber(text:match('����� �1 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+�������%s+%d+.'))
			local automining_getbtcstatus2 = tonumber(text:match('����� �2 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+�������%s+%d+.'))
			local automining_getbtcstatus3 = tonumber(text:match('����� �3 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+�������%s+%d+.'))
			local automining_getbtcstatus4 = tonumber(text:match('����� �4 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+�������%s+%d+.'))				
			
			for i = 1, 4 do
			    local automining_lvl = tonumber(text:match('����� �'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+(%d+)%s+�������%s+%d+.'))
				local automining_fillstatus = tonumber(text:match('����� �'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+(%d+%p%d+)%A'))
			    if automining_fillstatus ~= nil then
					if automining_fillstatus > 0 and automining_lvl ~= nil then
						automining_fillstatushours =  math.ceil(224 * (automining_fillstatus / 100))
						text = text:gsub('����� �'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������%s+%d+%p%d+%A', '%1 {BEF781}- [~'..automining_fillstatushours..' ���(��)]')	
					end				
					if automining_lvl > 0 then
						text = text:gsub('����� �'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+�������', '%1 | '..INFO[automining_lvl]..'/���')
					end
                end				
			end					
			
            if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				if automining_getbtc == 1 then
				    if automining_getbtcstatus1 ~= nil then
						if automining_getbtcstatus1 < 1 then
							automining_getbtc = 2
						elseif text:find('����� �1 | ��������') then
							automining_getbtc = 2
						end
					else
					    automining_getbtc = 2
					end
				end
				if automining_getbtc == 2 then
				    if automining_getbtcstatus2 ~= nil then
						if automining_getbtcstatus2 < 1 then
							automining_getbtc = 3
						elseif text:find('����� �2 | ��������') then
							automining_getbtc = 3
						end
					else
					    automining_getbtc = 3
					end
				end
				if automining_getbtc == 3 then
					if automining_getbtcstatus3 ~= nil then
						if automining_getbtcstatus3 < 1 then
							automining_getbtc = 4
						elseif text:find('����� �3 | ��������') then
							automining_getbtc = 4
						end
					else
					    automining_getbtc = 4
					end
				end
				if automining_getbtc == 4 then
					if automining_getbtcstatus4 ~= nil then
						if automining_getbtcstatus4 < 1 then
							automining_getbtc = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}�������� ������ ������.', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						elseif text:find('����� �4 | ��������') then
							automining_getbtc = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}�������� ������ ������.', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						end
					else
					    automining_getbtc = 10					
					end
				end
				adID = automining_getbtc - 1
			    sampSendDialogResponse(15272,1,adID,nil)				
            end				
			
			if automining_startall == 1 or automining_startall == 2 or automining_startall == 3 or automining_startall == 4 then
				if automining_startall == 1 then
				    if text:find('����� �1 | {BEF781}��������') then
						automining_startall = 2
					elseif text:find('����� �1 | ��������') then
					    automining_startall = 2
					end
				end
				if automining_startall == 2 then
				    if text:find('����� �2 | {BEF781}��������') then
				        automining_startall = 3
					elseif text:find('����� �2 | ��������') then
					    automining_startall = 3
					end
				end
				if automining_startall == 3 then
				    if text:find('����� �3 | {BEF781}��������') then
				        automining_startall = 4
					elseif text:find('����� �3 | ��������') then
					    automining_startall = 4
					end
				end
				if automining_startall == 4 then
				    if text:find('����� �4 | {BEF781}��������') then
				        automining_startall = 10
						sampAddChatMessage('[MineFarm] {FFFFFF}��������� ������ ������ (��� ��� ��������).', 0xFF6060)
					    worktread = lua_thread.create(PressAlt)
					elseif text:find('����� �4 | ��������') then
					    automining_startall = 10
					    sampAddChatMessage('[MineFarm] {FFFFFF}��������� ������ ������.', 0xFF6060)
					    worktread = lua_thread.create(PressAlt)
					end
				end			
				adID = automining_startall - 1
			    sampSendDialogResponse(15272,1,adID,nil)
			end
			
            if automining_fillall == 1 or automining_fillall == 2 or automining_fillall == 3 or automining_fillall == 4 then
				if automining_fillall == 1 then
				    if automining_fillstatus1 ~= nil then
						if automining_fillstatus1 > 51 then
							automining_fillall = 2
						elseif text:find('����� �1 | ��������') then
							automining_fillall = 2
						end
					else
					    automining_fillall = 2
					end
				end
				if automining_fillall == 2 then
				    if automining_fillstatus2 ~= nil then
						if automining_fillstatus2 > 51 then
							automining_fillall = 3
						elseif text:find('����� �2 | ��������') then
							automining_fillall = 3
						end
					else
					    automining_fillall = 3
					end
				end
				if automining_fillall == 3 then
					if automining_fillstatus3 ~= nil then
						if automining_fillstatus3 > 51 then
							automining_fillall = 4
						elseif text:find('����� �3 | ��������') then
							automining_fillall = 4
						end
					else
					    automining_fillall = 4
					end
				end
				if automining_fillall == 4 then
					if automining_fillstatus4 ~= nil then
						if automining_fillstatus4 > 51 then
							automining_fillall = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}�������� ������ ������ (� ����������� ������ 50%, ����� ������!).', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						elseif text:find('����� �4 | ��������') then
							automining_fillall = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}�������� ������ ������.', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						end
					else
					    automining_fillall = 10
					end
				end			
				adID = automining_fillall - 1
			    sampSendDialogResponse(15272,1,adID,nil)
			end			
		end
		
		text = table.concat(dtextm,'\n')
        dtextm = {}
        text = text .. '\n' .. ' '
		text = text .. '\n' .. '{ffff00}����������\t{ffff00}�������� �����\t{ffff00}������� � ���\t{ffff00}������� ��������������'
		text = text .. '\n' .. '{FFFFFF}�����: '..automining_videocards..' | {BEF781}�������� '..automining_videocardswork..'\t{FFFFFF}'..string.format("%.0f", automining_btcamountoverall)..' BTC\t{BEF781}'..automining_btcoverallph..' {FFFFFF}BTC\t{81DAF5}'..string.format("%.1f", automining_btcoverall)..' {FFFFFF}BTC' 
			if title:find('�������� ����������') then	
				if text:find('����� �1 | ��������') and text:find('����� �2 | ��������') and text:find('����� �3 | ��������') and text:find('����� �4 | ��������') then
					text = text .. '\n' .. ' '
					text = text .. '\n' .. '{FF6060}- ������� ��� ������� (����� �����!)'
					text = text .. '\n' .. '{FF6060}- ��������� ��� ���������� (����� �����!)'
					text = text .. '\n' .. '{FF6060}- ������ �������� (����� �����!)'
				else
					text = text .. '\n' .. ' '
					text = text .. '\n' .. '{99FF99}- ������� ��� �������'
					text = text .. '\n' .. '{22FF00}- ��������� ��� ����������'
					text = text .. '\n' .. '{00FF55}- ������ �������� (�� 50%)'
				end
			end
		automining_btcoverall = 0
	    automining_btcoverallph = 0        		
		return {id, style, title, button1, button2, text}
		end
		
		if id == 15273 then	    
		    if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				if title:find('������ �%d+%s+| ����� �'..automining_getbtc..'') then	
					local automining_btcamount = tonumber(text:match('������� ������� %((%d+).%d+ '))
					if automining_btcamount ~= 0 then
						sampSendDialogResponse(15273,1,1,nil) -- ��
					else
						automining_getbtc = automining_getbtc + 1
						sampSendDialogResponse(15273,0,nil,nil)
						if automining_getbtc == 5 then
							sampAddChatMessage('[MineFarm] {FFFFFF}������� ��������� � ����������.', 0xFF6060)
							automining_getbtc = 10
						end
					end
				else
				    sampSendDialogResponse(15273,0,nil,nil)
					worktread = lua_thread.create(PressAlt)
				end
			end
			
		    if automining_startall == 1 or automining_startall == 2 or automining_startall == 3 or automining_startall == 4 then
				if text:find('��������� ����������') and title:find('������ �%d+%s+| ����� �'..automining_startall..'') then
				    sampSendDialogResponse(15273,1,0,nil)
				    automining_startall = automining_startall + 1
				    sampSendDialogResponse(15273,0,nil,nil)
				else
				    sampSendDialogResponse(15273,0,nil,nil)
				end
				if automining_startall == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}������ ��������.', 0xFF6060)
					automining_startall = 10
				end
			end

		    if automining_fillall == 1 or automining_fillall == 2 or automining_fillall == 3 or automining_fillall == 4 then
				if title:find('������ �%d+%s+| ����� �'..automining_fillall..'') then
				    sampSendDialogResponse(15273,1,2,nil)
				    automining_fillall = automining_fillall + 1
				    worktread = lua_thread.create(PressAlt)
				else
				    worktread = lua_thread.create(PressAlt)
				end
				if automining_filltall == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}������� ������ �� 50% ��������.', 0xFF6060)
					sampSendDialogResponse(15273,0,nil,nil)
					automining_startall = 10
					worktread = lua_thread.create(PressAlt)
				end
			end
	    end
		
	    if id == 15274 and title:find('����� ������� ����������') then
     		if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				automining_getbtc = automining_getbtc + 1
				sampSendDialogResponse(15274,1,nil,nil) -- ��
				worktread = lua_thread.create(PressAlt)
				if automining_getbtc == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}������� ��������� � ����������.', 0xFF6060)
					automining_getbtc = 10
				end
				return false
			end
	    end			
	end

    if fix and text:find("���� ���������� �����") then
		sampSendDialogResponse(id, 0, 0, "")
		sampAddChatMessage("{ffffff} inventory {ff0000}fixed{ffffff}!",-1)
        
    --notf.addNotification(string.format("%s \ninventory fixed!" , os.date()), 10)
		return false
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
		if id == 15247 then mainini.functions.dotmoney = false
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
                mainini.functions.dotmoney = true
            end
		end
    end
    end)    

--[[     if id == 8928 then
        sendvknotf(text)
       -- return false
    end
    if id == 7782 then
        sendvknotf(text)
       -- return false
    end ]]
    if id == 1333 and mainini.afk.uvedomleniya then
        sendvknotf(text)
        setVirtualKeyDown(13, false)
    end
    if id == 1332 then
        setVirtualKeyDown(13, false)
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
    --autophone
    if id == 1000 then
        setVirtualKeyDown(13, false)
    end
    --bankpin
    if id == 991 then 
        sampSendDialogResponse(id, 1, _, mainini.helper.bankpin)
    end
    --skipzz
	if text:find("� ���� ����� ���������") then
		setVirtualKeyDown(13, false)
	end
    --dotmoney
    if mainini.functions.dotmoney then
        text = separator(text)
        title = separator(title)
        return {id, style, title, button1, button2, text}
    end
end

function sp.onSendDialogResponse(DialogId, DialogButton, DialogList, DialogInput)
    if DialogId == 15272 and DialogList == 8 and DialogButton == 1 then
	    automining_getbtc = 1
        worktread = lua_thread.create(PressAlt)
		sampAddChatMessage('[MineFarm] {FFFFFF}�������� �������... �� ���������� ������ ������� �� ����� �����!', 0xFF6060)
	end
	if DialogId == 15272 and DialogList == 9 and DialogButton == 1 then
	    automining_startall = 1
        worktread = lua_thread.create(PressAlt)
		sampAddChatMessage('[MineFarm] {FFFFFF}��������� ��� ����������... �� ���������� ������ ������� �� ����� �����!', 0xFF6060)
	end
	if DialogId == 15272 and DialogList == 10 and DialogButton == 1 then
	    automining_fillall = 1
        worktread = lua_thread.create(PressAlt)
		sampAddChatMessage('[MineFarm] {FFFFFF}�������� �������� (�� 50%)... �� ���������� ������ ������� �� ����� �����!', 0xFF6060)
	end	
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

--[[ function f()
	lua_thread.create(function() wait(0)
		fix = true
		sampSendChat("/donate")
		wait(3000)
		fix = false
	end)
end ]]
---- �������, ������� � ���, ���� ��
function sp.onDisplayGameText(style, time, text)
    if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
        local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
        return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
    end
    if text:find("%-400%$") then
        return false
    end
    if text:find("~w~Style: ~g~Comfort") and mainini.functions.autott then
        lua_thread.create(function()
        wait(1000)
        sampSendChat("/style")
        end)
    end
--[[ 	if text:find('You are hungry!') or text:find('You are very hungry!') then
        sampSendChat("/jmeat")
        return false
    end ]]
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
if text:find('Attention') then
    return false
end
if text:find('GPS: ON') then
    return false
end
if text:find('pursuit') then
    return false
end
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
              --[[ if bitkiSTATE then
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("�������� � �������������") and text:find("������ � �����: %d+ BTC") and text:find("���� ������ 1 BTC �� $45(.+)")  then
                            bitki = text:match("%d+")
                            if tonumber(bitki) > 0 and tonumber(bitki) <= 1000 then
                                sampAddChatMessage("bitki: "..bitki, -1)
                            setVirtualKeyDown(vkeys.VK_N, true)
                            wait(1000)
                            setVirtualKeyDown(vkeys.VK_N, false)
                            wait(1000)
                            sampSendDialogResponse(15276, 1, 1, -1)
                            wait(1000)
                            sampSendDialogResponse(15279, 1, _, bitki)
                            wait(1000)
                            --sampSendDialogResponse(15280, 1, _, -1)
                            closeDialog()
                            --bitkiSTATE = false
                            elseif tonumber(bitki) > 0 and tonumber(bitki) >= 1000 then
                                sampAddChatMessage("bitki: "..bitki, -1)
                                setVirtualKeyDown(vkeys.VK_N, true)
                                wait(1000)
                                setVirtualKeyDown(vkeys.VK_N, false)
                                wait(1000)
                                sampSendDialogResponse(15276, 1, 1, -1)
                                wait(1000)
                                sampSendDialogResponse(15279, 1, _, "1000")
                                wait(1000)
                                --sampSendDialogResponse(15280, 1, _, -1)
                                closeDialog()
                            end

                        end
                    end
                end
                end ]]
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
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
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
                                renderFontDrawText(Arial, "{2E8B57}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{008000}������: {FFFFFF}'..Counter, 1200, 700, 0xDD6622FF)
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
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                --renderFontDrawText(Arial, timerr, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find("˸�") and text:find("�������� %d+:%d+")  then
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
                                renderFontDrawText(Arial, "{D2B48C}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{8B4513}˸�: {FFFFFF}'..Counter, 1200, 800, 0xDD6622FF)
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
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                --addSpriteBlipForCoord(posX, posY, posZ, 37) addOneOffSound(0, 0, 0, 1057) 
                                if checkpoint ~= nil then deleteCheckpoint(checkpoint) end
                                --marker = createCheckpoint(1, posX, posY, posZ, _, _, _, 1)
                                --checkpoint = addBlipForCoord(posX, posY, posZ)
                                --setMarker1(1, posX, posY, posZ, 10, 0xFFFFFFFF)
                               --if math.floor(getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2)) <= 7 then deleteCheckpoint(marker) removeBlip(checkpoint) checkpoint = nil end
                            end
                        end
                    end
                end

                renderFontDrawText(Arial, '{00FFFF}�e�����: {ffffff}'..Counter, 1100, 600, 0xDD6622FF)
            if ScriptStateRR3 then
                local x, y, z = getCharCoordinates(PLAYER_PED)
                local cid = 1 
                local renderY = 230
                for k, v in pairs(icons.cords) do
                    f1 = ("%0.2f"):format(v.X)
                    f2 = ("%0.2f"):format(v.Y)
                    f3 = ("%0.2f"):format(v.Z)
                    
                    local distanka = math.floor(getDistanceBetweenCoords3d(v.X, v.Y, v.Z, x, y, z)) 
                    if distanka <= 1 then
                        renderFontDrawText(Arial1, '{ffffff}'..cid..' | {00FFFF}'..distanka..'{ffffff} | {7CFC00} '..f1..', {FFFF00}'..f2..', {00FFFF}'..f3..' \n', 1500, renderY, 0xDD6622FF)
                        renderY = renderY + 12
                        cid = cid + 1
                    else
                        renderFontDrawText(Arial1, '{ffffff}'..cid..' | {ff0000}'..distanka..'{ffffff} | {7CFC00} '..f1..', {FFFF00}'..f2..', {00FFFF}'..f3..' \n', 1500, renderY, 0xDD6622FF)
                        renderY = renderY + 12
                        cid = cid + 1
                    end
                end
                renderFontDrawText(Arial, '{7CFC00}X: ' .. math.floor(x) .. ' {ffffff}| {FFFF00}Y: ' .. math.floor(y) .. ' {ffffff}| {00ffff}Z: ' .. math.floor(z), 1100, 650, 0xDD6622FF)
            end
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
                            renderFontDrawText(Arial, resNames[v][1], x1, y1, -1) 
                        end
                    end
                end
            end
            if enabled then
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
                        renderDrawLine(x10, y10, x1, y1, 2, 0xDD6622FF)
                        renderDrawPolygon(x10, y10, 10, 10, 7, 0, 0xDD6622FF) 
                        renderFontDrawText(Arial,"{20B2AA}������ {00ff00}"..distance, x1, y1, -1)
                        end
                    end
                end
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
                    renderFontDrawText(font, textole, wposX, wposY, -1)
                    end
                end
            end
                    renderFontDrawText(Arial, '{BC8F8F}�����: {ffffff}'..olenk, 1200, 600, 0xDD6622FF)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
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
                        if text:find('��������') then
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
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                
                                --setMarker1(1, posX, posY, posZ, 10, 0xFFFFFFFF)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{EE82EE}��������:{ffffff} '..Counter, 1200, 600, 0xDD6622FF)
            end
           
            if on then
                if draw_suka then
                    --setMarker(1, x, y, z-2, 1, 0xFFFFFFFF)
                    removeUser3dMarker(mark)
                    mark = createUser3dMarker(x,y,z+2,0xFFD00000)
                else
                    removeUser3dMarker(mark)
                    --deleteCheckpoint(marker)
                    --removeBlip(checkpoint)
                end
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

function sp.onSendCommand(cmd)
    local result = cmd:match("^/vr (.+)")
	if result ~= nil then 
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
                    if mainini.functions.chatvipka then
		        	    renderDrawPolygon(650, 790, 20, 20, 3, rotate, 0xFFFFFFFF)
        			    renderDrawPolygon(650, 790, 20, 20, 3, -1 * rotate, 0xFF0090FF)
    		        	renderFontDrawText(fontVR, message, 660, 780, -1)
                    else
                        renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, rotate, 0xFFFFFFFF)
        			    renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, -1 * rotate, 0xFF0090FF)
    		        	renderFontDrawText(fontVR, message, X + 25, Y, -1)
                    end
		        	--renderFontDrawText(fontVR, string.format(" [x%s]", try), X + 25 + renderGetFontDrawTextLength(fontVR, message), Y, 0x40FFFFFF)
		        end
		        wait(0)
			end
		end)
	end
    ------    Anti-AFK � ������� ������������. ��� ������ ����� ������ �������� ID VK � settings.ini. �������� ��������� � ������ https://vk.com/tedj69.
    --������� /afktest �������� ��� �������� ���������.
    if cmd:find('/rlt') then
        rlton = not rlton
        if rlton then
            sendvknotf0("��������� ������� � ���� ��� ���")
            sampAddChatMessage("{ffffff}��������� ������� � ���� ��� {00FF00}���",-1)
            --notf.addNotification(string.format("%s \n��������� ������� � ���� ���\n��������" , os.date()), 10)
            checked_test = true
            checked_test2 = true
            checked_test3 = true
            checked_test4 = true
            --activrsdf = true
            else
            sendvknotf0("��������� ������� � ���� ��� ����")
            sampAddChatMessage("{ffffff}��������� ������� � ���� ��� {ff0000}����",-1)
            --notf.addNotification(string.format("%s \n��������� ������� � ���� ���\n���������" , os.date()), 10)
            checked_test = false
            checked_test2 = false
            checked_test3 = false
            checked_test4 = false
            --activrsdf = false
        end
        return false
    end
    if cmd:find('/cln') then
        CleanMemory()
        return false
    end
    if cmd:find('/9') then
        mainini.lidzam.devyatka = not mainini.functions.devyatka
        if mainini.lidzam.devyatka then
            sampAddChatMessage("����� ����������� � ����� {228b22}on {ffffff}| /h9 - ������ ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("����� ����������� � ����� {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if cmd:find("/h9") and mainini.lidzam.devyatka then
        lidzam_menu()
        return false
    end
--[[     if cmd:find("/nabor") and mainini.lidzam.devyatka then
        sampSendChat("/vr ����� � �� 'The Rifa'. /smug /port | �������� ��� �� ��������.")
        return false
    end ]]
    if cmd:find('/nabor') then
        naboron = not naboron
		if naboron then 
            sampAddChatMessage('{ff4500}nabor {228b22}on',-1)
			naborka = lua_thread.create(nabor) 
		else
            sampAddChatMessage('{ff4500}nabor {ff0000}off',-1)
			lua_thread.terminate(naborka) 
		end
        return false
    end
    if cmd:find("/povish") and mainini.lidzam.devyatka then
        lua_thread.create(function()
            sampSendChat("/f ����� ���������� �� 6-7 ����: ������� ������ �� �����, ��������� ���� ������ ���������...")
            wait(1000)
            sampSendChat("/f ...�������� ������/�����, ������� ��������, ��������� ������. ��������� �� ����� ����� � �������...")
            wait(1000)
            sampSendChat("/f ...����-������ - 8 ���� - ������ ������. �� ��������� � ���� ������, ��� ����� ���� �� �������.")
        end)
        return false
    end
    if cmd:find('/fu') and mainini.lidzam.devyatka then 
        local arguninv = cmd:match('/fu (.+)')
        sampSendChat('/uninvite '..arguninv..' �������.')
        return false
    end
    if cmd:find('/skl') and mainini.lidzam.devyatka then 
        lua_thread.create(function()
            sampSendChat('/lmenu')
            sampSendDialogResponse(1214, 1, 2, -1)
   --[[          wait(250)
            closeDialog() ]]
        end)
        return false
    end
--[[     if cmd:find('/fc') and mainini.lidzam.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 4, -1)
        return false
    end
    if cmd:find('/sc') and mainini.lidzam.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 3, -1)
        return false
    end ]]
    if cmd:find('/gr') and mainini.lidzam.devyatka then 
        local argidgr = cmd:match('/gr (.+)')
        sampSendChat('/giverank '..argidgr)
        return false
    end
    if cmd:find('/gs') and mainini.lidzam.devyatka then 
        local argskin = cmd:match('/gs (.+)')
        sampSendChat('/giveskin '..argskin)
        return false
    end
--[[     if cmd:find("/animki") then
        sampAddChatMessage("47 51 56 57 58 62 66 74 77 84 85 99", -1)
        return false
    end ]]
    if cmd:find('/spb') then
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
    if cmd:find('/sliv') then
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
    if cmd:find('/probiv') then
        lua_thread.create(function()
            sampSendChat("/id "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(1000)
            sampSendChat("/cl "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(1000)
            setVirtualKeyDown(116, true)
            wait(4000)
            setVirtualKeyDown(116, false)
            sampSendChat("/time")
            wait(500)
            sampSendChat("/invent")
            wait(1000)
            sampSendClickTextdraw(2073)
            wait(1000)
            sampSendClickTextdraw(2110)
            wait(1000)
            sampSendChat("/stats")
            wait(1000)
            sampSendChat("/donate")
            wait(1000)
            setVirtualKeyDown(9, false)
            wait(4000)
            setVirtualKeyDown(9, false)
            wait(1000)
            setVirtualKeyDown(192, false)
        end)
        return false
    end
     --[[
    if cmd:find('/info2') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����-���� ������: {DAA520}/auto_pass ������.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����-���� ���-����: {DAA520}/auto_pin ���-���.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����������� - {FFFF00}/info3{ffffff}.", -1)
        return false
    end
    if cmd:find('/info3') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}��������� �������� {EE82EE}/flood1 /flood2 /flood3", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}�������� ����� ��������: {00CED1}/fltext1 [text] /fltext2 [text] /fltext3 [text]", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}�������� ����� ��������: {00CED1}/flwait1 [sek] /flwait2 [sek] /flwait3 [sek]", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}���������� ���������� � ��������� {FF6347}/flood{ffffff}.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����������� - {FFFF00}/info4{ffffff}.", -1)
        return false
    end
    if cmd:find('/info4') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����� ������� {FFFACD}/pidors", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}�������� ������ � ������: {00FA9A}/addpidor [������_�������] ��� ID ", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����� ��������� � ���� ������ {808000}/fpidors{ffffff}.", -1)
        --sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}����������� - {FFFF00}/info4{ffffff}.", -1)
        return false
    end ]]
    if cmd:find('/gcolors') then
        sampAddChatMessage("{ffffff}Ballas 179 | NW 37 | Vagos 6 | Aztecas 2 | Rifa 135 | Grove 86", -1)
        return false
    end
--[[     if cmd:find('/apass') then
        mainini.helper.autopass = not mainini.helper.autopass
		if mainini.helper.autopass then 
            sampAddChatMessage('���� ����-������ ������� {228b22}on',-1) 
		else
            sampAddChatMessage('{ff4500}flood1 {ff0000}off',-1)
		end
        return false
    end ]]
--[[     if cmd:find('/auto_pass') then
        local arg = cmd:match('/auto_pass (.+)')
        mainini.helper.password = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('��� {DAA520}������: {ffffff}'..mainini.helper.password,-1)
        return false
    end
    if cmd:find('/auto_pin') then
        local arg = cmd:match('/auto_pin (.+)')
        mainini.helper.bankpin = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('��� {DAA520}���-���: {ffffff}'..mainini.helper.bankpin,-1)
        return false
    end
    if cmd:find('/userid') then
        local arg = cmd:match('/userid (.+)')
        mainini.helper.user_id = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('��� {9ACD32}�������� ID VK: {ffffff}'..mainini.helper.user_id,-1)
        sendvknotf('�������� ���������')
        return false
    end
    if cmd:find('/chatvip') then
        mainini.functions.chatvipka = not mainini.functions.chatvipka
		if mainini.functions.chatvipka then 
            sampAddChatMessage('���������� VIP-chat {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n�������" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('���������� VIP-chat {ff0000}off',-1)
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n��������" , os.date()), 10)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/fastmap') then
        mainini.functions.fastmap = not mainini.functions.fastmap
		if mainini.functions.fastmap then 
            sampAddChatMessage('FastMap {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n�������" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('FastMap {ff0000}off',-1)
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n��������" , os.date()), 10)
            inicfg.save(mainini, 'bd')
		end
        return false
    end ]]
    if cmd:find('/chatvip') then
        mainini.functions.chatvipka = not mainini.functions.chatvipka
		if mainini.functions.chatvipka then 
            sampAddChatMessage('���������� VIP-chat {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n�������" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('���������� VIP-chat {ff0000}off',-1)
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n��������" , os.date()), 10)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/colorchat') then
        mainini.functions.colorchat = not mainini.functions.colorchat
		if mainini.functions.colorchat then 
            sampAddChatMessage('������� chat {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n�������" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('������� chat {ff0000}off',-1)
            --notf.addNotification(string.format("%s \n���������� VIP-chat\n��������" , os.date()), 10)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/rabchat') then
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
    if cmd:find('/frachat') then
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
    --[[if cmd:find('/dotmoney') then
        mainini.functions.dotmoney = not mainini.functions.dotmoney
		if mainini.functions.dotmoney then 
            sampAddChatMessage('���������� ������� ������ {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('���������� ������� ������ {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/dhits') then
        mainini.functions.dhits = not mainini.functions.dhits
		if mainini.functions.dhits then 
            sampAddChatMessage('����-�������� {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('����-�������� {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/fishey') then
        mainini.functions.fish = not mainini.functions.fish
		if mainini.functions.fish then 
            sampAddChatMessage('����� ���� {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('����� ���� {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/extra') then
        mainini.functions.extra = not mainini.functions.extra
		if mainini.functions.extra then 
           -- if not isCharDead(playerPed) then cameraRestorePatch(true) else cameraRestorePatch(false) end
            sampAddChatMessage('������ WS {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            cameraRestorePatch(false)
            activeextra = false
            sampAddChatMessage('������ WS {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/autoc') then
        mainini.functions.autoc = not mainini.functions.autoc
		if mainini.functions.autoc then 
            sampAddChatMessage('����-+C {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('����-+C {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/ashot') then
        mainini.functions.bott = not mainini.functions.bott
		if mainini.functions.bott then 
            sampAddChatMessage('����-��� {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('����-��� {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/hphud') then
        mainini.functions.hphud = not mainini.functions.hphud
		if mainini.functions.hphud then 
            sampAddChatMessage('hp-hud {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('hp-hud {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/allsbiv (.+)') then
        local arg = cmd:match('/allsbiv (.+)')
        mainini.config.allsbiv = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('������� ��� ����� ����� ������ {00FFFF}'..mainini.config.allsbiv,-1)
        return false
    end
    if cmd:find('/sbiv (.+)') then
        local arg = cmd:match('/sbiv (.+)')
        mainini.config.sbiv = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('������� ��� ����� ������ {00FFFF}'..mainini.config.sbiv,-1)
        return false
    end
    if cmd:find('/fmap (.+)') then
        local arg = cmd:match('/fmap (.+)')
        mainini.config.fmap = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('������� ��� ������� ����� ������ {00FFFF}'..mainini.config.fmap,-1)
        return false
    end
    if cmd:find('/suicide (.+)') then
        local arg = cmd:match('/suicide (.+)')
        mainini.config.suicide = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('������� ��� ������� ������ {00FFFF}'..mainini.config.suicide,-1)
        return false
    end
    if cmd:find('/whb (.+)') then
        local arg = cmd:match('/whb (.+)')
        mainini.config.wh = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('������� ��� WallHack ������ {00FFFF}'..mainini.config.wh,-1)
        return false
    end ]]
    if cmd:find('/ch') and not cmd:find('/ch (.+)') and not cmd:find('/chh') then
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
    if cmd:find('/chh') then
        tbl = {}
        for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt') do 
            if l ~= "" then
                table.insert(tbl, string.sub(l, 1, 325)) 
            end
        end   
        sampShowDialog(1007, "���������: "..#tbl, table.concat(tbl, "\n"), "�����", _, 4)
        return false
    end
    if cmd:find('/ch (.+)') then
        local param = cmd:match('/ch (.+)')
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
    if cmd:find('/eathome') then
        gotoeatinhouse = true; sampSendChat('/home')
        return false
    end
    ---
    if cmd:find('/piss') then
        sampSetSpecialAction(68)
        --addOneOffSound(0.0, 0.0, 0.0, 1084)
        return false
    end
    if cmd:find('/cchat') then
        ClearChat()
        return false
    end
    if cmd:find('/hrec') then
        reconnect()
        return false
    end
    if cmd:find('/trpay') then
        trpay()
        return false
    end
    if cmd:find('/fpay') then
        activefpay = not activefpay gopay()
        return false
    end
--[[     if cmd:find('/fm') then
        sampSendChat('/fammenu')
        return false
    end ]] -- https://oplata.qiwi.com/success?invoice_uid=ed703c51-c23a-4ec7-a98f-42728d4efc87&allowedPaySources=card
    if cmd:find('/mb') then
        sampSendChat('/members')
        return false
    end
    if cmd:find('/k (.+)') then
        local arg = cmd:match('/k (.+)')
         sampSendChat("/fam "..arg)
        return false
    end
    if cmd:find('/getcolor (.+)') then
        local id = cmd:match('/getcolor (.+)')
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
    if cmd:find('/flood') and not (cmd:find('/flood1') or cmd:find('/flood2') or cmd:find('/flood3')) then
        flood_menu()
        return false
    end

    if cmd:find('/flood1') then
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
    if cmd:find('/flood2') then
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
    if cmd:find('/flood3') then
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
--[[     if cmd:find('/fltext1') then
        local arg = cmd:match('/fltext1 (.+)')
        mainini.flood.fltext1 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('����� flood1 ������ {00FFFF}'..mainini.flood.fltext1,-1)
        return false
    end
    if cmd:find('/fltext2') then
        local arg = cmd:match('/fltext2 (.+)')
        mainini.flood.fltext2 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('����� flood2 ������ {00FFFF}'..mainini.flood.fltext2,-1)
        return false
    end
    if cmd:find('/fltext3') then
        local arg = cmd:match('/fltext3 (.+)')
        mainini.flood.fltext3 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('����� flood3 ������ {00FFFF}'..mainini.flood.fltext3,-1)
        return false
    end
    if cmd:find('/flwait1') then
        local arg = cmd:match('/flwait1 (.+)')
        mainini.flood.flwait1 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('�������� flood1 �������� �� {ff1493}'..mainini.flood.flwait1..' ���.',-1)
        return false
    end
    if cmd:find('/flwait2') then
        local arg = cmd:match('/flwait2 (.+)')
        mainini.flood.flwait2 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('�������� flood2 �������� �� {ff1493}'..mainini.flood.flwait2..' ���.',-1)
        return false
    end
    if cmd:find('/flwait3') then
        local arg = cmd:match('/flwait3 (.+)')
        mainini.flood.flwait3 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('�������� flood3 �������� �� {ff1493}'..mainini.flood.flwait3..' ���.',-1)
        return false
    end ]]

----------------------------------------------------------------

if cmd:find('/mnk (.+)') then
    local arg = cmd:match('/mnk (.+)')
        if sampIsPlayerConnected(arg) then
            arg = sampGetPlayerNickname(arg)
        else
            sampAddChatMessage('������ ��� �� �������!', -1)
            --notf.addNotification(string.format("%s \n������ ��� �� �������!" , os.date()), 5)
            return
        end
        on = not on
        if on then
            --printStyledString("~G~Find:~W~ "..arg, 3330, 5)
            --printStringNow("~G~Find:~W~ "..arg, 1)
            sampAddChatMessage('����: '..arg..'!', -1)
            
            --notf.addNotification(string.format("%s \n����:\n"..arg.."" , os.date()), 5)
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
                            --sampDestroy3dText(dtext)
                 --[[            if not dtext then
                                dtext = sampCreate3dText('���������',0xFFD00000,0,0,0.4,9999,true,id,-1)
                            end ]]
                            if isPointOnScreen(x,y,z,0) then
                                renderDrawLine(x2, y2, x1, y1, 2.0, 0xDD6622FF)
                                renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                            else
                                screen_text = '���-�� �����!'
                            end
                            printStringNow(conv(screen_text),1)
                            --draw_suka = true
                        else
                            if marker or checkpoint then
                                deleteCheckpoint(marker)
                                removeBlip(checkpoint)
                            end
                            --sampDestroy3dText(dtext)
                            --dtext = nil
                            --draw_suka = false
                        end
                    end
                end
        
            end)
        else
            lua_thread.create(function()
                draw_suka = false
                wait(10)
                removeUser3dMarker(mark)
                --sampDestroy3dText(dtext)
               -- dtext = nil
                --deleteCheckpoint(marker)
                --removeBlip(checkpoint)
             --   sampAddChatMessage('�� ����.', -1)
            end)
        end
        return false
end
    if cmd:find('/de (.+)') then
        local arg = cmd:match('/de (.+)')
        if arg == nil then
            amount = deagle_ammo
        else
            amount = arg
        end
    
        mod = deagle
        thr:run()
    end
    if cmd:find('/m4 (.+)') then
        local arg = cmd:match('/m4 (.+)')
        if arg == nil then
		    amount = m4_ammo
	    else
		    amount = arg
	    end
	    mod = m4
	    thr:run()
    end
    if cmd:find('/ak (.+)') then
        local arg = cmd:match('/ak (.+)')
        if arg == nil then
            amount = ak_ammo
        else
            amount = arg
        end
      mod = ak
        thr:run()
    end
    if cmd:find('/sg (.+)') then
        local arg = cmd:match('/sg (.+)')
        if arg == nil then
			amount = shotgun_ammo
	    else
		    amount = arg
	    end
	    mod = shotgun
	    thr:run()
    end
    if cmd:find('/mp5 (.+)') then
        local arg = cmd:match('/mp5 (.+)')
        if arg == nil then
            amount = mp5_ammo
        else
            amount = arg
        end
        mod = mp5
        thr:run()
    end
    if cmd:find('/rf (.+)') then
        local arg = cmd:match('/rf (.+)')
        if arg == nil then
            amount = rifle_ammo
        else
            amount = arg
        end
        mod = rifle
        thr:run()
    end
    if cmd:find('/pst (.+)') then
        local arg = cmd:match('/pst (.+)')
        if arg == nil then
            amount = pistol_ammo
        else
            amount = arg
        end
        mod = pistol
        thr:run()
    end
    ----
    if cmd:find('/fh (.+)') then
        local arg = cmd:match('/fh (.+)')
        sampSendChat("/findihouse "..arg)
        return false
    end
    if cmd:find('/fbiz (.+)') then
        local arg = cmd:match('/fbiz (.+)')
        sampSendChat("/findibiz "..arg)
        return false
    end

    if cmd:find('/gn') then
		ScriptState4 = not ScriptState4
        --LoadMarkers1()
        return false
    end  
    if cmd:find('/blessave') then
            menu()
        return false
    end  

    if cmd:find('/bind_menu') then
            binder_menu()
        return false
    end 


--[[     if cmd:find('/are') then
    local _, myidanim = sampGetPlayerIdByCharHandle(playerPed)
local animka = sampGetPlayerAnimationId(myidanim)
sampAddChatMessage(animka, -1)
return false
end  ]] 
  --[[   if cmd:find('/eblan') then -- Adam_Yor 278
        --[[             local name_prem, id_prem, msg_prem = string.match(text, '{F345FC}%[PREMIUM%] {FFFFFF}(.+)%[(%d+)%]: (.+)')
            if name_prem and tonumber(id_prem) and msg_prem then
                sampAddChatMessage(string.format('{FFDAB9}'..name_prem..'{FFDAB9}[{DC143C}'..id_prem..'{FFDAB9}]: '..msg_prem), 0xF345FC)
                return false
            end
            local name_vip, id_vip, msg_vip = string.match(text, '{6495ED}%[VIP%] {FFFFFF}(.+)%[(%d+)%]: (.+)')
            if name_vip and tonumber(id_vip) and msg_vip then
                sampAddChatMessage(string.format('{FFDAB9}'..name_vip..'{FFDAB9}[{DC143C}'..id_vip..'{FFDAB9}]: '..msg_vip), 0x6495ED)
                return false
            end 
            sampAddChatMessage('{6495ED}%[VIP%] {FFFFFF}Adam_Yor%[278%]: ���� ���� ��� ������ �����, � ������ � ����� � ��� ���� ����� ����, ����� ��� �����', -1)
        return false
    end   ]]
  
    if cmd:find('/ub') and update_state then  
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
    if cmd:find('/ptguram (.+)') then
        local arg = cmd:match('/ptguram (.+)')
        l = 0
        local param = tonumber(arg)
        lua_thread.create(function()
            while l <= param do
                setGameKeyState(21, 255)
                wait(200)
                setGameKeyState(21, 0)
                sampSendDialogResponse(7625, 1, 9, -1)
                l = l+1
                wait(1000)
            end
        end)
        return false
    end 

--[[     
    if cmd:find('/bitki') then
		bitkiSTATE = not bitkiSTATE
        if bitkiSTATE then
			printString("AutoSkupBitkov ~G~ON",1500)
		else
			printString("AutoSkupBitkov ~R~OFF",1500)
		end
        return false
    end ]]
    ---
    if cmd:find('^/rend') then
		--sampAddChatMessage("[rend] {8A2BE2}Render for {FF4500}Arizona RP(G). {800080}�����: {8B008B}tedj", 0x7B68EE)
		sampAddChatMessage("{8B4513}˸�: {33EA0D}���������: {7B68EE}/len", -1)
		sampAddChatMessage("{008000}������: {33EA0D}���������: {7B68EE}/hlop", -1)
		sampAddChatMessage("{00FFFF}�������: {33EA0D}���������: {7B68EE}/waxta", -1)
		sampAddChatMessage("{EE82EE}��������: {33EA0D}���������: {7B68EE}/gn", -1)
		sampAddChatMessage("{20B2AA}������ �����: {33EA0D}���������: {7B68EE}/semena", -1)
		sampAddChatMessage("{BC8F8F}�����: {33EA0D}���������: {7B68EE}/olenina", -1)
		sampAddChatMessage("{0000CD}���� ����: {33EA0D}���������: {7B68EE}/laa", -1)
		sampAddChatMessage("{808080}����� ������ � ���� ������: {33EA0D}���������: {7B68EE}/mnk (id)", -1)
		sampAddChatMessage("{ff1493}�������� ����: {33EA0D}���������: {7B68EE}/graf {ffffff}| ������� ������ '{ff1493}77{ffffff}' ��� ���-���", -1)
		sampAddChatMessage("{00FF00}������� {87CEEB}������ ���������� ���������� �� �������.", -1)
		sampAddChatMessage("{9932CC}��������� {87CEEB}����� �� �������.", -1)
		sampAddChatMessage("{ffffff}����� {87CEEB}���������� �������� � ���� ������.", -1)
        return false
    end
    if cmd:find('/semena') then
		enabled = not enabled 
		if enabled then
			printString("Semena ~G~ON",1500)
		else
			printString("Semena ~R~OFF",1500)
		end
        return false
    end
    if cmd:find('/len') then
		ScriptState2 = not ScriptState2
        return false
    end
    if cmd:find('/olenina') then
		olenina = not olenina
        return false
    end 
    if cmd:find('/graf') then
		graffiti = not graffiti
        return false
    end
    if cmd:find('/waxta') and not doesFileExist("moonloader\\config\\waxta.json") then
        downloadUrlToFile("https://raw.githubusercontent.com/tedjblessave/binder/main/waxta.json", "moonloader\\config\\waxta.json", function(id, statuss, p1, p2)
            if statuss == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage("�������� ���� ���� ����� ���� {c0c0c0}waxta.json {ffffff}��� ������ �������. ����� ��������� ������������ �������." , -1)
                thisScript():reload()
            end 
        end)
        --ScriptState3 = not ScriptState3
       -- sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: /waxlist - �������� ������ ���� ����� ������ ���", -1)
        return false
    elseif cmd:find('/waxta') and doesFileExist("moonloader\\config\\waxta.json") then
        ScriptState3 = not ScriptState3
        sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: /waxlist - �������� ������ ���� ����� ������ ���", -1)
        return false
    end
    if cmd:find('/waxlist') then
		ScriptStateRR3 = not ScriptStateRR3
            if ScriptStateRR3 then
                LoadMarkers()
            end
        return false
    end
    if cmd:find('/runw') then
        lua_thread.create(function()
		runToPoint(518.62, 969.45)
        end)
        return false
    end

    if cmd:find('/hlop') then
		ScriptState = not ScriptState
        return false
    end
    if cmd:find('/laa') then
		status = not status
		if status then
            autoaltrend = true
			--printString("AutoALT ~G~ON",1500)
		else
			--printString("AutoALT ~R~OFF",1500)
            autoaltrend = false
		end
        return false
    end
    ----------------------------------------------------------------
--[[    if cmd:find('/fpidors') then
        onf = not onf
        if onf then
            --printString("Find Pidors ~G~ON",500)
            lua_thread.create(function()
    
                while onf do
                    wait(0)
                    for _,vvf in pairs(maintxt.pidors) do
                    local idpidort = sampGetPlayerIdByNickname(vvf)
                    if idpidort ~= nil and idpidort ~= -1 and idpidort ~= false then
                        local resf, handle = sampGetCharHandleBySampPlayerId(idpidor)
                        if resf then
                            screen_text = '{ffff00}������� {00ffff}'..vvf..' {ffffff}('..idpidort..') {ff0000}�����!'
                            x, y, z = getCharCoordinates(handle)
                            local mX, mY, mZ = getCharCoordinates(playerPed)
                            local x1, y1 = convert3DCoordsToScreen(x,y,z)
                            local x2, y2 = convert3DCoordsToScreen(mX, mY, mZ)
                            --sampDestroy3dText(dtext)
                            if isPointOnScreen(x,y,z,0) then
                                --renderDrawLine(x2, y2, x1, y1, 2.0, 0xFFD00000)
                                --renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                                pidoraso = true
                            else 
                                pidoraso = true
                            end
                            wait(1500)
                            pidoraso = false
                        end
                    end
                end
            end
            end)
        end
        return false
    end

    ----------------------------------------------------------------
 if cmd:find('/pidors') then 
    local countfind = 1 
        for id = 0,999 do
			if sampIsPlayerConnected(id) then
				local name = sampGetPlayerNickname(id)
				for _,vv in pairs(maintxt.pidors) do
					if vv == name then
                        sampAddChatMessage(""..countfind..". "..name.." {66CC66}id "..id, -1)
                        countfind = countfind + 1
					end 
				end 
			end       
		end
        if countfind == 1 then sampAddChatMessage("�������� �� �������", 0xC0C0C0) end
		countfind = 1
        return false
    end]]

        ------------------------------------
    if cmd:find('^/addpidor %a+_%a+') then
        local param = string.match(cmd,"%a+_%a+")
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?text=%s&action=add&key=%s', param, keyl), nil,
        function(response)
        end)
        addOneOffSound(0, 0, 0, 1131)
        return false
    end
    if cmd:find('^/delpidor %a+_%a+') then
        local param = string.match(cmd,"%a+_%a+")
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?text=%s&action=del&key=%s', param, keyl), nil,
        function(response)
        end)
        addOneOffSound(0, 0, 0, 1135)
        return false
    end
            ------------------------------------
    if cmd:find('/addpidor %d+') then
        local id = string.match(cmd,"%d+")
        local param = sampGetPlayerNickname(id)
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?text=%s&action=add&key=%s', param, keyl), nil,
        function(response)
        end)
        addOneOffSound(0, 0, 0, 1131)
        return false
    end 
    
            ------------------------------------
    if cmd:find('/pidors') then
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?action=show&key=%s', keyl), nil,
        function(response)
            text = response.text:gsub('<br />', '')
            for line in text:gmatch("[^\n\r]+") do
                idpidr = sampGetPlayerIdByNickname(line)
                --namepidr = sampGetPlayerNickname(idpidr)
                -----
                local found = false
                for _, v in pairs(maintxt.pidors) do
                    if v == line and not found then
                        found = true
                    end
                end
                if found == false then
                    table.insert(maintxt.pidors, line)
                    inicfg.save(maintxt, 'pidorasi.ini')
                end
                -----
                if (sampGetPlayerIdByNicknamePidor(line)) == nil then
                    line = line..'\t{E02A02}Offline'
                    dialogTabArr[#dialogTabArr+1] = line
                else
                    line = line..'\t{2CFF00}Online'
                    dialogTabArr[#dialogTabArr+1] = line
                end 
            end
            for _, str in ipairs(dialogTabArr) do
                dialogTabStr = dialogTabStr .. str .. "\n"
            end
            sampShowDialog(0, "{00ffff}������ ���� ���������", dialogTabStr, "�������", _, 4)
            dialogTabArr = {}
            dialogTabStr = ''
        end)
        return false
    end
    if cmd:find('/offpidors') then
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?action=show&key=%s', keyl), nil,
        function(response)
            text = response.text:gsub('<br />', '')
            for line in text:gmatch("[^\n\r]+") do
                if (sampGetPlayerIdByNicknamePidor(line)) == nil then
                    line = line..'\t{E02A02}Offline'
                    dialogTabArr[#dialogTabArr+1] = line
                end
            end
            for _, str in ipairs(dialogTabArr) do
                dialogTabStr = dialogTabStr .. str .. "\n"
            end
            sampShowDialog(0, "{00ffff}������ ��������� {ff0000}�������", dialogTabStr, "�������", _, 4)
            dialogTabArr = {}
            dialogTabStr = ''
        end)
        return false
    end
    if cmd:find('/onpidors') then
        sequent_async_http_request('GET', string.format('http://f0593183.xsph.ru/load.php?action=show&key=%s', keyl), nil,
        function(response)
            text = response.text:gsub('<br />', '')
            for line in text:gmatch("[^\n\r]+") do
                if (sampGetPlayerIdByNicknamePidor(line)) ~= nil then
                    line = line..'\t{2CFF00}Online'
                    dialogTabArr[#dialogTabArr+1] = line
                end
            end
            for _, str in ipairs(dialogTabArr) do
                dialogTabStr = dialogTabStr .. str .. "\n"
            end
            sampShowDialog(0, "{00ffff}������ ��������� {2CFF00}������", dialogTabStr, "�������", _, 4)
            dialogTabArr = {}
            dialogTabStr = ''
        end)
        return false
    end
end

function sampGetPlayerIdByNicknamePidor(nick)
    nick = tostring(nick)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if nick == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1003 do
      if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then
        return true
      end
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

function setMarker1(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    --marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        --deleteCheckpoint(marker)
        removeBlip(checkpoint)
        --addOneOffSound(0, 0, 0, 1149)
    end)
end

function setMarker2(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        addOneOffSound(0, 0, 0, 1149)
    end)
end

function setMarker(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
--[[    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        addOneOffSound(0, 0, 0, 1149)
    end)]]
end



--[[ function chatut(param)
    tbl = {}
    for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog ' .. os.date('%y.%m.%d').. '.txt') do 
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
   end ]]

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

--[[     if mainini.autoeda.legit then
        if text:find('� ��� ��� ����� � �����!') and color == -10270721 then
            lua_thread.create(function()
                wait(300)
                automeatbag = true
                wait(100)
                sampSendChat('/invent')
            end)
            return false
        end
    end
    if text:find('32f') then
        lua_thread.create(function()
            sampSendChat('/meatbag')
        end)
    end ]]

    if chatlog then
		if doesFileExist(fpath) then
			local fa = io.open(fpath, 'a+')
			if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
		end
	end
    ------------------------------------------------------------------
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
        
--[[         if color == -1 and text:find('%[���%]:')then
			sendvknotf0(text)
		end ]]
        if text:match('{73B461}%[���%]:')  and mainini.afk.uvedomleniya then
            sendvknotf0(text)
            text = text:gsub('^{73B461}%[���%]', '{2FAA5B}[���]') --b800a2
            return { 0xFFFFFFFF, text }
        end
        if color == -1347440641 and text:find('������ �������') and text:find('����������') and text:find('����� ���������') and mainini.afk.uvedomleniya  then
			sendvknotf(text)
		end

    if vknotf.chatc then 
		sendvknotf0(text)
	end 
    if not vknotf.chatf then 
        if text:find('%[�����') or text:find('%[������ ') then
			sendvknotf0(text)
		end
	end 

		if color == -1347440641 and text:find('����� � ���') and text:find('�� �������') and text:find('��������')  and mainini.afk.uvedomleniya then
			sendvknotf(text)
		end
        if color == -1347440641 and text:find('�� ������') and text:find('� ������')  and mainini.afk.uvedomleniya then
			sendvknotf(text)
		end
		if color == 1941201407 and text:find('����������� � �������� ������������� ��������') and mainini.afk.uvedomleniya  then
			sendvknotf('����������� � �������� ������������� ��������')
		end
--[[ 
		if text:find('����������� �������') and text:find('����� �������� ������ ���������� ���') then
			sendvknotf('������� ������� <3')
            sendvknotf(t00ext)
		end ]]

  -- print(text, color)

        if text:find("��� ������ ����� ���������!") and not text:find("�������") and not text:find('- |') then
            sampAddChatMessage("{fff000}��� ������ ����� {FFFFFF}SMS{fff000}-���������!", -1)
            addOneOffSound(0.0, 0.0, 0.0, 1055)
            printStringNow("~Y~SMS", 3000)
            return false
          end

 --[[          if  text:find('�������:') then
            print('{'..bit.tohex(bit.rshift(color, 8), 6)..'}'..text)
            print('======')
            print('%X', color)
            print(bit.tohex(bit.rshift(color, 8), 6))
            end ]]

        if text:find('�������:') then
                local idd = text:match('%d+')
            local colorr = sampGetPlayerColor(idd)
                sampAddChatMessage(text,colorr)
                return false 
        end

        if text:find('%[������ ') then
            --sampAddChatMessage(text, 0xFF00FF)
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
    if color == -10270721 and text:find('�� ������ ����� �� ��������������� ��������') and mainini.afk.uvedomleniya  then
            sendvknotf(text)
    end


    if text:find('���������� ���') and color == 1941201407 then 
       lua_thread.create(function()
        wait(10*1000)
        sampAddChatMessage('{ffffff}�� ������� ���������� ������ �� {ff4500}����, �������, ���.��{ffffff}!', -1)      
        wait(600*1000)
        sampAddChatMessage('{ffffff}�� ������� ���������� ������ �� {ff4500}����, �������, ���.��{ffffff}!', -1)    
        wait(1500*1000)
        sampAddChatMessage('{ffffff}�� ������� ���������� ������ �� {ff4500}����, �������, ���.��{ffffff}!', -1)    
       end)
    end

--[[     if text:find('���������� ���') and color == 1941201407 then 
        lua_thread.create(function()
            wait(1000)
            setVirtualKeyDown(vkeys.VK_N, true)
            wait(44)
            setVirtualKeyDown(vkeys.VK_N, false)
            wait(1000)
            sampSendDialogResponse(33, 1, 8, nil)
            wait(1000)
            sampSendDialogResponse(4498, 1, 0, "5000000")
            wait(1000)
            closeDialog()
            wait(600*1000)
            setVirtualKeyDown(vkeys.VK_N, true)
            wait(44)
            setVirtualKeyDown(vkeys.VK_N, false)
            wait(1000)
            sampSendDialogResponse(33, 1, 8, nil)
            wait(1000)
            sampSendDialogResponse(4498, 1, 0, "5000000")
            wait(1000)
            closeDialog()
            wait(600*1000)
            setVirtualKeyDown(vkeys.VK_N, true)
            wait(44)
            setVirtualKeyDown(vkeys.VK_N, false)
            wait(1000)
            sampSendDialogResponse(33, 1, 8, nil)
            wait(1000)
            sampSendDialogResponse(4498, 1, 0, "5000000")
            wait(1000)
            closeDialog()
            wait(600*1000)
            setVirtualKeyDown(vkeys.VK_N, true)
            wait(44)
            setVirtualKeyDown(vkeys.VK_N, false)
            wait(1000)
            sampSendDialogResponse(33, 1, 8, nil)
            wait(1000)
            sampSendDialogResponse(4498, 1, 0, "5000000")
            wait(1000)
            closeDialog()
        end)
    end ]]

    if text:find('�� �������� ��� ������ �� �����') and color == 1941201407 then
        lua_thread.create(function()
        wait(150)
        sampAddChatMessage('{ff0000}�� ������ �������� ������ �� {00ff00}������� {ffffff}(/trpay), {0000ff}���.�������� {ffffff}(/fpay)', 0xff0000)   
        end)
    end

        if text:find('���������� ���') and color == 1941201407  and mainini.afk.uvedomleniya then
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
                sendvknotf('\n ��������: ' .. getPlayerMoney(PLAYER_HANDLE) ..vknotf.ispaydaytext..'\n <3 �� ������� ���������� ������ �� ����, �������, ���.��!')
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



--[[                 if text:match('^{6495ED}%[VIP%]') then
                    text = text:gsub('^{6495ED}%[VIP%]', '[VIP]')
                    return { 0x2FAA5BFF, text }
                end
            
                if text:match('^{F345FC}%[PREMIUM%]') then
                    text = text:gsub('^{F345FC}%[PREMIUM%]', '[PREMIUM]')
                    return { 0xFFAA00FF, text }
                end
            
                if text:match('^{FCC645}%[ADMIN%]') then
                    text = text:gsub('^{FCC645}%[ADMIN%]', '[ADMIN]')
                    return { 0xFF4040FF, text }
                end ]]

                if (text:find("� ����� �������� �� ������ ���������� ������ ���������� ������� ����� � ���������") or text:find("�� �� �������� �����") or text:find("����� ������� �����������") or text:find("����� ������ ������������") or text:find("����� ���������� ������") or text:find("������� ������� ���� �� �����")) and color == 1687547391 then return false end

                if text:find("����� ��� ������� �������� ������ � ��� �������") and color == -1104335361 then return false end

                if (text:find("����� ������ ����� ����������") or text:find('�� ������� �������� ������')) and color == -1800355329 then return false end

                if (text:find("News LS") or text:find("News LV") or text:find("News SF")) and color == 1941201407 then return false end

                if text:find('������ �������') and color == -1800355329 then return false end

                if text:find('������ ������ � ���������') and color == -89368321 then return false end

                if (text:find('�� ������� ���� ���������') or text:find('�� ������ ������ ������ � ����') or text:find('����� ��������� �������') or text:find('����� �������� ����� �')) and text:find('���������') then return false end

                if (text:find('����� ������� ��������� �������') or text:find('����� �������� ����� ����������� ������') or text:find('����� ������������ �����') or text:find('��� ���������� ������������� �����������') or text:find('� ���������� ������������ �����')) and text:find('���������') then return false end

                if text:find('��������� ������ ���� ������') and text:find('����������') and not text:find('�������') and not text:find('- |') then return false end
                if text:find('���������� ������� �� �������') and text:find('����������� /gps') and not text:find('�������') and not text:find('- |') then return false end
                if text:find('��������� ������ ����') and text:find('���������') and not text:find('�������') and not text:find('- |') and color == -10270721 then return false end
                if text:find('���������� �� �������') and not text:find('�������') and not text:find('- |') and color == -1 then return false end

                if (text:find('��������� ������ �����') or text:find('� ������ ������ �������� �������������') or text:find('��� ���������� ���������� �������')) and color == 73381119 then return false end

                if (text:find("���������� ������������ �����") or text:find("�������") or text:find("��������� ������") or text:find("������ ������")  or text:find("�����") or text:find("����������� �������")  or text:find("������ ������� �������") or text:find("������ ��������� ��������������� �����:")) or text:find("������ �� �������� ����� ������������")  and not text:find('�������') and not text:find('- |') and color == -1 then return false end
                if text:find("������ ��������� ��������������� �����") and not text:find('�������') and not text:find('- |')  and color == 1687547391 then return false end

                if text:find('��� ��� �������� �������') and text:find('�����������') and color == -65281 then return false end
                if text:find('������ ����� ��������� ��� � ���� ��������') and text:find('���������') and color == -1347440641 then return false end
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

            if not finished then
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

            if text:match('%[VIP%]') or text:match('%[PREMIUM%]') then
                if not (text:find('������') or text:find('�������') or text:find('�����')) then
                    if text:find('���') or text:find('���') or text:find('���')  or text:find('�A�') or text:find('�AP') then
                        return false
                    end
                end
            end


            ----------------------sadlkjjasdlknmadsklasd
            if mainini.functions.chatvipka then
                if text:find('%[VIP%] {FFFFFF}.+%[%d+%]: (.+)') or  text:find('%[PREMIUM%] {FFFFFF}.+%[%d+%]: (.+)') then --�� ��, � ����� � ����� ���������
                    --gtext = text:gsub('{6495ED}',  '{'..bit.tohex(hex_color_color_tag_vip)..'}')
                    --gtext = gtext:gsub('{F345FC}', '{'..bit.tohex(hex_color_color_tag_premium)..'}')
                    --gtext = gtext:gsub('{ffffff}', '{'..bit.tohex(hex_color_vr_msg)..'}')
                    timeqw = os.date('[%H:%M:%S] ')
                    textWithColor = '{'..bit.tohex(color)..'}'..timeqw..text
                    if #chat >= 10 then
                        table.remove(chat, 1)
                    end
                    table.insert(chat, #chat + 1, textWithColor)
        
                    --��������, �� � �������� ��� ������
                    lastmsg[5 - 1] = lastmsg[5]
                    lastmsg[5] = text
                    return false
                end
            else
                ------------------
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
            end
                --[[                 if text:find("�������������� ��������� ���") and color == 1941201407 then return false end
                if text:find("�������������� ��������� ���") and not text:find('�������:') then return false end ]]
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

                if text:find('�������������') then
                    if color == -10270721 then -- �������� FF6347FF
                        return { 0xb22222ff, text }
                    elseif color == -2686721 then -- /ao FFD700FF
                        return { 0x38fcffff, text }
                    end
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

            if text:find("�������������� ��������� ���") and color == 1941201407 then return false end
            if text:find("�������������� ��������� ���") and not text:find('�������:') then return false end

  --[[           if (text:find('���') or text:find('���') or text:find('���') or text:find('�A�')) and (text:find('VIP') or text:find('PREMIUM')) and not (text:find('������') or text:find('������') or text:find('��������') or text:find('��������') or text:find('�����') or text:find('�����')) and color == -1  then return false end
            if (text:find('���') or text:find('���') or text:find('���') or text:find('�A�') or text:find('�AP')) and text:find('����������') and not (text:find('������') or text:find('������') or text:find('�����') or text:find('��������') or text:find('��������') or text:find('�����')) then return false end
             if (text:find('���') or text:find('���') or text:find('���')  or text:find('�A�') or text:find('�AP')) and text:find('�����') and (text:find('��������') or text:find('��������') or text:find('�������') or text:find('�������')) then return false end
             if (text:find('���') or text:find('�a�') or text:find('���') or text:find('���') or text:find('�A�') or text:find('�AP')) and text:find('������') and (text:find('��������') or text:find('��������')  or text:find('�������') or text:find('�������')) then return false end
         ]]


            if mainini.functions.dotmoney then
                text = separator(text)
                return {color, text}
            end

end

-- p���� � ���� ���
--[[ function sp.onSetInterior(interior)
        if interior ~= 0 then
            lua_thread.create(function()
                displayRadar()
                return true
            end)
        end
        if interior == 0 then
            lua_thread.create(function()
                displayRadar(1)
                return true
            end)
        end
end ]]

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




function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
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



--[[ 
--- Callbacks
function cmdSetTime(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
      timestsw = hour
      patch_samp_time_set(true)
    else
      patch_samp_time_set(false)
      timestsw = nil
    end
  end
  
  function cmdSetWeather(param)
    local weather = tonumber(param)
    if weather ~= nil and weather >= 0 and weather <= 45 then
      forceWeatherNow(weather)
    end
  end
  
  
  --- Functions
  function patch_samp_time_set(enable)
      if enable and default == nil then
          default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
          writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
      elseif enable == false and default ~= nil then
          writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
          default = nil
      end
  end ]]
  

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