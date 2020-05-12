-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}
  
local loger = dofile(getScriptPath() .. "\\interface\\color.lua")
local loger = dofile(getScriptPath() .. "\\loger.lua")


init.create = false;

local word = {
	['status'] = "Status",
	['buy'] = "Buy",
	['sell'] = "Sell",
--	['close_positions'] = "�lose positions",
	
	['start'] = "      START",
	['finish'] = "      STOP",
	['pause'] = "      PAUSE",
	['pause2'] = "           PAUSE",


	['emulation'] = "           Emulation",

	['on'] = "              ON      ",
	['off'] = "              OFF     ",
	['Trading_Bot_Control_Panel'] = "Trading Bot Control Panel",

	
	['open_position'] = "      Positions:",
	['open_limit'] = "             limit:",
	['profit'] = "             profit:",
	['count_sell'] = "        count sell:",
	['count_buy'] = "        count buy:",
	['SPRED'] = " minimal profit:",

	['SPRED_LONG_TREND_DOWN_LAST_PRICE'] = "         last buy:",

	
	['SPRED_LONG_LOST_SELL'] = "          last sell:",



	['candles_buy_last'] = "      candles buy last:",
	['number_of_candles'] = "      number of candle:",-- на какой свече была последняя покупка
	['range_down_price_candles'] = "     range down price candle:",
	['candle_buy_number_down_price'] = "    candle buy number down price:",  -- сколько свечей должно пройти чтобы отпустить продажу 


	['timeWork'] = "    time work:",  -- сколько свечей должно пройти чтобы отпустить продажу 
 
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
 
 

local function stats()  
	 
	SetCell(t_information, 6, 1,  tostring(#bid)) 
	SetCell(t_information, 7, 1,  tostring(LIMIT_BID+1)) 
	SetCell(t_information, 8, 1,  tostring(profit).. ' point') 
	SetCell(t_information, 8, 2,  tostring(profit*7).. ' ruble') 

	SetCell(t_information, 10, 1,  tostring(count_sell)) 
	SetCell(t_information, 11, 1,  tostring(count_buy)) 

	SetCell(t_information, 13, 1,  tostring(SPRED_LONG_TREND_DOWN_LAST_PRICE)) 
	SetCell(t_information, 14, 1,  tostring(SPRED_LONG_LOST_SELL)) 
	SetCell(t_information, 17, 1,  tostring(SPRED))  
 

end

local function show()  
	CreateNewTable(); 
	for i = 1, 18 do
		InsertRow(t_information, -1);
	 end;


	SetCell(t_information, 1, 0,  '')
	SetCell(t_information, 1, 1, '')
	SetCell(t_information, 1, 2, '')
	SetCell(t_information, 2, 1, word.on) 
	SetCell(t_information, 2, 2, word.on) 
	SetCell(t_information, 2, 3, word.off) 
	SetCell(t_information, 3, 0,  '')
	SetCell(t_information, 3, 1, '')
	SetCell(t_information, 3, 2, '')
	SetCell(t_information, 4, 0,  '')
	SetCell(t_information, 4, 1, '')
	SetCell(t_information,4, 2, '') 
 

 
	SetCell(t_information, 6, 0, word.open_position);
	SetCell(t_information, 7, 0, word.open_limit);
	SetCell(t_information,, 8, 0, word.profit);
 

	SetCell(t_information, 10, 0, word.count_sell);
	SetCell(t_information, 11, 0, word.count_buy);

	SetCell(t_information, 13, 0,  word.SPRED_LONG_TREND_DOWN_LAST_PRICE);
	SetCell(t_information, 14, 0,  word.SPRED_LONG_LOST_SELL);

	SetCell(t_information, 17, 0, word.SPRED);

	  

	-- SetCell(t_information, 21, 0, word.candles_buy_last);
	-- SetCell(t_information, 22, 0, word.number_of_candles);
	-- SetCell(t_information, 23, 0, word.range_down_price_candles);
	-- SetCell(t_information, 24, 0, word.candle_buy_number_down_price);






	-- ['candles_buy_last'] = "      candles buy last:",
	-- ['number_of_candles'] = "      number of candle:",-- на какой свече была последняя покупка
	-- ['candles_buy_last'] = "      candles buy last:",
	-- ['range_down_price_candles'] = "     range down price candle:",
	-- ['candle_buy_number_down_price'] = "    candle buy number down price:",  -- сколько свечей должно пройти чтобы отпустить продажу 



end
 
 
 



--- ������� ������� �������
function CreateNewTable() 
if createTable  then return; end;

init.create = true;
	-- �������� ��������� id ��� ��������
	t_information = AllocTable();	 
	AddColumn(t_information, 0, word.status , true, QTABLE_STRING_TYPE, 15);
	AddColumn(t_information, 1, word.buy, true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_information, 2, word.sell, true, QTABLE_STRING_TYPE, 20); 
	AddColumn(t_information, 3, word.close_positions, true,QTABLE_STRING_TYPE, 40); 
 
	t = CreateWindow(t_information); 
	SetWindowCaption(t_information, word.Trading_Bot_Control_Panel);  
   SetWindowPos(t_information, 0, 70, 292, 140)
end;

 
 

 function deleteTable()  -- �������
	DestroyTable(t_information)
 end;

 

M.stats =  stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M