 

   setting.profit_range =  0.05; -- минимальная прибыль
   setting.profit_range_array =  0.03; -- минимальная прибыль при больших заявках
   setting.profit_infelicity =  0.01; -- погрешность
   
   setting.profit =  0.00; -- подсчёт прибыли

   setting.datetime =  0; -- подсчёт прибыли




   setting.LIMIT_BID = 10;
   setting.LIMIT_BID_emulation = 10;



   setting.use_contract = 1;
   setting.emulation = true;
   setting.candles = {}; -- свечи
         
   setting.status = false;
   setting.buy = true;
   setting.sell = true;
   setting.sellTable = {};
   setting.close_positions = false; 
          
   setting.count_buyin_a_row =  0; -- покупок сколько было за торговую сессию
   setting.count_buyin_a_row_emulation =  0; -- покупок сколько было за торговую сессию
   setting.current_price =  0; -- текщая цена
         
   setting.count_buy = 0; -- сколько куплено раз
   setting.count_sell = 0; -- сколько продано раз
   setting.emulation_count_buy = 0; -- сколько куплено раз (режим эмуляции) 
   setting.emulation_count_sell = 0; -- сколько продано раз (режим эмуляции)


   setting.count_contract_buy = 0; -- сколько куплено контрактов за сессию
   setting.count_contract_sell = 0; -- сколько продано контрактов за сессию
  -- setting.emulation_count_contract_buy = 0; -- сколько куплено контрактов за сессию (режим эмуляции) 
  --  setting.emulation_count_contract_sell = 0; -- сколько продано контрактов за сессию (режим эмуляции)



    -- Выставлять контракт на продажу через тейки или лимитки
    -- Если рыно слабо ходит то выгоднее лимитки. Так как при выставлении тейков, продаваться будет ниже, что не выгодно.
    -- по умолчанию стоят тейки
   setting.sell_take_or_limit = false;





   setting.limit_count_buy = 0; -- лимит на покупку ( сколько контрактов купили на текущий момент )
   setting.limit_count_buy_emulation = 0; -- лимит на покупку в эмуляции ( сколько контрактов купили на текущий момент )
          
   setting.SPRED_LONG_BUY_UP = 0.02; -- условия; не покупаем если здесь ранее мы купили | вверх диапозон;
   setting.SPRED_LONG_BUY_down = 0.01; -- условия; не покупаем если здесь ранее мы купили | вниз диапозон

   setting.not_buy_high_UP = 1; -- условия; цена входа при запуске скрипта
   setting.not_buy_high = 36.85; -- условия; Выше какого диапазона не покупать(на хаях)



   setting.take_profit_offset = 0.01;   
   setting.take_profit_spread = 0.01;  
          
 
   setting.INTERVAL = INTERVAL_M1;
         
   setting.number_of_candles = 0; -- current a candle
   setting.old_number_of_candles = 0; -- old current candle
         
   setting.number_of_candle = 0; -- current a candle
   setting.old_number_of_candle = 0; -- old current candle
       
   setting.buffer_old_candles_high = 0; -- current a candle
   setting.buffer_old_candles_low = 0; -- old current candle




   setting.candles_buy_last = 0; -- на какой свече была последняя покупка
   setting.candle_buy_number_down_price = 6; -- сколько свечей должно пройти чтобы отпустить продажу 
   setting.range_down_price_candles = 0;


   setting.fractals_collection = {};
   setting.fractal_up = 0;
   setting.fractal_down = 0;
   setting.fractal_down_range = 0.05; -- если цена ниже; значит здесб был уровень; а под уровнем не покупаем.
   setting.fractal_candle = 3;
   setting.fractal_under_up = 0.06; -- под вверхом не покупаем; можем пробить а цена не пойдёт в нашу сторону

          
   setting.candle_current_high = 0.00; -- верхняя граница свечи; для промежутка покупки
   setting.candle_current_low = 0.00; -- верхняя граница свечи; для промежутка покупки



   setting.old_candle_price_high = 0.00; -- верхняя граница свечи; для промежутка покупки
   setting.old_candle_price_low = 0.00; -- верхняя граница свечи; для промежутка покупки


   -- сколько нужно подряд купить контрактов при падении рынка
   -- что-бы заблокировать кнопку покупки
   -- +1 покупка, блокировка покупок
   setting.each_to_buy_to_block = 3; -- потом только решение за человеком или пока не будут проданы все позиции
   setting.each_to_buy_step = 0; -- сколько подряд раз уже купили

   setting.each_to_sell_step = 0; -- сколько подряд раз продали если кнопка была заблокирована автоматом.
   setting.each_to_buy_status_block = false; -- сколько подряд раз уже купили



   setting.SPRED_LONG_LOST_SELL = 0.00; -- Последняя цена сделки по продаже констракта
   setting.SPRED_LONG_TREND_DOWN = 0.01;  -- рынок падает, увеличиваем растояние между покупками
   setting.SPRED_LONG_TREND_DOWN_SPRED = 0.02; -- на сколько увеличиваем растояние

   setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0.00; -- 

   setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0.00; -- когда следующая покупка при падении

   setting.timeWork =  {
            { '10:00', '14:00'};
            { '14:05', '18:45'}; 
            { '19:00', '23:50'}
         };   
         
   setting.closed_buy =  {
            { '13:00', '14:00'};
            { '18:00', '19:02'}; 
            { '22:55', '23:55'}
         };
