-- https://www.lua.org/ftp/
-- Бесплатный робот торгующий в боковике "robot XoraX"
-- https://t.me/robots_xorax 
local lua51path = "C:\\Program Files (x86)\\Lua\\5.1\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

package.cpath = "./?.dll;./?51.dll;" .. lua51path .. "?.dll;" .. lua51path ..
                    "?51.dll;" .. lua51path .. "clibs/?.dll;" .. lua51path ..
                    "clibs/?51.dll;" .. lua51path .. "loadall.dll;" .. lua51path ..
                    "clibs/loadall.dll;" .. package.cpath
package.path = package.path .. ";./?.lua;" .. lua51path .. "lua/?.lua;" ..
                   lua51path .. "lua/?/init.lua;" .. lua51path .. "?.lua;" ..
                   lua51path .. "?/init.lua;" .. lua51path .. "lua/?.luac;"

require("table")

setting = {};
stopClass = {};
engine = {};

dofile(getScriptPath() .. "\\setting\\work_evro.lua");
dofile(getScriptPath() .. "\\setting\\engine.lua");

local uTransaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");

local candles = dofile(getScriptPath() .. "\\Signals\\candle.lua");
local tradeSignal = dofile(getScriptPath() .. "\\Signals\\tradeSignal.lua");
local fractalSignal = dofile(getScriptPath() .. "\\Signals\\fractal.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local candleGraff = dofile(getScriptPath() .. "\\interface\\candleGraff.lua");

-- local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local signalShowLog =
    dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
-- local FRACTALS = dofile(getScriptPath() .. "\\LuaIndicators\\FRACTALS.lua"); 
local market = dofile(getScriptPath() .. "\\shop\\market.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local test_bids = dofile(getScriptPath() .. "\\tests\\test_bids.lua");
local test_signal = dofile(getScriptPath() .. "\\tests\\test_signal.lua");

local riskStop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");

Run = true;

function init()

    --  tradeSignal.setRange(RangeSignal);
    --   control.show();

end
 

--Size = 0;
function OnInit()
    riskStop.calculateMaxStopStart();
    panelBids.CreateNewTableBids();
    signalShowLog.CreateNewTableLogEvent();

    local Error = '';
    local ds, Error = CreateDataSource(setting.CLASS_CODE, setting.SEC_CODE,
                                 setting.INTERVAL); 

    if Error ~= "" and Error ~= nil then
        message("Error : " .. Error)
        return
    end
    -- GET_GRAFFIC

    GET_GRAFFIC = ds:SetEmptyCallback();
    --  ds:SetUpdateCallback(MyFuncName);

  --  Size = ds:Size();

    -- local p = tostring(
    --         getParamEx(setting:CLASS_CODE, setting:SEC_CODE, "offer").param_value +
    --             10 *
    --             getParamEx(setting.CLASS_CODE, setting.SEC_CODE,
    --                        "SEC_PRICE_STEP").param_value);
    -- SEC_PRICE_STEP = tostring(getParamEx2(setting.CLASS_CODE, setting.SEC_CODE,
    --                                       "SEC_PRICE_STEP").param_value);
end

function getPrice()

    SEC_PRICE_STEP = tostring(getParamEx2(setting.CLASS_CODE, setting.SEC_CODE,       "SEC_PRICE_STEP").param_value);
    if GET_GRAFFIC then
    else
        Run = false;
    end

end

function eventTranc(price, datetime, levelLocal, event)
    -- buy or sell
    -- long(price_long, datetime, levelLocal , event)

    -- collbackFunc( price, countingTicsVolume, datetime, 'buy');
    market.decision(price, datetime, levelLocal, event);
end

function update()
    control.stats();
    market.setLitmitBid();
end

function main()

    candles.getSignal(updateTick);
    candles.getSignal(market.callSELL_emulation);

    tradeSignal.getSignal(setting.tag, eventTranc);
    --  signalShowLog.CreateNewTableLogEvent();

    loger.save("start");

    -- statsPanel.show();
    panelBids.show();
    update();
    getPrice();
    control.show();

    local Price = false;

    while Run do
        if setting.developer then test_signal.testSendSignalBue(); end

        -- сработал стоп, проверка 

        update();
        --  statsPanel.stats();
        fractalSignal.last();

        if setting.status then
            tradeSignal.getSignal(setting.tag, eventTranc);
            candles.getSignal(updateTick);
        end
    end
end

-- срабатывает при обновлении свечи
function updateTick(result)

    if setting.emulation then
        -- обработка во время эмуляции
        market.callSELL_emulation(result);
        -- сработал стоп в режиме эмуляции
        riskStop.appruveOrderStopEmulation(result)
    end

end

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade показывает статусы сделок.
-- Функция вызывается терминалом когда с сервера приходит информация по заявке 
function OnOrder(order)
    -- только для лимитных заявок
    if order.trans_id == 0 then return end
    loger.save(
        "OnOrder work order_num = " .. order.order_num .. "  trans_id = " ..
            order.trans_id)

    -- присваиваем номера заявкам
    market.saleExecution(order);
    --  riskStop.updateOrderNumber(order); 

    if bit.band(order.flags, 3) == 0 then
        if bit.band(order.flags, 2) == 0 then
        else

            deleteBids.transCallback(order);
        end

        -- trans_id
    end

    if bit.band(order.flags, 1) + bit.band(order.flags, 2) == 0 then
        loger.save('  ')
        loger.save('  ')
        loger.save('  ')
        loger.save('  ')
        loger.save('OnOrder sellContract   ')
        market.sellContract(order);
    end

    if not CheckBit(order.flags, 0) and not CheckBit(order.flags, 1) then
        loger.save("OnOrder stop 1  сработал стоп order_num = " ..
                       order.order_num .. "  trans_id = " .. order.trans_id)
        riskStop.appruveOrderStop(order);
    end

end

-- OnTransReply -> OnTrade -> OnOrder 
-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function OnTrade(trade)

    loger.save('OnTrade ' .. trade.order_num)

    riskStop.updateOrderNumber(trade);

    local sell = CheckBit(trade.flags, 1);

    if (sell == 0) then end

    if bit.band(trade.flags, 2) == 0 then
        -- исполняется покупка контракта 
        market.buyContract(trade);
    else

        loger.save(
            'OnTrade исполняется покупка контракта 1')
        market.sellContract(trade);
    end

    if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then

        if bit.band(trade.flags, 2) == 0 then
            -- исполняется покупка контракта 
            market.buyContract(trade);
        else
            loger.save(
                'OnTrade исполняется покупка контракта 2')
            market.sellContract(trade);
        end
    end

end

-- Функция возвращает true, если бит с номером index флагов flags установлен в 1
function bit_set(flags, index)
    local n = 1;
    n = bit.lshift(1, index);
    if bit.band(flags, n) ~= 0 then
        return true;
    else
        return false;
    end
end

-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function OnStopOrder(trade)
    -- заявку выставили и приходит коллбек выставленой заявки 
    -- это просто заявка а не лимитка
    market.saleExecutionStopOrder(trade);

    -- обновляем номера стоп заявок при выставлении
    --  loger.save(' OnStopOrder -- обновляем номера стоп заявок при выставлении   '.. trade.trans_id   )

    -- http://luaq.ru/OnStopOrder.html
    --   riskStop.updateOrderNumber(trade);

    if bit.band(trade.flags, 4) > 0 then
        if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then
            --    loger.save('вызываем 11 riskStop.appruveOrderStop '.. trade.trans_id );

            if CheckBit(trade.flags, 8) then
                --      loger.save('вызываем  CheckBit(trade.flags, 8 '.. trade.trans_id );

            else
                --     loger.save('вызываем  riskStop.appruveOrderStop false '.. trade.trans_id );
            end
            if trade.stop_order_type == 1 and CheckBit(trade.flags, 8) then
                --     loger.save('вызываем  222 riskStop.appruveOrderStop '.. trade.trans_id );
                --  riskStop.appruveOrderStop(trade)
            end

        end

    else
        -- заявка на покупку 
    end

    if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then
        --   loger.save(' -- riskStop.updateOrderNumber изменения по стоп заявке, исполнелись наверное  ' )
        --   riskStop.updateOrderNumber(trade)
    end

    if bit.test(trade.flags, 15) then
    else

        loger.save(
            'OnStopOrder->updateStopNumber order_num=' .. trade.order_num ..
                ' trans_id ' .. tostring(trade.trans_id));
        riskStop.updateStopNumber(trade);
    end
end

-- Вызывается движком при полном, или частичном ИСПОЛНЕНИИ ЗАЯВКИ
function SE_OnExecutionOrder(order)
    -- Здесь Ваш код для действий при полном, или частичном исполнении заявки
    -- ...
    -- Выводит сообщение
    loger.save('SE_OnExecutionOrder() БАЛАНС заявки  ' ..
                   order.order_num .. ' изменился с ' ..
                   (order.qty - (order.last_execution_count or 0)) .. ' на ' ..
                   order.balance)
end

-- успешное ВЫПОЛНЕНИИ ТРАНЗАКЦИИ
function SE_OnTransOK(trans)
    -- Здесь Ваш код для действий при успешном выполнении транзакции
    -- ...
    -- Выводит сообщение
    loger.save('SE_OnTransOK() Транзакция №' .. trans.trans_id ..
                   ' УСПЕШНО выполнена')
end

function OnTransReply(trans_reply) end

function OnStop()

    Run = false;
    control.deleteTable();
    signalShowLog.deleteTable();
    statsPanel.deleteTableStats();
    panelBids.deleteTable();
    candleGraff.deleteTableGraff();

    DelAllLabels(setting.tag);
    -- когда закрываем приложение, надо снять стопы
    riskStop.backStop()

end

-- Функция проверяет установлен бит, или нет (возвращает true, или false)
function CheckBit(flags, _bit)
    -- Проверяет, что переданные аргументы являются числами
    if type(flags) ~= "number" then
        loger.save(
            "Ошибка!!! Checkbit: 1-й аргумент не число!")
    end
    if type(_bit) ~= "number" then
        loger.save(
            "Ошибка!!! Checkbit: 2-й аргумент не число!")
    end

    if _bit == 0 then
        _bit = 0x1
    elseif _bit == 1 then
        _bit = 0x2
    elseif _bit == 2 then
        _bit = 0x4
    elseif _bit == 3 then
        _bit = 0x8
    elseif _bit == 4 then
        _bit = 0x10
    elseif _bit == 5 then
        _bit = 0x20
    elseif _bit == 6 then
        _bit = 0x40
    elseif _bit == 7 then
        _bit = 0x80
    elseif _bit == 8 then
        _bit = 0x100
    elseif _bit == 9 then
        _bit = 0x200
    elseif _bit == 10 then
        _bit = 0x400
    elseif _bit == 11 then
        _bit = 0x800
    elseif _bit == 12 then
        _bit = 0x1000
    elseif _bit == 13 then
        _bit = 0x2000
    elseif _bit == 14 then
        _bit = 0x4000
    elseif _bit == 15 then
        _bit = 0x8000
    elseif _bit == 16 then
        _bit = 0x10000
    elseif _bit == 17 then
        _bit = 0x20000
    elseif _bit == 18 then
        _bit = 0x40000
    elseif _bit == 19 then
        _bit = 0x80000
    elseif _bit == 20 then
        _bit = 0x100000
    end

    if bit.band(flags, _bit) == _bit then
        return true
    else
        return false
    end
end
