import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class NewIbMarkdownParser {
  static final Map<String, GlobalKey> _headingKeys = {};

  static Map<String, GlobalKey> get headingKeys => _headingKeys;

  static void clearKeys() {
    _headingKeys.clear();
  }

  static List<Widget> parse(BuildContext context, String markdown) {
    final lines = markdown.split('\n');
    final widgets = <Widget>[];
    var inCodeBlock = false;
    var codeBlockContent = '';
    var inTable = false;
    var tableLines = <String>[];
    var skipToc = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      final lowerTrimmed = trimmed.toLowerCase();

      // Skip empty lines first
      if (trimmed.isEmpty) {
        if (!inCodeBlock && !inTable) {
          widgets.add(const SizedBox(height: 8));
        }
        continue;
      }

      // Detect and skip "Table of contents" section
      if (lowerTrimmed == 'table of contents' ||
          lowerTrimmed.startsWith('# table of contents') ||
          lowerTrimmed.startsWith('## table of contents') ||
          lowerTrimmed.startsWith('### table of contents')) {
        skipToc = true;
        continue;
      }

      // Skip TOC-related content
      if (skipToc) {
        // Check if this is a TOC list item
        final isTocItem = trimmed == '- TOC' || 
                         trimmed == '* TOC' || 
                         lowerTrimmed == 'toc' ||
                         trimmed == '- toc' ||
                         trimmed == '* toc';
        
        if (isTocItem) {
          // Skip TOC items
          continue;
        } else if (trimmed.startsWith('#')) {
          // Found a new heading, stop skipping and process this line
          skipToc = false;
          // Fall through to process this heading
        } else if (!trimmed.startsWith('-') && 
                   !trimmed.startsWith('*') &&
                   !RegExp(r'^\d+\.').hasMatch(trimmed)) {
          // Found non-list content, stop skipping and process this line
          skipToc = false;
          // Fall through to process this line
        } else {
          // Still in TOC section (other list items), skip
          continue;
        }
      }

      // Handle code blocks
      if (trimmed.startsWith('```')) {
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
      if (trimmed.contains('|')) {
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

    // Create a key for this heading based on its text
    final keyName = _parseInlineStyles(text)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    
    if (!_headingKeys.containsKey(keyName)) {
      _headingKeys[keyName] = GlobalKey();
    }

    return Padding(
      key: _headingKeys[keyName],
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
      child: _buildRichText(context, text),
    );
  }

  static Widget _buildRichText(BuildContext context, String text) {
    final spans = <InlineSpan>[];
    var currentIndex = 0;

    // Pattern to match bold, italic, inline code, and links
    final pattern = RegExp(
      r'\*\*([^*]+)\*\*|'  // Bold **text**
      r'__([^_]+)__|'       // Bold __text__
      r'\*([^*]+)\*|'       // Italic *text*
      r'_([^_]+)_|'         // Italic _text_
      r'`([^`]+)`|'         // Inline code `text`
      r'\[([^\]]+)\]\(([^)]+)\)'  // Links [text](url)
    );

    final matches = pattern.allMatches(text);

    for (final match in matches) {
      // Add text before the match
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: TextStyle(
            color: IbTheme.textColor(context),
            fontSize: 16,
            height: 1.6,
          ),
        ));
      }

      // Add styled text based on match type
      if (match.group(1) != null || match.group(2) != null) {
        // Bold text
        spans.add(TextSpan(
          text: match.group(1) ?? match.group(2),
          style: TextStyle(
            color: IbTheme.textColor(context),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ));
      } else if (match.group(3) != null || match.group(4) != null) {
        // Italic text
        spans.add(TextSpan(
          text: match.group(3) ?? match.group(4),
          style: TextStyle(
            color: IbTheme.textColor(context),
            fontSize: 16,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ));
      } else if (match.group(5) != null) {
        // Inline code
        spans.add(WidgetSpan(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: IbTheme.textColor(context).withAlpha(26),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              match.group(5)!,
              style: TextStyle(
                fontFamily: 'monospace',
                color: IbTheme.getPrimaryColor(context),
                fontSize: 15,
              ),
            ),
          ),
        ));
      } else if (match.group(6) != null) {
        // Link text
        spans.add(TextSpan(
          text: match.group(6),
          style: TextStyle(
            color: IbTheme.getPrimaryColor(context),
            fontSize: 16,
            decoration: TextDecoration.underline,
            height: 1.6,
          ),
        ));
      }

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: TextStyle(
          color: IbTheme.textColor(context),
          fontSize: 16,
          height: 1.6,
        ),
      ));
    }

    // If no matches, return simple text
    if (spans.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: IbTheme.textColor(context),
          fontSize: 16,
          height: 1.6,
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
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
            child: _buildRichText(context, text),
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
      child: DefaultTextStyle(
        style: TextStyle(
          color: IbTheme.textColor(context).withAlpha(179),
          fontStyle: FontStyle.italic,
          fontSize: 16,
          height: 1.6,
        ),
        child: _buildRichText(context, text),
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

    if (headers.isEmpty) {
      return const SizedBox.shrink();
    }

    final columnCount = headers.length;

    // Skip separator line (second line with dashes)
    // Parse data rows
    final dataRows = <List<String>>[];
    for (var i = 2; i < tableLines.length; i++) {
      final line = tableLines[i].trim();
      if (line.isEmpty) continue;

      var cells = line
          .split('|')
          .map((cell) => cell.trim())
          .where((cell) => cell.isNotEmpty)
          .toList();

      // Ensure row has same number of cells as headers
      if (cells.length < columnCount) {
        // Pad with empty cells
        cells = [...cells, ...List.filled(columnCount - cells.length, '')];
      } else if (cells.length > columnCount) {
        // Trim extra cells
        cells = cells.sublist(0, columnCount);
      }

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
          columnSpacing: 24,
          dataRowMinHeight: 48,
          dataRowMaxHeight: double.infinity,
          columns: headers
              .map((header) => DataColumn(
                    label: Expanded(
                      child: Text(
                        _parseInlineStyles(header),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: IbTheme.primaryHeadingColor(context),
                        ),
                        softWrap: true,
                      ),
                    ),
                  ))
              .toList(),
          rows: dataRows
              .map((row) => DataRow(
                    cells: row
                        .map((cell) => DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 100,
                                  maxWidth: 250,
                                ),
                                child: Text(
                                  _parseInlineStyles(cell),
                                  style: TextStyle(
                                    color: IbTheme.textColor(context),
                                  ),
                                  softWrap: true,
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
