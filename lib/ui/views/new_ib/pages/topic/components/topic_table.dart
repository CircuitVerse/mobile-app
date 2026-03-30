import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class TopicTable extends StatelessWidget {
  final dynamic data;

  const TopicTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String?;
    final headers = data['headers'] as List<dynamic>?;
    final rows = data['rows'] as List<dynamic>?;

    if (headers == null || rows == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: IbTheme.textColor(context).withAlpha(51)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: IbTheme.primaryHeadingColor(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: IbTheme.textColor(context).withAlpha(51),
              ),
              verticalInside: BorderSide(
                color: IbTheme.textColor(context).withAlpha(51),
              ),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: IbTheme.textColor(context).withAlpha(51),
                ),
                children: headers.map((header) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      header.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: IbTheme.primaryHeadingColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  );
                }).toList(),
              ),
              ...rows.map((row) {
                final rowData = row as List<dynamic>;
                return TableRow(
                  children: rowData.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        cell.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: IbTheme.textColor(context),
                            ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
