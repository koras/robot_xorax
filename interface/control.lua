-- scriptTest.lua (in your scripts directory)
local M = {}

local init = {}

local loger = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local words = dofile(getScriptPath() .. "\\langs\\words.lua");
local riskStop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local signalShowLog =
    dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");

init.create = false;

local word = {
    ['status'] = "Status",
    ['long'] = "         LONG",
    ['buy'] = "Buy",
    ['Buyplus'] = "Buy",
    ['sell'] = "",
    ['close_positions'] = "",
    ['profit_range'] = "Profit range:",
    ['start'] = "           BABLO",
    ['current_limit'] = "Current limit:",
    ['Use_contract_limit'] = "Use contract:",
    ['current_limit_minus'] = "          Minus",
    ['current_limit_plus'] = "          Add",
    ['finish'] = "           PAUSE",
    ['pause'] = "          CONTINUE",
    ['pause2'] = "           PAUSE",
    ['emulation'] = "     Emulation",
    ['buy_by_hand'] = "        BUY (now)",
    ['sell_by_hand'] = "        MODE",
    ['take_profit_offset'] = "take profit offset:",
    ['take_profit_spread'] = "take profit spread:",
    ['on'] = "          ON      ",

    ['on'] = "          ON      ",
    ['off'] = "          OFF     ",
    ['off_auto'] = "        OFF AUTO     ",
    ['Trading_Bot_Control_Panel'] = "("..setting.SEC_CODE..") / XoraX Control Panel (free " ..
        setting.version .. ")",

    ['block_buy'] = "buy / block",
    ['SPRED_LONG_TREND_DOWN'] = "trend down", -- рынок падает, увеличиваем растояние между покупками
    ['SPRED_LONG_TREND_DOWN_SPRED'] = "down market range", -- на сколько увеличиваем растояние
    ['not_buy_high'] = "not buy high" -- условия; Выше какого диапазона не покупать(на хаях)
};

-- OFFSET SPREAD

local function show()
    CreateNewTable();
    for i = 1, 35 do InsertRow(t_control, -1); end
    for i = 0, 3 do
        Blue(t_control, 4, i);
        Gray(t_control, 10, i);
        Gray(t_control, 16, i);
        Gray(t_control, 24, i);
        Gray(t_control, 30, i);
    end

    SetCell(t_control, 1, 0, '')
    SetCell(t_control, 1, 1, '')
    SetCell(t_control, 1, 2, '')
    SetCell(t_control, 2, 1, word.on)

    SetCell(t_control, 3, 0, '')
    SetCell(t_control, 3, 1, '')
    SetCell(t_control, 3, 2, '')
    SetCell(t_control, 4, 0, '')
    SetCell(t_control, 4, 1, '')
    SetCell(t_control, 4, 2, '')

    button_finish();
    buy_process();

    if setting.emulation then
        mode_emulation_on();
    else
        mode_emulation_off()
    end

    mode_long();

    current_limit();
    current_limit_plus();
    current_limit_minus();
    --	sell_take_or_limit();
    use_stop();
    show_stop();
    show_panel_bue_sell();
    --	mode_long();
end

function sell_take_or_limit()
    if setting.sell_take_or_limit then
        SetCell(t_control, 19, 1, words.word('sell_set_take_profit'));
    else
        SetCell(t_control, 19, 1, words.word('sell_set_limit'));
    end
end

function mode_long()
    SetCell(t_control, 2, 3, word.long);
    Green(t_control, 1, 3);
    Green(t_control, 2, 3);
    Green(t_control, 3, 3);
end

-- функция использования и отображения стопов
function use_stop()
    if stopClass.use_stop then
        SetCell(t_control, 30, 1, words.word('use_stop_yes'));

        Green(t_control, 30, 1);
    else
        SetCell(t_control, 30, 1, words.word('use_stop_no'));
        Red(t_control, 30, 1);
    end
end

function show_stop()
    if stopClass.show_panel then
        SetCell(t_control, 30, 0, words.word('show_stop_no'));
        show_info_stop();
    else
        SetCell(t_control, 30, 0, words.word('show_stop_yes'));
        hide_info_stop();
    end
end

-- отображение и сокрытие панели покупок
function show_panel_bue_sell()
    if stopClass.show_panel_bue_sell then
        SetCell(t_control, 16, 0, words.word('show_stop_no'));
        show_panel_buy();
    else
        SetCell(t_control, 16, 0, words.word('show_panel_bue_sell_yes'));
        hide_panel_buy();
    end
