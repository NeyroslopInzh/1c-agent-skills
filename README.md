# Навыки агента для расширений 1С

Agent skills for 1C:Enterprise extension development. The same `SKILL.md` files work in Cursor, Codex, and Claude Code.

License: [GNU General Public License v3](LICENSE) (GPL-3.0-only).

Copyright (C) 2026 Victor.

## Что это

Навыки учат агента дорабатывать расширение 1С так, как это делает конфигуратор и как устроена типовая: заимствованный русский язык, версия, директивы, пустая заимствованная форма, поля из модуля, общие настройки, код и проведение по образцу типовой.

Формат — [Agent Skills](https://agentskills.io/specification): у каждого навыка каталог с `SKILL.md`, в шапке `name` и `description`. Агент видит название и описание сразу, а полный текст читает, когда задача подходит.

Правила про расширение 1С. Редактор на них не влияет, поэтому отдельной редакции текста под Cursor, Codex и Claude нет. Отличается каталог, из которого агент этот текст читает.

## Навыки

| Навык | Когда срабатывает |
| --- | --- |
| `1c-extension-create` | Новое расширение. Русский язык заимствуется сразу, чтобы синоним был виден в палитре свойств. |
| `1c-extension-version` | Версия `РР.ПП.ЗЗ.СС`. Старт `0.0.0.1`. С каждой правкой растёт сборка. Релиз — только по слову пользователя. |
| `1c-extension-directives` | Чужую процедуру расширяют только `&Перед`, `&После` и `&ИзменениеИКонтроль`. |
| `1c-extension-forms` | Заимствованная управляемая форма так, как её выгружает конфигуратор: дерево элементов на месте, своих полей в `Form.xml` нет. |
| `1c-form-by-code` | Своё поле, команда и событие формы появляются из модуля, через `Элементы.Добавить`. |
| `1c-extension-constants` | Все константы расширения на одной форме «Настройки работы расширения», в подсистеме «Администрирование». |
| `1c-typical-code` | Модуль расширения повторяет области и приёмы типовой. Если база расходится с навыком, брать типовую. |
| `1c-typical-posting` | Проведение нового и дописанного документа через `ПроведениеДокументов`. |

В примерах префикс своих имён — `дп_`. Образец областей и проведения снят с УТ 11.6. Uuid языка, подсистемы и формы навык велит брать из выгрузки той базы, которую расширяешь. Числа в `1c-extension-forms/reference.md` — замер одной пустой заимствованной формы `Номенклатура` / `ФормаЭлемента`, для другой формы их не копируют.

## Где что лежит

| Каталог | Зачем |
| --- | --- |
| `skills/` | Исходники. Править здесь. |
| `.agents/skills/` | Общий путь. Его читают [Cursor](https://cursor.com/docs/skills) и [Codex](https://learn.chatgpt.com/docs/build-skills). |
| `.claude/skills/` | [Claude Code](https://code.claude.com/docs/en/skills). |

`.agents/skills` и `.claude/skills` в этом репозитории — копии `skills/`. После правки исходников их нужно собрать заново:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope project -Root . -Into agents,claude
```

```bash
./scripts/install.sh --scope project --root . --into agents,claude
```

Cursor читает и `.agents/skills`, и `.claude/skills`. В клоне этого репозитория один и тот же навык поэтому виден дважды. Текст совпадает.

Отдельные каталоги, если агент не видит общий путь:

| Ключ `-Into` / `--into` | Куда копирует | Кто это читает |
| --- | --- | --- |
| `agents` | `.agents/skills` | Cursor, Codex |
| `claude` | `.claude/skills` | Claude Code. Cursor тоже читает этот каталог |
| `cursor` | `.cursor/skills` | Cursor |
| `codex` | `.codex/skills` | Старый путь Codex. Новый путь Codex — `agents` |

## Установка

Из корня клона.

Себе, во все проекты. Cursor и Codex берут общий каталог, Claude Code — свой:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope user -Into agents,claude
```

```bash
./scripts/install.sh --scope user --into agents,claude
```

На Windows это `%USERPROFILE%\.agents\skills` и `%USERPROFILE%\.claude\skills`. На Linux и macOS — `~/.agents/skills` и `~/.claude/skills`.

В один проект, та же пара каталогов внутри него:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope project -Root "D:\путь\к\проекту" -Into agents,claude
```

```bash
./scripts/install.sh --scope project --root /path/to/project --into agents,claude
```

Только Cursor, без второй копии:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope user -Into agents
```

Только Claude Code:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope user -Into claude
```

Старый домашний каталог Codex:

```powershell
powershell -NoProfile -File .\scripts\install.ps1 -Scope user -Into codex
```

Скрипт заменяет только эти восемь навыков. Чужие каталоги рядом он не трогает.

Для Cursor и Codex достаточно `agents`. Вторая копия в `cursor` или `claude` заставит Cursor показать навык ещё раз. Для Claude Code каталог `claude` нужен: общий `.agents/skills` он не читает.

## Как вызвать

Агент подключает навык сам, когда описание совпадает с задачей. Явно:

- Cursor — `/` и имя, например `/1c-extension-forms`.
- Claude Code — `/1c-extension-forms`.
- Codex — `/skills` или упоминание навыка через `$`.

Имя команды совпадает с именем каталога.

## Лицензия

GNU General Public License версии 3, только эта версия: SPDX `GPL-3.0-only`. Полный текст — в [LICENSE](LICENSE).

Навыки можно использовать, менять и распространять. Изменённая версия этих текстов, которую вы отдаёте дальше, остаётся под той же лицензией.
