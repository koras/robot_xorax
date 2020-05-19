-- scriptTest.lua (in your scripts directory)
local M = {}

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")
 
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
   

local function  calculateVolume( volume)
    
     
end

local function  calculatePrice( price,datetime)
 
end

    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи
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

local function getSignal(tag, callback)

       
    shift = 0;
    len = 100
    basis = 9


    seconds = os.time(datetime); -- в seconds будет значение 1427052491
    collbackFunc = callback;
    shift = 0;
    setting.number_of_candle = getNumCandles(setting.tag); 

   bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, setting.number_of_candle-2*len-shift,2*len)

  --  local lines_count = getLinesCount(setting.tag) 
    bars={}

 

    i=len
    j=2*len
    while i>=1 do
     if(bars_temp[j-1].datetime.hour == nul)then
     end
            if bars_temp[j-1].datetime.hour >= 10 then

                  setting.current_price = bars_temp[j-1].close;
                  local bar = bars_temp[j-1];
                  if bigCandle <= i  then
                    bigCandle  = i; 
                    -- candle_current_high - setting.candle_current_low

                        if  setting.old_number_of_candle == setting.number_of_candle then
               
                            if setting.candle_current_high < bar.high or  setting.candle_current_high == 0 then
                                setting.candle_current_high = bar.high;
                            end
                            
                            if setting.candle_current_low > bar.low or setting.candle_current_low == 0 then
                            setting.candle_current_low = bar.low;
                            end
                                    
                            setting.buffer_old_candles_high = bar.high;
                            setting.buffer_old_candles_low = bar.low; 
                        else
                            setting.old_number_of_candle = setting.number_of_candle;

                            setting.candle_current_high = setting.buffer_old_candles_high;
                            setting.candle_current_low = setting.buffer_old_candles_low;
                        end
 
                        calculateSignal(bars_temp[j-1]);
                        collbackFunc(bars_temp[j-1]);
                end
 

                        bars[i]=bars_temp[j-1]   
                    --   setting.fractals_collection[#setting.fractals_collection + 1]  = bars_temp[j-1].close;

                    --    loger.save(countingTicsVolume .."  -  объёмов "..  lastTickVolume .. ' '.. updateValue..' rand ' );
                        --    loger.save( " bars_temp[j-1].price ".. bars_temp[j-1].close );
                                
                        
                          i=i-1
            end
            j=j-1
    end
    t = len+1
    return value
	  
end
M.getSignal = getSignal
M.setRange = setRange
M.getRange = getRange

return M