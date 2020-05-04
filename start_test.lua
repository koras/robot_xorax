local lua51path = "C:\\Program Files (x86)\\Lua\\5.1\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

package.cpath = "./?.dll;./?51.dll;"
        .. lua51path .. "?.dll;"
        .. lua51path .. "?51.dll;"
        .. lua51path .. "clibs/?.dll;"
        .. lua51path .. "clibs/?51.dll;"
        .. lua51path .. "loadall.dll;"
        .. lua51path .. "clibs/loadall.dll;"
        .. package.cpath
package.path = package.path
        .. ";./?.lua;"
        .. lua51path .. "lua/?.lua;"
        .. lua51path .. "lua/?/init.lua;"
        .. lua51path .. "?.lua;"
        .. lua51path .. "?/init.lua;"
        .. lua51path .. "lua/?.luac;"

        require("table")
          
local loger = dofile(getScriptPath() .. "\\loger_test.lua");



Run    = true;    

 
 
   
 
function init()
   tradeSignal.setRange(RangeSignal);
end;
    
setting = {
   ['profit_range'] =  0.05; -- минимальная прибыль
   ['profit_range_array'] =  0.03; -- минимальная прибыль при больших заявках
   ['profit_infelicity'] =  0.01; -- погрешность
   ['profit'] =  0.01; -- подсчёт прибыли
   ['LIMIT_BID'] = 10,
   ['use_contract'] = 1,
   ['emulation'] = true,
   ['candles'] = {}, -- свечи
   
   ['status'] = false, 
   
   ['tag'] = "my_br",

   ['number_of_candles'] = 0,

   ['fractals_collection'] = {},
   ['fractal_up'] = 0,
   ['fractal_down'] = 0,
   ['fractal_count'] = 0, -- о скольких свечах у нас есть информация
   ['fractal_down_range'] = 0.05, -- если цена ниже, значит здесб был уровень, а под уровнем не покупаем.
   ['fractal_candle'] = 3,
   ['fractal_under_up'] = 0.06, -- под вверхом не покупаем, можем пробить а цена не пойдёт в нашу сторону

};
    

function OnInit()


end;
  
fruits = {};  
 
function main()

   while Run do 
   
   shift = 0;
   len = 100;
   basis = 9;


   seconds = os.time(datetime); -- в seconds будет значение 1427052491

   collbackFunc = callback;
   shift = 0;

   setting.number_of_candles = getNumCandles(setting.tag); 

   bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, setting.number_of_candles-2*len-shift,2*len)

   local lines_count = getLinesCount(setting.tag) 
   bars={}

   i=len
   j=2*len
   while i>=1 do
    if(bars_temp[j-1].datetime.hour == nul)then
    end
           if bars_temp[j-1].datetime.hour >= 10 then

               setting.current_price = bars_temp[j-1].close;

               local bar = bars_temp[j-1];
                bar['number_candle'] = setting.number_of_candles;



               if #setting.fractals_collection > 0 then

                  setting.fractals_collection[ #setting.fractals_collection + 1 ] = bar;

               else

                  reloadCandles(bar)

               end 
               --    loger.save( " bars_temp[j-1].price ".. bars_temp[j-1].close );
                          bars[i]=bars_temp[j-1] 
                        
                         i=i-1
           end
           j=j-1
   end
   t = len+1


     
   fruits[1] = { {['aa']= 111,['bb']= 22} };
   fruits[333] = { {['aa']= 111,['bb']= 22} };
   fruits[334] = { {['aa']= 111,['bb']= 22} };

   loger.save( " fruits".. #fruits );

   table.insert(fruits, 8,"grapes")
   loger.save( " fruits ".. #fruits );

 
         
         
       
   end;  
end;
     
setting['candle_low'] = 0;
setting['candle_high'] = 0;
setting['candle_'] = 0;

 
function  reloadCandles(bar)

   for c = 1 ,  #setting.fractals_collection do 
      --   if statusRange then
 --  #setting.fractals_collection[(#setting.fractals_collection + 1 )]

     --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

   --  ['fractals_collection'] = {},
   --  ['fractal_up'] = 0,
   --  ['fractal_down'] = 0,
   --  ['fractal_down_range'] = 0.05, -- если цена ниже, значит здесб был уровень, а под уровнем не покупаем.
   --  ['fractal_candle'] = 3,
   --  ['fractal_under_up'] = 0.06, -- под вверхом не покупаем, можем пробить а цена не пойдёт в нашу сторону


         if  setting.fractals_collection[c].number_candle == bar.number_candle then 
             
            setting.fractals_collection[c] = bar;
            
            -- Проверяем, это падение, сравниваем с старыми свечами.


         end;
      end;
end;

       











function OnTransReply(trans_reply) 
  
      
end;
     

   
function OnStop()
      Run = false;
end;
    

   