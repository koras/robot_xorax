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
		[2] = 'Продали по текущей цене в этом промежутке',  
		[3] = 'Цена падает, покупка не возможна',  
		[4] = 'buy is off',  
		[5] = 'Очень большая цена',  
		[6] = 'Режим эмуляции',  
		[7] = 'Купили контракт',  
		[8] = 'Продали контракт',  
		[9] = 'Поставили заявку на продажу',  
		[10] = 'на продажу',  
		[11] = 'Заявка на продажу(покупка) была не исполнена', 
		[12] = 'У нас стоит заявка на продажу по текущей цене',   
		[13] = 'Текущая свеча меньше преполагаемого профита, низкая волатильность',  
		[14] = 'Цена на свече выше профита, покупка на верху невозможна',   
		[15] = 'Логирование ошибок',   
		[16] = 'Нет свободных контрактов на покупку, надо продать старые',   
		[17] = 'Мы продали много контрактов подряд, ушли в лимит продажи',   
	}
	 
	return arr[_event];
end;

    
function word(key)
 
	
	arr = {
		['not_found_tag'] = "В своиство графика необходимо добавить \"" .. setting.tag .."\".  Откройте график и в области Price перейдите в вкладку дополнительно, в самом низу есть поле 'Идентификатор', туда и добавьте " .. setting.tag ..". После нажмите Применить и перезапустите робота" ,  
	}
	 
	return arr[key];
end;
 
M.word = word; 
M.wSignal = wSignal; 
return M