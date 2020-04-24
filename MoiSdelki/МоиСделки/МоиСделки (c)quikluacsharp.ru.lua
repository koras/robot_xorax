Settings={}
Settings['Идентификатор графика *'] = '';          -- Тэг графика
Settings['Счет'] = 'Авто';                         -- Торговый счет
Account = 'Авто';                        
Settings['Цифра в треугольниках'] = '';            -- Номер иконок ('' без номера)
NumberInTriangles = -1;
Settings.Name = 'МоиСделки (c)quikluacsharp.ru';   -- Имя индикатора
Settings['Незакрытых сделок max'] = '20';          -- Максимальное количество одновременно открытых сделок 
OpenedTradesMAX = 0;
LinesWidth = 2; -- Толщина линий, соединяющих сделки
-- Информация о занятости линий (значение - последняя свеча)
CloseProfitLine = {};
CloseLossLine = {};

-- Массив значений всех линий на всех свечах
LineValue = {};

TradesFile = nil; -- Файл истории сделок по данному инструменту

Labels = {};      -- Массив номеров установленных меток
Trades = {};      -- Масиив сделок

SEC_CODE = "";    -- Инструмент графика
DSInfo = nil;     -- Информация об источнике данных (таблица)

FirstDrawComlete = false; -- Флаг, что все отрисовано по последнему индексу (после загрузки индикатора на график)
NewTrade = false; -- Флаг, поступила новая сделка

TradesFilePath = ''; -- Полный путь к папке "Данные(c)quikluacsharp.ru"

InitComplete = true;

LastSecond = 0;

function Init()    
   -- Валидация параметров
   OpenedTradesMAX = tonumber(Settings['Незакрытых сделок max']);
   -- Проверяет, чтобы количество линий было числом
   if type(OpenedTradesMAX) ~= 'number' then OpenedTradesMAX = 20; message('Индикатор "Мои Сделки": Значение параметра "Незакрытых сделок max" должно быть числом, по этому было исправлено на число 20.'); end;
   -- Проверяет, чтобы количество линий было положительным числом, больше нуля
   if OpenedTradesMAX <= 0 then OpenedTradesMAX = 20; message('Индикатор "Мои Сделки": Значение параметра "Незакрытых сделок max" должно быть положительным числом, больше нуля, по этому было исправлено на число 20.'); end;
   -- Проверяет, чтобы количество линий было четным
   if OpenedTradesMAX%2 > 0 then OpenedTradesMAX = OpenedTradesMAX/2 - OpenedTradesMAX%2 + 1;  message('Индикатор "Мои Сделки": Значение параметра "Незакрытых сделок max" должно быть четным числом, по этому было исправлено на число '..OpenedTradesMAX..'.');end;
   
   -- Создает нужные линии
   Settings.line = {};
   for i=0,OpenedTradesMAX/2-1,1 do
      -- Линия прибыльных сделок
      Settings.line[i*2+1] = {}
      Settings.line[i*2+1].Name = "Закрытая прибыльная "..tostring(i+1);
      Settings.line[i*2+1].Color = RGB(0, 220, 0);
      Settings.line[i*2+1].Width = LinesWidth;
      Settings.line[i*2+1].Type = TYPE_POINT;
      -- Линия убыточных сделок
      Settings.line[i*2+2] = {}
      Settings.line[i*2+2].Name = "Закрытая убыточная "..tostring(i+1);
      Settings.line[i*2+2].Color = RGB(255, 0, 0);
      Settings.line[i*2+2].Width = LinesWidth;
      Settings.line[i*2+2].Type = TYPE_POINT;
   end;
   LastSecond = os.time();
	return OpenedTradesMAX;
end;

