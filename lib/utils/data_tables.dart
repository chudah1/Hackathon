import 'package:flutter/material.dart';

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
    columns: const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Age',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    ], rows: const []);
  }
}
