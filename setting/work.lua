   setting.profit_range =  0.01; -- минимальная прибыль
   setting.profit_range_array =  0.03; -- минимальная прибыль при больших заявках
   setting.profit_infelicity =  0.01; -- погрешность
   
   setting.profit =  0.01; -- подсчёт прибыли

   setting.LIMIT_BID = 10;
   setting.use_contract = 1;
   setting.emulation = true;
   setting.candles = {}; -- свечи
         
   setting.status = false;
   setting.buy = true;
   setting.sell = true;
   setting.sellTable = {};
   setting.close_positions = false; 
          
   setting.count_buyin_a_row =  0; -- покупки подряд
   setting.current_price =  0; -- покупки подряд
         
   setting.count_buy = 0; -- сколько куплено
   setting.count_sell = 0; -- сколько продано
   setting.limit_count_buy = 0; -- лимит на покупку
          
   setting.SPRED_LONG_BUY_UP = 0.02; -- условия; не покупаем если здесь ранее мы купили | вверх диапозон;
   setting.SPRED_LONG_BUY_down = 0.01; -- условия; не покупаем если здесь ранее мы купили | вниз диапозон
          
         
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
