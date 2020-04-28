

-- ЗДесь определённые условия для магазина

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua"); 

M = {};
  

-- не покупаем если продали в текущем состоянии

function getRandBuy(price, bids)
          
   -- ['SPRED_LONG_BUY_UP'] = 0.02, -- условия, не покупаем если здесь ранее мы купили | вверх диапозон,
   -- ['SPRED_LONG_BUY_down'] = 0.00, -- условия, не покупаем если здесь ранее мы купили | вниз диапозон
   
--    ['price'] = price,
--    ['dt']= dt, 
--    ['trans_id']= getRand(), 
--    ['type']= 'buy',
--    ['emulation']=  setting.emulation,
--    ['contract']=  setting.use_contract,
--    ['buy_contract']= price, -- стоимость продажи


    local checkRange = true;
    
    for j=1, #bids  do
        
            if bids[j].type == 'buy' then
                    -- здесь узнаю, была ли покупка в этом диапозоне
                    if   setting.SPRED_LONG_BUY_UP + bids[j].price > price and price >  bids[j].price - setting.SPRED_LONG_BUY_down   then
                        checkRange = false;
                    end; 
            end; 
    end;  

    return checkRange;
end;


 
M.getRandBuy = getRandBuy;
 
return M