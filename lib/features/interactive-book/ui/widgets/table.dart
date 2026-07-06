import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/table/table.dart';

class CustomTable extends StatelessWidget {
  final TableModel data;

  const CustomTable({super.key, required this.data});

  @Preview(name: "Custom Table")
  static Widget preview() => CustomTable(
    data: TableModel(
      type: 'widget',
      subType: 'table',
      heading: ['Column A', 'Column B'],
      rows: [
        ['Row 1A', 'Row 1B'],
        ['Row 2A', 'Row 2B'],
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor =
        theme.brightness == Brightness.dark
            ? const Color(0xFF1E3A5F)
            : const Color(0xFFE3F2FD);

    final columnWidths = {
      for (var i = 0; i < data.heading.length; i++) i: const FlexColumnWidth(1),
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
            children:
                data.heading
                    .map<Widget>(
                      (h) => TableCellWidget(text: h, isHeader: true),
                    )
                    .toList(),
          ),
          // Data rows
          ...data.rows.map(
            (row) => TableRow(
              children:
                  row
                      .map<Widget>((cell) => TableCellWidget(text: cell))
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
