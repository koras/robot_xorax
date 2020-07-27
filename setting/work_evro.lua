-- Перед тем чтоб робота перевести робота в боевой режим, посмотрите работу робота XoraX в режиме эмуляции
-- Следите за объёмом и рисками
-- Не гонитеь за большими заработками
-- Удачи...
-- @xorax <=> @koras
-- счёт клиента, как вариант его можно узнать в зваяках в таблице заявок
setting.ACCOUNT = 'Счёт';

-- класс бумаги. У фьючерсов в основном он одинаков
setting.CLASS_CODE = "SPBFUT";

-- код бумаги. Название бумаги разная от месяца к месяцу 
setting.SEC_CODE = "EDU0";

-- тег графика, необходимо указывать в том графике из которого робот будет получать данные. 
-- график нужен в минутном таймфрейме(обязательно)
setting.tag = "ed";

-- тип инструмента, каждый тип имеет свои настройки
-- 1 фьючерс
-- 2 акции на moex
setting.type_instrument = 1;

-- минимальная прибыль
setting.profit_range = 0.0005;

-- минимальная прибыль при больших заявках, не используется 
setting.profit_range_array = 0.0003;

-- изменение  минимальной прибыли в панели
setting.profit_range_panel = 0.0001;

-- минимальная прибыль при больших заявках, не используется 
setting.profit_range_array = 0.0002;

-- погрешность, необходимо для предотвращения проскальзывания при активной торговле
setting.profit_infelicity = 0.0001;

-- подсчёт прибыли, считается после каждой продажи
setting.profit = 0.00;

-- текущее время в свече, для внетреннего использования в роботе
setting.datetime = 0;

-- режим разработки, используется только для тестирования нового функционала
setting.developer = false;

-- лимит количества заявок на сессию работы робота.
setting.LIMIT_BID = 10;

-- сколько использовать контрактов по умолчанию в режиме скальпинга
setting.use_contract = 1;
-- включён или выключен режим эмуляции по умолчанию
setting.emulation = false;
setting.candles = {}; -- свечи

setting.status = false;
setting.buy = true;
setting.sell = true;
-- таблица заявок, здесь все заявки используемые в работе робота
setting.sellTable = {};
-- кнопка закрытия позиции
setting.close_positions = false;

setting.count_buyin_a_row = 0; -- покупок сколько было за торговую сессию
setting.count_buyin_a_row_emulation = 0; -- покупок сколько было за торговую сессию
setting.current_price = 0; -- текщая цена

-- сколько куплено раз
setting.count_buy = 0;
-- сколько продано раз
setting.count_sell = 0;

setting.count_contract_buy = 0; -- сколько куплено контрактов за сессию
setting.count_contract_sell = 0; -- сколько продано контрактов за сессию 

-- Выставлять контракт на продажу через тейки или лимитки
-- Если рыно слабо ходит то выгоднее лимитки. Так как при выставлении тейков, продаваться будет ниже, что не выгодно.
-- по умолчанию стоят тейки
setting.sell_take_or_limit = false;

setting.limit_count_buy = 0; -- лимит на покупку ( сколько контрактов купили на текущий момент )
-- setting.limit_count_buy_emulation = 0; -- лимит на покупку в эмуляции ( сколько контрактов купили на текущий момент )

setting.SPRED_LONG_BUY_UP = 0.0002; -- условия; не покупаем если здесь ранее мы купили | вверх диапозон;
setting.SPRED_LONG_BUY_down = 0.001; -- условия; не покупаем если здесь ранее мы купили | вниз диапозон

setting.not_buy_high_UP = 0.005; -- условия; цена входа при запуске скрипта
setting.not_buy_high = 0; -- условия; Выше какого диапазона не покупать(на хаях)
setting.not_buy_high_change = 0.0005; --  изменения в контрольеой панели

setting.take_profit_offset = 0.0001;
setting.take_profit_spread = 0.0001;

-- тип интервала на свече, обязательный параметр
setting.INTERVAL = INTERVAL_M1;

setting.number_of_candles = 0; -- current a candle
setting.old_number_of_candles = 0; -- old current candle

setting.number_of_candle = 0; -- current a candle
setting.old_number_of_candle = 0; -- old current candle

--  setting.buffer_old_candles_high = 0; -- current a candle
-- setting.buffer_old_candles_low = 0; -- old current candle

-- на какой свече была последняя покупка
setting.candles_buy_last = 0;
setting.candle_buy_number_down_price = 6; -- сколько свечей должно пройти чтобы отпустить продажу 
setting.range_down_price_candles = 0;

