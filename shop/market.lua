

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
 
 

M = {};
 
-- SHORT  = FALSE
-- LONG = true
 
local DIRECT = 'LONG'; 
-- local LIMIT = 1; -- limit order
 

local function setDirect(localDirect) -- решение
    DIRECT = localDirect;
  --  bidTable.create();
end

local function setLitmitBid() -- решение
    LIMIT = setting.LIMIT_BID;
end
-- price текущая цена
-- levelLocal  сила сигнала
-- event -- продажа или покупка

local function decision(event, price, datetime, levelLocal) -- решение
    long(price, datetime, levelLocal , event);
end

local level = 1;
  
function getSetting()
    if setting_scalp then
        SPRED_LONG_BUY = 0.03; -- покупаем если в этом диапозоне небыло покупок
    end   
end   



-- автоматическая торговля
function long(price, datetime, levelLocal , event) -- решение 
    getSetting();
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
            -- лимит по заявкам
            getFailBuy = contitionMarket.getFailBuy(datetime);

            

            if limitBuy and checkRangeBuy and checkRangeSell and randCandle  and failMarket and getFailBuy then
                SPRED_LONG_TREND_DOWN  = SPRED_LONG_TREND_DOWN + SPRED_LONG_TREND_DOWN_SPRED;
                SPRED_LONG_TREND_DOWN_LAST_PRICE = price; -- записываем последнюю покупку
                    callBUY(price,  datetime);
                    signalShowLog.addSignal(datetime, 10, false, price); 
            end;  
              
end






function getfractal(price)  

    if #setting.fractals_collection > 0 then 
        for k,v in setting.fractals_collection do 

            label.set("k " , k);

        end
    end;

end;

buy_contract  = 0;

-- function callSELL(result)
    
--     -- if #setting.sellTable > 0 then
--     --     deleteSell(result);
--     -- end;
-- end


-- function deleteSell(result)
--     local buyContractSell = 0;
--     local deleteKeySell = 0;
--         for sellT = 1 ,  #setting.sellTable do 
--         --   if statusRange then
--                 if  setting.sellTable[sellT].type == 'sell' and result.close + setting.profit_infelicity >= setting.sellTable[sellT].price  then 
--                     local price = result.close;
--                     setting.count_buyin_a_row = 0; 

--                     SPRED_LONG_LOST_SELL = price;

--                     SPRED_LONG_TREND_DOWN  = SPRED_LONG_TREND_DOWN - SPRED_LONG_TREND_DOWN_SPRED;
                    
--                     setting.count_sell =  setting.count_sell + 1; 
--                     setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;



--                     signalShowLog.addSignal(result.datetime, 8, false, setting.sellTable[sellT].price); 

--                     -- надо удалить контракт по которому мы покупали
--                     buyContractSell = setting.sellTable[sellT].buy_contract; 
--                     deleteKeySell = sellT; 
--             end;
--         end;
        

--         if deleteKeySell ~= 0  then 

--          --   loger.save(' #setting.sellTable #setting.sellTable #setting.sellTable #setting.sellTable  ' ..  #setting.sellTable  );
--             table.remove (setting.sellTable, deleteKeySell); 
--             deleteBuy(result,buyContractSell); 
             
--         end;
-- end


-- function deleteBuy(result,buy_contract)
--     local deleteKey = 0;
--     local buyPrice = 0;
--     for searchBuy = 1 ,  #setting.sellTable do 
--         if setting.sellTable[searchBuy].type == 'buy' and setting.sellTable[searchBuy].price == ( buy_contract + setting.profit_infelicity)  then 
--                 -- удаляем только 1 элемент
--                 setting.limit_count_buy = setting.limit_count_buy - 1;
--                 deleteKey = searchBuy; 
--                 buyPrice = setting.sellTable[searchBuy].price;
--         end;
--     end;
--     if deleteKey  ~= 0  then 
--         table.remove (setting.sellTable, deleteKey);
     
--         panelBids.show();
--     end;

-- end




function commonBUY(price ,dt)


    label.set("BUY" , price, dt, 0);
    setting.count_buy = setting.count_buy + 1;
    -- текущаая свеча
    setting.candles_buy_last = setting.number_of_candles;
    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
    setting.limit_count_buy = setting.limit_count_buy + 1; -- отметка для лимита
    
    signalShowLog.addSignal(dt, 7, false, price);
end 


function callBUY(price ,dt)
    local priceLocal = price;
    local trans_id = getRand()
    local type = false
    -- ставим заявку на покупку выше на 0.01
    price  = price + setting.profit_infelicity; -- и надо снять заявку если не отработал
 
   
    commonBUY(price ,dt);
 
    if setting.emulation == false then
       local trans_id =  transaction.send("BUY", price, setting.use_contract, type);
    end;
   
    sellTransaction(priceLocal,dt);  
            setting.sellTable[(#setting.sellTable+1)] = {
                ['price'] = price,
                ['datetime']= dt, 
                ['trans_id']=  trans_id, 
                ['type']= 'buy',
                ['emulation']=  setting.emulation,
                ['contract']=  setting.use_contract,
                ['buy_contract']= price, -- стоимость продажи
                
            };
    panelBids.show();
end 

  
function sellTransaction(priceLocal,dt)
    local p = 0;
    local type = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER";
    local  trans_id_sell  =  getRand();
            p = setting.profit_range + priceLocal  + setting.profit_infelicity;
            if setting.emulation == false then
                trans_id_sell =  transaction.send("SELL", p, setting.use_contract, type);
            end;

            signalShowLog.addSignal(dt, 9, false, p); 

            signalShowLog.addSignal(dt, 9, false,trans_id_sell); 

            loger.save('trans_id_sell = ' ..  trans_id_sell ); 


            setting.sellTable[(#setting.sellTable+1)] = {
                                                            ['price'] = p,
                                                            ['datetime']= dt, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['type']= 'sell',
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  setting.use_contract,
                                                            ['buy_contract']= priceLocal, -- стоимость продажи
                                                        };
    label.set('red', p , dt, 1, 'sell contract '.. 1);
end;

 


function getRand()
    return tostring(math.random(2000000000));
end;

 
 
M.transCallback   = transCallback;
-- M.callSELL   = callSELL;
M.bid   = bid ;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;
 
return M