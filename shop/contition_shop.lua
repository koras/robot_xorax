-- ЗДесь определённые условия для магазина
-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local signalShowLog =
    dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local control = dofile(getScriptPath() .. "\\interface\\control.lua");

M = {};

-- не покупаем если купили в текущем состоянии
function getRand(price)
    local checkRange = true;
    if #setting.sellTable > 0 then
        for j_checkRangBuy = 1, #setting.sellTable do
            -- long
            if setting.sellTable[j_checkRangBuy].type == setting.mode and
                setting.sellTable[j_checkRangBuy].work then
                -- здесь узнаю, была ли покупка в этом диапозоне
                if setting.profit_range +
                    setting.sellTable[j_checkRangBuy].price >= price +
                    setting.profit_infelicity and price >=
                    setting.sellTable[j_checkRangBuy].price -
                    setting.SPRED_LONG_BUY_down then
                    signalShowLog.addSignal(11, false, price);
                    checkRange = false;
                end
            elseif setting.sellTable[j_checkRangBuy].type == setting.mode and
                setting.sellTable[j_checkRangBuy].work then
                -- short
                -- здесь узнаю, была ли покупка в этом диапозоне
                if setting.sellTable[j_checkRangBuy].price -
                    setting.profit_range >= price - setting.profit_infelicity and
                    price <= setting.sellTable[j_checkRangBuy].price +
                    setting.SPRED_LONG_BUY_down then
                    signalShowLog.addSignal(11, false, price);
                    checkRange = false;
                end
            end
        end
    end
    return checkRange;
end


-- висит ли заявка на продажу в этом промежутке
function getRandSell(price)
    local checkRange = true;
    if #setting.sellTable > 0 then
        for j_checkRange = 1, #setting.sellTable do

            if setting.sellTable[j_checkRange].work then

                -- здесь узнаю, была ли покупка в этом диапозоне
                if setting.sellTable[j_checkRange].type ~= setting.mode then
                    -- long 
                    if setting.profit_range + setting.sellTable[j_checkRange].price >= price and price >= setting.sellTable[j_checkRange].price - setting.profit_range then
                        checkRange = false;
                        signalShowLog.addSignal(12, false, price);
                    end

                elseif setting.sellTable[j_checkRange].type ~= setting.mode then
                    -- short
                    if setting.sellTable[j_checkRange].price - setting.profit_range <= price and price <= setting.sellTable[j_checkRange].price + setting.profit_range then
                        checkRange = false;
                        signalShowLog.addSignal(12, false, price);
                    end

                end
            end
        end
    end
    return checkRange;
end

-- Лимит заявок на покупку 
function getLimitBuy()
    if setting.LIMIT_BID <= setting.limit_count_buy then
        signalShowLog.addSignal(25, false, setting.limit_count_buy);
        return  false;
    end

    return true;
end

-- Не покупаем если промежуток на свече соответствуют высокой цене
function getRandCandle(price)

    -- высота свечи, не важно, к шорту или к лонгу относится
    local range_candle = setting.candle_current_high - setting.candle_current_low;
    local checkRange = true;

    if range_candle < setting.profit_range then
        -- свечка меньше текущего профита 
        --	[13] = 'Текущая свеча меньше преполагаемого профита, низкая волатильность',   
        checkRange = false;
        signalShowLog.addSignal(19, false, setting.candle_current_high);
    end

    return checkRange;
end


-- Определяем, цена удовлетворяет тому чтобы купить или продать
function getRandCandleProfit(price)
 
    local checkRange = false;

    if setting.mode == 'buy' then
        -- если лонг, смотрим цену и возможность покупки
        local priceSizeForLong = setting.candle_current_high - setting.profit_range;
         
        if price > priceSizeForLong + setting.profit_infelicity  then
            -- свечка меньше текущего профита  
            --	[14] = 'Цена на свече выше профита, покупка на верху невозможна',   
            checkRange = true; 
        end
    else
        -- short
        local priceSizeForShort = setting.candle_current_low + setting.profit_range;
        if priceSizeForLong + setting.profit_infelicity < price then
            -- свечка меньше текущего профита  
            --	[14] = 'Цена на свече выше профита, продажа  невозможна',   
            checkRange = true;
        end

    end

    if checkRange == false then
        signalShowLog.addSignal(14, false, priceMinimum);
    end

    return checkRange;
end







-- Падение рынка при лонге
-- рост рынка при шортах

function getFailMarket(price)
 
    -- setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - последняя покупка
    -- setting.SPRED_LONG_TREND_DOWN - увеличиваем растояние между покупками
    if setting.SPRED_LONG_TREND_DOWN_LAST_PRICE == 0 then 
        return true;
    end;

    if setting.mode == 'buy' then
        -- только лонг
        price = price - setting.profit_infelicity;
        setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - setting.profit_range - setting.SPRED_LONG_TREND_DOWN

        if price < setting.SPRED_LONG_TREND_DOWN_NEXT_BUY  then
            return true;
        end
    else
        -- short
        price = price + setting.profit_infelicity;
        setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = setting.SPRED_LONG_TREND_DOWN_LAST_PRICE + setting.profit_range + setting.SPRED_LONG_TREND_DOWN

        if price > setting.SPRED_LONG_TREND_DOWN_NEXT_BUY  then
            return true;
        end
    end

    signalShowLog.addSignal(3, true, setting.SPRED_LONG_TREND_DOWN_NEXT_BUY);
    return false;
end





-- Prohibition of buying and selling
function getFailBuy(price)
    local checkRange = true;
    if setting.each_to_buy_step >= setting.each_to_buy_to_block then
        -- активация кнопки блокировки покупки
        signalShowLog.addSignal(18, true, price);
        setting.each_to_buy_status_block = true;
        control.buy_stop_auto();
        checkRange = false;
    end
    return checkRange;
end

-- проверка на блокировку кнопки покупок
function buyButtonBlock(price)

    if setting.buy  then 
        return true
    end
    
    signalShowLog.addSignal(4, true, price);
    return false;
end


-- верхний диапазон
function not_high(price)
 
    if price >= setting.not_buy_high then
        signalShowLog.addSignal(19, true, price);
        return  false;
    end
    return true;
end

-- нижний диапазон
function not_buy_low(price)

    if price <= setting.not_buy_low then
        signalShowLog.addSignal(38, true, price);
        return  false
    end
    return false
end

M.not_low = not_low;
M.not_high = not_high;
M.buyButtonBlock = buyButtonBlock;
M.getFailBuy = getFailBuy;
M.getLimitBuy = getLimitBuy;
M.getFailMarket = getFailMarket;
M.getRandCandle = getRandCandle;
M.getRandCandleProfit = getRandCandleProfit;

 
M.getRandSell = getRandSell;
M.getRand = getRand;

return M
