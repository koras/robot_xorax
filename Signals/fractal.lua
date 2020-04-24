-- scriptTest.lua (in your scripts directory)
local M = {}
 
-- table.remove (bid,j);


local function last(text)
    number_of_candles = getNumCandles(tag); 
    
 
 
    
    t, n, l  =  getCandlesByIndex(tag, 0, number_of_candles-2*len-shift,2*len)

    
    local lines_count = getLinesCount(tag) 
    
    message("number_of_candles :".. lines_count) 
    TimeWork;
  --  t, n, l = getCandlesByIndex(tag, 0, 0, getNumCandles("tag")-1) 
    local Up=false
    local Down=false
    message("number_of_candles :".. number_of_candles)
    for i=0,n-1 do
      num=n-1-i
      if (t[num].high)>0 then
          Up=true
          
          message("number_of_candles :".. t[num].datetime.hour..":"..t[num].datetime.min)

          message("Up=".. t[num].datetime.hour..":"..t[num].datetime.min)
      end
      if (t[num].low)>0 then
          Down=true
          message("Down=".. t[num].datetime.hour..":"..t[num].datetime.min)
      end
      if Up and Down then
          break
      end
    end
end
M.last = last
return M