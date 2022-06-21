local imgui = require('imgui')
local inicfg = require 'inicfg'
local sampev = require "lib.samp.events"
local rkeys = require 'rkeys'
local vkeys = require 'vkeys'
local encoding = require('encoding')
local dlstatus = require('moonloader').download_status
local neatjson = require('neatjson')
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey

encoding.default = 'CP1251'
local u8 = encoding.UTF8



local update_state = false 

local script_vers = 1
local script_vers_text = "21.06.2022"

local update_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/update_gh.ini"
local update_path = getWorkingDirectory() .. "\\config\\update_gh.ini" 

local script_url = "https://raw.githubusercontent.com/tedjblessave/binder/main/ghettohelper.lua"
local script_path = thisScript().path

local binds = {}
local customBinds = {}

local menu = imgui.ImBool(false)
local TextHint = imgui.ImBuffer(256)
 
local nId = 0
local editId = 0

local bbinds = {}

local bnId = 0
local beditId = 0

local button = { }
button[1] = true 
button[2] = false 
button[3] = false 
button[4] = false 
button[5] = false 


button[11] = false 
button[12] = false 
button[13] = false 


 
local cfg = inicfg.load({   
    lidzam = {
        enabled = false,
        minlvl = 2, 
        minrank = 4, 
        band = 0,
        autouninv = false,
    },
    fastgun = {
        deagle = u8'de',
        shotgun = u8'sg',
        m4a1 = u8'ma',
        ak47 = u8'ak',
        molotov = u8'mo',
        mp5 = u8'mp5',
        microuzi = u8'uz',
        rifle = u8'rf',
        invisibleinventory = false
    }
    }, "settings_ghettohelper")
    inicfg.save(cfg, 'settings_ghettohelper.ini') 

local lidzam = {
    enabled = imgui.ImBool(cfg.lidzam.enabled),
    autouninv = imgui.ImBool(cfg.lidzam.autouninv),
    minlvl = imgui.ImBuffer(''..cfg.lidzam.minlvl,30),
    minrank = imgui.ImBuffer(''..cfg.lidzam.minrank,30),
    band = imgui.ImInt(cfg.lidzam.band)
}

-- // Максимальное время ожидания после отправки действия на сервер (Клик по текстдраву или его ожидание)
-- // Не рекомендуется ставить маленькое значение, на фуловом онлайне будет работать через раз
local TIMEOUT = 1.00

-- // ID кнопок страниц инвентаря
local page = { 
	[1] = 2107,
	[2] = 2108,
	[3] = 2109,
	["cur"] = 1
}

local fastgun = {
    invisibleinventory = imgui.ImBool(cfg.fastgun.invisibleinventory),
    deagle = imgui.ImBuffer(''..cfg.fastgun.deagle,30),
    shotgun = imgui.ImBuffer(''..cfg.fastgun.shotgun,30),
    m4a1 = imgui.ImBuffer(''..cfg.fastgun.m4a1,30),
    ak47 = imgui.ImBuffer(''..cfg.fastgun.ak47,30),
    molotov = imgui.ImBuffer(''..cfg.fastgun.molotov,30),
    mp5 = imgui.ImBuffer(''..cfg.fastgun.mp5,30),
    microuzi = imgui.ImBuffer(''..cfg.fastgun.microuzi,30),
    rifle = imgui.ImBuffer(''..cfg.fastgun.rifle,30)
}

function saveFastgunSettings()
    cfg.fastgun.invisibleinventory = fastgun.invisibleinventory.v
    cfg.fastgun.deagle = fastgun.deagle.v
    cfg.fastgun.shotgun = fastgun.shotgun.v
    cfg.fastgun.mp5 = fastgun.mp5.v
    cfg.fastgun.m4a1 = fastgun.m4a1.v
    cfg.fastgun.ak47 = fastgun.ak47.v
    cfg.fastgun.molotov = fastgun.molotov.v
    cfg.fastgun.microuzi = fastgun.microuzi.v
    cfg.fastgun.rifle = fastgun.rifle.v

    saved = inicfg.save(cfg,'settings_ghettohelper.ini')

end

local com1 = cfg.fastgun.deagle
local com2 = cfg.fastgun.shotgun 
local com4 = cfg.fastgun.mp5 
local com6 = cfg.fastgun.m4a1 
local com5 = cfg.fastgun.ak47 
local com7 = cfg.fastgun.molotov 
local com3 = cfg.fastgun.microuzi 
local com8 = cfg.fastgun.rifle 

Weapon = {
	[com1] 	= { model = 348, x = 0, y = 32, z = 189, name = "Desert Eagle" },
	[com2] 	= { model = 349, x = 0, y = 23, z = 140, name = "ShotGun" },
	[com3] 	= { model = 352, x = 0, y = 360, z = 188, name = "Micro Uzi" },
	[com4] 	= { model = 353, x = 0, y = 17, z = 181, name = "MP5" },
	[com5] 	= { model = 355, x = 0, y = 27, z = 134, name = "AK-47" },
	[com6] 	= { model = 356, x = 0, y = 27, z = 134, name = "M4" },
	[com7] 	= { model = 344, x = 0, y = 0, z = 70, name = "Molotov" },
	[com8] 	= { model = 357, x = 0, y = 13, z = 120, name = "Rifle" }
}

--[[ Weapon = {
	[cfg.fastgun.deagle] 	= { model = 348, x = 0, y = 32, z = 189, name = "Desert Eagle" },
	[cfg.fastgun.shotgun] 	= { model = 349, x = 0, y = 23, z = 140, name = "ShotGun" },
	[cfg.fastgun.microuzi] 	= { model = 352, x = 0, y = 360, z = 188, name = "Micro Uzi" },
	[cfg.fastgun.mp5] 	= { model = 353, x = 0, y = 17, z = 181, name = "MP5" },
	[cfg.fastgun.ak47] 	= { model = 355, x = 0, y = 27, z = 134, name = "AK-47" },
	[cfg.fastgun.m4a1] 	= { model = 356, x = 0, y = 27, z = 134, name = "M4" },
	[cfg.fastgun.molotov] 	= { model = 344, x = 0, y = 0, z = 70, name = "Molotov" },
	[cfg.fastgun.rifle] 	= { model = 357, x = 0, y = 13, z = 120, name = "Rifle" }
} ]]


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

function close_inventory()
	for i = 0, 1 do
		if i <= info.step then sampSendClickTextdraw(0xFFFF) end
	end
	info = nil
end

