-- сюда перенесены настройки которые необходимы во всём роботе но для каждого инструмента они разные
-- но от инструмента к инструменту они не меняются
-- версия продукта 
setting.version = "0.2.12";

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

-- минимальная цена контракта на продажу среди установленных заявок
setting.price_min_sell = 0
-- максимальная цена контракта на продажу среди установленных заявок
setting.price_max_sell = 0

-- минимальная цена купленного ранее контракта
setting.price_min_buy = 0
-- максимальная цена купленного ранее контракта
setting.price_max_buy = 0

-- подсчёт прибыли, считается после каждой продажи
setting.profit = 0.00;

-- текущее время в свече, для внетреннего использования в роботе
setting.datetime = 0;

-- режим разработки, используется только для тестирования нового функционала
setting.developer = false;

-- кнопка закрытия позиции
setting.close_positions = false;

setting.count_buyin_a_row = 0; -- покупок сколько было за торговую сессию
setting.current_price = 0; -- текщая цена

-- сколько куплено раз
setting.count_buy = 0;
-- сколько продано раз
setting.count_sell = 0;

setting.count_contract_buy = 0; -- сколько куплено контрактов за сессию
setting.count_contract_sell = 0; -- сколько продано контрактов за сессию 

-- тип интервала на свече, обязательный параметр
setting.INTERVAL = INTERVAL_M1;

setting.number_of_candles = 0; -- current a candle
setting.old_number_of_candles = 0; -- old current candle

setting.number_of_candle_init = true

-- сработал стоп или нет
-- если сработал стоп, то другие стопы не передигаем
-- число отвечающее на сколько отодвинуты стопы от первоначальной версии
stopClass.triger_stop = 0;

-- отвечает за расчёты в свечах
-- информация по свечам для анализа
setting.array_candle = {};

-- На сколько прибавить к свече чтобы закупится ниже профита
setting.profit_add_candle = 0;
-- открыта или закрыта панель покупок

-- максимальная цена в заявке
stopClass.price_max = 0;
-- минимальная цена в  заявке
stopClass.price_min = 10000000;

-- количество контрактов в работе
stopClass.contract_work = 0;

-- количество контрактов добавленных трейдером
stopClass.contract_add = 0;

-- какая последняя покупка была при падении
setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0; -- 
-- когда следующая покупка при падении
setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0;

setting.each_to_buy_step = 0; -- сколько подряд раз уже купили
 
setting.each_to_buy_status_block = false; -- сколько подряд раз уже купили

-- Последняя цена сделки по продаже констракта
setting.SPRED_LONG_LOST_SELL = 0;
 

-- Последняя цена сделки по продаже констракта
setting.SPRED_LONG_LOST_SELL = 0.00;

-- условия; Выше какого диапазона не покупать(на хаях)
setting.not_buy_high = 0

-- условия; ниже  какого диапазона не покупать(на хаях)
setting.not_buy_low = 0

-- лимит на покупку ( сколько контрактов купили на текущий момент )
setting.limit_count_buy = 0

-- текущее время в свече, для внетреннего использования в роботе
setting.datetime = 0;

-- режим разработки, используется только для тестирования нового функционала
setting.developer = false;

setting.candles = {}; -- свечи

setting.status = false;
setting.buy = true;
setting.sell = true;
-- таблица заявок, здесь все заявки используемые в работе робота
setting.sellTable = {};

-- long = 'buy'
-- long = 'sell'
setting.mode = 'buy'


setting.fractals_collection = {};
setting.fractal_up = 0;
setting.fractal_down = 0;
-- на какой свече была последняя операция по входу в рынок
setting.candles_operation_last = 0;
setting.range_down_price_candles = 0;

-- id линии высокой свечки на графике
setting.line_candle_height_label_id = 0;

-- id линии низкой свечки на графике
setting.line_candle_min_label_id = 0;

-- старые данные на свечке, для сравнения, максимум
setting.line_candle_height_old = 0;

-- старые данные на свечке, для сравнения, минимум
setting.line_candle_min_old = 0;
-- рисовать полоски максимума и минимума свечей
setting.line_candle_min_max_show = true;

-- сколько контрактов для разблокировки надо продать
setting.each_to_buy_to_block_contract = 0;

-- сколько продано 
setting.each_to_sell_to_block_contract = 0

