--[[ ������� MA-����� (c)QuikLuaCSharp.ru
!!! ��� ������������� ������ � ��������������� ����� �� ����-����� !!!
  
]]

 
 

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

setting = {
         ['status'] = false,
         ['buy'] = true,
         ['sell'] = true,
         ['close_positions'] = false,
         ['ACCOUNT'] =  '4105F8Y';  
         ['CLASS_CODE'] =  "SPBFUT"; 
         ['SEC_CODE'] =  "BRK0";
      };

      

 -- �����������
 local uTransaction = dofile(getScriptPath() .. "\\transaction.lua")
 -- �����������
local scriptTest = dofile(getScriptPath() .. "\\coutLine.lua")
local candles = dofile(getScriptPath() .. "\\tradeSignal.lua")
local loger = dofile(getScriptPath() .. "\\loger.lua")
local label = dofile(getScriptPath() .. "\\drawLabel.lua")
local control = dofile(getScriptPath() .. "\\interface\\control.lua")

 

-- ��������� ������� � ������� ��� �������
local market = dofile(getScriptPath() .. "\\market.lua")
 
 
  -- uTransaction.iTransaction()
    

 

   RangeSignal    = 0.1;            -- �������� ����
   ACCOUNT        = '232957';        -- ������������� �����
   CLASS_CODE     = "SPBFUT"     -- ����� ������
   SEC_CODE       = "BR-5.20"       -- ��� ������
   tag =  "my_br"; -- �� �������

-- SHORT  = FALSE
-- LONG = true
 
    
   LIMIT_BID = 9; -- +1 contract
   
   
   -- Ford Motor Company
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

     candles.setRange(RangeSignal);
  --   control.show();

end;
    
    
  
