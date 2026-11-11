import 'package:duckdb_cli/duckdb_invoke.dart';
import 'package:duckdb_cli/use_excel_plus.dart';
import 'package:duckdb_cli/use_sqlite.dart';
import 'package:duckdb_cli/write_xlsx.dart';
import 'package:duckdb_cli/output_xlsx.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';


void main(List<String> arguments) async {
  final sheetNames = getSheetNames('./data/functional_langs.xlsx');

  for (final sheetName in sheetNames) {
    print(sheetName);
  }

  runDuckDB();

  final file = File("working.sqlite3");
  try { 
    if (await file.exists()) {
      await file.delete();
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

void createXlsx(String dbpath, String outpath) {
  final db = sqlite3.open(dbpath);
  final wb = ExcelWorkbook.createOrReplace(outpath);
  outputXlsxTable('Telemetry Outstations', db, wb);
  wb.save();
  db.close();
}

