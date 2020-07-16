-- только для иестирования


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
 
 
setting = {};
stopClass = {};
engine = {};
 
dofile(getScriptPath() .. "\\setting\\work_rb.lua"); 
dofile(getScriptPath() .. "\\setting\\engine.lua");
 
 
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local vecm = dofile(getScriptPath() .. "\\modules\\vector.lua");
local v3 = dofile(getScriptPath() .. "\\modules\\Vec3.lua");
 
local candles = dofile(getScriptPath() .. "\\Signals\\candle.lua");
local tradeSignal = dofile(getScriptPath() .. "\\Signals\\tradeSignal.lua"); 
local fractalSignal = dofile(getScriptPath() .. "\\Signals\\fractal.lua"); 
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local candleGraff = dofile(getScriptPath() .. "\\interface\\candleGraff.lua");

 

--local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");

local market = dofile(getScriptPath() .. "\\shop\\market.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");


local test_bids = dofile(getScriptPath() .. "\\tests\\test_bids.lua");
 
local riskStop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");
 
 

   
Run  = true;  

function init()

 --  tradeSignal.setRange(RangeSignal);
  --   control.show();

end;
     

    Size = 0;
   function OnInit()
    
   end;
   
   function getPrice()
   
  
   end;
     
 
    
    
   function eventTranc( priceLocal , levelLocal ,datetime, event) 
  
   end
    

   function  update()
 
   end

   function trans()
      
      local price = 40;
      local use_contract = 1;
      local type = "SIMPLE_STOP_ORDER";

      trans_id_sell =  transaction.send("S", price, use_contract, type, 0);

   end;


   function angle(x1, y1, z1, x2, y2, z2)
             return math.deg(math.acos((x1*x2+y1*y2) / (((x1^2+y1^2)^0.5) * ((x2^2+y2^2)^0.5)))) 
    end


    function getAngle(Ax1, Ay1, Bx2, By2, Cx1, Cy2)
        
    end;


   function main() 
      -- например

      
      local a = {}
      local b = {}
      local c = {}
      local AB = {}
      local AC = {}

      a.x = 1133; 
      a.y = 4135;
      b.x = 1504 ;
      b.y = 4100;

       

      c.x = b.x;
      c.y = a.y;

      -- вычисляем вектор угла AB
      AB.x = (b.x - a.x) ;
      AB.y = (b.y - a.y) ;

      -- вычисляем вектор угла AC
      AC.x = (c.x - a.x) ;
      AC.y = (c.y - a.y) ;

      local x3  = (b.x - a.x);
      local y3  = (b.y - a.y);


    local  res =  math.acos( (x3*x3+y3*0) / ( ((x3^2+y3^2)^0.5) * ((x3^2+0^2)^0.5))); 

    message("result = " ..   math.deg(res) )


  --    local ans = math.acos(a:dot(b) / (a:len() * b:len()))
  --    message(math.deg(ans))

  --   local result = angle(x1, y1, z1, x2, y2, z2);
    --  message("result = " .. result);

   end;




   
 -- срабатывает при обновлении свечи
   function updateTick(result)

      if  setting.emulation then
         -- обработка во время эмуляции
      --   market.callSELL_emulation(result);
         -- сработал стоп в режиме эмуляции
      --   riskStop.appruveOrderStop(result)
      end;
      
   end;


   
   
   -- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

   -- OnTrade показывает статусы сделок.
   -- Функция вызывается терминалом когда с сервера приходит информация по заявке 
   function OnOrder(order)
      loger.save("OnOrder "); 

      if  bit.band(order.flags,3) == 0 then
 
  
         if bit.band(order.flags, 2) == 0 then

         else
           loger.save("SELL SELL SELL SELL SELL "); 
         
         end;


        -- trans_id
      end;
      
      if bit.band(order.flags,1) + bit.band(order.flags,2) == 0  then 


         loger.save("исполнена loger.save(  order.price ".. order.price) 
 
      
      
      end;
   end



