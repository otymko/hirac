
// Функция - читает указанный файл настроек JSON и возвращает содержимое в виде структуры/массива
//
// Параметры:
//	ИмяФайлаНастроек    - Строка   - полный путь к файлу настроек или имя файла настроек json (без расширения)
//                                   если указано только имя, то файл настроек должен находиться в корне приложения
//
// Возвращаемое значение:
//	Структура, Массив       - прочитанные настройки 
//
Функция ПрочитатьНастройкиИзJSON(Знач ИмяФайлаНастроек) Экспорт

	Чтение = Новый ЧтениеJSON();
	
	Если ВРег(Прав(ИмяФайлаНастроек, 4)) = ВРег(".JSON") Тогда
		ПутьКНастройкам = ИмяФайлаНастроек;
	Иначе
		ПутьКНастройкам = СтрШаблон("%1/%2.json", ТекущийКаталог(), ИмяФайлаНастроек);
	КонецЕсли;

	Чтение.ОткрытьФайл(ПутьКНастройкам, КодировкаТекста.UTF8);

	Возврат ПрочитатьJSON(Чтение, Ложь);

КонецФункции // ПрочитатьНастройкиИзJSON()

// Функция преобразует переданный текст вывода команды в массив соответствий
// элементы массива создаются по блокам текста, разделенным пустой строкой
// пары <ключ, значение> структуры получаются для каждой строки с учетом разделителя ":"
//   
// Параметры:
//   ВыводКоманды            - Строка            - текст для разбора
//   
// Возвращаемое значение:
//    Массив (Соответствие) - результат разбора
//
Функция РазобратьВыводКоманды(Знач ВыводКоманды)
	
	Текст = Новый ТекстовыйДокумент();
	Текст.УстановитьТекст(ВыводКоманды);

	МассивРезультатов = Новый Массив();
	Описание = Новый Соответствие();

	Для й = 1 По Текст.КоличествоСтрок() Цикл

		ТекстСтроки = Текст.ПолучитьСтроку(й);
		
		ПозРазделителя = СтрНайти(ТекстСтроки, ":");
		
		Если НЕ ЗначениеЗаполнено(ТекстСтроки) Тогда
			Если й = 1 Тогда
				Продолжить;
			КонецЕсли;
			МассивРезультатов.Добавить(Описание);
			Описание = Новый Соответствие();
			Продолжить;
		КонецЕсли;

		Если ПозРазделителя = 0 Тогда
			Описание.Вставить(СокрЛП(ТекстСтроки), "");
		Иначе
			Описание.Вставить(СокрЛП(Лев(ТекстСтроки, ПозРазделителя - 1)), СокрЛП(Сред(ТекстСтроки, ПозРазделителя + 1)));
		КонецЕсли;
		
	КонецЦикла;

	Если Описание.Количество() > 0 Тогда
		МассивРезультатов.Добавить(Описание);
	КонецЕсли;
	
	Если МассивРезультатов.Количество() = 1 И ТипЗнч(МассивРезультатов[0]) = Тип("Строка") Тогда
		Возврат МассивРезультатов[0];
	КонецЕсли;

	Возврат МассивРезультатов;

КонецФункции // РазобратьВыводКоманды()

// Процедура - выполняет преобразование переданных данных в JSON
//
// Параметры:
//    Данные       - Произвольный     - данные для преобразования
//
// ВозвращаемоеЗначение:
//    Строка     - результат преобразованияданные для преобразования
//
Функция ДанныеВJSON(Знач Данные) Экспорт
	
	Запись = Новый ЗаписьJSON();
	
	Запись.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));

	Попытка
		ЗаписатьJSON(Запись, Данные);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Возврат Запись.Закрыть();
	
КонецФункции // ДанныеВJSON()

