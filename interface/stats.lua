-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}
  
local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");


init.create = false;



  



  
local word = {
	['title'] = "title",
	['info'] = "info",    
	['LIMIT_BID'] = "LIMIT_BID", 
	['ACCOUNT'] = "ACCOUNT", 
	['SEC_CODE'] = "SEC_CODE", 
	['CLASS_CODE'] = "CLASS_CODE", 
	['emulation'] = "emulation",   
	['profit_range'] = "profit_range", 
	['profit'] = "prifit:",   
	['count_buy'] = "count buy:",   
	['count_sell'] = "count sell:",   
	['Trading_Bot_stat_Panel'] = "Trading Bot statistics",
	['tag'] = "Tag table",

	['last_buy_price'] = "Last buy price",
	['last_sell_price'] = "Last sell price",

	['use_contract'] = 'use contract:',

	
	['old_number_of_candles'] = "old number of candles",
	['number_of_candles'] = "number of candle",-- на какой свече была последняя покупка
	['candles_buy_last'] = "candles buy last",
	['range_down_price_candles'] = "range down price candle",
	['candle_buy_number_down_price'] = "candle buy number down price",  -- сколько свечей должно пройти чтобы отпустить продажу 


	['timeWork'] = "    time work:",  -- сколько свечей должно пройти чтобы отпустить продажу 
 


	
	['fractal_up'] = 'fractal up',
	['fractal_down'] = 'fractal down',

	['fractal_candle'] = 'fractal_candle', -- сколько считать за уровень

	['fractal_down_range'] = 'fractal_down_range', -- если цена ниже, значит здесб был уровень, а под уровнем не покупаем.
	['fractal_under_up'] = 'fractal_under_up', -- под вверхом не покупаем, можем пробить а цена не пойдёт в нашу сторону 
   
	['timeWork'] =  {
	   { '10:00', '14:00'},
	   { '14:05', '18:45'}, 
	   { '19:00', '23:50'}
	},   
	
	['closed_buy'] =  {
	   { '13:00', '14:00'},
	   { '18:00', '19:02'}, 
	   { '22:55', '23:55'}
	},

};
 
 
 
local function show()  
	CreateNewTableStats(); 
	stats()  
end
  
 
  function stats()    
	--  return; 
  
	  
	 SetCell(t_stat, 2, 1,  tostring(setting.LIMIT_BID));   
	 SetCell(t_stat, 3, 1,  tostring(setting.ACCOUNT));   
	 SetCell(t_stat, 4, 1,  tostring(setting.SEC_CODE));  
	 SetCell(t_stat, 5, 1,  tostring(setting.CLASS_CODE));
	 SetCell(t_stat, 6, 1,  tostring(setting.tag));

	 SetCell(t_stat, 10, 1,  tostring(setting.profit));   
 


	SetCell(t_stat, 11, 1,  tostring(setting.count_buy)..'/'..tostring(setting.count_contract_buy)..'/'..tostring(setting.emulation_count_contract_buy).."(e)");  
	SetCell(t_stat, 12, 1,  tostring(setting.count_sell)..'/'..tostring(setting.count_contract_sell)..'/'..tostring(setting.emulation_count_contract_sell).."(e)");  
	SetCell(t_stat, 13, 1,  tostring(setting.use_contract));  


	SetCell(t_stat, 14, 1,  tostring(setting.SPRED_LONG_TREND_DOWN_LAST_PRICE));  
	SetCell(t_stat, 15, 1,  tostring(setting.SPRED_LONG_LOST_SELL));  
	

	SetCell(t_stat, 21, 1, tostring(setting.candles_operation_last)); 

	SetCell(t_stat, 22, 1, tostring(setting.number_of_candle)); 
	SetCell(t_stat, 23, 1, tostring(setting.old_number_of_candle)); 
	SetCell(t_stat, 24, 1, tostring(setting.candle_buy_number_down_price)); 

  	
	SetCell(t_stat, 26, 1, tostring(setting.fractal_up));
	SetCell(t_stat, 27, 1, tostring(setting.fractal_down));
	SetCell(t_stat, 28, 1, tostring(setting.fractal_candle));
	SetCell(t_stat, 29, 1, tostring(setting.fractal_down_range));
	SetCell(t_stat, 30, 1, tostring(setting.fractal_under_up));

	
	SetCell(t_stat, 32, 1, tostring(   setting.number_of_candle));
	SetCell(t_stat, 33, 1, tostring(   setting.candle_current_high));
	SetCell(t_stat, 34, 1, tostring(   setting.candle_current_low));




 

