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

local fixbike = false
local dotmoney = true
local Arial = renderCreateFont("Tahoma", 17, 0x4)
local activeextra = false 

update_state = false 
 
local script_vers = 22
local script_vers_text = "10.01.2022"

local update_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "\\config\\update.ini" -- и тут свою ссылку

local script_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/bind_menu.lua" -- тут свою ссылку
local script_path = thisScript().path


textures = {
	['cs_rockdetail2'] = 1,  -- камень
	['ab_flakeywall'] = 2,   -- металл
	['metalic128'] = 3,      -- серебро
	['Strip_Gold'] = 4,	     -- бронза
	['gold128'] = 5          -- золото
}

resNames = {{'Камень', 0xFFFFFFFF}, {'Металл', 0xFF808080}, {'Серебро', 0xFF00BFFF}, {'Бронза', 0xFF654321}, {'Золото', 0xFFFFFF00}}

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



buttonslist = [[
            LBUTTON (1) - Левая кнопка мыши
	RBUTTON (2) - Правая кнопка мыши
	MBUTTON (3) - Колесо мыши (нажатие)
	XBUTTON1 (5) - Доп.кнопка мыши №1
	XBUTTON2 (6) - Доп.кнопка мыши №2

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

	LSHIFT - Левый шифт
	RSHIFT - Правий шифт
	LCONTROL - Левый контрл
	RCONTROL - Правый контрл
	LMENU - Левый альт
	RMENU - Правый альт
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
        password="хуйпизда",
        user_id="602252621",
        bankpin="123456"
    },
    functions = {
        dhits=false,
        extra=false,
        bott=false,
        sl=false,
        autoc=false,
        colorchat=false,
        offrabchat=false,
        offfrachat=false,
        activement=true,
        binder = false,
        arecc = false,
        famkv = false,
        uvedomusora = false
    },
    lidzamband = { 
        devyatka = false,
        naborgtext="/vr Набор в ФК 'The Rifa'. /smug /port | Желающих ждём на площадке.",
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
        tramp="7",
        autodhits="E",
        autoplusc="XBUTTON2"
    },
    flood = {
        fltext3="/j ываываыва",
        flwait2="180",
        flwait1="180",
        flwait3="15",
        flwait4="180",
        flwait5="10",
        fltext1="/vr Набор активных гетто-игроков в закрытую full семью nuestra. 18+, 60+fps fullHD. vk: @blessave",
        fltext2="/vr выывава",
        fltext4="/vr выывава",
        fltext5="/vr выывава"
    },
    oboss = {
        piss1 = false,
        piss2 = true,
        piss3 = false,
        obossactiv = "Q",
        animactiv = "1",
        pissactiv = "2",
        pisstext = "/me обоссал жертву рваного дюрекса по кличке %s"
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
    chatgo = false,
    chatadv = false,
    dialogs = false,
}


local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
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

function requestRunner() -- создание effil потока с функцией https запроса
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

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок
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
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
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
                            elseif pl.button == 'chatgovor' then
								govorchatVK()                            
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
						local text = v.object.message.text .. ' ' --костыль на случай если одна команда является подстрокой другой (!d и !dc как пример)
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
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t then
				if t.error then
					vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
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
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
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
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
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
	keyboard.buttons[4] = {}
	local row = keyboard.buttons[1]
    local row2 = keyboard.buttons[2]
	local row3 = keyboard.buttons[3]
	local row4 = keyboard.buttons[4]
    row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = 'Статус'
    row2[1] = {}
	row2[1].action = {}
	row2[1].color = trubka and 'negative' or 'positive'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "razgovor"}'
	row2[1].action.label = trubka and 'Положить трубку' or 'Поднять трубку'
    row3[1] = {}
	row3[1].action = {}
	row3[1].color = vklchat and 'secondary' or 'primary'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "chatchat"}'
	row3[1].action.label = vklchat and 'Выкл. весь чат' or 'Вкл. весь чат'
    row3[2] = {}
	row3[2].action = {}
	row3[2].color = vklchatfam and 'primary' or 'secondary'
	row3[2].action.type = 'text'
	row3[2].action.payload = '{"button": "famchat"}'
	row3[2].action.label = vklchatfam and 'Вкл. fam чат' or 'Выкл. fam чат'
    row3[3] = {}
	row3[3].action = {}
	row3[3].color = vklchatdialog and 'secondary' or 'primary'
	row3[3].action.type = 'text'
	row3[3].action.payload = '{"button": "alldialogs"}'
	row3[3].action.label = vklchatdialog and 'Выкл. диалоги' or 'Вкл. диалоги'
    row4[1] = {}
	row4[1].action = {}
	row4[1].color = vklchatgovor and 'secondary' or 'primary'
	row4[1].action.type = 'text'
	row4[1].action.payload = '{"button": "chatgovor"}'
	row4[1].action.label = vklchatgovor and 'Выкл. чат рядом' or 'Вкл. чат рядом'
    row4[2] = {}
	row4[2].action = {}
	row4[2].color = vklchatadv and 'secondary' or 'primary'
	row4[2].action.type = 'text'
	row4[2].action.payload = '{"button": "advchat"}'
	row4[2].action.label = vklchatadv and 'Выкл. adv чат' or 'Вкл. adv чат'
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
	response = response .. 'Координаты: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
	sendvknotf(response)
	else
		sendvknotf('Вы не подключены к серверу!')
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
		url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
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


local trigbott = false



function menu()
	sampShowDialog(2138, 'off: {ff0000}SHIFT+F5 {ffffff}| update: {C71585}/ub {ffffff}| legal: {8A2BE2}SHIFT+F2 {ffffff}| vers: {EE82EE}'..script_vers, string.format([[
{00FA9A}Изменить пароль для {ff0000}авто-логина
{AFEEEE}Изменить {ff0000}пин-код {AFEEEE}для банка
{DA70D6}Флудерка
{1E90FF}Режим лидера/заместителя
{9ACD32}Биндер binds.bind
{C0C0C0}Анти-АФК
{DEB887}Чат-лог
{ff4500}Обоссывалка
{E9967A}Авто-еда
Уведомлять семью каждый пейдей об оплате фам.квартиры %s
{ffffff}Рекконект: {ff4500}/hrec {ffffff}| Авто-рекконект %s
{BC8F8F}Кнопки для активации. Название (id)
{FFE4E1}Остальной функционал
]], 
    mainini.functions.famkv and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.arecc and '{00ff00}ON' or '{777777}OFF'), 
    'Выбрать', 'Закрыть', 2)
end

function afk_menu()
	sampShowDialog(2956, '{fff000}Анти-АФК', string.format([[
Изменить цифровой ID {00ffff}VK 
Отправлять различные уведомления %s {ffffff}(только для лаунчера)
{c0c0c0}p.s. для работы анти-афк на лаунчере нужен спец.обход - {808000}#AntiAFK_1.3_byAIR.asi
]],
mainini.afk.uvedomleniya and '{00ff00}ON' or '{777777}OFF'),  
    'Выбрать', 'Закрыть', 2)
end

function chatlog_menu()
    sampShowDialog(10647, "{fff000}Чат-лог", string.format([[
{ffffff}/ch
{ffffff}/ch текст
{ffffff}/chh
]]), "Выйти", _, 0)
end


function drugoenosoft_menu()
	sampShowDialog(2938, '{fff000}Функционал', string.format([[
{ffffff}1. Доставание оружия командами - {DDA0DD}/de /ma /rf /sg /mp5 /pst /ak
{ffffff}3. Сокращенные команды: {DDA0DD}/members -> /mb, /findihouse -> /fh, /findibiz -> /fbiz, /fam -> /k
{ffffff}4. Очистка памяти зоны стрима - {DDA0DD}/cln
{ffffff}5. Удобное открытие меню дома /home - ALT в доме (для домов 20, 46, 47, 48, 57, 61)
{ffffff}6. Удаление всякого ебаного мусора из чата
{ffffff}7. Цветной текст в чате, кто говорит, чат альянса
{ffffff}8. Авто-{DDA0DD}/key
{ffffff}9. Калькулятор - {DDA0DD}/calc
{ffffff}10. Авто-оплата налогов семейной квартиры - {DDA0DD}/fpay
{ffffff}11. Анти-задержка при отправке сообщений в {DDA0DD}/vr
{ffffff}12. Авто-прокрутка сундуков с рулетками - {DDA0DD}/rlt + {ffffff}фикс инвентаря в случае бага
{ffffff}13. Поесть в доме с холодильника - {DDA0DD}/eathome
{ffffff}14. Перевод секунды в минуты при {DDA0DD}/jail
{ffffff}15. Перевод секунды в минуты при {DDA0DD}/mute
{ffffff}16. Узнать цвет авто по иду из /dl - /getcolor
{ffffff}17. Очистка чата - {DDA0DD}/cchat
{ffffff}18. Умные и красивые {DDA0DD}/sms
{ffffff}19. Уведомления об оплате налогов, чтоб не забыть
{ffffff}20. Авто-сборка шара, велика, дельтаплана
{ffffff}21. Отключение чата адвокатов - {DDA0DD}/rabchat
{ffffff}22. Отключение чата банды - {DDA0DD}/frachat
{ffffff}23. Раскраска чата по мнению автора - {DDA0DD}/colorchat
{ffffff}24. Пробив всего себя для фрапса (кроме консоли) - {FF7F50}/probiv
{ffffff}25. {ff0000}CamHack {ffffff}- включить: {DDA0DD}C+1{ffffff}, выключить: {DDA0DD}С+2{ffffff}, ускорить: {DDA0DD}+{ffffff}, замедлить: {DDA0DD}-{ffffff}, показать худ: {DDA0DD}F12

]]),  
    'Закрыть', _, 0)
