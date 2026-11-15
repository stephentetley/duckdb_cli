/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:excel_plus/excel_plus.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:duckdb_cli/excel_workbook.dart';
import 'dart:io';

/// todo - escaping...
String _dblQuote(String s) {
  return '"$s"';
}


void copyXlsxTemplate({required String templatePath, required String outPath}) { 
    Excel excel = Excel.decodeBytes(File(templatePath).readAsBytesSync());
    File(outPath).writeAsBytesSync(excel.save()!);
  }

/// Use this to dump a table into a new sheet
void addTableAsSheet({
  required String sourceTable, 
  required String dbPath, 
  required String xlsxPath,
  required String destSheet,
  String? destTableName,
  List<String> orderByColumns = const [],
}) {
  final db = sqlite3.open(dbPath);
  final sql1 = "select cid, name, type from pragma_table_info('$sourceTable') order by cid;";
  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }
  final wb = ExcelWorkbook.attach(path: xlsxPath);
  wb.dropSheetIfExists(sheetName: sourceTable);
  wb.createSheet(sheetName: sourceTable, columns: cols);

  final selectList = cols.map((record) => _dblQuote(record.name)).join(',');
  final orderByClause = orderByColumns.isEmpty ? "" : "order by ${orderByColumns.map((col) => _dblQuote(col)).join(',')}";
  final sql2 = "select $selectList from ${_dblQuote(sourceTable)} $orderByClause;";
  final ResultSet rs2 = db.select(sql2);
  wb.insertInto(sheetName: destSheet, resultset: rs2);
  if (destTableName != null) {
    wb.createNamedTable(sheetName: destSheet, tableName: destTableName);
  }
  wb.detach();
  db.close();
}

/// Use this to dump a table into an existing sheet (that mayy have formatting etc.)
void addTableOverwriteSheet({
  required String sourceTable, 
  required String dbPath, 
  required String xlsxPath,
  required String destSheet,
  required int startRow,
  List<String> orderByColumns = const [],
}) {
  final db = sqlite3.open(dbPath);
  final sql1 = "select cid, name, type from pragma_table_info('$sourceTable') order by cid;";
  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }

  final wb = ExcelWorkbook.attach(path: xlsxPath);
  wb.updateSheet(sheetName: destSheet, columns: cols);

  final selectList = cols.map((record) => _dblQuote(record.name)).join(',');
  final orderByClause = orderByColumns.isEmpty ? "" : "order by ${orderByColumns.map((col) => _dblQuote(col)).join(',')}";
  final sql2 = "select $selectList from ${_dblQuote(sourceTable)} $orderByClause;";
  final ResultSet rs2 = db.select(sql2);
  wb.overwriteInto(sheetName: destSheet, resultset: rs2, startRow: startRow);
  wb.detach();
  db.close();  
}


