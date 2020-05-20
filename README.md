# Robot XoraX
Бесплатный робот для торговле фьючерсными контрактами Brent

Робот умеет выставлять заявки на продажу и покупку. У робота свой алгоритм торговли. 
Робот хорошо держит боковик и волатильность

Робот обладает функционалом:
- тейк профит на продажу
- регулировка профита покупки продажи контрактов
- лимит контрактов на торговлю
- установка количество используемых заявок на разовую покупку и продажу
- регилировка безопасного спреда на продажу тейк профита
- эмуляция торговли для понятия алгоритма торговли
- остановка и возобновление торговли в момент времени

Риски (снижение убытков) : 

Лимит на блокировку покупки. 

![Лимит на блокировку покупки](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/risk_buy_block.PNG)

Если цена будет падать и робот купит 3 контракта подряд, не продав не одного контракта, то сработает блокировка покупки, пока вы сами не разблокируете руками. При продаже хотя-бы одного контракта, идёт сброс лимита в 0. Это сделано с первую очередь для того, чтобы ограничить убытки, если цена резко пойдёт вниз на пол доллара или больше и вы не успеете отключить робота 



скачать https://github.com/koras/robot_xorax/archive/master.zip 

установка:
- Необходимо указать номер счёта. Его надо прописать в файле setting/account.lua  ( setting.ACCOUNT="")
- Прописать  текущий код бумаги setting.SEC_CODE в файле setting/account.lua 
- В графике надо указать Идентификатор my_br


Группы в телеграмм https://t.me/robots_xorax