end

function drugoesoft_menu()
	sampShowDialog(2939, '{fff000}Функционал', string.format([[
{ffffff}1. Рендер многого чего c авто-альтом - {FF7F50}/rend
{ffffff}2. Анти-столбы при врезании в трапспорте - зажать {ff0000}SHIFT
{ffffff}3. Зажимной GM-car - зажать {ff0000}левый SHIFT
{ffffff}4. Авто-баги игры: быстро бегать/плавать - зажать {ff0000}1{ffffff}, ездить на велике/мото - зажать {ff0000}SHIFT{ffffff}, высокий прыжок на велике - {ff0000}C
{ffffff}5. Анти-ломка
{ffffff}6. Авто-нитро - {ff0000}ЛКМ в машине
{ffffff}7. Спидхак маленький - {ff0000}ПКМ в машине
{ffffff}8. Бесконечный бег
{ffffff}9. Зажимное анти-падение с велосипеда/мото - зажать {ff0000}SHIFT. {ffffff}Исключение: в воде всегда не работает
{ffffff}10.Зажимнай анти-коллизия объектов на машинах (Анти-ковш) - зажать {ff0000}левый CTRL
]]),  
    'Закрыть', _, 0)
end

function lidzam_menu()
    sampShowDialog(2741, '{fff000}Режим лидера/зама', string.format([[
Режим лидера/зама для банды %s
Настройки
Режим лидера/зама для мафии %s
Настройки (В разработке)]], 
    mainini.lidzamband.devyatka and '{00ff00}ON' or '{777777}OFF',
    mainini.lidzammafia.devyatka and '{00ff00}ON' or '{777777}OFF'),
        'Выбрать', 'Закрыть', 2)
end

function lidzamband_menu()
    sampShowDialog(2790, '{fff000}Режим лидера/зама банды', string.format([[
Банда: {B0C4DE}%s
{ffffff}С какого лвл принимать: {00ffff}%s
{ffffff}На какой ранг принимать новичков: {00ff00}%s
{ff0000}Флудилка
Пиар набора %s
{C71585}%s сек.
{7FFFD4}%s
{ffffff}Принять в банду на 5 ранг - {ADFF2F}ПКМ+[
{ffffff}Принять в банду на 8 ранг - {ADFF2F}ПКМ+]
{ffffff}Сменить скин - {ADFF2F}ПКМ+= {ffffff}или {90EE90}/gs id skinid
{ffffff}Изменить ранг - {ADFF2F}ПКМ+- {ffffff}или {90EE90}/gr id rank
{ffffff}Уволить из банды с причиной "Выселен" - {CD5C5C}/fu id]],
    mainini.lidzamband.band,
    mainini.lidzamband.minlvl,
    mainini.lidzamband.minrank,
    naborgon and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzamband.naborgwait,
    mainini.lidzamband.naborgtext),
        'Выбрать', 'Закрыть', 2)
end

function lidzammafia_menu()
    sampShowDialog(2791, '{fff000}Режим лидера/зама мафии', string.format([[
Режим лидера/зама %s
Банда: %s
|
Пиар набора %s
{C71585}%s сек.
{7FFFD4}%s
|
Принять в банду на 5 ранг - ПКМ+[
Принять в банду на 8 ранг - ПКМ+]
Сменить скин - ПКМ+= или /gs id skinid
Изменить ранг - ПКМ+- или /gr id rank]], 
    mainini.lidzam.devyatka and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzam.band,
    nabormon and '{00ff00}ON' or '{777777}OFF', 
    mainini.lidzamband.nabormwait,
    mainini.lidzamband.nabormtext),
        'Выбрать', 'Закрыть', 2)
end

function flood_menu()
    sampShowDialog(2787, '{fff000}Флудерка', string.format([[
Flood 1 %s
{C71585}%s сек.
{7FFFD4}%s
Flood 2 %s
{C71585}%s сек.
{7FFFD4}%s
Flood 3 %s
{C71585}%s сек.
{7FFFD4}%s
Flood 4 %s
{C71585}%s сек.
{7FFFD4}%s
Flood 5 %s
{C71585}%s сек.
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
        'Выбрать', 'Закрыть', 2)
end

function ghetto_lidzam_flood()
    sampShowDialog(22487, '{fff000}Ghetto Флудерка', string.format([[
Flood 1 %s
Flood 2 %s
Flood 3 %s
Flood 4 %s
Flood 5 %s
Flood 6 %s
Flood 7 %s
Flood 8 %s
Flood 9 %s
{ffffff}FL1: {C71585}%s сек.
{ffffff}FL1: {7FFFD4}%s
{ffffff}FL2: {C71585}%s сек.
{ffffff}FL2: {7FFFD4}%s
{ffffff}FL3: {C71585}%s сек.
{ffffff}FL3: {7FFFD4}%s
{ffffff}FL4: {C71585}%s сек.
{ffffff}FL4: {7FFFD4}%s
{ffffff}FL5: {C71585}%s сек.
{ffffff}FL5: {7FFFD4}%s
{ffffff}FL6: {C71585}%s сек.
{ffffff}FL6: {7FFFD4}%s
{ffffff}FL7: {C71585}%s сек.
{ffffff}FL7: {7FFFD4}%s
{ffffff}FL8: {C71585}%s сек.
{ffffff}FL8: {7FFFD4}%s
{ffffff}FL9: {C71585}%s сек.
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
        'Выбрать', 'Закрыть', 2)
end

function piss_menu()
    sampShowDialog(4169, '{fff000}Обоссывалка', string.format([[
{ff0000}[ВАЖНО] {ffffff}Из списка ниже нужно выбрать что-то одно
Использовать {c0c0c0}Имя %s
Использовать {c0c0c0}Имя Фамилия %s
Использовать {c0c0c0}Имя_Фамилия %s
{ff4500}Текст обоссывался
Активация обоссывалки: {9370DB}ПКМ + {00ffff}%s
Активация РП /anim 85:{00ffff} %s
Активация нонРП /piss: {00ffff}%s]], 
    mainini.oboss.piss1 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.piss2 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.piss3 and '{00ff00}ON' or '{777777}OFF', 
    mainini.oboss.obossactiv,
    mainini.oboss.animactiv,
    mainini.oboss.pissactiv),
        'Выбрать', 'Закрыть', 2)
end

function eda_menu()
    sampShowDialog(4969, '{fff000}Авто-еда', string.format([[
{ff0000}[ВАЖНО] {ffffff}Из списка ниже нужно выбрать что-то одно
Обычная авто-еда %s
Авто-еда при условии, что надет мешок с мясом %s
Команда для обычной авто-еды. Сейчас: {ff4500}%s]], 
    mainini.autoeda.eda and '{00ff00}ON' or '{777777}OFF', 
    mainini.autoeda.meatbag and '{00ff00}ON' or '{777777}OFF', 
    mainini.autoeda.comeda),
        'Выбрать', 'Закрыть', 2)
end

function binder_menu()
	sampShowDialog(23388, '{fff000}Биндер меню', string.format([[
Биндер %s
Информация]], 
	mainini.functions.binder and '{00ff00}ON' or '{777777}OFF'),
    'Выбрать', 'Закрыть', 2)
end

function binder_info()
	sampShowDialog(2338, '{Fff000}Биндер', string.format([[
{ffffff}В биндере скрипта {fff000}\\moonloader\\config\\binds.bind {ffffff}настройка следующая:
Чтобы добавить биндер нужно в конце строки поставить запятую перед закрывающей квадратной скобкой и вписать:
{FFA07A}{"text":"раз два три - на лоб трампам ссы[enter]","v":[82]}
{ffffff}Здесь: текст бинда это "раз два три - на лоб трампам ссы" ([enter] - нажмимает интер, если не писать то биндер просто введется в чате), 82 - это ID клавиши. В данном случае клавиша R.

Чтобы добавить биндер на команду нужно ввести обратный слэш "\" перед самой командой:
{FFA07A}{"text":"\/mask[enter]","v":[82]}

        {9ACD32}Биндеры по умолчанию:
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
            {ffffff}Распальцовка (q) - {9370DB}R

]]),  
    'Закрыть', _, 0)
end

function soft_menu()
	sampShowDialog(21383, '{fff000}Читерские функции', string.format([[Авто-шот. Активация: {000fff}ALT+9. %s
[%s{ffffff}] Сало на дигл и узи. Активация: {000fff}9. %s
[salo] miss: %sper. dist: %s. wshot: %s. fov: %s. debugmenu: %s
{ffffff}Экстра WS. Активация: {000fff}SHIFT+9. %s
Авто-+С %s
{ff0000}Настройка Авто-+С
Авто-дабл-хиты %s
{ff0000}Настройка Авто-дабл-хиты
Cбив анимки. Активация:{00ffff} %s
Быстрый выход с транспорта. Активация:{00ffff} %s
Самоубийство. Активация:{00ffff} %s
{c0c0c0}WallHack. {0000ff}Cops.
SprintHook. Активация:{00ffff} %s
Трамплин. Активация:{00ffff} %s
{DAA520}Остальной функционал]], 
	mainini.functions.bott and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.sl and '{ff0000}ВЫКЛЮЧИ ДОЛБАЕБ' or '{00ffff}НЕ РАБОТАЕТ',
	mainini.functions.sl and '{00ff00}ON' or '{777777}OFF',
    settings.miss_ratio,
    settings.max_distance,
    settings.through_walls,
    settings.field_of_search,
    debugMode and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.extra and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.autoc and '{00ff00}ON' or '{777777}OFF',
    mainini.functions.dhits and '{00ff00}ON' or '{777777}OFF',
    mainini.config.sbiv,
    mainini.config.allsbiv,
    mainini.config.suicide,
    mainini.config.shook,
    mainini.config.tramp),
    'Выбрать', 'Закрыть', 2)
end

function wh_cops_pidors()
	sampShowDialog(2859, '{fff000}{c0c0c0}WallHack. {0000ff}Cops.', string.format([[WallHack. Активация:{00ffff} %s
Детектор мусоров %s {ffffff}(хавает FPS)
Уведомление на экране о том, что в зоне стрима есть Мусора %s]], 
    mainini.config.wh,
	mainini.functions.activement and '{00ff00}ON' or '{777777}OFF', 
	mainini.functions.uvedomusora and '{00ff00}ON' or '{777777}OFF'),
    'Выбрать', 'Закрыть', 2)
end

function edit_wh()
	sampShowDialog(2250, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.wh), 
'Сохранить', 'Закрыть', 1)
end

function edit_suicide()
	sampShowDialog(2251, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.suicide), 
'Сохранить', 'Закрыть', 1)
end

function edit_shook()
	sampShowDialog(2293, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.shook), 
'Сохранить', 'Закрыть', 1)
end


function edit_tramp()
	sampShowDialog(2299, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.tramp), 
'Сохранить', 'Закрыть', 1)
end

function edit_allsbiv()
	sampShowDialog(2252, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.allsbiv), 
'Сохранить', 'Закрыть', 1)
end

function edit_autoc()
	sampShowDialog(22526, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.autoplusc), 
'Сохранить', 'Закрыть', 1)
end

