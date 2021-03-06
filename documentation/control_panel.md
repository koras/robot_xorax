# Контрольная панель управления

С помощью панели управления можно менять в режиме торговли алгоритм работы робота. 

![Панель управления](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/control_panel_read.png)


    1) Кнопка старта и паузы. Кнопка блокируется, если сработала "стоп-заявка" до ручной разблокировки. 
    Если кнопка в неактивном состоянии, то робот не будет оценивать текущую ситуацию на рынке, 
    оценивать цена/объем и так далее. Поэтому если есть желание остановить покупки/продажи, 
    то лучше воспользоваться кнопкой "BUY" из пункта 2
    
    2) Кнопка покупки или продажи. Кнопка блокируется при достижении рисков или в ручном режиме. 
    Робот просто перестает выставлять заявки, при этом он продолжает рассчитывать точку входа, пересчитывать стопы и так далее.

    3) Кнопка эмуляции. Обычно данный режим полностью дублирует боевой режим, 
    за исключением того что не выставляет заявки, а рисует на графике ситуацию идентичную тому 
    что произошла бы в боевом режиме. В этом режиме можно посмотреть как ведёт себя робот и 
    что он предпримет при различных ситуациях на рынке. 
    *Не стоит полагаться на этот режим полностью (italic)*. 
    
    Режим эмуляции может расходиться с боевым режимом с тем, что информация о том, 
    что заявка исполнена в режиме эмуляции срабатывает после того как цена подошла к цене заявке. 
    В боевом же режиме приходит ответ от quik о том, что заявка исполнена.

    4) Кнопка long/short. Пока не активно

    5) Максимальный лимит контрактов. 
        Сколько контрактов может использовать робот / В работе / контрактов за одну сделку

![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_limit.PNG)

    В панели можно увеличить количество используемых контрактов, так и уменьшить. 
    Стоит помнить, что увеличение количества контрактов влечет увеличение рисков.

    6) Статистика покупок и продаж. Сколько было выставлено на покупку и продажу контрактов. 
        Это больше для статистики, сколько было продано и куплено в рамках работы скрипта.
        
    7) Сколько контрактов будет использовано при покупке/продаже в разовой сделке.
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_use_limit.PNG)

    8) Объем профита
        На какое количество пунктов выставлять заявку после продажи/покупки контракта. 
        Стоит заметить, что увеличение и уменьшение данного параметра влияет на работу алгоритма. 
        При уменьшении параметра робот будет чаще покупать и продавать, но профит будет меньше.
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_profit.PNG)

    9) Изменения типа заявок
        Есть два типа, это лимитные заявки и тейк-профит заявки. 
        В данном случае лучше почитать о типах заявок. Например при низкой волатильности рынка, лучше использовать лимитки. 
        При больших движениях, тейки. По умолчанию установлен лимитный тип заявок
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_taik.PNG)
        
    10) Блокировка покупок
        При падении цены, чтобы как-то снизить риски, устанавливается автоматическая блокировка покупок.
        
        Чтобы блокировка была разблокирована автоматически, необходимо чтобы были проданы то количество контрактов которые указаны при блокировке.
        Если установлена блокировка на 3 покупки, то надо чтобы робот продал 3 контракта для разблокировки, а не 1 или 2
        При падении цены, если было сделано 2 покупки, а робот стоит на 3 покупки и до срабатывания блокировки сработала хотябы 1 продажа, то блокировку обнуляется.
        
        Допустим покупка была на цене 43.39 рублей. Следующая покупка будет(если цена продолжит падать) 
        на цене 43.29(пункт 11). Далее, чем больше падение, тем больше будет увеличиваться расстояние между покупками на сумму 0.02(пункт 12)
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_block_buy.PNG)
        
    13) Коридор покупок
        Установка коридора, выше которого робот не будет покупать. 
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_up.PNG)

    14) Количество контрактов в стоп-заявке(ограничение убытков)
        К текущим контрактам которые в работе можно добавить дополнительные контракты, которые не учитываются роботом.
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_add_stop.PNG)
 
    15) Расстояние стоп-заявки до максимальной покупки.
    Чем дальше расстояние, тем больше убыток. Тем меньше, тем больше вероятность, что стоп будет задет.
    Каждый сам решает, какой убыток будет у него и где ставить стоп.
    Стоп пересчитывается после каждой продажи или покупки контракта
![Максимальный лимит контрактов](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/panel_stop_max.PNG)

 

[Последние релизы](https://github.com/koras/robot_xorax/releases)

[Группы в телеграмм @robots_xorax](https://t.me/robots_xorax)

