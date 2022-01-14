class IbPopQuizQuestion {
  IbPopQuizQuestion({
    required this.question,
    required this.answers,
    required this.choices,
  });

  final String question;
  List<int> answers;
  List<String> choices;
}