end

function show_panel_buy()
    if stopClass.show_panel_bue_sell == false then return end
    SetCell(t_control, 17, 3, word.current_limit_minus);
    SetCell(t_control, 18, 3, word.current_limit_minus);
    SetCell(t_control, 20, 3, word.current_limit_minus);
    SetCell(t_control, 21, 3, word.current_limit_minus);

    Red(t_control, 17, 3);
    Red(t_control, 18, 3);
    Red(t_control, 20, 3);
    Red(t_control, 21, 3);

    SetCell(t_control, 17, 2, word.current_limit_plus);
    SetCell(t_control, 18, 2, word.current_limit_plus);

    SetCell(t_control, 19, 2, words.word('sell_set_take_or_limit_change'));
    SetCell(t_control, 20, 2, word.current_limit_plus);
    SetCell(t_control, 21, 2, word.current_limit_plus);
    Green(t_control, 17, 2);
    Green(t_control, 18, 2);
    Green(t_control, 20, 2);
    Green(t_control, 21, 2);

    SetCell(t_control, 17, 0, words.word('profit_range'));
    SetCell(t_control, 18, 0, words.word('profit_range_array'));
    SetCell(t_control, 19, 0, words.word('sell_set_take_or_limit'));
    SetCell(t_control, 20, 0, words.word('profit_take_max_range'));
    SetCell(t_control, 21, 0, words.word('profit_take_protected'));

    SetCell(t_control, 17, 1, tostring(setting.profit_range) .. " (" ..  tostring(setting.profit) .. ") ");
    SetCell(t_control, 18, 1, tostring(setting.profit_range_array) );


    SetCell(t_control, 20, 1, tostring(setting.take_profit_offset));
    SetCell(t_control, 21, 1, tostring(setting.take_profit_spread));

    sell_take_or_limit();
end

function hide_panel_buy()

    for i = 17, 22 do
        for s = 0, 3 do
            SetCell(t_control, i, s, tostring(""));
            White(t_control, i, s);
        end
    end

end

function current_limit()
    SetCell(t_control, 11, 0, words.word('current_limit'));
    SetCell(t_control, 13, 0, words.word('current_limit_max'));
    SetCell(t_control, 25, 0, words.word('buy_block'));
    SetCell(t_control, 26, 0, words.word('SPRED_LONG_TREND_DOWN'));
    SetCell(t_control, 27, 0, words.word('SPRED_LONG_TREND_DOWN_SPRED'));
    SetCell(t_control, 28, 0, words.word('not_buy_high'));
    SetCell(t_control, 29, 0, words.word('count_calculate_candle'));
end

function current_limit_plus()
    SetCell(t_control, 11, 2, word.current_limit_plus);
    SetCell(t_control, 13, 2, word.current_limit_plus);

    SetCell(t_control, 30, 2, words.word('sell_set_take_or_limit_change'));
    SetCell(t_control, 25, 2, word.current_limit_plus);
    SetCell(t_control, 26, 2, word.current_limit_plus);
    SetCell(t_control, 27, 2, word.current_limit_plus);
    SetCell(t_control, 28, 2, word.current_limit_plus);
    SetCell(t_control, 29, 2, word.current_limit_plus);

    Green(t_control, 11, 2);
    Green(t_control, 13, 2);

    Green(t_control, 25, 2);
    Green(t_control, 26, 2);
    Green(t_control, 27, 2);
    Green(t_control, 28, 2);
    Green(t_control, 29, 2);

end
function current_limit_minus()
    SetCell(t_control, 11, 3, word.current_limit_minus);
    SetCell(t_control, 13, 3, word.current_limit_minus);
    SetCell(t_control, 25, 3, word.current_limit_minus);
    SetCell(t_control, 26, 3, word.current_limit_minus);
    SetCell(t_control, 27, 3, word.current_limit_minus);
    SetCell(t_control, 28, 3, word.current_limit_minus);
    SetCell(t_control, 29, 3, word.current_limit_minus);
    Red(t_control, 11, 3);
    Red(t_control, 13, 3);

    Red(t_control, 25, 3);
    Red(t_control, 26, 3);
    Red(t_control, 27, 3);
    Red(t_control, 28, 3);
    Red(t_control, 29, 3);
