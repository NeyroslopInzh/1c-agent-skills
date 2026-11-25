---
name: 1c-extension-sort
description: >-
  Sort every 1C extension metadata object by name, Latin A–Z then Cyrillic
  А–Я, top to bottom. Use when adding an object to an extension, editing
  Configuration.xml ChildObjects, or when object order in the extension tree
  is wrong.
---

# Сортировка объектов расширения

Списки объектов метаданных идут по имени сверху вниз: латиница `A–Z`, затем кириллица `А–Я`. `Ё` стоит сразу после `Е`. Регистр не учитывается. Сравнивается имя (`<Name>` или текст тега в `Configuration.xml`), не синоним.

Порядок видов метаданных не менять. Язык остаётся первым, дальше виды в том порядке, как их выгрузил конфигуратор. Внутри одного вида имена отсортированы.

Где сортировать:

- `Configuration.xml`, `<ChildObjects>`
- `<ChildObjects>` объекта: реквизиты, табличные части, формы, команды, макеты, значения перечисления, измерения, ресурсы, реквизиты табличной части
- состав подсистемы, `<Content>`

Куда новый объект ставить: в своё место по этому порядку, не в конец списка.

Не сортировать дерево формы (`ChildItems`, `BaseForm`), свойства внутри объекта, модули, права роли и предопределённые данные.
