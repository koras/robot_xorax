local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

-- local markets = dofile(getScriptPath() .. "\\shop\\market.lua");
  

-- класс для работы с стопами, риск-менеджмент
-- Главное не сколько заработаешь, а сколько не потеряешь


-- стопы обновляются только при покупке или продаже контракта
-- при срабатывании стопа, должны убираться контракты которые находятся на самом вверху
-- и закрываться позиции по покупке. Более такие позиции не учитываются в логике
function update_stop()
    if false then 
        -- получаем заявки для ордеров
        getOrdersForBid();
        -- снимаем старые стопы если таковые имеются
        backStop();
        -- генерируем объёкт из стоп заявок
        -- и ставим стоп
        generationCollectionStop(); 
    end;
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
function getMaxPriceRange(countStop)
 --   stopClass.triger_stop
   local  mPrice =  stopClass.price_max - ( stopClass.spred_range * countStop)  - stopClass.spred;

   return mPrice;
end;


 


-- функция сбора заявок для стопов
function getOrdersForBid()
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


-- Ставим новый стоп, но если сработал стоп, увеличиваем стоп на количество срабатываемых стопов и уменьшаем количество стопов

function generationCollectionStop() 
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

                    local lost_contract_start = 1;

                    -- количество контрактов на 1 стоп
                    local contract = math.floor(contract_work / stopClass.count_stop);

                    -- остаток от контрактов
                    local lost_contract = contract_work % stopClass.count_stop; -- в переменной A число остаток


                    -- сперва ставим стоп контракты с остатками, если таковые имеются
                    if  lost_contract ~= 0  then 
                        local stopContractCount = contract + lost_contract;
                        local price  = getMaxPriceRange(lost_contract); 
                        sendTransStop(stopContractCount, price);
                    end;
                    
                    for contractItterationLimit = lost_contract_start, stopClass.count_stop do 
                        -- расставляем стопы 
                        local price  = getMaxPriceRange(contractItterationLimit);
                        sendTransStop(contract, price);
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
            if stopClass.array_stop[s].emulation then
                -- удаляем метку
                DelLabel(setting.tag, stopClass.array_stop[s].label);
                signalShowLog.addSignal(setting.datetime, 15, false, stopClass.array_stop[s].price); 
            --   dataParam.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop '..countContract)
            else
                -- снимаем стоп заявку
                if  stopClass.array_stop[s].work == 1 then 
                    local order_num = stopClass.array_stop[s].order_num;
                    local trans_id = stopClass.array_stop[s].trans_id;
                    transaction.delete(trans_id, order_num);
                end;
            end;
            
        end;

    end;


    
end;



-- создаём объёкт 
-- countContract - сколько контрактов на стопе
-- countPrice - стоимость контракта


