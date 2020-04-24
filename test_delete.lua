require"QL"

log = "sbrf.log"
seccode = "SRM6"
lots_in_trade = 80
accnt = ""
better = -5
chart = "sberbankxxx"
is_run = true
prev_datetime = {}
len = 100
basis = 9
k_bal = {0,1,2,3}
sell = false
buy = false
id = 0
first = true

function trade_signal(shift)
        number_of_candles = getNumCandles(chart)
        bars_temp,res,legend = getCandlesByIndex(chart,0,number_of_candles-2*len-shift,2*len)
        bars={}

        i=len
        j=2*len
        while i>=1 do
                if bars_temp[j-1].datetime.hour>=10 then
                        sk=true
                        if bars_temp[j-1].datetime.hour==18 and bars_temp[j-1].datetime.min==45 then
                                sk=false
                        end
                        if sk then
                                bars[i]=bars_temp[j-1]
                                i=i-1
                        end
                end
                j=j-1
        end

        t = len+1

        do_sell = false
        do_buy = true

        value = 0
        if do_sell then value = 1 end
        if do_buy then value = -1 end
        toLog(log,"value="..value.." on candle: "..bars[len].datetime.year.."-"..bars[len].datetime.month.."-"..bars[len].datetime.day.." "..bars[len].datetime.hour..":"..bars[len].datetime.min.."   O="..bars[len].open.." H="..bars[len].high.." L="..bars[len].low.." C="..bars[len].close.." V="..bars[len].volume)
        return value
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function OnInit(path)
        log=getScriptPath()..'\\'..log
        toLog(log,"==========OnInit: START")
        toLog(log,"==========OnInit: FINISH")
end

function OnStop()
        is_run = false
        toLog(log,"==========OnStop: script finished manually")
end

function CheckBit(flags, bit)
   -- Проверяет, что переданные аргументы являются числами
   if type(flags) ~= "number" then error("Ошибка!!! Checkbit: 1-й аргумент не число!"); end;
   if type(bit) ~= "number" then error("Ошибка!!! Checkbit: 2-й аргумент не число!"); end;
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

function killorders(ccode,scode)
    for i=0,getNumberOf("orders")-1,1 do
        local t=getItem("orders", i)
        if t ~= nil and type(t) == "table" then
            if( t.seccode == scode and CheckBit(t.flags, 0) == 1) then
                local transaction={
                    ["TRANS_ID"]=tostring(math.random(2000000000)),
                    ["ACTION"]="KILL_ORDER",
                    ["CLASSCODE"]=ccode,
                    ["SECCODE"]=scode,
                                        ["ACCOUNT"] = accnt,
                    ["ORDER_KEY"]=tostring(t.ordernum),
                }
                                res=sendTransaction(transaction)
            end
        end
    end
end

function killstoporders(ccode,scode)
    for i=0,getNumberOf("stop_orders")-1,1 do
        local t=getItem("stop_orders", i)
        if t ~= nil and type(t) == "table" then
            if( t.seccode == scode and CheckBit(t.flags, 0) == 1) then
                local transaction={
                    ["TRANS_ID"]=tostring(math.random(2000000000)),
                    ["ACTION"]="KILL_STOP_ORDER",
                    ["CLASSCODE"]=ccode,
                    ["SECCODE"]=scode,
                                        ["ACCOUNT"] = accnt,
                    ["STOP_ORDER_KEY"]=tostring(t.ordernum),
                }
                                res=sendTransaction(transaction)
            end
        end
    end
end


