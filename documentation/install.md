# Установка Robot XoraX

#### Шаг 1

Сперва необходимо скачать архив с lua по ссылке c [yandex disk](https://yadi.sk/d/55qjoDJaATPYPQ)
Архив необходимо распоковать и положить в папке «C:\Program Files (x86)» можно и в другое место, самое главное указать или подредактировать путь в файле start.lua

![tag](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/lua_yandex.PNG)


#### Шаг 2
Скачиваете любой редактор, если у вас не установлен, например [Notepad++](https://notepad-plus-plus.org/downloads/) и устанавливаете


#### Шаг 3
Скачиваете последнюю версию робота [все релизы](https://github.com/koras/robot_xorax/releases) в удобном для вас формате. Распаковываете туда куда вам удобно. Мы рекоммендуем распаковать прям в папку QUIK. Перед скачиванием лучше конечно уточнить группе telegramm  [@robots_xorax](https://t.me/robots_xorax), какая более стабильная и рекоммендуемая версия


#### Шаг 4
Необходимо узнать активный номер счёта.
Для рынка FORTS один счёт, для фондового рынка может быть другой счёт. Это лучше узнать у своего брокера. Если вы планируете торговать на срочном рынке нефтью брент, а не знаете номер счёта, рекомендуем купить 1 контракт, после а после сразу его продать. Так вы сможете узнать номер счёта в списке заявок или сделок в quik.


#### Шаг 5
Для каждого рынка и инструмента свои настройки
Для торговли на срочном рынке: 

 - Нефть:
необходимо в редакторе Notepad++ который вы скачивали на шаге 2 открыть файл setting/work_rb.lua в роботе и указать свой номер счёта
 setting.ACCOUNT=""

![account](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/accounts.PNG)

 
- Прописать  текущий код бумаги setting.SEC_CODE
- В графике надо указать Идентификатор my_br
 
![tag](https://raw.githubusercontent.com/koras/robot_xorax/master/images/readme/tag.PNG)





[последние релизы] https://github.com/koras/robot_xorax/releases

[Группы в телеграмм @robots_xorax](https://t.me/robots_xorax)