function OnCalculate(idx)
   if not InitComplete then return; end;
   local ArrIdx = {};
   if idx == 1 then -- В начале рассчетов  
      DSInfo = getDataSourceInfo(); -- Получает информацию об источнике данных     
      FirstDrawComlete = false;
      -- Валидация параметров
      if Settings['Идентификатор графика *'] == '' then
         message('Индикатор "Мои Сделки": Предупреждение!!! Вы забыли указать "Идентификатор графика", индикатор не будет помечать сделки треугольниками!');
      else
         -- Проверяет существование указанного идентификатора в терминале
         local label_params = {};
         label_params['TEXT'] = Settings['Идентификатор графика *']; -- STRING Подпись метки (если подпись не требуется, то пустая строка)        
         label_params['YVALUE'] = O(idx); -- DOUBLE Значение параметра на оси Y, к которому будет привязана метка
         local Y = '';local m = '';local d = '';
         d,m,Y = string.match(tostring(getInfoParam('TRADEDATE')),"(%d*).(%d*).(%d*)");   
         if #d == 1 then d = "0"..d end   
         if #m == 1 then m = "0"..m end
         label_params['DATE'] = tonumber(Y..m..d); -- DOUBLE Дата в формате «ГГГГММДД», к которой привязана метка           
         label_params['TIME'] = 120000; -- DOUBLE Время в формате «ЧЧММСС», к которому будет привязана метка  
         local LabelID = AddLabel(Settings['Идентификатор графика *'], label_params);
         if LabelID == nil then
            message('Индикатор "Мои Сделки": Предупреждение!!! "Идентификатор графика" указан не верно, индикатор не будет помечать сделки треугольниками!');
         else
            DelLabel(Settings['Идентификатор графика *'], LabelID);
         end;
      end;
      if Settings['Цифра в треугольниках'] == '' then NumberInTriangles = -1; else NumberInTriangles = tonumber(Settings['Цифра в треугольниках']); end;
      if type(NumberInTriangles) ~= 'number' then NumberInTriangles = -1; message('Индикатор "Мои Сделки": Предупреждение!!! Номер иконок может быть от 0 до 9, либо без номера. Значение очищено!'); end;
      if NumberInTriangles < -1 or NumberInTriangles > 9 then message('Индикатор "Мои Сделки": Предупреждение!!! Номер иконок может быть от 0 до 9, либо без номера. Значение очищено!'); end;
      -- Валидация счета
      Account = Settings['Счет'];
      -- Находит идентификаторы счетов клиента для торговли данным инструментом
      AccountIndexes = SearchItems("trade_accounts", 0, getNumberOf("trade_accounts")-1, AccountFinded);
      -- Если в терминале не существует счет, по которому разрешена торговля данным инструментом
      if #AccountIndexes == 0 then
         message('Индикатор "Мои Сделки": ОШИБКА!!! Не найден счет, по которому разрешена торговля данным инструментом! Индикатор не функцианирует!'); InitComplete = false; 
      -- Если 'Авто'
      elseif Account == 'Авто' then
         -- Назначает индикатору найденный счет
         Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
      -- Если пользователь ввел идентификатор счета
      else
         -- Проверяет существование такого счета в терминале
         local Finded = false;
         for i = 0,getNumberOf("trade_accounts") - 1 do
            if getItem("trade_accounts", i).trdaccid == Account then Finded = true; break; end;
         end;
         -- Если такой счет не существует в терминале
         if not Finded then
            -- Назначает индикатору найденный счет
            Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
            message('Индикатор "Мои Сделки": Предупреждение!!! Указанный Вами счет не найден в списке счетов терминала, индикатору назначен счет по умолчанию для данного инструмента!');
         -- Если такой счет существует в терминале
         else
            -- Проверяет разрешена ли по этому счету торговля данным инструментом
            local Finded = false;
            for i=1,#AccountIndexes do
               -- Если указанный счет находится в списке найденных счетов
               if Account == getItem('trade_accounts', AccountIndexes[i]).trdaccid then Finded = true; break; end;
            end;
            if not Finded then
               message('Индикатор "Мои Сделки": Предупреждение!!! Указанный Вами счет не допускает торговли по данному инструменту, индикатору назначен счет по умолчанию для данного инструмента!');
               -- Назначает индикатору найденный счет
               Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
            end;
         end;
      end;
      
      if not InitComplete then return; end;
      
      -- Получает полный путь к папке "Данные(c)quikluacsharp.ru"
      TradesFilePath = getWorkingFolder().."\\Данные(c)quikluacsharp.ru\\"..Account.."\\"..DSInfo.sec_code..".csv";
      -- Открывает/создает файл сделок по текущему инструменту
      OpenOrCreateFile();
      
      ReadTradesHistoryFile(); -- Читает из открытого файла существующие сделки в массив      
      CheckNewTradesInFile(); -- Отслеживает появление новых сделок в файле, записывает их в массив и вызывает перерисовку
      DrawTrades();  -- Выводит сделки из массива на график       
      SetLinesValues(); -- Устанавливает значения для всех индексов линий
   end;
   -- Проверяет появление новой сделки не чаще 1 раза в секунду
   if os.time() > LastSecond or not FirstDrawComlete then
      LastSecond = os.time();
      if idx == Size() then
         CheckNewTradesInFile();
         if not FirstDrawComlete then         
            DrawTrades(); -- Выводит сделки из массива на график
            SetLinesValues(); -- Устанавливает значения для всех индексов линий
            FirstDrawComlete = true;
         end;
         -- Если пришла новая сделка, перерисовывает индикатора
         if NewTrade then
            SetLinesValues(); -- Устанавливает значения для всех индексов линий
            DrawTrades(); -- Выводит сделки из массива на график
            for i=1,Size()-1,1 do
               for j=1,OpenedTradesMAX*2,1 do
                  SetValue(i, j, LineValue[i][j]);
               end;
            end;
            NewTrade = false;
         end;
      end;   
      
      if #LineValue >= idx then 
         ArrIdx = LineValue[idx];
         return unpack(ArrIdx);         
      end;
   else
      return;
   end;
