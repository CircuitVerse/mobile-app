import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_structured_content.dart';
import 'package:mobile_app/ui/views/new_ib/components/binary_simulator_widget.dart';
import 'package:mobile_app/ui/views/new_ib/components/quiz_widget.dart';

class StructuredContentRenderer extends StatelessWidget {
  const StructuredContentRenderer({
    required this.content,
    required this.headingKeys,
    super.key,
  });

  final List<IbStructuredContent> content;
  final Map<String, GlobalKey> headingKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((block) => _renderBlock(context, block)).toList(),
    );
  }

  Widget _renderBlock(BuildContext context, IbStructuredContent block) {
    if (block is IbHeadingContent) {
      return _buildHeading(context, block);
    } else if (block is IbParagraphContent) {
      return _buildParagraph(context, block);
    } else if (block is IbListItemBlockContent) {
      return _buildListItem(context, block);
    } else if (block is IbCodeBlockContent) {
      return _buildCodeBlock(context, block);
    } else if (block is IbBlockquoteContent) {
      return _buildBlockquote(context, block);
    } else if (block is IbTableContent) {
      return _buildTable(context, block);
    } else if (block is IbQuizContent) {
      return _buildQuiz(context, block);
    } else if (block is IbBinarySimulatorContent) {
      return const BinarySimulatorWidget();
    } else if (block is IbHorizontalRuleContent) {
      return _buildHorizontalRule(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeading(BuildContext context, IbHeadingContent heading) {
    TextStyle? style;
    double topPadding;
    double bottomPadding;

    switch (heading.level) {
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

    // Store heading key for navigation
    if (!headingKeys.containsKey(heading.id)) {
      headingKeys[heading.id] = GlobalKey();
    }

    return Padding(
      key: headingKeys[heading.id],
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(heading.text, style: style),
    );
  }

  Widget _buildParagraph(BuildContext context, IbParagraphContent paragraph) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildRichText(context, paragraph.content),
    );
  }

  Widget _buildListItem(BuildContext context, IbListItemBlockContent listItem) {
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
          Expanded(child: _buildRichText(context, listItem.content)),
        ],
      ),
    );
  }

  Widget _buildRichText(
    BuildContext context,
    List<IbInlineContent> inlineContent,
  ) {
    final spans = <InlineSpan>[];

    for (final inline in inlineContent) {
      if (inline is IbTextContent) {
        spans.add(
          TextSpan(
            text: inline.value,
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        );
      } else if (inline is IbBoldContent) {
        spans.add(
          TextSpan(
            text: inline.value,
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        );
      } else if (inline is IbItalicContent) {
        spans.add(
          TextSpan(
            text: inline.value,
            style: TextStyle(
              color: IbTheme.textColor(context),
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        );
      } else if (inline is IbInlineCodeContent) {
        spans.add(
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: IbTheme.textColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                inline.value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: IbTheme.getPrimaryColor(context),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      } else if (inline is IbLinkContent) {
        spans.add(
          TextSpan(
            text: inline.text,
            style: TextStyle(
              color: IbTheme.getPrimaryColor(context),
              fontSize: 16,
              decoration: TextDecoration.underline,
              height: 1.6,
            ),
          ),
        );
      }
    }

    if (spans.isEmpty) {
      return const SizedBox.shrink();
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildCodeBlock(BuildContext context, IbCodeBlockContent codeBlock) {
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
          codeBlock.code,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            color: IbTheme.textColor(context),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBlockquote(
    BuildContext context,
    IbBlockquoteContent blockquote,
  ) {
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
        child: _buildRichText(context, blockquote.content),
      ),
    );
  }

  Widget _buildTable(BuildContext context, IbTableContent table) {
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
              table.headers
                  .map(
                    (header) => DataColumn(
                      label: Expanded(
                        child: Text(
                          header,
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
              table.rows
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
                                      cell,
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

  Widget _buildQuiz(BuildContext context, IbQuizContent quiz) {
    final questions =
        quiz.questions
            .map(
              (q) => QuizQuestion(
                question: q.question,
                answers:
                    q.answers
                        .map(
                          (a) => QuizAnswer(text: a.text, isCorrect: a.correct),
                        )
                        .toList(),
              ),
            )
            .toList();

    return QuizWidget(questions: questions);
  }

  Widget _buildHorizontalRule(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 1.5,
      color: Theme.of(context).dividerColor,
    );
  }
}
