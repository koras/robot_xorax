-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта
-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShow =  dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local risk_stop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");

-- сервис, общие математические операции
local market_service = dofile(getScriptPath() .. "\\shop\\market_service.lua");


local function gapGetPriceProfit(setting)
    
end



--    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
--    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
--    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
--    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
--    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
--    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

-- вычисляем направление цены которое будет
local function  chechPrice(setting)

    if setting.lastDayPrice > setting.openDayPrice then
        setting.gap_spred = setting.lastDayPrice - setting.openDayPrice
        setting.gap_direction = 'short';
        return;
    end;
        -- long
    setting.gap_spred = setting.openDayPrice - setting.lastDayPrice
    setting.gap_direction = 'long';

end

 
local function getOldPrice(setting)
 
    if setting.singleGetOldPrice then 
        setting.singleGetOldPrice = false;

    local currentDatetime = setting.currentDatetime;
    local datetime_min = 0;
    local   datetime = {};

    loger.save( "getSignal gap ")
    -- сколько свечей в работе с права
    local len = 990;
    local shift = 0;
 
    setting.number_of_candles = getNumCandles(setting.tag);
    bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candles - 2 * len - shift, 2 * len)
    local bars = {}
    local i = len
    local j = 2 * len
    while i >= 1 do
        if bars_temp[j - 1] == nil then
       --     message(words.word('not_found_tag'));
            OnStop();
            Run = false; 
            return
        end
                bars[i] = bars_temp[j - 1]
          --      loger.save( "===== : ".. bars[i] .close )
              datetime =  bars[i].datetime


        -- можем ошибиться с графиком и поставить другой таймфрейм, уберегём себя родного
        if datetime.hour == 23 and datetime.min >= 20  and currentDatetime.day ~= datetime.day then 
            -- хак специальный
            if datetime.min > datetime_min then 
                datetime_min = datetime.min;
             --   lastDayPrice = bars[i].close;
                setting.lastDayPrice = bars[i].close;
            end;  
        end
 

        -- можем ошибиться с графиком и поставить другой таймфрейм, уберегём себя родного
     --   if datetime.hour  == 10 and datetime.min == 00  and currentDatetime.day == datetime.day then 
            -- хак специальный
        --        setting.openDayPrice = bars[i].open;
     
     --   end
 
  
         
    --    loger.save( "===== :   ".. datetime.hour .. ":"..datetime.min)

  --  loger.save( tostring(datetime.year) .. " datetime " )
    -- loger.save( tostring(datetime.day) .. " " ..
    --           tostring(datetime.hour) .. " " ..
    --           tostring(datetime.min) .. " " ..
    --           tostring(datetime.sec)
    --         )



             -- просто отправляем текущую цену
             
                i = i - 1
        j = j - 1
    end

    t = len + 1;

   -- chechPrice(setting);
     
  --  loger.save( 'получили старую цену '..datetime.day.. "  ".. datetime.hour .. ": "..datetime_min .. " ===== : close".. setting.lastDayPrice )
  --  loger.save( "получили open : " .. setting.openDayPrice .. " setting.gap_direction " ..setting.gap_direction );
    end
end

 

local function autoStart(setting)

 
 if setting.autoStartEngine and setting.singleGetOldPrice == false then 
 

    local currentDatetime = setting.currentDatetime;
  

    loger.save( "getSignal gap ")
    -- сколько свечей в работе с права
    local len = 820;
    local shift = 0;
 
    setting.number_of_candles = getNumCandles(setting.tag);
    local bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candles - 2 * len - shift, 2 * len)
    local bars = {}
    local i = len
    local j = 2 * len
    while i >= 1 do
        if bars_temp[j - 1] == nil then
       --     message(words.word('not_found_tag'));
            OnStop();
            Run = false; 
            return
        end
                bars[i] = bars_temp[j - 1]
          --      loger.save( "===== : ".. bars[i] .close ) 
         if bars[i].datetime.hour  == 10 and bars[i].datetime.min == 00  and currentDatetime.day == bars[i].datetime.day then 
            -- хак специальный
             setting.openDayPrice = bars[i].open;

            setting.autoStartEngine = false;
            chechPrice(setting);
            loger.save("> autoStart ".. setting.lastDayPrice .. "  получили open : " .. setting.openDayPrice .. " setting.gap_direction " ..setting.gap_direction );
       end
                i = i - 1
        j = j - 1
    end

    t = len + 1;

   -- chechPrice(setting); 
    end
