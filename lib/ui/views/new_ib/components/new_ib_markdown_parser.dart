import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class NewIbMarkdownParser {
  static List<Widget> parse(BuildContext context, String markdown) {
    final lines = markdown.split('\n');
    final widgets = <Widget>[];
    var inCodeBlock = false;
    var codeBlockContent = '';
    var inTable = false;
    var tableLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle code blocks
      if (line.trim().startsWith('```')) {
        if (inCodeBlock) {
          // End of code block
          widgets.add(_buildCodeBlock(context, codeBlockContent.trim()));
          codeBlockContent = '';
          inCodeBlock = false;
        } else {
          // Start of code block
          inCodeBlock = true;
        }
        continue;
      }

      if (inCodeBlock) {
        codeBlockContent += '$line\n';
        continue;
      }

      // Handle tables
      if (line.trim().contains('|')) {
        if (!inTable) {
          inTable = true;
          tableLines = [];
        }
        tableLines.add(line);
        continue;
      } else if (inTable) {
        // End of table
        widgets.add(_buildTable(context, tableLines));
        tableLines = [];
        inTable = false;
      }

      // Skip empty lines
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Parse line
      final widget = _parseLine(context, line);
      if (widget != null) {
        widgets.add(widget);
      }
    }

    // Handle any remaining table
    if (inTable && tableLines.isNotEmpty) {
      widgets.add(_buildTable(context, tableLines));
    }

    return widgets;
  }

  static Widget? _parseLine(BuildContext context, String line) {
    var trimmed = line.trim();

    // Remove Jekyll/Kramdown attributes like {: fs-9}, {: .text-center}, etc.
    trimmed = trimmed.replaceAll(RegExp(r'\{:.*?\}'), '').trim();

    // Skip if line becomes empty after removing attributes
    if (trimmed.isEmpty) {
      return const SizedBox(height: 8);
    }

    // Headings
    if (trimmed.startsWith('# ')) {
      return _buildHeading(context, trimmed.substring(2), 1);
    } else if (trimmed.startsWith('## ')) {
      return _buildHeading(context, trimmed.substring(3), 2);
    } else if (trimmed.startsWith('### ')) {
      return _buildHeading(context, trimmed.substring(4), 3);
    } else if (trimmed.startsWith('#### ')) {
      return _buildHeading(context, trimmed.substring(5), 4);
    } else if (trimmed.startsWith('##### ')) {
      return _buildHeading(context, trimmed.substring(6), 5);
    } else if (trimmed.startsWith('###### ')) {
      return _buildHeading(context, trimmed.substring(7), 6);
    }

    // Horizontal rule
    if (trimmed == '---' || trimmed == '***' || trimmed == '___') {
      return _buildHorizontalRule(context);
    }

    // Blockquote
    if (trimmed.startsWith('> ')) {
      return _buildBlockquote(context, trimmed.substring(2));
    }

    // Unordered list
    if (trimmed.startsWith('- ') ||
        trimmed.startsWith('* ') ||
        trimmed.startsWith('+ ')) {
      return _buildListItem(context, trimmed.substring(2), false);
    }

    // Ordered list
    final orderedListMatch = RegExp(r'^\d+\.\s+').firstMatch(trimmed);
    if (orderedListMatch != null) {
      return _buildListItem(
        context,
        trimmed.substring(orderedListMatch.end),
        true,
      );
    }

    // Regular paragraph
    return _buildParagraph(context, trimmed);
  }

  static Widget _buildHeading(BuildContext context, String text, int level) {
    TextStyle? style;
    double topPadding;
    double bottomPadding;

    switch (level) {
      case 1:
        style = Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.bold,
            );
        topPadding = 24;
        bottomPadding = 16;
        break;
      case 2:
        style = Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            );
        topPadding = 20;
        bottomPadding = 12;
        break;
      case 3:
        style = Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            );
        topPadding = 16;
        bottomPadding = 10;
        break;
      case 4:
        style = Theme.of(context).textTheme.titleLarge?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            );
        topPadding = 14;
        bottomPadding = 8;
        break;
      case 5:
        style = Theme.of(context).textTheme.titleMedium?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w500,
            );
        topPadding = 12;
        bottomPadding = 6;
        break;
      default:
        style = Theme.of(context).textTheme.titleSmall?.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w500,
            );
        topPadding = 10;
        bottomPadding = 6;
    }

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(
        _parseInlineStyles(text),
        style: style,
      ),
    );
  }

  static Widget _buildParagraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        _parseInlineStyles(text),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: IbTheme.textColor(context),
              height: 1.6,
            ),
      ),
    );
  }

  static Widget _buildListItem(
    BuildContext context,
    String text,
    bool ordered,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: IbTheme.getPrimaryColor(context),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              _parseInlineStyles(text),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: IbTheme.textColor(context),
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBlockquote(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.getPrimaryColor(context).withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: IbTheme.getPrimaryColor(context),
            width: 4,
          ),
        ),
      ),
      child: Text(
        _parseInlineStyles(text),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: IbTheme.textColor(context).withAlpha(179),
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
      ),
    );
  }

  static Widget _buildCodeBlock(BuildContext context, String code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: IbTheme.textColor(context),
                height: 1.5,
              ),
        ),
      ),
    );
  }

  static Widget _buildHorizontalRule(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 1.5,
      color: Theme.of(context).dividerColor,
    );
  }

  static String _parseInlineStyles(String text) {
    // Remove Jekyll/Kramdown attributes
    text = text.replaceAll(RegExp(r'\{:.*?\}'), '');

    // Remove inline code backticks
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'\1');

    // Remove bold markers
    text = text.replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'\1');
    text = text.replaceAll(RegExp(r'__([^_]+)__'), r'\1');

    // Remove italic markers
    text = text.replaceAll(RegExp(r'\*([^*]+)\*'), r'\1');
    text = text.replaceAll(RegExp(r'_([^_]+)_'), r'\1');

    // Remove link markers [text](url)
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'\1');

    return text.trim();
  }

  static Widget _buildTable(BuildContext context, List<String> tableLines) {
    if (tableLines.length < 2) {
      return const SizedBox.shrink();
    }

    // Parse header row
    final headerLine = tableLines[0].trim();
    final headers = headerLine
        .split('|')
        .map((cell) => cell.trim())
        .where((cell) => cell.isNotEmpty)
        .toList();

    // Skip separator line (second line with dashes)
    // Parse data rows
    final dataRows = <List<String>>[];
    for (var i = 2; i < tableLines.length; i++) {
      final line = tableLines[i].trim();
      if (line.isEmpty) continue;

      final cells = line
          .split('|')
          .map((cell) => cell.trim())
          .where((cell) => cell.isNotEmpty)
          .toList();

      if (cells.isNotEmpty) {
        dataRows.add(cells);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: IbTheme.textColor(context).withAlpha(51),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            IbTheme.getPrimaryColor(context).withAlpha(26),
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: IbTheme.textColor(context).withAlpha(51),
            ),
          ),
          columns: headers
              .map((header) => DataColumn(
                    label: Text(
                      _parseInlineStyles(header),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                  ))
              .toList(),
          rows: dataRows
              .map((row) => DataRow(
                    cells: row
                        .map((cell) => DataCell(
                              Text(
                                _parseInlineStyles(cell),
                                style: TextStyle(
                                  color: IbTheme.textColor(context),
                                ),
                              ),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
