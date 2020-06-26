-- файл для тестирования заявок 
-- послать сигнал на покупку, тестирования ответа и реакции на различные ситуации


 
local market = dofile(getScriptPath() .. "\\shop\\market.lua");

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");

local S = {};

S.base = {};



-- инициализация свечи
function testInit()
    local base = {};

    local testDatetime = {};

    testDatetime.hour = 21;
    testDatetime.min = 33;
    testDatetime.sec = 21;

    base.open = 42.46; -- Получить значение Open для указанной свечи (цена открытия свечи)
    base.high = 42.48; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    base.low = 42.45; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    base.close = 42.46; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    base.volume = 100; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    base.datetime = testDatetime; -- Получить значение datetime для указанной свечи
    S.base[#S.base + 1] = base;
end;



function testbaseCreate()
    local base = {};

    local testDatetime = {};

    testDatetime.hour = 21;
    testDatetime.min = 33;
    testDatetime.sec = 21;

    base.open = 42.46; -- Получить значение Open для указанной свечи (цена открытия свечи)
    base.high = 42.48; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    base.low = 42.45; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    base.close = 42.46; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    base.volume = 100; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    base.datetime = testDatetime; -- Получить значение datetime для указанной свечи
    S.base[#S.base + 1] = base;
end;



function tSend(data)
    loger.save('отравляем транкзакцию');
end;

local test_transaction =  {};
test_transaction.send = tSend;


 

-- отправка сигнала на покупку
-- с каждым вызовом отправляется новый сигнал отличный от текущего
function testSendSignalBue()
    loger.save('отравляем транкзакцию 11');
    if   setting.developer then 
        market.updateTransaction(test_transaction);

        updateTransaction(test_transaction);

        testbaseCreate();

        -- покупка
            if #S.base > 0 then 
                for testItter = 1 ,  #S.base do 
                    market.decision(S.base[testItter].close, S.base[testItter].datetime) 
                end;
            end;
    --- market.decision( priceLocal, datetime, levelLocal, event) ;

    setting.developer = fale;
    end;

end;




S.testSendSignalBue = testSendSignalBue;

return S;