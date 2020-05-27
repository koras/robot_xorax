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

    local contract_work = stopClass.contract_work + stopClass.contract_add;
    if contract_work > 0 then 
        if contract_work == 1 then 
            -- один стоп
                    sendTransStop(contract_work);
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


                        sendTransStop(stopContractCount);
                        lost_contract_start = 1;
                    end;
                    
                    for contractItterationLimit = lost_contract_start, stopClass.count_stop do 
                        -- расставляем стопы
                        sendTransStop(contract_work);
                    end; 
                else
                        --   1 стоп
                        sendTransStop(contract_work);
                end; 

            end; 

        end; 
    end;

    local count = 0;
end;


-- снимаем старые стоп заявки
function backStop()
    -- обнуляем заявки
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

    stopClass.array_stop[ #stopClass.array_stop + 1 ] = dataParam;
    
    if setting.emulation then
        -- рисуем стоп
        signalShowLog.addSignal(setting.datetime, 28, false, countPrice);  
    else
        signalShowLog.addSignal( setting.datetime, 29, false, countPrice);  
        -- отправляем транкзакцию 

    end;
    
end;





stopClass.transCallback = transCallback;
stopClass.update_stop = update_stop;
 
return stopClass

