# Запуск на Windows

## 1. Установить

- [Python 3.12, Windows installer (64-bit)](https://www.python.org/downloads/release/python-31210/). При установке оставить Python Launcher и включить `Add python.exe to PATH`.
- [PostgreSQL 17](https://www.postgresql.org/download/windows/): PostgreSQL Server, Command Line Tools и pgAdmin. Оставить порт `5432`, запомнить пароль пользователя `postgres`. Stack Builder можно пропустить.

## 2. Положить данные

Скопировать папку `sample-500` с флешки в папку проекта:

```text
eyes/
  fr_unet.ipynb
  requirements.txt
  sample-500/
    database.dump
    files/
      ...avi
```

Открыть PowerShell в папке проекта. Все команды ниже выполнять оттуда.

## 3. Открыть БД

После установки PostgreSQL уже работает как служба. Если остановлен: `Win+R` → `services.msc` → `postgresql-x64-17` → «Запустить».

В каждой новой консоли для работы с БД:

```powershell
$env:Path = 'C:\Program Files\PostgreSQL\17\bin;' + $env:Path
```

Создать базу и загрузить дамп — один раз. Команды запросят пароль `postgres`:

```powershell
createdb -h localhost -U postgres -T template0 -E UTF8 sample_500
pg_restore -h localhost -U postgres --no-owner --no-privileges --exit-on-error -d sample_500 .\sample-500\database.dump
```

Посмотреть примеры запросов и открыть SQL-консоль:

```powershell
psql -h localhost -U postgres -d sample_500 -f .\inspect.sql
psql -h localhost -U postgres -d sample_500
```

Выход из SQL-консоли: `\q`. В pgAdmin база находится в `Servers → PostgreSQL 17 → Databases → sample_500`, таблицы — в схемах `dbo` и `cc_system`. `db.sh` предназначен для macOS.

## 4. Запустить ноутбук

Создать окружение и установить зависимости — один раз:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Запуск:

```powershell
.\.venv\Scripts\jupyter-lab.exe fr_unet.ipynb
```

В браузере: `Run → Run All Cells`. В первой ячейке меняются `VIDEO`, `N_FRAMES`, `SEED`, `SCALE`, `THRESHOLD`.

При первом запуске нужен интернет: ноутбук скачает код и веса модели, около 85 МБ. Для ноутбука запуск БД не требуется — видео читаются прямо из папки.

Данные передаются отдельно. Перед коммитом ноутбука очистить вывод: `Kernel → Restart Kernel and Clear Outputs of All Cells`.
