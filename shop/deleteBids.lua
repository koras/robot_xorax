

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
 
  


-- продажа в режиме симуляции
function callSELLEmulation(result)
    if #setting.sellTable > 0 then
        local buyContractSell = 0;
        local deleteKeySell = 0;
        
            for sellT = 1 ,  #setting.sellTable do 
    
                if  setting.sellTable[sellT].type == 'sell' and  result.close + setting.profit_infelicity >= setting.sellTable[sellT].price   then 
                        local price = result.price;
                        setting.count_buyin_a_row = 0; 
                        setting.SPRED_LONG_LOST_SELL = price;
                        setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;
    
                        -- сколько исполнилось продаж
                        setting.count_sell =  setting.count_sell + 1; 
                        setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;
    
                        signalShowLog.addSignal(result.datetime, 8, false, setting.sellTable[sellT].price  + setting.profit_infelicity); 
                        -- надо удалить контракт по которому мы покупали
                        buyContractSell = setting.sellTable[sellT].buy_contract; 
                        deleteKeySell = sellT; 
                end;
            end;
    
            if deleteKeySell ~= 0  then 
                table.remove (setting.sellTable, deleteKeySell); 
                deleteBuy(result,buyContractSell); 
                 
            end;
    end;
end




function callSELL(result)
    if #setting.sellTable > 0 then
        deleteSell(result);
    end;
end


--реальные продажы
function deleteSell(result)
    local buyContractSell = 0;
    local deleteKeySell = 0;
    
        for sellT = 1 ,  #setting.sellTable do 
            if  setting.sellTable[sellT].type == 'sell' and setting.sellTable[sellT].trans_id == result.trans_id  then 
                    local price = result.price;
                    setting.count_buyin_a_row = 0; 
                    setting.SPRED_LONG_LOST_SELL = price;
                    setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;

                    -- сколько исполнилось продаж
                    setting.count_sell =  setting.count_sell + 1; 
                    setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;

                    signalShowLog.addSignal(result.datetime, 8, false, setting.sellTable[sellT].price); 
                    -- надо удалить контракт по которому мы покупали
                    buyContractSell = setting.sellTable[sellT].buy_contract; 
                    deleteKeySell = sellT; 
            end;
        end;

        if deleteKeySell ~= 0  then 
            table.remove (setting.sellTable, deleteKeySell); 
            deleteBuy(result, buyContractSell); 
             
        end;
end


function deleteBuy(result, buy_contract)
    local deleteKey = 0;
    local buyPrice = 0;
    for searchBuy = 1 ,  #setting.sellTable do 
        if setting.sellTable[searchBuy].type == 'buy' and setting.sellTable[searchBuy].price == ( buy_contract + setting.profit_infelicity)  then 
                -- удаляем только 1 элемент
                setting.limit_count_buy = setting.limit_count_buy - 1;
                deleteKey = searchBuy; 
                buyPrice = setting.sellTable[searchBuy].price;
        end;
    end;

    if deleteKey  ~= 0  then 
        table.remove (setting.sellTable, deleteKey);
        panelBids.show();
    end;

end



 
function transCallback(trans_reply)
    

    loger.save(' trans_rtrans_rtrans_r ' ..  trans_reply.trans_id  );
   -- loger.save('trans_reply.result_msg ' ..  trans_reply.result_msg );
    loger.save('order_num ' ..  trans_reply.order_num );
 --   loger.save('exchange_code ' ..  trans_reply.exchange_code );

     
           
     -- http://luaq.ru/OnTransReply.html
    if #setting.sellTable > 0 then 
        deleteSell(trans_reply);
    end;

    --  if trans_reply.trans_id == trans_id then          
     --    trans_Status = trans_reply.status; 
     --    trans_result_msg  = trans_reply.result_msg;

     -- end;
end;


function getRand()
    return tostring(math.random(2000000000));
end;


M = {};
M.transCallback   = transCallback;
M.callSELL   = callSELL;
M.callSELLEmulation   = callSELLEmulation;
 
M.bid   = bid ;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;
 
return M