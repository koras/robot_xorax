-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}

arrTableLog = {};

local showLabel = false;



local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");

 


createTableBids= false;


-- ['price'] = price,
-- ['dt']= dt, 
-- ['trans_id']= getRand(), 
-- ['type']= 'buy',
-- ['emulation']=  setting.emulation,
-- ['contract']=  setting.use_contract,
-- ['buy_contract']= price, -- стоимость продажи

local wordTitleTableBids = {
	['number'] = "№",
	['price'] = "Price",
	['time'] = "Time", 
	['trans_id'] = "trans_id",
	['status'] = "Status", 
	['type'] = "type", 
	 
	['contract'] = "count",
	['emulation'] = "emulation",
	['buy_contract'] = 'buy contract',
	['title'] = 'Current bids  sell/buy'
};
  

-- dt - current time
-- (int)  event
-- (bool) status
-- (string) price

function getEventLog(_event)
	return arr[_event];
end;

local function show() 
	CreateNewTableBids();
	-- очищаем табличку
	updateBidsClear();

	if #setting.sellTable > 0  then  
		updateBidsSignal();     
		
	end;

end;


 
-- ['price'] = price,
-- ['dt']= dt, 
-- ['trans_id']= getRand(), 
-- ['type']= 'buy',
-- ['emulation']=  setting.emulation,
-- ['contract']=  setting.use_contract,
-- ['buy_contract']= price, -- стоимость продажи
function updateBidsClear() 

	for b = 1, 35 do
		SetCell(t_id_TableBids, b, 0, tostring(''));  
		SetCell(t_id_TableBids, b, 1, tostring(''));  
		SetCell(t_id_TableBids, b, 2, tostring(''));  
		SetCell(t_id_TableBids, b, 3, tostring('')); 
		SetCell(t_id_TableBids, b, 5, tostring('')); 
		SetCell(t_id_TableBids, b, 6, tostring('')); 
		SetCell(t_id_TableBids, b, 7, tostring('')); 

		White(t_id_TableBids, b, 0);
		White(t_id_TableBids, b, 1);
		White(t_id_TableBids, b, 2);
		White(t_id_TableBids, b, 3);
		White(t_id_TableBids, b, 4);
		White(t_id_TableBids, b, 5);
		White(t_id_TableBids, b, 6);
		White(t_id_TableBids, b, 7);
	end;

end;



 function updateBidsSignal()  
	CreateNewTableBids();
--	if #_arr == 0 then return; end; 
	for b = 1 , #setting.sellTable do
		bid = setting.sellTable[b];

		time = bid.datetime.hour..':'..bid.datetime.min..':'..bid.datetime.sec;
		SetCell(t_id_TableBids, b, 0, tostring(b));  
		SetCell(t_id_TableBids, b, 1, tostring(bid.price));  
		SetCell(t_id_TableBids, b, 2, tostring(time));  
		SetCell(t_id_TableBids, b, 3, tostring(bid.trans_id)); 
		SetCell(t_id_TableBids, b, 4, tostring(bid.contract)); 
		SetCell(t_id_TableBids, b, 5, tostring(bid.type)); 
		SetCell(t_id_TableBids, b, 6, tostring(bid.buy_contract)); 

		SetCell(t_id_TableBids, b, 7, tostring(bid.emulation)); 
		 

		if bid.type == 'sell' then
			Red(t_id_TableBids, b, 0);
			Red(t_id_TableBids, b, 1);
			Red(t_id_TableBids, b, 2);
			Red(t_id_TableBids, b, 3);
			Red(t_id_TableBids, b, 4);
			Red(t_id_TableBids, b, 5);
			Red(t_id_TableBids, b, 6);
			Red(t_id_TableBids, b, 7);

		elseif bid.type == 'buy' then
			Green(t_id_TableBids, b, 0);
			Green(t_id_TableBids, b, 1);
			Green(t_id_TableBids, b, 2);
			Green(t_id_TableBids, b, 3);
			Green(t_id_TableBids, b, 4);
			Green(t_id_TableBids, b, 5);
			Green(t_id_TableBids, b, 6);
			Green(t_id_TableBids, b, 7);
		else 
			White(t_id_TableBids, b, 0);
			White(t_id_TableBids, b, 1);
			White(t_id_TableBids, b, 2);
			White(t_id_TableBids, b, 3);
			White(t_id_TableBids, b, 4);
			White(t_id_TableBids, b, 5);
			White(t_id_TableBids, b, 6);
			White(t_id_TableBids, b, 7);
		end   
	end 
	setLabelTableLog(_arr);
end;


 function setLabelTableLog(_arr)  
if createTableBids == false then return; end;
end;
   


--- simple create a table
function CreateNewTableBids() 
	if createTableBids  then return; end;
	createTableBids = true; 
	
	t_id_TableBids = AllocTable();	 
 
	 
	AddColumn(t_id_TableBids, 0, wordTitleTableBids.number , true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id_TableBids, 1, wordTitleTableBids.price, true, QTABLE_STRING_TYPE, 10);
	AddColumn(t_id_TableBids, 2,  wordTitleTableBids.time, true, QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableBids, 3,  wordTitleTableBids.trans_id, true,QTABLE_STRING_TYPE, 15); 
	AddColumn(t_id_TableBids, 4,  wordTitleTableBids.contract, true,QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableBids, 5,  wordTitleTableBids.type, true,QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableBids, 6,  wordTitleTableBids.buy_contract, true,QTABLE_STRING_TYPE, 15); 
	AddColumn(t_id_TableBids, 7,  wordTitleTableBids.emulation, true,QTABLE_STRING_TYPE, 15); 
 
	 
	CreateWindow(t_id_TableBids); 
	SetWindowCaption(t_id_TableBids, wordTitleTableBids.title);  
   	SetWindowPos(tt, 0, 70, 50, 140);


	for i = 1, 35 do
		InsertRow(t_id_TableBids, -1);
	end;

 


end;

 
 

 function deleteTable()   
	DestroyTable(t_id_TableBids)
 end;
 
  
M.show =  show; 
M.updateBidsSignal= updateBidsSignal;
M.deleteTable = deleteTable;
M.CreateNewTableBids =  CreateNewTableBids;

return M