len = 100
basis = 9
 
    
    Size = 0;
   function OnInit()

      control.show(); 

 
      -- �������� ������ � ������ �������
      local Error = '';
      ds,Error = CreateDataSource(CLASS_CODE, SEC_CODE, INTERVAL);
      -- ���� ������, � �������� ����� ������������ �� ������ � ���������, �� ������ ������������ � �������, �� �� ��������� ����� �����,
      -- �� �����, ������������� ��������� ��� ����� ��������, ������, ��� ���������� � DS:
      -- ����, ���� ������ ����� �������� � ������� (�� ������, ���� ����� ������ �� ������)
    --  while (Error == "" or Error == nil) and DS:Size() == 0 do sleep(1) end
    
       
      -- ������ �������:
       
     if Error ~= "" and Error ~= nil then message("1111111111111111111111 ������ ����������� � �������: "..Error) return end
    -- GET_GRAFFIC
     
      -- ������������� �� ���������� �������
      GET_GRAFFIC   = ds:SetEmptyCallback();
    --  ds:SetUpdateCallback(MyFuncName);
    
      Size =ds:Size(); -- ���������� ������� ������ (���������� ������ � ��������� ������) 
      -- �������� ��� ���� �����������
      
        p      = tostring(getParamEx(CLASS_CODE, SEC_CODE, "offer").param_value + 10*getParamEx(CLASS_CODE, SEC_CODE, "SEC_PRICE_STEP").param_value); -- �� ����, ���������� �� 10 ���. ����� ����
       SEC_PRICE_STEP = tostring(getParamEx2(CLASS_CODE, SEC_CODE, "SEC_PRICE_STEP").param_value);	
   end;
   
   function getPrice()
   
       SEC_PRICE_STEP = tostring(getParamEx2(CLASS_CODE, SEC_CODE, "SEC_PRICE_STEP").param_value);
         if GET_GRAFFIC then
        -- message(' SEC_PRICE_STEP = ::: '..  p  ); 
      else 
       Run  = false;
     --    message('�� ���� �������� ������ � ������� ������ �� ������� ');
        end;
        
   end;
     
 
    
    
   function eventTranc( priceLocal , levelLocal ,datetime, event)
    --  label.set(event, priceLocal , datetime,levelLocal);
       
     -- market.setDirect(CurrentDirect) 
               
      market.decision(event, priceLocal, datetime , levelLocal) 

  --    loger.save( 'price ' .. priceLocal ..' level '.. levelLocal .. ' event '..event   )
   


   end
    
   function main()
      label.init(tag);
      market.setLitmitBid(LIMIT_BID)
    loger.save(  " start ")
      -- ������� ���������
    --  message('������� MA-�����: '.." - " ..ROBOT_STATE);
      -- "�����������" ����
      getPrice();
          CurrentDirect = "SELL" 
            local Price = false; -- ���������� ��� ��������� ���������� �������� ������� (����, ���� ������(false))
             Result = SL_TP(Price, CurrentDirect);
         
         
          --   table = tostring(getParamEx2(CLASS_CODE, SEC_CODE, "SEC_PRICE_STEP"));
   
            
      
      
         
          --  for key,value in table do
         --	   if index < 2 or value+1 < index then return key; end;
         --	    message('key '.." - " ..key);
         --   end;
               
               
            
      while Run do 
         
        -- if setting.status == false then return; end;


         candles.getSignal(tag, eventTranc);
     
      --[[     --���� ��������� ������ "� �������� ������"
         if ROBOT_STATE == '� �������� ������' then
            -- ������� ���������
          --  message('������� MA-�����: � �������� ������');
            -- ������ 10 ������� ������� ������
    
         -- ����� 
         
            
            for i=1,10 do
               if not Run then return; end; -- ���� ������ ���������������, �� ���������� �������
               -- ���� ������ ��� �������� ������� SELL, � �������� ���� �� ������� ����������� ���������
               if CurrentDirect == "SELL" and SEC_NO_SHORT then
                  -- ��������� ���� FOR
                  break; 
               end;
               -- ��������� ������ ���������� ���� ["BUY", ��� "SELL"] �� ��������(�������) ���� �������� � 1 ���,
               --- ���������� ���� �������� ������, ���� FALSE, ���� ���������� ������� ������
               Price = Trade(CurrentDirect);
               -- ���� ������ ���������
               if Price ~= false then
                  -- ��������� ���� FOR
                  break;
               end;
               sleep(100); -- ����� � 100 �� ����� ��������� ������� ������
            end;
   
   
            if not Run then return; end; -- ���� ������ ���������������, �� ���������� �������
            -- ���� ������ �������
            
            if Price ~= false then
               -- ���������� ������ �����, �� ������� ���� ������� ��������� ������� (����� ��� ����, ����� ����� �������� �� ����� ��� �� �� ������� ��� ���� �������)
               LastOpenBarIndex = DS:Size();
               -- ������� ���������
               message('������� MA-�����: ������� ������ '..CurrentDirect..' �� ���� '..Price);
               -- ������ 10 ������� ��������� ����-���� � ����-������, � ��������� �������� ������
               message('������� MA-�����: ������ 10 ������� ��������� ����-���� � ����-������, � ��������� �������� ������');
               local Result = nil; -- ���������� ��� ��������� ���������� ����������� � ������������ ����-���� � ����-������
               for i=1,10 do
                  if not Run then return; end; -- ���� ������ ���������������, �� ���������� �������
                  -- ���������� ����-���� � ����-������, ���� ���� �� ���������, ��������� ���� � ��� ["BUY", ��� "SELL"] �������� ������,
                  --- ���������� FALSE, ���� �� ������� ��������� ����-���� � ����-������, ��� TRUE, ���� ������ ���������,
                  --- ���� NIL, ���� ��� ������ �� 10 ������� �� ������� ������������� ������� �������
               
               
                  Result = SL_TP(Price, CurrentDirect);
               
               
                  -- ���� ������ ���������
                  if Result == true then
                     -- ��������� ���� FOR
                     break;
                  end;
               end;
   
   
               -- ���� �� 10 ������� �� ������� ������� �������
               if Result == nil or Result == false then
                  -- ������� ���������
                  message('������� MA-�����: ����� 10-� ������� �� ������� ������� ������!!! ���������� �������!!!');
                  -- ��������� ���������� �������
                  Run = false;
                  -- ��������� �������� ���� WHILE
                  break;
               else -- ������� ������� ������               
                  -- ������� ���������
                  message('������� MA-�����: ������ ������� �� ����-�����, ���� ����-�������');
                  --������ ��������� ������ �� "� ������ ����� �����"
                  ROBOT_STATE = '� ������ ����� �����';
                  -- ������� ���������
                  message('������� MA-�����: � ������ ����� �����');
               end;
            else -- ������ �� ������� �������
               -- ���� ������ ��� ������� ������� SELL, � �������� ���� �� ������� ����������� ���������
               if CurrentDirect == "SELL" and SEC_NO_SHORT then
                  -- ������� ���������
                  message('������� MA-�����: ���� ������ ������� ��������� ����������� �������� ����! ������ ����� �� ����������:)');
                  --������ ��������� ������ �� "� ������ ����� �����"
                  ROBOT_STATE = '� ������ ����� �����';
                  -- ������� ���������
                  message('������� MA-�����: � ������ ����� �����');
               else
                  -- ������� ���������
                  message('������� MA-�����: ����� 10-� ������� �� ������� ������� ������!!! ���������� �������!!!');
                  -- ��������� ���������� �������
                  Run = false;
               end;
            end;
         else         
            -- ��������� ������ '� ������ ����� �����'
            -- ���� �� ���� ����� ��� �� ���� ������� �������
            if DS:Size() > LastOpenBarIndex then 
               -- ���� ������� ��������� ��������� ����� �����
           --    if FastMA(DS:Size()-1) <= SlowMA(DS:Size()-1) and FastMA() > SlowMA() then
                  -- ������ ����������� �� �������
             --     CurrentDirect = 'BUY';
             --     message('CurrentDirect = "BUY"');
                  -- ������ ��������� ������ �� "� �������� ������"
               --   ROBOT_STATE = '� �������� ������';
               -- ���� ������� ��������� ��������� ������ ����
        --       elseif FastMA(DS:Size()-1) >= SlowMA(DS:Size()-1) and FastMA() < SlowMA() then
                  -- ���� �� ������� ����������� �� ��������� �������� ����
           --       if not SEC_NO_SHORT then
                     -- ������ ����������� �� �������
              --       CurrentDirect = 'SELL';
              -       message('CurrentDirect = "SELL"');
                     -- ������ ��������� ������ �� "� �������� ������"
              -       ROBOT_STATE = '� �������� ������';
             --     end;
               end;
            end; 
         end;
         
         
        -- sleep(10);--����� 10 ��, ��� ����, ����� �� ����������� ��������� ����������
           ]]   
      end;  
   end;
    
   -- ������� ���������� ���������� QUIK ��� ��������� ������ �� ���������� ������������
   function OnTransReply(trans_reply)
      -- ���� ��������� ���������� �� ������� ����������
      if trans_reply.trans_id == trans_id then
         -- �������� ������ � ���������� ����������
         trans_Status = trans_reply.status;
         -- �������� ��������� � ���������� ����������
         trans_result_msg  = trans_reply.result_msg;
      end;
   end;
    
   -- ������� ���������� ���������� QUIK ��� ��������� �������
   function OnStop()
      Run = false;
      control.deleteTable();
   end;
    
   -----------------------------
   -- ��������������� ������� --
   -----------------------------
    
   -- ��������� ������ ���������� ���� (Type) ["BUY", ��� "SELL"] �� ��������(�������) ���� �������� � 1 ���,
   --- ���������� ���� �������� ������, ���� FALSE, ���� ���������� ������� ������
   function Trade(Type)
      --�������� ID ����������
      trans_id = trans_id + 1;
    
      local Price = 0;
      local Operation = '';
      --������������� ���� � ��������, � ����������� �� ���� ������ � �� ������ �����������
      if Type == 'BUY' then
         if CLASS_CODE ~= 'QJSIM' and CLASS_CODE ~= 'TQBR' then Price = getParamEx(CLASS_CODE, SEC_CODE, 'offer').param_value + 10*SEC_PRICE_STEP;end; -- �� ����, ���������� �� 10 ���. ����� ����
         Operation = 'B';
      else
         if CLASS_CODE ~= 'QJSIM' and CLASS_CODE ~= 'TQBR' then Price = getParamEx(CLASS_CODE, SEC_CODE, 'bid').param_value - 10*SEC_PRICE_STEP;end; -- �� ����, ���������� �� 10 ���. ����� ����
         Operation = 'S';
      end;
      -- ��������� ��������� ��� �������� ����������
      local Transaction={
         ['TRANS_ID']   = tostring(trans_id),
         ['ACTION']     = 'NEW_ORDER',
         ['CLASSCODE']  = CLASS_CODE,
         ['SECCODE']    = SEC_CODE,
         ['OPERATION']  = Operation, -- �������� ("B" - buy, ��� "S" - sell)
         ['TYPE']       = 'M', -- �� ����� (MARKET)
         ['QUANTITY']   = '1', -- ����������
         ['ACCOUNT']    = ACCOUNT,
         ['PRICE']      = tostring(Price),
         ['CLIENT_CODE']= '������� MA-�����'
      }
      -- ���������� ����������
    --  sendTransaction(Transaction);
      -- ����, ���� ������� ������ ������� ���������� (���������� "trans_Status" � "trans_result_msg" ����������� � ������� OnTransReply())
      while Run and trans_Status == nil do sleep(1); end;
      -- ���������� ��������
      local Status = trans_Status;
      -- ������� ���������� ����������
      trans_Status = nil;
      -- ���� ���������� �� ��������� �� �����-�� �������
      if Status ~= 3 then
         -- ���� ������ ���������� �������� ��� �������� ����
         if Status == 6 then
            -- ������� ���������
        --    message('������� MA-�����: ������ ���������� �������� ��� �������� ����!');
            SEC_NO_SHORT = true;
         else
            -- ������� ��������� � �������
        --    message('������� MA-�����: ���������� �� ������!\n������: '..trans_result_msg);
         end;
         -- ���������� FALSE
         return false;
      else --���������� ����������
         local OrderNum = nil;
         --���� ���� ������ �� �������� ������ ����� ��������� ���������
         --���������� ����� ������ � ��������
         local BeginTime = os.time();
         while Run and OrderNum == nil do
            --���������� ������� ������
            for i=0,getNumberOf('orders')-1 do
               local order = getItem('orders', i);
               --���� ������ �� ������������ ���������� ��������� ���������
               if order.trans_id == trans_id and order.balance == 0 then
                  --���������� ����� ������
                  OrderNum  = order.order_num;
                  --��������� ���� FOR
                  break;
               end;
            end;
            --���� ������ 10 ������, � ������ �� ���������, ������ ��������� ������
            if os.time() - BeginTime > 9 then
               -- ������� ��������� � �������
          --     message('������� MA-�����: ������ 10 ������, � ������ �� ���������, ������ ��������� ������');
               -- ���������� FALSE
               return false;
            end;
            sleep(10); -- ����� 10 ��, ����� �� ����������� ��������� ����������
         end;
    
         --���� ���� ������ �������� ������� ����� ���������
         --���������� ����� ������ � ��������
         BeginTime = os.time();
         while Run do    for i=0,getNumberOf('trades')-1 do
               local trade = getItem('trades', i);
               --���� ������ �� ������� ������
               if trade.order_num == OrderNum then
                  --���������� ����������� ���� �������� ������
                  return trade.price;
               end;
            end;
            --���������� ������� ������
        
            --���� ������ 10 ������, � ������ �� ���������, ������ �� ����-����� ��������� ������
            if os.time() - BeginTime > 9 then
               -- ������� ��������� � �������
               message('������� MA-�����: ������ 10 ������, � ������ �� ���������, ������ �� ����-����� ��������� ������');
               -- ���������� FALSE
               return false;
            end;
            sleep(10); -- ����� 10 ��, ����� �� ����������� ��������� ����������
         end;
      end;
   end;
    
    
    
    
   -- ������������� ��������� �������� ������� ����������� ���� (Type) ["BUY", ��� "SELL"]
   function KillPos(Type)
      -- ������ 10 �������
      local Count = 0; -- ������� �������
      if Type == 'BUY' then
         -- ���� ������ �� ���������� � ������� �� �������
         while Run and not Trade('SELL') do -- ��������� SELL, ��� ����� �������� BUY, ���� Trade('SELL') ������ TRUE, ���� �����������
            Count = Count + 1; -- ����������� �������
            -- ���� �� 10 ������� �� ������� ������� �������
            if Count == 10 then
               -- ���������� NIL
               return nil;
            end;
            sleep(100); -- ����� 100 ��, ����� ���������� �������� �� �������
         end;
      else
         -- ���� ������ �� ���������� � ������� �� �������
         while Run and not Trade('BUY') do -- ��������� BUY, ��� ����� �������� SELL, ���� Trade('BUY') ������ TRUE, ���� �����������
            Count = Count + 1; -- ����������� �������
            -- ���� �� 10 ������� �� ������� ������� �������
            if Count == 10 then
               -- ���������� NIL
               return nil;
            end;
            sleep(100); -- ����� 100 ��, ����� ���������� �������� �� �������
         end;
      end;
      -- ���������� TRUE, ���� ������� ������������� ������� �������
      return true;
   end;
    
    
    
   -- ���������� ����-���� � ����-������, ���� ���� �� ���������, ��������� ���� (Price) � ��� (Type) ["BUY", ��� "SELL"] �������� ������,
   --- ���������� FALSE, ���� �� ������� ��������� ����-���� � ����-������, ���� TRUE, ���� ������ ���������,
   --- ���� NIL, ���� ��� ������ �� 10 ������� �� ������� ������������� ������� �������
   function SL_TP(Price, Type)
      --   message(' ������������ ���� --' );
      -- ID ����������
      trans_id = trans_id + 1;
    
      -- ������� ����������� ��� ������
      local operation = "";
      local price = "0"; -- ����, �� ������� ���������� ������ ��� ������������ ����-����� (��� �������� ������ �� ������ ������ ���� 0)
      local stopprice = ""; -- ���� ����-�������
      local stopprice2 = ""; -- ���� ����-�����
      local market = "YES"; -- ����� ������������ �����, ��� �����, ������ ��������� �� �������� ����
      -- ���� ������ BUY, �� ����������� ����-����� � ����-������� SELL, ����� ����������� ����-����� � ����-������� BUY
      if Type == 'BUY' then
         operation = "S"; -- ����-������ � ����-���� �� �������(����� ������� BUY, ����� ������� SELL)
         -- ���� �� �����
         if CLASS_CODE ~= 'QJSIM' and CLASS_CODE ~= 'TQBR' then
            price = tostring(math.floor(getParamEx(CLASS_CODE, SEC_CODE, 'PRICEMIN').param_value)); -- ���� ������������ ������ ����� ������������� ����� ���������� ���������, ����� �� �������������
            market = "NO";  -- ����� ������������ �����, ��� �����, ������ ��������� �� �� �������� ����
         end;
         stopprice	= tostring(Price + TAKE_PROFIT*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-������
         stopprice2	= tostring(Price - STOP_LOSS*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-����
      else -- ������ SELL
         operation = "B"; -- ����-������ � ����-���� �� �������(����� ������� SELL, ����� ������� BUY)
         -- ���� �� �����
        
            price = tostring(math.floor(getParamEx(CLASS_CODE, SEC_CODE, 'PRICEMAX').param_value)); -- ���� ������������ ������ ����� ������������� ����� ����������� ���������, ����� �� �������������
       
       --  message(' ������������ ����  --'.. price  ); 
         
         if CLASS_CODE ~= 'QJSIM' and CLASS_CODE ~= 'TQBR' then
            price = tostring(math.floor(getParamEx(CLASS_CODE, SEC_CODE, 'PRICEMAX').param_value)); -- ���� ������������ ������ ����� ������������� ����� ����������� ���������, ����� �� �������������
            market = "NO";  -- ����� ������������ �����, ��� �����, ������ ��������� �� �� �������� ����
         end;
        
          --  message(' ������������ ���� == '.. Price  );
      --	stopprice	= tostring(Price - TAKE_PROFIT*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-������
      --	stopprice2	= tostring(Price + STOP_LOSS*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-����
         
         stopprice	= tostring(price - TAKE_PROFIT*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-������
         stopprice2	= tostring(price + STOP_LOSS*SEC_PRICE_STEP); -- ������� ����, ����� ������������ ����-����
      end;
      -- ��������� ��������� ��� �������� ���������� �� ����-���� � ����-������
      local Transaction = {
         ["ACTION"]              = "NEW_STOP_ORDER", -- ��� ������
         ["TRANS_ID"]            = tostring(trans_id),
         ["CLASSCODE"]           = CLASS_CODE,
         ["SECCODE"]             = SEC_CODE,
         ["ACCOUNT"]             = ACCOUNT,
         ["OPERATION"]           = operation, -- �������� ("B" - �������(BUY), "S" - �������(SELL))
         ["QUANTITY"]            = "1", -- ���������� � �����
         ["PRICE"]               = price, -- ����, �� ������� ���������� ������ ��� ������������ ����-����� (��� �������� ������ �� ������ ������ ���� 0)
         ["STOPPRICE"]           = stopprice, -- ���� ����-�������
         ["STOP_ORDER_KIND"]     = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER", -- ��� ����-������
         ["EXPIRY_DATE"]         = "TODAY", -- ���� �������� ����-������ ("GTC" � �� ������,"TODAY" - �� ��������� ������� �������� ������, ���� � ������� "������")
         -- "OFFSET" - (������)���� ���� �������� ����-������� � ���� ������ � �������,
         -- �� ����-������ ��������� ������ ����� ���� �������� ������� �� 2 ���� ���� �����,
         -- ��� ����� ������������ ��������� �������
         ["OFFSET"]              = tostring(2*SEC_PRICE_STEP),
         ["OFFSET_UNITS"]        = "PRICE_UNITS", -- ������� ��������� ������� ("PRICE_UNITS" - ��� ����, ��� "PERCENTS" - ��������)
         -- "SPREAD" - ����� ��������� ����-������, ���������� ������ �� ���� ���� ������� �� 100 ����� ����,
         -- ������� ������������� �������������� �� ������� ������ ����,
         -- �� ��, ��� ���� ����������� ����, ������ �� ���������������,
         -- �����, ������ ����� ������ �� ��������� (������ �� �������� ����� ����������, �� ���� � ���� ������� �� ��� ���������)
         ["SPREAD"]              = tostring(100*SEC_PRICE_STEP),
         ["SPREAD_UNITS"]        = "PRICE_UNITS", -- ������� ��������� ��������� ������ ("PRICE_UNITS" - ��� ����, ��� "PERCENTS" - ��������)
         -- "MARKET_TAKE_PROFIT" = ("YES", ��� "NO") ������ �� ���������� ������ �� �������� ���� ��� ������������ ����-�������.
         -- ��� ����� FORTS �������� ������, ��� �������, ���������,
         -- ��� �������������� ������ �� FORTS ����� ��������� �������� ������ ����, ����� ��� ��������� ����� ��, ��� ��������
         ["MARKET_TAKE_PROFIT"]  = market,
         ["STOPPRICE2"]          = stopprice2, -- ���� ����-�����
         ["IS_ACTIVE_IN_TIME"]   = "NO",
         -- "MARKET_TAKE_PROFIT" = ("YES", ��� "NO") ������ �� ���������� ������ �� �������� ���� ��� ������������ ����-�����.
         -- ��� ����� FORTS �������� ������, ��� �������, ���������,
         -- ��� �������������� ������ �� FORTS ����� ��������� �������� ������ ����, ����� ��� ��������� ����� ��, ��� ��������
         ["MARKET_STOP_LIMIT"]   = market,
         ["CLIENT_CODE"]         = "������� MA-����� ����-������ � ����-����"
      }
      -- ���������� ���������� �� ��������� ����-������ � ����-����
   
   
   
   
   --   sendTransaction(Transaction);   
      -- ����, ���� �� ������� ������ ������� ���������� (���������� "trans_Status" � "trans_result_msg" ����������� � ������� OnTransReply())
      
      
      
        --[[    
      while Run and trans_Status == nil do sleep(10); end;
      -- ���������� ��������
      local Status = trans_Status;
      -- ������� ���������� ����������
      trans_Status = nil;
      -- ���� ���������� �� ��������� �� �����-�� �������
      if Status ~= 3 then
         -- ������� ��������� � �������
         message('������� MA-�����: ��������� ����-������ � ����-���� �� �������!\n������: '..trans_result_msg);
         -- ���������� FALSE
         return false;
      else
         -- ������� ���������
         message('������� MA-�����: ���������� ������ ����-������ � ����-����: '..trans_id);
         local OrderNum_CLOSE = nil;
         -- ���� ���� ����-������ �� ����-���� � ����-������ ����� ��������� ���������
         while Run and OrderNum_CLOSE == nil do
            -- ���������� ������� ����-������
            for i=0,getNumberOf("stop_orders")-1 do
               local stop_order = getItem("stop_orders", i);
               -- ���� ������ �� ������� ���������� ����-���� � ����-������
               if stop_order.trans_id == trans_id then
                  -- ���� ������ �� ������������ ����-���� � ����-������ ���������� ��������� ���������
                  if stop_order.balance == 0 then
                     -- ���� �� ����������� ����-���� ���������� ������
                     if stop_order.linkedorder > 0 then
                        -- ���������� ����� ������, ������� ���� ������� ��� ������������ ����-����, ��� ����-������
                        OrderNum_CLOSE  = stop_order.linkedorder;
                        -- ��������� ���� FOR
                        break;
                     -- ����-������ ���������, �� ���� ���������� �������� ��������
                     elseif CheckBit(stop_order.flags, 10) == 1 then
                        -- ������������� ��������� �������� ������� � ������� �� �������
                        return KillPos(Type);
                     end;
                  end;
               end;
            end;
            sleep(10); -- ����� 10 ��, ����� �� ����������� ��������� ����������
         end;
         --���� ���� ������ �������� ������� ����� ���������
         --���������� ����� ������ � ��������
         BeginTime = os.time();
         while Run do
            --���������� ������� ������
            for i=0,getNumberOf("trades")-1 do
               local trade = getItem("trades", i);
               --���� ������ �� ������� ������ �� ����-���� � ����-������
               if trade.order_num == OrderNum_CLOSE then
                  -- ���������� TRUE
                  return true;
               end;
            end;
            --���� ������ 10 ������, � ������ �� ���������, ������ �� ����-����� ��������� ������ ������� "��������� �����-������ �����������"
            if os.time() - BeginTime > 9 then
               -- ������������� ��������� �������� ������� � ������� �� �������
               return KillPos(Type);
            end;
            sleep(1);
         end;
      end;
      ]]
   end;
    
   -- ���������� �������� ��������� ���������� �� ������� ����� (�� ���������: ���������)
   function SlowMA(Index)
      -- ���� ������ ����� �� ������, �� ������������� ������ ��������� �����
      if Index == nil then Index = DS:Size(); end;
      -- ����� �������� SLOW_MA_SOURCE �� SLOW_MA_PERIOD ������
      local Sum = 0;
      -- ���������� ��������� SLOW_MA_PERIOD ������
      for i=Index, Index - (SLOW_MA_PERIOD - 1), -1 do      
         -- ������� �����, ������ �� ���������� ��������� ��� ��������� ����������
         if SLOW_MA_SOURCE == 'O' then
            Sum = Sum + DS:O(i);
         elseif SLOW_MA_SOURCE == 'C' then
            Sum = Sum + DS:C(i);
         elseif SLOW_MA_SOURCE == 'H' then
            Sum = Sum + DS:H(i);
         elseif SLOW_MA_SOURCE == 'L' then
            Sum = Sum + DS:L(i);
         else
            message('������� MA-�����:������! �� ����� ������ �������� ��� ��������� ����������!');
            -- ������������� ������
            OnStop();
         end;
      end;
      -- ���������� ��������
      return Sum/SLOW_MA_PERIOD;
   end;
   -- ���������� �������� ������� ���������� �� ������� ����� (�� ���������: ���������)
   function FastMA(Index)
      -- ���� ������ ����� �� ������, �� ������������� ������ ��������� �����
      if Index == nil then Index = DS:Size(); end;
      -- ����� �������� FAST_MA_SOURCE �� FAST_MA_PERIOD ������
      local Sum = 0;
      -- ���������� ��������� FAST_MA_PERIOD ������
      for i=Index, Index - (FAST_MA_PERIOD - 1), -1 do
         -- ������� �����, ������ �� ���������� ��������� ��� ������� ����������
         if FAST_MA_SOURCE == 'O' then
            Sum = Sum + DS:O(i);
         elseif FAST_MA_SOURCE == 'C' then
            Sum = Sum + DS:C(i);
         elseif FAST_MA_SOURCE == 'H' then
            Sum = Sum + DS:H(i);
         elseif FAST_MA_SOURCE == 'L' then
            Sum = Sum + DS:L(i);
         else
        --    message('������� MA-�����:������! �� ����� ������ �������� ��� ������� ����������!');
            -- ������������� ������
            OnStop();
         end;
      end;
      -- ���������� ��������
      return Sum/FAST_MA_PERIOD;
   end;
    
   -- ������� ���������� �������� ���� (����� 0, ��� 1) ��� ������� bit (���������� � 0) � ����� flags, ���� ������ ���� ���, ���������� nil
   function CheckBit(flags, bit)
      -- ���������, ��� ���������� ��������� �������� �������
      if type(flags) ~= "number" then error("��������������!!! Checkbit: 1-� �������� �� �����!"); end;
      if type(bit) ~= "number" then error("��������������!!! Checkbit: 2-� �������� �� �����!"); end;
      local RevBitsStr  = ""; -- ������������ (����� �������) ��������� ������������� ��������� ������������� ����������� ����������� ����� (flags)
      local Fmod = 0; -- ������� �� �������
      local Go = true; -- ���� ������ �����
      while Go do
         Fmod = math.fmod(flags, 2); -- ������� �� �������
         flags = math.floor(flags/2); -- ��������� ��� ��������� �������� ����� ������ ����� ����� �� �������
         RevBitsStr = RevBitsStr ..tostring(Fmod); -- ��������� ������ ������� �� �������
         if flags == 0 then Go = false; end; -- ���� ��� ��������� ���, ��������� ����
      end;
      -- ���������� �������� ����
      local Result = RevBitsStr :sub(bit+1,bit+1);
      if Result == "0" then return 0;
      elseif Result == "1" then return 1;
      else return nil;
      end;
   end;
   
   
   
   
   
   --- ������� ���������� ���������� QUIK ��� ��������� ������������ ������.
   function OnAllTrade(alltrade)
 --  message('���� ������ �� ������� �����������');
    
      -- ���� ������ �� ������� �����������
      if alltrade.sec_code == SEC_CODE then
         -- ���� �������� ����� ������, ������������ ����� ���������� ���� � ���������� TRUE, ����� FALSE
         if CheckNewMin(alltrade.datetime) then 
            -- ���������/�������� ������ ������� ��� ��������� ������ ��������� ����, ������������ �������� � ������� ����� �������   
            AddNewBarToArray5Min()
            -- ���� ������ �� �������, �������� ����� �� �������� 
            if bit.test(alltrade.flags, 0) then
               -- ������������� � ������������ ������ ����� �������� � ���������� �� � ��������������� ����
               SetBalance(Array5Min[#Array5Min] - alltrade.qty, 4)
            else -- ���� ������ �� �������, ���������� ����� � ��������
               -- ������������� � ������������ ������ ����� �������� � ���������� �� � ��������������� ����
               SetBalance(Array5Min[#Array5Min] + alltrade.qty, 4)
            end
         else -- ������ � ������� ������
            -- ���� ������ �� �������, �������� ����� �� �������� 
            if bit.test(alltrade.flags, 0) then
               -- ������������� � ������������ ������ ����� �������� � ���������� �� � ��������������� ����
               SetBalance(Array5Min[#Array5Min] - alltrade.qty, 4)
            else -- ���� ������ �� �������, ���������� ����� � ��������
               -- ������������� � ������������ ������ ����� �������� � ���������� �� � ��������������� ����
               SetBalance(Array5Min[#Array5Min] + alltrade.qty, 4)
            end
         end      
      end
   end