-- scriptTest.lua (in your scripts directory)
local M = {}

local init = {}

arrGraff = {};

local showLabel = false;
local showLabelPrice = true;

local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local words = dofile(getScriptPath() .. "\\langs\\words.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");

createTableGraff = false;
local wordTitleTableLog = {
    ['number'] = "N",
    ['time'] = "Time",
    ['event'] = "Event",
    ['volume'] = "volume",
    ['close'] = "close",
    ['datetime'] = "datetime",
    ['open'] = "open",
    ['high'] = "high",
    ['low'] = "low",
    ['datetime'] = "datetime",
    ['numberCandle'] = 'number Candle'
};

local function addSignal(arrGraff)
    CreateNewTableGraff();
    updateLogSignalGraff(arrGraff);
end

function updateLogSignalGraff(arrGraff)
    if #arrGraff == 0 then return; end

    itter = 1
    if #arrGraff > 35 then itter = #arrGraff - 35 end

    for keys = 1, #arrGraff do

        datetime = arrGraff[keys].datetime;
        local txtdatetime = datetime.hour .. ':' .. datetime.min .. ':' ..
                                datetime.sec;
        --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
        --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
        --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
        --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
        --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
        --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

        SetCell(t_graff, keys, 0, tostring(arrGraff[keys].open))
        SetCell(t_graff, keys, 1, tostring(arrGraff[keys].high))
        SetCell(t_graff, keys, 2, tostring(arrGraff[keys].low))
        SetCell(t_graff, keys, 3, tostring(arrGraff[keys].close))
        SetCell(t_graff, keys, 4, tostring(arrGraff[keys].volume))
        SetCell(t_graff, keys, 5, tostring(txtdatetime))

        SetCell(t_graff, keys, 6, tostring(arrGraff[keys].numberCandle))

    end

    setLabelTableLogGraff(_arr);
end

function setLabelTableLogGraff(_arr)
    if createTableGraff == false then return; end
end

--- simple create a table
function CreateNewTableGraff()
    if createTableGraff then return; end
    createTableGraff = true;

    t_graff = AllocTable();

    AddColumn(t_graff, 0, wordTitleTableLog.open, true, QTABLE_STRING_TYPE, 15);
    AddColumn(t_graff, 1, wordTitleTableLog.high, true, QTABLE_STRING_TYPE, 15);
    AddColumn(t_graff, 2, wordTitleTableLog.low, true, QTABLE_STRING_TYPE, 15);
    AddColumn(t_graff, 3, wordTitleTableLog.close, true, QTABLE_STRING_TYPE, 15);
    AddColumn(t_graff, 4, wordTitleTableLog.volume, true, QTABLE_STRING_TYPE, 15);
    AddColumn(t_graff, 5, wordTitleTableLog.datetime, true, QTABLE_STRING_TYPE,
              15);
    AddColumn(t_graff, 6, wordTitleTableLog.numberCandle, true,
              QTABLE_STRING_TYPE, 15);

    t = CreateWindow(t_graff);
    SetWindowCaption(t_graff, tostring("graff"));

    SetWindowPos(t_graff, 0, 70, 520, 340);

    for i = 1, 35 do InsertRow(t_graff, -1); end
    for i = 0, 3 do
        --	Blue(4, i);
        --	Blue(8, i);
        --	Gray(10, i);
        ----	Gray(12, i);
        --	Gray(14, i);
        --	Gray(16, i);
        --	Gray(18, i);
    end

end

function deleteTableGraff() DestroyTable(t_graff) end

M.addSignal = addSignal;
M.stats = stats;
M.deleteTableGraff = deleteTableGraff;
M.show = show;

return M
