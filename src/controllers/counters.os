
&HTTPMethod("GET")
Функция list() Экспорт

	ТипОбъектов = Неопределено;

	Если ТипЗнч(ЗначенияМаршрута) = Тип("Соответствие") Тогда
		ТипОбъектов = ЗначенияМаршрута.Получить("type");
	КонецЕсли;

	Результат = ПолучениеСчетчиков.Список(ТипОбъектов);

	Возврат Содержимое(Результат);

КонецФункции // list()

&HTTPMethod("GET")
Функция get() Экспорт

	ТипОбъектов = Неопределено;
	Счетчик = Неопределено;

	Если ТипЗнч(ЗначенияМаршрута) = Тип("Соответствие") Тогда
		ТипОбъектов = ЗначенияМаршрута.Получить("type");
		Счетчик = ЗначенияМаршрута.Получить("counter");
	КонецЕсли;
	
	ПараметрыЗапроса = ЗапросHTTP.ПараметрыЗапроса();

	Формат = "json";
	Если НЕ ПараметрыЗапроса["format"] = Неопределено Тогда
		Формат = ПараметрыЗапроса["format"];
	КонецЕсли;

	Фильтр = Новый Структура();
	Для Каждого ТекЭлемент Из ПараметрыЗапроса Цикл
		Если Лев(ВРег(ТекЭлемент.Ключ), 7) = ВРег("filter_") Тогда
			Фильтр.Вставить(Сред(ТекЭлемент.Ключ, 8), ТекЭлемент.Значение);
		КонецЕсли;
	КонецЦикла;

	Измерения = "";
	Если НЕ ПараметрыЗапроса["dim"] = Неопределено Тогда
		Измерения = ПараметрыЗапроса["dim"];
	КонецЕсли;

	АгрегатнаяФункция = "count";
	Если НЕ ПараметрыЗапроса["agregate"] = Неопределено Тогда
		АгрегатнаяФункция = ПараметрыЗапроса["agregate"];
	КонецЕсли;

	Если ТипОбъектов = "session" Тогда
		Данные = ДанныеСеансов.Сеансы(Истина);
	ИначеЕсли ТипОбъектов = "infobase" Тогда
		Данные = ДанныеИБ.ИБ(Истина);
	КонецЕсли;
	
	Результат = ПолучениеСчетчиков.Счетчики(Данные,
	                                        ТипОбъектов,
	                                        Счетчик,
	                                        Фильтр,
	                                        Измерения,
	                                        АгрегатнаяФункция,
	                                        Формат);

	Возврат Содержимое(Результат);

КонецФункции // get()
