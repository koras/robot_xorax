Данный архив содержит примеры функций расчета индикаторов терминала QUIK.
Файлы предоставляются "как есть". Допускаются любые правки на свое усмотрение.
 
ИНСТРУКЦИЯ:
Скопируйте каталог LuaIndicators из архива, в папку с терминалом QUIK.
 После этого в терминале, в окне с графиком, станет возможным добавить индикаторы из архива.
 Имя каждого из индикаторов начинается с символа *.

ПОЯСНЕНИЯ:
Все функции индикаторов уже имеют настройки по умолчанию, т.е, задавать их все не обязательно.
Все функции требуют предварительного расчета начиная с индекса 1. 
Т.е. даже если нужен только последний индекс, все равно требуется провести цикл расчета начиная с самого первого индекса.
Все функции защищены от возможного пропуска данных.

Помимо стандартных настроек, индикаторы содержат следующие опции:
  Опция "Round" которая задает количество знаков округления значений индикатора.
  Опция "Multiply" в которой можно указать коэффициент на который умножаются значения индикатора.
  Опция "Horizontal_line" предназначена для отображения дополнительной горизонтальной линии, 
                    если она не нужна, достаточно указать в значении любой текст, например "off".

Данные опции отсутствуют для исходных функций расчета индикаторов, только при добавлении индикатора на график.

Для удобства, для каждого вида Moving Average существует заранее заданная константа:
   SMA,MMA,EMA,WMA,SMMA,VMA = "SMA","MMA","EMA","WMA","SMMA","VMA"

Каждый файл индикатора, уже содержит в себе весь набор необходимых для его расчета функций.
В каждом файле, присутствует ряд служебных функций:
  BOOLEAN function CandleExist(NUMBER I, [TABLE data_source]) --функция проверяет наличие данных.
   Функция является универсальной и позволяет проверять не только свечки графика, но также и данные в обычной таблице или DataSource
   I - указывает индекс из источника данных.
   data_source - является не обязательным, указывает на таблицу, или источник DataSource
   
  NUMBER function Squeeze(NUMBER I, NUMBER P) --предназначена для экономии ресурсов
   Данная функция позволяет во временной таблице отказаться от хранения информации за весь период, 
   а хранить только за нужный промежуток. При появлении данных с новым индексом, старые значения, вне промежутка, затрутся новыми.
   I - указывает индекс из источника данных.
   P - указывает промежуток, за который стоит хранить данные. 
   
  NUMBER function ConvertValue(TABLE T, NUMBER ...) --предназначена для округления значений индикатора или умножения на коэффициент.
   T - таблица в которой должны быть параметры Multiply (коэффициент умножения) 
     и Round (число знаков до которых происходит округление).
   ... - произвольное количество аргументов функции, значения которых следует округлить или умножить.
  
  NUMBER function GetValueEX(NUMBER I, STRING VT, [TABLE data_source]) --предназначена для получения значений из источника информации.
  где:
   I - указывает индекс из источника данных.
   VT - указывает какие именно данные из источника нужны. 
     Для удобства, в коде заданы константы, для каждого типа данных:
     OPEN,HIGH,LOW,CLOSE,VOLUME,MEDIAN,TYPICAL,WEIGHTED,DIFFERENCE,ANY = "O","H","L","C","V","M","T","W","D","A"
   data_source - является не обязательным, указывает на таблицу, или источник DataSource

Функция каждого индикатора имеет три параметра:
  NUMBER func(NUMBER I, TABLE Fsettings, [TABLE data_source])
  где:
   I - обязательный параметр, индекс очередной свечи из OnCalculate или номер элемента в массиве
   Fsettings - не обязательный параметр, таблица содержащая настройки индикатора
   data_source - не обязательный параметр, указывает на Lua таблицу исходных 
                значений  или источник данных созданный через CreateDataSource,
				если не задан, то данные для расчета берутся из источника данных графика.


--Пример расчета индикатора Moving Average по произвольному набору чисел:
dofile(getWorkingFolder().."\\LuaIndicators\\MA.lua")
tbl = {[1]=2587.5, [2]=2588.5, [3]=2585.1, [4]=2583.7, [5]=2582.6, [6]=2581.2, [7]=2579.2, [8]=2574.7,
	[9]=2571.5, [10]=2570.8, [11]=2569.9, [12]=2569.7, [13]=2567.2, [14]=2569.3, [15]=2566.1, [16]=2567, 
	[17]=2563.3, [18]=2565.2, [19]=2564.3, [20]=2565.9, [21]=2568.5, [22]=2572.2, [23]=2572, [24]=2572, [25]=2571.3}
