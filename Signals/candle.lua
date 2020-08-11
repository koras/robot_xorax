-- свечной анализ графика
-- 
local M = {}

local start_init = true;

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")
local lineBuyHigh = dofile(getScriptPath() .. "\\modules\\lineBuyHigh.lua")
 
local signalShowLog =
    dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local candleGraff = dofile(getScriptPath() .. "\\interface\\candleGraff.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");

local function calculateVolume(volume) end

local function calculatePrice(price, datetime) end

local function calculateSignal(object)
    --   calculateVolume(object.volume)
    --  calculatePrice(object.close, object.datetime) 
end

local function setRange(range) rangeLocal = rangegetNumCandle end

local function getRange() return rangeLocal; end

bigCandle = 0;

local function initCandle(barCandleLocal)
    if start_init then
        setting.not_buy_high = setting.not_buy_high_UP + barCandleLocal.close;
        setting.datetime = barCandleLocal.datetime;
        lineBuyHigh.updateBuyHigh()

        setting.not_buy_low = barCandleLocal.close - setting.not_buy_low_UP;
        lineBuyHigh.updateBuyLow()
        start_init = false;
    end
end


--    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
--    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
--    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
--    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
--    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)

-- вызывается для сигналов
local function initCandles()

    local lenInit = 120
    local Initshift = 0
    local currentCandle = getNumCandles(setting.tag);
    candlesArray, res, legend = getCandlesByIndex(setting.tag, 0, currentCandle - 2 * lenInit - Initshift, 2 * lenInit)
    
    local i = lenInit
    local j = 2 * lenInit
    
    local first_candle = currentCandle - j  - Initshift

    while i >= 1 do
        if candlesArray[j - 1].datetime.hour ~= nul then
            
            if candlesArray[j - 1].datetime.hour >= 10 then
                local bar = candlesArray[j - 1];
                    bar.numberCandle =  first_candle  + j - 1;
                    setting.array_candle[#setting.array_candle + 1] = bar;
                i = i - 1
            end
            j = j - 1
        end
        t = lenInit + 1
    end
    candleGraff.addSignal(setting.array_candle)
end 

 

-- вызывается для сигналов
local function getSignal(collbackFunc)

    if setting.number_of_candle_init then 
    
        initCandles();
        
        setting.number_of_candle_init = false
        return;
    end;


    shift = 0;
    len = 10

    -- seconds = os.time(datetime); -- в seconds 

    setting.number_of_candle = getNumCandles(setting.tag);

    bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candle - 2 *
                                                   len - shift, 2 * len)
    
    -- analyse candles 
 

 

    i = len
    j = 2 * len
    while i >= 1 do

        if bars_temp[j - 1].datetime.hour ~= nul then

            if bars_temp[j - 1].datetime.hour >= 10 then

                

                local bar = bars_temp[j - 1];
                initCandle(bar);

                if bigCandle <= i then
                    bigCandle = i;
                    -- чтобы всегда был доступ к текущему времени
                    setBarCandle(bar, collbackFunc);
                end
                i = i - 1

            end
            j = j - 1
        end
        t = len + 1
    end
end

-- логика обновления данных
function setBarCandle(bar, collbackFunc)

    bar.numberCandle = setting.number_of_candle;

 
    if setting.old_number_of_candle ~= setting.number_of_candle then

        setting.array_candle[#setting.array_candle + 1] = bar;
        setting.old_number_of_candle = setting.number_of_candle;

    else
        -- обновляем бар в таблице
        setting.array_candle[#setting.array_candle] = bar;
    end

    setArrayCandles(bar, setting.number_of_candle);
    setting.current_price = bar.close;
    setting.datetime = bar.datetime;

    calculateSignal(bar);
    if nil ~= collbackFunc then 
        collbackFunc(bar);
    end
end

--    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
--    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
--    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
--    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
--    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
--    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

function setArrayCandles(barCandle, numberCandle)

    local localCandle = barCandle;
    localCandle.numberCandle = numberCandle;

    if #setting.array_candle > 0 then

        local min = 1000000000;
        local minDefault = 1000000000;
        local max = 0;

        for candle = 1, #setting.array_candle do
            -- мы перебираем все свечи и проверяем на свечах уровни

            if setting.array_candle[candle].numberCandle +
                setting.count_of_candle >= numberCandle then
                    

                -- обновляем высокую цену на текущей свече

                if barCandle.high <= setting.array_candle[candle].high then
                    -- проверяем старую свечу
                    if setting.array_candle[candle].high >= max then
                        max = setting.array_candle[candle].high;
                    end

                else
                    -- проверяем текущий максимум
                    if barCandle.high >= max then
                        max = barCandle.high;
                    end
                end
                -- текущее закрытие
                if barCandle.close > max then
                    max = barCandle.close;
                end

                if barCandle.low >= setting.array_candle[candle].low then
                    -- проверяем старую свечу
                    if setting.array_candle[candle].low <= min then
                        min = setting.array_candle[candle].low;
                    end

                else
                    -- проверяем текущий минимум
                    if barCandle.low <= min then
                        min = barCandle.low;
                    end
                end

                if barCandle.close < min then
                    min = barCandle.close;
                end

            else
                if setting.candle_test ~=
                    setting.array_candle[candle].numberCandle then
                    setting.candle_test =
                        setting.array_candle[candle].numberCandle;
                end

            end
        end

        -- max  = barCandle.high

        if setting.candle_current_high == 0 then
            setting.candle_current_high = barCandle.close;
        end

        if max ~= 0 and setting.candle_current_high ~= max then
            setting.candle_current_high = max;
            control.use_contract_limit();
        end

        if setting.candle_current_low == 0 then
            setting.candle_current_low = barCandle.close;
        end

        if min ~= minDefault and setting.candle_current_low ~= min then
            setting.candle_current_low = min;
            control.use_contract_limit();
        end

    else

        
        if setting.candle_current_high < localCandle.high then 
            setting.candle_current_high = localCandle.high;
        end

        setting.datetime = localCandle.datetime;

        if setting.candle_current_low > localCandle.low then 
            setting.candle_current_low = localCandle.low;
        end

        setting.array_candle[#setting.array_candle + 1] = localCandle;

    end

   --  candleGraff.addSignal(setting.array_candle); 
end

M.getSignal = getSignal
M.setRange = setRange
M.getRange = getRange
return M

-- setting.not_buy_high