function main()
        toLog(log,"==========main: START")
        while is_run do
                if isConnected() == 1 then
                        ss = getInfoParam("SERVERTIME")
                        if string.len(ss) >= 5 then
                                hh = mysplit(ss,":")
                                str=hh[1]..hh[2]
                                h = tonumber(str)
                                if (h>=1000 and h<1400) or (h>=1405 and h<1845) or (h>=1905 and h<2350) then
                                        if first then
                                                for ti = 50,2,-1 do     trade_signal(ti) end
                                                if buy and not sell then message(seccode.." Current state: green and buy",1) end
                                                if sell and not buy then message(seccode.." Current state: red and sell",1) end
                                                if buy and sell then message(seccode.." ERROR: green and red",1) end
                                                if not buy and not sell then message(seccode.." WARNING: nothing",1) end
                                                first = false
                                        end
                                        prev_candle = getPrevCandle(chart,0)
                                        if not isEqual(prev_candle.datetime,prev_datetime) then
                                                current_value = trade_signal(1)

                                                if current_value ~= 0 then
                                                        optn = "B"
                                                        if current_value==1 then optn = "S" end
                                                        curvol=0
                                                        no=getNumberOf("FUTURES_CLIENT_HOLDING")
                                                        if no>0 then
                                                                for i=0,no-1,1 do
                                                                        im=getItem("FUTURES_CLIENT_HOLDING", i)
                                                                        if im.sec_code==seccode then
                                                                        curvol=im.totalnet
                                                                        end
                                                                end
                                                        end
                                                        trvol = -current_value*lots_in_trade-curvol
                                                        if trvol ~= 0 then
                                                                killorders("SPBFUT",seccode)
                                                                killstoporders("SPBFUT",seccode)
                                                                f = io.open(getScriptPath().."\\sbrf2_pos.txt","r")
                                                                sbrf2_pos=f:read("*n")
                                                                f:close()
                                                                f = io.open(getScriptPath().."\\sbrf3_pos.txt","r")
                                                                sbrf3_pos=f:read("*n")
                                                                f:close()
                                                                pr,n,l = getCandlesByIndex ("futsber", 0, getNumCandles("futsber")-1, 1)
                                                                local trans =
                                                                {
                                                                        ["ACTION"] = "NEW_ORDER",
                                                                        ["CLASSCODE"] = "SPBFUT",
                                                                        ["SECCODE"] = seccode,
                                                                        ["ACCOUNT"] = accnt,
                                                                        ["OPERATION"] = optn,
                                                                        ["PRICE"] = toPrice(seccode,pr[0].close+current_value*better),
                                                                        ["QUANTITY"] = tostring(math.abs(curvol-sbrf2_pos-sbrf3_pos)),
                                                                        ["TRANS_ID"] = tostring(getTradeDate().month*100+getTradeDate().day+id)
                                                                }
                                                                id = id+1
                                                                --res = sendTransaction(trans)
                                                                message(seccode.." Send : " .. res, 2)
                                                                toLog(log,"Send: ".. res)
                                                                for btr=0,200,5 do
                                                                        local trans =
                                                                        {
                                                                                ["ACTION"] = "NEW_STOP_ORDER",
                                                                                ["CLASSCODE"] = "SPBFUT",
                                                                                ["SECCODE"] = seccode,
                                                                                ["ACCOUNT"] = accnt,
                                                                                ["OPERATION"] = optn,
                                                                                ["PRICE"] = toPrice(seccode,pr[0].close-current_value*btr),
                                                                                ["STOPPRICE"] = toPrice(seccode,pr[0].close-current_value*(btr+better)),
                                                                                ["QUANTITY"] = tostring(6),
                                                                                ["TRANS_ID"] = tostring(getTradeDate().month*100+getTradeDate().day+id),
                                                                                ["EXPIRY_DATE"] = "GTC"
                                                                        }
                                                                        id = id+1
                                                                        --res = sendTransaction(trans)
                                                                        message(seccode.." Send : " .. res, 2)
                                                                        toLog(log,"Send: ".. res)
                                                                end
                                                                if current_value == 1 then
                                                                        message(seccode..' RED: buy->sell',1)
                                                                        toLog(log,"RED signal")
                                                                else
                                                                        message(seccode..' GREEN: sell->buy',1)
                                                                        toLog(log,"GREEN signal")
                                                                end
                                                        else
                                                                if current_value == 1 then
                                                                        message(seccode..' RED: buy->sell',1)
                                                                        toLog(log,"RED signal, but nothing to do")
                                                                else
                                                                        message(seccode..' GREEN: sell->buy',1)
                                                                        toLog(log,"GREEN signal, but nothing to do")
                                                                end
                                                        end
                                                else
                                                        if buy and not sell then toLog(log,"Nothing to do. Current state: green and buy",1) end
                                                        if sell and not buy then toLog(log,"Nothing to do. Current state: red and sell",1) end
                                                        if buy and sell then toLog(log,"Nothing to do. ERROR: green and red",1) end
                                                        if not buy and not sell then toLog(log,"Nothing to do. WARNING: nothing",1) end
                                                end
                                                prev_datetime = prev_candle.datetime
                                        end
                                end
                        end
                end
                sleep(5*1000)
        end
        toLog(log,"==========main: FINISH")
end