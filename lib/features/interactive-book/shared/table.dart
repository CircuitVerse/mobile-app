import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        borderRadius: BorderRadius.circular(8),
      ),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: const [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFFE3F2FD)),
          children: [
            TableCellWidget(text: "Name", isHeader: true),
            TableCellWidget(text: "Role", isHeader: true),
          ],
        ),
        TableRow(
          children: [
            TableCellWidget(text: "Alice"),
            TableCellWidget(text: "Developer"),
          ],
        ),
        TableRow(
          children: [
            TableCellWidget(text: "Bob"),
            TableCellWidget(text: "Designer"),
          ],
        ),
        TableRow(
          children: [
            TableCellWidget(text: "Charlie"),
            TableCellWidget(text: "Tester"),
          ],
        ),
      ],
    );
  }
}

class TableCellWidget extends StatelessWidget {
  final String text;
  final bool isHeader;

  const TableCellWidget({super.key, required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