end;

local function getRand() return tostring(math.random(2000000000)); end

 

-- done
local function gapCommonOperation(setting, _price)

    -- сколько подряд покупок было
    -- не влияет на тип операции шорт или лонг
    if setting.each_to_buy_step <= setting.each_to_buy_to_block then
        setting.each_to_buy_step = setting.each_to_buy_step + 1;
        -- увеличиваем число контрактов которые надо продать до разблокировки
        setting.each_to_buy_to_block_contract =
            setting.use_contract + setting.each_to_buy_to_block_contract
    end

    -- текущаая свеча
    -- ставим заявку на с отклонением на 0.01

    local price = 0;

    if setting.type_instrument == 3 then
        if setting.mode == 'buy' then
            price = tonumber(_price + setting.profit_infelicity); -- и надо снять заявку если не отработал
        else
            price = tonumber(_price - setting.profit_infelicity); -- и надо снять заявку если не отработал
        end
    else
        if setting.mode == 'buy' then
            price = _price + setting.profit_infelicity; -- и надо снять заявку если не отработал
        else
            price = _price - setting.profit_infelicity; -- и надо снять заявку если не отработал
        end
    end

    setting.candles_operation_last = setting.number_of_candles;
    if setting.emulation then
        signalShow.addSignal(20, false, tostring(price));
    else
        signalShow.addSignal(7, false, price);
    end

    setting.count_buy = setting.count_buy + 1;
    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
    setting.limit_count_buy = setting.limit_count_buy + setting.use_contract; -- отметка для лимита
    return price;
end


