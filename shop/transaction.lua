-- scriptTest.lua (in your scripts directory)
local M = {}
 
 
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

local function send(typeMarket, price, quantity , type, trans_id_buy )
	
	local operation = "S" 
	  if typeMarket == "BUY" then
		operation = "B" 
	  end

	  local trans_id = random_max();

	  --https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/

	  -- http://luaq.ru/sendTransaction.html
	local Transaction={} 
	
		Transaction.CLASSCODE  = setting.CLASS_CODE;
		Transaction.SECCODE    = setting.SEC_CODE;
		Transaction.ACCOUNT    = setting.ACCOUNT;
		Transaction.USE_CASE_SENSITIVE_CONSTANTS = 'PROGRAM';
		Transaction.TYPE  = 'L';
 
		Transaction.trans_id   = tostring(trans_id);
		Transaction.ACTION    = 'NEW_ORDER'; 
		Transaction.OPERATION  = operation; -- ???????? ("B" - buy, ??? "S" - sell)
	 
		Transaction.QUANTITY   = tostring(quantity); -- ?????????? 
		Transaction.PRICE      = tostring(price);
		Transaction.CLIENT_CODE= setting.comment_quik;
		Transaction.EXPIRY_DATE = "TODAY";
	-- Transaction.COMMENT"]    = "??????"

	

	 --	 if type == "TAKE_PROFIT_AND_STOP_LIMIT_ORDER" then 
	 if type == "TAKE_PROFIT_STOP_ORDER" then 

		
		Transaction.STOP_ORDER_KIND = type;
		Transaction.ACTION = "NEW_STOP_ORDER"; 
		Transaction.OFFSET_UNITS  = "PRICE_UNITS";
		Transaction.STOPPRICE    = tostring(price);
		Transaction.STOPPRICE2 = tostring(price);
		Transaction.OFFSET = tostring(setting.take_profit_offset); 
		Transaction.KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO"; 
		Transaction.USE_BASE_ORDER_BALANCE ="NO";
		Transaction.ACTIVATE_IF_BASE_ORDER_PARTLY_FILLED = "YES";
		Transaction.BASE_ORDER_KEY = tostring(trans_id_buy);
  		Transaction.SPREAD  = tostring(setting.take_profit_spread);
		Transaction.SPREAD_UNITS  = "PRICE_UNITS";
	
		 
		loger.save( 'Transaction.STOP_ORDER_KIND ' .. Transaction.STOP_ORDER_KIND);
		loger.save( 'Transaction.BASE_ORDER_KEY ' ..Transaction.BASE_ORDER_KEY);


	elseif type == "SIMPLE_STOP_ORDER" then
		
		local direction  = tostring(4);
	   Transaction.ACTION = "NEW_STOP_ORDER";
	   Transaction.CONDITION = direction;
	   Transaction.STOPPRICE = tostring(price);
	   Transaction.STOP_ORDER_KIND = type;

	elseif type == "NEW_ORDER" then
				 
		Transaction.PRICE      = tostring(price); 
	 end;

	  local res  =  sendTransaction(Transaction);   
	  message('res 3 '.. tostring(res));
	  

	if res ~= "" then	
		message("res 2 "..res);
		loger.save( 'Transaction  ' .. res )
	  return nil, res
	   

	else   
		return trans_id ;
	end

end

 
function delete(transId_del_order,stopOrder_num, type)

	local Transaction={} 

 
	Transaction.ACTION    		= "KILL_STOP_ORDER";

	if type  ==  "TAKE_PROFIT_STOP_ORDER" or type  ==  "KILL_STOP_ORDER"  then  
		Transaction.ACTION  = "KILL_STOP_ORDER";
	
	elseif type == 'NEW_ORDER' then
		Transaction.ACTION = "KILL_ORDER";
	else
		Transaction.ACTION = "KILL_ORDER";
	
	
	end




	Transaction.CLASSCODE  		= setting.CLASS_CODE;
	Transaction.SECCODE    		= setting.SEC_CODE;
	Transaction.ACCOUNT   		= setting.ACCOUNT; 
	Transaction.CLIENT_CODE		= setting.comment_quik;
	Transaction.TRANS_ID  		= tostring(transId_del_order);
	Transaction.STOP_ORDER_KEY  = tostring(stopOrder_num);
	Transaction.ORDER_KEY  		= tostring(stopOrder_num);
	Transaction.TYPE = "L";

	loger.save("Transaction delete delete delete delete "..tostring(transId_del_order))
	loger.save("Transaction.ACTION "..tostring(Transaction.ACTION))
	loger.save("Transaction  transId_del_order "..tostring( transId_del_order))
	loger.save("Transaction  stopOrder_num "..tostring( stopOrder_num))
	loger.save("Transaction  type "..tostring( type))

	local res = sendTransaction(Transaction)
	if string.len(res) ~= 0 then
		--message('Error: '..res, 3)
		loger.save("Delete: fail "..tostring(res))
	else
		loger.save("Delete: "..tostring(stopOrder_num).." success ")
	end 
end;



function random_max()
 
	local res = (16807*(RANDOM_SEED or 137137))%2147483647
	RANDOM_SEED = res
	return res
end


M.delete = delete
M.send = send
 
return M