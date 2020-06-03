-- ЗДесь определённые условия для магазина

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua"); 
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");

M = {};

-- не покупаем если купили в текущем состоянии
function getRandBuy(price)
          
    -- ['SPRED_LONG_BUY_UP'] = 0.02, -- условия, не покупаем если здесь ранее мы купили | вверх диапозон,
    -- ['SPRED_LONG_BUY_down'] = 0.00, -- условия, не покупаем если здесь ранее мы купили | вниз диапозон
     local checkRange = true;
                if #setting.sellTable > 0  then
                        for j_checkRangBuy=1, #setting.sellTable  do
                                if setting.sellTable[j_checkRangBuy].type == 'buy' and 
                                setting.sellTable[j_checkRangBuy].work then
                                -- здесь узнаю, была ли покупка в этом диапозоне
                                
                                        if   setting.profit_range + setting.sellTable[j_checkRangBuy].price >= price + setting.profit_infelicity  and 
                                        price >= setting.sellTable[j_checkRangBuy].price - setting.SPRED_LONG_BUY_down   then
                                        signalShowLog.addSignal(setting.sellTable[j_checkRangBuy].datetime, 11, false, price);
                                        checkRange = false;
                                        end; 
                                end; 
                        end;  
                end;  
     return checkRange;
 end;
 
 
 -- висит ли заявка на продажу в этом промежутке
function getRandSell(price)
  
        local checkRange = true;
           if #setting.sellTable > 0  then
                   for j_checkRange=1, #setting.sellTable  do

                        if setting.sellTable[j_checkRange].type == 'sell' and setting.sellTable[j_checkRange].work then
                                   -- здесь узнаю, была ли покупка в этом диапозоне
                                if   setting.profit_range + setting.sellTable[j_checkRange].price >= price and 
                                price >= setting.sellTable[j_checkRange].price - setting.profit_range   then
                                           checkRange = false; 
                                           signalShowLog.addSignal(setting.sellTable[j_checkRange].datetime, 12, false, price);
                                end; 
                        end; 
                   end;  
           end;  
        return checkRange;
    end;
 



 -- Лимит заявок на покупку
function getLimitBuy(datetime)

        local checkRange = true;
        
        if setting.emulation == false and setting.LIMIT_BID <= setting.limit_count_buy  then
                signalShowLog.addSignal(datetime, 16, false, setting.limit_count_buy);
                checkRange = false; 
        end;  

        
        if setting.emulation  and setting.LIMIT_BID <= setting.limit_count_buy then
                signalShowLog.addSignal(datetime, 25, false, setting.limit_count_buy);
                checkRange = false; 
        end;  

        return checkRange;
end;
       

 
 -- Не покупаем если промежуток на свече соответствуют высокой цене
 function getRandCandle(price, datetime)
        local range_candle = setting.candle_current_high - setting.candle_current_low;
        local checkRange = true;
                if range_candle < setting.profit_range  then 
                        -- свечка меньше текущего профита 
	                --	[13] = 'Текущая свеча меньше преполагаемого профита, низкая волатильность',   
                        checkRange = false;
                        signalShowLog.addSignal(datetime, 13, false, range_candle);
                end;  

                local priceMinimum =  setting.candle_current_high - setting.profit_range  ;

                if checkRange == true and priceMinimum > price + setting.profit_infelicity    then
                 
                else
                                -- свечка меньше текущего профита  
                                --	[14] = 'Цена на свече выше профита, покупка на верху невозможна',   
                        checkRange = false;
                        signalShowLog.addSignal(datetime, 14, false, priceMinimum );
                end; 
        return checkRange;
end;
    
     
 


 -- Падение рынка
 function getFailMarket(price, datetime) 
        local checkRange = true;
        if setting.SPRED_LONG_TREND_DOWN_LAST_PRICE == 0  or  
                setting.profit_range - setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - setting.SPRED_LONG_TREND_DOWN  > price  - setting.profit_infelicity  or 
                setting.SPRED_LONG_TREND_DOWN_LAST_PRICE  < price  then
        
        else
                checkRange = false;
                setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - setting.SPRED_LONG_TREND_DOWN;
                signalShowLog.addSignal(datetime, 3, true, setting.SPRED_LONG_TREND_DOWN_NEXT_BUY);

        end;
        return checkRange;
end;


 -- Запрет на покупку
 function getFailBuy(price, datetime) 
        local checkRange = true;
                if setting.each_to_buy_step >= setting.each_to_buy_to_block then
                        -- активация кнопки блокировки покупки
                        signalShowLog.addSignal(datetime, 18, true, price);
                        setting.each_to_buy_status_block = true;
                        control.buy_stop_auto();
                        checkRange = false; 
                end;
        return checkRange;
end;


-- проверка на блокировку кнопки покупок
function buyButtonBlock(price, datetime) 

        local checkRange = true;
                if setting.buy == false  then
                        signalShowLog.addSignal(datetime, 4, true, price);
                        checkRange = false; 
                end;
        return checkRange;
end;


-- верхний диапазон, выше которого покупка запрещена
function not_buy_high(price, datetime) 

        local checkRange = true;
                if price >= ( setting.not_buy_high - setting.profit_range )  then
                        signalShowLog.addSignal(datetime, 19, true, price);
                        checkRange = false; 
                end;
        return checkRange;
end;

 


M.not_buy_high = not_buy_high;
M.buyButtonBlock = buyButtonBlock;
M.getFailBuy = getFailBuy;
M.getLimitBuy = getLimitBuy;
M.getFailMarket = getFailMarket;
M.getRandCandle = getRandCandle;
M.getRandSell = getRandSell;
M.getRandBuy = getRandBuy;
 
return M