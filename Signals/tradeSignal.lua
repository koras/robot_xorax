-- scriptTest.lua (in your scripts directory)
local M = {}

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local words = dofile(getScriptPath() .. "\\langs\\words.lua");

M.status = 0;

local collbackFunc;

-- три состояния, 

-- как должна ходить цена для сигнала
-- здесь мы не учитываем ничего
local rangeLocal = 0.0
 

local signalStrength = 0;
-- старая цена
local oldPrice = 0;

-- старый объём
local oldVolume = 0;
-- старый объём в прошлый тик
local  lastTickVolume = 0;

 -- новая цена
local newPrice = 0; 

-- объём в тик новый объём
local volumeRange = 0;
-- старый объём для сравнения в тик
local oldVolumeRange = 0;

-- объём в тик новый объём
local countingTicsVolume = 0;

-- свечки
local CRITICAL_VOLUME= 0;



local function  calculateVolume( volume)
     
-- объём для решения
local rangeVolume = 10


    -- новая свеча
    if (setting.old_number_of_candles + setting.count_of_candle  ~= setting.number_of_candles ) then 
        setting.old_number_of_candles = setting.number_of_candles;
        -- если новая свечка
        volumeRange =  volume;
        return
    end

    if oldVolume == volume then
        return
    end

    if oldVolume == 0 then 
        oldVolume =  volume
        return
    end
    -- вычисляем текущий объём
    -- это разница объёмов
    local updateValue = volume - oldVolume;
 
    if   lastTickVolume + rangeVolume <= updateValue  then 
        -- увеличение объёмов 
        countingTicsVolume =  countingTicsVolume + 1;
    end


    if lastTickVolume - rangeVolume >= updateValue  then 
        volumeRange = oldVolume - volume;
                -- уменьшение объёмов 
                if countingTicsVolume > 1  then 
                     countingTicsVolume =   countingTicsVolume - 2;
                 end         
    end

    oldVolume = volume;  
    lastTickVolume = updateValue;
     
end

local function  calculatePrice( price,datetime)
    -- 
    

    -- цена выросла
    if oldPrice == 0 then
        oldPrice = price;
        return
    end 
    if oldPrice + rangeLocal < price   then
        if(countingTicsVolume > CRITICAL_VOLUME)  then
            --  цена и объём  растёт   
        collbackFunc( price, datetime, countingTicsVolume,   'buy');
        end
    end
     

    -- цена упала
    if oldPrice - rangeLocal > price then 
        if(countingTicsVolume > CRITICAL_VOLUME) then
            --  цена  и объём падает
        collbackFunc( price, datetime,  countingTicsVolume, 'sell' );
  
        end
    end
    oldPrice = price;
end

-- вычисляем сигнал
local function  calculateSignal(object)
   
    calculateVolume(object.volume)
    calculatePrice(object.close, object.datetime) 

end;




-- local function  setRange(range)

-- rangeLocal = rangegetNumCandle
 

-- end;

local function  getRange()
    return rangeLocal;
end;
  

local function getSignal(tg, callback)
    seconds = os.time(datetime); -- в seconds будет значение 1427052491

    collbackFunc = callback;
    shift = 0;

    setting.number_of_candles = getNumCandles(setting.tag); 
    bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, setting.number_of_candles-2*len-shift,2*len)

    local lines_count = getLinesCount(tg) 
    local bars={}

    local i=len
    local j=2*len
 
    while i>=1 do

     if bars_temp[j-1] == nul then
        message(words.word('not_found_tag'));
     end
            if bars_temp[j-1].datetime.hour >= 10 then
                    sk=true
                    if bars_temp[j-1].datetime.hour ==18 and bars_temp[j-1].datetime.min==45 then
                            sk=false
                    end
                    if sk then
                            bars[i]=bars_temp[j-1] 
                          calculateSignal( bars[len] )
                          i=i-1
                    end
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