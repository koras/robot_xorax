

-- ЗДесь определённые условия для магазина

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua"); 
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");

M = {};
  
--    ['price'] = price,
--    ['dt']= dt, 
--    ['trans_id']= getRand(), 
--    ['type']= 'buy',
--    ['emulation']=  setting.emulation,
--    ['contract']=  setting.use_contract,
--    ['buy_contract']= price, -- стоимость продажи

-- не покупаем если продали в текущем состоянии

function getRandBuy(price, bids)
          
    -- ['SPRED_LONG_BUY_UP'] = 0.02, -- условия, не покупаем если здесь ранее мы купили | вверх диапозон,
    -- ['SPRED_LONG_BUY_down'] = 0.00, -- условия, не покупаем если здесь ранее мы купили | вниз диапозон
     local checkRange = true;
             for j_checkRange=1, #bids  do
                     if bids[j_checkRange].type == 'buy' then
                             -- здесь узнаю, была ли покупка в этом диапозоне
                             if   setting.SPRED_LONG_BUY_UP + bids[j_checkRange].price >= price and price >= bids[j_checkRange].price - setting.SPRED_LONG_BUY_down   then
                                 checkRange = false;
                              --   signalShowLog.addSignal(bids[j_checkRange].dt, 11, false, price);
                     end; 
             end; 
     end;  
     return checkRange;
 end;
 
 
 -- пвисит ли заявка на продажу в этом промежутке
function getRandSell(price, bids)

     local checkRange = true;
             for j_checkRange=1, #bids  do
                     if bids[j_checkRange].type == 'sell' then
                             -- здесь узнаю, была ли покупка в этом диапозоне
                             if   setting.profit + bids[j_checkRange].price >= price and price >= bids[j_checkRange].price - setting.profit   then
                                 checkRange = false;
                                 signalShowLog.addSignal(bids[j_checkRange].dt, 12, false, #bids);
                                 signalShowLog.addSignal(bids[j_checkRange].dt, 12, false, price);
                     end; 
             end; 
     end;  

     return checkRange;
 end;
 
  
 

 
M.getRandSell = getRandSell;
M.getRandBuy = getRandBuy;
 
return M