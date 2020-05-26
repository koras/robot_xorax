

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
 
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
 

M = {};
 
-- SHORT  = FALSE
-- LONG = true
 
local DIRECT = 'LONG';  
 

local function setDirect(localDirect)  
    DIRECT = localDirect;
end

local function setLitmitBid()  
    LIMIT = setting.LIMIT_BID;
end
-- price текущая цена
-- levelLocal  сила сигнала
-- event -- продажа или покупка

local function decision(event, price, datetime, levelLocal) -- решение
    long(price, datetime, levelLocal , event);
end

local level = 1;
  




-- автоматическая торговля
function long(price, datetime, levelLocal , event) -- решение 

            -- логика выставления заявки на покупку контракта

          --  getfractal(price);
 
            -- подсчитаем скольк заявок у нас на продажу
            -- проверём, покупали здесь или нет, в этом промежутке
            checkRangeBuy = contitionMarket.getRandBuy(price, setting.sellTable);
            -- проверём, стоит ли продажа в этом промежутке
            checkRangeSell = contitionMarket.getRandSell(price, setting.sellTable);
            -- уровень свечи 
            randCandle = contitionMarket.getRandCandle(price, datetime);
             -- Падение рынка
            failMarket = contitionMarket.getFailMarket(price, datetime) ;
            -- лимит по заявкам
            limitBuy = contitionMarket.getLimitBuy(datetime); 
            -- блокировка покупки при падении рынка
            getFailBuy = contitionMarket.getFailBuy(price,datetime);
            -- Запрет на покупку (блокируется кнопкой)
            buyButtonBlock = contitionMarket.buyButtonBlock(price,datetime);
            -- Запрет на покупку если цена выше коридора
            not_buy_high = contitionMarket.not_buy_high(price,datetime);


            if limitBuy and checkRangeBuy and checkRangeSell and randCandle  and failMarket and getFailBuy and buyButtonBlock and not_buy_high then
                setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN + setting.SPRED_LONG_TREND_DOWN_SPRED;
                setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = price; -- записываем последнюю покупку
                
                -- сколько подряд покупок было
                setting.each_to_buy_step = setting.each_to_buy_step + 1;
         
                     
                    if setting.emulation  then
                        -- в режиме эмуляции контракт на покупку исполнен в полном объёме
                        callBUY_emulation(price,  datetime);
                    else 
                        callBUY(price,  datetime);
                    end;
                    -- обновляем изменения в панели управления
                    control.use_contract_limit();
                  --  signalShowLog.addSignal(datetime, 10, false, price); 
            end;  
              
end






-- function getfractal(price)  
--     if #setting.fractals_collection > 0 then 
--         for k,v in setting.fractals_collection do 

--         end
--     end;

-- end;



