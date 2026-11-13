/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:sqlite3/sqlite3.dart';
import 'package:change_case/change_case.dart';
import 'package:duckdb_cli/write_xlsx.dart';

/// todo - escaping...
String dblQuote(String s) {
  return '"$s"';
}



void copyTableToExcel(String sourceTable, Database db, ExcelWorkbook wb) {
  final sql1 = "select cid, name, type from pragma_table_info('$sourceTable') order by cid;";

  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }
  print(cols);

  wb.dropSheetIfExists(sheetName: sourceTable);
  wb.createSheet(sheetName: sourceTable, columns: cols);

  /// todo optional order by clause
  final sql2 = "select ${cols.map((record) {return dblQuote(record.name);}).join(',')} from ${dblQuote(sourceTable)};";
  print(sql2);
  
  final ResultSet rs2 = db.select(sql2);
  wb.insertInto(sheetName: sourceTable, resultset: rs2);
  wb.createNamedTable(sheetName: sourceTable, tableName: sourceTable.toPascalCase());


}

