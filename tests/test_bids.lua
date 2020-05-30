-- заявки для режима эмуляции

local M = {};
M.test_bids = {};

-- генерация списка заявок для тестирования
-- curentPrice - текущая цена на контракте
-- тестирование только в режиме эмуляции

function getOrder(curentPrice)

    local stepPrice = 0.05
    local stepPricerange = 0.01
    local executed = true;
    local emulation = true;

    curentPrice = curentPrice + 0.1;
 

    for testB = 1 ,  10  do 
        
        local rangePrice = stepPricerange * testB;
        curentPrice = curentPrice +  rangePrice;

        local trans_id_buy = getRand();
        local trans_id_sell = getRand();
         

            local  buy_order_bids = {
                ['price'] = curentPrice,
                ['datetime']= setting.datetime, 
                ['trans_id']= trans_id_buy, 
                ['type']= 'buy',                
                ['work'] = true,
                ['executed'] = executed, -- покупка исполнилась
                ['emulation']= emulation,
                ['contract']=  1,
                ['use_contract']=  1,
                ['buy_contract']= curentPrice, -- стоимость продажи
                ['trans_id_buy'] = trans_id_buy
            };

            local  sell_order_bids = {
                ['price'] = curentPrice + stepPrice, -- продажа
                ['datetime']= setting.datetime, 
                ['trans_id']= trans_id_sell, 
                ['type']= 'sell',                
                ['work'] = true,
                ['executed'] = executed,  
                ['emulation']= emulation,
                ['contract']=  1,
                ['use_contract']=  1,
                ['buy_contract']= stepPrice, -- стоимость продажи
                ['trans_id_buy'] = trans_id_buy
            };
            M.test_bids[#M.test_bids + 1] = buy_order_bids;
            M.test_bids[#M.test_bids + 1] = sell_order_bids;

            curentPrice = curentPrice
        end;
    return  M.test_bids;
end;






-- воссоздаём ситуацию, что продали несколько контрактов, допустим 5;
function saleBids(priceBig) 
    -- сколько контрактов сделать проданными
    local priceBig = priceBig + 1;
    message(priceBig)
    if #setting.sellTable > 0 then 
        for cbuy = 1 ,  #setting.sellTable  do 
                if priceBig > setting.sellTable[cbuy].price then 
                setting.sellTable[cbuy].work = false;
                setting.sellTable[cbuy].use_contract =  0;
            end;
        end;
    end; 
end;




function getRand()
    return tostring(math.random(2000000000));
end;

 
M.saleBids = saleBids;
M.getOrder = getOrder;
return M;