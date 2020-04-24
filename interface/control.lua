-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}
  
local loger = dofile(getScriptPath() .. "\\loger.lua")


init.create = false;

local word = {
	['status'] = "Status",
	['buy'] = "Buy",
	['sell'] = "Sell",
	['close_positions'] = "�lose positions",
	
	['start'] = "      START",
	['finish'] = "      STOP",
	['pause'] = "      PAUSE",
	['pause2'] = "           PAUSE",

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
 
};
 
 

local function stats()  
	 
	SetCell(t_id, 6, 1,  tostring(#bid)) 
	SetCell(t_id, 7, 1,  tostring(LIMIT_BID+1)) 
	SetCell(t_id, 8, 1,  tostring(profit).. ' point') 
	SetCell(t_id, 8, 2,  tostring(profit*7).. ' ruble') 

	SetCell(t_id, 10, 1,  tostring(count_sell)) 
	SetCell(t_id, 11, 1,  tostring(count_buy)) 

	SetCell(t_id, 13, 1,  tostring(SPRED_LONG_TREND_DOWN_LAST_PRICE)) 
	SetCell(t_id, 14, 1,  tostring(SPRED_LONG_LOST_SELL)) 
	SetCell(t_id, 17, 1,  tostring(SPRED))  
 

	-- SPRED_LONG_TREND_DOWN_LAST_PRICE= 0; -- ��������� �������
  
	-- SPRED_LONG_PRICE_DOWN = 0.04; -- �� �������� ���� �� ������� �� ������� ����, ����
	-- SPRED_LONG_PRICE_UP = 0.04; -- �� �������� ���� �� ������� �� ������� ����, �����. ���� �� ���� � ����� ���
	-- SPRED_LONG_LOST_SELL = 0; -- ��������� ���� ������ �� ������� ����������
end

local function show()  
	CreateNewTable(); 
	for i = 1, 18 do
		InsertRow(t_id, -1);
	 end;


	SetCell(t_id, 1, 0,  '')
	SetCell(t_id, 1, 1, '')
	SetCell(t_id, 1, 2, '')
	SetCell(t_id, 2, 1,  word.on) 
	SetCell(t_id, 2, 2, word.on) 
	SetCell(t_id, 2, 3, word.off) 
	SetCell(t_id, 3, 0,  '')
	SetCell(t_id, 3, 1, '')
	SetCell(t_id, 3, 2, '')
	SetCell(t_id, 4, 0,  '')
	SetCell(t_id, 4, 1, '')
	SetCell(t_id, 4, 2, '') 
	button_finish();
	buy_process();
	sell_process();
	close_positions_finish();


	Yellow(5, 0) 
	Yellow(5, 1) 
	Yellow(5, 2) 
	Yellow(5, 3) 
	SetCell(t_id, 6, 0, word.open_position);
	SetCell(t_id, 7, 0, word.open_limit);
	SetCell(t_id, 8, 0, word.profit);
	Green(8, 1) 
	Green(8, 0) 
	Green(8, 2)  

	SetCell(t_id, 10, 0, word.count_sell);
	SetCell(t_id, 11, 0, word.count_buy);

	SetCell(t_id, 13, 0,  word.SPRED_LONG_TREND_DOWN_LAST_PRICE);
	SetCell(t_id, 14, 0,  word.SPRED_LONG_LOST_SELL);

	SetCell(t_id, 17, 0, word.SPRED);

	  
end
 

function button_start()
	setting.status=true;
	SetCell(t_id, 2, 0,  word.finish)
	SetCell(t_id, 3, 1,  '')
	SetCell(t_id, 3, 2,  '')
	SetCell(t_id, 3, 3,  '')
	Green(1, 0) 
	Green(2, 0) 
	Green(3, 0)
	loger.save('button_start');
end;
function button_finish() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.start)
	Gray(1, 0);
	Gray(2, 0);
	Gray(3, 0);
	loger.save('button_finish' );
end;

function button_pause() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.pause)
	SetCell(t_id, 3, 1,  word.pause2)
	SetCell(t_id, 3, 2,  word.pause2)
	SetCell(t_id, 3, 3,  word.pause2)
	Red(1, 0);
	Red(2, 0);
	Red(3, 0);
	loger.save('button_finish' );
end;


 

