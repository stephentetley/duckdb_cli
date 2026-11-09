/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:sqlite3/sqlite3.dart';
import 'package:duckdb_cli/write_xlsx.dart';

void outputXlsxTable(String tableName, Database db, ExcelWorkbook wb) async {
  final sql = "select cid, name from pragma_table_info('$tableName') order by cid;";

  final ResultSet rs = db.select(sql);

  List<String> cols = [];

  for (final Row row in rs) {
    cols.add(row['name']);
  }
  print(cols);

  final table = wb.addSheet(tableName);
  table.addHeaders(cols);
}

