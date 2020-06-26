

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local label = dofile(getScriptPath() .. "\\modules\\drawLabel.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");
local panelBids = dofile(getScriptPath() .. "\\interface\\bids.lua");

local interfaceBids = dofile(getScriptPath() .. "\\interface\\bids.lua");
local risk_stop = dofile(getScriptPath() .. "\\shop\\risk_stop.lua");
local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
 
  
 

-- исполнение продажи в режиме эмуляции
-- информация приходит из свечки
function callSELL_emulation(result)

    local price = result.close;

    if #setting.sellTable > 0 then
        local buyContractSell = 0;
        local deleteKeySell = 0;
            for sellT = 1 ,  #setting.sellTable do 
                if  setting.sellTable[sellT].type == 'sell' and   
                setting.sellTable[sellT].emulation  and  
                price + setting.profit_infelicity >= setting.sellTable[sellT].price   then 
                    
                      
                        setting.count_buyin_a_row = 0; 
                        setting.SPRED_LONG_LOST_SELL = price;
                        setting.SPRED_LONG_TREND_DOWN  = setting.SPRED_LONG_TREND_DOWN - setting.SPRED_LONG_TREND_DOWN_SPRED;
                        
                        setting.limit_count_buy = setting.limit_count_buy - setting.sellTable[sellT].contract;

                        if setting.SPRED_LONG_TREND_DOWN < 0  then 
                            setting.SPRED_LONG_TREND_DOWN = 0.01;
                        end;
                        -- сколько продано контрактов за сессию (режим эмуляции)ю
                        -- setting.emulation_count_contract_sell = setting.emulation_count_contract_sell + setting.sellTable[sellT].contract;
                        setting.count_contract_sell = setting.count_contract_sell  + setting.sellTable[sellT].contract;
                        -- сколько исполнилось продаж
                        setting.count_sell =  setting.count_sell + 1; 
                        setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;
    
                        signalShowLog.addSignal(result.datetime, 21 , false, price); 
                        -- надо удалить контракт по которому мы покупали
                        buyContractSell = setting.sellTable[sellT].buy_contract; 
                        deleteKeySell = sellT; 
                end;
            end;
            -- if deleteKeySell ~= 0  then 
            --     table.remove (setting.sellTable, deleteKeySell); 
            --     deleteBuy(result,buyContractSell); 
            -- end;
    end;
end




function callSELL(result)
    if #setting.sellTable > 0 then
        deleteSell(result);
    end;
end

 
function calculateProfit(value)
-- подсчёт чистой прибыли 
    local clearProfit =  value.price - value.buy_contract
    clearProfit = clearProfit * value.contract;
    setting.profit = clearProfit + setting.profit;
    -- сколько исполнилось продаж
    setting.count_sell =  setting.count_sell + 1; 
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

M.setDirect = setDirect;

 
return M