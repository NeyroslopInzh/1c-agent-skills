# Эталон пустой заимствованной формы

Замер снят с выгрузки конфигуратора. Объект: справочник `Номенклатура`, форма `ФормаЭлемента`. В конфигураторе на форму ничего не добавляли.

Выгрузка cfe в XML без записи в рабочую базу:

```text
ibcmd infobase create --db-path=<пустая ИБ> --data=<data> --temp=<temp>
ibcmd config export --db-path=<пустая ИБ> --data=<data> --temp=<temp> --file=<Расширение.cfe> <каталог XML>
```

## Замеры `Ext/Form.xml`

| Признак | Эталон |
|---|---|
| Строк | 6895 |
| `DataPath` | 0 |
| `RowPictureDataPath` | 0 |
| `Events` | 0 |
| `Commands` | 0 |
| `Attributes` | пустой тег `<Attributes/>` снаружи и внутри `BaseForm`, определений реквизитов нет |
| `BaseForm` | одна, копия внешнего дерева |
| `CommandSet` | 0 |
| `CommandName` | 86, все значение `0` |
| `CommonPicture.` | 0 |
| Картинки не из `StdPicture` | `xr:Ref` вида `0:uuid` |
| Модуль | файла нет, пока нет своего кода |

Дерево `ChildItems` в файле есть. Это типовая форма после заимствования, а не макет, собранный вручную.

## Мета родителя

`Catalogs/Номенклатура.xml`: Adopted, ECO `fc59acc3-f1f7-4e3f-96da-e580f2c5a88f`, пять `GeneratedType` как в CF, `ChildObjects` — одна форма. Реквизитов нет.

## Мета формы

`Forms/ФормаЭлемента.xml`: uuid расширения `7a296939-06ef-450f-be71-01359dff785b`, ECO `41c80aa8-4fc3-49dd-82ef-95812b6326fa`, `PropertyState Form=Extended`.

Эти uuid только у эталона. Для другой формы брать её uuid из CF и новый uuid расширения.

## Что не является эталоном

- CF `Ext/Form.xml`: там есть `DataPath`, `Events`, `Commands`, `Attributes`, `CommandName` вида `Form.Command.*`
- Файл из одного `AutoCommandBar` без дерева элементов
- Форма расширения, в родителя которой ради неё заимствованы реквизиты CF
