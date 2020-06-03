-- https://www.lua.org/ftp/


-- Бесплатный робот торгующий в боковике "robot XoraX"
-- https://t.me/robots_xorax
-- https://smart-lab.ru/blog/621155.php


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

dofile(getScriptPath() .. "\\setting\\account.lua");
dofile(getScriptPath() .. "\\setting\\work.lua");
dofile(getScriptPath() .. "\\setting\\stop.lua");
 
local uTransaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");

local candles = dofile(getScriptPath() .. "\\Signals\\candle.lua");
local tradeSignal = dofile(getScriptPath() .. "\\Signals\\tradeSignal.lua"); 
local fractalSignal = dofile(getScriptPath() .. "\\Signals\\fractal.lua"); 
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local FRACTALS = dofile(getScriptPath() .. "\\LuaIndicators\\FRACTALS.lua"); 
local market = dofile(getScriptPath() .. "\\shop\\market.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");


local test_bids = dofile(getScriptPath() .. "\\tests\\test_bids.lua");
 
local riskStop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");
 
 

   
Run  = true;  

function init()

   tradeSignal.setRange(RangeSignal);
  --   control.show();

end;
    
    
shift = 0;
len = 100
basis = 9

    Size = 0;
   function OnInit()

  
      local Error = '';
      ds,Error = CreateDataSource(setting.CLASS_CODE, setting.SEC_CODE, setting.INTERVAL); 
    --  while (Error == "" or Error == nil) and DS:Size() == 0 do sleep(1) end
    
       
     if Error ~= "" and Error ~= nil then message("1111111111111111111111 : "..Error) return end
    -- GET_GRAFFIC
      
      GET_GRAFFIC   = ds:SetEmptyCallback();
    --  ds:SetUpdateCallback(MyFuncName);
    
      Size =ds:Size();  
      
        p      = tostring(getParamEx(setting.CLASS_CODE, setting.SEC_CODE, "offer").param_value + 10*getParamEx(setting.CLASS_CODE, setting.SEC_CODE, "SEC_PRICE_STEP").param_value); 
       SEC_PRICE_STEP = tostring(getParamEx2(setting.CLASS_CODE, setting.SEC_CODE, "SEC_PRICE_STEP").param_value);	
   end;
   
   function getPrice()
   
       SEC_PRICE_STEP = tostring(getParamEx2(setting.CLASS_CODE, setting.SEC_CODE, "SEC_PRICE_STEP").param_value);
         if GET_GRAFFIC then
      else 
       Run  = false;
        end;
        
   end;
     
 
    
    
   function eventTranc( priceLocal , levelLocal ,datetime, event) 
      -- buy or sell
      market.decision(event, priceLocal, datetime , levelLocal) ;
   end
    

   function  update()
      control.stats();
      market.setLitmitBid();
      use_contract_limit();

      -- riskStop.appruveOrderStop(trade)
   end


   function main() 
      candles.getSignal(tag, market.callSELL_emulation);

      tradeSignal.getSignal(setting.tag, eventTranc);
      signalShowLog.CreateNewTableLogEvent();

 
      loger.save("start log");

   --   statsPanel.show();
      interfaceBids.show();
      update();
      getPrice();
      control.show(); 

      -- для тестирования
   --   setting.sellTable = test_bids.getOrder(setting.current_price);
   --    panelBids.show();
   --    riskStop.update_stop();
   --    riskStop.removeOldOrderSell(11);
   --   test_bids.saleBids(setting.current_price) 


      local Price = false;
          
      while Run do 
         update();
         --  statsPanel.stats();
           fractalSignal.last();

         
          if setting.status  then  
            tradeSignal.getSignal(setting.tag, eventTranc);
            candles.getSignal(tag, updateTick);
         end;
      end;  
   end;
   

-- срабатывает при обновлении свечи
   function updateTick(result)

      if  setting.emulation then
         -- обработка во время эмуляции
         market.callSELL_emulation(result);
         -- сработал стоп в режиме эмуляции
         riskStop.appruveOrderStop(result)
      end;
      
   end;


   
   
   -- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

   -- OnTrade показывает статусы сделок.
   -- Функция вызывается терминалом когда с сервера приходит информация по заявке 
   function OnOrder(order)

      if  bit.band(order.flags,3) == 0 then
 
 
       --  loger.save("====================================================== "); 
         if bit.band(order.flags, 2) == 0 then

         else
           loger.save("SELL SELL SELL SELL SELL "); 
            deleteBids.transCallback(order);
         end;


        -- trans_id
      end;
      
      if bit.band(order.flags,1) + bit.band(order.flags,2) == 0  then 


         loger.save("исполнена loger.save(  order.price ".. order.price) 

         loger.save("исполнена loger.save( trans_id  ".. order.trans_id) 
         market.sellContract(order);
      
      
      end;
   end



-- OnTransReply -> OnTrade -> OnOrder 
   -- Функция вызывается терминалом когда с сервера приходит информация по сделке
   function OnTrade(trade) 

   local sell = CheckBit(trade.flags, 1);

   if (sell  == 0) then

   end;

   if bit.band(trade.flags, 2) == 0 then
      -- исполняется покупка контракта 
      market.buyContract(trade);
      loger.save('OnTrade end 222  -- исполняется покупка контракта')
   else
      loger.save('OnTrade end 111 -- исполняется продажа контракта ')
       market.sellContract(trade);
   end;


   if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then

      if bit.band(trade.flags, 2) == 0 then
         -- исполняется покупка контракта 
         market.buyContract(trade);
         loger.save('OnTrade end  -- исполняется покупка контракта')
      else
         loger.save('OnTrade end  -- исполняется продажа контракта 1')
          market.sellContract(trade);
      end;

      loger.save('trade.flags -- '..bit.band(trade.flags, 2))
      loger.save('trade.flags ++ '..tostring(trade.flags))

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
               market.sellContract(trade);
               riskStop.appruveOrderStop(trade)
            end

         -- заявка на продажу
      loger.save(' trade.flags Sell ')
         else
         -- заявка на покупку
      loger.save(' trade.flags Buy ')
         end
      
         if not CheckBit(trade.flags, 0) and not CheckBit(trade.flags, 1) then
            loger.save('Заявка 11111 №'..trade.order_num..' appruve')
            riskStop.updateOrderNumber(trade)
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
      interfaceBids.deleteTable();
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