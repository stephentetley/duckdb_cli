/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:sqlite3/sqlite3.dart';
import 'package:duckdb_cli/write_xlsx.dart';

/// todo - escaping...
String dblQuote(String s) {
  return '"$s"';
}



void outputXlsxTable(String tableName, Database db, ExcelWorkbook wb) {
  final sql1 = "select cid, name, type from pragma_table_info('$tableName') order by cid;";

  final ResultSet rs1 = db.select(sql1);

  List<({String name, String ty})> cols = [];

  for (final Row row in rs1) {
    cols.add((name: row['name'], ty: row['type']));
  }
  print(cols);

  wb.dropSheetIfExists(tableName);
  wb.createSheet(tableName, cols);

  /// todo optional order by clause
  final sql2 = "select ${cols.map((record) {return dblQuote(record.name);}).join(',')} from ${dblQuote(tableName)};";
  print(sql2);
  
  final ResultSet rs2 = db.select(sql2);
  wb.insertInto(tableName, rs2);

}

