-- Скрипт выводит в таблицу QLua баланс покупок/продаж
-- последних 5-ти 1-минутных свечей,
-- окрашивая ячейку в красный если больше продаж,
-- в зеленый, если больше покупок
-- и в желтый, если покупок и продаж было равное количество
-- (c) QuikLuaCSharp.ru

CLASS_CODE				= "SPBFUT";				-- Класс бумаги
SEC_CODE				   = "GZH8";				-- Код бумаги

IsRun = true;

Array5Min = {};      -- Создает массив для хранения баланса покупок/продаж на последних 5-ти 1-минутных свечах 

LastBarSeconds = 0;  -- Время последнего бара в секундах

function main()
   -- Создает таблицу
 --  CreateNewTable();
   
   -- Основной цикл
	while IsRun do
      sleep(1);
   end;
end;

--- Функция создает таблицу
function CreateNewTable()
	-- Получает доступный id для создания
	t_id = AllocTable();	
	-- Добавляет 5 колонок
	AddColumn(t_id, 0, "1", true, QTABLE_INT_TYPE, 15);
	AddColumn(t_id, 1, "2", true, QTABLE_INT_TYPE, 15);
   AddColumn(t_id, 2, "3", true, QTABLE_INT_TYPE, 15);
   AddColumn(t_id, 3, "4", true, QTABLE_INT_TYPE, 15);
 --  AddColumn(t_id, 4, "5", true, QTABLE_INT_TYPE, 15);
	-- Создаем
	t = CreateWindow(t_id);
	-- Даем заголовок	
	SetWindowCaption(t_id, "Баланс покупок/продаж");
   -- Добавляет строку
	InsertRow(t_id, -1);
end;
--- Функции по раскраске ячеек таблицы
function Red(col)
	SetColor(t_id, 1, col, RGB(255,0,0), RGB(0,0,0), RGB(255,0,0), RGB(0,0,0));
end;
function Yellow(col)
	SetColor(t_id, 1, col, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0));
end;
function Green(col)
	SetColor(t_id, 1, col, RGB(0,200,0), RGB(0,0,0), RGB(0,200,0), RGB(0,0,0));
end;

--- Добавляет/сдвигает ячейки массива при появлении нового минутного бара, корректирует значения и окраску ячеек таблицы	
function AddNewBarToArray5Min()	
	table.insert(Array5Min, 0);
	-- Если размер массива стал больше 5, удаляет первый элемент	
	if #Array5Min > 5 then table.remove(Array5Min, 1); end; -- (# - длина массива)   
   -- Цикл по элементам массива
   local Offset = 5 - #Array5Min; -- Сдвиг ячеек, если еще нет данных по всем 5-ти барам
   for i = 1, #Array5Min do
      -- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет
      SetBalance(Array5Min[i], i + Offset - 1);
   end;
end

--- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет, редактирует значение массива
function SetBalance(NewBalance, NumCol)   
   SetCell(t_id, 1, NumCol, tostring(NewBalance));
   -- Если устанавливается значение последней ячейки
   if NumCol == 4 then 
      -- То корректируется значение в массиве
      Array5Min[#Array5Min] = NewBalance; 
   end;
   -- Если новое значение < 0, окрашивает в КРАСНЫЙ
   if NewBalance < 0 then Red(NumCol); end;
   -- Если новое значение = 0, окрашивает в ЖЕЛТЫЙ
   if NewBalance == 0 then Yellow(NumCol); end;
   -- Если новое значение > 0, окрашивает в ЗЕЛЕНЫЙ
   if NewBalance > 0 then Green(NumCol); end;
end;

--- Если началась новая минута, корректирует время последнего бара и возвращает TRUE, иначе FALSE 
function CheckNewMin(DealDateTime)   
   -- Переводит время поступившей сделки в секунды (в расчет берется время сделки до минут) 
   DealDateTime.sec = 0;
   DealDateTime.mcs = 0;
   local Seconds = os.time(DealDateTime);   
   -- Если сделка прошла на новом минутном баре
   if Seconds > LastBarSeconds then      
      -- Корректирует время последнего бара
      LastBarSeconds = Seconds;
      -- Возвращает TRUE
      return(true);
   else -- Иначе возвращает FALSE
      return(false);
   end;
end;

--- Функция вызывается терминалом QUIK при получении обезличенной сделки.
function OnAllTrade(alltrade)
	-- Если сделка по нужному инструменту
   if alltrade.sec_code == SEC_CODE then
      -- Если началась новая минута, корректирует время последнего бара и возвращает TRUE, иначе FALSE
      if CheckNewMin(alltrade.datetime) then 
         -- Добавляет/сдвигает ячейки массива при появлении нового минутного бара, корректирует значения и окраску ячеек таблицы	
         AddNewBarToArray5Min();
         -- Если сделка на продажу, вычитает объем из текущего 
         if bit.test(alltrade.flags, 0) then
            -- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет
            SetBalance(Array5Min[#Array5Min] - alltrade.qty, 4);
         else -- Если сделка на покупку, прибавляет объем к текущему
            -- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет
            SetBalance(Array5Min[#Array5Min] + alltrade.qty, 4);
         end;
      else -- Сделка в текущей минуте
         -- Если сделка на продажу, вычитает объем из текущего 
         if bit.test(alltrade.flags, 0) then
            -- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет
            SetBalance(Array5Min[#Array5Min] - alltrade.qty, 4);
         else -- Если сделка на покупку, прибавляет объем к текущему
            -- Устанавливает в определенную ячейку новое значение и окрашивает ее в соответствующий цвет
            SetBalance(Array5Min[#Array5Min] + alltrade.qty, 4);
         end;
      end;		
	end;
end

-- Функция вызывается когда пользователь останавливает скрипт
function OnStop()
   IsRun = false;
end;