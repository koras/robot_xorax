-- scriptTest.lua (in your scripts directory)
local M = {}
 
 
local loger = dofile(getScriptPath() .. "\\loger.lua")

local function send(typeMarket, price, quantity,type )
	
	local operation = "S" 
	  if typeMarket == "BUY" then
		operation = "B" 
	  end

	  local trans_id = random_max();




	  --https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/

	  -- http://luaq.ru/sendTransaction.html
	local Transaction={
		['TRANS_ID']   = tostring(trans_id),
		['ACTION']     = 'NEW_ORDER',
		['CLASSCODE']  = setting.CLASS_CODE,
		['SECCODE']    = setting.SEC_CODE,
		['ACCOUNT']    = setting.ACCOUNT,
		['USE_CASE_SENSITIVE_CONSTANTS'] = 'PROGRAM',
		['OPERATION']  = operation, -- операция ("B" - buy, или "S" - sell)
		['TYPE']       = 'L', -- по рынку (MARKET)
		['QUANTITY']   = tostring(quantity), -- количество 
		['PRICE']      = tostring(price),
		['CLIENT_CODE']= 'Robot XoraX',
		["EXPIRY_DATE"] = "TODAY",
	--	["COMMENT"]    = "скрипт"
	 } 

	 if type == "TAKE_PROFIT_AND_STOP_LIMIT_ORDER" then 

		Transaction['ACTION'] = "NEW_STOP_ORDER";
		Transaction['OFFSET_UNITS']  = "PRICE_UNITS";
		Transaction['STOPPRICE']     = tostring(price);
		-- "OFFSET" - (ОТСТУП)Если цена достигла Тэйк-профита и идет дальше в прибыль,
		-- то Тэйк-профит сработает только когда цена вернется минимум на 2 шага цены назад,
		-- это может потенциально увеличить прибыль
		Transaction["OFFSET"] = tostring(setting.take_profit_offset); 
	--	Transaction["OFFSET"] = 0,01; 

		-- "SPREAD" - Когда сработает Тэйк-профит, выставится заявка по цене хуже текущей 
      -- которая АВТОМАТИЧЕСКИ УДОВЛЕТВОРИТСЯ ПО ТЕКУЩЕЙ ЛУЧШЕЙ ЦЕНЕ,
      -- но то, что цена значительно хуже, спасет от проскальзывания,
      -- иначе, сделка может просто не закрыться (заявка на закрытие будет выставлена, но цена к тому времени ее уже проскочит)
		Transaction["SPREAD"]  = tostring(setting.take_profit_spread);

	 end;

	-- Неверно указаны единицы измерения защитного интервала take profit стоп-заявки. "0.01"

--    loger.save(' setting.CLASS_CODE '..setting.CLASS_CODE);
--    loger.save(' setting.SEC_CODE '..setting.SEC_CODE);
--    loger.save(' setting.ACCOUNT '..setting.ACCOUNT);
   
  -- loger.save( 'Transaction ' .. Transaction.OPERATION .. ' tostring(price) ' ..'  ' .. tostring(price).. ' ' .. ' '.. Transaction.TRANS_ID );
  -- loger.save( 'SEC_CODE ' .. setting.SEC_CODE );
--    loger.save( 'Transaction SECCODE ' .. Transaction['SECCODE'] );
--    loger.save( 'Transaction CLASS_CODE ' .. Transaction.CLASSCODE  );
--    loger.save( 'Transaction ACCOUNT ' .. Transaction.ACCOUNT );
   


	  local res  =   sendTransaction(Transaction);   
	  
	  

	  if res ~= "" then	
		message(res);
	--  Неверно указаны единицы измерения защитного интервала take profit стоп-заявки. "0.01"
		-- loger.save(' setting.CLASS_CODE '..setting.CLASS_CODE);
		-- loger.save(' setting.SEC_CODE '..setting.SEC_CODE);
		-- loger.save(' setting.ACCOUNT '..setting.ACCOUNT);

		loger.save( 'Transaction  res ' .. res )
	  return nil, res
	   

	else   
		return trans_id ;
	end

end


function random_max()
	-- не принимает параметры и возвращает от 0 до 2147483647 (макс. полож. 32 битное число) подходит нам для транзакций
	local res = (16807*(RANDOM_SEED or 137137))%2147483647
	RANDOM_SEED = res
	return res
end


M.send = send
 
return M