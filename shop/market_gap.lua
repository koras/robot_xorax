-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта
-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShow =  dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");

-- сервис, общие математические операции
local market_service = dofile(getScriptPath() .. "\\shop\\market_service.lua");



--    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
--    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
--    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
--    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
--    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
--    local T = t[i].datetime; -- Получить значение datetime для указанной свечи
local function  chechPrice(setting)
    if setting.lastDayPrice > setting.openDayPrice then 
            -- short
            -- long = 'buy'
-- long = 'short'
        setting.gap_direction = 'short';
        return;
    end;
        -- long
    setting.gap_direction = 'long';

end

 
local function getOldPrice(setting)
 
    if setting.singleGetOldPrice then 
        setting.singleGetOldPrice = false;

    local currentDatetime = setting.currentDatetime;
    local datetime_min = 0;
    local   datetime = {};

    loger.save( "getSignal gap ")
    -- сколько свечей в работе с права
    local len = 990;
    local shift = 0;
 
    setting.number_of_candles = getNumCandles(setting.tag);
    bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candles - 2 * len - shift, 2 * len)
    local bars = {}
    local i = len
    local j = 2 * len
    while i >= 1 do
        if bars_temp[j - 1] == nil then
       --     message(words.word('not_found_tag'));
            OnStop();
            Run = false; 
            return
        end
                bars[i] = bars_temp[j - 1]
          --      loger.save( "===== : ".. bars[i] .close )
              datetime =  bars[i].datetime


        -- можем ошибиться с графиком и поставить другой таймфрейм, уберегём себя родного
        if datetime.hour == 23 and datetime.min >= 20  and currentDatetime.day ~= datetime.day then 
            -- хак специальный
            if datetime.min > datetime_min then 
                datetime_min = datetime.min;
             --   lastDayPrice = bars[i].close;
                setting.lastDayPrice = bars[i].close;
            end;  
        end
 

        -- можем ошибиться с графиком и поставить другой таймфрейм, уберегём себя родного
     --   if datetime.hour  == 10 and datetime.min == 00  and currentDatetime.day == datetime.day then 
            -- хак специальный
        --        setting.openDayPrice = bars[i].open;
     
     --   end
 
  
         
    --    loger.save( "===== :   ".. datetime.hour .. ":"..datetime.min)

  --  loger.save( tostring(datetime.year) .. " datetime " )
    -- loger.save( tostring(datetime.day) .. " " ..
    --           tostring(datetime.hour) .. " " ..
    --           tostring(datetime.min) .. " " ..
    --           tostring(datetime.sec)
    --         )



             -- просто отправляем текущую цену
             
                i = i - 1
        j = j - 1
    end

    t = len + 1;

   -- chechPrice(setting);
     
  --  loger.save( 'получили старую цену '..datetime.day.. "  ".. datetime.hour .. ": "..datetime_min .. " ===== : close".. setting.lastDayPrice )
  --  loger.save( "получили open : " .. setting.openDayPrice .. " setting.gap_direction " ..setting.gap_direction );
    end
end

 

local function autoStart(setting)

 
 if setting.autoStartEngine and setting.singleGetOldPrice == false then 
 

    local currentDatetime = setting.currentDatetime;
  

    loger.save( "getSignal gap ")
    -- сколько свечей в работе с права
    local len = 820;
    local shift = 0;
 
    setting.number_of_candles = getNumCandles(setting.tag);
    local bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candles - 2 * len - shift, 2 * len)
    local bars = {}
    local i = len
    local j = 2 * len
    while i >= 1 do
        if bars_temp[j - 1] == nil then
       --     message(words.word('not_found_tag'));
            OnStop();
            Run = false; 
            return
        end
                bars[i] = bars_temp[j - 1]
          --      loger.save( "===== : ".. bars[i] .close ) 
         if bars[i].datetime.hour  == 10 and bars[i].datetime.min == 00  and currentDatetime.day == bars[i].datetime.day then 
            -- хак специальный
             setting.openDayPrice = bars[i].open;

            setting.autoStartEngine = false;
            chechPrice(setting);
            loger.save(bars[i].datetime.min.."  asdasd ".. setting.lastDayPrice .. "  получили open : " .. setting.openDayPrice .. " setting.gap_direction " ..setting.gap_direction );
       end
                i = i - 1
        j = j - 1
    end

    t = len + 1;

   -- chechPrice(setting); 
    end
