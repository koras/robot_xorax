local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
 
--local controlPanel = dofile(getScriptPath() .. "\\interface\\control.lua");
 
-- local markets = dofile(getScriptPath() .. "\\shop\\market.lua");
  
usestop = true;

-- класс для работы с стопами, риск-менеджмент
-- Главное не сколько заработаешь, а сколько не потеряешь


-- стопы обновляются только при покупке или продаже контракта
-- при срабатывании стопа, должны убираться контракты которые находятся на самом вверху
-- и закрываться позиции по покупке. Более такие позиции не учитываются в логике
function update_stop()


    
    if usestop==false then return; end;
    loger.save(' ' );
    loger.save('=================================' );
    
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

    stopClass.spred =  0.02;
  --  stopClass.spred = setting.LIMIT_BID / setting.use_contract * setting.profit_range ;
  --  stopClass.spred = setting.LIMIT_BID * setting.SPRED_LONG_TREND_DOWN / setting.use_contract  + stopClass.spred + stopClass.spred_range ;
 end;


 
function setStopDefault()
    if usestop==false then return; end;
    
    stopClass.price_min = 10000000;
    stopClass.spred = 0.01;
  --  stopClass.spred_range = 0.1;
    stopClass.contract_work = 0;
end;
 
-- расчёт цены для следующего стоп заявки
function getMaxPriceRange(countStop)
    
    
    if stopClass.price_max <= 0 then 
        stopClass.price_max = setting.current_price;
    end;


     -- расчёт максимального отступа от максимальной цены
    local mPrice  =  stopClass.price_max - stopClass.spred;
    -- if countStop > 1 then
    --     -- для второго стопа

    --     mPrice  = mPrice  -  countStop * stopClass.spred_range + stopClass.spred_range;  

    -- end
    
   return mPrice;
end;

-- ситуация когда срабатывали стопы, и сейчас стопов больше чем контрактов



 


-- функция сбора заявок для стопов
-- определяем максимальную и минимальную цену покупки
-- необходимо для определения куда ставить стоп
function getOrdersForBid() 
    if #setting.sellTable == 0 then return; end;
    
    stopClass.contract_work = 0;
    for contractStop = 1 ,  #setting.sellTable do 
            -- берём все заявки которые куплены

        if  setting.sellTable[contractStop].type == 'buy' and  setting.sellTable[contractStop].work then
             
 
            -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
            if setting.sellTable[contractStop].price > stopClass.price_max then 
                -- максимальная цена покупки
                stopClass.price_max = setting.sellTable[contractStop].price ;
                        
            end 
            if setting.sellTable[contractStop].price < stopClass.price_min then 
                -- минимальная цена покупки
                stopClass.price_min = setting.sellTable[contractStop].price ;
            end 
        end; 

        if  setting.sellTable[contractStop].type == 'sell' and  setting.sellTable[contractStop].work  then

            stopClass.contract_work = stopClass.contract_work + setting.sellTable[contractStop].use_contract;
         --   loger.save('-- смотрим сколько осталось контрактов  '.. stopClass.contract_work );

        end;
    end;

    if stopClass.contract_work == 0 then 
        loger.save('-- нет контрактов в работе '  );
    end;
end;






-- сколько стопов уже

-- Ставим новый стоп, увеличиваем стоп на количество срабатываемых стопов и уменьшаем количество стопов
function generationCollectionStop()  
    

    local contract_work = stopClass.contract_work + stopClass.contract_add;
    
    if contract_work > 0  then   
                    -- смотрим куда поставить стоп
                    maxPrice = getMaxPriceRange() 
                   -- loger.save('generationCollectionStop  ставм стоп   контрактов = '.. contract_work.." по цене : "..maxPrice )
                    sendTransStop(contract_work, maxPrice);
    end; 
end;


-- снимаем старые стоп заявки
function backStop()
    -- обнуляем заявки
    

        if stopClass.array_stop.emulation then
                -- удаляем метку
                DelLabel(setting.tag, stopClass.array_stop.label);
         else
            -- только 2, потому что только 2 заявкам присвоен  номер
            if  stopClass.array_stop.work == 2 then  
               -- loger.save(" delete  delete  delete  delete  delete  delete  delete  delete  delete  delete  delete "  );
                    -- стоп больше не используется 
                local order_num = tostring(stopClass.array_stop.order_num);
                local trans_id = tostring(stopClass.array_stop.trans_id);
                local order_type = tostring(stopClass.array_stop.order_type);

                loger.save(" "  );
                loger.save("------------------------------------------------------------------------------------------ "  );
                loger.save("-- снимаем стоп заявку   "   .. " trans_id "..trans_id .. "   order_num = ".. order_num );

                if order_num ~= 0 then 

                    transaction.delete(trans_id, order_num, order_type); 

                    stopClass.array_stop.work = 0;
                    stopClass.array_stop.trans_id = 0;
                    stopClass.array_stop.order_num = 0;  
                end;
        end;
    end;
        
end;



-- создаём объёкт 
-- countContract - сколько контрактов на стопе
-- countPrice - стоимость контракта


