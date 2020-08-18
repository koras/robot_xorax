-- ������ ��� ������������

dofile(getScriptPath() .. "\\setting\\path.lua");

dofile(getScriptPath() .. "\\setting\\engine.lua");
dofile(getScriptPath() .. "\\setting\\work_br.lua")

local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
-- local vecm = dofile(getScriptPath() .. "\\modules\\vector.lua");
local v3 = dofile(getScriptPath() .. "\\modules\\Vec3.lua");

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

local market = dofile(getScriptPath() .. "\\shop\\market.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local test_bids = dofile(getScriptPath() .. "\\tests\\test_bids.lua");

local riskStop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");

local Run = true;

function init()

    --  tradeSignal.setRange(RangeSignal);
    --   control.show();

end

local Size = 0;
function OnInit() end
  

function main()

 

    -- type = "NEW_ORDER";
    local direction = 4;
    local quantity = 1;
    --   res =  transaction.send("BUY", 43.10, 1, type, 0,  direction);
    res = transaction.sendStop("BUY", 44.60, quantity, direction);
    -- res =  transaction.sendStop("SELL", 43.10, quantity , direction );

    loger.save("res 1 " .. res);
    n = getNumberOf("orders")
    order = {}
    for i = 0, n - 1 do
        order = getItem("orders", i)
        r = "order: num=" .. tostring(order["order_num"]) .. " qty=" ..
                tostring(order["qty"]) .. " value=" .. tostring(order["value"])
    end
    while Run do end
end
 

del = true;

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

function OnOrder(order)
    EngineOrder(order)
end

function OnTrade(trade)

    loger.save('OnTrade')
    loger.save("OnTrade OnTrade trade.trans_id " .. tostring(trade.trans_id)); -- NUMBER
    loger.save("OnTrade OnTrade trade.trade_num " .. tostring(trade.trade_num)); -- NUMBER  
    loger.save("OnTrade OnTradetrade.order_num " .. tostring(trade.order_num)); -- NUMBER   

    local sell = bit.band(trade.flags, 1);

    if (sell == 0) then end

    if not bit.band(trade.flags, 0) and not bit.band(trade.flags, 1) then
        loger.save(
            'OnTrade 111 �������� 11 riskStop.appruveOrderStop ' ..
                trade.trans_id);

        if bit.band(trade.flags, 8) then
            loger.save(
                'OnTrade 222  ��������  CheckBit(trade.flags, 8 ' ..
                    trade.trans_id);

        else
            loger.save(
                'OnTrade 333 ��������  riskStop.appruveOrderStop false ' ..
                    trade.trans_id);
        end
        if trade.stop_order_type == 1 and bit.band(trade.flags, 8) then
            loger.save('OnTrade 444  riskStop.appruveOrderStop ' ..
                           trade.trans_id);

        end

    else
        -- ������ �� ������� 
    end

    if bit.band(trade.flags, 2) == 0 then

        -- loger.save('OnTrade end 222  --  ' .. tostring(trade.trans_id) ..
        --                "   == " .. tostring(trade.order_num))
    else
     --   loger.save('OnTrade end 111  ')

    end

    if not bit.band(trade.flags, 0) and not bit.band(trade.flags, 1) then

        if bit.band(trade.flags, 2) == 0 then
            -- ����������� ������� ��������� 

        end
    end

end
 

-- ������� ���������� ���������� ����� � ������� �������� ���������� �� ������
function OnStopOrder(trade)

    --  loger.save(' OnStopOrder' )
    loger.save(" QUIK " .. tostring(trade.order_num)); -- NUMBER    

    if bit.test(trade.flags, 0) then

        stopOrder_num = trade.order_num
        type = "KILL_STOP_ORDER";
        transId_del_order = trade.trans_id
        --  transaction.delete(transId_del_order,stopOrder_num, type)
    else
        loger.save(' return OnStopOrder ' .. trade.trans_id ..
                       "  stop_order.order_num " .. trade.order_num)
        return;
        --  riskStop.appruveOrderStop(trade)
    end

    if bit.band(trade.flags, 4) > 0 then

        if not bit.test(trade.flags, 0) and not bit.test(trade.flags, 1) then
            loger.save('������ 11111 �' .. trade.order_num ..
                           ' appruve Sell Sell Sell')

            --  riskStop.appruveOrderStop(trade)
        end

        -- ������ �� �������
        loger.save(' trade.flags Sell ')
    else
        -- ������ �� �������
        loger.save(' trade.flags Buy ')
    end

    if not bit.test(trade.flags, 0) and not bit.test(trade.flags, 1) then
    --    loger.save('������ 11111 �' .. trade.order_num ..' appruve')
    end

    if bit.test(trade.flags, 15) then
        loger.save(' calculation 1 ' .. trade.order_num .. ' condition ' ..
                       tostring(trade.condition))
        loger.save(' calculation 1 ' .. trade.order_num .. ' trans_id ' ..
                       tostring(trade.trans_id))
        loger.save(
            ' calculation 1 .condition_price ' .. trade.condition_price ..
                ' condition ' .. tostring(trade.linkedorder))

    else
        loger.save(' calculation 2 ' .. trade.order_num .. ' trans_id ' ..
                       tostring(trade.trans_id))
        loger.save(' calculation 2 ' .. trade.order_num .. ' .condition' ..
                       tostring(trade.condition))
        loger.save(
            ' calculation 2 .condition_price ' .. trade.condition_price ..
                ' .condition' .. tostring(trade.linkedorder))

    end
end

 

function OnTransReply(trans_reply)
    loger.save('OnTransReply  ' .. trans_reply.order_num);
    loger.save('OnTransReply server_trans_id	  ' .. trans_reply.server_trans_id);

end

function OnStop() Run = false; end
 