import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class CustomTable extends StatelessWidget {
  final data;

  @Preview(name: "Custom Table")
  const CustomTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1E3A5F)
        : const Color(0xFFE3F2FD);

    final columnCount = data.heading.length;
    final columnWidths = {
      for (var i = 0; i < columnCount; i++) i: const FlexColumnWidth(1),
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(
          color: Colors.grey,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(color: headerColor),
            children: (data.heading as List)
                .map<Widget>((h) => TableCellWidget(text: h as String, isHeader: true))
                .toList(),
          ),
          // Data rows
          ...(data.rows as List).map(
            (row) => TableRow(
              children: (row as List)
                  .map<Widget>((cell) => TableCellWidget(text: cell as String))
                  .toList(),
            ),
          ),
        ],
      ),
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