function main() 
  func = MA()
  t_id = AllocTable()
  AddColumn(t_id,1,"Price",true,QTABLE_INT_TYPE,10)
  AddColumn(t_id,2,"MA",true,QTABLE_INT_TYPE,10)
  CreateWindow(t_id)
  SetWindowCaption(t_id,"MA")
  for i=1,#tbl do
   ma_out=func(i, {Period=3, Metod = EMA, VType=ANY}, {[i]=tbl[i]})
   tmp=InsertRow(t_id,-1)
   SetCell(t_id,tmp,1,tostring(tbl[i]),tbl[i])
   SetCell(t_id,tmp,2,tostring(ma_out),ma_out)
  end 
end

--Пример расчета индикатора Moving Average по источнику данных созданному через CreateDataSource:
dofile(getWorkingFolder().."\\LuaIndicators\\MA.lua")
function main() 
  func = MA()
  t_id = AllocTable()
  AddColumn(t_id,1,"Price",true,QTABLE_INT_TYPE,10)
  AddColumn(t_id,2,"MA",true,QTABLE_INT_TYPE,10)
  CreateWindow(t_id)
  SetWindowCaption(t_id,"MA")
  ds = CreateDataSource("TQBR", "LKOH", INTERVAL_M1) 
  sleep(100)
  for i=1,ds:Size() do
   ma_out=func(i, {Period=9, Metod = EMA, VType=CLOSE}, ds)
   tmp=InsertRow(t_id,-1)
   SetCell(t_id,tmp,1,tostring(ds:C(i)),ds:C(i))
   SetCell(t_id,tmp,2,tostring(ma_out),ma_out)
  end 
end

Список индикаторов в архиве:
"AD"	--Accumulation/Distribution ("AD")
"AC"	--Accelerator/Decelerator Oscillator ("AC")
"ADX"	--Average Directional Movement Index ("ADX")
"AMA"	--Adaptive Moving Average ("AMA")
"AO"	--Awesome Oscillator ("AO")
"ALLIGATOR"	--Alligator ("ALLIGATOR")
"ATR"	--Average True Range ("ATR")
"BWMFI"	--Bill Williams Market Facilitation Index ("BWMFI")
"BEARS"	--Bears Power ("BEARS")
"BB"	--Bollinger Bands ("BB")
"BULLS"	--Bulls Power ("BULLS")
"CCI"	--Commodity Channel Index ("CCI")
"CMO"	--Chande Momentum Oscillator ("CMO")
"CO"	--Chaikin Oscillator ("CO")
"CV"	--ChaikinТs Volatility ("CV")
"EFI"	--Elder's Force Index ("EFI")
"ENVELOPES"	--Envelopes ("ENVELOPES")
"FRACTALS"	--Fractals ("FRACTALS")
"ICHIMOKU"	--Ichimoku ("ICHIMOKU")
"MACD"	--Moving Average Convergence/Divergence ("MACD")
"MACDH"	--MACD Histogram ("MACDH")
"MOMENTUM"	--Momentum ("MOMENTUM")
"MFI"	--Money FLow Index ("MFI")
"MA"	--Moving Average ("MA")
"OBV"	--On Balance "Volume" ("OBV")
"PSAR"	--Parabolic SAR ("PSAR")
"PC"	--Price Channel ("PC")
"PO"	--Price Oscillator ("PO")
"ROC"	--Rate Of Change ("ROC")
"RSI"	--Relative Strength Index ("RSI")
"RVI"	--Relative Vigor Index ("RVI")
"SROC"	--Smoothed Rate Of Change ("SROC")
"SD"	--Standard Deviation ("SD")
"SO"	--Stochastic Oscillator ("SO")
"TRIX"	--Triple Exponential Moving Average ("TRIX")
"VHF"	--Vertical Horizontal Filter ("VHF")
"VO"	--"Volume" Oscillator ("VO")
"WR"	--WilliamsТ Percent Range ("WR")
"WAD"	--WilliamsТ Accumulation/ Distribution ("WAD")