end;

-- Проверяет разрешена ли по переданному счету торговля по инструменту графика
function AccountFinded(trade_account)
   for str in trade_account.class_codes:gmatch("[^\|]+") do
      if str == DSInfo.class_code then return true; end;       
   end;
   return false;
end;

-- Открывает/создает файл сделок по текущему счету и текущему инструменту
function OpenOrCreateFile()   
   -- Пытается открыть файл текущего инструмента в режиме "чтения"
   TradesFile = io.open(TradesFilePath,"r");
   -- Если файл не существует
   if TradesFile == nil then 
      -- Создает файл в режиме "записи"
      TradesFile = io.open(TradesFilePath,"w");
      -- Закрывает файл
      TradesFile:close();
      -- Открывает уже существующий файл в режиме "чтения"
      TradesFile = io.open(TradesFilePath,"r");
   end;
end;

-- Читает из открытого файла существующие сделки в массив
function ReadTradesHistoryFile()
   -- Встает в начало файла
   TradesFile:seek('set',0);
   -- Перебирает строки файла, считывает содержимое в массив сделок
   local Count = 0; -- Счетчик строк
   for line in TradesFile:lines() do
      Count = Count + 1;
      if Count > 1 and line ~= "" then
         NewTrade = true;
         Trades[Count-1] = {};
         local i = 0; -- счетчик элементов строки
         for str in line:gmatch("[^;^\n]+") do
            i = i + 1;
            if i == 3 then Trades[Count-1].Num = tonumber(str);
            elseif i == 4 then Trades[Count-1].Date = tonumber(str);
            elseif i == 5 then Trades[Count-1].Time = tonumber(str);
            elseif i == 6 then Trades[Count-1].Operation = str;
            elseif i == 7 then Trades[Count-1].Qty = tonumber(str);
            elseif i == 8 then Trades[Count-1].Price = tonumber(str);
            elseif i == 9 then Trades[Count-1].Hint = str; Trades[Count-1].OpenCount = Trades[Count-1].Qty;
            end; 
         end;
      end;
   end; 
end;