end

function use_contract_limit()

    if setting.use_windows then
        if fuck_windows then
            fuck_windows = false;
            wt_control = wt_control + 1;
        else
            fuck_windows = true;
            wt_control = wt_control - 1;
        end
        SetWindowPos(t_control, 5, 5, wt_control, ht_control)
    end

    local buy_session = "b:" .. tostring(setting.count_buy) .. "/" ..
                            tostring(setting.count_contract_buy) .. "";
    local sell_session = "s:" .. tostring(setting.count_sell) .. "/" ..
                             tostring(setting.count_contract_sell) .. "";

    SetCell(t_control, 11, 1,
            tostring(setting.LIMIT_BID .. ' / ' .. setting.limit_count_buy ..
                         ' / ' .. setting.use_contract));
    SetCell(t_control, 12, 1, buy_session .. " | " .. sell_session);
    SetCell(t_control, 13, 1, tostring(setting.use_contract));
    -- потом только решение за человеком / сколько подряд раз уже купили
    SetCell(t_control, 25, 1,
            tostring(setting.each_to_buy_to_block) .. " ( " ..
                setting.each_to_sell_step .. ') /' .. setting.each_to_buy_step);
    SetCell(t_control, 26, 1, tostring(setting.SPRED_LONG_TREND_DOWN .. " - " ..
                                           setting.profit_range .. " (" ..
                                           setting.SPRED_LONG_TREND_DOWN_NEXT_BUY ..
                                           ")"));
    SetCell(t_control, 27, 1, tostring(setting.SPRED_LONG_TREND_DOWN_SPRED));
    SetCell(t_control, 28, 1, tostring(setting.not_buy_high));

    SetCell(t_control, 29, 1, tostring(setting.count_of_candle .. " (" ..
                                           setting.candle_current_high .. "/" ..
                                           setting.candle_current_low .. ")"));

    show_panel_bue_sell();
    -- панель покупки
    show_panel_buy()

    -- панель регилировки стопов
    show_info_stop();

    current_limit();
end

function show_info_stop()

    if stopClass.show_panel == false then return end
    -- количество контрактов добавленных трейдером
    SetCell(t_control, 31, 1,
            tostring(
                stopClass.contract_add .. ' ( ' .. stopClass.contract_work ..
                    words.word('stop_contract_work') .. ' )'));

    -- -- расстояние от максимальной покупки
    SetCell(t_control, 33, 1,
            tostring(stopClass.spred .. " (" .. words.word('stop_from_price') ..
                         stopClass.price_max .. ")"));

    SetCell(t_control, 31, 0, words.word('stop_add_contract'));

    SetCell(t_control, 33, 0, words.word('stop_range_price'));

    SetCell(t_control, 31, 2, word.current_limit_plus);
    SetCell(t_control, 33, 2, word.current_limit_plus);
    SetCell(t_control, 31, 3, word.current_limit_minus);

    SetCell(t_control, 33, 3, word.current_limit_minus);

    Red(t_control, 31, 3);

    Red(t_control, 33, 3);

    Green(t_control, 31, 2);

    Green(t_control, 33, 2);

end
function hide_info_stop()
    -- количество контрактов добавленных трейдером
    SetCell(t_control, 31, 1, tostring(""));
    SetCell(t_control, 33, 1, tostring(""));
    SetCell(t_control, 31, 0, tostring(""));
    SetCell(t_control, 33, 0, tostring(""));
    SetCell(t_control, 31, 2, tostring(""));
    SetCell(t_control, 33, 2, tostring(""));
    SetCell(t_control, 31, 3, tostring(""));
    SetCell(t_control, 33, 3, tostring(""));

    White(t_control, 31, 3);
    White(t_control, 33, 3);
    White(t_control, 31, 2);
    White(t_control, 33, 2);
end

function mode_emulation_on()
    setting.emulation = true;
    SetCell(t_control, 2, 2, words.word('emulation'))
    SetCell(t_control, 3, 2, word.on)
    Green(t_control, 1, 2)
    Green(t_control, 2, 2)
    Green(t_control, 3, 2)
end

function mode_emulation_off()
    setting.emulation = false;
    SetCell(t_control, 2, 2, words.word('emulation'))
    SetCell(t_control, 3, 2, word.off)
    Gray(t_control, 1, 2);
    Gray(t_control, 2, 2);
    Gray(t_control, 3, 2);
