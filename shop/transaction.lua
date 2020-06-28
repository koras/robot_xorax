-- scriptTest.lua (in your scripts directory)
local M = {}
 
 
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

local function send(typeMarket, price, quantity,type, trans_id_buy )
	
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

		Transaction.TRANS_ID   = tostring(trans_id);
		Transaction.ACTION    = 'NEW_ORDER'; 
		Transaction.OPERATION  = operation; -- операция ("B" - buy, или "S" - sell)
	 
		Transaction.QUANTITY   = tostring(quantity); -- количество 
		Transaction.PRICE      = tostring(price);
		Transaction.CLIENT_CODE= 'Robot XoraX';
		Transaction.EXPIRY_DATE = "TODAY";
	-- Transaction.COMMENT"]    = "скрипт"
	  
	  

-- 	 Transaction  res  Не указаны единицы измерения защитного интервала take profit стоп-заявки.
--   Не указан номер базовой заявки.
--   Не указан признак использования остатка базовой заявки.
--   Не указан признак активирования стоп-заявки при частичном исполнении базовой заявки.


	 --	 if type == "TAKE_PROFIT_AND_STOP_LIMIT_ORDER" then 
	 if type == "TAKE_PROFIT_STOP_ORDER" then 
		-- Не указан номер базовой заявки.
		-- Не указан признак использования остатка базовой заявки.
		-- Не указан признак активирования стоп-заявки при частичном исполнении базовой заявки.
		-- Параметр "IS_ACTIVE_IN_TIME" для транзакции "Стоп-заявка" типа "ACTIVATED_BY_ORDER_TAKE_PROFIT_STOP_ORDER" не поддерживается.

		Transaction.STOP_ORDER_KIND = type;
		Transaction.ACTION = "NEW_STOP_ORDER"; 
		Transaction.OFFSET_UNITS  = "PRICE_UNITS";
		Transaction.STOPPRICE    = tostring(price);
		Transaction.STOPPRICE2 = tostring(price);
		 
		 
		-- "OFFSET" - (ОТСТУП)Если цена достигла Тэйк-профита и идет дальше в прибыль,
		-- то Тэйк-профит сработает только когда цена вернется минимум на 2 шага цены назад,
		-- это может потенциально увеличить прибыль
		Transaction.OFFSET = tostring(setting.take_profit_offset); 
		Transaction.KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO"; 
	--	Transaction.IS_ACTIVE_IN_TIME = "NO"; 
		Transaction.USE_BASE_ORDER_BALANCE ="NO";
		Transaction.ACTIVATE_IF_BASE_ORDER_PARTLY_FILLED = "YES";
		Transaction.BASE_ORDER_KEY = tostring(trans_id_buy);
		-- "SPREAD" - Когда сработает Тэйк-профит, выставится заявка по цене хуже текущей 
      -- которая АВТОМАТИЧЕСКИ УДОВЛЕТВОРИТСЯ ПО ТЕКУЩЕЙ ЛУЧШЕЙ ЦЕНЕ,
      -- но то, что цена значительно хуже, спасет от проскальзывания,
      -- иначе, сделка может просто не закрыться (заявка на закрытие будет выставлена, но цена к тому времени ее уже проскочит)
		Transaction.SPREAD  = tostring(setting.take_profit_spread);
		Transaction.SPREAD_UNITS  = "PRICE_UNITS";
	
		 
		loger.save( 'Transaction.STOP_ORDER_KIND ' .. Transaction.STOP_ORDER_KIND);
		loger.save( 'Transaction.BASE_ORDER_KEY ' ..Transaction.BASE_ORDER_KEY);


	 elseif type == "SIMPLE_STOP_ORDER" then
		
		 -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно
		local direction  = tostring(4);
		Transaction.ACTION = "NEW_STOP_ORDER";
		Transaction.CONDITION = direction;
		Transaction.STOPPRICE = tostring(price);
		Transaction.STOP_ORDER_KIND = type;

	--	signalShowLog.addSignal(setting.datetime, 35 , false, tostring(price));

	 end;

	-- Неверно указаны единицы измерения защитного интервала take profit стоп-заявки. "0.01"

 


	  local res  =   sendTransaction(Transaction);   
	  
	  

	if res ~= "" then	
		message(res);
		loger.save( 'Transaction  ' .. res )
	  return nil, res
	   

	else   
		return trans_id ;
	end

end


-- здесь снимаются заявки
function delete(transId_del_order,stopOrder_num)

	local Transaction={} 
	
	Transaction.CLASSCODE  		= setting.CLASS_CODE;
	Transaction.SECCODE    		= setting.SEC_CODE;
	Transaction.ACCOUNT   		= setting.ACCOUNT;
	Transaction.ACTION    		= "KILL_STOP_ORDER";
	Transaction.CLIENT_CODE		= 'Robot XoraX';
	Transaction.TRANS_ID  		= transId_del_order;
	Transaction.STOP_ORDER_KEY  = tostring(stopOrder_num);
	Transaction.TYPE = "L";


	local res = sendTransaction(Transaction)
	if string.len(res) ~= 0 then
		--message('Error: '..res, 3)
		loger.save("DeleteStopOrder(): fail "..res)
	else
		loger.save("DeleteStopOrder(): "..stopOrder_num.." success ")
	end 
end;



function random_max()
	-- не принимает параметры и возвращает от 0 до 2147483647 (макс. полож. 32 битное число) подходит нам для транзакций
	local res = (16807*(RANDOM_SEED or 137137))%2147483647
	RANDOM_SEED = res
	return res
end


M.delete = delete
M.send = send
 
return M