local object_groups = {
    Wolfs = {
        {
            modelId = 18647,
            position = {
                x = 2447.05,
                y = -1449.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1448.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1445,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1442,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1439,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1436,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1433,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1430,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1427,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1424,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1421,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1418,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1415,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1412,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1409,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1406,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1403,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1400,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1397,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1394,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1391,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1388,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2446.05,
                y = -1385,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2447,
                y = -1384,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2450,
                y = -1384,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2453,
                y = -1384,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2456,
                y = -1384,
                z = 23
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2459,
                y = -1384,
                z = 23
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2462,
                y = -1384,
                z = 23
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2463,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2466,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2469,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2472,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2475,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2478,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2481,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2484,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2487,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2490,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2493,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2496,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2499,
                y = -1384,
                z = 27.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2502,
                y = -1384,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2505,
                y = -1384,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2508,
                y = -1384,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2511,
                y = -1384,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2514,
                y = -1384,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2517,
                y = -1384,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2520,
                y = -1384,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1385,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1388,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1391,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1394,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1397,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1400,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1403,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1406,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1409,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1412,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1415,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1418,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1421,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1424,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1427,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1430,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1433,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1436,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1439,
                z = 27.5
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1442,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1445,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2521.67,
                y = -1448,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2520.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2517.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2514.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2511.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2508.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2505.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2502.7,
                y = -1449.3,
                z = 27.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2499.7,
                y = -1449.3,
                z = 27.1
            },
            rotation = {
                x = -8.5,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2496.7,
                y = -1449.3,
                z = 26.7
            },
            rotation = {
                x = -8.5,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2493.7,
                y = -1449.3,
                z = 26.3
            },
            rotation = {
                x = -8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2490.7,
                y = -1449.3,
                z = 25.9
            },
            rotation = {
                x = -8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2487.7,
                y = -1449.3,
                z = 25.5
            },
            rotation = {
                x = -8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2484.7,
                y = -1449.3,
                z = 25.1
            },
            rotation = {
                x = -8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2481.7,
                y = -1449.3,
                z = 24.67
            },
            rotation = {
                x = -8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2478.7,
                y = -1449.3,
                z = 24.27
            },
            rotation = {
                x = -6,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2474.7,
                y = -1449.3,
                z = 23.9
            },
            rotation = {
                x = -5,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2471.7,
                y = -1449.3,
                z = 23.67
            },
            rotation = {
                x = -4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2468.7,
                y = -1449.3,
                z = 23.43
            },
            rotation = {
                x = -4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2465.7,
                y = -1449.3,
                z = 23.2
            },
            rotation = {
                x = -4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2462.7,
                y = -1449.3,
                z = 22.96
            },
            rotation = {
                x = -5,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2459.7,
                y = -1449.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2456.7,
                y = -1449.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2453.7,
                y = -1449.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18647,
            position = {
                x = 2450.7,
                y = -1449.3,
                z = 22.8
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        }
    },    
    Grove = {
        {
            modelId = 18649,
            position = {
                x = 2483,
                y = -1722.3,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 88,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2480,
                y = -1722.19,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 88,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2477,
                y = -1722.19,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 94,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2474,
                y = -1722.37,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2471,
                y = -1722.37,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1703.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1706.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1709.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1712.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1715.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1718.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1721.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1700.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1697.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1694.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1691.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1688.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1685.37,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2469.5,
                y = -1682.87,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2468.6,
                y = -1680.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 33,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2466.7,
                y = -1677.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 33,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2465.7,
                y = -1674.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 12,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2465.1,
                y = -1671.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 12,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2464.3,
                y = -1668.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 20,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1665.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1662.4,
                z = 12.3
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1659.4,
                z = 12.3
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1656.4,
                z = 12.3
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1653.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1650.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1647.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1644.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1641.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1638.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1635.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1632.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2463.6,
                y = -1629.4,
                z = 12.52
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2464.6,
                y = -1629.1,
                z = 14.7
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2467.6,
                y = -1629.1,
                z = 14.8
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2470.6,
                y = -1629.1,
                z = 14.91
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2473.6,
                y = -1629.1,
                z = 15.05
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2476.6,
                y = -1629.1,
                z = 15.2
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2479.6,
                y = -1629.1,
                z = 15.3
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2482.6,
                y = -1629.06,
                z = 15.45
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2485.6,
                y = -1629.02,
                z = 15.57
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2488.6,
                y = -1628.97,
                z = 15.7
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2491.6,
                y = -1628.915,
                z = 15.84
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2494.6,
                y = -1628.86,
                z = 15.98
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2497.6,
                y = -1628.79,
                z = 16.15
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2500.6,
                y = -1628.72,
                z = 16.25
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2503.6,
                y = -1628.67,
                z = 16.4
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2506.6,
                y = -1628.60,
                z = 16.5
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2509.6,
                y = -1628.53,
                z = 16.59
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2512.6,
                y = -1628.48,
                z = 16.657
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2515.6,
                y = -1628.43,
                z = 16.8
            },
            rotation = {
                x = -1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2518.6,
                y = -1628.43,
                z = 16.81
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2521.6,
                y = -1628.43,
                z = 16.81
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2524.6,
                y = -1628.43,
                z = 16.81
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2527.6,
                y = -1628.43,
                z = 16.81
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2530.6,
                y = -1628.43,
                z = 16.815
            },
            rotation = {
                x = -1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2533.6,
                y = -1628.43,
                z = 16.872
            },
            rotation = {
                x = -1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2536.6,
                y = -1628.38,
                z = 16.93
            },
            rotation = {
                x = -1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2539.6,
                y = -1628.35,
                z = 17
            },
            rotation = {
                x = -1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2523,
                y = -1722.3,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 88,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2520,
                y = -1722.3,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 88,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2540.95,
                y = -1715.7,
                z = 12.49
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2540.95,
                y = -1712.7,
                z = 12.48
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18649,
            position = {
                x = 2540.99,
                y = -1709.7,
                z = 12.46
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        }
    },
    Rifa = {
        {
            modelId = 18648,
            position = {
                x = 2173.8,
                y = -1763.05,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 51,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2176.7,
                y = -1765.4,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 51,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2179.7,
                y = -1766.16,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2182.7,
                y = -1766.16,
                z = 12.36
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2185.7,
                y = -1766.16,
                z = 12.36
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2188.7,
                y = -1766.16,
                z = 12.36
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2191.7,
                y = -1766.16,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2194.6,
                y = -1766.16,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        --[[ {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1763.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },]]
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1767.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        }, 
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1769.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1772.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1775.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1778.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1781.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1784.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1787.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1790.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1793.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1796.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1799.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1802.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1805.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1808.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1811.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1814.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1817.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1820.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1823.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1826.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1829.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1832.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1835.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2195.66,
                y = -1838.2,
                z = 12.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2135.3,
                y = -1830.9,
                z = 12.58
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2135.35,
                y = -1830.99,
                z = 15.15
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        }
    },
    Aztecas = {
        {
            modelId = 18648,
            position = {
                x = 2452.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2455.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2458.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2461.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2464.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2467.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2470.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2473.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2476.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2479.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2482.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2485.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2488.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2491.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2494.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2497.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2500.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2503.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2506.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2509.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2512.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2515.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2518.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2521.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2524.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2527.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2530.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2533.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2536.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2539.35,
                y = -1981.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2542.35,
                y = -1981.2,
                z = 11.6
            },
            rotation = {
                x = 38,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2545.35,
                y = -1981.2,
                z = 9.1
            },
            rotation = {
                x = 38,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2548.35,
                y = -1981.2,
                z = 6.8
            },
            rotation = {
                x = 38,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2551.35,
                y = -1981.2,
                z = 4.48
            },
            rotation = {
                x = 38,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -1985.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -1988.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -1991.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -1994.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -1997.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2000.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2003.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2006.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2009.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2012.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2015.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2018.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2021.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2024.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2027.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2030.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2033.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2036.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2553.5,
                y = -2039.3,
                z = 2.85
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2548.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2542.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2539.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2536.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2533.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2530.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2527.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2524.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2521.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2518.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2515.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2513.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2510.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2507.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2545.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2504.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2501.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2498.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2495.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2492.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2489.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2486.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2486.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2483.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2480.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2477.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2474.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2471.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2468.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2465.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2462.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2459.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2456.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2453.7,
                y = -2040.8,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1982.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1985.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1988.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1991.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1994.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -1997.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2000.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2003.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2006.2,
                z = 12.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2009.2,
                z = 12.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2012.2,
                z = 12.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2015.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2018.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2021.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2024.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2027.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2030.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2033.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2036.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18648,
            position = {
                x = 2451.25,
                y = -2039.2,
                z = 12.55
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        }
    },
    Vagos = {
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1599.5,
                z = 12.1
            },
            rotation = {
                x = 7,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1596.5,
                z = 12.43
            },
            rotation = {
                x = 7,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1593.5,
                z = 12.77
            },
            rotation = {
                x = 7,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1590.5,
                z = 13.2
            },
            rotation = {
                x = 7,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1587.5,
                z = 13.7
            },
            rotation = {
                x = 12,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1584.5,
                z = 14.5
            },
            rotation = {
                x = 14,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1581.5,
                z = 15.3
            },
            rotation = {
                x = 14,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1578.5,
                z = 16.1
            },
            rotation = {
                x = 14,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1575.5,
                z = 16.9
            },
            rotation = {
                x = 14,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1572.5,
                z = 17.75
            },
            rotation = {
                x = 14.5,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1569.5,
                z = 18.58
            },
            rotation = {
                x = 14.9,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1566.5,
                z = 19.41
            },
            rotation = {
                x = 14.9,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2747.7,
                y = -1563.5,
                z = 20.22
            },
            rotation = {
                x = 14.9,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2749.3,
                y = -1561.47,
                z = 20.8
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2752.3,
                y = -1561.47,
                z = 20.9
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2755.3,
                y = -1561.47,
                z = 21
            },
            rotation = {
                x = -2,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2758.3,
                y = -1561.47,
                z = 21
            },
            rotation = {
                x = -1.3,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2761.3,
                y = -1561.47,
                z = 21.1
            },
            rotation = {
                x = -1.3,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2764.3,
                y = -1561.47,
                z = 21
            },
            rotation = {
                x = 11.8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2767.3,
                y = -1561.47,
                z = 20.37
            },
            rotation = {
                x = 11.8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2770.3,
                y = -1561.47,
                z = 19.7
            },
            rotation = {
                x = 11.8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2773.3,
                y = -1561.47,
                z = 19.1
            },
            rotation = {
                x = 11.8,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2776.3,
                y = -1561.47,
                z = 18.53
            },
            rotation = {
                x = 11.6,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2779.3,
                y = -1561.47,
                z = 17.92
            },
            rotation = {
                x = 11.4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2782.3,
                y = -1561.47,
                z = 17.4
            },
            rotation = {
                x = 11.4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2785.3,
                y = -1561.47,
                z = 16.8
            },
            rotation = {
                x = 11.4,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2788.3,
                y = -1561.47,
                z = 16.17
            },
            rotation = {
                x = 11.1,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2791.5,
                y = -1561.47,
                z = 10.08
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2794.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2797.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2800.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2803.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2806.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2809.5,
                y = -1561.47,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2812.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2815.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2818.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2821.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2824.5,
                y = -1561.47,
                z = 9.9
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2827.5,
                y = -1561.47,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2827.66,
                y = -1562.48,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2827.66,
                y = -1564.16,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2828.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2831.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2834.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2837.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2840.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2843.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2846.66,
                y = -1565.18,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2847.86,
                y = -1566.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -18,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2846.67,
                y = -1569.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -28,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2844.95,
                y = -1572.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2843.24,
                y = -1575.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2841.5,
                y = -1578.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2839.73,
                y = -1581.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2838.0,
                y = -1584.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2836.26,
                y = -1587.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2834.53,
                y = -1590.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2832.8,
                y = -1593.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -30,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2831.1,
                y = -1596.3,
                z = 9.93
            },
            rotation = {
                x = 0,
                y = 0,
                z = -28,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2829.1,
                y = -1596.9,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 70,
            }
        },
        {
            modelId = 18650,
            position = {
                x = 2826.7,
                y = -1596.03,
                z = 10.1
            },
            rotation = {
                x = 0,
                y = 0,
                z = 70,
            }
        }
    },
    Ballas = {
        {
            modelId = 18651,
            position = {
                x = 1982.15,
                y = -1084,
                z = 24.16
            },
            rotation = {
                x = -2,
                y = 0,
                z = 80,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1985.15,
                y = -1084.5,
                z = 24.1
            },
            rotation = {
                x = 3,
                y = 0,
                z = 80,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1988.15,
                y = -1085.05,
                z = 23.8
            },
            rotation = {
                x = 7,
                y = 0,
                z = 80,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1980.96,
                y = -1085,
                z = 23.99
            },
            rotation = {
                x = -2,
                y = 0,
                z = -9,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1980.5,
                y = -1088,
                z = 24.1
            },
            rotation = {
                x = -2,
                y = 0,
                z = -9,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1980.01,
                y = -1091,
                z = 24.2
            },
            rotation = {
                x = -2,
                y = 0,
                z = -8.5,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1979.55,
                y = -1094,
                z = 24.26
            },
            rotation = {
                x = -2,
                y = 0,
                z = -8.5,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1979.07,
                y = -1097,
                z = 24.33
            },
            rotation = {
                x = -1,
                y = 0,
                z = -8.5,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1978.65,
                y = -1100,
                z = 24.4
            },
            rotation = {
                x = 0,
                y = 0,
                z = -5,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1978.35,
                y = -1103,
                z = 24.45
            },
            rotation = {
                x = -1,
                y = 0,
                z = -5,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1978.05,
                y = -1106,
                z = 24.5
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1977.75,
                y = -1109,
                z = 24.55
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1977.45,
                y = -1112,
                z = 24.58
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1977.15,
                y = -1115,
                z = 24.63
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1976.85,
                y = -1118,
                z = 24.7
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1976.53,
                y = -1121,
                z = 24.75
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1976.25,
                y = -1124,
                z = 24.8
            },
            rotation = {
                x = -1,
                y = 0,
                z = -6,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1976.0,
                y = -1127,
                z = 24.8
            },
            rotation = {
                x = -1,
                y = 0,
                z = -5,
            }
        },-------------------------
        {
            modelId = 18651,
            position = {
                x = 1974.73,
                y = -1148,
                z = 24.85
            },
            rotation = {
                x = -1,
                y = 0,
                z = -1,
            }
        },
        {
            modelId = 18651,
            position = {
                x = 1974.82,
                y = -1145,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },---1
        {
            modelId = 18651,
            position = {
                x = 1974.9,
                y = -1142,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },---2
        {
            modelId = 18651,
            position = {
                x = 1975,
                y = -1139,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },---3
        {
            modelId = 18651,
            position = {
                x = 1975.3,
                y = -1136,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },---4
        {
            modelId = 18651,
            position = {
                x = 1975.5,
                y = -1133,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },---5
        {
            modelId = 18651,
            position = {
                x = 1975.7,
                y = -1130,
                z = 24.83
            },
            rotation = {
                x = 0,
                y = 0,
                z = -2,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 1975.73,
                y = -1149,
                z = 25
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 1978.73,
                y = -1149,
                z = 25
            },
            rotation = {
                x = 0,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2004.65,
                y = -1145.8,
                z = 24.37
            },
            rotation = {
                x = 1,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2007.65,
                y = -1145.8,
                z = 24.30
            },
            rotation = {
                x = 1,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2010.65,
                y = -1145.8,
                z = 24.22
            },
            rotation = {
                x = 2,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2013.65,
                y = -1145.8,
                z = 24.13
            },
            rotation = {
                x = 2,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2016.65,
                y = -1145.8,
                z = 24.04
            },
            rotation = {
                x = 2,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2019.65,
                y = -1145.8,
                z = 23.95
            },
            rotation = {
                x = 2,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2022.65,
                y = -1145.8,
                z = 23.87
            },
            rotation = {
                x = 2,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2025.65,
                y = -1145.8,
                z = 23.78
            },
            rotation = {
                x = 1.5,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2028.65,
                y = -1145.8,
                z = 23.71
            },
            rotation = {
                x = 1.5,
                y = 0,
                z = 90,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2029.65,
                y = -1144.8,
                z = 23.67
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2029.3,
                y = -1141.8,
                z = 23.67
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2029,
                y = -1138.8,
                z = 23.5
            },
            rotation = {
                x = 1,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2028.7,
                y = -1135.8,
                z = 23.53
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2028.4,
                y = -1132.8,
                z = 23.53
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2028.1,
                y = -1129.8,
                z = 23.7
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.8,
                y = -1126.8,
                z = 23.7
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1123.8,
                z = 25
            },
            rotation = {
                x = 12,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1120.8,
                z = 25.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1117.8,
                z = 25.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1114.8,
                z = 25.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1111.8,
                z = 25.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1108.8,
                z = 25.2
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1105.8,
                z = 23.69
            },
            rotation = {
                x = -1,
                y = 0,
                z = 0,
            }
        },        
        { 
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1102.8,
                z = 23.69
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        },        
        {
            modelId = 18651,
            position = {
                x = 2027.5,
                y = -1099.8,
                z = 23.69
            },
            rotation = {
                x = 0,
                y = 0,
                z = 0,
            }
        }
    }
} 

local createdObjects = {
}

local bands = {u8"Ballas",u8"Grove",u8"Vagos",u8"Aztecas",u8"Wolfs",u8"Rifa"}

function initCommands(unload)
    _G[unload and 'sampUnregisterChatCommand' or 'sampRegisterChatCommand']("fu", function(param) sampSendChat('/uninvite '..param..' Выселен.') end)
    _G[unload and 'sampUnregisterChatCommand' or 'sampRegisterChatCommand']("gr", function(param) sampSendChat('/giverank '..param) end)
    _G[unload and 'sampUnregisterChatCommand' or 'sampRegisterChatCommand']("gs", function(param) sampSendChat('/giveskin '..param) end)
    _G[unload and 'sampUnregisterChatCommand' or 'sampRegisterChatCommand']("fm", function(param) sampSendChat('/fmute '..param) end)
    _G[unload and 'sampUnregisterChatCommand' or 'sampRegisterChatCommand']("mb", function(param) sampSendChat('/members') end)
end

function main()
    repeat wait(0) until isSampAvailable()
    if not doesFileExist("moonloader\\config\\update_gh.ini") then
        downloadUrlToFile("https://raw.githubusercontent.com/tedjblessave/binder/main/update_gh.ini", "moonloader\\config\\update_gh.ini", function(id, statuss, p1, p2)
        end)
    end  
    wapka = imgui.CreateTextureFromFile('moonloader/config/blessave.jpg')
    loadSettings()    
    loadSKSettings()
    loadBinderSettings() 
    loadCustomBinds()
    sampRegisterChatCommand('gh', function() 
        menu.v = not menu.v
    end) 
    if cfg.lidzam.enabled then
        initCommands(false) 
    end
    sampRegisterChatCommand('flood', function(param) 
        local bindId = param:match('%d+')
        if bindId ~= nil then
            bindId = tonumber(bindId)
            if bindId < 1 or bindId > table.getn(binds) then
                sampAddChatMessage('Некорректный ID флудера', -1)
            else
                local bind = binds[bindId]
                bind.enabled.v = not bind.enabled.v
                sampAddChatMessage(string.format('Флудер №%d %s', bindId, bind.enabled.v and '{00FF00}включен' or '{FF0000}выключен'), -1)
            end
        else
            sampAddChatMessage('Используй: /flood [ID флудера]', -1)
        end
    end)
    sampAddChatMessage("{800080}[blessave]: {ffffff}Скрипт {c0c0c0}Ghetto Helper {09951a}Запущен! {ffffff}Активация: {00ffff}/gh", 0x800080)
    
    while true do   
        wait(0) 
        imgui.Process = menu.v 
        local time = os.time()
        for k, bind in pairs(binds) do
            if bind.enabled.v and time - bind.timeSinceSend > bind.delay.v then
                sampSendChat(u8:decode(bind.message.v))
                bind.timeSinceSend = time
            end
        end

        if cfg.lidzam.band == 0 then
            banda = "East Side Ballas"
        elseif cfg.lidzam.band == 1 then
            banda = "Grove St. Family"
        elseif cfg.lidzam.band == 2 then
            banda = "Los-Santos Vagos"
        elseif cfg.lidzam.band == 3 then
            banda = "Varios Los Aztecas"
        elseif cfg.lidzam.band == 4 then
            banda = "Night Wolfs"
        elseif cfg.lidzam.band == 5 then
            banda = "San-Fierro Rifa"
        end
    end
end

function targetfunc(actionId)
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
            if actionId == 1 then
                if sampGetPlayerScore(id) >= cfg.lidzam.minlvl then
                    sampSendChat(string.format('/invite %s', name))
                else
                    sampSendChat(string.format("%s, в нашу банду %s проходит набор с %s лет проживания в штате", namee, banda, cfg.lidzam.minlvl))
                end
            end
            if actionId == 2 then
                sampSendChat(string.format('/invite %s', name))
                captsostav = true
            end
            if actionId == 3 then
                sampSetChatInputText(string.format('/giveskin %s ', id))
                sampSetChatInputEnabled(true)
            end
            if actionId == 4 then
                sampSetChatInputText(string.format('/giverank %s ', id))
                sampSetChatInputEnabled(true)
            end
        end
    end
end

function sampev.onSendCommand(input)
    local cmd, args = string.match(input, "^/([^%s]+)"), {}
	local cmd_len = string.len("/" .. cmd)
	local arg_text = string.sub(input, cmd_len + 2, string.len(input))
	for arg in string.gmatch(arg_text, "[^%s]+") do args[#args + 1] = arg end

	if Weapon[cmd] ~= nil then
		if info ~= nil then
			sampAddChatMessage("» Подождите немного!", 0xAA3030)
			return false
		end

		local count = tonumber(args[1]) or 50
		if count > 500 then
			sampAddChatMessage("» Нельзя доставать более 500 ед. за раз!", 0xAA3030)
			return false
		elseif count < 1 then
			sampAddChatMessage("» Введено некорректное количество!", 0xAA3030)
			return false
		end

		page.cur = 1
		lua_thread.create(function()
			while true do wait(0)
				if info ~= nil then
					if os.clock() - info.clock >= TIMEOUT then
						if info.step == 0 and page.cur < 3 then
							page.cur = page.cur + 1
							info.clock = os.clock()
							sampSendClickTextdraw(page[page.cur])
						elseif page.cur > 1 then
							sampAddChatMessage("» В вашем инвентаре не найдено это оружие!", 0xAA3030)
							close_inventory()
						else
							sampAddChatMessage("» Вышло время ожидания, попробуйте ещё раз!", 0xAA3030)
							close_inventory()
						end
					end
				end
			end
		end)
		info = Weapon[cmd](count)
		return { "/invent" }
	end
    if input:find('^/probiv') then
        lua_thread.create(function()
            sampSendChat("/id "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(700)
            sampSendChat("/cl "..sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))))
            wait(700)
            setVirtualKeyDown(116, true)
            wait(2500)
            setVirtualKeyDown(116, false)
            wait(100)
            sampSetChatInputText("жоская проверка инсерт")
            sampSetChatInputEnabled(true)
            wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)wait(500)
            setVirtualKeyDown(45, true)
            setVirtualKeyDown(45, false)
            wait(500) 
            setVirtualKeyDown(13, false)
            wait(100)
            sampSendChat("/time")
            wait(700)
            setVirtualKeyDown(9, true)
            setVirtualKeyDown(9, false)
            wait(2000)
            setVirtualKeyDown(9, true)
            setVirtualKeyDown(9, false)
            wait(700)
            sampSendChat("/invent")
            wait(1000)
            sampSendClickTextdraw(2073)
            wait(1000)
            sampSendClickTextdraw(0xFFFF)
            wait(700)
            sampSendChat("/stats")
            wait(700)            
            sampSendChat("/skill")
            wait(700)
            sampSendChat("/donate")
            wait(700)
            sampAddChatMessage("{ff4500}[Auto-Probiv]: {c0c0c0}КОНСОЛЬ САМПФУНКС ПРОБИТЬ НЕ ЗАБУДЬ, ЕСЛИ НАДО!", 0xff4500)
        end)
        return false
    end
end

function sampev.onShowTextDraw(id, data)
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
        if cfg.fastgun.invisibleinventory then
            return false
        end
	end
end

function sampev.onShowDialog(id, style, title, but_1, but_2, text)
	if info ~= nil then
		if info.step == 3 and string.find(text, "Введите количество") then
			sampSendDialogResponse(id, 1, nil, info.count)
			info = nil
			return false
		end
	end
end

function imgui.OnDrawFrame()
    apply_custom_style()
    if menu.v then
        local xw, yw = getScreenResolution()
        local x, y = 800, 500
        local xs, ys = 755, 475
        imgui.SetNextWindowPos(imgui.ImVec2(xw / 2 - x / 2, yw / 2 - y / 2), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(xs, ys), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'', menu, imgui.WindowFlags.NoResize)
        imgui.Image(wapka, imgui.ImVec2(738, 100))
        imgui.BeginChild("##1", imgui.ImVec2(180, 320), true)
        local btn_size = imgui.ImVec2(-0.1, 0)
        if imgui.Button(u8('Информация'), btn_size) then
            imgui.OpenPopup('##info') 
        end
        ShowHintText('Информация о скрипте')
        imgui.SetNextWindowSize(imgui.ImVec2(900,530))
        if imgui.BeginPopupModal('##info',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
            if imgui.Button(u8'Закрыть окно', btn_size) then
                imgui.CloseCurrentPopup()
            end
            imgui.Text(u8("ИНФА ВАЖДЛЫАД"))
            imgui.EndPopup()
        end
        imgui.Separator()
        if imgui.Button(u8('Сохранить настройки'), btn_size) then
            sampAddChatMessage("{800080}[blessave]: {ffffff}Скрипт {c0c0c0}Ghetto Helper {c0e01f}Все настройки сохранены!", 0x800080)
            saveSettings(false)
            saveBinderSettings(false)
            saveCustomBinds(false)
            saveini()
            saveSKSettings()
        end
        ShowHintText('Сохранение всех настроек')
        if imgui.Button(u8'Обновление', btn_size) then
            lua_thread.create(function()
                downloadUrlToFile(update_url, update_path, function(id, status)
                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        updateini = inicfg.load(nil, update_path)
                        if tonumber(updateini.info.vers) > script_vers then
                            up_text = "{c0c0c0}Доступна новая версия скрипта за {cf87cd}"..updateini.info.vers_text
                            update_state = true
                        else
                            up_text = "{c0c0c0}У вас обновленный скрипт!"
                        end
                        sampAddChatMessage("{800080}[blessave]: {c0c0c0}"..up_text, 0x800080)
                    end
                end)   
            end) 
        end
        ShowHintText('Проверка наличия обновления версии скрипта')
        if update_state then
            if imgui.Button(u8'Обновить?', btn_size) then
                lua_thread.create(function()
                    downloadUrlToFile(script_url, script_path, function(id, status)
                        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            sampAddChatMessage("Скрипт успешно обновлен!", -1)
                            --thisScript():reload()
                        end
                    end)
                    update_state = false
                end)
            end
            ShowHintText('Авто-обновление скрипта. Также новая версия уже опубликована в официальном дискорде нелегаллов SaintRose')
        end
        imgui.Separator()
        if imgui.Button(u8('Лидерам и замам'), btn_size) then
            for i = 0,11 do
                button[i] = false
            end
            button[4] = not button[4]
        end
        ShowHintText('Помощник для лидеров и заместителей банд')
        if imgui.Button(u8('Флудерка'), btn_size) then
            for i = 0,11 do
                button[i] = false
            end
            button[1] = not button[1]
        end
        ShowHintText('Многофункциональная флуд-машина')
        if imgui.Button(u8('Биндер'), btn_size) then
            for i = 0,11 do
                button[i] = false
            end
            button[2] = not button[2]
        end
        ShowHintText('Многофункциональный биндер')
        if imgui.Button(u8('СК-зоны банд'), btn_size) then
            for i = 0,11 do
                button[i] = false
            end
            button[3] = not button[3]
        end
        ShowHintText('Зоны спавнов банд на сервере SaintRose')
        if imgui.Button(u8('Фастган'), btn_size) then
            for i = 0,11 do
                button[i] = false
            end
            button[6] = not button[6]
        end
        ShowHintText('Быстрое доставание оружие из /invent')
        imgui.EndChild()
        ---- 
        imgui.SameLine()
        imgui.BeginChild("##2", imgui.ImVec2(550, 320), true)
        if button[6] then
            if imgui.Button(u8'Сохранить. Это приведет к перезагрузке скрипта.', imgui.ImVec2(-1, 20)) then
                saveFastgunSettings()
                showCursor(false)
                thisScript():reload()
            end
            imgui.Text(u8'Невидимый инвентарь')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##Невидимый инвентарь',fastgun.invisibleinventory) then
                if fastgun.invisibleinventory.v == true then 
                    cfg.fastgun.invisibleinventory = true
                end
                if fastgun.invisibleinventory.v == false then
                    cfg.fastgun.invisibleinventory = false
                end
            end
            imgui.Text(u8"Команды:")
            imgui.InputText(u8'Desert Eagle', fastgun.deagle)
            imgui.InputText(u8'Shotgun', fastgun.shotgun)
            imgui.InputText(u8'MP-5', fastgun.mp5)
            imgui.InputText(u8'AK-47', fastgun.ak47)
            imgui.InputText(u8'M4A1', fastgun.m4a1)
            imgui.InputText(u8'Country Rifle', fastgun.rifle)
            imgui.InputText(u8'Micro-UZI', fastgun.microuzi)
            imgui.InputText(u8'Molotov', fastgun.molotov)
        end
        if button[4] then
            imgui.TextQuestion(u8"Отвечает за включение/выключение всего функционала для лидеров и заместителей")
            imgui.SameLine()
            if imgui.Checkbox('##on/off',lidzam.enabled) then
                cfg.lidzam.enabled = lidzam.enabled.v
                initCommands(not cfg.lidzam.enabled)
            end
            imgui.SameLine()
            if lidzam.enabled.v then
                imgui.Text(u8'Режим лидера/зама включен!')
            else
                imgui.Text(u8'Режим лидера/зама выключен!')
            end
            imgui.Separator()
            imgui.PushItemWidth(100)
            imgui.Text(u8'Название банды')
            imgui.SameLine() 
            if imgui.Combo(u8'##band',lidzam.band, bands, -1) then
                cfg.lidzam.band = lidzam.band.v
                inicfg.save(cfg, "settings_ghettohelper.ini")
            end
            imgui.Separator()
            imgui.PushItemWidth(20)
            imgui.Text(u8'Минимальный lvl для инвайта')
            imgui.SameLine()
            imgui.InputText(u8'##minlvl', lidzam.minlvl)
            imgui.Text(u8'Минимальный ранг для инвайта на печень')
            imgui.SameLine()
            imgui.InputText(u8'##minrank', lidzam.minrank)
            imgui.Separator()
            imgui.PushItemWidth(57) 
            imgui.TextQuestion(u8"Чтобы принять в банду на печеньку - прицельтесь на игрока (ПКМ)\nи нажмите выбранную кнопку.")
            imgui.SameLine()
            imgui.Text(u8'Инвайт на печеньку | ПКМ +')
            imgui.SameLine()
            local tLastKeys = {}
            local _, data = rkeys.getHotKey(customBinds.inv_pech.bindId)
            local keys = {v = _ and data.keys or {}}
            if imgui.HotKey(u8'##Активация inv_pech', keys, tLastKeys, 50) then
                rkeys.changeHotKey(customBinds.inv_pech.bindId, keys.v)
                customBinds.inv_pech.keys = keys.v
            end
            ----
            imgui.TextQuestion(u8"Чтобы принять в банду в капт-состав (8 ранг) - прицельтесь на игрока (ПКМ) и нажмите выбранную кнопку.")
            imgui.SameLine()
            imgui.Text(u8'Инвайт в капт-состав | ПКМ +')
            imgui.SameLine()
            _, data = rkeys.getHotKey(customBinds.inv_capt.bindId)
            keys = {v = _ and data.keys or {}}
            if imgui.HotKey(u8'##Активация inv_capt', keys, tLastKeys, 50) then
                rkeys.changeHotKey(customBinds.inv_capt.bindId, keys.v)
                customBinds.inv_capt.keys = keys.v
            end
            ----
            imgui.TextQuestion(u8"Чтобы выдать ранг - прицельтесь на игрока (ПКМ)\nи нажмите выбранную кнопку.")
            imgui.SameLine()
            imgui.Text(u8'Выдать ранг | ПКМ +')
            imgui.SameLine()
            _, data = rkeys.getHotKey(customBinds.giverank.bindId)
            keys = {v = _ and data.keys or {}}
            if imgui.HotKey(u8'##Активация giverank', keys, tLastKeys, 50) then
                rkeys.changeHotKey(customBinds.giverank.bindId, keys.v)
                customBinds.giverank.keys = keys.v
            end
            ----
            imgui.TextQuestion(u8"Чтобы выдать скин - прицельтесь на игрока (ПКМ)\nи нажмите выбранную кнопку.")
            imgui.SameLine()
            imgui.Text(u8'Выдать скин | ПКМ +')
            imgui.SameLine()
            _, data = rkeys.getHotKey(customBinds.giveskin.bindId)
            keys = {v = _ and data.keys or {}}
            if imgui.HotKey(u8'##Активация giveskin', keys, tLastKeys, 50) then
                rkeys.changeHotKey(customBinds.giveskin.bindId, keys.v)
                customBinds.giveskin.keys = keys.v
            end
            imgui.Separator()
            imgui.TextQuestion(u8"Отвечает за включение/выключение авто-увольнения.\nРаботает только, когда вы в игре или с анти-афк.")
            imgui.SameLine()
            if imgui.Checkbox('##onAU/offAU',lidzam.autouninv) then
                cfg.lidzam.autouninv = lidzam.autouninv.v
            end
            imgui.SameLine()
            if lidzam.autouninv.v then
                imgui.Text(u8'Авто-увольнение включено!')
            else
                imgui.Text(u8'Авто-увольнение выключено!')
            end
            imgui.Separator()
            imgui.Columns(4)
            imgui.SetColumnWidth(-1, 130); imgui.Text(u8'Вспомогательные\nкоманды'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 100);             
            imgui.TextQuestion(u8"Aвто-пробив для фрапса, всё кроме консоли SF. Для корректной работы не используйте в машине.")
            imgui.SameLine()
            imgui.Text(u8'/probiv')
            imgui.TextQuestion(u8"Увольняет игрока с указанным id по причине 'Выселен'")
            imgui.SameLine()
            imgui.Text(u8'/fu id'); imgui.NextColumn()
            imgui.TextQuestion(u8"Заменяет /giverank")
            imgui.SameLine()
            imgui.Text(u8'/gr id rank')
            imgui.TextQuestion(u8"Заменяет /giveskin")
            imgui.SameLine()
            imgui.SetColumnWidth(-1, 100); 
            imgui.Text(u8'/gs id skinid'); imgui.NextColumn()
            imgui.TextQuestion(u8"Заменяет /members")
            imgui.SameLine()
            imgui.Text(u8'/mb')
            imgui.TextQuestion(u8"Заменяет /fmute")
            imgui.SameLine()
            imgui.Text(u8'/fm id time reason')

            imgui.Columns(1)
            imgui.Separator()
            imgui.TextQuestion(u8"Открывает серверное меню лидера и заместителей")
            imgui.SameLine()
            imgui.Text(u8'/lmenu')
            imgui.SameLine()
            _, data = rkeys.getHotKey(customBinds.lmenu.bindId)
            keys = {v = _ and data.keys or {}}
            if imgui.HotKey(u8'##Активация lmenu', keys, tLastKeys, 50) then
                rkeys.changeHotKey(customBinds.lmenu.bindId, keys.v)
                customBinds.lmenu.keys = keys.v
            end
            imgui.Separator()
        end
        if button[1] then
            imgui.Columns(5)
            imgui.SetColumnWidth(-1, 50); imgui.Text(u8'Статус'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 80); imgui.Text(u8'Команда'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 80); imgui.Text(u8'Действие'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 220); imgui.Text(u8'Текст'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 200); imgui.Text(u8'Задержка (сек)'); imgui.NextColumn()
            imgui.Separator()
            for k, bind in pairs(binds) do
                imgui.ToggleButton(string.format('##toggle%d', k), bind.enabled); imgui.NextColumn()
                imgui.Text(string.format('/flood %d', k)); imgui.NextColumn()
                if imgui.Button(string.format(u8'Удалить##del%d', k)) then
                    table.remove(binds, k)
                    break
                end
                imgui.NextColumn()
                imgui.InputText(string.format('##text%d', k), bind.message); imgui.NextColumn()
                imgui.InputInt(string.format('##delay%d', k), bind.delay); imgui.NextColumn()
                imgui.Separator()
            end
            imgui.Columns(1)
            if imgui.Button(u8'Добавить флудер', imgui.ImVec2(-1, 20)) then
                local bind = {
                    enabled = imgui.ImBool(false),
                    message = imgui.ImBuffer(128),
                    delay = imgui.ImInt(1),
                    timeSinceSend = 0
                }
                table.insert(binds, bind)
            end
        end
        if button[2] then
            imgui.Columns(5)
            imgui.SetColumnWidth(-1, 50); imgui.Text(u8'Статус'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 80); imgui.Text(u8'Отправлять'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 100); imgui.Text(u8'Клавиша'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 75); imgui.Text(u8'Действие'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 170); imgui.Text(u8'Бинд'); imgui.NextColumn()
            imgui.Separator()
            for k, bind in pairs(bbinds) do
                imgui.ToggleButton(string.format('##toggle%d', k), bind.enabled); imgui.NextColumn()
                imgui.ToggleButton(string.format('##send%d', k), bind.send); imgui.NextColumn()
                local _, data = rkeys.getHotKey(bind.bindId)
                local keys = {v = _ and data.keys or {}}
                if imgui.HotKey(string.format('##hotkey%d', k), keys, tLastKeys, 85) then
                    rkeys.changeHotKey(bind.bindId, keys.v)
                    bind.keys = keys.v
                end
                imgui.NextColumn()
                if imgui.Button(string.format(u8'Удалить##del%d', k)) then
                    rkeys.unRegisterHotKey(bind.keys)
                    table.remove(bbinds, k)
                    break
                end 
                imgui.NextColumn()
                imgui.PushItemWidth(150)
                imgui.InputText(string.format('##text%d', k), bind.message); imgui.NextColumn()
                imgui.Separator()
            end
            imgui.Columns(1)
            if imgui.Button(u8'Добавить бинд', imgui.ImVec2(-1, 20)) then
                bnId = bnId + 1
                local bind = {
                    id = bnId,
                    enabled = imgui.ImBool(true),
                    message = imgui.ImBuffer(256),
                    keys = {},
                    send = imgui.ImBool(true),
                    bindId = rkeys.registerHotKey({}, 1, true, onBindCallback)
                }
                table.insert(bbinds, bind)
            end
        end
        if button[3] then
            imgui.Columns(2)
            imgui.SetColumnWidth(-1, 50); imgui.Text(u8'Статус'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 200); imgui.Text(u8'Банда'); imgui.NextColumn()
            imgui.Separator()
            local i = 0
            for k, group in pairs(object_groups) do
                i = i + 1
                if imgui.Checkbox(string.format('##status%d', i), imgui.ImBool(doesGroupEnabled(k))) then
                    if doesGroupEnabled(k) then unloadGroup(k) else loadGroup(k) end
                end
                imgui.NextColumn()
                imgui.Text(u8(k)); imgui.NextColumn()
            end
            imgui.Columns(1)
        end
        imgui.EndChild()
        imgui.SetCursorPosX((735 - imgui.CalcTextSize(TextHint.v).x) / 2)
        if #TextHint.v > 0 then
            imgui.Text(TextHint.v)
        end
        imgui.End()
    end
end

function loadCustomBinds()
    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    local file = dir .. '/settings_ghettohelper.json'
    if doesFileExist(file) then 
        local f = io.open(file, 'r')
        customBinds = decodeJson(f:read('*a')) 
        
        customBinds.lmenu['bindId'] = rkeys.registerHotKey(customBinds.lmenu.keys, 1, true, function() 
            if cfg.lidzam.enabled and isKeyCheckAvailable() then
                sampSendChat("/lmenu")
            end 
        end)
        customBinds.inv_pech['bindId'] = rkeys.registerHotKey(customBinds.inv_pech.keys, 1, true, function() 
            if cfg.lidzam.enabled then
                targetfunc(1)
            end
        end)
        customBinds.inv_capt['bindId'] = rkeys.registerHotKey(customBinds.inv_capt.keys, 1, true, function() 
            if cfg.lidzam.enabled then
                targetfunc(2)
            end
        end)
        customBinds.giveskin['bindId'] = rkeys.registerHotKey(customBinds.giveskin.keys, 1, true, function() 
            if cfg.lidzam.enabled then
                targetfunc(3)
            end
        end)
        customBinds.giverank['bindId'] = rkeys.registerHotKey(customBinds.giverank.keys, 1, true, function() 
            if cfg.lidzam.enabled then
                targetfunc(4)
            end
        end)

        f:close()
    else
        saveCustomBinds(true)
    end
end

function saveCustomBinds(needLoad)
    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
--[[     for k, bind in pairs(customBinds) do
        bind['bindId'] = nil
    end ]]
    dir = dir .. '/settings_ghettohelper.json'
    local f = io.open(dir, 'w')
    f:write(neatjson({
        lmenu = {keys=needLoad and {} or customBinds.lmenu.keys},
        inv_pech = {keys=needLoad and {} or customBinds.inv_pech.keys},
        inv_capt = {keys=needLoad and {} or customBinds.inv_capt.keys},
        giverank = {keys=needLoad and {} or customBinds.giverank.keys},
        giveskin = {keys=needLoad and {} or customBinds.giveskin.keys}
    }, {wrap = 40, arrayPadding = 1}))
    f:close()
    if needLoad then
        loadCustomBinds()
    end
end

function loadBinderSettings()
    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    dir = dir .. '/binder_ghettohelper.json'
    if doesFileExist(dir) then
        local f = io.open(dir, 'r')
        local data = decodeJson(f:read('*a'))
        f:close()
        for k, v in pairs(data) do
            bnId = bnId + 1
            local bind = {
                id = bnId,
                enabled = imgui.ImBool(v.enabled),
                message = imgui.ImBuffer(128),
                keys = v.keys,
                send = imgui.ImBool(v.send),
                bindId = rkeys.registerHotKey(v.keys, 1, true, onBindCallback)
            }
            bind.message.v = v.message
            table.insert(bbinds, bind)
        end
    else
        saveBinderSettings(true)
    end
end

function onBindCallback(bindObj)
    for k, bind in pairs(bbinds) do
        if bind.bindId == bindObj.id then
            if bind.enabled.v and not menu.v and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsCursorActive() then
                if bind.send.v and isKeyCheckAvailable() then
                    sampSendChat(u8:decode(bind.message.v))
                else
                    sampSetChatInputEnabled(true)
                    sampSetChatInputText(u8:decode(bind.message.v))
                end
            end
            break
        end
    end
end

function saveBinderSettings(addExamples)
    if addExamples then
        for i = 1, 3 do
            local bind = {
                id = bnId,
                enabled = imgui.ImBool(true),
                message = imgui.ImBuffer(256),
                send = imgui.ImBool(true),
                keys = {},
                bindId = rkeys.registerHotKey({}, 1, true, onBindCallback)
            }
            bind.message.v = u8(string.format('Тестовое сообщение #%d', i))
            table.insert(bbinds, bind)
        end
    end

    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    dir = dir .. '/binder_ghettohelper.json'

    local data = {}
    for k, bind in pairs(bbinds) do
        local _, kData = rkeys.getHotKey(bind.bindId)
        table.insert(data, {
            enabled = bind.enabled.v,
            message = bind.message.v,
            send = bind.send.v,
            keys = _ and kData.keys or {}
        })
    end 

    local f = io.open(dir, 'w')
    f:write(neatjson(data, {wrap = 40, arrayPadding = 1}))
    f:close()
end

function loadSettings() 
    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    local file = dir .. '/flooder_ghettohelper.json'
    if doesFileExist(file) then
        local f = io.open(file, 'r')
        local data = decodeJson(f:read('*a'))
        f:close()
        for k, v in pairs(data) do
            local bind = {
                enabled = imgui.ImBool(false),
                message = imgui.ImBuffer(128),
                delay = imgui.ImInt(v.delay),
                timeSinceSend = 0
            }
            bind.message.v = v.message
            table.insert(binds, bind)
        end
    else
        saveSettings(true)
    end
end

function saveSettings(addExamples)
    if addExamples then
        for i = 1, 3 do
            local bind = {
                enabled = imgui.ImBool(false),
                message = imgui.ImBuffer(128),
                delay = imgui.ImInt(10 * i),
                timeSinceSend = 0
            }
            bind.message.v = u8(string.format('Тестовое сообщение #%d', i))
            table.insert(binds, bind)
        end
    end

    local dir = getWorkingDirectory() .. '/config'
    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    dir = dir .. '/flooder_ghettohelper.json'
 
    local data = {}
    for k, bind in pairs(binds) do
        table.insert(data, {
            message = bind.message.v,
            delay = bind.delay.v
        })
    end

    local f = io.open(dir, 'w')
    f:write(neatjson(data, {wrap = 40, arrayPadding = 1}))
    f:close()
end

function sampev.onServerMessage(color, text)
	if cfg.lidzam.enabled then
        if text:find('(%w+_%w+) принял ваше предложение вступить к вам в организацию') and color == 1941201407 then
            local ainv_nick = text:match('%w+_%w+')  
            local ainv_nickk = string.gsub(ainv_nick, "_", " ")
            lua_thread.create(function()
                sampSendChat(string.format("/me передал %s бандану %s", ainv_nickk, banda))
                wait(1000)
                if captsostav then 
                    sampSendChat(string.format('/giverank %s 8', ainv_nick))  
                    captsostav = false
                else
                    sampSendChat(string.format('/giverank %s %s', ainv_nick, cfg.lidzam.minrank))
                end
            end)
        end
        if cfg.lidzam.autouninv then
            local words = {
                "УВАЛ",
                "ПСЖ",
                "псж",
                "увольте",
                "увол",
                "увал",
                "Увал",
                "Псж",
                "Увол"
            }
            if text:find('%[F%] ') and (text:find('%(%( УВАЛ %)%)') or text:find('%(%( увал %)%)')) and color == 766526463 then
                local rank, nick, bandid = text:match('%[F%] (.+) (%w+_%w+)%[(%d+)%]:')
               -- sampAddChatMessage(text, 0xc0c0c0)
                lua_thread.create(function()
                    wait(100)
                    sampSendChat('/uninvite '..bandid..' Выселен (авто-увал)')
                end)
            end
            if text:find('%[F%] ') and color == 766526463 then
                for k, word in pairs(words) do
                    if text:find(word) then
                        lua_thread.create(function()
                            wait(100)
                            sampSendChat("/f [Auto-uninvite]: Для того, чтобы уволиться ПСЖ напишите в чат: /fb УВАЛ")
                        end)
                    end
                end
            end
        end
    end
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


function onScriptTerminate(script, quit) 
    if script == thisScript() then
        sampAddChatMessage("{800080}[blessave]: {ffffff}Скрипт {c0c0c0}Ghetto Helper {a50324}Выключен!", 0x800080)
        for k, group in pairs(createdObjects) do
            for l, object in pairs(group) do
                deleteObject(object)
            end
        end 
        os.remove(update_path) 
    end  
end

function loadGroup(name)
    if not doesGroupEnabled(group) then
        for k, group in pairs(object_groups) do
            if k == name then
                createdObjects[k] = {}
                for l, object in pairs(group) do
                    requestModel(object.modelId)
                    loadAllModelsNow()
                    local obj = createObject(object.modelId, object.position.x, object.position.y, object.position.z)
                    setObjectRotation(obj, object.rotation.x, object.rotation.y, object.rotation.z)
                    table.insert(createdObjects[k], obj)
                end
            end
        end
    end
end

function unloadGroup(name)
    for k, group in pairs(createdObjects) do
        if k == name then
            for l, object in pairs(group) do
                deleteObject(object)
            end
            createdObjects[k] = nil
            return
        end
    end
end

function doesGroupEnabled(name)
    for k, group in pairs(createdObjects) do
        if k == name then
            return true
        end
    end
    return false
end

function loadSKSettings()
    if not doesDirectoryExist(getWorkingDirectory() .. '/config') then
        createDirectory(getWorkingDirectory() .. '/config')
    end
    if doesFileExist(getWorkingDirectory() .. '/config/skzones_ghettohelper.json') then
        local f = io.open(getWorkingDirectory() .. '/config/skzones_ghettohelper.json', 'r')
        local data = decodeJson(f:read('*a'))
        --object_groups = data.groups
        enabledGroups = data.enabledGroups
        f:close()
        for k, group in pairs(enabledGroups) do
            loadGroup(group)
        end
    else
        saveSKSettings()
    end
end

function saveSKSettings()
    if not doesDirectoryExist(getWorkingDirectory() .. '/config') then
        createDirectory(getWorkingDirectory() .. '/config')
    end
    local data = {
       -- groups = {},
        enabledGroups = {}
    }
   -- data.groups = object_groups
    for k, group in pairs(createdObjects) do
        table.insert(data.enabledGroups, k)
    end
    local f = io.open(getWorkingDirectory() .. '/config/skzones_ghettohelper.json', 'w')
    f:write(neatjson(data, {wrap = 40, arrayPadding = 1}))
    f:close()
end

function saveini()
    cfg.lidzam.enabled = lidzam.enabled.v
    cfg.lidzam.autouninv = lidzam.autouninv.v
    cfg.lidzam.minrank = lidzam.minrank.v
    cfg.lidzam.minlvl = lidzam.minlvl.v
    cfg.lidzam.band = lidzam.band.v

    saved = inicfg.save(cfg,'settings_ghettohelper.ini')
end

function imgui.TextQuestion(text)
	imgui.TextDisabled(u8'(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function ShowHintText(text)
    if imgui.IsItemHovered() then
        TextHint.v = u8(''..text)
    elseif not imgui.IsAnyItemHovered() then 
        TextHint.v = ''
    end
end

function apply_custom_style()
    local style = imgui.GetStyle()
	local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00);
    colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
    colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
    colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
    colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
    colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
    colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
    colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
    colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
    colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
    colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
    colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
    colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
    colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
    colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
    colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24); 
    colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
    colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
    colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
    colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
    colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
    colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
    colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
    colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
    colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
    colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
    colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
    colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
    colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
    colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end