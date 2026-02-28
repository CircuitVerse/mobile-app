import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/ui/views/new_ib/components/binary_simulator_widget.dart';
import 'package:mobile_app/ui/views/new_ib/components/quiz_widget.dart';

class NewIbMarkdownParser {
  static final Map<String, GlobalKey> _headingKeys = {};
  static bool _skipFirstH1 = true;

  static Map<String, GlobalKey> get headingKeys => _headingKeys;

  static void clearKeys() {
    _headingKeys.clear();
    _skipFirstH1 = true;
  }

  static List<Widget> parse(BuildContext context, String markdown) {
    // Reset state for new content
    _skipFirstH1 = true;
    _headingKeys.clear();

    final lines = markdown.split('\n');
    final widgets = <Widget>[];
    var inCodeBlock = false;
    var codeBlockContent = '';
    var inTable = false;
    var tableLines = <String>[];
    var skipTocSection = false;
    var inQuiz = false;
    var quizLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      final lowerTrimmed = trimmed.toLowerCase();

      // Skip empty lines first
      if (trimmed.isEmpty) {
        if (!inCodeBlock && !inTable && !inQuiz) {
          widgets.add(const SizedBox(height: 8));
        } else if (inQuiz) {
          quizLines.add(line);
        }
        continue;
      }

      // Detect quiz section (can be in blockquote)
      if (trimmed == '{:.quiz}' ||
          trimmed == '{: .quiz}' ||
          trimmed == '> {:.quiz}' ||
          trimmed == '> {: .quiz}') {
        inQuiz = true;
        quizLines = [];
        continue;
      }

      // Collect quiz lines
      if (inQuiz) {
        // Check if quiz section ends (next heading, Jekyll directive, or end of content)
        if (trimmed.startsWith('#') ||
            trimmed.startsWith('{%') ||
            (trimmed.startsWith('{') && !trimmed.startsWith('{:.'))) {
          // End of quiz, parse and add widget
          if (quizLines.isNotEmpty) {
            widgets.add(_buildQuiz(context, quizLines));
          }
          quizLines = [];
          inQuiz = false;
          // Fall through to process this line
        } else {
          quizLines.add(line);
          continue;
        }
      }

      // Detect "Table of contents" heading and start skipping
      if (lowerTrimmed.startsWith('## table of contents') ||
          lowerTrimmed.startsWith('### table of contents')) {
        skipTocSection = true;
        continue;
      }

      // Skip TOC section content
      if (skipTocSection) {
        // Check if this is Jekyll TOC directive or related
        if (trimmed.startsWith('1. TOC') ||
            trimmed.startsWith('{:toc}') ||
            trimmed.startsWith('{: toc}')) {
          continue;
        }
        // Check if we've reached a new section (## heading)
        if (trimmed.startsWith('##') &&
            !lowerTrimmed.contains('table of contents')) {
          skipTocSection = false;
          // Fall through to process this heading
        } else if (trimmed.startsWith('{:')) {
          // Skip Jekyll attributes
          continue;
        } else {
          // Still in TOC section
          continue;
        }
      }

      // Skip Jekyll attributes like {: .no_toc}
      if (trimmed.startsWith('{:')) {
        continue;
      }

      // Handle Jekyll includes (like binary simulator)
      if (trimmed.startsWith('{%') && trimmed.contains('include binary.html')) {
        widgets.add(const BinarySimulatorWidget());
        continue;
      }

      // Skip other Jekyll include directives (like chapter_toc.html)
      if (trimmed.startsWith('{%') && trimmed.contains('include')) {
        continue;
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

    // Handle any remaining quiz
    if (inQuiz && quizLines.isNotEmpty) {
      widgets.add(_buildQuiz(context, quizLines));
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
      // Skip the first H1 heading (it's the page title, already shown)
      if (_skipFirstH1) {
        _skipFirstH1 = false;
        return null;
      }
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
      child: Text(_parseInlineStyles(text), style: style),
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
      r'\*\*([^*]+)\*\*|' // Bold **text**
      r'__([^_]+)__|' // Bold __text__
      r'\*([^*]+)\*|' // Italic *text*
      r'_([^_]+)_|' // Italic _text_
      r'`([^`]+)`|' // Inline code `text`
      r'\[([^\]]+)\]\(([^)]+)\)', // Links [text](url)
    );

    final matches = pattern.allMatches(text);

    for (final match in matches) {
      // Add text before the match
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        );
      }

      // Add styled text based on match type
      if (match.group(1) != null || match.group(2) != null) {
        // Bold text
        spans.add(
          TextSpan(
            text: match.group(1) ?? match.group(2),
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        );
      } else if (match.group(3) != null || match.group(4) != null) {
        // Italic text
        spans.add(
          TextSpan(
            text: match.group(3) ?? match.group(4),
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        );
      } else if (match.group(5) != null) {
        // Inline code
        spans.add(
          WidgetSpan(
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
          ),
        );
      } else if (match.group(6) != null) {
        // Link text
        spans.add(
          TextSpan(
            text: match.group(6),
            style: TextStyle(
              color: IbTheme.getPrimaryColor(context),
              fontSize: 16,
              decoration: TextDecoration.underline,
              height: 1.6,
            ),
          ),
        );
      }

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: TextStyle(
            color: IbTheme.textColor(context),
            fontSize: 16,
            height: 1.6,
          ),
        ),
      );
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

    return RichText(text: TextSpan(children: spans));
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
          Expanded(child: _buildRichText(context, text)),
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
          left: BorderSide(color: IbTheme.getPrimaryColor(context), width: 4),
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

    // Remove inline code backticks - keep the content
    text = text.replaceAllMapped(
      RegExp(r'`([^`]+)`'),
      (match) => match.group(1)!,
    );

    // Remove bold markers
    text = text.replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'),
      (match) => match.group(1)!,
    );
    text = text.replaceAllMapped(
      RegExp(r'__([^_]+)__'),
      (match) => match.group(1)!,
    );

