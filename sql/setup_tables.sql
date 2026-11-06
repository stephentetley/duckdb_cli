load sqlite;

attach './working.sqlite3' as sqlite_db (type sqlite);

create table sqlite_db.source_files (file varchar);

detach sqlite_db;