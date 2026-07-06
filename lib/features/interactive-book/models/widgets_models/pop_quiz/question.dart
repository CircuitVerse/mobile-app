class OptionModel {
  String option;
  bool isAnswer;

  OptionModel({required this.option, required this.isAnswer});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      option: json['option'] ?? '',
      isAnswer: json['isAnswer'] ?? json['is_answer'] ?? false,
    );
  }
}

class QuestionModel {
  String question;
  List<OptionModel> options;

  QuestionModel({required this.question, required this.options});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((optionJson) => OptionModel.fromJson(optionJson))
              .toList() ??
          [],
    );
  }
}