end;

local function getRand() return tostring(math.random(2000000000)); end

 

-- done
local function commonOperation(setting, _price, datetime)

    -- сколько подряд покупок было
    -- не влияет на тип операции шорт или лонг
    if setting.each_to_buy_step <= setting.each_to_buy_to_block then
        setting.each_to_buy_step = setting.each_to_buy_step + 1;
        -- увеличиваем число контрактов которые надо продать до разблокировки
        setting.each_to_buy_to_block_contract =
            setting.use_contract + setting.each_to_buy_to_block_contract
    end

    -- текущаая свеча
    -- ставим заявку на с отклонением на 0.01

    local price = 0;

    if setting.type_instrument == 3 then
        if setting.mode == 'buy' then
            price = tonumber(_price + setting.profit_infelicity); -- и надо снять заявку если не отработал
        else
            price = tonumber(_price - setting.profit_infelicity); -- и надо снять заявку если не отработал
        end
    else
        if setting.mode == 'buy' then
            price = _price + setting.profit_infelicity; -- и надо снять заявку если не отработал
        else
            price = _price - setting.profit_infelicity; -- и надо снять заявку если не отработал
        end
    end

    setting.candles_operation_last = setting.number_of_candles;
    if setting.emulation then
        signalShow.addSignal(20, false, tostring(price));
    else
        signalShow.addSignal(7, false, price);
    end

    setting.count_buy = setting.count_buy + 1;
    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали
    setting.limit_count_buy = setting.limit_count_buy + setting.use_contract; -- отметка для лимита
    return price;
end

-- выставление заявки на покупку/продажу
-- вызывается для эмуляции и не только
-- solve
-- done
local function gapSendOrder(setting, price, datetime)
    -- генерация trans_id для эмуляции 
    local trans_id = getRand()
    local use_contract = market_service.getUseContract( setting, price)
    setting.count_contract_buy = setting.count_contract_buy + use_contract;
    price = commonOperation(setting, price, datetime);
    if setting.emulation == false then
        trans_id = transaction.send(setting.gap_direction, price, use_contract, type, 0);
    end

    local data = {};
    data.price = price;
    data.datetime = datetime;
    data.trans_id = trans_id;
    -- сколько контрактов исполнилось 
    data.use_contract = use_contract;
    data.trans_id_buy = trans_id;

    data.work = true;
    data.executed = false;
    data.type = setting.gap_direction;
    data.emulation = setting.emulation;
    data.contract = use_contract;
    data.buy_contract = price; -- стоимость продажи

    if setting.emulation then
        if setting.gap_direction == 'buy' then
            -- long
            label.set("BUY", price, data.datetime, use_contract);
        else
            -- short 
            label.set("SELL", price, data.datetime, use_contract);
        end
    end

    setting.sellTable[(#setting.sellTable + 1)] = data;
    -- Выставили контракт на покупку
    signalShow.addSignal(23, false, price);
    panelBids.show();
    control.use_contract_limit();
end
 
-- выставляем заявку на продажу
local function pushMarket(setting, price, datetime)
    if setting.autoStartEngine == false and setting.gapSendOrderStatus == false then
        -- меняем статус чтобы такие заявки больше не выставлять
        setting.gapSendOrderStatus = true;

        gapSendOrder(setting, price, datetime);

    end
end
 
 
local M = {}
M.getOldPrice = getOldPrice
M.autoStart = autoStart
M.pushMarket = pushMarket
return M
