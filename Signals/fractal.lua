
local loger = dofile(getScriptPath() .. "\\loger.lua");

-- scriptTest.lua (in your scripts directory)
local M = {}
 
-- table.remove (bid,j);




    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи


local function last()
    number_of_candles = getNumCandles(tag); 
    t, n, l  =  getCandlesByIndex(tag, 0, number_of_candles-2*len-shift,2*len)
    local lines_count = getLinesCount(tag) 
  --  loger.save( 'null 12313' )   
   -- message("number_of_candles :".. lines_count) 
 
  --  t, n, l = getCandlesByIndex(tag, 0, 0, getNumCandles("tag")-1) 
    local Up=false
    local Down=false 
    for i=0,n-1 do
      num=n-1-i


      setting.fractals_collection[number_of_candles] = {
          ['high'] = t[num].high,
          ['low'] = t[num].low
      };

    --  loger.save( 't[num].high'  .. t[num].high )   
    --    message("t[num].high :"..t[num].high) 


      if (t[num].high)>0 then
        
        setting.fractals_collection[number_of_candles] = {
            ['high'] = t[num].high,
            ['low'] = t[num].low
          };
  
        Up=true;
          

      --  table.remove (bid,j);


    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
        --    message("number_of_candles :".. t[num].datetime.hour..":"..t[num].datetime.min)

        --   message("Up=".. t[num].datetime.hour..":"..t[num].datetime.min)
      end
      if (t[num].low)>0 then


          setting.fractals_collection[number_of_candles]['low'] = t[num].low;

          Down=true;
       ---   message("Down=".. t[num].datetime.hour..":"..t[num].datetime.min)

      end
      if Up and Down then
          break
      end
    end
end
M.last = last
return M