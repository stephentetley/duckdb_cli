import 'dart:io';


void runDuckDB() async {
  var result = await Process.run('duckdb', ['-c', "select upper('hello world!') as ans;"]);
  print(result.stdout);
}


void setupTables() async {
  var result = await Process.run('duckdb', ['-f', "./sql/setup_tables.sql"]);
  print(result.stdout);
}

void globMatch(String glob) async {
  var result = await Process.run('duckdb', ['-c', "set variable search_path='$glob'", '-f', "./sql/setup_tables.sql"]);
  print(result.stdout);
}

void printSourceFiles() async {
  var result = await Process.run('duckdb', ['-c', "attach './working.sqlite3' as sqlite_db (type sqlite);", 
                                            '-c', "select file from sqlite_db.source_files;",
                                            '-c', "detach sqlite_db;"]);
  print(result.stdout);
}