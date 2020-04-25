

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");
local bidTable = dofile(getScriptPath() .. "\\bidTable.lua");
local transaction = dofile(getScriptPath() .. "\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
 
 

M = {};
 
-- SHORT  = FALSE
-- LONG = true
 
local DIRECT = 'LONG'; 
-- local LIMIT = 1; -- limit order
 

local function setDirect(localDirect) -- решение
    DIRECT = localDirect;
    bidTable.create();
end

local function setLitmitBid(_limit) -- решение
    LIMIT = _limit;
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




function long(price, dt, levelLocal , event) -- решение
     
 --   signalShowLog.addSignal(dt, 0, status, price);

    getSetting();

    if event == 'SELL'  then
    --    loger.save( level..'  ' .. #bid .. '  SELL SELL  SELL SELL  SELL SELL  SELL SELL ' ..  price )
        if  #bid > 0  then 
           for j=1,  #bid  do
                if  bid[j] + setting.profit <  price   then
                     
                    profit =  price - bid[j] + profit;
                     
                --    loger.save(  ' profit ' ..profit   );
                    if SPRED_LONG_TREND_DOWN  - SPRED_LONG_TREND_DOWN_SPRED > 0  then
                        SPRED_LONG_TREND_DOWN  = SPRED_LONG_TREND_DOWN - SPRED_LONG_TREND_DOWN_SPRED; 
                    end; 
                    -- записываем цену продажи контракта 
                    callSELL(price,  dt, j);
                    SPRED_LONG_LOST_SELL = price;

                                -- продаём 
                    break;
                end; 
            end;  
             
        end; 
    else 
        
     --   loger.save(#bid .. '  SPRED ' .. '  buy long ' ..  price )
                        -- просто покупаем
        if  LIMIT >= #bid  then

                    local checkRange = true;
                   



            for j=1,  #bid  do
                        -- здесь узнаю, была ли покупка в этом диапозоне
                if  price + SPRED_LONG_BUY > bid[j]  then
                            checkRange = false;
                            -- продаём 28.22 SPRED_LONG_BUY 28.23
                      --      loger.save(  price  .. ' SPRED_LONG_BUY ' ..bid[j] ) ;
                end; 
            end;  


            if checkRange == true then
                      -- SPRED_LONG_BUY
                        -- мы покупаем, если в определённом диапозоне небыло покупок
                 loger.save( 'callBUY  '  .. price  );
                            -- мы не покупаем, если только что продали по текуще цене
                if(SPRED_LONG_LOST_SELL - SPRED_LONG_PRICE_DOWN > price or  price > SPRED_LONG_LOST_SELL + SPRED_LONG_PRICE_UP or SPRED_LONG_LOST_SELL ==0 ) then       
                    --    local SPRED_LONG_TREND_DOWN = 0.01; -- рынок падает, увеличиваем растояние между покупками
                    --    local SPRED_LONG_TREND_DOWN_SPRED = 0.01; -- на сколько увеличиваем растояние
                    --    local SPRED_LONG_TREND_DOWN_LAST_PRICE= 0; -- последняя покупка
 
                    if SPRED_LONG_TREND_DOWN_LAST_PRICE == 0  or  SPRED_LONG_TREND_DOWN_LAST_PRICE - SPRED_LONG_TREND_DOWN > price  or SPRED_LONG_TREND_DOWN_LAST_PRICE  < price  then

                        SPRED_LONG_TREND_DOWN  = SPRED_LONG_TREND_DOWN + SPRED_LONG_TREND_DOWN_SPRED;
                        SPRED_LONG_TREND_DOWN_LAST_PRICE = price; -- записываем последнюю покупку
                         callBUY(price,  dt); 
                        -- SPRED_LONG_TREND_DOWN
                    end;
                end;  

            end;       
        end;  
    end;  
end

function callSELL(price ,dt ,j)
    -- метод срабатывает когда транкзакция на продажу исполняется

    if setting.sell == false  then return; end;

     

  --  label.set(event, priceLocal , datetime,levelLocal);
    -- продаём по дешевле
    price = price - 0.01;
    table.remove (bid,j);
    label.set("SELL" , price, dt, 0);
    bidTable.show(bid);
    loger.save('profit:' ..profit..' SELL: ' .. price ..' contracts left: '.. #bid   );
    count_sell = count_sell + 1;
  --  return;
   --  transaction.send("SELL", price, setting.use_contract);
 
end




function callBUY(price ,dt)
  if setting.buy == false  then return; end;
    -- ставим заявку на покупку выше на 0.01
    price  = price + 0.01; -- и надо снять заявку если не отработала
    -- покупаем по дороже (
    bid [#bid+1] = price; 
    label.set("BUY" , price, dt, 0);
    bidTable.show(bid);
    count_buy = count_buy + 1;

    if setting.emulation == false then
       local trans_id_buy =  transaction.send("BUY", price, setting.use_contract);
            if(setting.use_contract > 1 ) then
                for j=1,  setting.use_contract  do 
                    local p = setting.profit + price + (setting.profit_range * j) ;
                trans_id_sell = transaction.send("SELL", p, setting.use_contract );
                end;
            else 
                local p = setting.profit + price;
                trans_id_sell =  transaction.send("SELL", p, setting.use_contract );
            end 
    else


    end;


end 


 
M.bid   = bid 
M.decision = decision
M.setDirect = setDirect
M.setLitmitBid = setLitmitBid
 
return M