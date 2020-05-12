-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}
  
local loger = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\loger.lua");


init.create = false;

local word = {
	['status'] = "Status",
	['buy'] = "Buy",
	['Buyplus'] = "Buy",
	['sell'] = "Sell",
	['close_positions'] = "Close positions",

	['profit_size'] = "Profit size:",
	['profit_range'] = "Profit range:",
	
	['start'] = "      START",
	['current_limit'] = "Current limit:",
	['Use_contract_limit'] = "Use contract:",
	['current_limit_minus'] = "          Minus",
	['current_limit_plus'] = "          Add", 

	['finish'] = "      STOP",
	['pause'] = "      PAUSE",
	['pause2'] = "           PAUSE",


	['emulation'] = "     Emulation",
	['buy_by_hand'] = "        BUY (now)",
	['sell_by_hand'] = "       SELL (now)",



	['on'] = "          ON      ",
	['off'] = "          OFF     ",
	['Trading_Bot_Control_Panel'] = "Trading Bot Control Panel",

};
 
 
 
local function show()  
	CreateNewTable(); 
	for i = 1, 25 do
		InsertRow(t_id, -1);
	 end;
	for i = 0, 3 do
		Blue(t_id,4, i);
		Blue(t_id,8, i);
		Gray(t_id,10, i);
		Gray(t_id,12, i);
		Gray(t_id,14, i);
		Gray(t_id,16, i);
		Gray(t_id,18, i);
		Gray(t_id,20, i);
		Gray(t_id,22, i);
		Gray(t_id,24, i);
		
	 end; 
		 
	 
	Yellow(t_id, 5, 2);



	SetCell(t_id, 1, 0,  '')
	SetCell(t_id, 1, 1, '')
	SetCell(t_id, 1, 2, '')
	SetCell(t_id, 2, 1, word.on) 
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
	mode_emulation_on();
	buy_by_hand_ready();
	sell_by_hand_ready();
	current_limit();
	current_limit_plus();
	current_limit_minus();
end
 
-- ['profit_size'] = "profit size:",
-- ['profit_range'] = "profit range:",

function current_limit() 
	SetCell(t_id, 11, 0,  word.current_limit); 
	SetCell(t_id, 13, 0,  word.Use_contract_limit); 
	SetCell(t_id, 15, 0,  word.profit_size); 
	SetCell(t_id, 17, 0,  word.profit_range); 

	 
end;
function current_limit_plus()  
	SetCell(t_id, 11, 2,  word.current_limit_plus); 
	SetCell(t_id, 13, 2,  word.current_limit_plus); 
	SetCell(t_id, 15, 2,  word.current_limit_plus); 
	SetCell(t_id, 17, 2,  word.current_limit_plus); 
	Green(t_id,11, 2);
	Green(t_id,13, 2);
	Green(t_id,15, 2);
	Green(t_id,17, 2);
end;
function current_limit_minus()  
	SetCell(t_id, 11, 3,  word.current_limit_minus); 
	SetCell(t_id, 13, 3,  word.current_limit_minus); 
	SetCell(t_id, 15, 3,  word.current_limit_minus); 
	SetCell(t_id, 17, 3,  word.current_limit_minus); 
	Red(t_id,11, 3);
	Red(t_id,13, 3);
	Red(t_id,15, 3);
	Red(t_id,17, 3);
end;

 
function use_contract_limit()  
	SetCell(t_id, 11, 1,   tostring( setting.LIMIT_BID ) .. '  /'.. setting.use_contract ..' '); 
	SetCell(t_id, 13, 1,   tostring(setting.use_contract)); 
	SetCell(t_id, 15, 1,   tostring(setting.profit_range_array)); 
	SetCell(t_id, 17, 1,   tostring(setting.profit_range)); 
end;

 





--['buy_by_hand'] = "buy by hand",
--['sell_by_hand'] = "           sell by hand",

function buy_by_hand_ready() 
	setting.buy_by_hand=true;
	SetCell(t_id, 6, 1,  word.buy_by_hand);
	White(t_id,5, 1);
	White(t_id,6, 1);
	White(t_id,7, 1);
end;



function buy_by_hand_oK() 
	setting.buy_by_hand=false;  
	SetCell(t_id, 6, 1,  word.off)
	Yellow(t_id,5, 1);
	Yellow(t_id,6, 1);
	Yellow(t_id,7, 1);
end;


function sell_by_hand_ready() 
	setting.sell_by_hand=true;
	SetCell(t_id, 6, 2,  word.sell_by_hand)
	White(t_id,5, 2) 
	White(t_id,6, 2) 
	White(t_id,7, 2)
end;

function selly_by_hand_oK() 
	setting.sell_by_hand=false;  
	SetCell(t_id, 6, 2,  word.off)
	Yellow(t_id,5, 2);
	Yellow(t_id,6, 2);
	Yellow(t_id,7, 2);
end;


 
function mode_emulation_on() 
	setting.emulation=true;
	SetCell(t_id, 5, 0,  word.emulation)
	SetCell(t_id, 6, 0,  word.on)
	Green(t_id,5, 0) 
	Green(t_id,6, 0) 
	Green(t_id,7, 0)
end;

function mode_emulation_off() 
	setting.emulation=false;  
	SetCell(t_id, 5, 0,  word.emulation)
	SetCell(t_id, 6, 0,  word.off)
	Gray(t_id,5, 0);
	Gray(t_id,6, 0);
	Gray(t_id,7, 0);