function edit_dhits()
	sampShowDialog(22527, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
mainini.config.autodhits), 
'Сохранить', 'Закрыть', 1)
end

function edit_sbiv()
	sampShowDialog(2253, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущий ID: {00ffff}%s]], 
mainini.config.sbiv), 
'Сохранить', 'Закрыть', 1)
end



function edit_userid()
	sampShowDialog(2139, '{fff000}Настройки', string.format([[
{ffffff}Для начала работы скрипта {ff4500}ble$$ave {ffffff}необходимо:
{ffffff}Перейти в группу {00FF00}https://vk.com/blessavesoft. {ffffff}Вступить и написать в личные сообщения группе.
{ffffff}Вставить в {FF1493}этом {ffffff}диалоговом окне скопированный цифровой ID вашего VK.
{ffffff}Если вы всё сделали правильно то вам придет сообщение с тектом {F5DEB3}тестовое сообщение{ffffff}.
Текущий ID: {00ffff}%s]], 
mainini.helper.user_id), 
'Сохранить', 'Закрыть', 1)
end

function edit_pass()
	sampShowDialog(21391, '{fff000}Настройки', string.format([[
{ffffff}Введите свой пароль от аккаунта.
{ffffff}Текущий пароль: {00ffff}%s]], 
mainini.helper.password), 
'Сохранить', 'Закрыть', 1)
end
function edit_bank()
	sampShowDialog(21392, '{fff000}Настройки', string.format([[
{ffffff}Введите свой банковский пин-код.
{ffffff}Текущий пин-код: {00ffff}%s]], 
mainini.helper.bankpin), 
'Сохранить', 'Закрыть', 1)
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
local PI = 3.14159
if not doesFileExist("moonloader\\config\\udpate.ini") then
    downloadUrlToFile("https://raw.githubusercontent.com/tedjblessave/binder/main/udpate.ini", "moonloader\\config\\udpate.ini", function(id, statuss, p1, p2)
        if statuss == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage("Загружен файл {c0c0c0}udpate.ini {ffffff}для работы скрипта." , -1)
        end 
    end)
end
local _, ider = sampGetPlayerIdByCharHandle(PLAYER_PED)
local nicker = sampGetPlayerNickname(ider)
local nickker = string.match(nicker, '(.*)_')
--printStringNow("~B~Script ~Y~/blessave ~G~ON ~P~for "..nickker, 1500, 5)

workpaus(true)
lAA = lua_thread.create(lAA)
renderr = lua_thread.create(renderr)



downloadUrlToFile(update_url, update_path, function(id, status)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        updateini = inicfg.load(nil, update_path)
        if tonumber(updateini.info.vers) > script_vers then
            sampAddChatMessage("Есть обновление! Версия за {FA8072}" .. updateini.info.vers_text.. " {ffffff}число. {c0c0c0}Обновить: {ff4500}/ub", -1)
            update_state = true
        end
        --os.remove(update_path)
    end
end)


sampRegisterChatCommand("/sm", setStatic)
sampRegisterChatCommand("/t", setTime)
sampRegisterChatCommand("/w", setWeather)

sampRegisterChatCommand('bind', menu)

local fontSF = renderCreateFont("Arial", 8, 5) --creating font
sampfuncsRegisterConsoleCommand("deletetd", del)    --registering command to sampfuncs console, this will call delete function
sampfuncsRegisterConsoleCommand("showtdid", show)   --registering command to sampfuncs console, this will call function that shows textdraw id's
sampfuncsRegisterConsoleCommand("getdialoginfo", dialoginfo) --registering sf console command

sampRegisterChatCommand('calc', function(arg) 
if #arg > 0 then 
local k = calc(arg)
if k then 
sampAddChatMessage('[Calculator] {FFFFFF}Решенный пример: {FFFF00}' ..arg.. ' = ' .. k,0xff4500)  
end 
else sampAddChatMessage("[Calculator] {FFFFFF}Введи пример который нужно решить" , 0xff4500)
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
    renderFontDrawText(fontALT, "{ffffff}Auto{ff0000}ALT", 1400, 600, 0xDD6622FF)
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
                            renderFontDrawText(fontment, '{0000ff}Мусорa: {FFFFFF}'..policeCounter, w/50, h/3.350, 0xFFFFFFFF)
                            renderFontDrawText(fontment, '{'..warningment..'}'..namement..'{ffffff}['..idment..'] {18cd58}lvl: {ffffff}'..sampGetPlayerScore(idment), w/50, h/Yposm, 0xFFFFFFFF)
                        end
                    end    
                end
            end
        end
        if not isPauseMenuActive() and policeCounter == 0 then
            renderFontDrawText(fontment1, 'Возле вас нет мусоров.', w/50, h/3.350, 0xFFFFFFFF)
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
                           -- renderFontDrawText(fontment, '{0000ff}Мусорa: {FFFFFF}'..policeCounter, w/6, h/3.350, 0xFFFFFFFF)
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

if mainini.functions.sl and isKeyJustPressed(57) and isKeyCheckAvailable() and not isKeyDown(18) and not isKeyDown(16) and not isKeyDown(17) and not captureon then statesl = not statesl end



if isKeyDown(18) and isKeyJustPressed(57) and isKeyCheckAvailable() then trigbott = not trigbott end
if trigbott then 
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







local texthome = sampTextdrawGetString(2054)
if texthome:match("House~g~ 20") or texthome:match("House~g~ 61") or texthome:match("House~g~ 47") or texthome:match("House~g~ 46") or texthome:match("House~g~ 48") or texthome:match("House~g~ 57") then
    menuhome = true
end
if menuhome and not sampTextdrawIsExists(2054) then menuhome = false end

if sampTextdrawIsExists(2103) and not act then
-- addOneOffSound(0.0, 0.0, 0.0, 23000)
    local text = sampTextdrawGetString(2103)
    if text:find('Incoming') and mainini.afk.uvedomleniya then
        local nick = text:gsub('(%s)(%w_%w)(.+)', '%2')
        sendvknotf('<3 Тебе звонит '..nick) -- output
    end
    act = true
end
if act and not sampTextdrawIsExists(2103) then act = false end

while isPauseMenuActive() do -- в меню паузы отключаем курсор, если он активен
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




doKeyCheck()

arec()






if isKeyJustPressed(78) and isCharInAnyCar(PLAYER_PED) then
    notkey = true
end


if isKeyDown(16) and isKeyJustPressed(116) and isKeyCheckAvailable() then
    --printStringNow("~B~Script ~Y~/blessave ~R~OFF ~P~for "..nickker, 1500, 5)
    thisScript():unload() 
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
        wh = false
        sound = false
        sound1 = false
        statesl = false
       actmentpidor = false
        cameraRestorePatch(false)
        activeextra = false
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
end
if isKeyDown(119) then
    if wh then 
        nameTagOff()
        wait(1000)
        nameTagOn()
    end
end

if mainini.functions.sl and statesl then 
    local clr = join_argb(0, 133, 17, 17)
    local r,g,b = 133, 17, 17
    writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
else
    local clr = join_argb(0, 128, 46, 46)
    local r,g,b = 128, 46, 46
    writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
end

if mainini.functions.sl and statesl and settings.show_circle and isKeyDown(2) and isCharOnFoot(1) and getDamage(getCurrentCharWeapon(1)) then
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

function sp.onSendBulletSync(data)
    if mainini.functions.sl then
        if getCurrentCharWeapon(playerPed) == 24 then
            math.randomseed(os.clock())
            if not statesl then return end
            local weap = getCurrentCharWeapon(1)
            if not getDamage(weap) then return end
            local id, ped = getClosestPlayerFromCrosshair()
            if id == -1 then return debugSay('В зоне вокруг прицела не было найдено игроков') end
            local vmes =	sampGetPlayerNickname(id) .. ' > ' .. math.floor(getDistanceFromPed(ped)) .. 'm > ' ..
                    math.floor(getCharSpeed(1) * 3) .. ' vs ' .. math.floor(getCharSpeed(ped) * 3) .. ' > '
            if data.targetType == 1 then return debugSay(vmes .. '{008000}Без помощи аима') end
            if math.random(1, 100) < settings.miss_ratio and not isKeyDown(VK_Q) then return debugSay(vmes .. '{40E0D0}Имитация промахов') end
            if not getcond(ped) then return debugSay(vmes .. '{FFA500}Игрок за текстурами') end
            debugSay(vmes .. '{FF0000}Сработал аим')
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
            if id == -1 then return debugSay('В зоне вокруг прицела не было найдено игроков') end
            local vmes =	sampGetPlayerNickname(id) .. ' > ' .. math.floor(getDistanceFromPed(ped)) .. 'm > ' ..
                    math.floor(getCharSpeed(1) * 3) .. ' vs ' .. math.floor(getCharSpeed(ped) * 3) .. ' > '
            if data.targetType == 1 then return debugSay(vmes .. '{008000}Без помощи аима') end
            if math.random(1, 100) < 0 and not isKeyDown(VK_Q) then return debugSay(vmes .. '{40E0D0}Имитация промахов') end
            if not getcond(ped) then return debugSay(vmes .. '{FFA500}Игрок за текстурами') end
            debugSay(vmes .. '{FF0000}Сработал аим')
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
        --sampAddChatMessage('Возможно долбаеб '..nickname.."("..playerId..") вошел в игру.", -1)
        --notf.addNotification(string.format("%s \nКакой-то хуй с фамилией Nuestra\n\n"..nickname.."("..playerId..") вошел в игру." , os.date()), 10)
	end
end)
end
end 

