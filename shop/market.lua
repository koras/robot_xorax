

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
-- local LIMIT = 1; -- limit order
 

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

            getfractal(price);
 

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
         


                    callBUY(price,  datetime);
                    -- обновляем изменения в панели управления
                    control.use_contract_limit();

                    signalShowLog.addSignal(datetime, 10, false, price); 
            end;  
              
end






function getfractal(price)  

    if #setting.fractals_collection > 0 then 
        for k,v in setting.fractals_collection do 

 

        end
    end;

end;

buy_contract  = 0;
 



function commonBUY(price ,dt)
    setting.count_buy = setting.count_buy + 1;
    -- текущаая свеча
    setting.candles_buy_last = setting.number_of_candles;
    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
    setting.limit_count_buy = setting.limit_count_buy + setting.use_contract; -- отметка для лимита
    
    signalShowLog.addSignal(dt, 7, false, price);
end 










-- исполнение покупки контракта
function buyContract(result)
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then

        for contract = 1 ,  #setting.sellTable do 
            if  setting.sellTable[contract].type == 'buy' and  
            setting.sellTable[contract].executed == false  and 
            setting.sellTable[contract].trans_id == result.trans_id  then
                
                setting.sellTable[contract].executed = true;
                -- выставляем на продажу контракт.
                sellTransaction(result, countContracts);
            end;
        end;
    end;
end;

 

-- исполнение покупки контракта на продажу
function sellContract(result)
    -- сперва находим контракт который купили и ставим статус что мы купили контракт
    if #setting.sellTable > 0 then

        for contract = 1 ,  #setting.sellTable do 
            if  setting.sellTable[contract].type == 'sell' and  
            setting.sellTable[contract].executed == false  and 
            setting.sellTable[contract].trans_id == result.trans_id  then
                
                setting.sellTable[contract].executed = true;
                -- для учёта при выставлении заявки
                setting.sellTable[contract].work = false;
                -- выставляем на продажу контракт.
                deleteBuy(result, setting.sellTable[contract])
            end;
        end;
    end;
end;


 -- надо отметить в контркте на покупку что заявка исполнена
function deleteBuy(result, saleContract)
    if #setting.sellTable > 0 then
        for sellT = 1,  #setting.sellTable do 
            if  setting.sellTable[sellT].type == 'buy' and  
            setting.sellTable[sellT].executed == true and 
            setting.sellTable[sellT].use_contract > 0  and
            setting.sellTable[sellT].trans_id == result.trans_id  then 
                    local local_contract = setting.sellTable[sellT];

                    setting.sellTable[sellT].use_contract = local_contract.use_contract - saleContract.contract;


                    setting.count_buyin_a_row = 0; 
                    setting.SPRED_LONG_LOST_SELL = result.price;
                    setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;

                    if setting.SPRED_LONG_TREND_DOWN < 0  then 
                        setting.SPRED_LONG_TREND_DOWN = 0.01;
                    end;

                    if setting.sellTable[sellT].use_contract >= 0 then 
                        -- использовать контракт в работе
                        setting.sellTable[sellT].work = false;
                    end;

                    
                    setting.limit_count_buy = setting.limit_count_buy - saleContract.contract;
                    setting.count_contract_sell = setting.count_contract_sell + saleContract.contract;
                    -- calculateProfit(setting.sellTable[sellT]);

                    signalShowLog.addSignal(result.datetime, 8, false, result.price); 
                    -- надо удалить контракт по которому мы покупали
            end;
        end;
    end;
end





-- выставление заявки на продажу
function callBUY(price ,dt)
    local priceLocal = price;
    local trans_id = getRand()
    local type = false
    -- ставим заявку на покупку выше на 0.01
    price  = price + setting.profit_infelicity; -- и надо снять заявку если не отработал
 

    commonBUY(price ,dt);
 
    if setting.emulation == false then
       local trans_id_buy =  transaction.send("BUY", price, setting.use_contract, type, 0);
       setting.count_contract_buy = setting.count_contract_buy + setting.use_contract
    else 
        setting.emulation_count_contract_buy = setting.emulation_count_contract_buy + setting.use_contract
    end;
   

            setting.sellTable[(#setting.sellTable+1)] = {
                ['price'] = price,
                ['datetime']= dt, 
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
    panelBids.show();
end 

  
-- только выставляется заявка на продажу

function sellTransaction(order, countContracts)
    --loger.save("trans_id".. order.trans_id);
    --loger.save("trans_id".. order.order_num); 


    local type = "TAKE_PROFIT_STOP_ORDER";
    for contract = 1 ,  #setting.sellTable do 

    local  trans_id_sell  =  getRand();
            local price = setting.profit_range + order.price + setting.profit_infelicity;
            if setting.emulation == false then
                 trans_id_sell =  transaction.send("SELL", p, setting.use_contract, type, order.order_num);
            end;

            signalShowLog.addSignal(order.datetime, 9, false, p); 
            
            loger.save('trans_id_sell = ' ..  trans_id_sell ); 
            setting.sellTable[(#setting.sellTable+1)] = {
                                                            ['price'] = price,
                                                            ['datetime']= order.datetime, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['order_num_buy']=  order.order_num, 
                                                            ['use_contract']=   setting.use_contract, 
                                                            ['type'] = 'sell',
                                                            ['work'] = true,
                                                            ['executed'] = false,
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  setting.use_contract,
                                                            ['buy_contract']= priceLocal, -- стоимость продажи
                                                        };

    end;
end;

 

function getRand()
    return tostring(math.random(2000000000));
end;

 
 
M.transCallback   = transCallback;
-- M.callSELL   = callSELL;

 
M.buyContract   = buyContract ;
M.sellTransaction   = sellTransaction ;
M.bid   = bid ;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;
 
return M