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

dofile(getScriptPath() .. "\\setting\\account.lua");
dofile(getScriptPath() .. "\\setting\\work.lua");
 
local uTransaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local scriptTest = dofile(getScriptPath() .. "\\coutLine.lua");
local candles = dofile(getScriptPath() .. "\\Signals\\candle.lua");
local tradeSignal = dofile(getScriptPath() .. "\\Signals\\tradeSignal.lua"); 
local fractalSignal = dofile(getScriptPath() .. "\\Signals\\fractal.lua"); 
local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local FRACTALS = dofile(getScriptPath() .. "\\LuaIndicators\\FRACTALS.lua"); 
local market = dofile(getScriptPath() .. "\\shop\\market.lua");
local deleteBids = dofile(getScriptPath() .. "\\shop\\deleteBids.lua");
 
  
     
  setting_scalp = true; -- на тихий рынок
  
  
  SPRED_LONG_BUY = 0.02; -- покупаем если в этом диапозоне небыло покупок
  SPRED_LONG_TREND_DOWN = 0.04; -- рынок падает, увеличиваем растояние между покупками
  SPRED_LONG_TREND_DOWN_SPRED = 0.02; -- на сколько увеличиваем растояние

  SPRED_LONG_TREND_DOWN_LAST_PRICE= 0; -- последняя покупка
  
  SPRED_LONG_PRICE_DOWN = 0.04; -- не покупать если мы продали по текущей цене, вниз
  SPRED_LONG_PRICE_UP = 0.04; -- не покупать если мы продали по текущей цене, вверх. Если мы явно в росто идём
  SPRED_LONG_LOST_SELL = 0; -- Последняя цена сделки по продаже констракта




   --require (modname)
   
   log =  "take_log.log"
   
   
 
  
  -- SHORT  = FALSE
   -- LONG = true
  LastOpenBarIndex  =  0;                   -- ������ �����, �� ������� ���� ������� ��������� ������� (����� ��� ����, ����� ����� �������� �� ����� ��� �� �� ������� ��� ���� �������)
   Run               = true;  
     

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
      
        p      = tostring(getParamEx(setting.CLASS_CODE, setting.SEC_CODE, "offer").param_value + 10*getParamEx(setting.CLASS_CODE, setting.SEC_CODE, "SEC_PRICE_STEP").param_value); -- �� ����, ���������� �� 10 ���. ����� ����
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
      control.stats()

      market.setLitmitBid();
      use_contract_limit();
   end


   function main()
   
      tradeSignal.getSignal(setting.tag, eventTranc);

     signalShowLog.CreateNewTableLogEvent();

      label.init(setting.tag);
      loger.save(  " start ");
      statsPanel.show();

      interfaceBids.show();

      update();
      getPrice();
      control.show(); 

 
       local Price = false;
          
      while Run do 
         update();
           statsPanel.stats();
           fractalSignal.last();

         
          if setting.status  then  
            tradeSignal.getSignal(setting.tag, eventTranc);
            candles.getSignal(tag, deleteBids.callSELLEmulation);
         end;
      end;  
   end;
   
   
   
   -- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

   -- OnTrade показывает статусы сделок.
   -- Функция вызывается терминалом когда с сервера приходит информация по заявке 
   function OnOrder(order)
      if  bit.band(order.flags,3) == 0 then
         deleteBids.transCallback(order);
        -- trans_id
      end;


      if bit.band(order.flags,1) + bit.band(order.flags,2) == 0  then loger.save("исполнена loger.save(") end;
      loger.save('OnOrder' )

   end



-- OnTransReply -> OnTrade -> OnOrder 
   -- Функция вызывается терминалом когда с сервера приходит информация по сделке
   function OnTrade(trade)
   local test = CheckBit(trade.flags, 3);
   if (test == 0) then
      -- если бит 0 и 1 не установлены -- заявка выполнена
      loger.save('CheckBit(order.flags, 3)  ' )
    --  self:OnStatusChanged(ST_FILLED);

   --   self:InternalDelete();
   else
      local sell = CheckBit(trade.flags, 4) ~= 0;
   --   assert((sell == (self.request.OPERATION == "S")) and (not sell == (self.request.OPERATION == "B")));
      -- if (test == 2) then
      -- --   self:OnStatusChanged(ST_REJECTED);
      -- --   self:InternalDelete();
      -- else
      -- --   self:UpdateTiming();
      -- end
   end


      loger.save('OnTrade end' )
       
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