end

function button_start()
    setting.status = true;
    SetCell(t_control, 2, 0, word.finish)
    SetCell(t_control, 3, 1, '')
    SetCell(t_control, 3, 2, '')
    SetCell(t_control, 3, 3, '')
    Green(t_control, 1, 0)
    Green(t_control, 2, 0)
    Green(t_control, 3, 0)
end

function button_finish()
    setting.status = false;
    SetCell(t_control, 2, 0, words.word('bablo'))
    Gray(t_control, 1, 0);
    Gray(t_control, 2, 0);
    Gray(t_control, 3, 0);
end

function button_worked_stop()
    setting.status = false;
    SetCell(t_control, 2, 0, words.word('setSTOP'))
    Red(t_control, 1, 0);
    Red(t_control, 2, 0);
    Red(t_control, 3, 0);
    use_contract_limit();
end

function button_pause()
    setting.status = false;
    SetCell(t_control, 2, 0, word.pause)
    SetCell(t_control, 3, 1, word.pause2)
    SetCell(t_control, 3, 2, word.pause2)

    Red(t_control, 1, 0);
    Red(t_control, 2, 0);
    Red(t_control, 3, 0);
end

function buy_process()
    setting.buy = true;
    -- при падении рынка обнуляем продажы
    setting.each_to_buy_step = 0;
    SetCell(t_control, 2, 1, word.on)
    Green(t_control, 1, 1)
    Green(t_control, 2, 1)
    Green(t_control, 3, 1)
end

function buy_stop()
    setting.buy = false;
    SetCell(t_control, 2, 1, word.off)
    Red(t_control, 1, 1);
    Red(t_control, 2, 1);
    Red(t_control, 3, 1);
end
function buy_stop_auto()
    setting.buy = false;
    SetCell(t_control, 2, 1, word.off_auto)
    Red(t_control, 1, 1);
    Red(t_control, 2, 1);
    Red(t_control, 3, 1);
end

local function stats() end

wt_control = 582;
ht_control = 600;
fuck_windows = true;

--- simple create a table
function CreateNewTable()
    if createTable then return; end

    init.create = true;
    t_control = AllocTable();

    AddColumn(t_control, 0, word.status, true, QTABLE_STRING_TYPE, 35);
    AddColumn(t_control, 1, word.buy, true, QTABLE_STRING_TYPE, 30);
    AddColumn(t_control, 2, word.sell, true, QTABLE_STRING_TYPE, 21);
    AddColumn(t_control, 3, word.close_positions, true, QTABLE_STRING_TYPE, 21);

    t = CreateWindow(t_control);
    SetWindowCaption(t_control, word.Trading_Bot_Control_Panel);
    SetTableNotificationCallback(t_control, event_callback_message_control);

    SetWindowPos(t_control, 5, 5, wt_control, ht_control)
end

