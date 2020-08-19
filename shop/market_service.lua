
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");

 

-- надо отсортировать все контракты на покупку и найти с самой высокой ценой
function getLastSell()

    local price_min_sell = 1000000
    setting.price_min_sell = price_min_sell
    setting.price_max_sell = 0

    if #setting.sellTable == 0 then return 0; end

    for contractStop = 1, #setting.sellTable do
        -- берём все заявки которые выставлены на продажу
        if setting.sellTable[contractStop].type == 'sell' and
            setting.sellTable[contractStop].work then
            -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
            if setting.sellTable[contractStop].price > setting.price_max_sell then
                -- максимальная цена продажи
                setting.price_max_sell = setting.sellTable[contractStop].price;

            end

            if setting.sellTable[contractStop].price < setting.price_min_sell then
                -- минимальная цена продажи
                setting.price_min_sell = setting.sellTable[contractStop].price;
            end
        end
    end

    if price_min_sell ~= setting.price_min_sell then
        return setting.price_min_sell;
    end

    -- не стоит заявок на продажу, всё продали
    return 0;
end




 
-- здесь подсчитываем сколько контрактов можем купить
-- range_sell_buy - растояние между продажей и покупкой
function getPullBuy(range_sell_buy)
    local use_contract = 0; 

    if range_sell_buy > setting.profit_range then 
        -- есть место для одного контракта
        use_contract = use_contract + 1;
        range_sell_buy = range_sell_buy - setting.profit_range;
        loger.save('getPullBuy |0|  use_contract=' .. use_contract );
    end;
    
    if range_sell_buy > setting.profit_range_array then 
      local contract_add =  math.ceil(range_sell_buy / setting.profit_range_array) - 1
      
      loger.save('getPullBuy |1|  contract_add=' .. contract_add.." range_sell_buy="..range_sell_buy );
        if contract_add > 0 then 
            use_contract =   use_contract + contract_add;
            loger.save('getPullBuy |2| ' .. use_contract .. ' contract_add=' .. contract_add );
        end;
    end;
    
    if setting.use_contract < use_contract then 
        use_contract = setting.use_contract;
    end
    loger.save('getPullBuy |3| ' .. use_contract );
    return use_contract;
end;


 
-- здесь подсчитываем сколько контрактов можем продать
-- range_price - растояние между продажей и покупкой
-- ONLY SHORT
function getPullsell(range_price)
    local use_contract = 0; 

    if range_price > setting.profit_range then 
        -- есть место для одного контракта
        use_contract = use_contract + 1;
        range_price = range_price + setting.profit_range;
        loger.save('getPullBuy |0|  use_contract=' .. use_contract );
    end;
    
    if range_price < setting.profit_range_array then 
      local contract_add =  math.ceil(range_price / setting.profit_range_array) + 1
      
      loger.save('getPullBuy |1|  contract_add=' .. contract_add.." range_price="..range_price );
        if contract_add > 0 then 
            use_contract =   use_contract + contract_add;
            loger.save('getPullBuy |2| ' .. use_contract .. ' contract_add=' .. contract_add );
        end;
    end;
    
    if setting.use_contract < use_contract then 
        use_contract = setting.use_contract;
    end
    loger.save('getPullBuy |3| ' .. use_contract );
    return use_contract;
end;


-- надо отсортировать все контракты и найти с самой низкой/высокой ценой
function getLastMinMax()
    
    local price_min_sell = 1000000
    local price_max_sell = 0

    local price_min_buy = 1000000
    local price_max_buy  = 0  

    if #setting.sellTable == 0 then return; end
    for contractStop = 1, #setting.sellTable do
        -- берём все заявки которые куплены
        if  setting.sellTable[contractStop].work then 

            if setting.sellTable[contractStop].type == 'buy' then
                -- больше для лонга

                -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
                if setting.sellTable[contractStop].price > price_max_buy  then
                    -- максимальная цена покупки
                    price_max_buy  = setting.sellTable[contractStop].price
                end

                if setting.sellTable[contractStop].price < price_min_buy then
                    -- минимальная цена покупки
                    price_min_buy = setting.sellTable[contractStop].price; 
                end

            else 
                -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
                if setting.sellTable[contractStop].price > price_max_sell then
                    -- максимальная цена покупки
                    price_max_sell = setting.sellTable[contractStop].price;
                end

                if setting.sellTable[contractStop].price < price_min_sell then
                    -- минимальная цена покупки
                    price_min_sell = setting.sellTable[contractStop].price;
                end

            end
        end
    end

    
    setting.price_min_sell = price_min_sell
    setting.price_max_sell = price_max_sell
    
    setting.price_min_buy = price_min_buy
    stopClass.price_min = price_min_buy
    setting.price_max_buy = price_max_buy 
    stopClass.price_max = price_max_buy 
end

-- здесь мы вычисляем, сколько контрактов необходимо купить
-- Всё зависит от количество проданых контрактов
function getUseContract(price)

    loger.save('getUseContract  price = ' .. price.. " setting.use_contract="..setting.use_contract );
    
    if setting.use_contract == 1 then
        -- если 1 контракт
        return setting.use_contract;
    end 
    -- если контрактов больше, то надо расчитать сколько покупать, в зависимости от количества проданых контрактов
    -- минимальная прибыль
    --setting.profit_range = 0.05;
    -- минимальная прибыль при больших заявках при торговле веерной продажей
    -- setting.profit_range_array = 0.04;
    if setting.profit_range_array == 0 then 
      --  не используется веерная продажа
      
      loger.save('getUseContract 1 setting.use_contract = ' .. setting.use_contract );
        return setting.use_contract
    else 
        
        loger.save('getUseContract 2 setting.use_contract = '  .. setting.use_contract  );
        -- расчет - надо узнать где стоит ближайшая заявка на продажу по минимальной цене в работе
 



        
        if setting.mode == 'buy' then
                -- only  long 
                local price_min_sell = getLastSell();
            if price_min_sell == 0 then 
                -- у нас не стоит контракты на продажу
                loger.save('getUseContract 2 setting.use_contract = ' .. setting.use_contract );
                return setting.use_contract;
            else
                -- стоит контракт на продажу
                local range_sell_buy = setting.price_min_sell - price
                -- как далеко от цены покупки?
                -- здесь подсчитываем сколько контрактов можем купить
                
                loger.save('getUseContract |5| range_sell_buy = '  .. range_sell_buy );
            return getPullBuy(range_sell_buy);
            end 
        else 
            -- only short
           -- only  long 
           local price_min_buy = getLastMinMax();
           if price_min_buy == 0 then 
               -- у нас не стоит контракты на продажу
               loger.save('getUseContract 2 setting.use_contract = ' .. setting.use_contract );
               return setting.use_contract;
           else
               -- стоит контракт на продажу
               local range_sell_buy = setting.price_min_sell + price
               -- как далеко от цены покупки?
               -- здесь подсчитываем сколько контрактов можем купить
               
               loger.save('getUseContract |5| range_sell_buy = '  .. range_sell_buy );
           return getPullsell(range_sell_buy);
           end 
        end




        return setting.use_contract;
    end 
end




-- finish, general function
-- исполнение продажи по контракту
-- contract - контракт который продали
-- общие расчёты 
function executionContractFinish(contract)

    -- увеличивает лимит используемых контрактов
    getLastMinMax()

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

    check_buy_status_block(contract);
end