-- scriptTest.lua (in your scripts directory)
local M = {}
   
function wSignal(_event)
	arr = {
		[1] = 'There was a purchase in this range',  
		[2] = 'We sold at current price',  
		[3] = 'We do not buy where we bought before',  
		[4] = 'buy is off',  
		[5] = 'too high price',  
		[6] = 'mode emulation',  
		[7] = 'bye contract',  
		[8] = 'sell contract',  
		[9] = 'Set a order for to sale', 
		[10] = 'bye',  
		[11] = 'bye', 
		[12] = 'sell', 
		[13] = 'the current candle is less than the expected profit, low volatility', 
		[14] = 'the price of the candle is higher than the profit; buying at the top is impossible', 
		[15] = 'Error logging',   
		[16] = 'We do not have free purchase contracts, high limit',
		[17] = 'We sold a lot of contracts in a row, went into the sales limit',
	} 	
	
	
	arr = {
		[1] = 'В этом промежутке ранее была покупка',  
		[2] = 'Мы продали по текущей цене в этом промежутке',  
		[3] = 'Цена падает, поэтому покупка не возможна',  
		[4] = 'buy is off',  
		[5] = 'Очень большая цена',  
		[6] = 'Режим эмуляции',  
		[7] = 'Купили контракт',  
		[8] = 'Продали контракт',  
		[9] = 'Поставили заявку на продажу',  
		[10] = 'на продажу',  
		[11] = 'Мы покупали по текущей цене в этом промежутке', 
		[12] = 'У нас стоит заявка на продажу по текущей цене',   
		[13] = 'Текущая свеча меньше преполагаемого профита, низкая волатильность',  
		[14] = 'Цена на свече выше профита, покупка на верху невозможна',   
		[15] = 'Логирование ошибок',   
		[16] = 'У нас нет свободных контрактов на покупку, высокий лимит',   
		[17] = 'Мы продали много контрактов подряд, ушли в лимит продажи',   
	}
	 
	return arr[_event];
end;

 
 
M.wSignal = wSignal; 
return M