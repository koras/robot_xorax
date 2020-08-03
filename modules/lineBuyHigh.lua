-- scriptTest.lua (in your scripts directory)
local bh = {} 

local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

labelIdHigh = 0;

labelIdLow = 0;

function updateBuyHigh()

    DelLabel(setting.tag,  labelIdHigh);
--- lineBuyHigh.lua
    labelIdHigh = tonumber(label.set('purchase_height', setting.not_buy_high, setting.datetime, 0,'Buy high '))
end


function updateBuyLow()

    DelLabel(setting.tag,  labelIdLow);
--- lineBuyHigh.lua
    labelIdLow = tonumber(label.set('purchase_low', setting.not_buy_low, setting.datetime, 0,'Buy high '))
end

 
bh.updateBuyLow = updateBuyLow
bh.updateBuyHigh = updateBuyHigh
return bh
