﻿#Использовать irac

Перем ПодключениеКАгентам;
Перем ИБ;

#Область ПрограммныйИнтерфейс

// Процедура инициализирует подключение к агентам управления кластерами
//
// Параметры:
//   НастройкиПодключения     - Строка,     - путь к файлу настроек управления кластерами
//                              Структура     или структура настроек управления кластерами
//
Процедура Инициализировать(Знач НастройкиПодключения = Неопределено) Экспорт

	ПодключениеКАгентам = Новый ПодключениеКАгентам(НастройкиПодключения);

КонецПроцедуры // Инициализировать()

// Функция - возвращает объект-подключение к агентам кластера 1С
//
// Возвращаемое значение:
//   ПодключениеКАгентам     - объект-подключение к агентам кластера 1С
//
Функция ПодключениеКАгентам() Экспорт
	
	Возврат ПодключениеКАгентам;

КонецФункции // ПодключениеКАгентам()

Процедура ОбновитьИБ() Экспорт

	ИБ = Новый Массив();

	Для Каждого ТекАгент Из ПодключениеКАгентам.Агенты() Цикл

		ИБАгента = ИБАгента(ТекАгент.Значение);

		Для Каждого ТекИБ Из ИБАгента Цикл
			ИБ.Добавить(ТекИБ);
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры // ОбновитьИБ()

Функция ИБ(Знач Обновить = Ложь) Экспорт

	Если Обновить Тогда
		ОбновитьИБ();
	КонецЕсли;

	Возврат ИБ;

КонецФункции // ИБ()

Функция Список() Экспорт

	Возврат ОбщегоНазначения.ДанныеВJSON(ИБ(Истина));
	
КонецФункции // Список()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ПолучениеДанныхИБ

Функция ИБАгента(Знач Агент)

	ИБАгента = Новый Массив();

	Кластеры = Агент.Кластеры().Список();

	Для Каждого ТекКластер Из Кластеры Цикл

		ИБКластера = ИБКластера(ТекКластер);

		Для Каждого ТекИБ Из ИБКластера Цикл
			
			ТекИБ.Вставить("agent", СтрШаблон("%1:%2",
			                                  Агент.АдресСервераАдминистрирования(),
			                                  Агент.ПортСервераАдминистрирования()));

			ИБАгента.Добавить(ТекИБ);

		КонецЦикла;

	КонецЦикла;

	Возврат ИБАгента;

КонецФункции // ИБАгента()

Функция ИБКластера(Знач Кластер)

	ИБКластера = Новый Массив();
	
	СписокИБ = Кластер.ИнформационныеБазы().Список(, , Истина);

	ПоляИБ = Кластер.ИнформационныеБазы().ПараметрыОбъекта("ИмяРАК");

	Для Каждого ТекИБ Из СписокИБ Цикл

		ОписаниеИБ = Новый Соответствие();
		ОписаниеИБ.Вставить("cluster" , Кластер.Имя());
		ОписаниеИБ.Вставить("count"   , 1);

		Для Каждого ТекЭлемент Из ПоляИБ Цикл
			ЗначениеЭлемента = ТекИБ[ТекЭлемент.Значение.Имя];
			Если ТекЭлемент.Ключ = "infobase" Тогда
				ЗначениеЭлемента = ТекИБ[ПоляИБ["name"].Имя];
			КонецЕсли;
			ОписаниеИБ.Вставить(ТекЭлемент.Ключ, ЗначениеЭлемента);
		КонецЦикла;

		ИБКластера.Добавить(ОписаниеИБ);

	КонецЦикла;

	Возврат ИБКластера;
	
КонецФункции // ИБКластера()

#КонецОбласти // ПолучениеДанныхИБ

Инициализировать();
