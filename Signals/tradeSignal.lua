-- scriptTest.lua (in your scripts directory)
local M = {}

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local words = dofile(getScriptPath() .. "\\langs\\words.lua");

M.status = 0;

local collbackFunc;

-- три состояния, 

-- как должна ходить цена для сигнала
 
local function getSignal(tg, callback)

    -- сколько свечей в работе с права
    local len = 1;
    local shift = 0;

  --  seconds = os.time(datetime); -- в seconds будет значение 1427052491
    collbackFunc = callback; 

    setting.number_of_candles = getNumCandles(setting.tag);
    bars_temp, res, legend = getCandlesByIndex(setting.tag, 0,
                                               setting.number_of_candles - 2 *
                                                   len - shift, 2 * len)
    local bars = {}
    local i = len
    local j = 2 * len
    while i >= 1 do
        if bars_temp[j - 1] == nil then
            message(words.word('not_found_tag'));
            OnStop();
            Run = false; 
            return
        end
                bars[i] = bars_temp[j - 1]
           --     loger.save( "bars[i] : ".. bars[i] .close )
             -- просто отправляем текущую цену
                collbackFunc(bars[i].close, bars[i].datetime, 0, 'buy');
                i = i - 1
        j = j - 1
    end

    t = len + 1
    return value
end


M.getSignal = getSignal
M.setRange = setRange 

return M
