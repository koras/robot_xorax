-- базовые функции, чтобы не переносить с одного файла в другой



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


function update()
    control.stats();
    market.setLitmitBid();
end


function EngineStop()
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

 
function eventTranc(price, datetime, levelLocal, event)
    -- buy or sell
    -- long(price_long, datetime, levelLocal , event)
    -- collbackFunc( price, countingTicsVolume, datetime, 'buy');
    market.decision(price, datetime, levelLocal, event);
end

function EngineOrder(order)
    
    loger.save("OnOrder NUMBER   = " .. tostring(order.order_num)); -- NUMBER 

    if bit.band(order.flags, 0) and bit.band(order.flags, 1) then

        loger.save("OnOrder 0  stop order.order_num " .. order.order_num)
        loger.save("OnOrder 0 stop trans_id " .. order.trans_id)
    end

    if bit.band(order.flags, 0) then

        loger.save("OnOrder 1 stop order.order_num " .. order.order_num)
    end

    if bit.band(order.flags, 1) then
        loger.save("OnOrder 3 stop order.order_num " .. order.order_num)
    end

    if not bit.band(order.flags, 0) and not bit.band(order.flags, 1) then
        loger.save("OnOrder stop 5 order.price " .. order.order_num)
    end

    if bit.test(order.flags, 0) then

        if del and order.trans_id ~= 0 then
            stopOrder_num = order.order_num
            type = "KILL_ORDER";
            transId_del_order = order.trans_id
            --  transaction.delete(transId_del_order,stopOrder_num, type)
            loger.save('  order.order_num ' .. order.order_num ..
                           '  order.trans_id ' .. order.trans_id)

            del = false;
        end

    else
        loger.save(' return OnStopOrder ')
        return;
        --  riskStop.appruveOrderStop(trade)
    end

    -- ���� ��������� Buy, ���������� ����� ������ � �������� �������
    if order.trans_id == BuyUniqTransID and BuyOrderNum == 0 then
        BuyOrderNum = order.order_num;
    end
    -- ���� ��������� Sell, ���������� ����� ������ � �������� �������
    if order.trans_id == SellUniqTransID and SellOrderNum == 0 then
        SellOrderNum = order.order_num;
    end

    loger.save("OnOrder");

    if bit.band(order.flags, 3) == 0 then

        if bit.band(order.flags, 2) == 0 then

        else
            loger.save("SELL SELL SELL SELL SELL ");

        end

        -- trans_id
    end

    if bit.band(order.flags, 1) + bit.band(order.flags, 2) == 0 then

        loger.save("��������� loger.save(  order.price " ..
                       order.price)

    end
end





function EngineTrade(trade)

    loger.save('OnTrade ' .. trade.order_num)

    riskStop.updateOrderNumber(trade);

    local sell = bit.band(trade.flags, 1);

    if (sell == 0) then end

    if bit.band(trade.flags, 2) == 0 then
        -- исполняется покупка контракта 
        market.buyContract(trade);
    else

        loger.save(
            'OnTrade исполняется покупка контракта 1')
        market.sellContract(trade);
    end

    if not bit.band(trade.flags, 0) and not bit.band(trade.flags, 1) then

        if bit.band(trade.flags, 2) == 0 then
            -- исполняется покупка контракта 
            market.buyContract(trade);
        else
            loger.save('OnTrade исполняется покупка контракта 2')
            market.sellContract(trade);
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


function getPrice()
    SEC_PRICE_STEP = tostring(getParamEx2(setting.CLASS_CODE, setting.SEC_CODE,       "SEC_PRICE_STEP").param_value);
    if GET_GRAFFIC then
    else
        Run = false;
    end
end

function EngineMain()

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

-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function EngineStopOrder(trade)
    -- заявку выставили и приходит коллбек выставленой заявки 
    -- это просто заявка а не лимитка
    market.saleExecutionStopOrder(trade);

    -- обновляем номера стоп заявок при выставлении
    --  loger.save(' OnStopOrder -- обновляем номера стоп заявок при выставлении   '.. trade.trans_id   )

    -- http://luaq.ru/OnStopOrder.html
    --   riskStop.updateOrderNumber(trade);

    if bit.band(trade.flags, 4) > 0 then
        if not bit.band(trade.flags, 0) and not bit.band(trade.flags, 1) then
            --    loger.save('вызываем 11 riskStop.appruveOrderStop '.. trade.trans_id );

            if bit.band(trade.flags, 8) then
                --      loger.save('вызываем  bit.band(trade.flags, 8 '.. trade.trans_id );

            else
                --     loger.save('вызываем  riskStop.appruveOrderStop false '.. trade.trans_id );
            end
            if trade.stop_order_type == 1 and bit.band(trade.flags, 8) then
                --     loger.save('вызываем  222 riskStop.appruveOrderStop '.. trade.trans_id );
                --  riskStop.appruveOrderStop(trade)
            end

        end

    else
        -- заявка на покупку 
    end

    if not bit.band(trade.flags, 0) and not bit.band(trade.flags, 1) then
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


function EngineInit()
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
 
end


function EngineTransReply(trans_reply)


end