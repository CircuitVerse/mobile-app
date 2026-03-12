import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class QuizQuestion {
  final String question;
  final List<QuizAnswer> answers;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.answers,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as List<dynamic>?;
    final answers =
        options?.map((opt) {
          final optMap = opt as Map<String, dynamic>;
          return QuizAnswer(
            text: optMap['text'] as String,
            isCorrect: optMap['correct'] as bool? ?? false,
          );
        }).toList() ??
        [];

    return QuizQuestion(
      question: json['question'] as String,
      answers: answers,
      explanation: json['explanation'] as String?,
    );
  }
}

class QuizAnswer {
  final String text;
  final bool isCorrect;

  QuizAnswer({required this.text, required this.isCorrect});
}

class QuizWidget extends StatefulWidget {
  final dynamic questions;

  const QuizWidget({super.key, required this.questions});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  final Map<String, bool?> _selectedAnswers = {};
  final Map<int, bool> _showExplanation = {};
  late List<QuizQuestion> _parsedQuestions;

  @override
  void initState() {
    super.initState();
    _parseQuestions();
  }

  void _parseQuestions() {
    if (widget.questions is List<QuizQuestion>) {
      _parsedQuestions = widget.questions as List<QuizQuestion>;
    } else if (widget.questions is List<dynamic>) {
      _parsedQuestions =
          (widget.questions as List<dynamic>)
              .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
              .toList();
    } else {
      _parsedQuestions = [];
    }
  }

  void _selectAnswer(int questionIndex, int answerIndex, bool isCorrect) {
    setState(() {
      _selectedAnswers['$questionIndex-$answerIndex'] = isCorrect;
      _showExplanation[questionIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_parsedQuestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.only(top: 32, bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: IbTheme.textColor(context).withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Pop Quiz',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 24),
            ..._parsedQuestions.asMap().entries.map((entry) {
              final questionIndex = entry.key;
              final question = entry.value;
              return _buildQuestion(context, questionIndex, question);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(
    BuildContext context,
    int questionIndex,
    QuizQuestion question,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Question ${questionIndex + 1}',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: IbTheme.textColor(context).withAlpha(179),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IbTheme.primaryHeadingColor(context),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children:
                question.answers.asMap().entries.map((answerEntry) {
                  final answerIndex = answerEntry.key;
                  final answer = answerEntry.value;
                  final key = '$questionIndex-$answerIndex';
                  final isSelected = _selectedAnswers[key] != null;
                  final isCorrect = answer.isCorrect;

                  Color backgroundColor;
                  Color textColor = IbTheme.textColor(context);
                  Color borderColor = IbTheme.textColor(context).withAlpha(77);

                  if (isSelected) {
                    if (isCorrect) {
                      backgroundColor = const Color(0xFF5cd65c);
                      textColor = Colors.white;
                      borderColor = const Color(0xFF5cd65c);
                    } else {
                      backgroundColor = const Color(0xFFff6666);
                      textColor = Colors.white;
                      borderColor = const Color(0xFFff6666);
                    }
                  } else {
                    backgroundColor = IbTheme.textColor(context).withAlpha(26);
                  }

                  return InkWell(
                    onTap:
                        () => _selectAnswer(
                          questionIndex,
                          answerIndex,
                          isCorrect,
                        ),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 120),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: IbTheme.textColor(context).withAlpha(26),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        answer.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          if (_showExplanation[questionIndex] == true &&
              question.explanation != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.explanation!,
                      style: TextStyle(
                        fontSize: 14,
                        color: IbTheme.textColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
