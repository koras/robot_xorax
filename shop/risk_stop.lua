local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

-- local markets = dofile(getScriptPath() .. "\\shop\\market.lua");
  
usestop = false;

-- класс для работы с стопами, риск-менеджмент
-- Главное не сколько заработаешь, а сколько не потеряешь


-- стопы обновляются только при покупке или продаже контракта
-- при срабатывании стопа, должны убираться контракты которые находятся на самом вверху
-- и закрываться позиции по покупке. Более такие позиции не учитываются в логике
function update_stop()
    if usestop==false then return; end;
    
    -- можно ли использовать стопы
    if stopClass.use_stop   then 
        -- получаем заявки для ордеров
        -- определяем максимальную и минимальную цену покупки
        getOrdersForBid();
        -- снимаем старые стопы если таковые имеются
        backStop();
        -- генерируем объёкт из стоп заявок
        -- и ставим стоп
        generationCollectionStop(); 
  end;
end;

 


 -- расчёт максимального расстояния в зависимости от количества используемых контрактов при старте
function calculateMaxStopStart()
    if usestop==false then return; end;
    -- зависимость контрактов
    stopClass.spred = setting.LIMIT_BID / setting.use_contract * setting.profit_range ;
    stopClass.spred = setting.LIMIT_BID * setting.SPRED_LONG_TREND_DOWN / setting.use_contract  + stopClass.spred + stopClass.spred_range ;
 end;


 
function setStopDefault()
    if usestop==false then return; end;
   -- stopClass.price_max = 0;
    stopClass.price_min = 10000000;
    stopClass.spred = 0.8;
  --  stopClass.spred_range = 0.1;
    stopClass.contract_work = 0;
end;
 
-- расчёт цены для следующего стоп заявки
function getMaxPriceRange(countStop)
    if usestop==false then return; end;
        if stopClass.price_max <= 0 then 
            stopClass.price_max = setting.current_price;
        end;


     -- расчёт максимального отступа от максимальной цены
    local mPrice  =  stopClass.price_max - stopClass.spred;
    if countStop > 1 then
        -- для второго стопа

        mPrice  = mPrice  -  countStop * stopClass.spred_range + stopClass.spred_range;  

    end
    
   return mPrice;
end;

-- ситуация когда срабатывали стопы, и сейчас стопов больше чем контрактов



 


-- функция сбора заявок для стопов
-- определяем максимальную и минимальную цену покупки
function getOrdersForBid()
    if usestop==false then return; end;
    -- есть или нет контракты в стопах в работе
    local exist_work = true;

   -- setStopDefault();

    -- if stopClass.triger_update_up  then
    --     -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
    -- при условии что заявок нет и его надо обновить
    --     return;
    -- end;

    if #setting.sellTable == 1 or  #setting.sellTable == 2 then 
        stopClass.triger_update_up = true;
    end;
 

    stopClass.contract_work = 0;
    for contractStop = 1 ,  #setting.sellTable do 
            -- берём все заявки которые куплены


        if  setting.sellTable[contractStop].type == 'buy' and    setting.sellTable[contractStop].work then
            
            exist_work = false;

            if stopClass.triger_update_up  then
            -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
                    if setting.sellTable[contractStop].price > stopClass.price_max then 
                        -- максимальная цена покупки
                        stopClass.price_max = setting.sellTable[contractStop].price ;
                        
                    end 
                    stopClass.triger_update_up = false;
            end;
            
            if setting.sellTable[contractStop].price < stopClass.price_min then 
                -- минимальная цена покупки
                stopClass.price_min = setting.sellTable[contractStop].price ;
            end 
        end;
        -- смотрим сколько осталось контрактов
        if  setting.sellTable[contractStop].type == 'sell' and    setting.sellTable[contractStop].work then
            stopClass.contract_work = stopClass.contract_work + setting.sellTable[contractStop].use_contract;
        end;
    end;

    -- количество контрактов в работе stopClass.contract_work = 0;
    -- количество контрактов добавленных трейдером stopClass.contract_add = 0;
 
 
    if exist_work and stopClass.contract_work ~= 0 and stopClass.contract_add == 0 then
        -- снимаем все стопы
        backStop();
        
        signalShowLog.addSignal(setting.datetime, 35, false, stopClass.contract_work);  
    end;

 
    if exist_work and stopClass.contract_work ~= 0 and stopClass.contract_add ~= 0 then
        -- обновляем стопы
        backStop();
        -- генерируем объёкт из стоп заявок
        -- и ставим стоп
        generationCollectionStop(); 

        signalShowLog.addSignal(setting.datetime, 36, false, ( stopClass.contract_work ~= 0 + stopClass.contract_add));  
    end;

