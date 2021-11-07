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
local oboss = false
local poss = false

local captureon = false


local fixbike = false

local fontvip = renderCreateFont("Arial", 10, 9)

local activeextra = false

update_state = false
 
local script_vers = 2
local script_vers_text = "1.01"

local update_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "\\config\\update.ini" -- и тут свою ссылку

local script_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/binder.lua" -- тут свою ссылку
local script_path = thisScript().path

--[[ local salosalo = false

local missRatio = 25
local silentMaxDist = 70
local silentFov = 0
local silentShootWalls = false ]]

textures = {
	['cs_rockdetail2'] = 1,  -- камень
	['ab_flakeywall'] = 2,   -- металл
	['metalic128'] = 3,      -- серебро
	['Strip_Gold'] = 4,	     -- бронза
	['gold128'] = 5          -- золото
}

resNames = {{'Камень', 0xFFFFFFFF}, {'Металл', 0xFF808080}, {'Серебро', 0xFF00BFFF}, {'Бронза', 0xFF654321}, {'Золото', 0xFFFFFF00}}

resources = {}

musorasosat = false

sound = false
sound1 = false

musora = false
obideli = false


local fontALT = renderCreateFont("Tahoma", 14, 0x4)

local fontVR = renderCreateFont("Arial", 10, 9)




buttonslist = [[
            LBUTTON - Левая кнопка мыши
	RBUTTON - Правая кнопка мыши
	MBUTTON - Колесо мыши (нажатие)
	XBUTTON1 - Доп.кнопка мыши №1
	XBUTTON2 - Доп.кнопка мыши №2

	BACK - 'Backspace'
	TAB - 'Tab'
	RETURN - 'Enter'

	CAPITAL - 'Caps Lock'
	ESCAPE - 'Esc'
	SPACE - 'Space'
	PRIOR - 'Page Up'
	NEXT - 'Page Down'
	END - 'End'
	HOME - 'Home'

	LEFT - 'Arrow Left'
	UP - 'Arrow Up'
	RIGHT - 'Arrow Right'
	DOWN - 'Arrow Down'

	PRINT - 'Print'
	INSERT - 'Insert'
	DELETE - 'Delete'


	0 - '0'
	1 - '1'
	2 - '2'
	3 - '3'
	4 - '4'
	5 - '5'
	6 - '6'
	7 - '7'
	8 - '8'
	9 - '9'


	A - 'A'
	B - 'B'
	C - 'C'
	D - 'D'
	E - 'E'
	F - 'F'
	G - 'G'
	H - 'H'
	I - 'I'
	J - 'J'
	K - 'K'
	L - 'L'
	M - 'M'
	N - 'N'
	O - 'O'
	P - 'P'
	Q - 'Q'
	R - 'R'
	S - 'S'
	T - 'T'
	U - 'U'
	V - 'V'
	W - 'W'
	X - 'X'
	Y - 'Y'
	Z - 'Z'


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
        user_id="122337026",
        bankpin="123456"
    },
    functions = {
        dotmoney=true,
        dhits=false,
        extra=false,
        bott=false,
        autoc=false,
        hphud=true,
        chatvipka=false,
        colorchat=false,
        offrabchat=false,
        offfrachat=false,
        devyatka=false
    },
    config = {
        allsbiv="0",
        sbiv="Z",
        suicide="F10",
        wh="MBUTTON"
    },
    flood = {
        fltext3="/j ываываыва",
        flwait2="180",
        flwait1="180",
        flwait3="15",
        fltext1="/vr Набор активных гетто-игроков в закрытую full семью nuestra. 18+, 60+fps fullHD. vk: @blessave",
        fltext2="/vr Куплю MAZDA RX7. Куплю объекты для дома 'Мишени (1 или 2)'. Звоните или vk: @blessave"
    }
}, 'bd')
inicfg.save(mainini, 'bd.ini')



--local mainini = inicfg.load(nil, "settings")
--local maintxt = inicfg.load(nil, "pidorasi.txt")
   -- inicfg.save(mainini, 'moonloader\\config.ini') 
----------------------------------------------------------------------------------------------------------------------------------------------------------
local supsettings = "\nНастроить конфиг bd.ini скрипта можно командами: \nЦифровой айди VK: /userid (айди). Нынешний айди: "..mainini.helper.user_id.." \nПароль для авто-ввода: /auto_pass (Пароль). Нынешний пароль: "..mainini.helper.password.." \nБанковский пин-код для авто-ввода: /auto_pin (пин). Нынешний пин-код: "..mainini.helper.bankpin.."\n\nВключить/Выключить раздельный VIP-chat: /chatvip \nВключить/Выключить разделение точками деньги: /dotmoney \nВключить/Выключить HP-HUD: /hphud \nВключить/Выключить Авто-Шот: /ashot \nВключить/Выключить Авто-+C: /autoc \nВключить/Выключить Авто-даблхиты: /dhits \nВключить/Выключить Экстра WS: /extra \n\nНастройка активации по клавишам. Весь список клавиш /buttons: \nWallHack: /whb (название кнопки). Сейчас: "..mainini.config.wh.." \nСбив всего: /allsbiv (название кнопки). Сейчас: "..mainini.config.allsbiv.." \nПростой сбив: /sbiv (название кнопки). Сейчас: "..mainini.config.sbiv.." \nCуицид: /suicide (название кнопки). Сейчас: "..mainini.config.suicide
local supsettings2 = [[

В биндере скрипта \\moonloader\\config\\binds.bind настройка следующая:
Чтобы добавить биндер нужно в конце строки поставить запятую перед закрывающей квадратной скобкой и вписать:
{"text":"МАТЬ ЕБАЛ[enter]","v":[82]}
Здесь: текст бинда это МАТЬ ЕБАЛ ([enter] - нажмимает интер, если не писать то биндер просто введется в чате), 82 - это ID клавиши. В данном случае клавиша R.

Чтобы добавить биндер на команду нужно ввести обратный слэш "\" перед самой командой:
{"text":"\/mask[enter]","v":[82]}

]]

local supfunctions = [[
    0. Как настроить скрипт - /blessave
    1. Биндер, который настраивается в binds.bind
    2. Пиар-флудилка - /flood
    3. Рендер многого чего c авто-альтом - /rend
    4. Самый пиздатый анти-афк с VK с возможностью говорить по телефону /phone
    5. Доставание оружия командами - /de /m4 /rf /sg /mp5 /pst /ak
    6. Легальный мод для фрапса - SHIFT + F2
    7. Пробив всего себя для фрапса - /probiv
    8. Лучший WallHack с рендером мусоров и пидорасов.
    9. Серверный список пидорасов /pidors, /addpidor, /delpidor
    10. Удобное пользование майнинг фермой
    11. Собственный чат-лог с поиском - /ch
    12. Анти-столбы при врезании в трапспорте - зажать SHIFT
    13. Зажимной GM-car - зажать SHIFT
    14. Авто-баги игры: быстро бегать/плавать - зажать 1, ездить на велике/мото - зажать SHIFT, высокий прыжок на велике - C
    15. Авто-обновление скрипта по команде - /updatebinder
    16. Сокращенные команды: /members - /mb, /findihouse - /fh, /findibiz - /fbiz, /fam - /k 
    17. Очистка памяти зоны стрима - /cln
    18. Удобное открытие меню дома /home - ALT в доме
    19. Удаление всякого ебаного мусора из чата
    20. Цветной текст в чате, кто говорит
    21. Цвета в чате по мнению разработчика
    22. Цвет чата альянса
    23. Авто-/key
    24. Анти-ломка
    25. Калькулятор - /calc
    26. Разделение суммы запятыми
    27. Авто+С. Клацать доп.кнопку мыши 2
    28. Авто-дабл-хиты. Клацать букву Е
    29. Экстра ВС. SHIFT+9
    30. Авто-шот. если вкл /ashot то срабатывает при наводке на скин, можно отключить ALT + V
    31. Отключить рабочий чат - /rabchat
    32. Отдельный вип-чат - /chatvip
    33. Суицид
    34. Сбивы анимаций
    35. ХП-худ в цифрах
    36. Отправка различных уведомлений в VK
    37. Помощник для заместителей/лидеров банд - /9
    38. Пиздатая обоссывалка в двух режимах /anim 85 и /piss - ПКМ на игрока + Q (/anim 85 - 1, /piss - 2)
    39. Реконнект - /hrec
    40. Авто-реконнект
    41. Выключить скрипт - SHIFT+F5
    42. Авто-оплата налогов семейной квартиры - /fpay
    43. Авто-оплата налогов на трейлер - /trpay
    44. Авто-флудилка в чат /vr
    45. Авто-прокрутка сундуков с рулетками - /rlt + фикс инвентаря в случае бага
    46. Авто-нитро - ЛКМ в машине
    47. Спидхак маленький - ПКМ в машине
    48. Трамплин - 7 в машине
    49. Бесконечный бег
    50. Зажимное анти-падение с велосипеда/мото - зажать SHIFT. Исключение: в воде всегда не работает
    51. Кам-хак
    52. Авто-ввод пароля
    53. Авто-ввод пин-кода в банке
    54. Поесть в доме с холодильника - /eathome
    55. Авто-еда мясо оленя
    56. Авто-ТвинТурбо
    57. Перевод секунды в минуты при /jail
    58. Перевод секунды в минуты при /mute
    59. Цвета авто всех банд - /gcolors
    60. Узнать цвет авто по иду из /dl - /getcolor
    61. Список всех кнопок - /buttons
    62. Очистка чата - /cchat
    63. Авто-закуп патрон у Гурамма - /ptguram
    64. Умные и красивые /sms
    65. Уведомления об оплате налогов, чтоб не забыть
    66. Разделение цен авто на АвтоБазаре
    67. Авто-сборка шара, велика, дельтаплана
    68. Отключить фракционный чат - /frachat
]]
local maintxt = inicfg.load({
    pidors = {    },
}, 'pidorasi')
--if not doesFileExist('moonloader/config/pidorasi.ini') then inicfg.save(maintxt, 'pidorasi.ini') end
------------------------------------------------------------------------------------------------------------------------------------------------------------
local fontt = renderCreateFont('Arial', 10, 9)
local fo0nt = renderCreateFont('Tahoma', 9, 5)

local sukazaebalmutit = 0

bike = {[481] = true, [509] = true, [510] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true, [3196] = true}

local fam = {'Family', 'Empire', 'Squad', 'Dynasty', 'Corporation', 'Crew', 'Brotherhood'}


notkey = false
local locked = false

