-- свечной анализ графика
-- 

local M = {}

local start_init = true;

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")
 
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local candleGraff = dofile(getScriptPath() .. "\\interface\\candleGraff.lua");
 

local function  calculateVolume( volume)
    
     
end

local function  calculatePrice( price,datetime)
 
end

 
local function  calculateSignal(object)
 --   calculateVolume(object.volume)
  --  calculatePrice(object.close, object.datetime) 
end;




local function  setRange(range)

rangeLocal = rangegetNumCandle

end;

local function  getRange()
    return rangeLocal;
end;


bigCandle = 0;


-- вызывается для сигналов
local function getSignal(collbackFunc)

       
    shift = 0;
    len = 100

    -- seconds = os.time(datetime); -- в seconds 
     
    setting.number_of_candle = getNumCandles(setting.tag); 

    bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, setting.number_of_candle-2*len-shift, 2*len)
 

    i=len
    j=2*len
    while i>=1 do

        if bars_temp[j-1].datetime.hour ~= nul then

                if bars_temp[j-1].datetime.hour >= 10 then
    
                    local bar = bars_temp[j-1];


                    if bigCandle <= i  then
                            bigCandle  = i; 
                            -- чтобы всегда был доступ к текущему времени
                            setBarCandle(bar,collbackFunc);
                    end;
                    i=i-1

                end;
                j=j-1
            end
        t = len+1
    end
end




-- логика обновления данных
function setBarCandle(bar,collbackFunc)

        setting.datetime  = bar.datetime; 
        if  setting.old_number_of_candle == setting.number_of_candle and setting.number_of_candle ~=0 then
                setArrayCandles(bar, setting.number_of_candle);
        else 
                bar.numberCandle = setting.number_of_candle;
                setting.array_candle[#setting.array_candle + 1] = bar;
                setting.old_number_of_candle = setting.number_of_candle;
                setting.current_price = bar.close;
                setting.candle_current_high = bar.high;
                setting.candle_current_low = bar.low;

        end;

        calculateSignal(bar);
        collbackFunc(bar);
end;




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
        for candle = 1 ,  #setting.array_candle do 
            if setting.array_candle[candle].numberCandle == numberCandle then
                -- основные вычесления и обновления текущих свечей
                calculateCandle(candle, barCandle);
                -- обновляем данные
                setting.array_candle[candle] = localCandle;
                setting.candle_current_high = barCandle.high;
                setting.candle_current_low = barCandle.low; 
                setting.datetime = barCandle.datetime;
                
            end;


            -- мы перебираем все свечи и проверяем на свечах уровни
            if numberCandle + setting.count_of_candle <= setting.array_candle[candle].numberCandle   then
                 
                -- обновляем высокую цену на текущей свече

                 
                if setting.candle_current_high < setting.array_candle[candle].high  then
                    setting.candle_current_high = setting.array_candle[candle].high;
                end

                -- обновляем низкую цену на текущей свече
                if setting.candle_current_low > setting.array_candle[candle].low  then
                    setting.candle_current_low = setting.array_candle[candle].low;
                end
                -- проверяем уровень
            end;

        end;
    else
        -- записываем данные по свече
        setting.array_candle[#setting.array_candle + 1] = localCandle
    end;
 
    candleGraff.addSignal(setting.array_candle); 
end;

-- проверка формаций

function checkFormation()
 --   setting.candle_current_low  
  --  setting.low_formacia
end




-- единоразовые вычисления
function calculateCandle(key, barC) 

    if start_init  then
        setting.not_buy_high  = setting.not_buy_high_UP + barC.close;
        setting.current_price = barC.close;

        setting.array_candle[key].high = barC.high;
        setting.array_candle[key].low  = barC.low;
        setting.array_candle[key].close  = barC.close;

        setting.candle_current_high = barC.high;
        setting.candle_current_low = barC.low;
        start_init  = false;
    end;
end;



M.getSignal = getSignal
M.setRange = setRange
M.getRange = getRange
return M