end;




-- Ставим новый стоп, но если сработал стоп, увеличиваем стоп на количество срабатываемых стопов и уменьшаем количество стопов
function generationCollectionStop() 
    if usestop==false then return; end;
    local contract_work = stopClass.contract_work + stopClass.contract_add;

    if stopClass.triger_stop == 0 then 
      --  stopClass.triger_stop = 1
    end;

    local triger_stop = stopClass.triger_stop

    local contract = math.floor(contract_work / stopClass.count_stop);


    local lost_contract_start = 1;

    


    if contract_work > 0  then 

        if contract_work == 1 then 
            -- один стоп  
                    maxPrice = getMaxPriceRange(1) 
                    sendTransStop(contract_work, maxPrice);

        else
                if stopClass.count_stop >= 2  then 
                    -- более двух стопов
                
                
                    if   stopClass.count_stop  ==  triger_stop  then 
                        --   1 стоп 
                        
                            maxPrice = getMaxPriceRange( triger_stop +1 ) 
                            sendTransStop(contract_work, maxPrice);
                            return;
    
                        elseif   stopClass.count_stop  <=  triger_stop  or  stopClass.count_stop  ==  triger_stop + 1    then 

                            --   1 стоп 
                             
                                maxPrice = getMaxPriceRange( triger_stop + 1 ) 
                                sendTransStop(contract_work, maxPrice);
                        return;
        

                    elseif   stopClass.count_stop  ==  triger_stop and  stopClass.count_stop  == contract_work    then 

                            --   1 стоп 
                             
                                maxPrice = getMaxPriceRange( triger_stop + 1 ) 
                                sendTransStop(contract_work, maxPrice);
                        return;
        
                    elseif  stopClass.count_stop >  triger_stop  then 
                        
                        local workCountStop =  stopClass.count_stop -  triger_stop;
                         

                        -- количество контрактов на 1 стоп
                    

                        -- остаток от контрактов
                        -- local lost_contract = contract_work % stopClass.count_stop; -- в переменной A число остаток

                        local lost_contract = math.fmod(contract_work, workCountStop);


                        
                        -- сперва ставим стоп контракты с остатками, если таковые имеются
                        if  tostring(lost_contract) ~= 0  then 
                             
                                local price = 0;
                                
                                -- сколько контрактов в первом стопе 
                                 
                                local firstContract = contract + contract_work - (contract * workCountStop); 
                                
                                if triger_stop == 0 then 
                                    lost_contract_start = 2;
                                    price  = getMaxPriceRange(1);
                                else 
                                -- triger_stop  = triger_stop + 1;
                                    lost_contract_start = 1;
                                    price  = getMaxPriceRange(triger_stop + 1); 
                                end;
                                sendTransStop(firstContract, price);
                      
                                
                            
                        end;
                        
                        
         
                        


                        for contractItterationLimit = lost_contract_start, stopClass.count_stop - triger_stop do 
                            -- расставляем стопы  
                            
                            -- если раньше срабатывали стопы
                            if contract ~= 0 then 
                                local trigerStop = triger_stop + contractItterationLimit;
                                local price  = getMaxPriceRange(trigerStop);  
                                
                                    sendTransStop(contract, price);
                            end;
                        end; 


                        return;

                    elseif   stopClass.count_stop == triger_stop then 
                        --   1 стоп 
                        
                            maxPrice = getMaxPriceRange( triger_stop +1 ) 
                            sendTransStop(contract_work, maxPrice);
                            return;

                    elseif   stopClass.count_stop < triger_stop then 
                        --   1 стоп 
                        
                            maxPrice = getMaxPriceRange( triger_stop +1 ) 
                            sendTransStop(contract_work, maxPrice);
                            return;

                    elseif contract_work  < stopClass.count_stop  then 
                            maxPrice = getMaxPriceRange( triger_stop +1 ) 
                            
                            sendTransStop(contract_work, maxPrice);
                            return;
                  

                            
    
                    end; 

 
                    
            
            
                elseif  stopClass.count_stop == 1  then 
                    --   1 стоп 
                     
                        maxPrice = getMaxPriceRange( triger_stop +1 ) 
                        sendTransStop(contract_work, maxPrice);
                        return;
                end; 
        end; 
    end;

    local count = 0;