end;

--- simple create a table
function CreateNewTableStats() 
if createTable  then return; end;

init.create = true; 
	t_stat = AllocTable();	 


	AddColumn(t_stat, 0, word.title , true, QTABLE_STRING_TYPE, 35);
	AddColumn(t_stat, 1, word.info, true, QTABLE_STRING_TYPE, 40);
--	AddColumn(t_stat, 2, word.sell, true, QTABLE_STRING_TYPE, 40);  
 
 

	t = CreateWindow(t_stat); 
	SetWindowCaption(t_stat, word.Trading_Bot_stat_Panel);  
	SetWindowPos(tt, 0, 70, 22, 140);
	
	for i = 1, 40 do
		InsertRow(t_stat, -1);
	 end; 


	 for i = 0, 3 do
		Blue(t_stat,1, i);
		--Gray(t_stat,3, i);
	--	Gray(t_stat,5, i);
	--	Gray(t_stat,7, i);
		Blue(t_stat,9, i); 
	--	Gray(t_stat,11, i); 
	--	Gray(t_stat,13, i); 
	--	Gray(t_stat,15, i); 
	--	Gray(t_stat,17, i); 
		Blue(t_stat,20, i); 
	 end; 
	 
	 for i = 10, 19 do
		Yellow(t_stat, i, 0);
		Yellow(t_stat, i, 1); 
	   end; 
	   for i = 2, 8 do
		   Gray(t_stat, i, 0);
		   Gray(t_stat, i, 1); 
		 end; 
		for i = 21, 30 do
			 Gray(t_stat, i, 0);
			 Gray(t_stat, i, 1); 
		end; 
	 
	  
	SetCell(t_stat, 2, 0,  tostring(word.LIMIT_BID));   
	SetCell(t_stat, 3, 0,  tostring(word.ACCOUNT));  
	SetCell(t_stat, 4, 0,  tostring(word.SEC_CODE));  
	SetCell(t_stat, 5, 0,  tostring(word.CLASS_CODE)); 
	SetCell(t_stat, 6, 0,  tostring(word.tag)); 
	   
	SetCell(t_stat, 10, 0,  tostring(word.profit));  
	SetCell(t_stat, 11, 0,  tostring(word.count_buy));  
	SetCell(t_stat, 12, 0,  tostring(word.count_sell));  
	SetCell(t_stat, 13, 0,  tostring(word.use_contract));  
	SetCell(t_stat, 14, 0,  tostring(word.last_buy_price));  
	SetCell(t_stat, 15, 0,  tostring(word.last_sell_price));  

	SetCell(t_stat, 21, 0, tostring(word.candles_buy_last));
	SetCell(t_stat, 22, 0, tostring(word.number_of_candles));
	SetCell(t_stat, 23, 0, tostring(word.range_down_price_candles));
	SetCell(t_stat, 24, 0, tostring(word.candle_buy_number_down_price));


	
	SetCell(t_stat, 26, 0, tostring(word.fractal_up));
	SetCell(t_stat, 27, 0, tostring(word.fractal_down));
	SetCell(t_stat, 28, 0, tostring(word.fractal_candle));
	SetCell(t_stat, 29, 0, tostring(word.fractal_down_range));
	SetCell(t_stat, 30, 0, tostring(word.fractal_under_up));
	-- ['fractal_up'] = 'fractal up',
	-- ['fractal_down'] = 'fractal down',

	-- ['fractal_candle'] = 'fractal_candle', -- сколько считать за уровень

	-- ['fractal_down_range'] = 'fractal_down_range', -- если цена ниже, значит здесб был уровень, а под уровнем не покупаем.
	-- ['fractal_under_up'] = 'fractal_under_up', -- под вверхом не покупаем, можем пробить а цена не пойдёт в нашу сторону 

 
	-- ['last_buy_price'] = "Last buy price",
	-- ['last_sell_price'] = "Last sell price",


end;

 

 function deleteTableStats(Line, Col)   
	DestroyTable(t_stat)
 end;

 
 M.deleteTableStats = deleteTableStats;
 M.stats =  stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M