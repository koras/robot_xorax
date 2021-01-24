

local eData = {}

-- сюда перенесены настройки которые необходимы во всём роботе но для каждого инструмента они разные
-- но от инструмента к инструменту они не меняются
-- версия продукта 
eData.version = "1.0.01";

-- второй минимум
eData.low_formacia = {};

eData.candle_test = 0;

eData.candle_current_high = 0; -- верхняя граница свечи; для промежутка покупки
eData.candle_current_low = 0; -- верхняя граница свечи; для промежутка покупки

eData.old_candle_price_high = 0; -- верхняя граница свечи; для промежутка покупки
eData.old_candle_price_low = 0; -- верхняя граница свечи; для промежутка покупки

-- На какой свече была оследняя покупка
-- это надо для понимания роботом, что покупка была давно
-- Если покупка была давно, то робот начнёт уменьшать спред последней покупки
eData.last_buy_candle = 0

-- открыта, закрыта панель покупок
eData.show_panel_bue_sell = false;

eData.use_windows = false;

-- примерное время работы, пока не используется
eData.timeWork = {{'10:00', '14:00'}, {'14:05', '18:45'}, {'19:00', '23:50'}};

eData.closed_buy = {
    {'13:00', '14:00'}, {'18:00', '19:02'}, {'22:55', '23:55'}
};

-- https://open-broker.ru/pricing-plans/

-- стоп заявки
eData.array_stop = {};
eData.array_stop.work = 0;
eData.array_stop.order_num = 0;
eData.array_stop.trans_id = 0;
eData.array_stop.price = 0;
eData.array_stop.stop_number = 0;
-- обновление стопов
eData.update = true;

-- минимальная и максимальная цена покупки
eData.price_min_buy = 0;
eData.price_max_buy = 0;



eData.fuck_windows = true;

-- обновили максимальную цену, передвигаем стоп, сбрасываем тригер на обновление
eData.triger_update_up = true;

eData.comment_quik = 'Robot XoraX';

-- Использовать стопы или нет, по умолчанию да
eData.use_stop = false;
-- Показывать или скрывать панель стопов, по умолчинию скрыта
eData.show_panel = false;

-- максимальная цена в заявке
eData.price_max = 0;
-- минимальная цена в  заявке
eData.price_min = 10000000;

-- количество контрактов в работе
eData.contract_work = 0;

-- количество контрактов добавленных трейдером
eData.contract_add = 0;

-- минимальная цена контракта на продажу среди установленных заявок
eData.price_min_sell = 0
-- максимальная цена контракта на продажу среди установленных заявок
eData.price_max_sell = 0

-- минимальная цена купленного ранее контракта
eData.price_min_buy = 0
-- максимальная цена купленного ранее контракта
eData.price_max_buy = 0

-- подсчёт прибыли, считается после каждой продажи
eData.profit = 0.00;

-- текущее время в свече, для внетреннего использования в роботе
eData.datetime = 0;

-- режим разработки, используется только для тестирования нового функционала
eData.developer = false;

-- кнопка закрытия позиции
eData.close_positions = false;

eData.count_buyin_a_row = 0; -- покупок сколько было за торговую сессию
eData.current_price = 0; -- текщая цена

-- сколько куплено раз
eData.count_buy = 0;
-- сколько продано раз
eData.count_sell = 0;

eData.count_contract_buy = 0; -- сколько куплено контрактов за сессию
eData.count_contract_sell = 0; -- сколько продано контрактов за сессию 

-- тип интервала на свече, обязательный параметр
eData.INTERVAL = INTERVAL_M1;

eData.number_of_candles = 0; -- current a candle
eData.old_number_of_candles = 0; -- old current candle

eData.number_of_candle_init = true

-- сработал стоп или нет
-- если сработал стоп, то другие стопы не передигаем
-- число отвечающее на сколько отодвинуты стопы от первоначальной версии
eData.triger_stop = 0;

-- отвечает за расчёты в свечах
-- информация по свечам для анализа
eData.array_candle = {};

-- На сколько прибавить к свече чтобы закупится ниже профита
eData.profit_add_candle = 0;
-- открыта или закрыта панель покупок

-- максимальная цена в заявке
eData.price_max = 0;
-- минимальная цена в  заявке
eData.price_min = 10000000;

-- количество контрактов в работе
eData.contract_work = 0;

-- количество контрактов добавленных трейдером
eData.contract_add = 0;

-- какая последняя покупка была при падении
eData.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0; -- 
-- когда следующая покупка при падении
eData.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0;

eData.each_to_buy_step = 0; -- сколько подряд раз уже купили
 
eData.each_to_buy_status_block = false; -- сколько подряд раз уже купили

-- Последняя цена сделки по продаже констракта
eData.SPRED_LONG_LOST_SELL = 0;
 

-- Последняя цена сделки по продаже констракта
eData.SPRED_LONG_LOST_SELL = 0.00;

-- условия; Выше какого диапазона не покупать(на хаях)
eData.not_buy_high = 0

-- условия; ниже  какого диапазона не покупать(на хаях)
eData.not_buy_low = 0

-- лимит на покупку ( сколько контрактов купили на текущий момент )
eData.limit_count_buy = 0

eData.candles = {}; -- свечи


-- start or stop
eData.status = false;

eData.buy = true;
eData.sell = true;
-- таблица заявок, здесь все заявки используемые в работе робота
eData.sellTable = {};

-- long = 'buy'
-- long = 'sell'
eData.mode = 'buy'

-- current date
eData.currentDatetime = {};
-- max old price
eData.lastDayPrice = 0;
-- current price
eData.openDayPrice = 0;
-- max old price
eData.singleGetOldPrice = true;

-- выставили заявку при гэпе, статус
eData.gapSendOrderStatus = false;

-- long = 'buy'
-- long = 'short'
eData.gap_direction = '';

eData.autoStartEngine = true;



eData.fractals_collection = {};
eData.fractal_up = 0;
eData.fractal_down = 0;
-- на какой свече была последняя операция по входу в рынок
eData.candles_operation_last = 0;
eData.range_down_price_candles = 0;

-- id линии высокой свечки на графике
eData.line_candle_height_label_id = 0;

-- id линии низкой свечки на графике
eData.line_candle_min_label_id = 0;

-- старые данные на свечке, для сравнения, максимум
eData.line_candle_height_old = 0;

-- старые данные на свечке, для сравнения, минимум
eData.line_candle_min_old = 0;
-- рисовать полоски максимума и минимума свечей
eData.line_candle_min_max_show = true;

-- сколько контрактов для разблокировки надо продать
eData.each_to_buy_to_block_contract = 0;

-- сколько продано 
eData.each_to_sell_to_block_contract = 0


-- была ли покупка или продажа
eData.gap_is_decision = false;
-- old price
eData.gap_old_price = 0;

-- price
eData.gap_offer_bid = 1;
-- price take
eData.gap_spred = 0;

-- short long
eData.gap_direction = '';

-- short long
eData.gap_send_price = 0;

return eData;