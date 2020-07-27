-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта
-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog =
    dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
-- local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
-- local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
-- local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local risk_stop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");
dofile(getScriptPath() .. "\\setting\\work_br.lua");

-- SHORT  = FALSE
-- LONG = true

local DIRECT = 'LONG';

function getRand() return tostring(math.random(2000000000)); end

function setDirect(localDirect) DIRECT = localDirect; end

function setLitmitBid() LIMIT = setting.LIMIT_BID; end
-- price текущая цена
-- levelLocal  сила сигнала
-- event -- продажа или покупка

local level = 1;

-- обновляем транкзакцию для того чтобы при тестировании не отправлялись заросы
function updateTransaction(_transaction) transaction = _transaction; end

-- исполнение покупки контракта
function buyContract(result)
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do
            -- loger.save(setting.sellTable[contract].type);  
            if setting.sellTable[contract].type == 'buy' and
                setting.sellTable[contract].executed == false and
                setting.sellTable[contract].trans_id == result.trans_id then

                signalShowLog.addSignal(result.datetime, 27, false,
                                        setting.sellTable[contract].price);
                setting.sellTable[contract].executed = true;
                -- выставляем на продажу контракт.
                sellTransaction(result, setting.sellTable[contract]);

                return;
            end
        end
    end
end

