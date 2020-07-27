-- scriptTest.lua (in your scripts directory)
local M = {}
local Transaction = {}

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

local  function setTransDefault()

    Transaction = {}
    Transaction.CLASSCODE = setting.CLASS_CODE;
    Transaction.SECCODE = setting.SEC_CODE;
    Transaction.ACCOUNT = setting.ACCOUNT;
    Transaction.USE_CASE_SENSITIVE_CONSTANTS = 'PROGRAM';
    Transaction.CLIENT_CODE = setting.comment_quik;
    Transaction.EXPIRY_DATE = "TODAY";
end

 function send(typeMarket, price, quantity, type, trans_id_buy, direction)

    setTransDefault();

    loger.save("send = " .. tostring(Transaction.CLASSCODE));
    loger.save("send = " .. tostring(Transaction.SECCODE));
    loger.save("send = " .. tostring(Transaction.ACCOUNT));
    loger.save("send = " .. tostring(setting.SEC_CODE));

    local operation = "S"
    if typeMarket == "BUY" then operation = "B" end

    local trans_id = random_max();

    -- https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/

    -- http://luaq.ru/sendTransaction.html
 
    Transaction.TYPE = 'L';

    Transaction.trans_id = tostring(trans_id);
    Transaction.ACTION = 'NEW_ORDER';
    Transaction.OPERATION = operation; --  ("B" - buy, ??? "S" - sell)

    Transaction.QUANTITY = tostring(quantity)
    Transaction.PRICE = tostring(price)

    --	 if type == "TAKE_PROFIT_AND_STOP_LIMIT_ORDER" then 
    if type == "TAKE_PROFIT_STOP_ORDER" then

        Transaction.STOP_ORDER_KIND = type;
        Transaction.ACTION = "NEW_STOP_ORDER";
        Transaction.OFFSET_UNITS = "PRICE_UNITS";
        Transaction.STOPPRICE = tostring(price);
        Transaction.STOPPRICE2 = tostring(price);
        Transaction.OFFSET = tostring(setting.take_profit_offset);
        Transaction.KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO";
        Transaction.USE_BASE_ORDER_BALANCE = "NO";
        Transaction.ACTIVATE_IF_BASE_ORDER_PARTLY_FILLED = "YES";
        Transaction.BASE_ORDER_KEY = tostring(trans_id_buy);
        Transaction.SPREAD = tostring(setting.take_profit_spread);
        Transaction.SPREAD_UNITS = "PRICE_UNITS";

        loger.save('Transaction.STOP_ORDER_KIND ' .. Transaction.STOP_ORDER_KIND);
        loger.save('Transaction.BASE_ORDER_KEY ' .. Transaction.BASE_ORDER_KEY);

    elseif type == "SIMPLE_STOP_ORDER" then

        local direction = tostring(direction);
        Transaction.ACTION = "NEW_STOP_ORDER";
        Transaction.CONDITION = direction;
        Transaction.STOPPRICE = tostring(price);
        Transaction.STOP_ORDER_KIND = type;

    elseif type == "NEW_ORDER" then

        Transaction.PRICE = tostring(price);
    end

    local res = sendTransaction(Transaction);
    message('res 3 ' .. tostring(res));

    if res ~= "" then
        message("res 2 " .. res);
        loger.save('Transaction  ' .. res)
        return nil, res

    else
        return trans_id;
    end

end

function delete(transId_del_order, stopOrder_num, type)

    setTransDefault();
    Transaction.ACTION = "KILL_STOP_ORDER";

    if type == "TAKE_PROFIT_STOP_ORDER" or type == "KILL_STOP_ORDER" or type ==
        "SIMPLE_STOP_ORDER" then
        Transaction.ACTION = "KILL_STOP_ORDER";
        --	elseif type == 'NEW_ORDER' then
        --		Transaction.ACTION = "KILL_ORDER";
    else
        Transaction.ACTION = "KILL_ORDER";
    end

    Transaction.TRANS_ID = tostring(transId_del_order);
    Transaction.STOP_ORDER_KEY = tostring(stopOrder_num);
    Transaction.ORDER_KEY = tostring(stopOrder_num);
    Transaction.TYPE = "L";

    loger.save("Delete :  " .. tostring(transId_del_order) ..
                   "  Transaction.ACTION = " .. tostring(Transaction.ACTION))

    local res = sendTransaction(Transaction)
    if string.len(res) ~= 0 then
        -- message('Error: '..res, 3)
        loger.save("Delete: fail " .. tostring(res))
    else
        loger.save("Delete: " .. tostring(stopOrder_num) .. " success ")
    end
end

function sendStop(typeMarket, priceParam, quantity, direction)

    setTransDefault();
    local price = ""
    local STOPPRICE = tostring(priceParam)

    local operation = "S"
    if typeMarket == "BUY" then
        operation = "B"
        price = tostring(priceParam + 1);
    else
        price = tostring(priceParam - 1);

    end

    local trans_id = random_max();

    -- https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/
    -- http://luaq.ru/sendTransaction.html

    Transaction.TYPE = 'L';
    Transaction.trans_id = tostring(trans_id);
    Transaction.OPERATION = operation; --  ("B" - buy, OR "S" - sell)

    Transaction.QUANTITY = tostring(quantity);
    Transaction.PRICE = price;
    Transaction.ACTION = "NEW_STOP_ORDER";

    --  Направленность стоп-цены. Возможные значения: «4» — меньше или равно, «5» – больше или равно
    Transaction.CONDITION = tostring(direction);
    Transaction.STOPPRICE = STOPPRICE;
    Transaction.STOP_ORDER_KIND = "SIMPLE_STOP_ORDER";

    local res = sendTransaction(Transaction);
    loger.save('sendStop ' .. tostring(res))

    if res ~= "" then
        message("res 2 " .. res);
        loger.save('Transaction  ' .. res)
        return nil, res

    else
        loger.save('===============')
        loger.save('Выставляем стоп  trans_id=' ..
                       tostring(trans_id))
        return trans_id;
    end

end

function random_max()

    local res = (16807 * (RANDOM_SEED or 137137)) % 2147483647
    RANDOM_SEED = res
    return res
end

M.delete = delete
M.send = send
M.sendStop = sendStop

return M
