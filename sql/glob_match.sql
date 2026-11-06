load sqlite;

attach './working.sqlite3' as sqlite_db (type sqlite);



insert into sqlite_db.source_files by name
select t.file from glob($search_path) t;

detach sqlite_db;

