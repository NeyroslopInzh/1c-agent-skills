---
name: 1c-extension-create
description: >-
  Create a 1C extension so Russian is borrowed from the start and synonyms
  show in the Configurator property palette without a manual language switch.
  Use when creating an extension, ibcmd infobase config extension create,
  borrowing Language.Русский, DefaultLanguage, LanguageCode, or when the
  synonym field stays empty until the user re-borrows the language.
license: GPL-3.0-only
---

# Расширение с заимствованным языком

Эталон — выгрузка конфигуратора: `Configuration.xml` расширения и `Languages/Русский.xml`. Сверяй её с той базой, которую расширяешь.

Без заимствованного языка палитра свойств показывает пустой синоним. Текст в XML при этом может уже лежать. Пользователь тогда заимствует русский руками и переключает язык в свойствах дерева. Так не оставлять.

1. Прочитай язык основной конфигурации, не выдумывай uuid. В УТ 11.6 этой линейки `Language.Русский` имеет uuid `0663bf5b-bcba-4a40-a862-a0b3baa2d884` и `LanguageCode` `ru`. На другой базе сними uuid и код с её `Languages/Русский.xml`.
2. В расширении язык — Adopted. Свой uuid объекта расширения, `ExtendedConfigurationObject` — uuid языка родителя, и обязательно код:

```xml
<Language uuid="новый-uuid-расширения">
	<InternalInfo/>
	<Properties>
		<ObjectBelonging>Adopted</ObjectBelonging>
		<Name>Русский</Name>
		<Comment/>
		<ExtendedConfigurationObject>0663bf5b-bcba-4a40-a862-a0b3baa2d884</ExtendedConfigurationObject>
		<LanguageCode>ru</LanguageCode>
	</Properties>
</Language>
```

3. В `Configuration.xml` расширения, внутри `Properties`, строка `<DefaultLanguage>Language.Русский</DefaultLanguage>`. В `ChildObjects` язык первый: `<Language>Русский</Language>`.
4. Код языка и `DefaultLanguage` должны совпадать с `<v8:lang>ru</v8:lang>` в синонимах. Одного блока `v8:lang` без `LanguageCode` мало: конфигуратор его не показывает.

После import и apply выгрузи расширение обратно и проверь две строки: `DefaultLanguage` есть, у `Languages/Русский.xml` есть `<LanguageCode>ru</LanguageCode>`. Пока этого нет, пользователю не говори, что язык заимствован.

Открытый конфигуратор эту выгрузку не видит. Сохранение открытого сеанса затирает язык. Скажи закрыть его без сохранения и открыть базу снова.