function close_positions_start() 
	setting.close_positions=true;
	SetCell(t_id, 2, 3,  word.on)
	Green(1, 3) 
	Green(2, 3) 
	Green(3, 3)
	loger.save('close_positions _start');
end;

function close_positions_finish()
	setting.close_positions=false;  
	SetCell(t_id, 2, 3,  word.off)
	Gray(1, 3);
	Gray(2, 3);
	Gray(3, 3);
	loger.save('close_positions _finish' );
end;





function sell_process()
	setting.sell = true;
	SetCell(t_id, 2, 2,  word.on)
	Green(1, 2) 
	Green(2, 2) 
	Green(3, 2)
	loger.save('sell start');
end;
function sell_stop()  
	setting.sell = false;  
	SetCell(t_id, 2, 2,  word.off)
	Red(1, 2);
	Red(2, 2);
	Red(3, 2);
	loger.save('sell _finish' );
end;


function buy_process()
	setting.buy = true;
	SetCell(t_id, 2, 1,  word.on)
	Green(1, 1) 
	Green(2, 1) 
	Green(3, 1)
	loger.save('buy_start');
end;
function buy_stop()  
	setting.buy = false;  
	SetCell(t_id, 2, 1,  word.off)
	Red(1, 1);
	Red(2, 1);
	Red(3,1);
	loger.save('buy_finish' );
end;
 



--- ������� ������� �������
function CreateNewTable() 
if createTable  then return; end;

init.create = true;
	-- �������� ��������� id ��� ��������
	t_id = AllocTable();	 
	AddColumn(t_id, 0, word.status , true, QTABLE_STRING_TYPE, 15);
	AddColumn(t_id, 1, word.buy, true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_id, 2, word.sell, true, QTABLE_STRING_TYPE, 20); 
	AddColumn(t_id, 3, word.close_positions, true,QTABLE_STRING_TYPE, 20); 
	-- �������
	t = CreateWindow(t_id); 
	SetWindowCaption(t_id, word.Trading_Bot_Control_Panel); 
   SetTableNotificationCallback(t_id, event_callback_message);  
   SetWindowPos(tt, 0, 70, 292, 140)
end;


function event_callback_message (t_id, msg, par1, par2)

	if par1 == 1 and par2 == 0 or  par1 == 2 and par2 == 0 or par1 == 3 and par2 == 0 then
		if  msg == 1 and setting.status == false then
				button_start(); 
				return;
		end;

		if  msg == 1 and setting.status == true then
			--button_finish();
			button_pause();
			return;
		end;
	end;

	    
	if par1 == 1 and par2 == 1 or  par1 == 2 and par2 == 1 or par1 == 3 and par2 == 1 then
		if  msg == 1 and setting.buy == false then
				buy_process(); 
				return;
		end;

		if  msg == 1 and setting.buy == true then
				buy_stop();
			return;
		end;
	end;




	if par1 == 1 and par2 == 2 or  par1 == 2 and par2 == 2 or par1 == 3 and par2 == 2 then
		if  msg == 1 and setting.sell == false then
				sell_process(); 
				return;
		end;

		if  msg == 1 and setting.sell == true then
				sell_stop();
			return;
		end;
	end;


	if par1 == 1 and par2 == 3 or  par1 == 2 and par2 == 3 or par1 == 3 and par2 == 3 then
		if  msg == 1 and setting.close_positions == false then
				close_positions_start(); 
				buy_stop();
				return;
		end;

		if  msg == 1 and setting.close_positions == true then
			close_positions_finish(); 
			return;
		end;
	end;

  
	loger.save(msg ..'  '  .. par1 .. '   '.. par2..' QTABLE_LBUTTONUP '.. QTABLE_LBUTTONUP);
end;

function Red(Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(t_id, Line, Col, RGB(255,168,164), RGB(0,0,0), RGB(255,168,164), RGB(0,0,0));
 end;
 function Gray(Line, Col)  
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(t_id, Line, Col, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
 end;
 function Green(Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(t_id, Line, Col, RGB(165,227,128), RGB(0,0,0), RGB(165,227,128), RGB(0,0,0));
 end;

 function Yellow(Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(t_id, Line, Col, RGB(255,255,0), RGB(000,000,0),RGB(255,255,0),RGB(0,0,0));
 end;
 

 function deleteTable(Line, Col)  -- �������
	DestroyTable(t_id)
 end;

 

M.stats =  stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M