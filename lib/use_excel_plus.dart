import 'package:excel_plus/excel_plus.dart';
import 'dart:io';


Iterable<String> getSheetNames(String filename) {
  final bytes = File(filename).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  
  return excel.tables.keys;
}
