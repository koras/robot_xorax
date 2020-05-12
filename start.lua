-- https://www.lua.org/ftp/

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
 
 
  -- uTransaction.iTransaction()
    

 
  
  --SPRED = 0.05; -- минимальная прибыль
  setting_scalp = true; -- на тихий рынок
  
  
  SPRED_LONG_BUY = 0.02; -- покупаем если в этом диапозоне небыло покупок
  SPRED_LONG_TREND_DOWN = 0.04; -- рынок падает, увеличиваем растояние между покупками
  SPRED_LONG_TREND_DOWN_SPRED = 0.02; -- на сколько увеличиваем растояние

  SPRED_LONG_TREND_DOWN_LAST_PRICE= 0; -- последняя покупка
  
  SPRED_LONG_PRICE_DOWN = 0.04; -- не покупать если мы продали по текущей цене, вниз
  SPRED_LONG_PRICE_UP = 0.04; -- не покупать если мы продали по текущей цене, вверх. Если мы явно в росто идём
  SPRED_LONG_LOST_SELL = 0; -- Последняя цена сделки по продаже констракта



 --  count_buy = 0;
  -- count_sell = 0;

   profit = 0;
   --sellTable = {};
   bid = {}
   RangeSignal    = 0.1;            -- �������� ����

   --require (modname)
   
   log =  "take_log.log"
   
   
   INTERVAL          = INTERVAL_M1;          -- ��������� ������� (��� ���������� ����������)
   SLOW_MA_PERIOD    = 12;                   -- ������ ��������� ����������
   SLOW_MA_SOURCE    = 'C';                  -- �������� ��������� ���������� [O - open, C - close, H - hi, L - low]
   FAST_MA_PERIOD    = 4;                    -- ������ ������� ����������
   FAST_MA_SOURCE    = 'C';                  -- �������� ������� ���������� [O - open, C - close, H - hi, L - low]
   STOP_LOSS         = 10;                   -- ������ ����-����� (� ����� ����)
   TAKE_PROFIT       = 30;                   -- ������ ����-������� (� ����� ����)
   GET_GRAFFIC       = FALSE;                   -- ������ ����-������� (� ����� ����)
    
   --/*������� ���������� ������ (������ �� �����)*/
   SEC_PRICE_STEP    = 0;                    -- ��� ���� �����������
   SEC_NO_SHORT      = false;                -- ����, ��� �� ������� ����������� ��������� �������� ����
   DS                = nil;                  -- �������� ������ ������� (DataSource)
   ROBOT_STATE       ='� ������ ����� �����';-- ��������� ������ ['� �������� ������', ���� '� ������ ����� �����']
   trans_id          = os.time();            -- ������ ��������� ����� ID ����������
   trans_Status      = nil;                  -- ������ ������� ���������� �� ������� OnTransPeply
   trans_result_msg  = '';                   -- ��������� �� ������� ���������� �� ������� OnTransPeply
  
  
  -- SHORT  = FALSE
   -- LONG = true
   CurrentDirect     = 'LONG';                -- ������� ����������� ['BUY', ��� 'SELL']
   LastOpenBarIndex  =  0;                   -- ������ �����, �� ������� ���� ������� ��������� ������� (����� ��� ����, ����� ����� �������� �� ����� ��� �� �� ������� ��� ���� �������)
   Run               = true;                 -- ���� ����������� ������ ������������ ����� � main
     
   Array5Min = {}      -- ������� ������ ��� �������� ������� �������/������ �� ��������� 5-�� 1-�������� ������ 
    
function init()

   tradeSignal.setRange(RangeSignal);
  --   control.show();

end;
    
    
shift = 0;
len = 100
basis = 9
 
    
    Size = 0;
   function OnInit()

      control.show(); 

  
      local Error = '';
      ds,Error = CreateDataSource(setting.CLASS_CODE, setting.SEC_CODE, INTERVAL); 
    --  while (Error == "" or Error == nil) and DS:Size() == 0 do sleep(1) end
    
       
      -- ������ �������:
       
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
        -- message(' SEC_PRICE_STEP = ::: '..  p  ); 
      else 
       Run  = false;
     --    message('�� ���� �������� ������ � ������� ������ �� ������� ');
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
 

      -- setting.ACCOUNT =  '4105F8Y'; 
      -- setting.CLASS_CODE =  "SPBFUT"; 
      -- setting.SEC_CODE =  "BRM0" ; 
 --tostring(tonumber(getParamEx(CLASS_CODE, SEC_CODE, 'NUMCONTRACTS')))
      --local res = getParamEx(setting.CLASS_CODE, setting.SEC_CODE, 'NUMCONTRACTS')
      local res =getFuturesHolding("", setting.ACCOUNT, setting.SEC_CODE, 4)
      message(' Sres = ::: '.. res.totalnet  ); 

     signalShowLog.CreateNewTableLogEvent();

      label.init(setting.tag);
      loger.save(  " start ");
      statsPanel.show();

      interfaceBids.show();

      update();
      getPrice();

 
       CurrentDirect = "SELL" 
       local Price = false;
          
      while Run do 
         
          
           update();
           statsPanel.stats();
           fractalSignal.last();

         
          if setting.status  then  
            tradeSignal.getSignal(setting.tag, eventTranc);
            candles.getSignal(tag, market.callSELL);
         end;
      end;  
   end;
     


   function OnTransReply(trans_reply) 
      if trans_reply.trans_id == trans_id then 
         trans_Status = trans_reply.status; 
         trans_result_msg  = trans_reply.result_msg;
      end;
   end;
     

   
   function OnStop()
      Run = false;
      control.deleteTable();
      signalShowLog.deleteTable();
      statsPanel.deleteTableStats();
      interfaceBids.deleteTable();
   end;
    

   