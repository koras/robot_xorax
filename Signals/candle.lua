-- scriptTest.lua (in your scripts directory)
local M = {}

local loger = dofile(getScriptPath() .. "\\loger.lua")
 
   

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

 

local function getSignal(tag, callback)
    seconds = os.time(datetime); -- в seconds будет значение 1427052491

    collbackFunc = callback;
    shift = 0;

    number_of_candles = getNumCandles(setting.tag); 
    bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, number_of_candles-2*len-shift,2*len)

    local lines_count = getLinesCount(setting.tag) 
    bars={}

    i=len
    j=2*len
    while i>=1 do
     if(bars_temp[j-1].datetime.hour == nul)then
     end
            if bars_temp[j-1].datetime.hour >= 10 then
                    setting.current_price = bars_temp[j-1].price;
                    sk=true
                            bars[i]=bars_temp[j-1] 
                          calculateSignal( bars[len] )
                          collbackFunc(bars[len]);
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