function event_callback_message_control(t_control, msg, par1, par2)

    -- панель заявок 

    -- if par1 == 1 and par2 == 3  and  msg == 1 then
    -- 	panelBids.CreateNewTableBids();
    -- 	panelBids.show();
    -- 	return;
    -- end; 
    -- -- панель логов
    -- if par1 == 2 and par2 == 3  and  msg == 1 then
    -- 	signalShowLog.CreateNewTableLogEvent();
    -- 	return;
    -- end;

    if par1 == 1 and par2 == 2 or par1 == 2 and par2 == 2 or par1 == 3 and par2 ==
        2 then
        if msg == 1 and setting.emulation == false then
            mode_emulation_on();
            return;
        end
        if msg == 1 and setting.emulation == true then
            mode_emulation_off();
            return;
        end
    end

    if par1 == 1 and par2 == 0 or par1 == 2 and par2 == 0 or par1 == 3 and par2 ==
        0 then
        if msg == 1 and setting.status == false then
            button_start();
            return;
        end

        if msg == 1 and setting.status == true then
            -- button_finish();
            button_pause();
            return;
        end
    end

    if par1 == 1 and par2 == 1 or par1 == 2 and par2 == 1 or par1 == 3 and par2 ==
        1 then
        if msg == 1 and setting.buy == false then
            buy_process();
            return;
        end

        if msg == 1 and setting.buy == true then
            buy_stop();
            return;
        end
    end

    if par1 == 11 and par2 == 2 and msg == 1 then
        setting.LIMIT_BID = setting.LIMIT_BID + 1;
        use_contract_limit();
        SetWindowCaption(t_control, word.Trading_Bot_Control_Panel ..
                             tostring(setting.LIMIT_BID));
        return;
    end

    if par1 == 11 and par2 == 3 and msg == 1 then

        if setting.LIMIT_BID > 1 then
            setting.LIMIT_BID = setting.LIMIT_BID - 1;
            use_contract_limit();
            -- return
            SetWindowCaption(t_control, word.Trading_Bot_Control_Panel ..
                                 tostring(setting.LIMIT_BID));

            --	use_contract_limit();
            return;
        end
        return;
    end

    if par1 == 13 and par2 == 2 and msg == 1 then

        setting.use_contract = setting.use_contract + 1;
        use_contract_limit();
        return;
    end

    if par1 == 13 and par2 == 3 and msg == 1 then

        if (setting.use_contract > 1) then
            setting.use_contract = setting.use_contract - 1;
            use_contract_limit();
        end
        return;
    end

    if par1 == 17 and par2 == 2 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end

        setting.profit_range = setting.profit_range + setting.profit_range_panel;
        use_contract_limit();
        return;
    end

    if par1 == 17 and par2 == 3 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        if setting.profit_range > setting.profit_range_panel then
            setting.profit_range = setting.profit_range - setting.profit_range_panel;
            use_contract_limit();
        end
        return;
    end


     


    if par1 == 18 and par2 == 2 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end

        setting.profit_range_array = setting.profit_range_array + setting.profit_range_array_panel;
        use_contract_limit();
        return;
    end

    if par1 == 18 and par2 == 3 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        if setting.profit_range > 0 then

            setting.profit_range_array = setting.profit_range_array - setting.profit_range_array_panel;
            if setting.profit_range_array < 0 then 
                setting.profit_range_array = 0
            end 
            use_contract_limit();
        end
        return;
    end





    if par1 == 20 and par2 == 2 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        setting.take_profit_offset = setting.take_profit_offset + setting.profit_range_panel;
        use_contract_limit();
        return;
    end

    if par1 == 20 and par2 == 3 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        if setting.take_profit_offset > setting.profit_range_panel then
            setting.take_profit_offset = setting.take_profit_offset - setting.profit_range_panel;
            use_contract_limit();
        end
        return;
    end

    if par1 == 21 and par2 == 2 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        setting.take_profit_spread = setting.take_profit_spread + setting.profit_range_panel;
        use_contract_limit();
        return;
    end

    if par1 == 21 and par2 == 3 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        if setting.take_profit_spread > setting.profit_range_panel then
            setting.take_profit_spread = setting.take_profit_spread - setting.profit_range_panel;
            use_contract_limit();
        end
        return;
    end

    -- блокировка лимита при падении
    if par1 == 25 and par2 == 2 and msg == 1 then
        setting.each_to_buy_to_block = setting.each_to_buy_to_block + 1;
        use_contract_limit();
        return;
    end
    if par1 == 25 and par2 == 3 and msg == 1 then
        if setting.each_to_buy_to_block > 1 then
            setting.each_to_buy_to_block = setting.each_to_buy_to_block - 1;
            use_contract_limit();
        end
        return;
    end

    -- рынок падает, увеличиваем растояние между покупками
    if par1 == 26 and par2 == 2 and msg == 1 then
        setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN + setting.profit_range_panel;
        use_contract_limit();
        return;
    end
    if par1 == 26 and par2 == 3 and msg == 1 then
        if setting.SPRED_LONG_TREND_DOWN > 0 then
            setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN - setting.profit_range_panel;
            use_contract_limit();
        end
        return;
    end

    -- на сколько увеличиваем растояние при падении рынка между покупками
    if par1 == 27 and par2 == 2 and msg == 1 then
        setting.SPRED_LONG_TREND_DOWN_SPRED =
            setting.SPRED_LONG_TREND_DOWN_SPRED + setting.profit_range_panel;
        use_contract_limit();
        return;
    end
    if par1 == 27 and par2 == 3 and msg == 1 then
        if setting.SPRED_LONG_TREND_DOWN_SPRED > setting.profit_range_panel then
            setting.SPRED_LONG_TREND_DOWN_SPRED =
                setting.SPRED_LONG_TREND_DOWN_SPRED - setting.profit_range_panel;
            use_contract_limit();
        end
        return;
    end

    -- на сколько увеличиваем растояние при падении рынка между покупками
    if par1 == 28 and par2 == 2 and msg == 1 then
        setting.not_buy_high = setting.not_buy_high + setting.not_buy_high_change;
        use_contract_limit();
        return;
    end
    if par1 == 28 and par2 == 3 and msg == 1 then
        if setting.not_buy_high > setting.not_buy_high_change then
            setting.not_buy_high = setting.not_buy_high - setting.not_buy_high_change;
            use_contract_limit();
        end
        return;
    end

    --	['sell_set_take_profit'] = "тейк профит",
    --	['sell_set_limit'] = "тейк профит",

    --	['sell_set_take_or_limit_change'] = "Изменить",
    -- установка тейкпрофита или лимитки на продажу
    if par1 == 19 and par2 == 2 and msg == 1 then
        if stopClass.show_panel_bue_sell == false then return end
        if setting.sell_take_or_limit then
            setting.sell_take_or_limit = false;
            sell_take_or_limit();
            use_contract_limit();
        else
            setting.sell_take_or_limit = true;
            sell_take_or_limit();
            use_contract_limit();
        end
        return;
    end

    -- количество контрактов которые добавляет трейдер
    if par1 == 31 and par2 == 2 and msg == 1 then
        stopClass.contract_add = stopClass.contract_add + 1;
        riskStop.update_stop();
        use_contract_limit();
        return;
    end
    if par1 == 31 and par2 == 3 and msg == 1 then
        if stopClass.contract_add > 0 then
            stopClass.contract_add = stopClass.contract_add - 1;
            riskStop.update_stop();
            use_contract_limit();
        end
        return;
    end

    -- Кнопка использовать стопы или нет
    if par1 == 30 and par2 == 2 and msg == 1 then
        if stopClass.use_stop then
            stopClass.use_stop = false;
            riskStop.backStop()
        else
            stopClass.use_stop = true;
        end
        use_stop();
        riskStop.update_stop();
        use_contract_limit();
        --	show_info_stop()
        return;
    end

    -- Кнопка отобразить панель со стопами или нет
    if par1 == 30 and par2 == 0 and msg == 1 then
        if stopClass.show_panel then
            stopClass.show_panel = false;
        else
            stopClass.show_panel = true;
        end
        show_stop();
        use_contract_limit();

        return;
    end

    -- кнопка показываем панель покупок или нет

    if par1 == 16 and par2 == 0 and msg == 1 then
        if stopClass.show_panel_bue_sell then
            stopClass.show_panel_bue_sell = false;
        else
            stopClass.show_panel_bue_sell = true;
        end
        use_contract_limit();
        show_panel_bue_sell();

        return;
    end

    -- растояние до максимальной покупки, меняется только при максимальной покупке
    if par1 == 33 and par2 == 2 and msg == 1 then
        stopClass.spred = stopClass.spred + stopClass.spred_limit;
        riskStop.update_stop();
        use_contract_limit();
        show_info_stop()
        return;
    end
    if par1 == 33 and par2 == 3 and msg == 1 then
        if stopClass.spred > stopClass.spred_default then
            stopClass.spred = stopClass.spred - stopClass.spred_limit;
            riskStop.update_stop();
            use_contract_limit();
            show_info_stop()
        end
        return;
    end

    -- растояние до максимальной покупки, меняется только при максимальной покупке
    if par1 == 29 and par2 == 2 and msg == 1 then
        setting.count_of_candle = setting.count_of_candle + 1;

        use_contract_limit();
        return;
    end
    if par1 == 29 and par2 == 3 and msg == 1 then
        message(setting.count_of_candle);
        if setting.count_of_candle > 0 then
            setting.count_of_candle = setting.count_of_candle - 1;
            use_contract_limit();
        end
        return;
    end

    if par1 == 4 and par2 == 0 and msg == 1 then return; end

end

function deleteTable() DestroyTable(t_control) end

M.button_worked_stop = button_worked_stop;
M.buy_stop_auto = buy_stop_auto;
M.buy_process = buy_process;
M.buy_stop = buy_stop;
M.use_contract_limit = use_contract_limit;
M.stats = stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M
