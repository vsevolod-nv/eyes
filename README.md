### 1. что установить

- [PostgreSQL 17](https://www.postgresql.org/download/windows/): PostgreSQL Server, Command Line Tools и pgAdmin. оставь порт `5432`, запомни пароль пользователя `postgres`. Stack Builder можно пропустить.

### 2. куда положить данные

скопируй папку `sample-500` с флешки в папку проекта:

```text
eyes/
  fr_unet.ipynb
  requirements.txt
  sample-500/
    database.dump
    files/
      ...avi
```

открой PowerShell в папке проекта. все команды ниже выполняй оттуда.

### 3. как открыть бд

после установки PostgreSQL уже работает как служба. если остановлен: `Win+R` → `services.msc` → `postgresql-x64-17` → «Запустить».

в каждой новой консоли для работы с бд:

```powershell
$env:Path = 'C:\Program Files\PostgreSQL\17\bin;' + $env:Path
```

создай базу и загрузи дамп — это делается один раз. команды запросят пароль `postgres`:

```powershell
createdb -h localhost -U postgres -T template0 -E UTF8 sample_500
pg_restore -h localhost -U postgres --no-owner --no-privileges --exit-on-error -d sample_500 .\sample-500\database.dump
```

посмотреть примеры запросов и открыть SQL-консоль:

```powershell
psql -h localhost -U postgres -d sample_500 -f .\inspect.sql
psql -h localhost -U postgres -d sample_500
```

выйти из SQL-консоли: `\q`. в pgAdmin база находится в `Servers → PostgreSQL 17 → Databases → sample_500`, таблицы — в схемах `dbo` и `cc_system`. `db.sh` — для macOS.

### 4. как запустить ноутбук

создай окружение и поставь зависимости — тоже один раз:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

запуск:

```powershell
.\.venv\Scripts\jupyter-lab.exe fr_unet.ipynb
```

в браузере нажми `Run → Run All Cells`. в первой ячейке меняются `VIDEO`, `N_FRAMES`, `SEED`, `SCALE`, `THRESHOLD`.

при первом запуске скачаютсят код и веса модели, около 85 МБ. для ноутбука запуск бд не требуется — видео читаются прямо из папки.

данные передаются отдельно. перед коммитом ноутбука очисти вывод: `Kernel → Restart Kernel and Clear Outputs of All Cells`.
