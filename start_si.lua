

-- Доллар/рубль


-- https://www.lua.org/ftp/
-- Бесплатный робот торгующий в боковике "robot XoraX"
-- https://t.me/robots_xorax 

 
-- stopClass = {};
-- engine = {};
local path = getScriptPath();


dofile(path .. "\\setting\\path.lua");


local setting  = dofile(path .. "\\setting\\work_si.lua");
--local settingEngine = dofile(getScriptPath() .. "\\setting\\work_si.lua");

local engineData = dofile(path .. "\\setting\\engine.lua");
local engineModule = dofile(path .. "\\modules\\start_engine.lua");

function OnInit()
    engineModule.EngineInit(setting, engineData);
end
 
 

function main()
    engineModule.EngineMain(setting)
end
 

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade показывает статусы сделок.
-- Функция вызывается терминалом когда с сервера приходит информация по заявке 
local function OnOrder(order)
    engineModule.EngineOrder(setting, order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- Функция вызывается терминалом когда с сервера приходит информация по сделке
local function OnTrade(trade)
    engineModule.EngineTrade(setting, trade)
end
 

-- Функция вызывается терминалом когда с сервера приходит информация по сделке
local function OnStopOrder(trade)
    engineModule.EngineStopOrder(setting, trade)
end

 
local function OnTransReply(trans_reply) 
    engineModule.EngineTransReply(setting, trans_reply)
end

local function OnStop()
    engineModule.EngineStop(setting )
end