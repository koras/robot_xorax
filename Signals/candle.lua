-- свечной анализ графика
-- 

local M = {}

start_init = true;

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
function setBarCandle(bar, collbackFunc) 

        if  setting.old_number_of_candle ~= setting.number_of_candle  then
                loger.save("numberCandle numberCandle ".. setting.number_of_candle ); 
                bar.numberCandle = setting.number_of_candle;
                setting.array_candle[#setting.array_candle + 1] = bar;
                setting.old_number_of_candle = setting.number_of_candle; 
        end;

        setArrayCandles(bar, setting.number_of_candle);
        setting.current_price = bar.close;
        setting.datetime  = bar.datetime; 
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
         
        local min = 1000000000;
        local max = 0;

        for candle = 1 ,  #setting.array_candle do 
            -- мы перебираем все свечи и проверяем на свечах уровни

          
            if   setting.array_candle[candle].numberCandle  + setting.count_of_candle  >= numberCandle   then
            --    loger.save( "-- записываем данные по свече " );
             --   loger.save("numberCandle numberCandle ".. numberCandle ); 

                -- обновляем высокую цену на текущей свече
           
                 

                if   barCandle.high <= setting.array_candle[candle].high then 
                    -- проверяем старую свечу
                    if setting.array_candle[candle].high >= max then
                         max  = setting.array_candle[candle].high;
                    end 

                else 
                    -- проверяем текущий максимум
                    if barCandle.high >= max then
                        max  = barCandle.high;
                   end 
                end
               -- текущее закрытие
                if barCandle.close > max then 
                    max  = barCandle.close;
                end
               



                if   barCandle.low >= setting.array_candle[candle].low then 
                    -- проверяем старую свечу
                    if setting.array_candle[candle].low <= min then
                            min = setting.array_candle[candle].low;
                    end 

                else 
                    -- проверяем текущий минимум
                    if barCandle.low <= min then
                        min  = barCandle.low;
                   end 
                end
                      
                if barCandle.close < min then 
                    min  = barCandle.close;
                end
               
                 
              --  loger.save(setting.array_candle[candle].numberCandle .. " min= ".. setting.array_candle[candle].high.." > ".. setting.array_candle[candle].low .." barCandle.low"..barCandle.low);
                      

            else
              
            --    loger.save("setting.candle_test === ".. setting.candle_test );  
             --   loger.save("setting.array_candle[candle].numberCandle === ".. setting.array_candle[candle].numberCandle);  

                if setting.candle_test ~= setting.array_candle[candle].numberCandle then 
                    setting.candle_test = setting.array_candle[candle].numberCandle;
               --     loger.save("setting.candle_current_high === ".. setting.array_candle[candle].numberCandle );  
                end;

            end;

     


        end;

        
       --max  = barCandle.high
        
       if setting.candle_current_high == 0 then  
            setting.candle_current_high =  barCandle.close;   
        end;

       if max ~=0 then  
            setting.candle_current_high = max;   
       end;

       

    else
        
        
        loger.save( "-- записываем данные по свече " );
        if setting.candle_current_high < localCandle.high then 
            loger.save("update high "..localCandle.high);
            setting.candle_current_high = localCandle.high; 
        end 

        setting.datetime = localCandle.datetime; 
        if setting.candle_current_low > setting.candle_current_low then 
            loger.save("update low "..localCandle.high);
            setting.candle_current_low = localCandle.low;
        end 

        setting.array_candle[#setting.array_candle + 1] = localCandle;

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
        if setting.not_buy_high == 0 then 
            setting.not_buy_high  =  barC.close + setting.not_buy_high_UP; 
        end;
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