/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:excel_plus/excel_plus.dart';
import 'dart:io';


Iterable<String> getSheetNames(String filename) {
  final bytes = File(filename).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  
  return excel.tables.keys;
}