floodon1 = false
floodon2 = false
floodon3 = false



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
							if pl.button == 'supfunc' then 
								--getPlayerArzStats()
                                sendvknotf(supfunctions)
							elseif pl.button == 'getinfo' then
								getPlayerInfo()
                            elseif pl.button == 'supsett' then
                                poddVK()
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
--[[ 					local objsend = tblfromstr(v.object.text)
					if objsend[1] == '!getplstats' then
						getPlayerArzStats()
					elseif objsend[1] == '!recon' then
                        sendvknotf('Переподключаемся на сервер!')
                        reconnect()
					elseif objsend[1] == '!gethun' then
						getPlayerArzHun()
					elseif objsend[1] == '!' then
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampProcessChatInput(args)
							sendvknotf('Сообщение "' .. args .. '" отправлено')
						else
							sendvknotf('Неправильный аргумент! Пример: ! [text]')
						end
                    elseif objsend[1] == '.' then
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampProcessChatInput(args)
						else
							sendvknotf('Неправильный аргумент! Пример: . [text]')
						end
					end ]]
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
	msg = ''..host..' | Online:' .. sampGetPlayerCount(false) ..'\n'..acc..' | Health: '.. getCharHealth(PLAYER_PED) ..'\n'..msg
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
	local row = keyboard.buttons[1]
    local row2 = keyboard.buttons[2]
	local row3 = keyboard.buttons[3]
    row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = 'Статус'
    row[2] = {}
	row[2].action = {}
	row[2].color = podderjk and 'secondary' or 'secondary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "supsett"}'
	row[2].action.label = podderjk and 'Настройки 2' or 'Настройки 1'
    row[3] = {}
	row[3].action = {}
	row[3].color = 'secondary'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "supfunc"}'
	row[3].action.label = 'Функционал'
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
sendstatsstate = false
function getPlayerArzStats()
	if isSampLoaded() and isSampAvailable() and sampIsLocalPlayerSpawned() then
	sendstatsstate = true
	sampSendChat('/stats')
	else
		sendvknotf('Ваш персонаж не заспавнен!')
	end
end
function getPlayerArzHun()
	if sampIsLocalPlayerSpawned() then
		gethunstate = true
		sampSendChat('/satiety')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if gethunstate ~= true then
				timesendrequest = 0
			end 
		end
		sendvknotf(gethunstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring(gethunstate))
		gethunstate = false
	else
		sendvknotf('(error) Персонаж не заспавнен')
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

--local bitkiSTATE = false
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
local zadervka = 1
local zadervka1 = 1
local zadervka2 = 1
local zadervka3 = 1 

local Counter = 0

local logging = false

local fix = false
local activrsdf = false

local miningtool = true
local automining_status = false
local automining_getbtc = 0
local automining_startall = 0
local automining_fillall = 0

