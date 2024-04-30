// Function to extract data from DataTable rows and store it in a list of maps
import 'package:flutter/material.dart';

List<Map<String, dynamic>> extractDataTableData(DataTable? dataTable) {
  List<Map<String, dynamic>> dataList = [];
  String columnLabel = "";
  for (var row in dataTable!.rows) {
    Map<String, dynamic> rowData = {};

    for (var i = 0; i < row.cells.length; i++) {
      DataColumn column = dataTable.columns[i];
      Widget columnName = (column.label as Expanded).child;

      if (columnName is Text) {
        columnLabel = columnName.data!;
      }

      if (row.cells[i].child is TextField) {
        TextEditingController controller = TextEditingController();
        controller.text =
            (row.cells[i].child as TextField).controller?.text ?? '';
        rowData[columnLabel] = controller.text;
      }
    }
    dataList.add(rowData);
  }

  return dataList;
}

Map<String, dynamic> extractCapstoneInfo(DataTable? dataTable) {
  Map<String, dynamic> capstoneInfo = {};
  String columnLabel = "";
  for (var row in dataTable!.rows) {
    for (var i = 0; i < row.cells.length; i++) {
      DataColumn column = dataTable.columns[i];
      Widget columnName = (column.label as Expanded).child;

      if (columnName is Text) {
        columnLabel = columnName.data!;
      }

      if (row.cells[i].child is TextField) {
        TextEditingController controller = TextEditingController();
        controller.text =
            (row.cells[i].child as TextField).controller?.text ?? '';
        capstoneInfo[columnLabel] = controller.text;
      }
    }
  }

  return capstoneInfo;
}
