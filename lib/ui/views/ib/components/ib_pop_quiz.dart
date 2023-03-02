import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_pop_quiz_question.dart';
import 'package:mobile_app/ui/views/ib/components/ib_pop_quiz_button.dart';

class IbPopQuiz extends StatelessWidget {
  const IbPopQuiz({
    Key? key,
    required this.context,
    required this.questions,
  }) : super(key: key);

  final BuildContext context;
  final List<IbPopQuizQuestion> questions;

  Widget _buildQuestion(int questionNumber, IbPopQuizQuestion question) {
    var buttonsWidgets = <Widget>[];

    for (var i = 0; i < question.choices.length; i++) {
      buttonsWidgets.add(
        IbPopQuizButton(
          content: question.choices[i],
          isCorrect: question.answers.contains(i),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $questionNumber',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MarkdownBody(data: question.question),
          ),
          ...buttonsWidgets,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var questionsWidgets = <Widget>[];

    for (var i = 0; i < questions.length; i++) {
      questionsWidgets.add(_buildQuestion(i + 1, questions[i]));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Pop Quiz',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: IbTheme.primaryHeadingColor(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...questionsWidgets,
      ],
    );
  }
}
