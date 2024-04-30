import 'package:editable/editable.dart';
import 'package:flutter/material.dart';

class EditableTable extends StatelessWidget {
  final GlobalKey<EditableState> editableKey;
  final List<Map<String, dynamic>> columns;
  final void Function(GlobalKey<EditableState>) addNewRow;
  final List Function(GlobalKey<EditableState>) saveTableData;

  const EditableTable({super.key, 
    required this.editableKey,
    required this.columns,
    required this.addNewRow,
    required this.saveTableData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Editable(
            key: editableKey,
            columns: columns,
            trHeight: 50,
            // Add other Editable properties
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: ()=> addNewRow(editableKey),
              icon: const Icon(Icons.add),
              label: const Text('Add Row'),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: ()=> saveTableData(editableKey),
              icon: const Icon(Icons.save),
              label: const Text('Save Data'),
            ),
          ],
        ),
      ],
    );
  }
}