-- исполнение покупки контракта
function buyContract(result)
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
  --      signalShowLog.addSignal(result.datetime, 15, false, #setting.sellTable); 
    if #setting.sellTable > 0 then 
    for contract = 1 ,  #setting.sellTable do 
    loger.save(setting.sellTable[contract].type); 
       loger.save(result.trans_id); 
       loger.save(tostring(setting.sellTable[contract].trans_id));  
            if  setting.sellTable[contract].type == 'buy' and  
            setting.sellTable[contract].executed == false  and 
            setting.sellTable[contract].trans_id == result.trans_id  then
                
                signalShowLog.addSignal(result.datetime, 27, false, 100); 
                
                setting.sellTable[contract].executed = true;
                -- выставляем на продажу контракт.
              
                sellTransaction(result, setting.sellTable[contract]);
                panelBids.show();
                return;
            end;
        end;
    end;
end;




-- только выставляется заявка на продажу
function sellTransaction(order, countContracts)
    local type = "TAKE_PROFIT_STOP_ORDER";

    if setting.sell_take_or_limit == false  then
        type = "SIMPLE_STOP_ORDER";
    end;
    
  -- for contract = 1 ,  #setting.sellTable do 

    local  trans_id_sell  =  getRand();
          --  local price = setting.profit_range + order.price + setting.profit_infelicity;
            local price = setting.profit_range + order.price ;
          if setting.emulation == false then
                 trans_id_sell =  transaction.send("SELL", price, setting.use_contract, type, order.order_num);
            end;

            signalShowLog.addSignal(order.datetime, 9, false, price); 

            loger.save('trans_id_sell = ' ..  trans_id_sell ); 

                                            local data = {
                                                            ['price'] = price,
                                                            ['datetime']= order.datetime, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['order_num_buy']=  order.order_num, 
                                                            ['trans_id_buy']=  countContracts.trans_id, 
                                                             
                                                            ['use_contract']=   setting.use_contract, 
                                                            ['order_type'] = type,
                                                            ['type'] = 'sell',
                                                            ['work'] = true,
                                                            ['executed'] = false,
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  setting.use_contract,
                                                            ['buy_contract']= order.price, -- стоимость покупку
                                                        };
            setting.sellTable[(#setting.sellTable+1)] = data;
  --  end;
end;



 

-- исполнение продажи контракта
function sellContract(result)

    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then

        for contract = 1 ,  #setting.sellTable do 
            if  setting.sellTable[contract].type == 'sell' and  
            setting.sellTable[contract].executed == false  and 
            setting.sellTable[contract].trans_id == result.trans_id  then
                
                -- статистика
                setting.count_sell = setting.count_sell + 1;
                setting.count_contract_sell = setting.count_contract_sell +  setting.sellTable[contract].use_contract;


                setting.sellTable[contract].executed = true;
                -- для учёта при выставлении заявки
                setting.sellTable[contract].work = false;
                -- выставляем на продажу контракт.
                setting.sellTable[contract].price_take = result.price,
 
                execution_sell(setting.sellTable[contract]); 

                signalShowLog.addSignal(setting.sellTable[contract].datetime, 26, false, result.price); 

                deleteBuyCost(result, setting.sellTable[contract])
 

              --  panelBids.show();
            end;
        end;
    end;
end;






--  -- надо отметить в контркте на покупку что заявка исполнена
function deleteBuyCost(result, saleContract)
    if #setting.sellTable > 0 then
        for sellT = 1,  #setting.sellTable do 
            if  setting.sellTable[sellT].type == 'buy' and  
            setting.sellTable[sellT].executed == true and 
            setting.sellTable[sellT].trans_id == saleContract.trans_id_buy  then 
                    local local_contract = setting.sellTable[sellT];

                    setting.sellTable[sellT].use_contract = local_contract.use_contract - saleContract.contract;


                    setting.count_buyin_a_row = 0; 
                    setting.SPRED_LONG_LOST_SELL = result.price;
                    setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;

                    if setting.SPRED_LONG_TREND_DOWN < 0  then 
                        setting.SPRED_LONG_TREND_DOWN = 0.01;
                    end;

                  --  if setting.sellTable[sellT].use_contract >= 0 then 
                        -- использовать контракт в работе
                        setting.sellTable[sellT].work = false;
                  --  end;

                    
                    setting.limit_count_buy = setting.limit_count_buy - saleContract.contract;
                    setting.count_contract_sell = setting.count_contract_sell + saleContract.contract;
                    -- calculateProfit(setting.sellTable[sellT]);
                    signalShowLog.addSignal(setting.sellTable[sellT].datetime, 8, false, result.price); 
                    -- надо удалить контракт по которому мы покупали

                    
                    panelBids.show();
            end;
        end;
    end;
end






 
function commonBUY(price ,datetime)
    -- текущаая свеча

    
    -- ставим заявку на покупку выше на 0.01
    price  = price + setting.profit_infelicity; -- и надо снять заявку если не отработал

    setting.candles_buy_last = setting.number_of_candles;

    if setting.emulation  then
        signalShowLog.addSignal(datetime, 20, false, price);
        -- лимит на покупку в эмуляции ( сколько контрактов купили на текущий момент )
        setting.limit_count_buy_emulation = setting.limit_count_buy_emulation + setting.use_contract;  
        setting.emulation_count_buy = setting.emulation_count_buy + 1;
        -- покупок сколько было за торговую сессию
        setting.count_buyin_a_row_emulation = setting.count_buyin_a_row_emulation + 1;
    else

        setting.count_buy = setting.count_buy + 1; 
        setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
        setting.limit_count_buy = setting.limit_count_buy + setting.use_contract; -- отметка для лимита
        
        signalShowLog.addSignal(datetime, 7, false, price);
    end 
    return   price ;
end 





function callBUY_emulation(price ,datetime)
    local trans_id_buy = getRand() 
    price = commonBUY(price ,datetime);
    setting.emulation_count_contract_buy = setting.emulation_count_contract_buy + setting.use_contract;


    local data = {
                ['price'] = price,
                ['datetime']= datetime, 
                ['trans_id']=  trans_id_buy, 
                -- сколько контрактов исполнилось  
                
                ['work'] = true,
                ['executed'] = true, -- покупка исполнилась
                ['type']= "buy",
                ['emulation']=  setting.emulation,
                ['contract']=  setting.use_contract,
                ['use_contract']=   setting.use_contract,  
                ['buy_contract']= price, -- стоимость продажи
                ['trans_id_buy']=  trans_id_buy, 
            };

            signalShowLog.addSignal(data.datetime, 24, false, #setting.sellTable);  
            setting.sellTable[(#setting.sellTable+1)] = data;
           signalShowLog.addSignal(data.datetime, 24, false, #setting.sellTable);  

           panelBids.show();
            sellTransaction_emulation(data) 
end 


-- выставляем заявку на продажу в режиме эмуляции
function sellTransaction_emulation(contractBuy)
    local price = 0;
    local type = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER";
    local  trans_id_sell  =  getRand();

          -- price = setting.profit_range + contractBuy.price  + setting.profit_infelicity;
           price = setting.profit_range + contractBuy.price;

            signalShowLog.addSignal(contractBuy.datetime, 22, false, #setting.sellTable); 

            setting.sellTable[#setting.sellTable + 1] = {
                                                            ['price'] = price,
                                                            ['datetime']= contractBuy.datetime, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['type']= 'sell',                
                                                            ['work'] = true,
                                                            ['executed'] = false, -- покупка исполнилась
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  setting.use_contract,
                                                            ['use_contract']=  setting.use_contract,
                                                            ['buy_contract']= contractBuy.price, -- стоимость продажи
                                                            ['trans_id_buy'] = contractBuy.trans_id_buy
                                                        };
                                                        signalShowLog.addSignal(contractBuy.datetime, 22, false, #setting.sellTable); 
    panelBids.show();
end;


-- исполнение продажи контракта в режиме эмуляции
function callSELL_emulation(result)

    local price = result.close;
    local trans_id_buy = "0";

    if #setting.sellTable > 0 then 
            for sellT = 1 ,  #setting.sellTable do 
                if  setting.sellTable[sellT].type == 'sell' and   
                setting.sellTable[sellT].work and  
                setting.sellTable[sellT].emulation  and  
                --     result.close + setting.profit_infelicity >= setting.sellTable[sellT].price 
                result.close  >= setting.sellTable[sellT].price   then 
                    
                       
                        setting.sellTable[sellT].work = false; 
                         
                        
                        execution_sell(setting.sellTable[sellT]);
                        -- сколько продано контрактов за сессию (режим эмуляции)ю
                        setting.emulation_count_contract_sell = setting.emulation_count_contract_sell + setting.sellTable[sellT].contract; 
                        setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;
    
                        signalShowLog.addSignal(result.datetime, 21 , false, result.close); 
                        -- надо удалить контракт по которому мы покупали 

                     --   panelBids.show();
                       deleteBuy_emulation(setting.sellTable[sellT])
 

                end;
            end; 
    end;
end


-- здесь ищем контракт который мы купили ранее 
-- после продажи контракта надо его пометить, что мы больше не используем
-- режим эмуляции
function deleteBuy_emulation(contract_sell)
    if #setting.sellTable > 0 then 
        for contract_buy_tr = 1 ,  #setting.sellTable do 

            if contract_sell.trans_id_buy == setting.sellTable[contract_buy_tr].trans_id then 
                setting.sellTable[contract_buy_tr].work = false;
                setting.sellTable[contract_buy_tr].use_contract =   setting.sellTable[contract_buy_tr].contract - contract_sell.use_contract;
               panelBids.show();
            end;
        end;
    end; 
end;





-- исполнение продажи кпо контракту
-- contract - контракт который продали
-- общие расчёты 
function execution_sell(contract)

--setting.each_to_buy_step
    -- увеличивает лимит используемых контрактов 
    
    if   setting.emulation and contract.contract > 0 and setting.limit_count_buy  > contract.contract  then 
        setting.limit_count_buy = setting.limit_count_buy - contract.contract;
    end;

    setting.count_buyin_a_row = 0; 

    -- цена последней продажи контракта
    setting.SPRED_LONG_LOST_SELL = contract.price; 


    setting.each_to_buy_step = 0;
    -- сколько исполнилось продаж
    setting.emulation_count_sell =  setting.emulation_count_sell + 1; 

    if
    setting.emulation == false and 
    setting.limit_count_buy_emulation > 0 and
    setting.limit_count_buy_emulation  + contract.contract > 0 then 
        setting.limit_count_buy_emulation = setting.limit_count_buy_emulation - contract.contract;
    end;

    -- падение цены прекратилось
    setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;

    if setting.SPRED_LONG_TREND_DOWN < 0  then 
        setting.SPRED_LONG_TREND_DOWN = 0.01;
    end;

end;

 




-- выставление заявки на покупку
function callBUY(price ,datetime)  

    price = commonBUY(price ,datetime);
    local trans_id_buy =  transaction.send("BUY", price, setting.use_contract, type, 0);
    setting.count_contract_buy = setting.count_contract_buy + setting.use_contract

    
    
     local data = {
                ['price'] = price,
                ['datetime']= datetime, 
                ['trans_id']=  trans_id_buy, 
                -- сколько контрактов исполнилось 
                ['use_contract']=   setting.use_contract, 
                ['trans_id_buy']=  trans_id_buy, 
                
                ['work'] = true,
                ['executed'] = false,
                ['type']= 'buy',
                ['emulation']=  setting.emulation,
                ['contract']=  setting.use_contract,
                ['buy_contract']= price, -- стоимость продажи
            };
            
            setting.sellTable[(#setting.sellTable+1)] = data;
            -- Выставили контракт на покупку
            signalShowLog.addSignal(datetime, 23, false, price); 
    panelBids.show();
end 

  
 
 

 

function getRand()
    return tostring(math.random(2000000000));
end;

 
 
M.transCallback   = transCallback;
-- M.callSELL   = callSELL;
 
 
M.callSELL_emulation   = callSELL_emulation ;
M.buyContract   = buyContract ;
M.sellContract   = sellContract ;
M.sellTransaction   = sellTransaction ;
M.bid   = bid ;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;
 
return M