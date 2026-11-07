import 'package:duckdb_cli/duckdb_invoke.dart';
import 'package:duckdb_cli/use_excel_plus.dart';
import 'package:duckdb_cli/use_sqlite.dart';
import 'package:duckdb_cli/write_xlsx.dart';
import 'package:duckdb_cli/gen_equiclass_attribs.dart' as dummy_equiclass;
import 'dart:io';


void main(List<String> arguments) async {
  final sheetNames = getSheetNames('./data/functional_langs.xlsx');

  for (final sheetName in sheetNames) {
    print(sheetName);
  }
  print("Writing './data/output1.xlsx'");
  writeSheet('./data/output1.xlsx');

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

  dummy_equiclass.createXlsx('./output/telemetry.xlsx');

}

