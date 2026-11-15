import 'package:duckdb_cli/duckdb_invoke.dart';
import 'package:duckdb_cli/xlsx_cli.dart';
import 'package:duckdb_cli/use_sqlite.dart';
import 'dart:io';


void main() {
  print("test2.main()");
  extractWorkbookInfo(
    xlsxPath: './output/telemetry2.xlsx',
    outPath:  './output/telemetry2.json',
  );


  runDuckDB();

  final file = File("working.sqlite3");
  try { 
    if (file.existsSync()) {
      file.deleteSync();
    }
  } catch(e) {
    print('Error deleting working.sqlite3: $e');
  }
  writeSqlite("working.sqlite3");

  setupTables();
  globMatch("./data/fun*.xlsx");
  printSourceFiles();

  print("Writing './output/telemetry2.xlsx'");
  createXlsx('./data/temp.sqlite.db', './output/telemetry2.xlsx');

}

void createXlsx(String dbPath, String outPath) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  addTableAsSheet(
    sourceTable: 'Telemetry Outstations', 
    dbPath: dbPath, 
    xlsxPath: outPath,
    orderByColumns: ['temp_id'],
    destSheet: 'Telemetry Outstations',
    destTableName: 'Outstations'
  );

}

