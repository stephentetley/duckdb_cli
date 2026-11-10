/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:excel_plus/excel_plus.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:duckdb_cli/write_xlsx.dart';

String dblQuote(String s) {
  return '"$s"';
}

/// https://excel-plus.web.app/create-excel-file#appending-rows
void outputXlsxTable(String tableName, Database db, ExcelWorkbook wb) async {
  final sql1 = "select cid, name, type from pragma_table_info('$tableName') order by cid;";

  final ResultSet rs1 = db.select(sql1);

  Map<int, ({String name, String ty})> cols = {};

  for (final Row row in rs1) {
    cols.addAll({row['cid']: (name: row['name'], ty: row['type'])});
  }
  print(cols);

  final table = wb.addSheet(tableName);
  table.addHeaders(cols.values.map((record) {return record.name;}));

  /// todo optional order by
  final sql2 = "select ${cols.values.map((record) {return dblQuote(record.name);}).join(',')} from ${dblQuote(tableName)};";
  print(sql2);
  
  final ResultSet rs2 = db.select(sql2);
  for (final Row row in rs2) {
    final List<CellValue> cells = [];
    for (final ({String name, String ty}) record in cols.values) {
      cells.add(TextCellValue(row[record.name]));
    }
    table.addRow(cells);
  }
  

}

