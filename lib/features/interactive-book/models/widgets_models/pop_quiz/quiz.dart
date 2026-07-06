import 'package:mobile_app/features/interactive-book/models/widgets_models/pop_quiz/question.dart';
import 'package:mobile_app/features/interactive-book/models/view.dart';

class PopQuizModel extends ViewModel {
  List<QuestionModel> content;

  PopQuizModel({required this.content}) : super(type: 'widget', subType: 'pop-quiz');

  factory PopQuizModel.fromJson(Map<String, dynamic> json) {
    return PopQuizModel(
      content:
          (json['content'] as List<dynamic>?)
              ?.map((questionJson) => QuestionModel.fromJson(questionJson))
              .toList() ??
          [],
    );
  }
}
