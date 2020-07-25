-- scriptTest.lua (in your scripts directory)
local M = {}

local init = {}

arrTableLog = {};

local showLabel = false;

local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");

createTableBids = false;

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
    ['work'] = "work",
    ['emulation'] = "emulation",
    --	['buy_contract'] = 'buy contract',
    ['title'] = 'Current bids  sell/buy'
};

function getEventLog(_event) return arr[_event]; end

local function show()
    --	CreateNewTableBids();
    -- очищаем табличку
    updateBidsClear();

    if #setting.sellTable > 0 then updateBidsSignal(); end

end

local rows = 0;
local CountRows = 0;

-- ['price'] = price,
-- ['dt']= dt, 
-- ['trans_id']= getRand(), 
-- ['type']= 'buy',
-- ['emulation']=  setting.emulation,
-- ['contract']=  setting.use_contract,
-- ['buy_contract']= price, -- стоимость продажи
function updateBidsClear()

    if CountRows < #setting.sellTable then

        rows = #setting.sellTable - CountRows;
        CountRows = #setting.sellTable;

        for i = 1, rows do InsertRow(t_id_TableBids, -1); end
    end
end

function updateBidsSignal()
    --	CreateNewTableBids();

    if #setting.sellTable == 0 then return; end

    local b = 0;
    local itter = 0;

    -- local itter = 1
    if #setting.sellTable > 1 then itter = #setting.sellTable; end

    --	for b = #setting.sellTable  , itter , -1 do
    for b = 1, #setting.sellTable do

        if b == 0 then return; end

        --	if #_arr == 0 then return; end; 
        --	for b = 1 , #setting.sellTable do
        bid = setting.sellTable[b];

        time = bid.datetime.hour .. ':' .. bid.datetime.min .. ':' ..
                   bid.datetime.sec;

        SetCell(t_id_TableBids, b, 0, tostring(b));
        SetCell(t_id_TableBids, b, 1, tostring(bid.price));
        --	SetCell(t_id_TableBids, b, 1, tostring(bid.price)..'/'.. tostring(bid.buy_contract));  
        SetCell(t_id_TableBids, b, 2, tostring(time));
        SetCell(t_id_TableBids, b, 3,
                tostring(bid.trans_id) .. '/' .. tostring(bid.trans_id_buy));
        SetCell(t_id_TableBids, b, 4,
                tostring(bid.contract) .. '/' .. tostring(bid.use_contract));
        SetCell(t_id_TableBids, b, 5, tostring(bid.type));

        --	SetCell(t_id_TableBids, b, 7, tostring(bid.emulation)..'/'..tostring(bid.work)); 

        --	SetCell(t_id_TableBids, b, 7, tostring(bid.work)); 

        if bid.type == 'sell' and bid.work then

            for num = 0, 8 do Red(t_id_TableBids, b, num); end

        elseif bid.type == 'buy' and bid.work then

            for num = 0, 8 do Green(t_id_TableBids, b, num); end
        else
            for num = 0, 8 do White(t_id_TableBids, b, num); end

        end
    end
    setLabelTableLog(_arr);
end

function setLabelTableLog(_arr) if createTableBids == false then return; end end

--- simple create a table
function CreateNewTableBids()
    -- if createTableBids  then return; end;
    createTableBids = true;

    t_id_TableBids = AllocTable();

    AddColumn(t_id_TableBids, 0, wordTitleTableBids.number, true,
              QTABLE_STRING_TYPE, 5);
    AddColumn(t_id_TableBids, 1, wordTitleTableBids.price, true,
              QTABLE_STRING_TYPE, 20);
    AddColumn(t_id_TableBids, 2, wordTitleTableBids.time, true,
              QTABLE_STRING_TYPE, 10);
    AddColumn(t_id_TableBids, 3, wordTitleTableBids.trans_id, true,
              QTABLE_STRING_TYPE, 25);
    AddColumn(t_id_TableBids, 4, wordTitleTableBids.contract, true,
              QTABLE_STRING_TYPE, 10);
    AddColumn(t_id_TableBids, 5, wordTitleTableBids.type, true,
              QTABLE_STRING_TYPE, 10);
    AddColumn(t_id_TableBids, 6, wordTitleTableBids.buy_contract, true,
              QTABLE_STRING_TYPE, 15);
    -- AddColumn(t_id_TableBids, 7,  wordTitleTableBids.emulation, true,QTABLE_STRING_TYPE, 15); 

    -- AddColumn(t_id_TableBids, 8,  wordTitleTableBids.work, true, QTABLE_STRING_TYPE, 15); 

    CreateWindow(t_id_TableBids);
    SetWindowCaption(t_id_TableBids, wordTitleTableBids.title);
    SetWindowPos(t_id_TableBids, 0, 70, 460, 340);

    -- for i = 1, 35 do
    -- 	InsertRow(t_id_TableBids, -1);
    -- end;
end

function deleteTable() DestroyTable(t_id_TableBids) end

M.show = show;
M.updateBidsSignal = updateBidsSignal;
M.deleteTable = deleteTable;
M.CreateNewTableBids = CreateNewTableBids;

return M
