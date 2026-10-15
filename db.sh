#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
PGBIN=/opt/homebrew/opt/postgresql@17/bin
export PGHOST="$ROOT/.postgres/socket"
export PGPORT=55432
export PGUSER="$(id -un)"
export PGDATABASE=sample_500

case "${1:-psql}" in
    start) "$PGBIN/pg_ctl" -D "$ROOT/.postgres/data" -l "$ROOT/.postgres/server.log" -w start ;;
    stop) "$PGBIN/pg_ctl" -D "$ROOT/.postgres/data" -m fast -w stop ;;
    status) "$PGBIN/pg_ctl" -D "$ROOT/.postgres/data" status ;;
    psql) "$PGBIN/psql" -X "${@:2}" ;;
    restore) "$PGBIN/pg_restore" --no-owner --no-privileges -d "$PGDATABASE" "${2:-$ROOT/sample-500/database.dump}" ;;
    export) "$PGBIN/psql" -X --csv -q -P footer=off -c '
        SELECT f.file_name AS "Видео", r."Patient_Id", r."Id" AS "Record_Id"
        FROM dbo.record r JOIN cc_system.files f ON f.id = r.filename
        ORDER BY r."Id";' ;;
    *) echo "start | stop | status | psql [args] | restore [dump] | export" ;;
esac
