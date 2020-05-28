local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
 

-- класс для работы с стопами


-- стопы обновляются только при покупке или продаже контракта
-- при срабатывании стопа, должны убираться контракты которые находятся на самом вверху
-- и закрываться позиции по покупке. Более такие позиции не учитываются в логике
function update_stop()
    getStopBid();
    createStop();
end;

 
function setStopDefault()
    stopClass.price_max = 0;
    stopClass.price_min = 10000000;
    stopClass.spred = 0.8;
    stopClass.spred_range = 0.1;
    stopClass.contract_work = 0;
end;

 -- расчёт максимального отступа от максимальной цены
 function getMaxStopPrice()
    
    return  stopClass.price_max - stopClass.spred;
end;
-- расчёт цены для следующего стоп заявки
function getMaxPriceRange(mPrice, countStop)
    if countStop == 0 then 
        countStop = 1;
    end;

    mPrice = mPrice * countStop;
    mPrice = stopClass.price_max - stopClass.spred_range + mPrice;
   return mPrice;
end;


 


-- функция сбора заявок для стопов
function getStopBid()
    setStopDefault();
    for contractStop = 1 ,  #setting.sellTable do 
            -- берём все заявки которые куплены
        if  setting.sellTable[contractStop].type == 'buy' and    setting.sellTable[contractStop].work then
            stopClass.contract_work = stopClass.contract_work + setting.sellTable[contractStop].use_contract;
            
            if setting.sellTable[contractStop].price > stopClass.price_max then 
                -- максимальная цена покупки
                stopClass.price_max = setting.sellTable[contractStop].price ;
            end 


            if setting.sellTable[contractStop].price < stopClass.price_min then 
                -- минимальная цена покупки
                stopClass.price_min = setting.sellTable[contractStop].price ;
            end 
        end;
    end;
end;

-- снимаем стоп
function removeStop() 
     


end;

-- Ставим новый стоп
function createStop() 
    
 
    maxPrice = getMaxStopPrice();

    local contract_work = stopClass.contract_work + stopClass.contract_add;
    if contract_work > 0 then 
        if contract_work == 1 then 
            -- один стоп
 
                    sendTransStop(contract_work, maxPrice);
        else

            if stopClass.count_stop >= 2  then 
                -- более двух стопов

                if contract_work  > stopClass.count_stop  then 
    

                    local lost_contract_start = 0;

                    -- количество контрактов на 1 стоп
                    local contract = math.floor(contract_work / stopClass.count_stop);

                    -- остаток от контрактов
                    local lost_contract = contract_work % stopClass.count_stop; -- в переменной A число остаток


                    -- сперва ставим стоп контракты с остатками, если таковые имеются
                    if  lost_contract ~= 0  then 
                        local stopContractCount = contract + lost_contract;

                        local price  = getMaxPriceRange(maxPrice, lost_contract);
                        sendTransStop(stopContractCount, price);
                        lost_contract_start = 1;
                    end;
                    
                    for contractItterationLimit = lost_contract_start, stopClass.count_stop do 
                        -- расставляем стопы
                        local price  = getMaxPriceRange(maxPrice, contractItterationLimit);
                        sendTransStop(contract_work, price);
                    end; 
                else
                        --   1 стоп
                        sendTransStop(contract_work, maxPrice);
                end; 

            end; 

        end; 
    end;

    local count = 0;
end;


-- снимаем старые стоп заявки
function backStop()

    -- обнуляем заявки
    if #stopClass.array_stop > 0 then

        for s = 1 ,  #stopClass.array_stop do 
            if #stopClass.array_stop[s].emulation then
                -- удаляем метку

            else
                -- снимаем стоп заявку

            end;
            
        end;

    end;

    stopClass.array_stop = {};
    
end;



-- отправляем транкзакцию
-- countContract - сколько контрактов на стопе
-- countPrice - стоимость контракта
function sendTransStop(countContract, countPrice )
    -- [28] = 'Ставим стоп заявку в режиме эмуляции', 
    -- [29] = 'Ставим стоп заявку',  

    local dataParam = {};
            dataParam.emulation = setting.emulation;
            dataParam.price = countPrice;
            dataParam.contract = countContract;
            dataParam.trans_id = getRand();
            dataParam.label = 0;
 
    
    if setting.emulation then
        -- рисуем стоп

        signalShowLog.addSignal(setting.datetime, 28, false, countPrice); 
        dataParam.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop')
         
   
    else
          
        signalShowLog.addSignal( setting.datetime, 29, false, countPrice);  
        -- отправляем транкзакцию 
    end;

    stopClass.array_stop[ #stopClass.array_stop + 1 ] = dataParam; 
    
end;
 


function getRand()
    return tostring(math.random(2000000000));
end;




stopClass.transCallback = transCallback;
stopClass.update_stop = update_stop;
 
return stopClass