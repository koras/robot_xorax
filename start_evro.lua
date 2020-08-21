
-- Евро/доллар


-- https://www.lua.org/ftp/
-- Бесплатный робот торгующий в боковике "robot XoraX"
-- https://t.me/robots_xorax 

dofile(getScriptPath() .. "\\setting\\path.lua");

dofile(getScriptPath() .. "\\setting\\work_evro.lua")
dofile(getScriptPath() .. "\\setting\\engine.lua")
dofile(getScriptPath() .. "\\modules\\start_engine.lua")


function OnInit()
    EngineInit()
end
  
function main()
    EngineMain()
end
 

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade показывает статусы сделок.
-- Функция вызывается терминалом когда с сервера приходит информация по заявке 
function OnOrder(order)
    EngineOrder(order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function OnTrade(trade)
    EngineTrade(trade)
end
 

-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function OnStopOrder(trade)
    EngineStopOrder(trade)
end

function OnTransReply(trans_reply) 
    EngineTransReply(trans_reply)
end

function OnStop()
    EngineStop()
end
 