-- только выставляется заявка на продажу
-- or
-- может вызываеться при срабатывании стопа
function sellTransaction(order, countContracts)

    local type = "TAKE_PROFIT_STOP_ORDER";
    if setting.sell_take_or_limit == false then type = "NEW_ORDER"; end

    local trans_id_sell = getRand();
    --  local price = setting.profit_range + order.price + setting.profit_infelicity;
    local price = setting.profit_range + order.price;

    if setting.emulation == false then
        trans_id_sell = transaction.send("SELL", price, setting.use_contract,
                                         type, order.order_num);
        signalShowLog.addSignal(order.datetime, 9, false, price);
    end

    loger.save('trans_id_sell = ' .. trans_id_sell);
    local data = {
        ['price'] = price,
        ['number'] = 0,
        ['datetime'] = order.datetime,
        ['trans_id'] = trans_id_sell,
        ['order_num'] = order.order_num,
        ['trans_id_buy'] = countContracts.trans_id,

        ['use_contract'] = setting.use_contract,
        ['order_type'] = type,
        ['type'] = 'sell',
        ['work'] = true,
        ['executed'] = false,
        ['emulation'] = setting.emulation,
        ['contract'] = setting.use_contract,
        ['buy_contract'] = order.price -- стоимость покупку
    };
    setting.sellTable[(#setting.sellTable + 1)] = data;
    panelBids.show();
end

-- исполнение продажи по контракту
-- contract - контракт который продали
-- общие расчёты 
function execution_sell(contract)

    -- setting.each_to_buy_step
    -- увеличивает лимит используемых контрактов 

    setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0;

    if contract.contract > 0 and setting.limit_count_buy >= contract.contract then
        setting.limit_count_buy = setting.limit_count_buy - contract.contract;
    end

    setting.count_buyin_a_row = 0;

    -- цена последней продажи контракта
    setting.SPRED_LONG_LOST_SELL = contract.price;

    setting.each_to_buy_step = 0;
    -- сколько исполнилось продаж
    setting.count_sell = setting.count_sell + 1;

    -- падение цены прекратилось
    setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN -
                                        setting.SPRED_LONG_TREND_DOWN_SPRED;

    if setting.SPRED_LONG_TREND_DOWN < 0 then
        setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN_minimal;
    end

    check_buy_status_block();
end

-- присваиваем номер заявке на продажу

function saleExecution(result)
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do
            if setting.sellTable[contract].type == 'sell' and
                setting.sellTable[contract].executed == false and
                setting.sellTable[contract].trans_id == result.trans_id then
                loger.save(
                    "saleExecution  Присваеваем заявке на продажу номер ");
                loger.save("saleExecution  order_num=" .. result.order_num ..
                               " trans_id=" .. result.trans_id .. "  ");
                --  setting.sellTable[contract].executed = true;
                setting.sellTable[contract].order_num = result.order_num
                -- risk_stop.update_stop();
            end
        end
    end

end

function saleExecutionStopOrder(result)
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do
            if setting.sellTable[contract].type == 'sell' and
                setting.sellTable[contract].executed == false and
                setting.sellTable[contract].trans_id == result.trans_id then
                loger.save(
                    "saleExecutionOrder обновляем номер trans_id=" ..
                        result.trans_id .. " order_num=" .. result.order_num);
                --  setting.sellTable[contract].executed = true;
                setting.sellTable[contract].order_num = result.order_num
                --  risk_stop.update_stop();
            end
        end
    end

end

function commonBUY(_price, datetime)
    -- сколько подряд покупок было
    setting.each_to_buy_step = setting.each_to_buy_step + 1;
    -- текущаая свеча
    -- ставим заявку на покупку выше на 0.01
    local price = _price + setting.profit_infelicity; -- и надо снять заявку если не отработал

    setting.candles_buy_last = setting.number_of_candles;

    if setting.emulation then
        signalShowLog.addSignal(datetime, 20, false, price);
        setting.count_buyin_a_row_emulation =
            setting.count_buyin_a_row_emulation + 1;
    else
        signalShowLog.addSignal(datetime, 7, false, price);
    end

    setting.count_buy = setting.count_buy + 1;
    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
    setting.limit_count_buy = setting.limit_count_buy + setting.use_contract; -- отметка для лимита

    return price;
end

-- исполнение продажи контракта
function sellContract(result)
    --  loger.save("sellContract  " );
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do

            if setting.sellTable[contract].type == 'sell' and
                setting.sellTable[contract].executed == false and
                setting.sellTable[contract].trans_id == result.trans_id then

                -- статистика
                setting.count_sell = setting.count_sell + 1;
                setting.count_contract_sell =
                    setting.count_contract_sell +
                        setting.sellTable[contract].use_contract;

                -- подсчёт профита
                local sell = setting.sellTable[contract].use_contract *
                                 setting.sellTable[contract].price;
                local buy = setting.sellTable[contract].use_contract *
                                setting.sellTable[contract].buy_contract;
                setting.profit = sell - buy + setting.profit;

                setting.sellTable[contract].executed = true;
                -- для учёта при выставлении заявки
                setting.sellTable[contract].work = false;

                -- выставляем на продажу контракт.
                setting.sellTable[contract].price_take = result.price,

                                                         execution_sell(
                                                             setting.sellTable[contract]);

                signalShowLog.addSignal(setting.sellTable[contract].datetime,
                                        26, false, result.price);
                deleteBuyCost(result, setting.sellTable[contract])
                control.use_contract_limit();

                loger.save(
                    "sellContract продали контракт result.trans_id = " ..
                        result.trans_id .. " trans_id = " ..
                        stopClass.array_stop.trans_id .. " order_num = " ..
                        stopClass.array_stop.order_num);
            end
        end
    end
    loger.save("вызов update_stop 1 ");
    risk_stop.update_stop();
end

-- выставление заявки на покупку 
-- вызывается для эмуляции и не только
function callBUY(price_callBUY, datetime)

    local price_callBUYl = commonBUY(price_callBUY, datetime);
    local trans_id_buy = transaction.send("BUY", price_callBUYl,
                                          setting.use_contract, type, 0);
    setting.count_contract_buy = setting.count_contract_buy +
                                     setting.use_contract

    local data = {};
    data.price = price_callBUYl;
    data.datetime = datetime;
    data.trans_id = trans_id_buy;
    -- сколько контрактов исполнилось 
    data.use_contract = setting.use_contract;
    data.trans_id_buy = trans_id_buy;

    data.work = true;
    data.executed = false;
    data.type = 'buy';
    data.emulation = setting.emulation;
    data.contract = setting.use_contract;
    data.buy_contract = price_callBUYl; -- стоимость продажи

    setting.sellTable[(#setting.sellTable + 1)] = data;
    -- Выставили контракт на покупку
    signalShowLog.addSignal(datetime, 23, false, price_callBUYl);
    panelBids.show();
    control.use_contract_limit();
end

-- выставляем заявку на продажу в режиме эмуляции
function sellTransaction_emulation(contractBuy)

    local trans_id_sell = getRand();

    -- price = setting.profit_range + contractBuy.price  + setting.profit_infelicity;
    local price = setting.profit_range + contractBuy.price;

    local data = {};
    data.price = price;
    data.datetime = contractBuy.datetime;
    data.trans_id = trans_id_sell;
    data.number = 0;
    data.type = 'sell';
    data.work = true;
    data.executed = false; -- покупка исполнилась
    data.emulation = setting.emulation;
    data.contract = setting.use_contract;
    data.use_contract = setting.use_contract;
    data.buy_contract = contractBuy.price; -- стоимость продажи
    data.trans_id_buy = contractBuy.trans_id_buy;

    setting.sellTable[#setting.sellTable + 1] = data;

    signalShowLog.addSignal(contractBuy.datetime, 22, false, price);
    if setting.emulation then
        label.set('red', price, contractBuy.datetime, 1, "");
    end
end

-- выставление заявки на покупку в эмуляции
function callBUY_emulation(price, datetime)
    local trans_id_buy = getRand()

    loger.save("OnOrder work order_num = " .. price);
    price = commonBUY(price, datetime);
    --  setting.emulation_count_contract_buy = setting.emulation_count_contract_buy + setting.use_contract;
    setting.count_contract_buy = setting.count_contract_buy +
                                     setting.use_contract;
    local data = {};

    data.price = price;
    data.datetime = datetime;
    data.trans_id = trans_id_buy;
    -- сколько контрактов исполнилось  

    data.work = true;
    data.number = 0;
    data.executed = true; -- покупка исполнилась
    data.type = "buy";
    data.emulation = setting.emulation;
    data.contract = setting.use_contract;
    data.use_contract = setting.use_contract;
    data.buy_contract = price; -- стоимость продажи
    data.trans_id_buy = trans_id_buy;

    signalShowLog.addSignal(data.datetime, 24, false, price);

    if setting.emulation then label.set("BUY", price, data.datetime, 0); end
    setting.sellTable[(#setting.sellTable + 1)] = data;

    loger.save("OnOrder work order_num =  ")
    sellTransaction_emulation(data)
    panelBids.show();
    loger.save("вызов update_stop 3");
    risk_stop.update_stop();
    control.use_contract_limit();
end

-- исполнение продажи контракта в режиме эмуляции
function callSELL_emulation(result)

    --  local price_callSELL_emulation = result.close;

    if #setting.sellTable > 0 then
        for sellT = 1, #setting.sellTable do
            if setting.sellTable[sellT].type == 'sell' and
                setting.sellTable[sellT].work and
                setting.sellTable[sellT].emulation and --     result.close + setting.profit_infelicity >= setting.sellTable[sellT].price 
            result.close >= setting.sellTable[sellT].price then

                setting.sellTable[sellT].work = false;
                execution_sell(setting.sellTable[sellT]);
                -- сколько продано контрактов за сессию (режим эмуляции)
                --   setting.emulation_count_contract_sell = setting.emulation_count_contract_sell + setting.sellTable[sellT].contract; 
                setting.count_contract_sell =
                    setting.count_contract_sell +
                        setting.sellTable[sellT].contract;
                setting.profit = setting.sellTable[sellT].price -
                                     setting.sellTable[sellT].buy_contract +
                                     setting.profit;

                if setting.limit_count_buy >= setting.sellTable[sellT].contract then
                    setting.limit_count_buy =
                        setting.limit_count_buy -
                            setting.sellTable[sellT].contract;
                end

                signalShowLog.addSignal(result.datetime, 21, false, result.close);
                if setting.emulation then
                    label.set('SELL', result.close, result.datetime, 1,
                              'sell contract ' .. 1);
                end
                -- надо удалить контракт по которому мы покупали 
                --   panelBids.show(); 
                control.use_contract_limit();
                deleteBuy_emulation(setting.sellTable[sellT]);
                --  loger.save("вызов update_stop 4 "  .. setting.limit_count_buy .. " setting.limit_count_buy " .. setting.sellTable[sellT].contract );
                risk_stop.update_stop();

            end
        end
    end
end

-- здесь ищем контракт который мы купили ранее 
-- после продажи контракта надо его пометить, что мы больше не используем
-- режим эмуляции
function deleteBuy_emulation(contract_sell)
    if #setting.sellTable > 0 then
        for contract_buy_tr = 1, #setting.sellTable do

            if contract_sell.trans_id_buy ==
                setting.sellTable[contract_buy_tr].trans_id then
                setting.sellTable[contract_buy_tr].work = false;
                setting.sellTable[contract_buy_tr].use_contract =
                    setting.sellTable[contract_buy_tr].contract -
                        contract_sell.use_contract;
                panelBids.show();
            end
        end
    end
end

function check_buy_status_block()
    --   loger.save("-- если кнопка покупки заблокирована автоматически по причине падение"  );
    -- если кнопка покупки заблокирована автоматически по причине падение
    if setting.each_to_buy_status_block then
        setting.each_to_sell_step = setting.each_to_sell_step + 1;
        if setting.each_to_sell_step >= setting.each_to_buy_to_block then
            -- разблокируем кнопку покупки, потому что всё продали что должны были
            setting.each_to_buy_status_block = false;
            setting.each_to_sell_step = 0;
            setting.each_to_buy_step = 0; -- сколько подряд раз уже купили 
            control.buy_process();

        end
    end
end

-- надо отметить в контркте на покупку что заявка исполнена
function deleteBuyCost(result, saleContract)
    if #setting.sellTable > 0 then
        for sellT = 1, #setting.sellTable do
            if setting.sellTable[sellT].type == 'buy' and
                setting.sellTable[sellT].executed == true and
                setting.sellTable[sellT].trans_id == saleContract.trans_id_buy then
                local local_contract = setting.sellTable[sellT];

                setting.sellTable[sellT].use_contract =
                    local_contract.use_contract - saleContract.contract;

                setting.count_buyin_a_row = 0;
                setting.SPRED_LONG_LOST_SELL = result.price;
                setting.SPRED_LONG_TREND_DOWN =
                    setting.SPRED_LONG_TREND_DOWN -
                        setting.SPRED_LONG_TREND_DOWN_SPRED;

                if setting.SPRED_LONG_TREND_DOWN < 0 then
                    setting.SPRED_LONG_TREND_DOWN =
                        setting.SPRED_LONG_TREND_DOWN_minimal;
                end

                setting.sellTable[sellT].work = false;

                if setting.limit_count_buy > 0 then
                    setting.limit_count_buy =
                        setting.limit_count_buy - local_contract.use_contract;
                end

                setting.count_contract_sell =
                    setting.count_contract_sell + saleContract.contract;
                -- calculateProfit(setting.sellTable[sellT]);
                signalShowLog.addSignal(setting.sellTable[sellT].datetime, 8,
                                        false, result.price);

                if setting.emulation then
                    label.set('sell', result.price,
                              setting.sellTable[sellT].datetime, 1, "");
                end
                -- надо удалить контракт по которому мы покупали
                loger.save("вызов update_stop 2 ");
                -- risk_stop.update_stop(); 
                panelBids.show();
            end
        end
    end
end

-- автоматическая торговля
function long(price, datetime, levelLocal, event) -- решение
    -- подсчитаем скольк заявок у нас на продажу
    -- Не покупать, если была покупка по текущей цене или в промежутке
    local checkRangeBuy = contitionMarket.getRandBuy(price, setting.sellTable);
    -- Не покупать, если стоит ли продажа в этом промежутке, не продали контракт
    local checkRangeSell = contitionMarket.getRandSell(price, setting.sellTable);
    --  Не покупать, если свечной анализ показывает низкий уровень промежутка продаж/покупок 
    local randCandle = contitionMarket.getRandCandle(price, datetime);
    -- Не покупать, если рынок падает а мы раньше купили, но не продали согласно правилам
    local failMarket = contitionMarket.getFailMarket(price, datetime);
    -- Не покупать, если лимит по заявкам выделеным на покупку исчерпан
    local limitBuy = contitionMarket.getLimitBuy(datetime);
    -- Не покупать, если сработала блокировка покупки при падении рынка
    local getFailBuy = contitionMarket.getFailBuy(price, datetime);
    -- Не покупать, если кнопка покупки заблокирована  (блокируется кнопкой)
    local buyButtonBlock = contitionMarket.buyButtonBlock(price, datetime);
    -- Не покупать, если цена выше коридора покупок
    local not_buy_high = contitionMarket.not_buy_high(price, datetime);

    if limitBuy and checkRangeBuy and checkRangeSell and randCandle and
        failMarket and getFailBuy and buyButtonBlock and not_buy_high then
        setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN +
                                            setting.SPRED_LONG_TREND_DOWN_SPRED;
        setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = price; -- записываем последнюю покупку

        if setting.emulation then
            -- в режиме эмуляции контракт на покупку исполнен в полном объёме
            callBUY_emulation(price, datetime);
        else
            callBUY(price, datetime);
        end
        -- обновляем изменения в панели управления
    end
end

function decision(price, datetime, levelLocal, event) -- решение
    long(price, datetime, levelLocal, event);
end

local M = {};
M.saleExecutionStopOrder = saleExecutionStopOrder;
M.saleExecution = saleExecution;
M.updateTransaction = updateTransaction;
M.callSELL_emulation = callSELL_emulation;
M.buyContract = buyContract;
M.sellContract = sellContract;
M.sellTransaction = sellTransaction;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;

return M