end;
 


function button_start()
	setting.status=true;
	SetCell(t_id, 2, 0,  word.finish)
	SetCell(t_id, 3, 1,  '')
	SetCell(t_id, 3, 2,  '')
	SetCell(t_id, 3, 3,  '')
	Green(t_id,1, 0) 
	Green(t_id,2, 0) 
	Green(t_id,3, 0)
end;
function button_finish() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.start)
	Gray(t_id,1, 0);
	Gray(t_id,2, 0);
	Gray(t_id,3, 0);
end;






function button_pause() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.pause)
	SetCell(t_id, 3, 1,  word.pause2)
	SetCell(t_id, 3, 2,  word.pause2)
	SetCell(t_id, 3, 3,  word.pause2)
	Red(t_id,1, 0);
	Red(t_id,2, 0);
	Red(t_id,3, 0);
end;


 

 
 

function close_positions_start() 
	setting.close_positions=true;
	SetCell(t_id, 2, 3,  word.on)
	Green(t_id,1, 3) 
	Green(t_id,2, 3) 
	Green(t_id,3, 3)
end;

function close_positions_finish()
	setting.close_positions=false;  
	SetCell(t_id, 2, 3,  word.off)
	Gray(t_id,1, 3);
	Gray(t_id,2, 3);
	Gray(t_id,3, 3);
end;





function sell_process()
	setting.sell = true;
	SetCell(t_id, 2, 2,  word.on)
	Green(t_id,1, 2) 
	Green(t_id,2, 2) 
	Green(t_id,3, 2)
end;
function sell_stop()  
	setting.sell = false;  
	SetCell(t_id, 2, 2,  word.off)
	Red(t_id,1, 2);
	Red(t_id,2, 2);
	Red(t_id,3, 2);
end;


function buy_process()
	setting.buy = true;
	SetCell(t_id, 2, 1,  word.on)
	Green(t_id,1, 1) 
	Green(t_id,2, 1) 
	Green(t_id,3, 1)
end;
function buy_stop()  
	setting.buy = false;  
	SetCell(t_id, 2, 1,  word.off)
	Red(t_id,1, 1);
	Red(t_id,2, 1);
	Red(t_id,3,1);
end;
 
local function stats()  
end;



--- simple create a table
function CreateNewTable() 
if createTable  then return; end;

init.create = true;
	-- �������� ��������� id ��� ��������
	t_id = AllocTable();	 


	AddColumn(t_id, 0, word.status , true, QTABLE_STRING_TYPE, 15);
	AddColumn(t_id, 1, word.buy, true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_id, 2, word.sell, true, QTABLE_STRING_TYPE, 20); 
	AddColumn(t_id, 3, word.close_positions, true,QTABLE_STRING_TYPE, 20); 
 
	t = CreateWindow(t_id); 
	SetWindowCaption(t_id, word.Trading_Bot_Control_Panel); 
   SetTableNotificationCallback(t_id, event_callback_message);  
   SetWindowPos(tt, 0, 70, 292, 140)
end;


function event_callback_message (t_id, msg, par1, par2)



	if par1 == 5 and par2 == 0 or  par1 == 6 and par2 == 0 or par1 == 7 and par2 == 0 then
		if  msg == 1 and setting.emulation == false then
			mode_emulation_on(); 
			return; 
		end;
		if  msg == 1 and setting.emulation == true then
			mode_emulation_off();
			return;
		end;
	end;





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



	
 
	if par1 == 11 and par2 == 2  and  msg == 1 then
		
		setting.LIMIT_BID = setting.LIMIT_BID + 1;
		
		use_contract_limit();
		return;
	end;
	if par1 == 11 and par2 == 3  and  msg == 1 then
		
		if(setting.LIMIT_BID > 0) then
				setting.LIMIT_BID = setting.LIMIT_BID - 1;
				use_contract_limit();
			end; 
		return;
	end;



	
 
	if par1 == 13 and par2 == 2  and  msg == 1 then
		
		setting.use_contract = setting.use_contract + 1; 
		use_contract_limit();
		return;
	end;

	if par1 == 13 and par2 == 3  and  msg == 1 then
		
		if(setting.use_contract > 1) then
				setting.use_contract = setting.use_contract - 1;
				use_contract_limit();
			end; 
		return;
	end;




 
	if par1 == 15 and par2 == 2  and  msg == 1 then
		setting.profit_range_array = setting.profit_range_array + 0.01; 
		use_contract_limit();
		return;
	end;
	if par1 == 15 and par2 == 3  and  msg == 1 then
		
		if(setting.profit > 0.01) then
			setting.profit_range_array = setting.profit_range_array - 0.01;
				use_contract_limit();
			end; 
		return;
	end;

 


	if par1 == 17 and par2 == 2  and  msg == 1 then
		setting.profit_range = setting.profit_range + 0.01; 
		use_contract_limit();
		return;
	end;

	if par1 == 17 and par2 == 3  and  msg == 1 then
		if setting.profit_range > 0.01 then
			setting.profit_range = setting.profit_range - 0.01;
			use_contract_limit();
			end; 
		return;
	end;

	 
--	loger.save(msg ..'  '  .. par1 .. '   '.. par2..' QTABLE_LBUTTONUP '.. QTABLE_LBUTTONUP);
end;

 

 function deleteTable()  -- �������
	DestroyTable(t_id)
 end;

 
M.stats =  stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M