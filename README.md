# project_data_infrastructure
Базы данных и процедуры хранения и обработки данных для проектов транспортного планирования.

Двухуровневая организация хранения данных на сервере.

Верхний уровень - Генеральная база данных.
1) [x] таблица infra_objects: объекты транспортной инфраструктуры федерального значения, международные терминалы транспорта;
   Для внесения существующих объектов. В рамках перечня ОТИ понимать как объект с уникальными: нормативным установленным классом (категорией), линейными или площадными параметрами мощности.
   В качестве резервного варианта для объектов с неопределенными характеристиками предусмотрены количественные параметры (по типу Транспортная развязка - 1 ед.), но лучше вносить конкретные параметры.
   Также для каждого ОТИ необходимо наличие характеристик транспортной и/или пассажирской/грузовой пропускной способности и/или емкости (или потенциальная возможность их установить).
   Известные источники:
   - Перечень федеральных дорог - Постановление Правительства РФ от 17.11.2010 N 928 (ред. от 14.06.2023) (https://rosavtodor.gov.ru/docs/ofitsialnye-dokumenty/12217);
   - Государственный реестр аэродромов и вертодромов гражданской авиации Российской Федерации (https://favt.gov.ru/dejatelnost-ajeroporty-i-ajerodromy-reestr-grajdanskih-ajerodromov-rf/);
   - Объемы перевозок через аэропорты России (https://favt.gov.ru/dejatelnost-ajeroporty-i-ajerodromy-osnovnie-proizvodstvennie-pokazateli-aeroportov-obyom-perevoz/);
   - Объемы перевозок через аэропорты МАУ (https://favt.gov.ru/dejatelnost-ajeroporty-i-ajerodromy-osnovnie-proizvodstvennie-pokazateli-aeroportov-obyomy-mau/);
   - Перечень морских портов Российской Федерации, в которых осуществляет деятельность ФГУП «Росморпорт» (https://www.rosmorport.ru/services/seaports/);
   - Речные порты??? (открытый источник - перечень 2008 г., однако есть распоряжение ППРФ об открытых портах, и там другие порты есть)
3) [x] таблица ptv_threads: межрегиональные маршруты транспорта общего пользования, авиационные региональные маршруты и поезда дальнего следования согласно открытым реестрам и перечням;
   Для внесения межрегиональных маршрутов и установленных маршрутов ОПТ, которые связывают между собой субъекты РФ, в первую очередь.
   Официально существуют реестры автобусных и субсидируемых маршрутов. Поезда дальнего следования единым перечнем в открытом доступе отсутствуют.
   Источник:
   - Реестр межрегиональных маршрутов: в документах Минтранса по словам Реестр межрегиональных маршрутов;
   - Авиация: перечень субсидируемых маршрутов в рамках ППРФ от 25.12.2013 № 1242 (https://favt.gov.ru/dejatelnost-vozdushnye-perevozki-subsidirovanie-regiony/);
5) [x] таблица ptv_vehs: по сути, таблица-приложение к таблице ptv_threads (связка через УИН маршрутов), содержащая информацию о подвижном составе, обслуживающем маршруты в составе ptv_threads;
   Для внесения данных о подвижном составе на маршрутах ОПТ. Разделение обеспечит относительно свободное формирование данных о ПС (внести данные можно, в совокупности, по классам ПС, а можно по каждой единице).
   Также позволяет привязывать набор данных о каком-то наборе транспортных средств к нескольким маршрутам (необходимо при внесении данных о разных вариантах одного маршрута.
   Каждый вариант маршрута вносится отдельной строкой в таблицу маршрутов ptv_routes. Но строка ПС остается одной для обеих строк, и при сведении результатов не необходимости отслеживать дублирование ПС.
7) таблицы-справочники: классификаторы объектов и отдельных параметров:
   - [x] таблица tobjects: классификатор объектов инфраструктуры и маршрутов (используется для определения типа вносимого объекта и маршрута;
         Нужна для однозначного определения типов ОТИ в составе документов и программ. Типы ОТИ кодируются в числовом формате.
   - [x] таблица fuel_types: типы топлива для использования в таблицах ptv_vehs;
         Однозначное определение типов используемого топлива. В основном, для решения вопросов экологии в проектах.
   - [x] таблица fin_levels: источники финансирования для определения источника финансирования мероприятий;
         Однозначное определение источников финансирования. Необходимо для сведения итоговых расходов по источникам финансирования.
         Также код из fin_levels может использоваться в проектной таблице мероприятий как номер строки 3-го уровня нумерации;
   - [x] таблица codes_regions: коды ОКАТО и ГРЗ для идентификации субъектов РФ;
         Информация о субъекте РФ, где проводится разработка хранится под кодом ОКАТО. Коды ГРЗ включены ввиду их наличия в различных рег. номерах объектов (напр., на остановках на межрег. маршрутах).
         Код ОКАТО является основным географическим классификаторов на уровне субъекта РФ. При этом совершенно не важно, реализуется ли проект в рамках субъекта РФ или отдельного мун. обр.
         Также через него формируются запросы в Генеральную БД для получения данных об ОТИ и маршрутах в представления (view).
   - [ ] таблица urban_agglos: список городских агломераций в составе субъекта РФ (используется, в основном, в рамках Национального проекта);
         Таблица городских агломераций с аббревиатурой для однозначного определения перечня в рамках нацпроекта.
   - [ ] таблица agglos_municipalities*: список муниципальных образований в составе городских агломераций.
         Однозначное определение состава городских агломераций в рамках нац. проекта. Использовать ответы субъектов РФ в справках 2020-2021 гг.
   - [ ] таблица srd_cat: таблица категорий улиц и дорог;
         Стандартные категории а. дорог для стандартизации обозначения в документах.
   - [ ] таблица act_type: таблица типов мероприятий.
         Стандартные типы мероприятий для стандартизации обозначения типа в отчетных документах.
8) административные таблицы: управление
