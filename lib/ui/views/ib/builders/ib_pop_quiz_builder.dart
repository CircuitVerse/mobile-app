import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/ui/views/ib/components/ib_pop_quiz.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';

class IbPopQuizBuilder extends MarkdownElementBuilder {
  IbPopQuizBuilder({required this.context, required this.model});

  final BuildContext context;
  final IbPageViewModel model;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var _rawContent = element.textContent;
    var _popQuizQuestions = model.fetchPopQuiz(_rawContent);

    if (_popQuizQuestions == null) return Container();

    return IbPopQuiz(
      context: context,
      questions: _popQuizQuestions,
    );
  }
}