-- второй этап регистрации события
-- если шорт, то здесь выставляем заявку на покупку, после продажи
-- лонг, выставляем заявку на продажу, если купили контракт
-- done
local function gapSecondOperation(setting, order, contractBuy)
    local price = 0
    if contractBuy.use_contract == 0 then
        loger.save("нет контрактов " .. contractBuy.use_contract);
    end

    loger.save("secondOperation");

    local type = "TAKE_PROFIT_STOP_ORDER";
    if setting.sell_take_or_limit == false then type = "NEW_ORDER"; end
 

    for sell_use_contract = 1, contractBuy.use_contract do

        local data = {};
        data.number = 0


         if( setting.gap_direction == 'short') then
            -- short
            data.type = 'buy'
 
            
        -- какой промежуток покупки/ продажи
            price = contractBuy.price - setting.gap_spred;
        else 
            -- long 
            data.type = 'sell'
            price = contractBuy.price + setting.gap_spred;
        end
 
        loger.save( setting.gap_direction.. "setting.gap_spred"..setting.gap_spred.." "..price )


        data.datetime = order.datetime
        data.order_type = type;
        data.work = true;
        data.executed = false; -- покупка исполнилась
        data.emulation = setting.emulation;
        data.contract = 1;
        data.use_contract = 1;
        data.buy_contract = contractBuy.price; -- стоимость продажи
        data.trans_id_buy = contractBuy.trans_id_buy 
        signalShow.addSignal(23, false, price);

        loger.save("gapSecondOperation 3 " .. sell_use_contract);
        data.price = price;
        if setting.emulation then

            data.trans_id = getRand();
            signalShow.addSignal(22, false, price);

            if setting.mode == 'buy' then
                label.set(setting,"redCircle", price, contractBuy.datetime, 1, "sell");
            else
                label.set(setting,"greenCircle", price, contractBuy.datetime, 1, "buy");
            end

        else
            data.order_num = order.order_num;

            if setting.mode == 'buy' then
                data.trans_id = transaction.send("SELL", price, 1, type,
                                                 order.order_num);
            else
                data.trans_id = transaction.send("BUY", price, 1, type,
                                                 order.order_num);
            end
            signalShow.addSignal(9, false, price);
        end
        loger.save("gapSecondOperation 5 " .. sell_use_contract);
        setting.sellTable[#setting.sellTable + 1] = data;
        -- обязательно в конце цикла
        price = price + setting.profit_range_array;
    end

    panelBids.show(setting);
end

-- исполнение покупки(продажи контракта) контракта
-- first operation
-- the market entry
-- done
local function GapStartContract(setting, result)
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do
            -- loger.save(setting.sellTable[contract].type);  
            if setting.sellTable[contract].executed == false and
                    setting.sellTable[contract].trans_id == result.trans_id then

                    signalShow.addSignal(27, false, setting.sellTable[contract].price);
                    setting.sellTable[contract].executed = true;
                    -- выставляем на продажу контракт.
                    gapSecondOperation(setting, result, setting.sellTable[contract]);
                return;
            end
        end
    end
end



-- выставление заявки на покупку/продажу
-- вызывается для эмуляции и не только
-- solve
-- done
local function gapSendOrder(  setting, price, datetime)
    -- генерация trans_id для эмуляции 
    local trans_id = getRand()

    local use_contract =  setting.use_contract
    setting.count_contract_buy = setting.count_contract_buy + use_contract;
    price = gapCommonOperation(setting, price, datetime);
    if setting.emulation == false then
        trans_id = transaction.send(setting.gap_direction, price, use_contract, type, 0);
    end

    local data = {};
    data.price = price;
    data.datetime = datetime;
    data.trans_id = trans_id;
    -- сколько контрактов исполнилось 
    data.use_contract = use_contract;
    data.trans_id_buy = trans_id;

    data.work = true;
    data.executed = false;
    data.type = setting.gap_direction;
    data.emulation = setting.emulation;
    data.contract = use_contract;
    data.buy_contract = price; -- стоимость продажи

    loger.save("> gapSendOrder " ..setting.gap_direction );

    loger.save("> price " .. price );
    if setting.emulation then
        if setting.gap_direction == 'long' then
            -- long
            label.set(setting,"BUY", price, data.datetime, use_contract);
        else
            -- short 
            label.set(setting,"SELL", price, data.datetime, use_contract);
        end
    end

    setting.sellTable[(#setting.sellTable + 1)] = data;
    -- Выставили контракт на покупку
    signalShow.addSignal(23, false, price);
    panelBids.show(setting);
    control.use_contract_limit(setting);
end
 -- http://luaq.ru/getSecurityInfo.html
 -- получаем минимальный шаг цены
 local function getMinPriceStep(setting)
    local info = getSecurityInfo(setting.CLASS_CODE, setting.SEC_CODE);
    return info.min_price_step;
end;

local function myGetQuoteLevel2(setting)
    local itterPrice = setting.gap_offer_bid;

    local q = getQuoteLevel2(setting.CLASS_CODE, setting.SEC_CODE)
    loger.save("QuoteLevel2: bid_count=" .. tonumber(q.bid_count) .. ", offer_count=" .. tonumber(q.offer_count), 1)

  --  loger.save("QuoteLevel2: bid_count=" .. tonumber(q.offer) .. ", offer_count=" .. tonumber(q.bid), 1)

    if q.bid_count == 0 or q.offer_count == 0  then 
        loger.save("> myGetQuoteLevel2 I didn't cost" .. tonumber(q.offer) )
        return;
    end
    
    local minPriceStep =  getMinPriceStep(setting);

    if setting.gap_direction == 'short' then
        -- продаём
        local bid_count = #q.bid -  setting.gap_offer_bid;
        for contract = 1, #q.bid do
            -- loger.save(setting.sellTable[contract].type);
         --   loger.save("QuoteLevel2: bid price =" .. q.bid[contract].price)
        end
        setting.gap_send_price = q.bid[bid_count].price - minPriceStep;
        loger.save(bid_count .. " QuoteLevel2: bid price =" .. q.bid[bid_count].price .." setting.gap_offer_bid "..setting.gap_offer_bid .."  #q.bid "..  #q.bid)
        
    else 
 
            -- покупаем
        for contract = 1, #q.offer do 
            -- loger.save(setting.sellTable[contract].type);
        --    loger.save("QuoteLevel2: offer  price =" .. q.offer[contract].price)
        end
        setting.gap_send_price = q.offer[itterPrice].price +  minPriceStep;

    end
    loger.save("QuoteLevel2: minPriceStep =" ..minPriceStep)
 
    return setting.gap_send_price;
end;
 

-- выставляем заявку на продажу
local function pushMarket(setting, datetime)
    if 
        setting.autoStartEngine == false and 
        setting.gapSendOrderStatus == false and 
        setting.status
    then
        -- меняем статус чтобы такие заявки больше не выставлять
        setting.gapSendOrderStatus = true;
        local price = myGetQuoteLevel2(setting);
        gapSendOrder( setting, price, datetime);
    end
end
 

-- надо отметить в контркте на покупку что заявка исполнена
-- finish - помечаем контракт
-- done
local function GapdeleteBuyCost(result, saleContract)
    if #setting.sellTable > 0 then
        for sellT = 1, #setting.sellTable do
            if setting.sellTable[sellT].executed == true and
                setting.sellTable[sellT].trans_id == saleContract.trans_id_buy then

                local local_contract = setting.sellTable[sellT];

                setting.sellTable[sellT].use_contract = local_contract.use_contract - saleContract.contract;

                setting.count_buyin_a_row = 0;
                setting.SPRED_LONG_LOST_SELL = result.price;

                
           
                setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;
          


                if setting.SPRED_LONG_TREND_DOWN < 0 then
                    setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN_minimal;
                end

                setting.sellTable[sellT].work = false;

                if setting.limit_count_buy > 0 then
                    setting.limit_count_buy = setting.limit_count_buy - result.qty
                end

                if setting.limit_count_buy == 0 then
                    setting.sellTable[sellT].work = false;
                end

                setting.count_contract_sell =  setting.count_contract_sell + saleContract.contract;

                signalShow.addSignal(8, false, result.price);

                if setting.emulation then
                    label.set(setting, 'SELL', result.price, setting.sellTable[sellT].datetime, 1, "");
                end
                -- надо удалить контракт по которому мы покупали
                loger.save("вызов update_stop 2 ");
                -- risk_stop.update_stop(); 
                panelBids.show(setting);
            end
        end
    end
end

-- присваиваем номер заявке на продажу
-- обновляем номер заявки на стопах
-- done
local function gapSaleExecution(result,setting)
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do
            -- обновляем номер заявки
            if  setting.sellTable[contract].executed == false and setting.sellTable[contract].trans_id == result.trans_id then

                loger.save("saleExecution  order_num=" .. result.order_num .. " trans_id=" .. result.trans_id .. "  ");
                setting.sellTable[contract].order_num = result.order_num
                -- risk_stop.update_stop();
            end
        end
    end
end


-- third
-- исполнение тейка или лимита в профите
-- done
local function takeExecutedContractGap(setting,result)
    
    loger.save("-- исполнение продажи контракта ");
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then
        for contract = 1, #setting.sellTable do

            if  setting.sellTable[contract].executed == false and
                setting.sellTable[contract].trans_id == result.trans_id then

                -- статистика
                setting.count_sell = setting.count_sell + 1;
                -- count the number of used contracts
                setting.count_contract_sell = setting.count_contract_sell +  setting.sellTable[contract].use_contract;

                setting.sellTable[contract].executed = true;
                -- для учёта при выставлении заявки
                setting.sellTable[contract].work = false;
                setting.sellTable[contract].price_take = result.price;

                -- подсчёт профита, от фактической стоимости
                local sell = setting.sellTable[contract].use_contract *  result.price;
                local buy = setting.sellTable[contract].use_contract * setting.sellTable[contract].buy_contract;



                setting.profit = sell - buy + setting.profit;
 
            
                if  setting.gap_direction == 'short' then
                    -- short
                    setting.profit = buy - sell + setting.profit; 
                else 
                    -- long
                    setting.profit = sell - buy + setting.profit;
                end



                market_service.executionContractFinish(setting.sellTable[contract]);
                -- увеличивает лимит используемых контрактов
                market_service.getLastMinMax(setting)

                setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = setting.price_min_buy;

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

                market_service.check_buy_status_block(contract);

 
                signalShow.addSignal(26, false, result.price);
                GapdeleteBuyCost(result, setting.sellTable[contract])
                control.use_contract_limit(setting);

                loger.save(
                    "takeExecutedContract продали контракт result.trans_id = " ..
                        result.trans_id .. " trans_id = " ..
                        settingData.array_stop.trans_id .. " order_num = " ..
                        settingData.array_stop.order_num);
            end
        end
    end
    loger.save("вызов update_stop 1 ");
    risk_stop.update_stop();
end

-- здесь ищем контракт который мы купили / продали  ранее 
-- после продажи контракта надо его пометить, что мы больше не используем
-- режим эмуляции
-- no done
local function gap_deleteBuy_emulation(setting, contractSell)
    if #setting.sellTable > 0 then
        for contract_buy_tr = 1, #setting.sellTable do

            if contractSell.trans_id_buy == setting.sellTable[contract_buy_tr].trans_id then
                setting.sellTable[contract_buy_tr].work = false;
                setting.sellTable[contract_buy_tr].use_contract = setting.sellTable[contract_buy_tr].contract - contractSell.use_contract;
                panelBids.show(setting)
            end
        end
    end
end


-- Каждый ТИК  Только продажа
-- исполнение продажи контракта в режиме эмуляции
-- done
local function gapEmulationLong(setting,result)

    --  local price_callSELL_emulation = result.close;

    if #setting.sellTable > 0 then
        for sellT = 1, #setting.sellTable do

            loger.save( result.close  .."  result.close " .. setting.sellTable[sellT].price);
            
            if 
         --   setting.sellTable[sellT].type == 'sell' and
                setting.sellTable[sellT].work and setting.sellTable[sellT].emulation and result.close >= setting.sellTable[sellT].price then

                    loger.save( result.close  .."  exeption " .. setting.sellTable[sellT].price);

                setting.sellTable[sellT].work = false;

                market_service.executionContractFinish(setting.sellTable[sellT]);
                -- сколько продано контрактов за сессию (режим эмуляции)
                --   setting.emulation_count_contract_sell = setting.emulation_count_contract_sell + setting.sellTable[sellT].contract; 
                setting.count_contract_sell =  setting.count_contract_sell +  setting.sellTable[sellT].contract;
                setting.profit = setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract +  setting.profit;

                if setting.limit_count_buy >= setting.sellTable[sellT].contract then
                    setting.limit_count_buy =
                        setting.limit_count_buy -
                            setting.sellTable[sellT].contract;
                end

                signalShow.addSignal(21, false, result.close);
                if setting.emulation then
                    label.set(setting, 'SELL', result.close, result.datetime, 1, 'sell contract ' .. 1);
                end
                -- надо удалить контракт по которому мы покупали 
                --   panelBids.show(); 
                control.use_contract_limit(setting);
                gap_deleteBuy_emulation(setting,setting.sellTable[sellT]);
                risk_stop.update_stop();

            end
        end
    end
end

local function gapTickEmulation(setting,result)
       
 
    if  setting.gap_direction == 'short' then
        -- short  
    else 
        -- long
      --  gapCallEmulation(setting,result);
        gapEmulationLong(setting, result);
    end
end


 
local M = {}
M.getOldPrice = getOldPrice
M.autoStart = autoStart
M.gapSaleExecution = gapSaleExecution
M.pushMarket = pushMarket
M.GapStartContract = GapStartContract
M.takeExecutedContractGap = takeExecutedContractGap
-- M.gapCallEmulation = gapCallEmulation

-- вызываем каждый тик 
M.gapTickEmulation = gapTickEmulation
return M
