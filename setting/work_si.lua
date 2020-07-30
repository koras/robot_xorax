-- Перед тем чтоб робота перевести робота в боевой режим, посмотрите работу робота XoraX в режиме эмуляции
-- Следите за объёмом и рисками
-- Не гонитеь за большими заработками
-- Удачи...
-- @xorax <=> @koras
-- счёт клиента, как вариант его можно узнать в зваяках в таблице заявок
setting.ACCOUNT = '4105F8Y';

-- класс бумаги. У фьючерсов в основном он одинаков
setting.CLASS_CODE = "SPBFUT";

-- код бумаги. Название бумаги разная от месяца к месяцу 
setting.SEC_CODE = "SiU0";

-- тег графика, необходимо указывать в том графике из которого робот будет получать данные. 
-- график нужен в минутном таймфрейме(обязательно)
setting.tag = "my_si";

-- тип инструмента, каждый тип имеет свои настройки
-- 1 фьючерс
-- 2 акции на moex
setting.type_instrument = 3;

-- минимальная прибыль
setting.profit_range = 50;

-- минимальная прибыль при больших заявках при торговле веерной продажей
setting.profit_range_array = 35;
-- для веерной продажи. Какой промежуток между заявками
setting.profit_range_array_panel = 5;

-- изменение  минимальной прибыли в панели
setting.profit_range_panel = 1;

-- погрешность, необходимо для предотвращения проскальзывания при активной торговле
setting.profit_infelicity = 1;

-- подсчёт прибыли, считается после каждой продажи
setting.profit = 0;

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

setting.SPRED_LONG_BUY_UP = 2; -- условия; не покупаем если здесь ранее мы купили | вверх диапозон;
setting.SPRED_LONG_BUY_down = 1; -- условия; не покупаем если здесь ранее мы купили | вниз диапозон

setting.not_buy_high_UP = 400; -- условия; цена входа при запуске скрипта
setting.not_buy_high = 0; -- условия; Выше какого диапазона не покупать(на хаях)
setting.not_buy_high_change = 10; --  изменения в контрольеой панели

setting.take_profit_offset = 1;
setting.take_profit_spread = 1;

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
setting.fractal_down_range = 5; -- если цена ниже; значит здесб был уровень; а под уровнем не покупаем.
setting.fractal_candle = 3;
setting.fractal_under_up = 6; -- под вверхом не покупаем; можем пробить а цена не пойдёт в нашу сторону

-- сколько нужно подряд купить контрактов при падении рынка
-- что-бы заблокировать кнопку покупки
-- +1 покупка, блокировка покупок
setting.each_to_buy_to_block = 3; -- потом только решение за человеком или пока не будут проданы все позиции
setting.each_to_buy_step = 0; -- сколько подряд раз уже купили

setting.each_to_sell_step = 0; -- сколько подряд раз продали если кнопка была заблокирована автоматом.
setting.each_to_buy_status_block = false; -- сколько подряд раз уже купили

-- Последняя цена сделки по продаже констракта
setting.SPRED_LONG_LOST_SELL = 0;
-- рынок падает, увеличиваем растояние между покупками
setting.SPRED_LONG_TREND_DOWN = 10;
setting.SPRED_LONG_TREND_DOWN_SPRED = 20; -- на сколько увеличиваем растояние

-- рынок падает, увеличиваем растояние между покупками(минимальное число)
setting.SPRED_LONG_TREND_DOWN_minimal = 1;

-- какая последняя покупка была при падении
setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0; -- 
-- когда следующая покупка при падении
setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0;

-- минимильное измерение в инструменте 
setting.instrument_measurement = 1;

-- ### engine
-- На сколько прибавить к свече чтобы закупится ниже профита
setting.profit_add_candle = 0;
-- открыта или закрыта панель покупок
 

-- расстояние от максимальной покупки
-- зависимость от используемых контрактов
stopClass.spred = 50;
stopClass.spred_default = 50;
-- на сколько исзменять параметр в панели управления
stopClass.spred_limit = 11;

-- увеличение промежутка между стопами
stopClass.spred_range = 50;
stopClass.spred_range_default = 9;

-- на сколько исзменять параметр в панели управления
stopClass.spred_range_limit = 1;

-- сработал стоп или нет
-- если сработал стоп, то другие стопы не передигаем
-- число отвечающее на сколько отодвинуты стопы от первоначальной версии
stopClass.triger_stop = 0;
 
-- отвечает за расчёты в свечах

-- информация по свечам для анализа
setting.array_candle = {};

-- сколько свечей являются уходящими по тренду для расчёта общей динамики
engine.candle_range = 10;

-- какой средний промежуток в цене инструмента считается допустимый при расчёте формации
engine.candle_price_range = 5; -- для нефти например

-- какая высота должна быть, для того чтобы понять, текущий уровень высокий или низкий
-- минимальная высота в цене
engine.candle_price_max_hight = 5;

-- минутные свечи. используются для подсчёта 
setting.count_of_candle = 15;



 