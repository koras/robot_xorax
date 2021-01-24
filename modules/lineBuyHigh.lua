-- scriptTest.lua (in your scripts directory)
local bh = {} 

local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

labelIdHigh = 0;

labelIdLow = 0;

local function updateBuyHigh(setting)

    DelLabel(setting.tag,  labelIdHigh);
--- lineBuyHigh.lua
    labelIdHigh = tonumber(label.set(setting,'purchase_height', setting.not_buy_high, setting.datetime, 0,'Buy high '))
end


local function updateBuyLow(setting)
    DelLabel(setting.tag,  labelIdLow);
--- lineBuyHigh.lua
    labelIdLow = tonumber(label.set(setting,'purchase_low', setting.not_buy_low, setting.datetime, 0,'Buy high '))
end


-- обновление максимальной свечи
-- обновление минимальной свечи
local function updateLineCandleMinMax(setting)
    if setting.line_candle_min_max_show then 
        DelLabel(setting.tag,  setting.line_candle_height_label_id);
    --- lineBuyHigh.lua
        setting.line_candle_height_label_id = tonumber(label.set(setting,'line_candle_min_max', setting.candle_current_high, setting.datetime, 0,'Buy high '))

        DelLabel(setting.tag,  setting.line_candle_min_label_id);
    --- lineBuyHigh.lua
        setting.line_candle_min_label_id = tonumber(label.set(setting,'line_candle_min_max', setting.candle_current_low, setting.datetime, 0,'minimum price'))
    end
end

bh.updateLineCandleMinMax = updateLineCandleMinMax
bh.updateBuyLow = updateBuyLow
bh.updateBuyHigh = updateBuyHigh
return bh
