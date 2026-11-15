/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:sqlite3/sqlite3.dart';
import 'package:change_case/change_case.dart';
import 'package:duckdb_cli/excel_workbook.dart';

/// todo - escaping...
String _dblQuote(String s) {
  return '"$s"';
}



void createSheetForSQLiteTable(String sourceTable, Database db, ExcelWorkbook wb) {
  final sql1 = "select cid, name, type from pragma_table_info('$sourceTable') order by cid;";

  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }

  wb.dropSheetIfExists(sheetName: sourceTable);
  wb.createSheet(sheetName: sourceTable, columns: cols);

  /// todo optional order by clause
  final sql2 = "select ${cols.map((record) {return _dblQuote(record.name);}).join(',')} from ${_dblQuote(sourceTable)};";
  print(sql2);
  
  final ResultSet rs2 = db.select(sql2);
  wb.insertInto(sheetName: sourceTable, resultset: rs2);
  wb.createNamedTable(sheetName: sourceTable, tableName: sourceTable.toPascalCase());
}

void appendSQLiteTableToExistingSheet(String sourceTable, Database db, ExcelWorkbook wb, String sheetName, int startRow) {
  final sql1 = "select cid, name, type from pragma_table_info('$sourceTable') order by cid;";

  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }

  wb.updateSheet(sheetName: sheetName, columns: cols);

  /// todo optional order by clause
  final sql2 = "select ${cols.map((record) {return _dblQuote(record.name);}).join(',')} from $sourceTable;";
  
  final ResultSet rs2 = db.select(sql2);
  wb.overwriteInto(sheetName: sheetName, resultset: rs2, startRow: startRow);
}