function sendTransStop(countContract, countPrice )


    if usestop==false then return; end;
    
    if stopClass.array_stop.work == 3  or stopClass.array_stop.work == 0 then    
     

        local dataParam = {};
        stopClass.array_stop.emulation = setting.emulation;
        stopClass.array_stop.price = countPrice;
                stopClass.array_stop.contract = countContract;
                
                stopClass.array_stop.label = 0;
                -- work = 0 - отправляем на сервер
                -- work = 1 - заявка выставлена
                -- work = 2 - заявка снята пл какой либо причине
                -- work = 3 - заявка снята пл какой либо причине
                stopClass.array_stop.work = 1;
                stopClass.array_stop.order_num = 0;
                
        
        if setting.emulation then
            -- рисуем стоп
            stopClass.array_stop.work = 1;
            stopClass.array_stop.order_type = 1;
            stopClass.array_stop.order_type = "SIMPLE_STOP_ORDER";
            stopClass.array_stop.trans_id = getRand();
            stopClass.array_stop.label = label.set('stop', countPrice ,  setting.datetime, countContract, 'stop '..countContract)
            loger.save("dataParam.label =".. stopClass.array_stop.label  )
            
        else
            -- здесь статус меняется полсле того как пришёл статус об установке стопа 
            -- dataParam.work = 0; 

            local type = "SIMPLE_STOP_ORDER";

            stopClass.array_stop.trans_id = transaction.send('sell', countPrice, countContract, type, 0 );

            loger.save("sendTransStop   ставим стоп ".. countPrice .. '  trans_id='.. stopClass.array_stop.trans_id  )
            -- отправляем транкзакцию 
        end;

 

    end; 
end;
 

-- обновление заявки по которой пришла информация
-- присваиваем номер заявке, если он отсутствует
-- вызывается в OnStopOrder

function updateOrderNumber(order) 
    
 
        if  order.trans_id == stopClass.array_stop.trans_id and  stopClass.array_stop.work == 1  then

            
        loger.save("updateOrderNumber  обновление заявки по которой пришла информация "..    
        '  order.order_num= '.. order.order_num..
        '  work = '.. stopClass.array_stop.work..
        '  trans_id = '.. stopClass.array_stop.trans_id );


            stopClass.array_stop.work = 2;
            stopClass.array_stop.order_num = order.order_num;
        --    stopClass.array_stop.order_type = "TAKE_PROFIT_STOP_ORDER";
            stopClass.array_stop.order_type = "SIMPLE_STOP_ORDER";
             
        end;
         
end;


function getRand()
    return tostring(math.random(2000000000));
end;
 
 

 
-- сработал стоп (OnStopOrder)
-- необходимо снять старые заявки на продажу, если есть таковые
-- когда срабатывает стоп, передвижение стопов запрещено
function appruveOrderStop(order)  

        -- помечаем заявку как исполненной
    if stopClass.use_stop and setting.emulation == false then 
        
        loger.save("      "   )
        loger.save("      "   )
        loger.save("      "   )
        loger.save("STOP STOP STOP STOP  trans_id = ".. stopClass.array_stop.trans_id.." = "..order.trans_id   )
                --  режим торговли  
                if order.trans_id == stopClass.array_stop.trans_id and stopClass.array_stop.work == 2  then
                     
                    -- признак срабатывания стопа
                    loger.save("-- appruveOrderStop  признак срабатывания стопа "  )
                    stopClass.array_stop.work = 0;
                    stopClass.array_stop.trans_id = 0;
                    stopClass.array_stop.price = 0;

                    removeOldOrderSell();
                    
                    button_worked_stop();
                    -- обновляем таблицу с заявками 
                    panelBids.show(); 
                end;
         
    end; 
end;


-- снимаем старые контракты которые продаём выше.
-- контракты расположены в самом вверху. Снимаем в зависимости от количества контрактов
-- перебираем старые заявки, сверху вних по цене.
-- подсчитываем 
function removeOldOrderSell()
    if usestop==false then return; end; 
  
    local arrayOrders = {};
    -- коллекция транкзакция на покупку контрактов, для поиска, чтоб не учитывать в будущем
    local arrayOrdersBuys = {};

    
    if #setting.sellTable > 0 then 
        for i = 1, #setting.sellTable do
            if   setting.sellTable[i].type == "sell" and setting.sellTable[i].work  then
                
                 -- удаляем контракт  
                setting.sellTable[i].work = false; 
                signalShowLog.addSignal(setting.datetime, 34, false, setting.sellTable[i].price);  
                loger.save(" помечаем заявку как неактивную sell,".. setting.sellTable[i].contract); 
 
                   arrayOrdersBuys[#arrayOrdersBuys + 1]  = setting.sellTable[i].trans_id_buy; 
                   transaction.delete(setting.sellTable[i].trans_id, setting.sellTable[i].order_num, tostring(setting.sellTable[i].order_type));
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
                            loger.save(" помечаем заявку как неактивную buy,".. setting.sellTable[o].price);
                        end
                    end
                end
            end
        end
    end;
    panelBids.show();
end;

 

















function  appruveOrderStopEmulation(order) 


    if stopClass.use_stop and  setting.emulation and stopClass.array_stop.price ~= nil then 
        -- помечаем заявку как исполненной
   
                -- в режиме эмуляции сработал стоп, здесь смотрим цену
            if order.close <= stopClass.array_stop.price and stopClass.array_stop.work == 1 or
                order.close <= stopClass.array_stop.price and stopClass.array_stop.work == 2  then 

                stopClass.array_stop.work = 3;
                signalShowLog.addSignal(setting.datetime, 31, false, stopClass.array_stop.price);  

                    -- снимаем стоп
                DelLabel(setting.tag, stopClass.array_stop.label);
                button_worked_stop();

                loger.save("-- appruveOrderStopEmulation признак срабатывания стопа "  )
                    -- признак срабатывания стопа
                    
                removeOldOrderSell();
                panelBids.show();
            end;
    end; 
end;
 
 
stopClass.calculateMaxStopStart = calculateMaxStopStart;
stopClass.removeOldOrderSell = removeOldOrderSell;
stopClass.backStop = backStop;
stopClass.appruveOrderStopEmulation = appruveOrderStopEmulation;
stopClass.appruveOrderStop = appruveOrderStop;
stopClass.updateOrderNumber = updateOrderNumber;
stopClass.transCallback = transCallback;
stopClass.update_stop = update_stop;
 
return stopClass