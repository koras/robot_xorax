-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}

arrTableLog = {};

local showLabel = false;



local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");

 


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
	['emulation'] = "emulation",
	['buy_contract'] = 'buy contract',
	['title'] = 'Bids'
};
  

-- dt - current time
-- (int)  event
-- (bool) status
-- (string) price

function getEventLog(_event)
	return arr[_event];
end;

local function show(_bids) 
	
	
	CreateNewTableBids();
	updateLogSignal(_bids);   
end;


 
-- ['price'] = price,
-- ['dt']= dt, 
-- ['trans_id']= getRand(), 
-- ['type']= 'buy',
-- ['emulation']=  setting.emulation,
-- ['contract']=  setting.use_contract,
-- ['buy_contract']= price, -- стоимость продажи
 
 function updateLogSignal(_arr)   
	if #_arr == 0 then return; end; 

	itter = 1
 


 

	for b = 1 , #_arr do

	SetCell(t_id_TableBids, keys, 0, tostring(_arr[b].price));  

 

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
 
	 
	local wordTitleTableBids = {
		['number'] = "№",
		['price'] = "Price",
		['time'] = "Time", 
		['trans_id'] = "trans_id",
		['status'] = "Status", 
		['type'] = "type", 
		['emulation'] = "emulation",
		['buy_contract'] = 'buy contract'
	};

	AddColumn(t_id_TableBids, 0, wordTitleTableBids.number , true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id_TableBids, 1, wordTitleTableBids.price, true, QTABLE_STRING_TYPE, 10);
	AddColumn(t_id_TableBids, 2,  wordTitleTableBids.time, true, QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableBids, 3,  wordTitleTableBids.trans_id, true,QTABLE_STRING_TYPE, 15); 
	AddColumn(t_id_TableBids, 4,  wordTitleTableBids.status, true,QTABLE_STRING_TYPE, 5); 
	AddColumn(t_id_TableBids, 5,  wordTitleTableBids.type, true,QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableBids, 6,  wordTitleTableBids.buy_contract, true,QTABLE_STRING_TYPE, 10); 
 
 


	t = CreateWindow(t_id_TableBids); 
	SetWindowCaption(t_id_TableBids, wordTitleTableBids.title);  

   SetWindowPos(tt, 0, 70, 50, 140);


	for i = 1, 35 do
		InsertRow(t_id_TableBids, -1);
	end;

	for i = 0, 3 do
		Blue(4, i);
		Blue(8, i);
		Gray(10, i);
		Gray(12, i);
		Gray(14, i);
		Gray(16, i);
		Gray(18, i);
	end; 



end;

 
 

 function deleteTable()  -- �������
	DestroyTable(t_id_TableBids)
 end;
 
  
M.show =  show; 
M.stats = stats;
M.deleteTable = deleteTable;
M.CreateNewTableBids =  CreateNewTableBids;


return M