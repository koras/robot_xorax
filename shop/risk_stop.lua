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


stopClass = {};
-- максимальная цена в заявке
stopClass.price_max = 0;
-- минимальная цена в  заявке
stopClass.price_min = 10000000;

-- количество контрактов в работе
stopClass.contract_work = 0;

-- количество контрактов добавленных трейдером
stopClass.contract_add = 0;


-- расстояние от максимальной покупки
stopClass.spred = 5;
-- количество стопов
stopClass.count_stop = 2;
-- увеличение промежутка между стопами
stopClass.spred_range = 0.1;


-- стопы обновляются только при покупке или продаже контракта
-- при срабатывании стопа, должны убираться контракты которые находятся на самом вверху
-- и закрываться позиции по покупке. Более такие позиции не учитываются в логике
function update_stop()

    if setting.emulation then
      
    else

    end;
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
                    sendTransStop();
        else

            if stopClass.count_stop >= 2  then 
                for contractStopLimit = 0 , stopClass.count_stop do 
                    -- расставляем стопы
                    sendTransStop();
                end; 
            end; 

        end; 
    end;

    local count = 0;
end;

-- отправляем транкзакцию
function sendTransStop()

end;





stopClass.transCallback = transCallback;

return stopClass