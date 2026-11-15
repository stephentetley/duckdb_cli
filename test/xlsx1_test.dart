import 'package:duckdb_cli/xlsx_cli.dart';
import 'dart:io';

void main() {
  print("test1.main()");
  createXlsxFromTemplate(
    dbPath: "./data/new_simple_equi_create_batch01.sqlite",
    xlsxTemplate: "./data/AIW_Equi_Creation_Template_V1.0.xlsx",
    outPath: "./output/uploader_EQUI_CREATE.xlsx"
  );
}


void createXlsxFromTemplate({required String dbPath, required String xlsxTemplate, required String outPath}) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  copyXlsxTemplate(
    templatePath: xlsxTemplate,
    outPath: outPath
  );
  
  addTableOverwriteSheet(
    sourceTable: 'equi_create_change_request_header', 
    dbPath: dbPath, 
    xlsxPath: outPath, 
    destSheet: 'Change Request Header', 
    startRow: 5
  );

  addTableOverwriteSheet(
    sourceTable: 'equi_create_change_request_notes', 
    dbPath: dbPath, 
    xlsxPath: outPath, 
    destSheet: 'Change Request Notes',
    startRow: 4,
  );
  
  addTableOverwriteSheet(
    sourceTable: 'equi_create_equipment_data', 
    dbPath: dbPath, 
    xlsxPath: outPath,
    destSheet: 'EQ-Equipment Data',
    startRow: 5,
    orderByColumns: ['equipment'],
  );

  addTableOverwriteSheet(
    sourceTable: 'equi_create_classification', 
    dbPath: dbPath, 
    xlsxPath: outPath, 
    destSheet: 'EQ-Classification', 
    startRow: 5,
    orderByColumns: ['equipment', 'class'],
  );
}


// void modifyTemplate({required String xlsxTemplate, required String outPath}) {
//   if (File(outPath).existsSync()) {
//     File(outPath).deleteSync();
//   }
//   final excel = Excel.decodeBytes(File(xlsxTemplate).readAsBytesSync());
//   final sheet = excel['EQ-Classification'];
//   final cell = sheet.cell(CellIndex.indexByString('B5'));
//   print("B5 is `${cell.value}`");
//   print("maxRows: ${sheet.maxRows}");
//   sheet.insertRowIterables(
//     [TextCellValue('\$5006'), 
//     TextCellValue('FSTNEM'), 
//     TextCellValue('LOCATION_ON_SITE'), 
//     TextCellValue('Kiosk')], 
//     5
//   );
  
//   File(outPath).writeAsBytesSync(excel.save()!);
// }
