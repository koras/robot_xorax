-- сюда перенесены настройки которые необходимы во всём роботе но для каждого инструмента они разные
-- но от инструмента к инструменту они не меняются


-- версия продукта 
setting.version = "0.1.136";

-- второй минимум
setting.low_formacia = {};

setting.candle_test = 0;

setting.candle_current_high = 0; -- верхняя граница свечи; для промежутка покупки
setting.candle_current_low = 0; -- верхняя граница свечи; для промежутка покупки

setting.old_candle_price_high = 0; -- верхняя граница свечи; для промежутка покупки
setting.old_candle_price_low = 0; -- верхняя граница свечи; для промежутка покупки

-- На какой свече была оследняя покупка
-- это надо для понимания роботом, что покупка была давно
-- Если покупка была давно, то робот начнёт уменьшать спред последней покупки
setting.last_buy_candle = 0




-- открыта, закрыта панель покупок
stopClass.show_panel_bue_sell = false;

setting.use_windows = false;

-- примерное время работы, пока не используется
setting.timeWork = {{'10:00', '14:00'}, {'14:05', '18:45'}, {'19:00', '23:50'}};

setting.closed_buy = {
    {'13:00', '14:00'}, {'18:00', '19:02'}, {'22:55', '23:55'}
};

-- https://open-broker.ru/pricing-plans/


-- стоп заявки
stopClass.array_stop = {};
stopClass.array_stop.work = 0;
stopClass.array_stop.order_num = 0;
stopClass.array_stop.trans_id = 0;
stopClass.array_stop.price = 0;
stopClass.array_stop.stop_number = 0;
-- обновление стопов
stopClass.update = true;

-- минимальная и максимальная цена покупки
stopClass.price_min_buy = 0;
stopClass.price_max_buy = 0;

-- обновили максимальную цену, передвигаем стоп, сбрасываем тригер на обновление
stopClass.triger_update_up = true;



setting.comment_quik = 'Robot XoraX';

-- Использовать стопы или нет, по умолчанию да
stopClass.use_stop = false;
-- Показывать или скрывать панель стопов, по умолчинию скрыта
stopClass.show_panel = false;

-- максимальная цена в заявке
stopClass.price_max = 0;
-- минимальная цена в  заявке
stopClass.price_min = 10000000;

-- количество контрактов в работе
stopClass.contract_work = 0;

-- количество контрактов добавленных трейдером
stopClass.contract_add = 0;