-- OnTransReply -> OnTrade -> OnOrder 
   -- Функция вызывается терминалом когда с сервера приходит информация по сделке
   function OnTrade(trade) 
      loger.save('OnTrade')

   local sell = CheckBit(trade.flags, 1);

   if (sell  == 0) then

   end;

   if bit.band(trade.flags, 2) == 0 then
      -- исполняется покупка контракта 

      loger.save('OnTrade end 222  -- исполняется покупка контракта')
   else
      loger.save('OnTrade end 111 -- исполняется продажа контракта ')
     
   end;


   if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then

      if bit.band(trade.flags, 2) == 0 then
         -- исполняется покупка контракта 
  
      end; 
   end
    
       
   end


-- Функция возвращает true, если бит с номером index флагов flags установлен в 1
function bit_set( flags, index )
   local n=1;
   n=bit.lshift(1, index);
   if bit.band(flags, n) ~=0 then
       return true;
   else
       return false;
   end;
end


   -- Функция вызывается терминалом когда с сервера приходит информация по сделке
   function OnStopOrder(trade)
      loger.save(' OnStopOrder' )

      if  bit.band(trade.flags,4)>0
         then

            if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then
               loger.save('Заявка 11111 №'..trade.order_num..' appruve Sell Sell Sell')
            
             --  riskStop.appruveOrderStop(trade)
            end

         -- заявка на продажу
      loger.save(' trade.flags Sell ')
         else
         -- заявка на покупку
      loger.save(' trade.flags Buy ')
         end
      
         if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then
            loger.save('Заявка 11111 №'..trade.order_num..' appruve')
         end

   end


   

   

      -- Вызывается движком при полном, или частичном ИСПОЛНЕНИИ ЗАЯВКИ
   function SE_OnExecutionOrder(order)
      -- Здесь Ваш код для действий при полном, или частичном исполнении заявки
      -- ...
      -- Выводит сообщение
      loger.save('SE_OnExecutionOrder() БАЛАНС заявки №'..order.order_num..' изменился с '..(order.qty - (order.last_execution_count or 0))..' на '..order.balance)
   end

   -- успешное ВЫПОЛНЕНИИ ТРАНЗАКЦИИ
   function SE_OnTransOK(trans)
      -- Здесь Ваш код для действий при успешном выполнении транзакции
      -- ...
      -- Выводит сообщение
      loger.save('SE_OnTransOK() Транзакция №'..trans.trans_id..' УСПЕШНО выполнена')
   end


   function OnTransReply(trans_reply) 

   end;
     




   

   
   function OnStop()

      Run = false;
      control.deleteTable();
      signalShowLog.deleteTable();
      statsPanel.deleteTableStats();
      panelBids.deleteTable();
      candleGraff.deleteTableGraff();

      DelAllLabels(setting.tag);

   end;
    

   -- Функция проверяет установлен бит, или нет (возвращает true, или false)
  function CheckBit(flags, _bit)
   -- Проверяет, что переданные аргументы являются числами
   if type(flags) ~= "number" then loger.save("Ошибка!!! Checkbit: 1-й аргумент не число!") end
   if type(_bit) ~= "number" then loger.save("Ошибка!!! Checkbit: 2-й аргумент не число!") end
 
   if _bit == 0 then _bit = 0x1
   elseif _bit == 1 then _bit = 0x2
   elseif _bit == 2 then _bit = 0x4
   elseif _bit == 3 then _bit  = 0x8
   elseif _bit == 4 then _bit = 0x10
   elseif _bit == 5 then _bit = 0x20
   elseif _bit == 6 then _bit = 0x40
   elseif _bit == 7 then _bit  = 0x80
   elseif _bit == 8 then _bit = 0x100
   elseif _bit == 9 then _bit = 0x200
   elseif _bit == 10 then _bit = 0x400
   elseif _bit == 11 then _bit = 0x800
   elseif _bit == 12 then _bit  = 0x1000
   elseif _bit == 13 then _bit = 0x2000
   elseif _bit == 14 then _bit  = 0x4000
   elseif _bit == 15 then _bit  = 0x8000
   elseif _bit == 16 then _bit = 0x10000
   elseif _bit == 17 then _bit = 0x20000
   elseif _bit == 18 then _bit = 0x40000
   elseif _bit == 19 then _bit = 0x80000
   elseif _bit == 20 then _bit = 0x100000
   end
 
   if bit.band(flags,_bit ) == _bit then return true
   else return false end
end