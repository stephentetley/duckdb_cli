/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:sqlite3/sqlite3.dart';

void writeSqlite(String path) {
  final db = sqlite3.open(path);
  
  db.execute('''
    create table glob_matches (
      file_name text not null primary key
    );
  ''');

  db.close();
}