function sendTransStop(countContract, countPrice )
    local dataParam = {};
            dataParam.emulation = setting.emulation;
            dataParam.price = countPrice;
            dataParam.contract = countContract;
            dataParam.trans_id = getRand();
            dataParam.label = 0;
            -- work = 0 - отправляем на сервер
            -- work = 1 - заявка выставлена
            -- work = 2 - заявка снята пл какой либо причине
            dataParam.work = 0;
            dataParam.order_num = 0;
             
    
    if setting.emulation then
        -- рисуем стоп

        dataParam.work = true;
        dataParam.order_num = 1;
        signalShowLog.addSignal(setting.datetime, 28, false, countPrice); 
        dataParam.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop '..countContract)
         
   
    else
        signalShowLog.addSignal( setting.datetime, 29, false, countPrice);  
        -- отправляем транкзакцию 
    end;

    stopClass.array_stop[ #stopClass.array_stop + 1] = dataParam; 
    
end;
 

-- обновление заявки по которой пришла информация
-- присваиваем номер заявке, если он отсутствует
-- вызывается в OnStopOrder
function updateOrderNumber(order) 
    for stopItter = 1 ,  #stopClass.array_stop do 
        if order.trans_id == stopClass.array_stop[stopItter].trans_id and stopClass.array_stop[stopItter].work == 1 then
            stopClass.array_stop[stopItter].work = 2;
            stopClass.array_stop[stopItter].order_num = order.order_num;
        end;
    end;
end;


 


function getRand()
    return tostring(math.random(2000000000));
end;
 
 
-- сработал стоп (OnStopOrder)
-- необходимо снять старые заявки на продажу, если есть таковые
-- когда срабатывает стоп, передвижение стопов запрещено
function appruveOrderStop(order) 

    
    local appruveStop = false;
    local countContract = 0;
    -- помечаем заявку как исполненной
    for stopItter = 1 ,  #stopClass.array_stop do 

        if setting.emulation then 
            -- в режиме эмуляции сработал стоп, здесь смотрим цену
            if order.trans_id == stopClass.array_stop[stopItter].trans_id and stopClass.array_stop[stopItter].work == 1 then
                stopClass.array_stop[stopItter].work = 2;

                countContract = stopClass.array_stop[stopItter].contract;
                -- признак срабатывания стопа
                appruveStop = true; 
                -- снимаем стоп
                DelLabel(setting.tag, stopClass.array_stop[stopItter].label);
            end;
        else 
            --  режим торговли 
            if order.close < stopClass.array_stop[stopItter].price and stopClass.array_stop[stopItter].work == 1 then
                stopClass.array_stop[stopItter].work = 2;

                countContract = stopClass.array_stop[stopItter].contract;
                -- признак срабатывания стопа
                appruveStop = true; 
                -- снимаем стоп
                
                local order_num = stopClass.array_stop[stopItter].order_num;
                local trans_id = stopClass.array_stop[stopItter].trans_id;
                transaction.delete(trans_id, order_num);
            end;
        end;

    end; 

    -- сработал стоп, флаг
    -- перебераем все заявки для того чтобы снять, по цене 
    -- если контрактов в заявке больше, то такие заявки надо перевыставить 
    if  appruveStop then 
        if stopClass.count_stop > 0 then 
            stopClass.triger_stop = stopClass.triger_stop + 1;
            -- сколько контрактов было в стопе
            signalShowLog.addSignal(setting.datetime, 30, false, countContract); 
            -- снимаем заявки которые установлены на верху, в зависимости от количества заявок
            removeOldOrderSell( countContract );
        end;
    end;
end;


-- снимаем старые контракты которые продаём выше.
-- контракты расположены в самом вверху. Снимаем в зависимости от количества контрактов
-- перебираем старые заявки, сверху вних по цене.
-- подсчитываем 
function removeOldOrderSell(countContract)

    if countContract == 0 then return end;

   local scontract = countContract;
    local priceItteration = 0;
    local arrayOrders = {};
    -- коллекция транкзакция на покупку контрактов, для поиска, чтоб не учитывать в будущем
    local arrayOrdersBuys = {};


    if #setting.sellTable > 0 then 

        loger.save("Массив до сортировки:")
        for is = 1, #setting.sellTable do
            loger.save( setting.sellTable[is].price .. ",")
        end

 
        arrayOrders = setting.sellTable;
        table.sort( setting.sellTable, function (a,b) return (a.price > b.price) end)    -- сортировка по 3му элементу

        -- for key = 1 ,  #setting.sellTable do  

        --     if  setting.sellTable[key].type == 'sell' and  setting.sellTable[key].executed == false  then
        --         if setting.sellTable[key].price > priceItteration then 
        --             priceItteration[#priceItteration + 1 ] = setting.sellTable[key].price;
        --         end
        --          --   signalShowLog.addSignal(result.datetime, 27, false, setting.sellTable[key].price); 


        --     end;
        -- end;

        loger.save("Массив после сортировки:")


        for i = 1, #setting.sellTable do

            loger.save(setting.sellTable[i].price .. ",".. setting.sellTable[i].contract);


        end

        loger.save("удаляем контракты " .. countContract);
        for i = 1, #setting.sellTable do

            if   setting.sellTable[i].type == "sell" and 
            countContract >= setting.sellTable[i].contract or 
            setting.sellTable[i].type == "sell" and 
            countContract ~= 0 then
                
                 -- удаляем контракт  
                setting.sellTable[i].work = false;
                loger.save(setting.sellTable[i].price .. ",".. setting.sellTable[i].contract)

                -- заявка не покупку не должна быть активная, поэтому собираем массив заявок 
                
                --  setting.sellTable[sellT].trans_id == saleContract.trans_id_buy 
                 if  countContract >= setting.sellTable[i].contract then
                    -- просто удаляем контракт
                    arrayOrdersBuys[#arrayOrdersBuys + 1]  = setting.sellTable[i].trans_id_buy;
                    countContract = countContract -  setting.sellTable[i].contract ;  
                 else 
                    -- надо перевыставить одну заявку на продажу, ставим лимитку, чтоб не заморачиваться
                    loger.save("  надо перевыставить одну заявку на продажу, ставим лимитку, чтоб не заморачиваться ,".. arrayOrders[i].price);
                    loger.save("  надо перевыставить одну заявку на продажу, ставим лимитку, чтоб не заморачиваться ,".. arrayOrders[i].contract);
                    
                    local orderStop = {};
                    orderStop.price = arrayOrders[i].price;
                    orderStop.datetime = arrayOrders[i].datetime;
                    orderStop.order_num = arrayOrders[i].order_num;
                     
                    local obj = { ['trans_id'] = setting.sellTable[i].trans_id };

                    sellTransaction(orderStop,  obj);

                    countContract = 0; 
                 end;
            end
        end


        

        -- здесь делаем не рабочие заявки на продажу, диактивируя их
        if #arrayOrdersBuys > 0 then 
            -- перебираем все заявки
            for o = 1, #setting.sellTable  do
                -- находим только покупки
                if setting.sellTable[o].type == "buy" and setting.sellTable[o].work then 
                    for i = 1, #arrayOrdersBuys do
                        -- setting.sellTable[sellT].trans_id == saleContract.trans_id_buy 
                        if setting.sellTable[o].trans_id == arrayOrdersBuys[i] then 

                            setting.sellTable[o].work = false;
                            loger.save(" помечаем заявку как неактивную ,".. arrayOrders[i].contract);

                        end
                    end
                end
            end
        end

    end;
    panelBids.show();
end;




 

 
stopClass.removeOldOrderSell = removeOldOrderSell;
stopClass.backStop = backStop;
stopClass.appruveOrderStop = appruveOrderStop;
stopClass.updateOrderNumber = updateOrderNumber;
stopClass.transCallback = transCallback;
stopClass.update_stop = update_stop;
 
return stopClass