function sp.onPlayerJoin(playerId, color, isNpc, nickname)
    if nickname == "Chief_Cannon" then
        sendvknotf0("чиф в ИГРЕ!")
    end
end

function sp.onPlayerQuit(playerId, reason)
	if logginggh then
		if reason == 0 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") вышел из игры.", -1)
		elseif reason == 1 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") вышел из игры.", -1)
		elseif reason == 2 then
            sampAddChatMessage(sampGetPlayerNickname(playerId).."("..playerId..") вышел из игры.", -1)
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
    if s == thisScript() then
        if marker or checkpoint or mark or dtext then
            removeUser3dMarker(mark)
            deleteCheckpoint(marker)
            removeBlip(checkpoint)
            sampDestroy3dText(dtext)
        end 
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

if checked_test and active then
    lua_thread.create(function()
      if data.modelId == 19918 then
        wait(111)
        sampSendClickTextdraw(id)
        use = true
      end
      if data.text == 'USE' or data.text == '…CЊO‡’€O‹AЏ’' and use then
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
      if data.text == 'USE' or data.text == '…CЊO‡’€O‹AЏ’' and use1 then
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
      if data.text == 'USE' or data.text == '…CЊO‡’€O‹AЏ’' and use2 then
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
      if data.text == 'USE' or data.text == '…CЊO‡’€O‹AЏ’' and use3 then
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
        if dotmoney then
		    text = separator(text)
		    return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
        end
	end
    function se.onSetObjectMaterialText(id, data)
        local object = sampGetObjectHandleBySampId(id)
        if object and doesObjectExist(object) then
            if getObjectModel(object) == 18663 then
                if string.find(data.text, "Владелец: [A-z0-9_]+") then
                    last = {
                        vehicle = nil,
                        price = nil,
                        tuning = nil
                    }
    
                    local tuning = string.match(data.text, "\n\n\n([^\n]+)\n\nВладелец: [A-z0-9_]+\n{%x+}id: %d+")
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
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." or chatstring == "Сервер закрыл соединение." or chatstring == "Wrong server password." or chatstring == "Use /quit to exit or press ESC and select Quit Game" then
        sampDisconnectWithReason(false)
        wait(3000)
        printStringNow("~B~AUTORECONNECT", 3000)
            wait(100) -- задержка
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
  printStringNow("~B~RECONNECT", 3000)
  wait(100) -- задержка
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

        if mainini.lidzamband.devyatka and isKeyJustPressed(219) and isKeyCheckAvailable() then
            if sampGetPlayerScore(id) >= mainini.lidzamband.minlvl then
                sampSendChat(string.format("/todo Надень вот это на себя*кинув в руки %s поношенную(5) бандану %s", namee, mainini.lidzamband.band))
                wait(500)
                sampSendChat(string.format('/invite %s', name))
                wait(3000)
                sampSendChat(string.format('/giverank %s %s', name, mainini.lidzamband.minrank))
            else
                sampSendChat(string.format("%s, в нашу банду %s проходит набор с %s лет проживания в штате", namee, mainini.lidzamband.band, mainini.lidzamband.minlvl))
            end
        end
        if mainini.lidzamband.devyatka and isKeyJustPressed(221) and isKeyCheckAvailable() then
            sampSendChat(string.format("/todo Надень вот это на себя*кинув в руки %s легендарную(8) бандану %s", namee, mainini.lidzamband.band))
            wait(500)
            sampSendChat(string.format('/invite %s', name))
            wait(3000)
            sampSendChat(string.format('/giverank %s 8', name))
            -- принял ваше предложение вступить к вам в организацию

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
            setCurrentCharWeapon(PLAYER_PED, 0) -- скроллит на фист
            sampForceOnfootSync() -- отправляет синхронизацию для того чтобы и для других челов у тебя из рук на несколько мс пропал дигл
            wait(200) -- сама задержка скролла, она выставляется в миллисекундах, т.е 1000мс = 1с, самое оптимальное значение 200-300 мс
            setCurrentCharWeapon(PLAYER_PED, 24) -- скроллит обратно на дигл
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
    sendvknotf('Весь чат '..(vklchat and 'включен!' or 'выключен!'))
end
function famchatVK()
    vklchatfam = not vklchatfam
    if vklchatfam then
        vknotf.chatf = true
    else
        vknotf.chatf = false
    end
    sendvknotf('Fam чат '..(vklchatfam and 'включен!' or 'выключен!'))
end
function govorchatVK()
    vklchatgovor = not vklchatgovor
    if vklchatgovor then
        vknotf.chatgo = true
    else
        vknotf.chatgo = false
    end
    sendvknotf('Чат рядом '..(vklchatgovor and 'включен!' or 'выключен!'))
end
function advchatVK()
    vklchatadv = not vklchatadv
    if vklchatadv then
        vknotf.chatadv = true
    else
        vknotf.chatadv = false
    end
    sendvknotf('Адвокатский чат '..(vklchatadv and 'включен!' or 'выключен!'))
end
function alldialogsVK()
    vklchatdialog = not vklchatdialog
    if vklchatdialog then
        vknotf.dialogs = true
    else
        vknotf.dialogs = false
    end
    sendvknotf('Диалоги '..(vklchatdialog and 'включены!' or 'выключены!'))
end
function razgovorVK()
    trubka = not trubka
    if trubka then
        sampSendClickTextdraw(2108)
        sendvknotf('Разговор начат!')
    else
        sampSendChat('/phone')
        sendvknotf('Звонок окончен!')
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
	NTdist = mem.getfloat(pStSet + 39) -- дальность
	NTwalls = mem.getint8(pStSet + 47) -- видимость через стены
	NTshow = mem.getint8(pStSet + 56) -- видимость тегов
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

    function sp.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
        if mainini.afk.uvedomleniya then
            sendvknotf('Вы подключились к серверу!', hostName)
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
   

    if fix and text:find("Курс пополнения счета") then
		sampSendDialogResponse(id, 0, 0, "")
		sampAddChatMessage("{ffffff} inventory {ff0000}fixed{ffffff}!",-1)
        
		return false
        --fix = false
	end
    if text:find("Вы были кикнуты за подозрение") and mainini.afk.uvedomleniya then
        sendvknotf(text)
	--return false
        --fix = false
	end
    if id == 2 then
        if mainini.helper.password ~= "хуйпизда" then
            sampSendDialogResponse(id, 1, _, mainini.helper.password)
            return false
        end
    end
    if id == 15252 then
        if title:find('Оплата всех налогов') then	
            if text:find('В сумме за всё') then
                text = '{ff0000}НЕ ЗАБУДЬ ЗАПЛАТИТЬ ЗА СЕМЕЙНУЮ КВАРТИРУ!\n'..text .. '\n' .. ' '
            end
        end
    end

    if id == 9989 then
        if text:find('Выйти на улицу') and text:find('Войти в гараж') then
            text = text .. '\n{00ffff}Меню дома'
        elseif text:find('Выйти на улицу') and not text:find('Войти в гараж') then
            text = text .. '\n' .. ' '
            text = text .. '\n{00ffff}Меню дома'
        end
    end

    if id == 162 and fixbike then
        lua_thread.create(function()
            local index = sampGetListboxItemByText('Mountain')
            --local index = sampGetListboxItemByText('%Mountain.-%a+', false)
            sampSendDialogResponse(162,1, index,nil)
            sampSendDialogResponse(163,1,9,nil)
            --sampSendDialogResponse(ид диалога, ид кнопки (0 / 1) , номер элемента списка (от 0), текст введенный в поле)
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

      if id == 8928 and mainini.afk.uvedomleniya then
        sendvknotf(text)
       -- return false
    end
    if id == 7782 and mainini.afk.uvedomleniya then
        sendvknotf(text)
       -- return false
    end
    if id == 1333 and mainini.afk.uvedomleniya then
        sendvknotf(text)
        setVirtualKeyDown(13, false)
    end
    if id == 1332 then
        setVirtualKeyDown(13, false)
    end
    if text:find('Вы получили бан аккаунта') and mainini.afk.uvedomleniya then
        local svk = text:gsub('\n','') 
        svk = svk:gsub('\t','') 
        sendvknotf('(warning | dialog) '..svk)
    end
    
        if text:find('Администратор (.+) ответил вам') and mainini.afk.uvedomleniya then
            local svk = text:gsub('\n','') 
            svk = svk:gsub('\t','') 
            sendvknotf('(warning | dialog) '..svk)
        end
    --/eathome
	if gotoeatinhouse then
		local linelist = 0
		for n in text:gmatch('[^\r\n]+') do
			if id == 174 and n:find('Меню дома') then
				sampSendDialogResponse(174, 1, linelist, false)
			elseif id == 2431 and n:find('Холодильник') then
				sampSendDialogResponse(2431, 1, linelist, false)
			elseif id == 185 and n:find('Комплексный Обед') then
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
	if text:find("В этом месте запрещено") then
		setVirtualKeyDown(13, false)
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
---- автоеда, автосек в дмг, авто ТТ
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
            local result, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 2, "Для")
            
            local result1, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 2, "Чтобы подобрать")
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
            if ScriptState then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("Нажмите 'ALT'") and text:find("Хлопок") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{008000}Хлопок {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find("Хлопок") and text:find("Осталось %d+:%d+")  then
                            timerr = text:match("%d+:%d+")
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                --distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                --renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                --text = string.format("{8B4513}Лён {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                --renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                renderFontDrawText(Arial, "{2E8B57}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{008000}Хлопок: {FFFFFF}'..Counter, 1200, 700, 0xDD6622FF)
            end
            if ScriptState2 then
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("Нажмите 'ALT'") and text:find("Лён")  then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                --local timerr = "Осталось %d+"
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{8B4513}Лён {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                                --renderFontDrawText(Arial, timerr, wposX, wposY, 0xDD6622FF)
                            end
                        end
                        if text:find("Лён") and text:find("Осталось %d+:%d+")  then
                            timerr = text:match("%d+:%d+")
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                              wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, "{D2B48C}"..timerr, wposX, wposY, -1)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{8B4513}Лён: {FFFFFF}'..Counter, 1200, 800, 0xDD6622FF)
            end
            if ScriptState3 then
                
                Counter = 0
                local px, py, pz = getCharCoordinates(PLAYER_PED)
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if (text:find("Нажмите 'ALT'") or text:find("Нажмите'ALT'")) and text:find("Месторождение ресурсов") then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)	
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{00FFFF}Ресурс {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                           end
                        end
                    end
                end

                renderFontDrawText(Arial, '{00FFFF}Рeсурсы: {ffffff}'..Counter, 1100, 600, 0xDD6622FF)

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
                        renderFontDrawText(Arial,"{20B2AA}Семена {00ff00}"..distance, x1, y1, -1)
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
                        textole = string.format("{BC8F8F}Олень {00ff00}"..distance)	
                        wposX = x1 + 5
                        wposY = y1 - 7					
                    renderFontDrawText(font, textole, wposX, wposY, -1)
                    end
                end
            end
                    renderFontDrawText(Arial, '{BC8F8F}Олени: {ffffff}'..olenk, 1200, 600, 0xDD6622FF)
            end
            if graffiti then
                    for id = 0, 2048 do
                              if sampIs3dTextDefined(id) then
                                  local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                                  if text:find('Grove Street') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
                              text = string.format("{B0E0E6}[Graffiti] {228B22}Grove Street")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {228B22}Grove Street {FFFAFA}[+]")
                            end
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('The Rifa') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
                              text = string.format("{B0E0E6}[Graffiti] {4682B4}The Rifa")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {4682B4}The Rifa {FFFAFA}[+]")
                            end
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('East Side Ballas') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
                              text = string.format("{B0E0E6}[Graffiti] {EE82EE}Ballas")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {EE82EE}Ballas {FFFAFA}[+]")
                            end
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Varrios Los Aztecas') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
                              text = string.format("{B0E0E6}[Graffiti] {00BFFF}Los-Aztecas")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {00BFFF}Los-Aztecas {FFFAFA}[+]")
                            end
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Night Wolves') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
                              text = string.format("{B0E0E6}[Graffiti] {DCDCDC}Night Wolves")
                              else
                              text = string.format("{B0E0E6}[Graffiti] {DCDCDC}Night Wolves {FFFAFA}[+]")
                            end
                            renderFontDrawText(font, text, p1, p2, 0xcac1f4c1)
                          end
                        end
                        if text:find('Los Santos Vagos') and text:find('Можно закрасить') then
                                      if isPointOnScreen(posX, posY, posZ, 3.0) then
                                          p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                            p3, p4 = convert3DCoordsToScreen(px, py, pz)
                            if text:find('часов') then 
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
                        if text:find('Закладка') then
                            Counter = Counter + 1
                            if isPointOnScreen(posX, posY, posZ, 0.3) then
                                p1, p2 = convert3DCoordsToScreen(posX, posY, posZ)
                                p3, p4 = convert3DCoordsToScreen(px, py, pz)
                                local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                                distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                text = string.format("{EE82EE}Закладка {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{EE82EE}Закладок:{ffffff} '..Counter, 1200, 600, 0xDD6622FF)
            end
           
            if on then
                if draw_suka then
                    removeUser3dMarker(mark)
                    mark = createUser3dMarker(x,y,z+2,0xFFD00000)
                else
                    removeUser3dMarker(mark)
        
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
                        renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, rotate, 0xFFFFFFFF)
        			    renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(fontVR) / 2), 20, 20, 3, -1 * rotate, 0xFF0090FF)
    		        	renderFontDrawText(fontVR, message, X + 25, Y, -1)
		        end
		        wait(0)
			end
		end)
	end
    if cmd:find('/rlt') then
        rlton = not rlton
        if rlton then
            sendvknotf0("Прокрутка рулеток и фикс инв вкл")
            sampAddChatMessage("{ffffff}Прокрутка рулеток и фикс инв {00FF00}вкл",-1)
            checked_test = true
            checked_test2 = true
            checked_test3 = true
            checked_test4 = true
            --activrsdf = true
            else
            sendvknotf0("Прокрутка рулеток и фикс инв выкл")
            sampAddChatMessage("{ffffff}Прокрутка рулеток и фикс инв {ff0000}выкл",-1)
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
    if cmd:find('/g9') then
        mainini.lidzamband.devyatka = not mainini.lidzamband.devyatka
        if mainini.lidzamband.devyatka then
            sampAddChatMessage("Режим заместителя в банде {228b22}on {ffffff}| /h9 - помощь ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("Режим заместителя в банде {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if cmd:find('/m9') then
        mainini.lidzammafia.devyatka = not mainini.lidzammafia.devyatka
        if mainini.lidzammafia.devyatka then
            sampAddChatMessage("Режим заместителя в мафии {228b22}on {ffffff}| /h9 - помощь ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("Режим заместителя в мафии {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if cmd:find("/h9") and mainini.lidzamband.devyatka then
        lidzamband_menu()
        return false
    end
    if cmd:find("/h9") and mainini.lidzammafia.devyatka then
        lidzammafia_menu()
        return false
    end
    if cmd:find('/nabor') and mainini.lidzamband.devyatka then
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
    if cmd:find('/fu') and mainini.lidzamband.devyatka then 
        local arguninv = cmd:match('/fu (.+)')
        sampSendChat('/uninvite '..arguninv..' Выселен.')
        return false
    end
--[[     if cmd:find('/fc') and mainini.lidzamband.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 4, -1)
        return false
    end
    if cmd:find('/sc') and mainini.lidzamband.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 3, -1)
        return false
    end ]]
    if cmd:find('/gr') and not cmd:find('/graf') and mainini.lidzamband.devyatka then 
        local argidgr = cmd:match('/gr (.+)')
        sampSendChat('/giverank '..argidgr)
        return false
    end
    if cmd:find('/gs') and mainini.lidzamband.devyatka then 
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
            wait(2500)
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
            wait(2000)
            setVirtualKeyDown(9, false)
            wait(1000)
            setVirtualKeyDown(192, false)
        end)
        return false
    end

    if cmd:find('/colorchat') then
        mainini.functions.colorchat = not mainini.functions.colorchat
		if mainini.functions.colorchat then 
            sampAddChatMessage('Цветной chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Цветной chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/rabchat') then
        mainini.functions.offrabchat = not mainini.functions.offrabchat
		if not mainini.functions.offrabchat then 
            sampAddChatMessage('Рабочий-chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Рабочий-chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/frachat') then
        mainini.functions.offfrachat = not mainini.functions.offfrachat
		if not mainini.functions.offfrachat then 
            sampAddChatMessage('Фракционный-chat {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Фракционный-chat {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end

    if cmd:find('/ch') and not cmd:find('/ch (.+)') and not cmd:find('/chh') then
        tbl = {}
        for l in io.lines(getWorkingDirectory()..'\\config\\chatlogs\\chatlog_' .. os.date('%y.%m.%d').. '.txt') do 
            if l ~= "" then
                table.insert(tbl, string.sub(l, 1, 325)) 
            end
        end
        if #tbl <= 2000 then    
            sampShowDialog(1007, "Результат: "..#tbl, table.concat(tbl, "\n"), "Выйти", _, 4)
        elseif #tbl > 2000 then
            local warningch = "{ffffff}В чат-логе целых {ff0000}"..#tbl.." {ffffff}строк, может быть пролаг вплоть до краша. \nРекомендую использовать поиск по фразе/слову - {00ffff}/ch (слово) \n{ffffff}Если хочешь вывести чат-лог целиком вводи - {fff000}/chh"
            sampShowDialog(1047, "{ff0000}Предупреждение", warningch, "Выйти", _, 0)
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
        sampShowDialog(1007, "Результат: "..#tbl, table.concat(tbl, "\n"), "Выйти", _, 4)
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
        sampShowDialog(1007, "Ищем: "..param.." | Результат: "..#tbl, table.concat(tbl, "\n"), "Выйти", _, 4)
        return false
    end
    if cmd:find('/eathome') then
        gotoeatinhouse = true; sampSendChat('/home')
        return false
    end
    ---
    if cmd:find('/piss') then
        sampSetSpecialAction(68)
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
    if cmd:find('/fpay') then
        activefpay = not activefpay gopay()
        return false
    end
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
                sampAddChatMessage(string.format('Цвет траспорта:{FFFFFF} %s | %s', clr1, clr2), 0xFF4500)
            else
                sampAddChatMessage('Транспорта с таким ID нет в зоне прорисовки!', 0xFFF000)
            end
        end
        return false
    end
    if cmd:find('/flood') and not (cmd:find('/flood1') or cmd:find('/flood2') or cmd:find('/flood3') or cmd:find('/flood4') or cmd:find('/flood5')) then
        flood_menu()
        return false
    end

    if cmd:find('/gflood') then
        ghetto_lidzam_flood()
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
    if cmd:find('/flood4') then
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
    if cmd:find('/flood5') then
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

if cmd:find('/mnk (.+)') then
    local arg = cmd:match('/mnk (.+)')
        if sampIsPlayerConnected(arg) then
            arg = sampGetPlayerNickname(arg)
        else
            sampAddChatMessage('Игрока нет на сервере!', -1)
            return
        end
        on = not on
        if on then
            sampAddChatMessage('Ищем: '..arg..'!', -1)
            
            lua_thread.create(function()

            while on do
                wait(0)
                local id = sampGetPlayerIdByNickname(arg)
                if id ~= nil and id ~= -1 and id ~= false then
                    local res, handle = sampGetCharHandleBySampPlayerId(id)
                    if res then

                        

                        local screen_text = 'Нашли!'
                        x, y, z = getCharCoordinates(handle)
                        local mX, mY, mZ = getCharCoordinates(playerPed)
                        local x1, y1 = convert3DCoordsToScreen(x,y,z)
                        local x2, y2 = convert3DCoordsToScreen(mX, mY, mZ)
                        if isPointOnScreen(x,y,z,0) then
                            renderDrawLine(x2, y2, x1, y1, 2.0, 0xDD6622FF)
                            renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                        else
                            screen_text = 'Где-то рядом!'
                        end
                        printStringNow(conv(screen_text),1)
                    else
                        if marker or checkpoint then
                            deleteCheckpoint(marker)
                            removeBlip(checkpoint)
                        end
                    end
                end
            end
    
        end)
    else
        lua_thread.create(function()
            draw_suka = false
            wait(10)
            removeUser3dMarker(mark)
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
    if cmd:find('/ma (.+)') then
        local arg = cmd:match('/ma (.+)')
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
        return false
    end  

    if cmd:find("/coords") then
        coordmy = not coordmy
        return false
    end

    if cmd:find('/bind_soft') then
        soft_menu()
        return false
    end   
    if cmd:find("/fid") then
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

    if cmd:find("/fnum") then
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
  
    if cmd:find('/ub') and update_state then  
        lua_thread.create(function()
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            update_state = false
        end)
        return false
    end  
    ---
    if cmd:find('^/rend') then
		sampAddChatMessage("{8B4513}Лён: {33EA0D}Активация: {7B68EE}/len", -1)
		sampAddChatMessage("{008000}Хлопок: {33EA0D}Активация: {7B68EE}/hlop", -1)
		sampAddChatMessage("{00FFFF}Ресурсы: {33EA0D}Активация: {7B68EE}/waxta", -1)
		sampAddChatMessage("{EE82EE}Закладки: {33EA0D}Активация: {7B68EE}/gn", -1)
		sampAddChatMessage("{20B2AA}Семена нарко: {33EA0D}Активация: {7B68EE}/semena", -1)
		sampAddChatMessage("{BC8F8F}Олени: {33EA0D}Активация: {7B68EE}/olenina", -1)
		sampAddChatMessage("{0000CD}Авто Альт: {33EA0D}Активация: {7B68EE}/laa", -1)
		sampAddChatMessage("{808080}Поиск игрока в зоне стрима: {33EA0D}Активация: {7B68EE}/mnk (id)", -1)
		sampAddChatMessage("{ff1493}Граффити банд: {33EA0D}Активация: {7B68EE}/graf {ffffff}| быстрая краска '{ff1493}77{ffffff}' как чит-код", -1)
		sampAddChatMessage("{00FF00}Зеленым {87CEEB}цветом отмечается расстояние до объекта.", -1)
		sampAddChatMessage("{9932CC}Пурпурным {87CEEB}линии до объекта.", -1)
		sampAddChatMessage("{ffffff}Белым {87CEEB}количество объектов в зоне стрима.", -1)
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
    if cmd:find('/waxta') then
        ScriptState3 = not ScriptState3
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
		else
            autoaltrend = false
		end
        return false
    end
    ----------------------------------------------------------------
end


function CleanMemory()
	-- адреса памяти можно взять тут https://github.com/DK22Pac/plugin-sdk/blob/master/plugin_sa/game_sa/CGame.cpp
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
    sampAddChatMessage("Очистка памяти была произведена и прошла успешно." , -1)
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
   -- print(text, color)
    --[[          if  text:find('говорит:') then
            print('{'..bit.tohex(bit.rshift(color, 8), 6)..'}'..text)
            print('======')
            print('%X', color)
            print(bit.tohex(bit.rshift(color, 8), 6))
            end ]]
    if text:find('Член семьи') and text:find('в счёт оплату') and color == -1178486529 and mainini.afk.uvedomleniya then
        sendvknotf0(text..' <3')
    end
    if text:find("У вас нет мешка с мясом") and color ==  -10270721 then
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
        if text:find("UID") and text:find("Уровень") and color == -1 then
            if doesFileExist(bazafpath) then
                local bazafa = io.open(bazafpath, 'a+')
                if bazafa then bazafa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
            end
        end
	end
    if menuhome then
        if text:find('Дверь закрыта, невозможно зайти') and color == -10270721 then
            sampSendChat("/home")
        end
    end
    if color == 1118842111 and text:find('Вы использовали') and mainini.afk.uvedomleniya then
        sendvknotf0(text)
    end

    if text:find('Вам удалось улучшить') and color == 1941201407 and mainini.afk.uvedomleniya  then
        sendvknotf0(text)
    end
    if text:match('{73B461}%[Тел%]:')  and mainini.afk.uvedomleniya then
        sendvknotf0(text)
        text = text:gsub('^{73B461}%[Тел%]', '{2FAA5B}[Тел]') --b800a2
        return { 0xFFFFFFFF, text }
    end
    if color == -1347440641 and text:find('Звонок окончен') and text:find('Информация') and text:find('Время разговора') and mainini.afk.uvedomleniya  then
        sendvknotf(text)
    end
    if vknotf.chatc  and mainini.afk.uvedomleniya then 
		sendvknotf0(text)
	end 
    if not vknotf.chatf  and mainini.afk.uvedomleniya then 
        if text:find('%[Семья') or text:find('%[Альянс ') or text:find('%[Новости Семьи%]') then
			sendvknotf0(text)
		end
	end 
    if vknotf.chatadv  and mainini.afk.uvedomleniya then 
        if text:find('%[Адвокат%] ') then
			sendvknotf0(text)
		end
	end 
    if vknotf.chatgo  and mainini.afk.uvedomleniya then 
        if text:find('говорит:') then
			sendvknotf0(text)
		end
	end 
    if color == -1347440641 and text:find('купил у вас') and text:find('от продажи') and text:find('комиссия')  and mainini.afk.uvedomleniya then
        sendvknotf(text)
    end
    if color == -1347440641 and text:find('Вы купили') and text:find('у игрока')  and mainini.afk.uvedomleniya then
        sendvknotf(text)
    end
    if color == 1941201407 and text:find('Поздравляем с продажей транспортного средства') and mainini.afk.uvedomleniya  then
        sendvknotf('Поздравляем с продажей транспортного средства')
    end
    if text:find("Вам пришло новое сообщение!") and not text:find("говорит") and not text:find('- |') then
        sampAddChatMessage("{fff000}Вам пришло новое {FFFFFF}SMS{fff000}-сообщение!", -1)
        addOneOffSound(0.0, 0.0, 0.0, 1055)
        printStringNow("~Y~SMS", 3000)
        return false
    end
    if text:find('говорит:') then
            local idd = text:match('%d+')
        local colorr = sampGetPlayerColor(idd)
            sampAddChatMessage(text,colorr)
            return false 
    end
    if text:find('%[Альянс ') then
        return { 0x9c15c1ff, text }
    end
    if text:find('^Администратор (.+) ответил вам')  and mainini.afk.uvedomleniya then
        sendvknotf('(warning | chat) '..text)
    end
    if color == -10270721 and text:find('Администратор')  and mainini.afk.uvedomleniya then
        local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if res then 
            local mname = sampGetPlayerNickname(mid)
            if text:find(mname) then
                    sendvknotf(text)
            end 
        end
    end
    if color == -10270721 and text:find('Вы можете выйти из психиатрической больницы') and mainini.afk.uvedomleniya  then
            sendvknotf(text)
    end
    if text:find('Банковский чек')  and color == 1941201407 then 
       lua_thread.create(function()
        wait(10*1000)
        if mainini.functions.famkv then
        sampSendChat('/fam [notf.] Мужики и девахи, оплачивайте налоги за фам.квартиру! (/fammenu - семейная квартира)')
        end
        sampAddChatMessage('{ffffff}Не забывай оплачивать налоги за {ff4500}дома, бизнесы, фам.кв{ffffff}!', -1)      
        wait(600*1000)
        sampAddChatMessage('{ffffff}Не забывай оплачивать налоги за {ff4500}дома, бизнесы, фам.кв{ffffff}!', -1)    
        wait(1500*1000)
        sampAddChatMessage('{ffffff}Не забывай оплачивать налоги за {ff4500}дома, бизнесы, фам.кв{ffffff}!', -1)    
       end)
    end
    if text:find('Вы оплатили все налоги на сумму') and color == 1941201407 then
        lua_thread.create(function()
        wait(150)
        sampAddChatMessage('{ffffff}Но забыли оплатить налоги на {ff4500}фам.квартиру {800080}(/fpay)', 0xff0000)   
        end)
    end
    if text:find('Банковский чек') and color == 1941201407  and mainini.afk.uvedomleniya then
        vknotf.ispaydaystate = true
        vknotf.ispaydaytext = ''
    end
    if vknotf.ispaydaystate  and mainini.afk.uvedomleniya then
        if text:find('Депозит в банке') then 
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text 
        elseif text:find('Сумма к выплате') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text 
        elseif text:find('Текущая сумма в банке') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text
        elseif text:find('Текущая сумма на депозите') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n '..text
        elseif text:find('В данный момент у вас') then
            vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
            sendvknotf('\n Наличные: ' .. getPlayerMoney(PLAYER_HANDLE) ..vknotf.ispaydaytext..'\n <3 Не забывай оплачивать налоги за дома, бизнесы, фам.кв!')
            vknotf.ispaydaystate = false
            vknotf.ispaydaytext = ''
        end
    end
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)
    if isCharInAnyCar(PLAYER_PED) then
        lua_thread.create(function()
            if text:find("Необходимо вставить ключи в зажигание") and not text:find("говорит") and not text:find('- |') and notkey == true then
                sampSendChat("/key")
                wait(240)
                setVirtualKeyDown(vkeys.VK_N, true)
                wait(44)
                setVirtualKeyDown(vkeys.VK_N, false)
                notkey = false
            end
        end)
        if text:find(nick) and text:find ("заглушил") and text:find ("двигатель") and not text:find("говорит") and not text:find('- |')  then
            sampSendChat("/key")
        end
    end

    if text:find('У вас началась сильная ломка') or text:find('Вашему персонажу нужно принять') then return false end

    --- МУСОРКА А НЕ ЧАТ НА АРИЗОНЕ СУКА
    if text:match('^%s+$') then return false end

    if (text:find("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~") or text:find("Основные команды сервера:") or text:find("Пригласи друга и получи") or text:find("Наш сайт:"))  and color == -89368321 then return false end

    if (text:find("В нашем магазине ты можешь приобрести нужное количество игровых денег и потратить") or text:find("их на желаемый тобой") or text:find("имеют большие возможности") or text:find("имеют больше возможностей") or text:find("можно приобрести редкие") or text:find("которые выделят тебя из толпы")) and color == 1687547391 then return false end

    -- if text:find("вышел при попытке избежать ареста и был наказан") and color == -1104335361 then return false end

    if (text:find("начал работу новый инкассатор") or text:find('вы сможете получить деньги')) and color == -1800355329 then return false end

    if (text:find("News LS") or text:find("News LV") or text:find("News SF")) and color == 1941201407 then return false end

    -- if text:find('выехал матовоз') and color == -1800355329 then return false end

    if text:find('Открыв СУНДУК с подарками') and color == -89368321 then return false end

    if (text:find('На сервере есть инвентарь') or text:find('Вы можете задать вопрос в нашу') or text:find('Чтобы запустить браузер') or text:find('Чтобы включить радио в')) and text:find('Подсказка') then return false end

    if (text:find('Чтобы завести двигатель введите') or text:find('Чтобы включить радио используйте кнопку') or text:find('может присутствует радио') or text:find('Для управления поворотниками используйте') or text:find('В транспорте присутствует радио')) and text:find('Подсказка') then return false end

    if text:find('Состояние вашего авто крайне') and text:find('Информация') and not text:find('говорит') and not text:find('- |') then return false end
    if text:find('Необходимо заехать на станцию') and text:find('Используйте /gps') and not text:find('говорит') and not text:find('- |') then return false end
    if text:find('Состояние вашего авто') and text:find('Подсказка') and not text:find('говорит') and not text:find('- |') and color == -10270721 then return false end
    if text:find('Обратитесь на станцию') and not text:find('говорит') and not text:find('- |') and color == -1 then return false end

    if (text:find('Уважаемые жители штата') or text:find('В данный момент проходит собеседование') or text:find('Для Вступления необходимо прибыть')) and color == 73381119 then return false end

    if (text:find("Справочная центрального банка") or text:find("Механик") or text:find("Проверить баланс") or text:find("Скорая помощь")  or text:find("Такси") or text:find("Полицейский участок")  or text:find("Служба точного времени") or text:find("Номера телефонов государственных служб:")) or text:find("Служба по вопросам жилой недвижимости")  and not text:find('говорит') and not text:find('- |') and color == -1 then return false end
    if text:find("Номера телефонов государственных служб") and not text:find('говорит') and not text:find('- |')  and color == 1687547391 then return false end
    if text:find('домами могут бесплатно раз в день получать') and text:find('Подсказка') and color == -1347440641 then return false end
    --[[           if text:find('Вам был добавлен предмет') and text:find('Ингредиенты') and color == -65281 then return false end

    if (text:find('Либерти Сити') or text:find('отправляйтесь на его разгрузку') or text:find('об контрабанде')) and text:find('Внимание') and color == -1104335361 then return false end
    ]]
    --[[           if (text:find('Ограбление изъятых патронов и наркотиков завершено') or text:find('Если вам удалось что-то украсть') or text:find('Внимание!') or text:find('Через 10 минут состоится выгрузка изъятых патронов и наркотиков') or text:find('чтобы украсть как можно больше ящиков в порту и пополнить ими общак') or text:find('Берите фургон и направляйтесь в порт') or text:find('Берите фургон и направляйтесь в порт') or text:find('вся Армия штата сосредоточена на том')) and color == -10270721 then return false end
    if (text:find('Если вам удалось что-то украсть') or text:find('доставьте это в общак')) and color == -10270721 then return false end
    if (text:find('чтобы не дать бандитам украсть и пополнить свой общак патронами пии наркотиками') or text:find('Берите технику и направляйтесь в порт для защиты груза')) and color == -10270721 then return false end
    if (text:find('В порт уже доставили изъятые патроны и наркотики с соседнего штата') or text:find('Успейте украсть как можно больше, пока их не украли другие')) and color == -10270721 then return false end
    ]]
    --  if (text:find('арендатор концертного зала:') and text:find('проводит мероприятие') and text:find('Развлечения')) and color == 1687547391 then return false end

    if text:find("Гос.Новости:") and color == 73381119 then return false end

    -- if text:find('Мероприятие') and text:find('Зловещий дворец') and color ==  -1178486529 then return false end

    if (text:find('Гость') or text:find('Репортёр')) and color == -1697828097 then return false end

    --if text:find('За дверью') and text:find('говорит:') and color == -1077886209 then return false end

    if text:find('С помощью телефона можно заказать такси') and text:find('Подсказка') and color == -170229249 then return false end

    -----------------------------------------------------ajksdhfjsdjkfhsdjkfhsdjkf
    if not finished then
        if text:find("^%[Ошибка%].*После последнего сообщения в этом чате нужно подождать") then
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
    if text:find("^Вы заглушены") or text:find("Для возможности повторной отправки сообщения в этот чат") then
        finished = true
    end
    if text:find ('Вы заглушены. Оставшееся время') then
        sukazaebalmutit = text:match('%d+')
        hvatitmutitbliat = sukazaebalmutit/60
        sampAddChatMessage('Вы заглушены. Оставшееся время ' .. math.floor(hvatitmutitbliat) .. ' минут(ы) = '..sukazaebalmutit.. ' секунд(ы).', -1347440641)
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
            local ad, tel = text:match('^Объявление:%s(.+)%.%sОтправил:%s[A-z0-9_]+%[%d+%]%sТел%.%s(%d+)')
            if ad ~= nil then
                local outstring = string.format('AD: {73B461}%s {D5A457}| Тел: %s', ad, tel)
                return { 0xD5A457FF, outstring }
            elseif text:find('Отредактировал сотрудник') then
                return false
            end
        end                
        if color == -1 then
            local ad, tel = text:match('^{%x+}%[VIP%]%sОбъявление:%s(.+)%.%sОтправил:%s[A-z0-9_]+%[%d+%]%sТел%.%s(%d+)')
            if ad ~= nil then
                local outstring = string.format('VIP AD: {73B461}%s {D5A457}| Тел: %s', ad, tel)
                return { 0xD5A457FF, outstring }
            elseif text:find('Отредактировал сотрудник') then
                return false
            end
        end

        if text:find('Администратор') or text:find('Куратор') or text:find('BOT') then
            if color == -10270721 then -- действия FF6347FF
                return { 0xb22222ff, text }
            elseif color == -2686721 then -- /ao FFD700FF
                return { 0x38fcffff, text }
            end
        end
        if text:find("вышел при попытке избежать ареста и был наказан") and color == -1104335361 then 
            return { 0x6f6d6fff, text }
        end
        if text:find('%[Адвокат%] ') then
            if mainini.functions.offrabchat then
                return false
            else
                local advtext = text:match('%[Адвокат%] (.+)')
                --sampAddChatMessage("{ffffff} Адвокат "..advtext, 0x5F9EA0)
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
    if text:find('%[Адвокат%] ') and mainini.functions.offrabchat then
        return false
    end
    if text:find("Отредактировал сотрудник СМИ") and color == 1941201407 then return false end
    if text:find("Отредактировал сотрудник СМИ") and not text:find('говорит:') then return false end

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
function isKeyCheckAvailable() -- Проверка на доступность клавиши
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
end --end of functionэ
--functions can be declared at any part of code unlike it usually works in lua
function del(n) --this function simly delete textdeaw with a number that we give with command
    sampTextdrawDelete(n)
end
function show() --this function sets toggle param from false to true and vise versa
    toggle = not toggle
end

function setTime(time)
	local time = tonumber(time)
	if time < 0 or time > 23 then sampAddChatMessage("Правильный ввод: {F7E937}//t [0-23]", -1) else
		
		if mainini.stsw.Static then
            sampAddChatMessage("Время установлено на {F7E937}"..time, -1)
			mainini.stsw.Time = time
			inicfg.save(mainini, "bd.ini")
		--else memory.write(0xB70153, time, 1, false)
		end
	end
end
function setWeather(weather)
	local weather = tonumber(weather)
	if weather < 0 or weather > 45 then sampAddChatMessage("Правильный ввод: {F7E937}//w [0-45]", -1) else
			
		if mainini.stsw.Static then
            sampAddChatMessage("Погода установлена на {F7E937}"..weather, -1)
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
                    afk_menu()
                end
                if list == 6 then
                    chatlog_menu()
                end
                if list == 7 then
                    piss_menu()
                end
                if list == 8 then
                    eda_menu()
                end
                if list == 9 then
                    mainini.functions.famkv = not mainini.functions.famkv	
					inicfg.save(mainini, 'bd')
					menu()
                end
                if list == 10 then
					mainini.functions.arecc = not mainini.functions.arecc	
					inicfg.save(mainini, 'bd')
					menu()
				end
                if list == 11 then
                    sampShowDialog(3905, "{00CC00}Список клавиш | Справка", buttonslist, "Закрыть", _, 2)
                end
                if list == 12 then 
                    drugoenosoft_menu()
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
                    sampShowDialog(49169, '{fff000}Настройки', string.format([[
{ffffff}Введите команду, с помощью которой возможно принимать продукты.
Например: /jmeat, /chips и т.д.
Текущая команда: {20B2AA}%s]], 
                        mainini.autoeda.comeda), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(41691, '{fff000}Настройки', string.format([[
{ffffff}Для отображения ника игрока нужно ввести знак процента и букву s
Текущий текст обоссывалки:
{20B2AA}%s]], 
                        mainini.oboss.pisstext), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 5 then
                    sampShowDialog(44169, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
                        mainini.oboss.obossactiv), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 6 then
                    sampShowDialog(43169, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
                        mainini.oboss.animactiv), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 7 then
                    sampShowDialog(42169, '{fff000}Настройки', string.format([[
{ffffff}Напишите в поле ниже название кнопки для активации
Текущая активация: {00ffff}%s]], 
                        mainini.oboss.pissactiv), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27871, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.flood.flwait1), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 2 then
                    sampShowDialog(27872, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.flood.fltext1), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27873, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.flood.flwait2), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 5 then
                    sampShowDialog(27874, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.flood.fltext2), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27875, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.flood.flwait3), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 8 then
                    sampShowDialog(27876, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.flood.fltext3), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27885, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.flood.flwait4), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 11 then
                    sampShowDialog(27886, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.flood.fltext4), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27895, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.flood.flwait5), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 14 then
                    sampShowDialog(27896, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.flood.fltext5), 
                        'Сохранить', 'Закрыть', 1)
                end
			end

            local result, button, list, _ = sampHasDialogRespond(21383)
			if result and button == 1 then
                if list == 0 then
					mainini.functions.bott = not mainini.functions.bott	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 1 then
					mainini.functions.sl = not mainini.functions.sl	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 2 then
					debugMode = not debugMode
					soft_menu()
				end
                if list == 3 then
                    mainini.functions.extra = not mainini.functions.extra	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 4 then
                    mainini.functions.autoc = not mainini.functions.autoc	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 5 then
					edit_autoc()
				end
                if list == 6 then
                    mainini.functions.dhits = not mainini.functions.dhits	
					inicfg.save(mainini, 'bd')
					soft_menu()
				end
                if list == 7 then
					edit_dhits()
				end
                if list == 8 then
					edit_sbiv()
				end
                if list == 9 then
					edit_allsbiv()
				end
                if list == 10 then
					edit_suicide()
				end
                if list == 11 then
					wh_cops_pidors()
				end
                if list == 12 then
					edit_shook()
				end
                if list == 13 then
					edit_tramp()
				end
                if list == 14 then
					drugoesoft_menu()
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
                    sampShowDialog(27411, '{fff000}Настройки', string.format([[
{ffffff}Напишите название вашей банды
Текущие название: {F08080}%s]], 
                        mainini.lidzamband.band), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 1 then
                    sampShowDialog(21411, '{fff000}Настройки', string.format([[
{ffffff}Напишите c какого игрового уровня допустимо принимать вв банду
Текущий уровень: {F08080}%s lvl]], 
                        mainini.lidzamband.minlvl), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 2 then
                    sampShowDialog(22411, '{fff000}Настройки', string.format([[
{ffffff}Напишите на какой ранг принимать печенек в банду
Текущий ранг: {F08080}%s rank]], 
                        mainini.lidzamband.minrank), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(27418, '{fff000}Настройки', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.naborgwait), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 6 then
                    sampShowDialog(27417, '{fff000}Настройки', string.format([[
{ffffff}Введите текст для флуда о наборе
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.naborgtext), 
                        'Сохранить', 'Закрыть', 1)
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
                    sampShowDialog(2911, '{fff000}Настройки FL1', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait1), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 10 then
                    sampShowDialog(2811, '{fff000}Настройки FL1', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext1), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 11 then
                    sampShowDialog(2912, '{fff000}Настройки FL2', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait2), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 12 then
                    sampShowDialog(2812, '{fff000}Настройки FL2', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext2), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 13 then
                    sampShowDialog(2913, '{fff000}Настройки FL3', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait3), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 14 then
                    sampShowDialog(2813, '{fff000}Настройки FL3', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext3), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 15 then
                    sampShowDialog(2914, '{fff000}Настройки FL4', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait4), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 16 then
                    sampShowDialog(2814, '{fff000}Настройки FL4', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext4), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 17 then
                    sampShowDialog(2915, '{fff000}Настройки FL5', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait5), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 18 then
                    sampShowDialog(2815, '{fff000}Настройки FL5', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext5), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 19 then
                    sampShowDialog(2916, '{fff000}Настройки FL6', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait6), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 20 then
                    sampShowDialog(2816, '{fff000}Настройки FL6', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext6), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 21 then
                    sampShowDialog(2917, '{fff000}Настройки FL7', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait7), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 22 then
                    sampShowDialog(2817, '{fff000}Настройки FL7', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext7), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 23 then
                    sampShowDialog(2918, '{fff000}Настройки FL8', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait8), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 24 then
                    sampShowDialog(2818, '{fff000}Настройки FL8', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext8), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 25 then
                    sampShowDialog(2919, '{fff000}Настройки FL9', string.format([[
{ffffff}Напишите количество секунд для задержки
Текущая задержка: {F08080}%s сек.]], 
                        mainini.lidzamband.flwait9), 
                        'Сохранить', 'Закрыть', 1)
                end
                if list == 26 then
                    sampShowDialog(2819, '{fff000}Настройки FL9', string.format([[
{ffffff}Введите текст для флуда
Текущий текст:
{20B2AA}%s]], 
                        mainini.lidzamband.fltext9), 
                        'Сохранить', 'Закрыть', 1)
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
                sendvknotf('Тестовое сообщение')
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