    // Remove italic markers
    text = text.replaceAllMapped(
      RegExp(r'\*([^*]+)\*'),
      (match) => match.group(1)!,
    );
    text = text.replaceAllMapped(
      RegExp(r'_([^_]+)_'),
      (match) => match.group(1)!,
    );

    // Remove link markers [text](url)
    text = text.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^)]+\)'),
      (match) => match.group(1)!,
    );

    return text.trim();
  }

  static Widget _buildTable(BuildContext context, List<String> tableLines) {
    if (tableLines.length < 2) {
      return const SizedBox.shrink();
    }

    // Parse header row
    final headerLine = tableLines[0].trim();
    final headers =
        headerLine
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

      var cells =
          line
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
        border: Border.all(color: IbTheme.textColor(context).withAlpha(51)),
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
          columns:
              headers
                  .map(
                    (header) => DataColumn(
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
                    ),
                  )
                  .toList(),
          rows:
              dataRows
                  .map(
                    (row) => DataRow(
                      cells:
                          row
                              .map(
                                (cell) => DataCell(
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
                                ),
                              )
                              .toList(),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  static Widget _buildQuiz(BuildContext context, List<String> quizLines) {
    final questions = <QuizQuestion>[];
    String? currentQuestion;
    final currentAnswers = <QuizAnswer>[];

    for (var i = 0; i < quizLines.length; i++) {
      var line = quizLines[i];

      // Remove blockquote prefix if present
      if (line.trim().startsWith('> ')) {
        line = line.trim().substring(2);
      }

      // Count leading spaces to determine nesting level
      final leadingSpaces = line.length - line.trimLeft().length;
      final trimmed = line.trim();

      if (trimmed.isEmpty) continue;

      // Question: 2 spaces indentation, starts with number
      if (leadingSpaces <= 2 && RegExp(r'^\d+\.\s+').hasMatch(trimmed)) {
        // Save previous question if exists
        if (currentQuestion != null && currentAnswers.isNotEmpty) {
          questions.add(
            QuizQuestion(
              question: currentQuestion,
              answers: List.from(currentAnswers),
            ),
          );
          currentAnswers.clear();
        }
        currentQuestion = _parseInlineStyles(
          trimmed.replaceFirst(RegExp(r'^\d+\.\s+'), ''),
        );
        continue;
      }

      // Answers: more than 2 spaces indentation
      if (leadingSpaces > 2) {
        // Correct answer (ordered list)
        if (RegExp(r'^\d+\.\s+').hasMatch(trimmed)) {
          currentAnswers.add(
            QuizAnswer(
              text: _parseInlineStyles(
                trimmed.replaceFirst(RegExp(r'^\d+\.\s+'), ''),
              ),
              isCorrect: true,
            ),
          );
          continue;
        }
        // Incorrect answer (unordered list)
        if (trimmed.startsWith('* ')) {
          currentAnswers.add(
            QuizAnswer(
              text: _parseInlineStyles(trimmed.substring(2)),
              isCorrect: false,
            ),
          );
          continue;
        }
      }
    }

    // Add last question
    if (currentQuestion != null && currentAnswers.isNotEmpty) {
      questions.add(
        QuizQuestion(
          question: currentQuestion,
          answers: List.from(currentAnswers),
        ),
      );
    }

    if (questions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Shuffle answers for each question
    for (var question in questions) {
      question.answers.shuffle();
    }

    return QuizWidget(questions: questions);
  }
}