local oxladtime = 224 -- Часы, на сколько хватит охлада

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
} -- Прибыль в час по лвл

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
--[[ else
	local fw = io.open(fpath, 'w+')
	if fw then fw:write():close() end 
--[[ 	local fr = io.open(fpath, 'r')
	if fr then defString = fr:read('*a') fr:close() end ]]
end


local icons = {
    markers = 0,
    cords = {
    }
}
 --[[   "Y":969.45849609375,"X":518.62060546875,"Z":-24.017101287842
        {"Y":924.79602050781,"X":508.57431030273,"Z":-28.802114486694},
        {"Y":896.86645507813,"X":488.56677246094,"Z":-30.675764083862},
        {"Y":959.25762939453,"X":528.65753173828,"Z":-22.163450241089},
        "Y":949.86871337891,"X":584.56866455078,"Z":-30.890481948853, 
        "Y":944.93212890625,"X":563.93872070313,"Z":-29.804889678955, 
        "Y":944.80871582031,"X":518.88824462891,"Z":-24.8971118927, 
        "Y":880.00518798828,"X":476.39981079102,"Z":-30.168491363525, 
        "Y":938.78778076172,"X":508.33227539063,"Z":-27.438257217407, 
        "Y":908.40637207031,"X":490.27337646484,"Z":-30.097179412842, 
        "Y":888.46685791016,"X":484.85659790039,"Z":-30.315467834473, 
        "Y":917.66320800781,"X":496.69097900391,"Z":-30.066947937012, 
        "Y":968.89794921875,"X":532.23193359375,"Z":-22.030118942261, 
        "Y":953.41711425781,"X":632.56195068359,"Z":-34.737201690674, 
        "Y":941.20916748047,"X":647.29693603516,"Z":-35.584941864014, 
        "Y":947.06243896484,"X":629.54083251953,"Z":-35.332775115967, 
        "Y":949.59338378906,"X":606.66931152344,"Z":-33.062973022461, 
        "Y":850.59051513672,"X":496.82528686523,"Z":-29.898014068604, 
        "Y":799.89123535156,"X":562.17401123047,"Z":-28.308031082153, 
        "Y":822.28552246094,"X":525.43640136719,"Z":-25.52254486084, 
        "Y":792.00616455078,"X":500.41354370117,"Z":-21.567844390869, 
        "Y":780.25555419922,"X":554.48327636719,"Z":-17.711265563965, 
        "Y":789.52264404297,"X":601.30999755859,"Z":-32.068206787109, 
        "Y":777.28668212891,"X":616.30914306641,"Z":-32.101264953613, 
        "Y":777.83294677734,"X":648.51092529297,"Z":-29.977233886719, 
        "Y":787.9345703125,"X":663.62817382813,"Z":-30.213798522949, 
        "Y":789.30163574219,"X":686.13287353516,"Z":-29.950016021729, 
        "Y":800.32189941406,"X":693.44476318359,"Z":-29.936937332153, 
        "Y":847.44659423828,"X":718.64086914063,"Z":-29.914356231689, 
        "Y":834.65539550781,"X":712.2099609375,"Z":-29.921224594116, 
        "Y":805.2001953125,"X":506.47015380859,"Z":-21.686738967896, 
        "Y":790.23608398438,"X":518.31451416016,"Z":-21.307481765747, 
        "Y":821.77642822266,"X":515.5546875,"Z":-24.337631225586, 
        "Y":790.98803710938,"X":584.28436279297,"Z":-29.943504333496, 
        "Y":818.3388671875,"X":716.27630615234,"Z":-30.253126144409, 
        "Y":955.14135742188,"X":644.61730957031,"Z":-34.354789733887, 
        "Y":866.25604248047,"X":494.16189575195,"Z":-31.324489593506, 
        "Y":870.33416748047,"X":470.46572875977,"Z":-28.64769744873, 
        "Y":937.03601074219,"X":662.13812255859,"Z":-37.777637481689, 
        "Y":808.60009765625,"X":518.22290039063,"Z":-23.172925949097, 
        "Y":941.28930664063,"X":618.97619628906,"Z":-37.38431930542, 
        "Y":769.96472167969,"X":565.70635986328,"Z":-16.364233016968 ]]
    
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
--[[ keyShow = VK_XBUTTON1
reduceZoom = true ]]


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

--[[ function rand() return math.random(-50, 50) / 100 end

function getDamage(weap)
	local damage = {
        [22] = 8.25,
        [23] = 13.2,
        [24] = 46.2,
        --[[ [25] = 3.3,
        [26] = 3.3,
        [27] = 4.95,
        [28] = 6.6,
        [29] = 8.25,
        [30] = 9.9,
        [31] = 9.9,
        [32] = 6.6, 
        [33] = 24.75,
        [34] = 41.25,
        [38] = 46.2 
	}
	return (damage[weap] or 0) + math.random(1e9)/1e15
end





function getpx()
	return ((wwe / 2) / getCameraFov()) * silentFov
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
			if getDistanceFromPed(ped) < silentMaxDist then
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

function getDistanceFromPed(ped)
	local ax, ay, az = getCharCoordinates(1)
	local bx, by, bz = getCharCoordinates(ped)
	return math.sqrt( (ax - bx) ^ 2 + (ay - by) ^ 2 + (az - bz) ^ 2 )
end

function canPedBeShot(ped)
	local ax, ay, az = convertScreenCoordsToWorld3D(xc, yc, 0)
	local bx, by, bz = getCharCoordinates(ped)
	return not select(1, processLineOfSight(ax, ay, az, bx, by, bz + 0.7, true, false, false, true, false, true, false, false))
end

function getcond(ped)
	if silentShootWalls then return true
	else return canPedBeShot(ped) end
end ]]
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

--pidoraso = false

local dialogTabArr = {}
local dialogTabStr = ""
local keyl = 'AAF0rwwhGQ1-qPZL1sCP7s6rqCL7uuajy54' -- ключ конечно лучше шифровать, а не оставлять прям в коде, но это чисто тебе подарок, если скрипт для друзей. Защита от левых челов.


function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end 
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
printStringNow("~B~Script ~Y~/blessave ~G~ON ~P~for "..nickker, 1500, 5)

workpaus(true)
lAA = lua_thread.create(lAA)
renderr = lua_thread.create(renderr)



downloadUrlToFile(update_url, update_path, function(id, status)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        updateini = inicfg.load(nil, update_path)
        if tonumber(updateini.info.vers) > script_vers then
            sampAddChatMessage("Есть обновление! Версия: " .. updateini.info.vers_text, -1)
            update_state = true
        end
        --os.remove(update_path)
    end
end)

if not doesFileExist("moonloader\\config\\waxta.json") then
    downloadUrlToFile("https://raw.githubusercontent.com/tedjblessave/binder/main/waxta.json", "moonloader\\config\\waxta.json", function(id, statuss, p1, p2)
        if statuss == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage("Загружен файл {c0c0c0}waxta.json {ffffff}для работы скрипта." , -1)
        end 
    end)
end

--[[ sampRegisterChatCommand('coords', function(coords)
local x, y, z = coords:match('(.+), (.+), (.+)')
local x, y, z = getCharCoordinates(PLAYER_PED)
    sampAddChatMessage('{ff4500}Координаты: {ffffff}X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z), -1)
end) ]]

--sampRegisterChatCommand('wsave', msave)

--sampRegisterChatCommand('wdelete', mdelete)
--sampRegisterChatCommand('wlist', mlist)

--sampRegisterChatCommand('wercv', runToPoint(518.62, 969.45))

--sampRegisterChatCommand("ch", chatut)
--sampRegisterChatCommand("log", function() logging = not logging end)



--sampRegisterChatCommand("buttons", function() sampShowDialog(1905, "{00CC00}Список клавиш | Справка", buttonslist, "ОК", _, 2) end)
--[[ sampRegisterChatCommand("st", cmdSetTime)
sampRegisterChatCommand("sw", cmdSetWeather) ]]

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


fastrun = lua_thread.create(fastrun)
hphud = lua_thread.create(hphud)

proops = lua_thread.create(proops)


rltao = lua_thread.create(rltao)
ifixx = lua_thread.create(ifixx)

camhack = lua_thread.create(camhack)

thr = lua_thread.create_suspended(thread_func)
thr2 = lua_thread.create_suspended(thread_func2)


lua_thread.create(musora_detector)
lua_thread.create(musora_handle)

--lua_thread.create(kopat_detector)

flymode = 0  
speed = 0.2
radarHud = 0
time = 0
keyPressed = 0



while true do
--[[         local pw, ph = getScreenResolution()
renderFontDrawText(fo0nt, string.format('{FF4500}%d{ffffff}/{008000}%d {ffffff}- {00FFFF}%d', mainini.stats.shots, mainini.stats.hits, mainini.stats.shots ~= 0 and 100 / (mainini.stats.shots / mainini.stats.hits) or 0)..'{ffffff}%', 0, ph - 50, 0xFFFFFFFF)
if 100 / (mainini.stats.shots / mainini.stats.hits) >= 0 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 5 then
renderFontDrawText(fo0nt, string.format('Zero'), 0, ph - 30,  0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 6 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 20 then
renderFontDrawText(fo0nt, string.format('Low'), 0, ph - 30, 0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 21 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 30 then
renderFontDrawText(fo0nt, string.format('Low+'), 0, ph - 30, 0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 31 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 50 then
renderFontDrawText(fo0nt, string.format('Medium'), 0, ph - 30, 0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 51 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 70 then
renderFontDrawText(fo0nt, string.format('Medium+'), 0, ph - 30, 0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 71 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 80 then
renderFontDrawText(fo0nt, string.format('HARD'), 0, ph - 30, 0xFFFFFFFF)
elseif 100 / (mainini.stats.shots / mainini.stats.hits) >= 81 and 100 / (mainini.stats.shots / mainini.stats.hits) <= 100 then
renderFontDrawText(fo0nt, string.format('VERY HARD'), 0, ph - 30, 0xFFFFFFFF)
end ]]

if autoaltrend then
    renderFontDrawText(fontALT, "{ffffff}Auto{ff0000}ALT", 1400, 600, 0xDD6622FF)
end



if onfp then
    lua_thread.create(function()
        for _,vv in pairs(maintxt.pidors) do
            local idpidra = sampGetPlayerIdByNickname(vv)
            if idpidra ~= nil and idpidra ~= -1 and idpidra ~= false then
                local resfp, handle = sampGetCharHandleBySampPlayerId(idpidra)
                if resfp then
                    screen_text = '~P~Пидорас ~W~'..vv..' ~R~('..idpidra..') ~Y~рядом!'
                    printStringNow(conv(screen_text),1)
                end
            end
        end
    end)
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
--[[ if timestsw then
    setTimeOfDay(timestsw, 0)
  end ]]
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

if isKeyDown(18) and isKeyJustPressed(86) and isKeyCheckAvailable() then trigbott = not trigbott end
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
            sampAddChatMessage('123', -1)
        else
            cameraRestorePatch(false)
            sampAddChatMessage('123456', -1)
            activeextra = false
        end
    end
    if isCharDead(playerPed) then cameraRestorePatch(false) sampAddChatMessage('sda123456', -1) activeextra = false end
end

--[[ if isKeyJustPressed(86) and isKeyCheckAvailable() and not isKeyDown(18) then salosalo = not salosalo end
if isKeyDown(18) and isKeyJustPressed(86) and isKeyCheckAvailable() then silentShootWalls = not silentShootWalls end 
		
if mainini.functions.salo then
    if salosalo and not silentShootWalls then 
        local clr = join_argb(0, 133, 17, 17)
        local r,g,b = 133, 17, 17
        writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
    elseif salosalo and silentShootWalls then
        local clr = join_argb(0, 0, 206, 209)
        local r,g,b = 0, 206, 209
        writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
    elseif not salosalo then
        local clr = join_argb(0, 128, 46, 46)
        local r,g,b = 128, 46, 46
        writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
    end
end ]]


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

--local menuhome = false
local texthome = sampTextdrawGetString(2054)
if texthome:match("House~g~ 20") or texthome:match("House~g~ 47") or texthome:match("House~g~ 46") or texthome:match("House~g~ 48") or texthome:match("House~g~ 57") then
    menuhome = true
end
if menuhome and not sampTextdrawIsExists(2054) then menuhome = false end

if sampTextdrawIsExists(2103) and not act then
-- addOneOffSound(0.0, 0.0, 0.0, 23000)
    local text = sampTextdrawGetString(2103)
    if text:find('Incoming') then
        local nick = text:gsub('(%s)(%w_%w)(.+)', '%2')
        sendvknotf('<3 Тебе звонит '..nick) -- output
    end
    act = true
end
if act and not sampTextdrawIsExists(2103) then act = false end



--[[     if isKeyDown(VK_9) then 
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
end ]]



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
        if isKeyJustPressed(81) and isKeyCheckAvailable() then 
            sampSendChat(string.format('/me обоссал жертву рваного дюрекса по кличке %s', nickk))
            poss = true
        end
        if mainini.functions.devyatka and isKeyJustPressed(219) and isKeyCheckAvailable() then
            sampSendChat(string.format("/todo Надень вот это на себя*кинув в руки %s бандану The Rifa номер 5", namee))
            wait(500)
            sampSendChat(string.format('/invite %s', name))
            wait(3000)
            sampSendChat(string.format('/giverank %s 5', name))
        end
        if mainini.functions.devyatka and isKeyJustPressed(221) and isKeyCheckAvailable() then
            sampSendChat(string.format("/todo Надень вот это на себя*кинув в руки %s бандану The Rifa номер 8", namee))
            wait(500)
            sampSendChat(string.format('/invite %s', name))
            wait(3000)
            sampSendChat(string.format('/giverank %s 8', name))
            -- принял ваше предложение вступить к вам в организацию

        end
        if mainini.functions.devyatka and isKeyJustPressed(187) and isKeyCheckAvailable() then
            sampSetChatInputText(string.format('/giveskin %s ', id))
            sampSetChatInputEnabled(true)
        end
        if mainini.functions.devyatka and isKeyJustPressed(189) and isKeyCheckAvailable() then
            sampSetChatInputText(string.format('/giverank %s ', id))
            sampSetChatInputEnabled(true)
        end
    end
end


if poss and isKeyJustPressed(50) and isKeyCheckAvailable() then 
    sampSetSpecialAction(68)
    poss = false
end
if poss and isKeyJustPressed(49) and isKeyCheckAvailable() then 
    sampSendChat('/anim 85')
    poss = false
end



if musorasosat then
    if sound then
        addOneOffSound(0.0, 0.0, 0.0, 1084)
        sound = false
    end
    if sound1 then
        addOneOffSound(0.0, 0.0, 0.0, 1085)
        sound1 = false
    end
end

doKeyCheck()

arec()

--[[ if mainini.functions.extra then
	if not isCharDead(playerPed) then cameraRestorePatch(true)
	else cameraRestorePatch(false) end end


 if isKeyDown(189) and isKeyJustPressed(187) and isKeyCheckAvailable() then
trigger = not trigger
if trigger then
mainini.functions.bott = true
--local clr = join_argb(0, 220, 20, 60)
local clr = join_argb(0, 0, 255, 255)
local r,g,b = 220, 20, 60
--writeMemory(health, 4, ("0xFF%06X"):format(clr), true)
--changeRadarColor(("0xFF%06X"):format(clr))
changeCrosshairColor(("0xFF%06X"):format(clr))
else
mainini.functions.bott = false
local clr1 = join_argb(0, 178, 34, 34)
local clr = join_argb(0, 255, 255, 255)
local r,g,b = 178, 34, 34
writeMemory(health, 4, ("0xFF%06X"):format(clr1), true)
--changeRadarColor(("0xFF%06X"):format(clr))
changeCrosshairColor(("0xFF%06X"):format(clr))
end
end ]]

--[[  if bott and not isCharOnAnyBike(playerPed) and not isCharDead(playerPed) then
local int = readMemory(0xB6F3B8, 4, 0)
int=int + 0x79C
local intS = readMemory(int, 4, 0)
if intS > 0
then
local lol = 0xB73458
lol=lol + 34
writeMemory(lol, 4, 255, 0)
wait(100)
local int = readMemory(0xB6F3B8, 4, 0)
int=int + 0x79C
writeMemory(int, 4, 0, 0)
end
end ]]





if isKeyJustPressed(78) and isCharInAnyCar(PLAYER_PED) then
    notkey = true
end


if isKeyDown(16) and isKeyJustPressed(116) and isKeyCheckAvailable() then
    --sampAddChatMessage("{ff4500}[ble$$ave] {4682B4}Скрипт {FF0000}ВЫКЛЮЧЕН. {ffffff}Автор: {800080}tedj",-1)
    printStringNow("~B~Script ~Y~/blessave ~R~OFF ~P~for "..nickker, 1500, 5)
    thisScript():unload() 
end
if isKeyDown(16) and isKeyJustPressed(113) and isKeyCheckAvailable() then
    captureon = not captureon
    if captureon then
        printStringNow("~P~LEGAL ~G~ON", 1500, 5)
        wh = false
        musorasosat = false
        sound = false
        sound1 = false
        onfp = false
        cameraRestorePatch(false)
        activeextra = false
        musora = false
        obideli = false
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

    else
        printStringNow("~P~LEGAL ~R~OFF", 1500, 5)
    end
end

--[[ if isKeyDown(16) and isKeyJustPressed(57) and isKeyCheckAvailable() then
    musorasosat = not musorasosat
    if musorasosat then 
        printStyledString("MUSORA SOSAT ~G~on", 3330, 5)
        --sampAddChatMessage('{ff4500}MUSORA SOSATb {228b22}on',-1)
        else
        --sampAddChatMessage('{ff4500}MUSORA SOSATb {ff0000}off',-1)
        printStyledString("MUSORA SOSAT ~R~off", 3330, 5)
        musoso = false
    end
end ]]
if isKeyCheckAvailable() and captureon then
    if isKeyDown(16) and isKeyJustPressed(_G['VK_'..mainini.config.allsbiv]) then  wait(100) clearCharTasksImmediately(PLAYER_PED) 
    end 
end

--[[ local _, myidanim = sampGetPlayerIdByCharHandle(playerPed)
local animka = sampGetPlayerAnimationId(myidanim)
if isPlayerPlaying(PLAYER_HANDLE) and animka == 1462 and isCharOnFoot(PLAYER_PED) and isKeyCheckAvailable() and not sampIsChatInputActive() then
    if isKeyJustPressed(VK_LSHIFT) then  taskPlayAnim(PLAYER_PED, "camcrch_stay", "CAMERA", 4.0, false, false, true, false, 1) end 
end ]]

if isPlayerPlaying(PLAYER_HANDLE) and isCharOnFoot(PLAYER_PED) and isKeyCheckAvailable() then
    if isKeyJustPressed(_G['VK_'..mainini.config.sbiv]) and not captureon then  taskPlayAnim(playerPed, "HANDSUP", "PED", 4.0, false, false, false, false, 4) 
    end 
end
if isKeyCheckAvailable() and not captureon then
    if isKeyJustPressed(_G['VK_'..mainini.config.allsbiv]) then  wait(100) clearCharTasksImmediately(PLAYER_PED) 
    end 
end
if isKeyJustPressed(_G['VK_'..mainini.config.suicide]) and not isPlayerDead(playerHandle) then setCharHealth(playerPed, 0) 
end
if  isKeyJustPressed(_G['VK_'..mainini.config.wh]) and isKeyCheckAvailable() and not captureon then
    musorasosat = not musorasosat
    onfp = not onfp
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

--[[ 
local menuPtr = 0x00BA6748
if isPlayerPlaying(playerHandle) then 
        if isKeyCheckAvailable()  and isKeyDown(keyShow) then
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
            while isKeyDown(keyShow) do
                wait(80)
            end
                writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
            end
        end
    end
end ]]


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
--[[ function LoadMarkers1()
    for k,v in pairs(icons1.cords1) do
        if type(v) ~= 'userdata' then mymark[#mymark+1] = addSpriteBlipForCoord(v.X, v.Y, v.Z, 25) end
    end
    sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: Loaded {FF0000}"..icons1.markers1.."{FFFFFF} icons!", -1)
end ]]

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
function sp.onPlayerJoin(playerId, color, isNpc, nickname)
	if logging then
        local nameN = string.gsub(nickname, "_", " ");
        if nameN == "Nuestra" then
        sampAddChatMessage(nickname.."("..playerId..") вошел в игру.", -1)
        --notf.addNotification(string.format("%s \nКакой-то хуй с фамилией Nuestra\n\n"..nickname.."("..playerId..") вошел в игру." , os.date()), 10)
	end
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

function musora_detector()
    --skins = Set { 175, 174, 102, 103, 104 }
    skins = Set { 265, 266, 267, 165, 166, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 303, 304, 305, 306, 307, 309, 310, 311, 163, 164 }
    while true do
    wait(200) 
    detected = false
    
    for k, v in pairs(getAllChars()) do
        if doesCharExist(v) then
            f = getCharModel(v)
            local resultgg, jopa = sampGetPlayerIdByCharHandle(v)
            local colorrrggg = sampGetPlayerColor(jopa) --368966908
            if skins[f] then
                

                if resultgg and musorasosat and (colorrrggg == 23486046 or colorrrggg == 2147502591)   then   -- 2573625087 and colorrrggg == 23486046 or colorrrggg == 2147502591
                    obideli = true
                    detected = true
                     local nameqqq = sampGetPlayerNickname(jopa)
       
        
                   printStyledString("~B~ "..nameqqq.." ~W~("..jopa..")", 1000, 5) --and colorrr ~= 36896690
                    
                end
                    break
                end
            end
        end
        if not detected then
            musora = false
            obideli = false
        end
    end
end


function musora_handle()
    while true do
    wait(0)
    if musora then
        sound = true
        while musora do wait(1000) end
        wait(2000)
    end
    if obideli then
        sound1 = true
        while obideli do wait(1000) end
        wait(2000)
    end
    end
end
  
function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

--[[ function kopat_detector()
    skins = Setk { 155 }
    --skins = Set { 265, 266, 267, 165, 166, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 303, 304, 305, 306, 307, 309, 310, 311, 163, 164 }
    while true do
    wait(200)
    detected = false
    
    for k, u in pairs(getAllChars()) do
        if doesCharExist(u) then
            fh = getCharModel(u)
            resultggk, jopak = sampGetPlayerIdByCharHandle(v)
            local colorrrggg = sampGetPlayerColor(jopa) --368966908
            if skins[fh] then
                

                if resultggk and kopathui and colorrrggg ~= 368966908  then   
                     nameqqqk = sampGetPlayerNickname(jopak)
       
                    kopatt = true
                    --printStyledString("~R~MUSOR:~B~ "..nameq.." "..colorrr, 333, 5) and colorrr ~= 368966908
                    --printStringNow("~R~MUSOR:~B~ "..nameqqq.." ~W~("..jopa..")", 333, 5)
--[[                     renderFontDrawText(Arial1g, '{ffffff}'..cidg..'.{7CFC00} '..nameq..' {00FFFF}('..jopa..') \n', 1500, renderYg, 0xDD6622FF)
                    renderYg = renderYg + 12
                    cidg = cidg + 1 
                    cidg = 1 
                    renderYg = 330
                    rendermusora = true
                    renderYg = renderYg + 12
                    cidg = cidg + 1

                end
                    break
                end
            end
        end
    end
end

  
function Setk (list)
    local setk = {}
    for _, lk in ipairs(list) do setk[lk] = true end
    return setk
end ]]


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
		if sKeys == tostring(table.concat(v.v, " ")) and isKeyCheckAvailable() then
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
        if mainini.functions.dotmoney then
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
    local chatstring = sampGetChatString(99)
    if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." or chatstring == "Сервер закрыл соединение." or chatstring == "Wrong server password." or chatstring == "Use /quit to exit or press ESC and select Quit Game" then
    sampDisconnectWithReason(false)
    wait(3000)
    printStringNow("~B~AUTORECONNECT", 3000)
        wait(100) -- задержка
        sampSetGamestate(1)
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




function dHits()
    while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
    if mainini.functions.dhits then
        if getCurrentCharWeapon(playerPed) == 24 then
    if isKeyJustPressed(69) and isKeyCheckAvailable() and isCharOnFoot(PLAYER_PED) then
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
            if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() and not isCharOnAnyBike(PLAYER_PED) then
                if isKeyJustPressed(56) and isKeyCheckAvailable() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then cruise = not cruise end
                if cruise then
                    local veh = storeCarCharIsInNoSave(PLAYER_PED)
                    setCarCruiseSpeed(veh, 60.0)
                    setGameKeyState(16, 255)
                end  
            end 
            if isCharInAnyCar(PLAYER_PED) and isKeyJustPressed(55) and isKeyCheckAvailable() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
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
            if getCurrentCharWeapon(playerPed) == 24 then
                if isKeyDown(2) and isKeyJustPressed(6) then
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
    if isCharOnFoot(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then -- onFoot&inWater SpeedUP [[1]] --
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
    sendvknotf('Весь чат '..(vklchat and 'включен!' or 'выключен!'))
end
function famchatVK()
    vklchatfam = not vklchatfam
    if vklchatfam then
        vknotf.chatf = true
    else
        vknotf.chatf = false
    end
    sendvknotf('Fam чат '..(vklchat and 'включен!' or 'выключен!'))
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
function poddVK()
    podderjk = not podderjk
    if podderjk then
        sendvknotf(supsettings)
    else
        sendvknotf(supsettings2)
    end
end

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
function ifixx()
    while true do wait(30*1000)
        if activrsdf then
            lua_thread.create(function() wait(0)
                fix = true
                sampSendChat("/donate")
                wait(3000)
                fix = false
            end)
        end
    end
end
function rltao()
	while true do wait(0)
        while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
        if checked_test then
            sampSendClickTextdraw(65535)
            wait(355)
            active = true
            sampSendChat("/invent")
            wait(zadervka*60000)
          end
          if checked_test2 then
            sampSendClickTextdraw(65535)
            wait(355)
            active1 = true
            sampSendChat("/invent")
            wait(zadervka1*60000)
          end
          if checked_test3 then
            sampSendClickTextdraw(65535)
            wait(355)
            active2 = true
            sampSendChat("/invent")
            wait(zadervka2*60000)
          end
          if checked_test4 then
            sampSendClickTextdraw(65535)
            wait(355)
            active3 = true
            sampSendChat("/invent")
            wait(zadervka3*60000)
          end
    end
end





--[[ function sp.onSendGiveDamage(playerId, damage, weapon, bodypart)
        mainini.stats.hits = mainini.stats.hits + 1
        inicfg.save(mainini, 'settings.ini')
end

function sp.onSendBulletSync(data)
        mainini.stats.shots = mainini.stats.shots + 1
        inicfg.save(mainini, 'settings.ini')
end ]]
--[[ function sp.onSendBulletSync(data)
    if mainini.functions.salo then
        math.randomseed(os.clock())
        if not salosalo then return end
        local weap = getCurrentCharWeapon(PLAYER_PED)
        if not getDamage(weap) then return end
        local id, ped = getClosestPlayerFromCrosshair()
        if id == -1 then return end
        if math.random(1, 100) < missRatio then return end
        if not getcond(ped) then return end
        data.targetType = 1
        local px, py, pz = getCharCoordinates(ped)
        data.targetId = id

        data.target = { x = px + rand(), y = py + rand(), z = pz + rand() }
        data.center = { x = rand(), y = rand(), z = rand() }

        lua_thread.create(function()
            wait(1)
            sampSendGiveDamage(id, getDamage(weap), weap, 3)
        end)
    end
end ]]


    
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
    function sp.onSendTakeDamage(playerId, damage, weapon, bodypart)
        local killer = ''
            if sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(playerPed))) - damage <= 0 and sampIsLocalPlayerSpawned() then
                if playerId > -1 and playerId < 1001 then
                    killer = '\nУбийца: '..sampGetPlayerNickname(playerId)..'['..playerId..']'
                end
                sendvknotf('Ваш персонаж умер'..killer)
        end
    end
    function sp.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
            sendvknotf('Вы подключились к серверу!', hostName)
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
    function onReceiveRpc(id,bitStream)
        if (id == RPC_CONNECTIONREJECTED) then
            goaurc()
        end
    end
    function goaurc()
        sendclosenotf('Потеряно соединение с сервером')
        ip, port = sampGetCurrentServerAddress()
        end
    function sendclosenotf(text)
        sendvknotf(text)
    end
---- aafk vksend



function sampGetListboxItemByText(text, plain)
    if not sampIsDialogActive() then return -1 end
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
	    if id == 15272 or id == 0 and title:find('Обзор всех видеокарт') or title:find('Выберите видеокарту') then
			local automining_btcoverall = 0
			local automining_btcoverallph = 0
			local automining_btcamountoverall = 0
			local automining_videocards = 0
			local automining_videocardswork = 0
			for line in text:gmatch("[^\n]+") do
                dtextm[#dtextm+1] = line 
            end
			
			if dtextm[1]:find('%(BTC%)') then
			    dtextm[1] = dtextm[1]:gsub('%(BTC%)', '%1 | До 9 BTC')
			end
			
			for d = 1, #dtextm do
				if dtextm[d]:find('Полка%s+№%d+%s+|%s+%{BEF781%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+%d+%p%d+%%') then	-- Статус, работает или нет
					automining_status = 1
					automining_statustext = '{BEF781}'
				else
					automining_status = 0
					automining_statustext = '{F78181}'
				end
				local automining_lvl = tonumber(dtextm[d]:match('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+(%d+)%s+уровень%s+%d+%p%d+%%')) -- Уровень видюхи
				local automining_fillstatus = tonumber(dtextm[d]:match('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%%')) -- Залито охлада в процентах
				local automining_btcamount = tonumber(dtextm[d]:match('Полка%s+№%d+%s+|%s+%{......%}%W+%s+(%d+%p%d+)%s+BTC%s+%d+%s+уровень%s+%d+%p%d+%%')) -- Число битков сейчас в видюхе              						
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
                    					
					automining_fillstatushours = math.ceil(oxladtime * (automining_fillstatus / 100)) -- На сколько часов охлада
					automining_fillstatusbtc = automining_fillstatushours * INFO[automining_lvl] -- Сколько видюха еще даст BTC
					automining_btcoverall = automining_btcoverall + automining_fillstatusbtc -- Подсчет сколько всего дадут все видюхи
					automining_btcamountoverall = automining_btcamountoverall + math.floor(automining_btcamount) -- Подсчет сколько доступно для снятия
					if automining_fillstatus > 0 and automining_status == 1 then
						automining_btcoverallph = automining_btcoverallph + INFO[automining_lvl]
					end
					dtextm[d] = dtextm[d]:gsub('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+'..automining_lvl..'%s+уровень', '%1 | '..automining_statustext..INFO[automining_lvl]..'/Час')
					if automining_fillstatus > 0 then
						dtextm[d] = dtextm[d]:gsub('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+|%s+%{......%}%d+%p%d+/Час%s+'..automining_fillstatus..'%A+', '%1 '..tostring(automining_status and '{BEF781}' or '{F78181}')..'- [~'..automining_fillstatushours..' Час(ов)] {FFFFFF}|{81DAF5} [~'..string.format("%.1f", automining_fillstatusbtc)..' BTC]')
					else
						dtextm[d] = dtextm[d]:gsub('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+|%s+%{......%}%d+%p%d+/Час%s+'..automining_fillstatus..'%A+', '%1 {F78181}(!)')
					end
					dtextm[d] = dtextm[d]:gsub('Полка%s+№%d+%s+|%s+%{......%}%W+%s+%d+%p%d+%s+BTC', '%1 '..tostring(automining_btcamountinfo and '{BEF781}•' or '{F78181}•')..' {ffffff}| '..automining_statustext..'~'..automining_btctimetofull..'ч')
				end				
			end
			
		if id == 15272 and title:find('Выберите видеокарту') then
            if worktread ~= nil then
                worktread:terminate()
            end			
		    local automining_fillstatus1 = tonumber(text:match('Полка №1 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%A'))
			local automining_fillstatus2 = tonumber(text:match('Полка №2 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%A'))
			local automining_fillstatus3 = tonumber(text:match('Полка №3 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%A'))
			local automining_fillstatus4 = tonumber(text:match('Полка №4 |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%A'))
			
			local automining_getbtcstatus1 = tonumber(text:match('Полка №1 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+уровень%s+%d+.'))
			local automining_getbtcstatus2 = tonumber(text:match('Полка №2 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+уровень%s+%d+.'))
			local automining_getbtcstatus3 = tonumber(text:match('Полка №3 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+уровень%s+%d+.'))
			local automining_getbtcstatus4 = tonumber(text:match('Полка №4 |%s+%{......%}%W+%s+(%d+)%p%d+%s+BTC%s+%d+%s+уровень%s+%d+.'))				
			
			for i = 1, 4 do
			    local automining_lvl = tonumber(text:match('Полка №'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+(%d+)%s+уровень%s+%d+.'))
				local automining_fillstatus = tonumber(text:match('Полка №'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+(%d+%p%d+)%A'))
			    if automining_fillstatus ~= nil then
					if automining_fillstatus > 0 and automining_lvl ~= nil then
						automining_fillstatushours =  math.ceil(224 * (automining_fillstatus / 100))
						text = text:gsub('Полка №'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень%s+%d+%p%d+%A', '%1 {BEF781}- [~'..automining_fillstatushours..' Час(ов)]')	
					end				
					if automining_lvl > 0 then
						text = text:gsub('Полка №'..i..' |%s+%{......%}%W+%s+%d+%p%d+%s+BTC%s+%d+%s+уровень', '%1 | '..INFO[automining_lvl]..'/Час')
					end
                end				
			end					
			
            if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				if automining_getbtc == 1 then
				    if automining_getbtcstatus1 ~= nil then
						if automining_getbtcstatus1 < 1 then
							automining_getbtc = 2
						elseif text:find('Полка №1 | Свободна') then
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
						elseif text:find('Полка №2 | Свободна') then
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
						elseif text:find('Полка №3 | Свободна') then
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
							sampAddChatMessage('[MineFarm] {FFFFFF}Собирать больше нечего.', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						elseif text:find('Полка №4 | Свободна') then
							automining_getbtc = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}Собирать больше нечего.', 0xFF6060)
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
				    if text:find('Полка №1 | {BEF781}Работает') then
						automining_startall = 2
					elseif text:find('Полка №1 | Свободна') then
					    automining_startall = 2
					end
				end
				if automining_startall == 2 then
				    if text:find('Полка №2 | {BEF781}Работает') then
				        automining_startall = 3
					elseif text:find('Полка №2 | Свободна') then
					    automining_startall = 3
					end
				end
				if automining_startall == 3 then
				    if text:find('Полка №3 | {BEF781}Работает') then
				        automining_startall = 4
					elseif text:find('Полка №3 | Свободна') then
					    automining_startall = 4
					end
				end
				if automining_startall == 4 then
				    if text:find('Полка №4 | {BEF781}Работает') then
				        automining_startall = 10
						sampAddChatMessage('[MineFarm] {FFFFFF}Запускать больше нечего (Все уже работает).', 0xFF6060)
					    worktread = lua_thread.create(PressAlt)
					elseif text:find('Полка №4 | Свободна') then
					    automining_startall = 10
					    sampAddChatMessage('[MineFarm] {FFFFFF}Запускать больше нечего.', 0xFF6060)
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
						elseif text:find('Полка №1 | Свободна') then
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
						elseif text:find('Полка №2 | Свободна') then
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
						elseif text:find('Полка №3 | Свободна') then
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
							sampAddChatMessage('[MineFarm] {FFFFFF}Заливать больше некуда (В видеокартах больше 50%, будут потери!).', 0xFF6060)
							worktread = lua_thread.create(PressAlt)
						elseif text:find('Полка №4 | Свободна') then
							automining_fillall = 10
							sampAddChatMessage('[MineFarm] {FFFFFF}Заливать больше некуда.', 0xFF6060)
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
		text = text .. '\n' .. '{ffff00}Информация\t{ffff00}Доступно снять\t{ffff00}Прибыль в час\t{ffff00}Прибыль прогнозируемая'
		text = text .. '\n' .. '{FFFFFF}Всего: '..automining_videocards..' | {BEF781}Работают '..automining_videocardswork..'\t{FFFFFF}'..string.format("%.0f", automining_btcamountoverall)..' BTC\t{BEF781}'..automining_btcoverallph..' {FFFFFF}BTC\t{81DAF5}'..string.format("%.1f", automining_btcoverall)..' {FFFFFF}BTC' 
			if title:find('Выберите видеокарту') then	
				if text:find('Полка №1 | Свободна') and text:find('Полка №2 | Свободна') and text:find('Полка №3 | Свободна') and text:find('Полка №4 | Свободна') then
					text = text .. '\n' .. ' '
					text = text .. '\n' .. '{FF6060}- Забрать всю прибыль (Полки пусты!)'
					text = text .. '\n' .. '{FF6060}- Запустить все видеокарты (Полки пусты!)'
					text = text .. '\n' .. '{FF6060}- Залить жидкость (Полки пусты!)'
				else
					text = text .. '\n' .. ' '
					text = text .. '\n' .. '{99FF99}- Забрать всю прибыль'
					text = text .. '\n' .. '{22FF00}- Запустить все видеокарты'
					text = text .. '\n' .. '{00FF55}- Залить жидкость (По 50%)'
				end
			end
		automining_btcoverall = 0
	    automining_btcoverallph = 0        		
		return {id, style, title, button1, button2, text}
		end
		
		if id == 15273 then	    
		    if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				if title:find('Стойка №%d+%s+| Полка №'..automining_getbtc..'') then	
					local automining_btcamount = tonumber(text:match('Забрать прибыль %((%d+).%d+ '))
					if automining_btcamount ~= 0 then
						sampSendDialogResponse(15273,1,1,nil) -- Да
					else
						automining_getbtc = automining_getbtc + 1
						sampSendDialogResponse(15273,0,nil,nil)
						if automining_getbtc == 5 then
							sampAddChatMessage('[MineFarm] {FFFFFF}Прибыль проверена и обналичена.', 0xFF6060)
							automining_getbtc = 10
						end
					end
				else
				    sampSendDialogResponse(15273,0,nil,nil)
					worktread = lua_thread.create(PressAlt)
				end
			end
			
		    if automining_startall == 1 or automining_startall == 2 or automining_startall == 3 or automining_startall == 4 then
				if text:find('Запустить видеокарту') and title:find('Стойка №%d+%s+| Полка №'..automining_startall..'') then
				    sampSendDialogResponse(15273,1,0,nil)
				    automining_startall = automining_startall + 1
				    sampSendDialogResponse(15273,0,nil,nil)
				else
				    sampSendDialogResponse(15273,0,nil,nil)
				end
				if automining_startall == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}Запуск завершен.', 0xFF6060)
					automining_startall = 10
				end
			end

		    if automining_fillall == 1 or automining_fillall == 2 or automining_fillall == 3 or automining_fillall == 4 then
				if title:find('Стойка №%d+%s+| Полка №'..automining_fillall..'') then
				    sampSendDialogResponse(15273,1,2,nil)
				    automining_fillall = automining_fillall + 1
				    worktread = lua_thread.create(PressAlt)
				else
				    worktread = lua_thread.create(PressAlt)
				end
				if automining_filltall == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}Успешно залито по 50% жидкости.', 0xFF6060)
					sampSendDialogResponse(15273,0,nil,nil)
					automining_startall = 10
					worktread = lua_thread.create(PressAlt)
				end
			end
	    end
		
	    if id == 15274 and title:find('Вывод прибыли видеокарты') then
     		if automining_getbtc == 1 or automining_getbtc == 2 or automining_getbtc == 3 or automining_getbtc == 4 then
				automining_getbtc = automining_getbtc + 1
				sampSendDialogResponse(15274,1,nil,nil) -- Да
				worktread = lua_thread.create(PressAlt)
				if automining_getbtc == 5 then
					sampAddChatMessage('[MineFarm] {FFFFFF}Прибыль проверена и обналичена.', 0xFF6060)
					automining_getbtc = 10
				end
				return false
			end
	    end			
	end

    if fix and text:find("Курс пополнения счета") then
		sampSendDialogResponse(id, 0, 0, "")
		sampAddChatMessage("{ffffff} inventory {ff0000}fixed{ffffff}!",-1)
        
    --notf.addNotification(string.format("%s \ninventory fixed!" , os.date()), 10)
		return false
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
            sampSendDialogResponse(162,1,nil,nil)
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

	if gethunstate and id == 0 and text:find('Ваша сытость') then
		sampSendDialogResponse(id,0,0,'')
		gethunstate = text
		return false
	end
    if sendstatsstate and id == 235 then
        sendvknotf(text)
        sendstatsstate = false
        return false
    end
    if bizii and id == 9761 then
        sendvknotf0(text)
        bizii = false
        return false
    end
    if id == 8928 then
        sendvknotf(text)
       -- return false
    end
    if id == 7782 then
        sendvknotf(text)
       -- return false
    end
    if id == 1333 then
        sendvknotf(text)
        setVirtualKeyDown(13, false)
    end
    if id == 1332 then
        setVirtualKeyDown(13, false)
    end
    if text:find('Вы получили бан аккаунта') then
        if banscreen.v then
            createscreen:run()
        end

        local svk = text:gsub('\n','') 
        svk = svk:gsub('\t','') 
        sendvknotf('(warning | dialog) '..svk)
    end
    
        if text:find('Администратор (.+) ответил вам') then
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
		sampAddChatMessage('[MineFarm] {FFFFFF}Забираем прибыль... Не открывайте другие диалоги во время этого!', 0xFF6060)
	end
	if DialogId == 15272 and DialogList == 9 and DialogButton == 1 then
	    automining_startall = 1
        worktread = lua_thread.create(PressAlt)
		sampAddChatMessage('[MineFarm] {FFFFFF}Запускаем все видеокарты... Не открывайте другие диалоги во время этого!', 0xFF6060)
	end
	if DialogId == 15272 and DialogList == 10 and DialogButton == 1 then
	    automining_fillall = 1
        worktread = lua_thread.create(PressAlt)
		sampAddChatMessage('[MineFarm] {FFFFFF}Заливаем жидкость (По 50%)... Не открывайте другие диалоги во время этого!', 0xFF6060)
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
---- автоеда, автосек в дмг, авто ТТ
function sp.onDisplayGameText(style, time, text)
    if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
        local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
        return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
    end
    if text:find("%-400%$") then
        return false
    end
    if text:find("~w~Style: ~g~Comfort") then
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
        sampSendChat("/jmeat")
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
--[[ 	if text:find ('stone %+ (%d+)') then
		stone1=text:match('stone %+ (%d+)')
		stone = stone+tonumber(stone1)
		
	end
	if text:find ('metal %+ (%d+)') then
		metal1=text:match('metal %+ (%d+)')
		metal = metal+tonumber(metal1)
	end	 ]]
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
              --[[ if bitkiSTATE then
                for id = 0, 2048 do
                    if sampIs3dTextDefined(id) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                        if text:find("Операции с криптовалютой") and text:find("Сейчас в банке: %d+ BTC") and text:find("Банк продаёт 1 BTC за $45(.+)")  then
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
                                --distance = string.format("%.0f", getDistanceBetweenCoords3d(posX,posY,posZ, x2, y2, z2))
                                --renderDrawLine(p1, p2, p3, p4, 2, 0xDD6622FF)
                                --renderDrawPolygon(p1, p2, 10, 10, 7, 0, 0xDD6622FF)
                                --text = string.format("{8B4513}Лён {00ff00}"..distance)
                                wposX = p1 + 5
                                wposY = p2 - 7
                                --renderFontDrawText(Arial, text, wposX, wposY, 0xDD6622FF)
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

                renderFontDrawText(Arial, '{00FFFF}Рeсурсы: {ffffff}'..Counter, 1100, 600, 0xDD6622FF)
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
                                
                                --setMarker1(1, posX, posY, posZ, 10, 0xFFFFFFFF)
                            end
                        end
                    end
                end
                renderFontDrawText(Arial, '{EE82EE}Закладок:{ffffff} '..Counter, 1200, 600, 0xDD6622FF)
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
    ------    Anti-AFK с большим функционалом. Для работы нужно ввести цифровой ID VK в settings.ini. Написать сообщение в группе https://vk.com/tedj69.
    --Команда /afktest отправит вам тестовое сообщение.
    if cmd:find('/rlt') then
        rlton = not rlton
        if rlton then
            sendvknotf0("Прокрутка рулеток и фикс инв вкл")
            sampAddChatMessage("{ffffff}Прокрутка рулеток и фикс инв {00FF00}вкл",-1)
            --notf.addNotification(string.format("%s \nПрокрутка рулеток и фикс инв\nВключена" , os.date()), 10)
            checked_test = true
            checked_test2 = true
            checked_test3 = true
            checked_test4 = true
            activrsdf = true
            else
            sendvknotf0("Прокрутка рулеток и фикс инв выкл")
            sampAddChatMessage("{ffffff}Прокрутка рулеток и фикс инв {ff0000}выкл",-1)
            --notf.addNotification(string.format("%s \nПрокрутка рулеток и фикс инв\nВыключена" , os.date()), 10)
            checked_test = false
            checked_test2 = false
            checked_test3 = false
            checked_test4 = false
            activrsdf = false
        end
        return false
    end
    if cmd:find('/cln') then
        CleanMemory()
        return false
    end
    if cmd:find('/9') then
        mainini.functions.devyatka = not mainini.functions.devyatka
        if mainini.functions.devyatka then
            sampAddChatMessage("Режим заместителя в банде {228b22}on {ffffff}| /h9 - помощь ", -1)
            inicfg.save(mainini, 'bd') 
        else
            sampAddChatMessage("Режим заместителя в банде {ff0000}off", -1)
            inicfg.save(mainini, 'bd') 
        end
        return false
    end
    if cmd:find("/h9") and mainini.functions.devyatka then
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}ПКМ+1 {ffffff}- Принять в банду на 5", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}ПКМ+2 {ffffff}- Принять в банду на 8", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/fu id {ffffff}- Уволить с причиной 'выселен'", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/gr id rank {ffffff}- Выдать ранг", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/st id skinid {ffffff}- Выдать скин", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/sk {ffffff}- Открыть/Закрыть общак", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/fc {ffffff}- Заправить транспорт", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/sc {ffffff}- Заспавнить транспорт", -1)
        
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/nabor {ffffff}- Пиар в VIP-chat о наборе", -1)
        sampAddChatMessage("{00ffff}[9-10] {c0c0c0}/povish {ffffff}- Флудилка о том, как повыситься", -1)
        return false
    end
    if cmd:find("/nabor") and mainini.functions.devyatka then
        sampSendChat("/vr Набор в ФК 'The Rifa'. /smug /port | Желающих ждём на площадке.")
        return false
    end
    if cmd:find("/povish") and mainini.functions.devyatka then
        lua_thread.create(function()
            sampSendChat("/f Чтобы повыситься на 6-7 ранг: активно ездить на порты, проявлять себя любыми способами...")
            wait(1000)
            sampSendChat("/f ...помогать лидеру/замам, красить граффити, выполнять квесты. Привозить на склад нарко и аптечки...")
            wait(1000)
            sampSendChat("/f ...Капт-состав - 8 ранг - состав лидера. Не проситесь в этот состав, вас никто сюда не возьмет.")
        end)
        return false
    end
    if cmd:find('/fu') and mainini.functions.devyatka then 
        local arguninv = cmd:match('/fu (.+)')
        sampSendChat('/uninvite '..arguninv..' Выселен.')
        return false
    end
    if cmd:find('/skl') and mainini.functions.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 2, -1)
        return false
    end
    if cmd:find('/fc') and mainini.functions.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 4, -1)
        return false
    end
    if cmd:find('/sc') and mainini.functions.devyatka then 
        sampSendChat('/lmenu')
        sampSendDialogResponse(1214, 1, 3, -1)
        return false
    end
    if cmd:find('/gr') and mainini.functions.devyatka then 
        local argidgr = cmd:match('/gr (.+)')
        sampSendChat('/giverank '..argidgr)
        return false
    end
    if cmd:find('/gs') and mainini.functions.devyatka then 
        local argskin = cmd:match('/gs (.+)')
        sampSendChat('/giveskin '..argskin)
        return false
    end
    if cmd:find("/animki") then
        sampAddChatMessage("47 51 56 57 58 62 66 74 77 84 85 99", -1)
        return false
    end
    if cmd:find('/spb') then
        sampSendChat("/cars")
        fixbike = true
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
            sampSendChat("/id Tedj_Nuestra")
            wait(1000)
            sampSendChat("/cl Tedj_Nuestra")
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
     if cmd:find('/blessave') then
        sampAddChatMessage(" {ffffff}Для начала работы скрипта {ff4500}ble$$ave {ffffff}необходимо:", -1)
        sampAddChatMessage(" {ffffff}Перейти в группу {00FF00}https://vk.com/blessave1. {ffffff}Вступить и написать в личные сообщения группе.", -1)
        sampAddChatMessage(" {ffffff}Далее перейти в найстроки профиля VK, скопировать {9ACD32}цифровой ID {ffffff}вашего профиля.", -1)
        sampAddChatMessage(" {ffffff}В игре написать команду {FF1493}/userid {ffffff}и через пробел вставить скопированный цифровой ID вашего VK", -1)
        sampAddChatMessage(" {ffffff}Если всё сделали верно, то вам в VK придет от группы {F0E68C}тестовое сообщение{ffffff}.", -1)
        sampAddChatMessage(" {ffffff}Далее узнать подробнее можно с помощью кнопок {00ffff}Настройки/Функционал{ffffff}, в беседе с группой.", -1)
        sampAddChatMessage(" {ffffff}P.S. если у Вас нет ВК, чтоб скрипт мог полностью работать, то: {fff000}регистрируйтесь там или идите{ff0000} НАХУЙ!", -1)
        return false
    end --[[
    if cmd:find('/info2') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Авто-ввод пароля: {DAA520}/auto_pass пароль.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Авто-ввод пин-кода: {DAA520}/auto_pin пин-код.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Продолжение - {FFFF00}/info3{ffffff}.", -1)
        return false
    end
    if cmd:find('/info3') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Активация флудерок {EE82EE}/flood1 /flood2 /flood3", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Изменить текст флудерок: {00CED1}/fltext1 [text] /fltext2 [text] /fltext3 [text]", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Изменить текст флудерок: {00CED1}/flwait1 [sek] /flwait2 [sek] /flwait3 [sek]", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Посмотреть информацию о флудерках {FF6347}/flood{ffffff}.", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Продолжение - {FFFF00}/info4{ffffff}.", -1)
        return false
    end
    if cmd:find('/info4') then
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Чекер пидоров {FFFACD}/pidors", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Добавить пидора в список: {00FA9A}/addpidor [Полный_Никнейм] или ID ", -1)
        sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Поиск пидорасов в зоне стрима {808000}/fpidors{ffffff}.", -1)
        --sampAddChatMessage("{ff4500}[ble$$ave] {ffffff}Продолжение - {FFFF00}/info4{ffffff}.", -1)
        return false
    end ]]
    if cmd:find('/gcolors') then
        sampAddChatMessage("{ffffff}Ballas 179 | NW 37 | Vagos 6 | Aztecas 2 | Rifa 135 | Grove 86", -1)
        return false
    end
--[[     if cmd:find('/apass') then
        mainini.helper.autopass = not mainini.helper.autopass
		if mainini.helper.autopass then 
            sampAddChatMessage('Ввод авто-пароля включен {228b22}on',-1) 
		else
            sampAddChatMessage('{ff4500}flood1 {ff0000}off',-1)
		end
        return false
    end ]]
    if cmd:find('/auto_pass') then
        local arg = cmd:match('/auto_pass (.+)')
        mainini.helper.password = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Ваш {DAA520}пароль: {ffffff}'..mainini.helper.password,-1)
        return false
    end
    if cmd:find('/auto_pin') then
        local arg = cmd:match('/auto_pin (.+)')
        mainini.helper.bankpin = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Ваш {DAA520}пин-код: {ffffff}'..mainini.helper.bankpin,-1)
        return false
    end
    if cmd:find('/userid') then
        local arg = cmd:match('/userid (.+)')
        mainini.helper.user_id = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Ваш {9ACD32}цифровой ID VK: {ffffff}'..mainini.helper.user_id,-1)
        sendvknotf('Тестовое сообщение')
        return false
    end
    if cmd:find('/chatvip') then
        mainini.functions.chatvipka = not mainini.functions.chatvipka
		if mainini.functions.chatvipka then 
            sampAddChatMessage('Раздельный VIP-chat {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \nРаздельный VIP-chat\nВключен" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Раздельный VIP-chat {ff0000}off',-1)
            --notf.addNotification(string.format("%s \nРаздельный VIP-chat\nВыключен" , os.date()), 10)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/colorchat') then
        mainini.functions.colorchat = not mainini.functions.colorchat
		if mainini.functions.colorchat then 
            sampAddChatMessage('Цветной chat {228b22}on',-1)
            
            --notf.addNotification(string.format("%s \nРаздельный VIP-chat\nВключен" , os.date()), 10)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Цветной chat {ff0000}off',-1)
            --notf.addNotification(string.format("%s \nРаздельный VIP-chat\nВыключен" , os.date()), 10)
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
    if cmd:find('/dotmoney') then
        mainini.functions.dotmoney = not mainini.functions.dotmoney
		if mainini.functions.dotmoney then 
            sampAddChatMessage('Разделение точками деньги {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Разделение точками деньги {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/dhits') then
        mainini.functions.dhits = not mainini.functions.dhits
		if mainini.functions.dhits then 
            sampAddChatMessage('Авто-даблхиты {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Авто-даблхиты {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/extra') then
        mainini.functions.extra = not mainini.functions.extra
		if mainini.functions.extra then 
           -- if not isCharDead(playerPed) then cameraRestorePatch(true) else cameraRestorePatch(false) end
            sampAddChatMessage('Экстра WS {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            cameraRestorePatch(false)
            activeextra = false
            sampAddChatMessage('Экстра WS {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/autoc') then
        mainini.functions.autoc = not mainini.functions.autoc
		if mainini.functions.autoc then 
            sampAddChatMessage('Авто-+C {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Авто-+C {ff0000}off',-1)
            inicfg.save(mainini, 'bd')
		end
        return false
    end
    if cmd:find('/ashot') then
        mainini.functions.bott = not mainini.functions.bott
		if mainini.functions.bott then 
            sampAddChatMessage('Авто-шот {228b22}on',-1)
            inicfg.save(mainini, 'bd') 
		else
            sampAddChatMessage('Авто-шот {ff0000}off',-1)
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
    if cmd:find('/buttons') then
        sampShowDialog(1905, "{00CC00}Список клавиш | Справка", buttonslist, "ОК", _, 2)
        return false
    end
    if cmd:find('/allsbiv (.+)') then
        local arg = cmd:match('/allsbiv (.+)')
        mainini.config.allsbiv = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Клавиша для сбива всего теперь {00FFFF}'..mainini.config.allsbiv,-1)
        return false
    end
    if cmd:find('/sbiv (.+)') then
        local arg = cmd:match('/sbiv (.+)')
        mainini.config.sbiv = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Клавиша для сбива теперь {00FFFF}'..mainini.config.sbiv,-1)
        return false
    end
    if cmd:find('/suicide (.+)') then
        local arg = cmd:match('/suicide (.+)')
        mainini.config.suicide = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Клавиша для суицида теперь {00FFFF}'..mainini.config.suicide,-1)
        return false
    end
    if cmd:find('/whb (.+)') then
        local arg = cmd:match('/whb (.+)')
        mainini.config.wh = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Клавиша для WallHack теперь {00FFFF}'..mainini.config.wh,-1)
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
                sampAddChatMessage(string.format('Цвет траспорта:{FFFFFF} %s | %s', clr1, clr2), 0xFF4500)
            else
                sampAddChatMessage('Транспорта с таким ID нет в зоне прорисовки!', 0xFFF000)
            end
        end
        return false
    end
    if cmd:find('/flood') and not (cmd:find('/flood1') or cmd:find('/flood2') or cmd:find('/flood3')) then
        sampAddChatMessage("Активировать: {ff4500}/flood(1-3){ffffff} | Изменить задержку:{ff1493} /flwait(1-3) [sek] {ffffff}| Изменить текст: {00FFFF} /fltext(1-3) [text]", -1)
        
        sampAddChatMessage("{ff4500}/flood1: {00FFFF}"..mainini.flood.fltext1.." | {ff1493}"..mainini.flood.flwait1.." сек.", -1)
        sampAddChatMessage("{ff4500}/flood2: {00FFFF}"..mainini.flood.fltext2.." | {ff1493}"..mainini.flood.flwait2.." сек.", -1)
        sampAddChatMessage("{ff4500}/flood3: {00FFFF}"..mainini.flood.fltext3.." | {ff1493}"..mainini.flood.flwait3.." сек.", -1)
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
    if cmd:find('/fltext1') then
        local arg = cmd:match('/fltext1 (.+)')
        mainini.flood.fltext1 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Текст flood1 теперь {00FFFF}'..mainini.flood.fltext1,-1)
        return false
    end
    if cmd:find('/fltext2') then
        local arg = cmd:match('/fltext2 (.+)')
        mainini.flood.fltext2 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Текст flood2 теперь {00FFFF}'..mainini.flood.fltext2,-1)
        return false
    end
    if cmd:find('/fltext3') then
        local arg = cmd:match('/fltext3 (.+)')
        mainini.flood.fltext3 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Текст flood3 теперь {00FFFF}'..mainini.flood.fltext3,-1)
        return false
    end
    if cmd:find('/flwait1') then
        local arg = cmd:match('/flwait1 (.+)')
        mainini.flood.flwait1 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Задержка flood1 изменена на {ff1493}'..mainini.flood.flwait1..' сек.',-1)
        return false
    end
    if cmd:find('/flwait2') then
        local arg = cmd:match('/flwait2 (.+)')
        mainini.flood.flwait2 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Задержка flood2 изменена на {ff1493}'..mainini.flood.flwait2..' сек.',-1)
        return false
    end
    if cmd:find('/flwait3') then
        local arg = cmd:match('/flwait3 (.+)')
        mainini.flood.flwait3 = arg
        inicfg.save(mainini, 'bd')
        sampAddChatMessage('Задержка flood3 изменена на {ff1493}'..mainini.flood.flwait3..' сек.',-1)
        return false
    end

----------------------------------------------------------------

if cmd:find('/mnk (.+)') then
    local arg = cmd:match('/mnk (.+)')
        if sampIsPlayerConnected(arg) then
            arg = sampGetPlayerNickname(arg)
        else
            sampAddChatMessage('Игрока нет на сервере!', -1)
            --notf.addNotification(string.format("%s \nИгрока нет на сервере!" , os.date()), 5)
            return
        end
        on = not on
        if on then
            --printStyledString("~G~Find:~W~ "..arg, 3330, 5)
            --printStringNow("~G~Find:~W~ "..arg, 1)
            sampAddChatMessage('Ищем: '..arg..'!', -1)
            
            --notf.addNotification(string.format("%s \nИщем:\n"..arg.."" , os.date()), 5)
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
                            --sampDestroy3dText(dtext)
                 --[[            if not dtext then
                                dtext = sampCreate3dText('Найденный',0xFFD00000,0,0,0.4,9999,true,id,-1)
                            end ]]
                            if isPointOnScreen(x,y,z,0) then
                                renderDrawLine(x2, y2, x1, y1, 2.0, 0xDD6622FF)
                                renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                            else
                                screen_text = 'Где-то рядом!'
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
             --   sampAddChatMessage('Не ищем.', -1)
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
            sampAddChatMessage('{6495ED}%[VIP%] {FFFFFF}Adam_Yor%[278%]: ВАШИ МАМЫ ВСЕ ЕБАНОЕ ГОВНО, Я НАСРАЛ В ШТАНЫ А МНЕ МАМА ПИЗДЫ ДАЛА, ПОШЛИ ВСЕ НАХУЙ', -1)
        return false
    end   ]]
  
    if cmd:find('/updatebinder') and update_state then  
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
		--sampAddChatMessage("[rend] {8A2BE2}Render for {FF4500}Arizona RP(G). {800080}Автор: {8B008B}tedj", 0x7B68EE)
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
        sampAddChatMessage("[{00fc76}WAXTA{FFFFFF}]: /waxlist - показать список всех точек спавна руд", -1)
        
        return false
    end
    if cmd:find('/waxlist') then
		ScriptStateRR3 = not ScriptStateRR3
        
        LoadMarkers()
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
                            screen_text = '{ffff00}Пидорас {00ffff}'..vvf..' {ffffff}('..idpidort..') {ff0000}рядом!'
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
        if countfind == 1 then sampAddChatMessage("Пидорасы не найдены", 0xC0C0C0) end
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
            sampShowDialog(0, "{00ffff}Список всех пидорасов", dialogTabStr, "Закрыть", _, 4)
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
            sampShowDialog(0, "{00ffff}Список пидорасов {ff0000}оффлайн", dialogTabStr, "Закрыть", _, 4)
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
            sampShowDialog(0, "{00ffff}Список пидорасов {2CFF00}онлайн", dialogTabStr, "Закрыть", _, 4)
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
    sampShowDialog(1007, "Ищем: "..param.." | Результат: "..#tbl, table.concat(tbl, "\n"), "Выйти", _, 4)
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


    if chatlog then
		if doesFileExist(fpath) then
			local fa = io.open(fpath, 'a+')
			if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] "..text.."\n"):close() end
		end
	end
    ------------------------------------------------------------------
    if menuhome then
        if text:find('Дверь закрыта, невозможно зайти') and color == -10270721 then
            sampSendChat("/home")
        end
    end

    ---------

        if color == 1118842111 and text:find('Вы использовали')then
            sendvknotf0(text)
		end

        if text:find('Вам удалось улучшить') and color == 1941201407 then
            sendvknotf0(text)
		end
        
--[[         if color == -1 and text:find('%[Тел%]:')then
			sendvknotf0(text)
		end ]]
        if text:match('{73B461}%[Тел%]:') then
            sendvknotf0(text)
            text = text:gsub('^{73B461}%[Тел%]', '{2FAA5B}[Тел]') --b800a2
            return { 0xFFFFFFFF, text }
        end
        if color == -1347440641 and text:find('Звонок окончен') and text:find('Информация') and text:find('Время разговора') then
			sendvknotf(text)
		end

    if vknotf.chatc then 
		sendvknotf0(text)
	end 
    if not vknotf.chatf then 
        if text:find('%[Семья%]') or text:find('%[Альянс ') then
			sendvknotf0(text)
		end
	end 

		if color == -1347440641 and text:find('купил у вас') and text:find('от продажи') and text:find('комиссия') then
			sendvknotf(text)
		end
        if color == -1347440641 and text:find('Вы купили') and text:find('у игрока') then
			sendvknotf(text)
		end
		if color == 1941201407 and text:find('Поздравляем с продажей транспортного средства') then
			sendvknotf('Поздравляем с продажей транспортного средства')
		end

--[[ 
		if text:find('Используйте клавишу') and text:find('чтобы показать курсор управления или') then
			sendvknotf('Телефон проверь <3')
            sendvknotf(t00ext)
		end ]]

   print(text, color)

        if text:find("Вам пришло новое сообщение!") and not text:find("говорит") and not text:find('- |') then
            sampAddChatMessage("{fff000}Вам пришло новое {FFFFFF}SMS{fff000}-сообщение!", -1)
            addOneOffSound(0.0, 0.0, 0.0, 1055)
            printStringNow("~Y~SMS", 3000)
            return false
          end

 --[[          if  text:find('говорит:') then
            print('{'..bit.tohex(bit.rshift(color, 8), 6)..'}'..text)
            print('======')
            print('%X', color)
            print(bit.tohex(bit.rshift(color, 8), 6))
            end ]]

        if text:find('говорит:') then
                local idd = text:match('%d+')
            local colorr = sampGetPlayerColor(idd)
                sampAddChatMessage(text,colorr)
                return false 
        end

        if text:find('%[Альянс ') then
            --sampAddChatMessage(text, 0xFF00FF)
            return { 0x9c15c1ff, text }
        end


        


    if text:find('^Администратор (.+) ответил вам') then
        sendvknotf('(warning | chat) '..text)
    end

    
    if color == -10270721 and text:find('Администратор') then
        local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if res then 
            local mname = sampGetPlayerNickname(mid)
            if text:find(mname) then
                    sendvknotf(text)
            end 
        end
    end
    if color == -10270721 and text:find('Вы можете выйти из психиатрической больницы') then
            sendvknotf(text)
    end

    if text:find('Банковский чек') and color == 1941201407 then
       lua_thread.create(function()
        wait(10*1000)
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
        sampAddChatMessage('{ff0000}Но забыли оплатить налоги на {00ff00}трейлер {ffffff}(/trpay), {0000ff}фам.квартиру {ffffff}(/fpay)', 0xff0000)   
        end)
    end

        if text:find('Банковский чек') and color == 1941201407 then
            vknotf.ispaydaystate = true
            vknotf.ispaydaytext = ''
        end
        if vknotf.ispaydaystate then
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
                if (text:find('Бар') or text:find('бар') or text:find('БАР') or text:find('БAР')) and (text:find('VIP') or text:find('PREMIUM')) and not (text:find('Продам') or text:find('продам') or text:find('Открылся') or text:find('открылся') or text:find('Куплю') or text:find('куплю')) and color == -1  then return false end
               if (text:find('Бар') or text:find('бар') or text:find('БАР') or text:find('БAР') or text:find('БAP')) and text:find('Объявление') and not (text:find('Продам') or text:find('продам') or text:find('Куплю') or text:find('Открылся') or text:find('открылся') or text:find('куплю')) then return false end
                if (text:find('Бар') or text:find('бар') or text:find('БАР')  or text:find('БAР') or text:find('БAP')) and text:find('Семья') and (text:find('Работает') or text:find('работает') or text:find('Конкурс') or text:find('конкурс')) then return false end
                if (text:find('Бар') or text:find('Бaр') or text:find('бар') or text:find('БАР') or text:find('БAР') or text:find('БAP')) and text:find('Альянс') and (text:find('Работает') or text:find('работает')  or text:find('Конкурс') or text:find('конкурс')) then return false end
           

                if text:match('^%s+$') then return false end

                if (text:find("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~") or text:find("Основные команды сервера:") or text:find("Пригласи друга и получи") or text:find("Наш сайт:"))  and color == -89368321 then return false end



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

                if (text:find("В нашем магазине ты можешь приобрести нужное количество игровых денег и потратить") or text:find("их на желаемый тобой") or text:find("имеют большие возможности") or text:find("имеют больше возможностей") or text:find("можно приобрести редкие") or text:find("которые выделят тебя из толпы")) and color == 1687547391 then return false end

                if text:find("вышел при попытке избежать ареста и был наказан") and color == -1104335361 then return false end

                if (text:find("начал работу новый инкассатор") or text:find('вы сможете получить деньги')) and color == -1800355329 then return false end

                if (text:find("News LS") or text:find("News LV") or text:find("News SF")) and color == 1941201407 then return false end

                if text:find('выехал матовоз') and color == -1800355329 then return false end

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

                if text:find('Вам был добавлен предмет') and text:find('Ингредиенты') and color == -65281 then return false end
                if text:find('домами могут бесплатно раз в день получать') and text:find('Подсказка') and color == -1347440641 then return false end
                if (text:find('Либерти Сити') or text:find('отправляйтесь на его разгрузку') or text:find('об контрабанде')) and text:find('Внимание') and color == -1104335361 then return false end

                if (text:find('Ограбление изъятых патронов и наркотиков завершено') or text:find('Если вам удалось что-то украсть') or text:find('Внимание!') or text:find('Через 10 минут состоится выгрузка изъятых патронов и наркотиков') or text:find('чтобы украсть как можно больше ящиков в порту и пополнить ими общак') or text:find('Берите фургон и направляйтесь в порт') or text:find('Берите фургон и направляйтесь в порт') or text:find('вся Армия штата сосредоточена на том')) and color == -10270721 then return false end
                if (text:find('Если вам удалось что-то украсть') or text:find('доставьте это в общак')) and color == -10270721 then return false end
                if (text:find('чтобы не дать бандитам украсть и пополнить свой общак патронами пии наркотиками') or text:find('Берите технику и направляйтесь в порт для защиты груза')) and color == -10270721 then return false end
                if (text:find('В порт уже доставили изъятые патроны и наркотики с соседнего штата') or text:find('Успейте украсть как можно больше, пока их не украли другие')) and color == -10270721 then return false end

                if (text:find('арендатор концертного зала:') and text:find('проводит мероприятие') and text:find('Развлечения')) and color == 1687547391 then return false end

                if text:find("Гос.Новости:") and color == 73381119 then return false end

                if text:find('Мероприятие') and text:find('Зловещий дворец') and color ==  -1178486529 then return false end

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


            ----------------------sadlkjjasdlknmadsklasd
            if mainini.functions.chatvipka then
                if text:find('%[VIP%] {FFFFFF}.+%[%d+%]: (.+)') or  text:find('%[PREMIUM%] {FFFFFF}.+%[%d+%]: (.+)') then --да да, и снова я гений регулярок
                    --gtext = text:gsub('{6495ED}',  '{'..bit.tohex(hex_color_color_tag_vip)..'}')
                    --gtext = gtext:gsub('{F345FC}', '{'..bit.tohex(hex_color_color_tag_premium)..'}')
                    --gtext = gtext:gsub('{ffffff}', '{'..bit.tohex(hex_color_vr_msg)..'}')
                    timeqw = os.date('[%H:%M:%S] ')
                    textWithColor = '{'..bit.tohex(color)..'}'..timeqw..text
                    if #chat >= 10 then
                        table.remove(chat, 1)
                    end
                    table.insert(chat, #chat + 1, textWithColor)
        
                    --ГОВНОКОД, НО Я ЗАЕБАЛСЯ ЭТО ДЕЛАТЬ
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
                --[[                 if text:find("Отредактировал сотрудник СМИ") and color == 1941201407 then return false end
                if text:find("Отредактировал сотрудник СМИ") and not text:find('говорит:') then return false end ]]
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

                if text:find('Администратор') then
                    if color == -10270721 then -- действия FF6347FF
                        return { 0xb22222ff, text }
                    elseif color == -2686721 then -- /ao FFD700FF
                        return { 0x38fcffff, text }
                    end
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

            if text:find("Отредактировал сотрудник СМИ") and color == 1941201407 then return false end
            if text:find("Отредактировал сотрудник СМИ") and not text:find('говорит:') then return false end

            if mainini.functions.dotmoney then
                text = separator(text)
                return {color, text}
            end

end

-- pадар в инте офф
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
  