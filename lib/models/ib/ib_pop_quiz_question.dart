import 'package:flutter/cupertino.dart';

class IbPopQuizQuestion {
  final String question;
  List<int> answers;
  List<String> choices;

  IbPopQuizQuestion(
      {@required this.question,
      @required this.answers,
      @required this.choices});
}
