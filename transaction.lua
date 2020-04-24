-- scriptTest.lua (in your scripts directory)
local M = {}
 
 
local loger = dofile(getScriptPath() .. "\\loger.lua")

local function send(typeMarket, price, quantity )

	-- local ACCOUNT        = '4105F8Y';  
	-- local CLASS_CODE     = "SPBFUT"; 
	-- local SEC_CODE       = "BRK0";


	local operation = "S" 
	  if typeMarket == "BUY" then
		operation = "B" 
	  end

	  local trans_id = random_max();

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
		['CLIENT_CODE']= '12робот',
	--	["COMMENT"]    = "скрипт"
	 }
   -- Отправляет транзакцию на установку ТЭЙК-ПРОФИТ и СТОП-ЛОСС


   loger.save( 'Transaction ' .. Transaction.OPERATION .. ' tostring(price) ' ..'  ' .. tostring(price).. ' ' .. ' '.. Transaction.TRANS_ID );
   loger.save( 'SEC_CODE ' .. SEC_CODE );
   loger.save( 'Transaction SECCODE ' .. Transaction['SECCODE'] );
   loger.save( 'Transaction CLASS_CODE ' .. Transaction.CLASSCODE  );
   loger.save( 'Transaction ACCOUNT ' .. Transaction.ACCOUNT );
   


	  local res  =   sendTransaction(Transaction);   
	  
	  

	  if res ~= "" then	
		message(res);
		
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