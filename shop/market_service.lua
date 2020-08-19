-- надо отсортировать все контракты на продажу и найти с самой низкой ценой
function getLastSell()

    local price_min_sell = 1000000
    setting.price_min_sell = price_min_sell
    setting.price_max_sell = 0

    if #setting.sellTable == 0 then return 0; end

    for contractStop = 1, #setting.sellTable do
        -- берём все заявки которые выставлены на продажу
        if setting.sellTable[contractStop].type == 'sell' and
            setting.sellTable[contractStop].work then
            -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
            if setting.sellTable[contractStop].price > setting.price_max_sell then
                -- максимальная цена продажи
                setting.price_max_sell = setting.sellTable[contractStop].price;

            end

            if setting.sellTable[contractStop].price < setting.price_min_sell then
                -- минимальная цена продажи
                setting.price_min_sell = setting.sellTable[contractStop].price;
            end
        end
    end

    if price_min_sell ~= setting.price_min_sell then
        return setting.price_min_sell;
    end

    -- не стоит заявок на продажу, всё продали
    return 0;
end

-- надо отсортировать все контракты на покупку и найти с самой высокой ценой
function getLastSell()

    local price_min_sell = 1000000
    setting.price_min_sell = price_min_sell
    setting.price_max_sell = 0

    if #setting.sellTable == 0 then return 0; end

    for contractStop = 1, #setting.sellTable do
        -- берём все заявки которые выставлены на продажу
        if setting.sellTable[contractStop].type == 'sell' and
            setting.sellTable[contractStop].work then
            -- если стоп сработал хотя бы раз, то больше максимальную цену не обновляем
            if setting.sellTable[contractStop].price > setting.price_max_sell then
                -- максимальная цена продажи
                setting.price_max_sell = setting.sellTable[contractStop].price;

            end

            if setting.sellTable[contractStop].price < setting.price_min_sell then
                -- минимальная цена продажи
                setting.price_min_sell = setting.sellTable[contractStop].price;
            end
        end
    end

    if price_min_sell ~= setting.price_min_sell then
        return setting.price_min_sell;
    end

    -- не стоит заявок на продажу, всё продали
    return 0;
end