setting.fractals_collection = {};
setting.fractal_up = 0;
setting.fractal_down = 0;
setting.fractal_down_range = 0.0005; -- если цена ниже; значит здесб был уровень; а под уровнем не покупаем.
setting.fractal_candle = 3;
setting.fractal_under_up = 0.0006; -- под вверхом не покупаем; можем пробить а цена не пойдёт в нашу сторону

-- сколько нужно подряд купить контрактов при падении рынка
-- что-бы заблокировать кнопку покупки
-- +1 покупка, блокировка покупок
setting.each_to_buy_to_block = 3; -- потом только решение за человеком или пока не будут проданы все позиции
setting.each_to_buy_step = 0; -- сколько подряд раз уже купили

setting.each_to_sell_step = 0; -- сколько подряд раз продали если кнопка была заблокирована автоматом.
setting.each_to_buy_status_block = false; -- сколько подряд раз уже купили

-- Последняя цена сделки по продаже констракта
setting.SPRED_LONG_LOST_SELL = 0.00;
-- рынок падает, увеличиваем растояние между покупками
setting.SPRED_LONG_TREND_DOWN = 0.0001;
setting.SPRED_LONG_TREND_DOWN_SPRED = 0.0002; -- на сколько увеличиваем растояние

-- рынок падает, увеличиваем растояние между покупками(минимальное число)
setting.SPRED_LONG_TREND_DOWN_minimal = 0.0001;

-- какая последняя покупка была при падении
setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0.00; -- 
-- когда следующая покупка при падении
setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0.00;

-- минимильное измерение в инструменте 
setting.instrument_measurement = 0.0001;

-- ### engine
-- На сколько прибавить к свече чтобы закупится ниже профита
setting.profit_add_candle = 0.0;
-- открыта или закрыта панель покупок

setting.comment_quik = 'Robot XoraX';

-- Использовать стопы или нет, по умолчанию да
stopClass.use_stop = true;
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

-- расстояние от максимальной покупки
-- зависимость от используемых контрактов
stopClass.spred = 0.01;
stopClass.spred_default = 0.0004;
-- на сколько исзменять параметр в панели управления
stopClass.spred_limit = 0.0011;

-- увеличение промежутка между стопами
stopClass.spred_range = 0.1;
stopClass.spred_range_default = 0.09;

-- на сколько исзменять параметр в панели управления
stopClass.spred_range_limit = 0.0001;

-- сработал стоп или нет
-- если сработал стоп, то другие стопы не передигаем
-- число отвечающее на сколько отодвинуты стопы от первоначальной версии
stopClass.triger_stop = 0;

-- обновили максимальную цену, передвигаем стоп, сбрасываем тригер на обновление
stopClass.triger_update_up = true;

-- стоп заявки
stopClass.array_stop = {};
stopClass.array_stop.work = 0;
stopClass.array_stop.order_num = 0;
stopClass.array_stop.trans_id = 0;
stopClass.array_stop.price = 0;
stopClass.array_stop.stop_number = 0;
-- обновление стопов
stopClass.update = true;

-- отвечает за расчёты в свечах

-- информация по свечам для анализа
setting.array_candle = {};

-- сколько свечей являются уходящими по тренду для расчёта общей динамики
engine.candle_range = 10;

-- какой средний промежуток в цене инструмента считается допустимый при расчёте формации
engine.candle_price_range = 0.0005; -- для нефти например

-- какая высота должна быть, для того чтобы понять, текущий уровень высокий или низкий
-- минимальная высота в цене
engine.candle_price_max_hight = 0.005;

-- минутные свечи. используются для подсчёта 
setting.count_of_candle = 5;

-- второй минимум
setting.low_formacia = {};

setting.candle_test = 0;

setting.candle_current_high = 0.00; -- верхняя граница свечи; для промежутка покупки
setting.candle_current_low = 0.00; -- верхняя граница свечи; для промежутка покупки

setting.old_candle_price_high = 0.00; -- верхняя граница свечи; для промежутка покупки
setting.old_candle_price_low = 0.00; -- верхняя граница свечи; для промежутка покупки

-- На какой свече была оследняя покупка
-- это надо для понимания роботом, что покупка была давно
-- Если покупка была давно, то робот начнёт уменьшать спред последней покупки
setting.last_buy_candle = 0;

-- открыта, закрыта панель покупок
stopClass.show_panel_bue_sell = false;

-- версия продукта 
setting.version = "0.1.132";

setting.use_windows = false;

-- примерное время работы, пока не используется
setting.timeWork = {{'10:00', '14:00'}, {'14:05', '18:45'}, {'19:00', '23:50'}};

setting.closed_buy = {
    {'13:00', '14:00'}, {'18:00', '19:02'}, {'22:55', '23:55'}
};


-- https://open-broker.ru/pricing-plans/
