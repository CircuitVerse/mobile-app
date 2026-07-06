import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/models.dart';

class PopQuizWidget extends StatefulWidget {
  final List<QuestionModel> content;

  const PopQuizWidget({super.key, required this.content});

  @override
  State<PopQuizWidget> createState() => _PopQuizWidgetState();
}

class _PopQuizWidgetState extends State<PopQuizWidget> {
  // selectedIndex[i] = index of the chosen option for question i, or null
  late final List<int?> _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = List.filled(widget.content.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Pop Quiz!',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedIndex.fillRange(0, _selectedIndex.length, null);
                  });
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(widget.content.length, (qIndex) {
            final question = widget.content[qIndex];
            final selected = _selectedIndex[qIndex];

            return Padding(
              padding: EdgeInsets.only(
                bottom: qIndex < widget.content.length - 1 ? 24 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${qIndex + 1}. ${question.question}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 4,
                    children: List.generate(question.options.length, (oIndex) {
                      final opt = question.options[oIndex];
                      final isSelected = selected == oIndex;
                      final hasAnswered = selected != null;

                      Color bgColor = theme.colorScheme.surfaceContainerHighest;
                      Color textColor = theme.colorScheme.onSurface;

                      if (hasAnswered) {
                        if (opt.isAnswer) {
                          bgColor = Colors.green.shade600;
                          textColor = Colors.white;
                        } else if (isSelected && !opt.isAnswer) {
                          bgColor = Colors.red.shade600;
                          textColor = Colors.white;
                        }
                      } else if (isSelected) {
                        bgColor = theme.colorScheme.primary;
                        textColor = theme.colorScheme.onPrimary;
                      }

                      return ElevatedButton(
                        onPressed: hasAnswered
                            ? null
                            : () {
                                setState(() {
                                  _selectedIndex[qIndex] = oIndex;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bgColor,
                          foregroundColor: textColor,
                          disabledBackgroundColor: bgColor,
                          disabledForegroundColor: textColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: isSelected ? 2 : 0,
                        ),
                        child: Text(
                          opt.option,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      question.options[selected].isAnswer
                          ? '✓ Correct!'
                          : '✗ Incorrect. The answer is: ${question.options.firstWhere((o) => o.isAnswer).option}',
                      style: TextStyle(
                        color: question.options[selected].isAnswer
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