-- Отслеживает появление новых сделок в файле, записывает их в массив, устанавливает флаг NewTrade
function CheckNewTradesInFile()
   -- Встает в начало файла
   TradesFile:seek('set',0);
   -- Перебирает строки файла
   local Count = 0; -- Счетчик строк
   for line in TradesFile:lines() do
      Count = Count + 1;      
      if Count > 1 and line ~= "" then
         if Count > #Trades + 1 then
            -- Найдена новая сделка         
            NewTrade = true;
            -- Добавляет новую сделку в массив
            Trades[Count-1] = {};
            local i = 0; -- счетчик элементов строки
            for str in line:gmatch("[^;^\n]+") do
               i = i + 1;
               if i == 3 then Trades[#Trades].Num = tonumber(str);
               elseif i == 4 then Trades[#Trades].Date = tonumber(str);
               elseif i == 5 then Trades[#Trades].Time = tonumber(str);
               elseif i == 6 then Trades[#Trades].Operation = str;
               elseif i == 7 then Trades[#Trades].Qty = tonumber(str);
               elseif i == 8 then Trades[#Trades].Price = tonumber(str);
               elseif i == 9 then Trades[#Trades].Hint = str; Trades[#Trades].OpenCount = Trades[#Trades].Qty;
               end; 
            end;
         end;
      end;
   end;
end;

-- Выводит сделки из массива на график
function DrawTrades()
   -- Удаляет предыдущие метки
   if #Labels > 0 then -- Удаляет ранееустановленные метки
      for i=1,#Labels,1 do
         DelLabel(Settings['Идентификатор графика *'], Labels[i]);
      end;
      Labels = {};
   end;
   -- Работает с временными переменными сделок
   TradesTmp = {{}};
   TradesTmp = Trades;
   -- Перебирает массив сделок
   if #TradesTmp > 0 then
      -- Ставит метки сделок
      for j=1,#TradesTmp,1 do
         local label_params = {};
         label_params['TEXT'] = ''; -- STRING Подпись метки (если подпись не требуется, то пустая строка)         
         if TradesTmp[j].Operation == "B" then             
            if NumberInTriangles == -1 then
               label_params['IMAGE_PATH'] = getScriptPath()..'\\Изображения\\МоиСделки_buy.bmp'; -- STRING Путь к картинке, которая будет отображаться в качестве метки (пустая строка, если картинка не требуется)  
            else
               local PicPath = getScriptPath()..'\\Изображения\\МоиСделки_buy'..NumberInTriangles..'.bmp';
               label_params['IMAGE_PATH'] = PicPath;
            end;
            label_params['ALIGNMENT'] = 'BOTTOM'; -- STRING Расположение картинки относительно текста (возможно 4 варианта: LEFT, RIGHT, TOP, BOTTOM)  
         else 
            if NumberInTriangles == -1 then
               label_params['IMAGE_PATH'] = getScriptPath()..'\\Изображения\\МоиСделки_sell.bmp'; -- STRING Путь к картинке, которая будет отображаться в качестве метки (пустая строка, если картинка не требуется)  
            else
               local PicPath = getScriptPath()..'\\Изображения\\МоиСделки_sell'..NumberInTriangles..'.bmp';
               label_params['IMAGE_PATH'] = PicPath;
            end;
            label_params['ALIGNMENT'] = 'TOP'; -- STRING Расположение картинки относительно текста (возможно 4 варианта: LEFT, RIGHT, TOP, BOTTOM)  
         end;         
         label_params['YVALUE'] = TradesTmp[j].Price; -- DOUBLE Значение параметра на оси Y, к которому будет привязана метка  
         label_params['DATE'] = TradesTmp[j].Date; -- DOUBLE Дата в формате «ГГГГММДД», к которой привязана метка  
         label_params['TIME'] = TradesTmp[j].Time; -- DOUBLE Время в формате «ЧЧММСС», к которому будет привязана метка  
         label_params['R'] = 0; -- DOUBLE Красная компонента цвета в формате RGB. Число в интервале [0;255]  
         label_params['G'] = 0; -- DOUBLE Зеленая компонента цвета в формате RGB. Число в интервале [0;255]  
         label_params['B'] = 0; -- DOUBLE Синяя компонента цвета в формате RGB. Число в интервале [0;255]  
         label_params['TRANSPARENCY'] = 0; -- DOUBLE Прозрачность метки в процентах. Значение должно быть в промежутке [0; 100]  
         label_params['TRANSPARENT_BACKGROUND'] = 1; -- DOUBLE Прозрачность метки. Возможные значения: «0» – прозрачность отключена, «1» – прозрачность включена  
         label_params['FONT_FACE_NAME'] = 'Verdana'; -- STRING Название шрифта (например «Arial»)  
         label_params['FONT_HEIGHT'] = 14; -- DOUBLE Размер шрифта  
         label_params['HINT'] = TradesTmp[j].Hint:gsub("_", "\n"); -- STRING Текст подсказки
         
         local LabelID = AddLabel(Settings['Идентификатор графика *'], label_params);
         if LabelID ~= nil then Labels[#Labels+1] = LabelID; end;
      end;
   end;
end;

-- Устанавливает значения для всех индексов линий
function SetLinesValues()
   -- Обнуляет все линии по всем индексам
   for i=0,OpenedTradesMAX/2-1,1 do
      CloseProfitLine[i*2+1] = 0;
      CloseLossLine[i*2+2] = 0;
   end;
   -- Работает с временными переменными сделок
   local TradesTmp = {};
   for i=1,#Trades,1 do
      TradesTmp[i] = {};
      TradesTmp[i].Num = Trades[i].Num; 
      TradesTmp[i].Date = Trades[i].Date; 
      TradesTmp[i].Time = Trades[i].Time;
      TradesTmp[i].Operation = Trades[i].Operation;
      TradesTmp[i].Qty = Trades[i].Qty;
      TradesTmp[i].Price = Trades[i].Price;
      TradesTmp[i].OpenCount = Trades[i].Qty;
   end;
   -- Перебирает массив сделок
   if #TradesTmp > 0 then
      -- Устанавливает индексы свечей сделок
      for j=1,#TradesTmp,1 do
         for l=1,Size(),1 do
            if l < Size() then
               local Date = tonumber(T(l+1).year);
               local month = tostring(T(l+1).month);
               if #month == 1 then Date = Date.."0"..month; else Date = Date..month; end;
               local day = tostring(T(l+1).day);
               if #day == 1 then Date = Date.."0"..day; else Date = Date..day; end;
               Date = tonumber(Date);
               local Time = "";
               local hour = tostring(T(l+1).hour);
               if #hour == 1 then Time = Time.."0"..hour; else Time = Time..hour; end;
               local minute = tostring(T(l+1).min);
               if #minute == 1 then Time = Time.."0"..minute; else Time = Time..minute; end;
               local sec = tostring(T(l+1).sec);
               if #sec == 1 then Time = Time.."0"..sec; else Time = Time..sec; end;
               Time = tonumber(Time);
               if TradesTmp[j].Date < Date then
                  TradesTmp[j].Index = l;
                  break;
               elseif TradesTmp[j].Date == Date and TradesTmp[j].Time < Time then
                  TradesTmp[j].Index = l;
                  break;
               end;
            elseif l == Size() then
               TradesTmp[j].Index = l;
               break;
            end;
         end;
      end;      
      -- Очищает все значения 
      LineValue = {};
      for i=1,Size(),1 do
         LineValue[i] = {};
         for j=1,OpenedTradesMAX,1 do
            LineValue[i][j] = "";
         end;
      end;
      -- Устанавливает значения для всех индексов линий
      for i=1,#TradesTmp,1 do
         for j=i+1,#TradesTmp,1 do            
            -- Ищет встречную сделку, которая закрыла рассматриваемую
            if TradesTmp[i].OpenCount > 0 and TradesTmp[j].OpenCount > 0 then  
               if TradesTmp[i].Operation == "B" then
                  if TradesTmp[j].Operation == "S" then                      
                     if TradesTmp[j].Qty >= TradesTmp[i].Qty then
                        -- Убирает взаимо закрытое количество
                        TradesTmp[i].OpenCount = 0;
                        TradesTmp[j].OpenCount = TradesTmp[j].OpenCount - TradesTmp[i].Qty;
                        -- Если сделка прибыльная
                        if TradesTmp[j].Price > TradesTmp[i].Price then                           
                           -- Находит свободную прибыльную линию
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);                           
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);                              
                              -- Устанавливает значения на линию 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- сделка убыточная
                           -- Находит свободную убыточную линию
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           LineNumber = FreeLine;
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;                              
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --Устанавливает значения на линию 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     else -- Объем последующей меньше объема обрабатываемой
                        -- Убирает взаимо закрытое количество
                        TradesTmp[i].OpenCount = TradesTmp[i].OpenCount - TradesTmp[j].Qty;
                        TradesTmp[j].OpenCount = 0; 
                        -- Если сделка прибыльная
                        if TradesTmp[j].Price > TradesTmp[i].Price then                        
                           -- Находит свободную прибыльную линию
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- Устанавливает значения на линию
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- сделка убыточная
                           -- Находит свободную убыточную линию
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --Устанавливает значения на линию
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     end;
                  end;
               else -- первая сделка "S"
                  if TradesTmp[j].Operation == "B" then
                     if TradesTmp[j].Qty >= TradesTmp[i].Qty then
                        -- Убирает взаимо закрытое количество
                        TradesTmp[i].OpenCount = 0;
                        TradesTmp[j].OpenCount = TradesTmp[j].OpenCount - TradesTmp[i].Qty;
                        -- Если сделка прибыльная
                        if TradesTmp[j].Price < TradesTmp[i].Price then                        
                           -- Находит свободную прибыльную линию
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- Устанавливает значения на линию
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- сделка убыточная
                           -- Находит свободную убыточную линию
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --Устанавливает значения на линию
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     else
                        -- Убирает взаимо закрытое количество
                        TradesTmp[i].OpenCount = TradesTmp[i].OpenCount - TradesTmp[j].Qty;
                        TradesTmp[j].OpenCount = 0;   
                        -- Если сделка прибыльная
                        if TradesTmp[j].Price < TradesTmp[i].Price then                        
                           -- Находит свободную прибыльную линию
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- Устанавливает значения на линию
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- сделка убыточная
                           -- Находит свободную убыточную линию
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --Устанавливает значения на линию 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
end;

-- Возвращает номер свободной линии по аббривиатуре ("CPL","CLL") и индексу свечи, с которого нужно рисовать
function GetFreeLineNumber(Abbr, index)
   local Arr = nil;
   if Abbr == "CPL" then Arr = CloseProfitLine;
   elseif Abbr == "CLL" then Arr = CloseLossLine;
   end;
   for key,value in pairs(Arr) do
       if index < 2 or value+1 < index then return key; end;
   end;
   message('Работа индикатора должна быть прекращена, т.к. открыто больше максимально возможного количества сделок!!!\nУвеличьте параметр "Незакрытых сделок max" в настройках индикатора и запустите его снова.',1);
   return nil;
end;

-- Функция возвращает значение бита (число 0, или 1) под номером bit (начинаются с 0) в числе flags, если такого бита нет, возвращает nil
function CheckBit(flags, bit)
   -- Проверяет, что переданные аргументы являются числами
   if type(flags) ~= "number" then error("Предупреждение!!! Checkbit: 1-й аргумент не число!"); end;
   if type(bit) ~= "number" then error("Предупреждение!!! Checkbit: 2-й аргумент не число!"); end;
   local RevBitsStr  = ""; -- Перевернутое (задом наперед) строковое представление двоичного представления переданного десятичного числа (flags)
   local Fmod = 0; -- Остаток от деления 
   local Go = true; -- Флаг работы цикла
   while Go do
      Fmod = math.fmod(flags, 2); -- Остаток от деления
      flags = math.floor(flags/2); -- Оставляет для следующей итерации цикла только целую часть от деления           
      RevBitsStr = RevBitsStr ..tostring(Fmod); -- Добавляет справа остаток от деления
      if flags == 0 then Go = false; end; -- Если был последний бит, завершает цикл
   end;
   -- Возвращает значение бита
   local Result = RevBitsStr :sub(bit+1,bit+1);
   if Result == "0" then return 0;     
   elseif Result == "1" then return 1;
   else return nil;
   end;
end;

function OnDestroy()
   TradesFile = nil;
   if #Labels > 0 then -- Удаляет ранееустановленные метки
      for i=1,#Labels,1 do
         DelLabel(Settings['Идентификатор графика *'], Labels[i]);
      end;
   end;
end;
