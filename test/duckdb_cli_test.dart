import 'package:duckdb_cli/excel_workbook.dart';
import 'package:duckdb_cli/output_xlsx.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:excel_plus/excel_plus.dart';
import 'dart:io';

void main() {
  createXlsxFromTemplate(
    dbPath: "./data/new_simple_equi_create_batch01.sqlite",
    xlsxTemplate: "./data/AIW_Equi_Creation_Template_V1.0.xlsx",
    outPath: "./output/uploader_EQUI_CREATE.xlsx"
  );
  modifyTemplate(
    xlsxTemplate: "./data/AIW_Equi_Creation_Template_V1.0.xlsx",
    outPath: "./output/uploader_EQUI_CREATE_edit1.xlsx"
  );
}


void createXlsxFromTemplate({required String dbPath, required String xlsxTemplate, required String outPath}) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  final db = sqlite3.open(dbPath);
  final wb = ExcelWorkbook.attachAs(outPath: outPath, templatePath: xlsxTemplate);
  appendSQLiteTableToExistingSheet('equi_create_change_request_header', db, wb, 'Change Request Header', 5);
  appendSQLiteTableToExistingSheet('equi_create_change_request_notes', db, wb, 'Change Request Notes', 4);
  appendSQLiteTableToExistingSheet('equi_create_equipment_data', db, wb, 'EQ-Equipment Data', 5);
  wb.deleteRowsFromSheet(
    sheetName: 'EQ-Classification', 
    start: 6
  );
  appendSQLiteTableToExistingSheet('equi_create_classification', db, wb, 'EQ-Classification', 5);
  wb.detach();
  db.close();
}


void modifyTemplate({required String xlsxTemplate, required String outPath}) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  final excel = Excel.decodeBytes(File(xlsxTemplate).readAsBytesSync());
  final sheet = excel['EQ-Classification'];
  final cell = sheet.cell(CellIndex.indexByString('B5'));
  print("B5 is `${cell.value}`");
  print("maxRows: ${sheet.maxRows}");
  sheet.insertRowIterables(
    [TextCellValue('\$5006'), 
    TextCellValue('FSTNEM'), 
    TextCellValue('LOCATION_ON_SITE'), 
    TextCellValue('Kiosk')], 
    5
  );
  
  File(outPath).writeAsBytesSync(excel.save()!);
}
