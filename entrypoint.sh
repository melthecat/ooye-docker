#!/usr/bin/env sh
set -e

touch "$OOYE_DATADIR/ooye.db"

if [ "$OOYE_WAL" = "true" ] && [ "$OOYE_DATADIR" = "/usr/src/app" ]; then
    echo "WAL mode cannot be enabled when OOYE_DATADIR isn't set."
    echo "The directory set should also be bind-mounted."
    exit 1
fi

if [ "$OOYE_DATADIR" != "/usr/src/app" ]; then
    ln -sf "$OOYE_DATADIR/ooye.db" "/usr/src/app/ooye.db"
    ln -sf "$OOYE_DATADIR/registration.yaml" "/usr/src/app/registration.yaml"
    echo "Database symlink to $OOYE_DATADIR/ooye.db created!"
else 
    echo "Not setting OOYE_DATADIR is deprecated and might be removed in the future."
    echo "Please set it to a writeable directory and bind-mount it to persist your data."
    echo "Make sure to move your existing data to the new directory."
fi

if [ ! -s "$OOYE_DATADIR/ooye.db" ]; then
    echo "Database file is empty, sleeping for 30 mins."
    echo "Run setup by executing \`docker compose exec ooye npm run setup\`"
    echo "After setup, run \`docker compose down && docker compose up -d\`"
    sleep 1800
fi

if [ "$OOYE_WAL" = "true" ]; then
    node << EOF
const sqlite = require("better-sqlite3")
const db = new sqlite("/usr/src/app/ooye.db", {fileMustExist: true})
db.pragma("journal_mode = wal")
db.close()
EOF
    ln -sf "$OOYE_DATADIR/ooye.db-wal" "/usr/src/app/ooye.db-wal"
    ln -sf "$OOYE_DATADIR/ooye.db-shm" "/usr/src/app/ooye.db-shm"
    echo "WAL mode enabled!"
else 
    node << EOF
const sqlite = require("better-sqlite3")
const db = new sqlite("/usr/src/app/ooye.db", {fileMustExist: true})
db.pragma("journal_mode = delete")
db.close()
EOF
    rm -f "/usr/src/app/ooye.db-wal" "/usr/src/app/ooye.db-shm" "$OOYE_DATADIR/ooye.db-wal" "$OOYE_DATADIR/ooye.db-shm"
    echo "WAL mode disabled!"
fi

npm run start