end;


-- снимаем старые стоп заявки
function backStop()
    if usestop==false then return; end;
    -- обнуляем заявки
    loger.save("backStop  "..#stopClass.array_stop );
    if #stopClass.array_stop > 0 then

        for s = 1 ,  #stopClass.array_stop do 
            if stopClass.array_stop[s].emulation then
                -- удаляем метку
                DelLabel(setting.tag, stopClass.array_stop[s].label);
                
            --   dataParam.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop '..countContract)
            else
                -- снимаем стоп заявку
                --  loger.save("stopClass.array_stop[s].work ".. stopClass.array_stop[s].work)
                --  loger.save("stopClass.array_stop[s].order_num ".. stopClass.array_stop[s].order_num)
                --  loger.save("stopClass.array_stop[s].trans_id ".. stopClass.array_stop[s].trans_id)
                if  stopClass.array_stop[s].work == 1 then 

                    -- стоп больше не используется
                    stopClass.array_stop[s].work = 3;

                    local order_num = tostring(stopClass.array_stop[s].order_num);
                    local trans_id = tostring(stopClass.array_stop[s].trans_id);
                    
                    loger.save("1  transaction.delete(trans_id, order_num); ".. trans_id .." , ".. order_num)
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
    if usestop==false then return; end;
    
    
    local dataParam = {};
            dataParam.emulation = setting.emulation;
            dataParam.price = countPrice;
            dataParam.contract = countContract;
             
            dataParam.label = 0;
            -- work = 0 - отправляем на сервер
            -- work = 1 - заявка выставлена
            -- work = 2 - заявка снята пл какой либо причине
            dataParam.work = 0;
            dataParam.order_num = 0;
             
    
    if setting.emulation then
        -- рисуем стоп
        dataParam.work = 1;
        dataParam.order_num = 1;
        dataParam.trans_id = getRand();
        dataParam.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop '..countContract)
         
    else
        -- здесь статус меняется полсле того как пришёл статус об установке стопа 
        -- dataParam.work = 0; 

        local type = "SIMPLE_STOP_ORDER";

        
        loger.save("transaction.send  ".. countPrice.." , ".. countContract)
        dataParam.trans_id =  transaction.send('sell', countPrice, countContract, type, 0 );
        -- отправляем транкзакцию 
    end;

    stopClass.array_stop[ #stopClass.array_stop + 1] = dataParam; 
    
end;
 

-- обновление заявки по которой пришла информация
-- присваиваем номер заявке, если он отсутствует
-- вызывается в OnStopOrder

function updateOrderNumber(order) 
    if usestop==false then return; end;

    for stopItter = 1 ,  #stopClass.array_stop do 
 
        if order.trans_id == stopClass.array_stop[stopItter].trans_id and stopClass.array_stop[stopItter].work == 0 then
            stopClass.array_stop[stopItter].work = 1;
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
    if usestop==false then return; end;
    if stopClass.use_stop then 

        local appruveStop = false;
        local countContract = 0;
        -- помечаем заявку как исполненной

        
                
        loger.save(" #stopClass.array_stop#stopClass.array_stop#stopClass.array_stop "..#stopClass.array_stop )

        for stopItter = 1 ,  #stopClass.array_stop do 

            if setting.emulation then 
    

                -- в режиме эмуляции сработал стоп, здесь смотрим цену
                if order.close <= stopClass.array_stop[stopItter].price and stopClass.array_stop[stopItter].work == 1 then 
                    stopClass.array_stop[stopItter].work = 2;

                    signalShowLog.addSignal(setting.datetime, 31, false, stopClass.array_stop[stopItter].price);  

                    countContract = countContract + stopClass.array_stop[stopItter].contract;
                    -- признак срабатывания стопа
                    appruveStop = true; 
                    
                    if stopClass.count_stop > stopClass.triger_stop then 
                    stopClass.triger_stop = stopClass.triger_stop + 1;
                    end
                    -- снимаем стоп
                    DelLabel(setting.tag, stopClass.array_stop[stopItter].label);
                end;
            else 
                
                loger.save(" stopClass.array_stop[stopItter].work ".. stopClass.array_stop[stopItter].work )
                --  режим торговли  
                if order.trans_id == stopClass.array_stop[stopItter].trans_id and stopClass.array_stop[stopItter].work == 1 then
                    stopClass.array_stop[stopItter].work = 2;

                    countContract = countContract + stopClass.array_stop[stopItter].contract;
                    -- признак срабатывания стопа
                    appruveStop = true; 
                    
                    if stopClass.count_stop > stopClass.triger_stop then 
                        stopClass.triger_stop = stopClass.triger_stop + 1;
                    end
                    -- снимаем стоп
                    signalShowLog.addSignal(setting.datetime, 32, false, stopClass.array_stop[stopItter].price); 
                    
                    local order_num = stopClass.array_stop[stopItter].order_num;
                    local trans_id = stopClass.array_stop[stopItter].trans_id;

                    
                  loger.save(" transaction.delete(trans_id, order_num); ".. trans_id .." , ".. order_num)
                    transaction.delete(trans_id, order_num);
                end;
            end;

        end; 

        -- сработал стоп, флаг
        -- перебераем все заявки для того чтобы снять, по цене 
        -- если контрактов в заявке больше, то такие заявки надо перевыставить 
        if  appruveStop then 
            

            if stopClass.count_stop > 0 then  
                -- сколько контрактов было в стопе
                signalShowLog.addSignal(setting.datetime, 33, false, stopClass.triger_stop); 
                -- снимаем заявки которые установлены на верху, в зависимости от количества заявок
                removeOldOrderSell( countContract );
                -- обновляем таблицу с заявками 

            end;
            panelBids.show();
        end;
    end; 
end;


-- снимаем старые контракты которые продаём выше.
-- контракты расположены в самом вверху. Снимаем в зависимости от количества контрактов
-- перебираем старые заявки, сверху вних по цене.
-- подсчитываем 
function removeOldOrderSell(countContract)
    if usestop==false then return; end;

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

                signalShowLog.addSignal(setting.datetime, 34, false, arrayOrders[i].price); 
                -- заявка не покупку не должна быть активная, поэтому собираем массив заявок 
                
                --  setting.sellTable[sellT].trans_id == saleContract.trans_id_buy 
                 if  countContract >= setting.sellTable[i].contract then
                    -- просто удаляем контракт
                    arrayOrdersBuys[#arrayOrdersBuys + 1]  = setting.sellTable[i].trans_id_buy;
                    countContract = countContract -  setting.sellTable[i].contract ;  
                 else 
                    -- надо перевыставить одну заявку на продажу, ставим лимитку, чтоб не заморачиваться 
                    
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

 
 
 
stopClass.calculateMaxStopStart = calculateMaxStopStart;
stopClass.removeOldOrderSell = removeOldOrderSell;
stopClass.backStop = backStop;
stopClass.appruveOrderStop = appruveOrderStop;
stopClass.updateOrderNumber = updateOrderNumber;
stopClass.transCallback = transCallback;
stopClass.update_stop = update_stop;
 
return stopClass