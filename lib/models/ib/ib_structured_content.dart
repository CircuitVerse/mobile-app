// Structured content models for Interactive Book
// These models represent pre-parsed content from the API

abstract class IbStructuredContent {
  IbStructuredContent({required this.type});
  final String type;

  factory IbStructuredContent.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'heading':
        return IbHeadingContent.fromJson(json);
      case 'paragraph':
        return IbParagraphContent.fromJson(json);
      case 'list':
        return IbListContent.fromJson(json);
      case 'list_item':
        return IbListItemBlockContent.fromJson(json);
      case 'code_block':
        return IbCodeBlockContent.fromJson(json);
      case 'blockquote':
        return IbBlockquoteContent.fromJson(json);
      case 'table':
        return IbTableContent.fromJson(json);
      case 'quiz':
        return IbQuizContent.fromJson(json);
      case 'binary_simulator':
        return IbBinarySimulatorContent();
      case 'horizontal_rule':
        return IbHorizontalRuleContent();
      default:
        throw Exception('Unknown content type: ${json['type']}');
    }
  }
}

// Inline content (for paragraphs, list items, etc.)
abstract class IbInlineContent {
  IbInlineContent({required this.type});
  final String type;

  factory IbInlineContent.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'text':
        return IbTextContent.fromJson(json);
      case 'bold':
        return IbBoldContent.fromJson(json);
      case 'italic':
        return IbItalicContent.fromJson(json);
      case 'code':
        return IbInlineCodeContent.fromJson(json);
      case 'link':
        return IbLinkContent.fromJson(json);
      default:
        throw Exception('Unknown inline content type: ${json['type']}');
    }
  }
}

class IbTextContent extends IbInlineContent {
  IbTextContent({required this.value}) : super(type: 'text');
  final String value;

  factory IbTextContent.fromJson(Map<String, dynamic> json) {
    return IbTextContent(value: json['value'] ?? '');
  }
}

class IbBoldContent extends IbInlineContent {
  IbBoldContent({required this.value}) : super(type: 'bold');
  final String value;

  factory IbBoldContent.fromJson(Map<String, dynamic> json) {
    return IbBoldContent(value: json['value'] ?? '');
  }
}

class IbItalicContent extends IbInlineContent {
  IbItalicContent({required this.value}) : super(type: 'italic');
  final String value;

  factory IbItalicContent.fromJson(Map<String, dynamic> json) {
    return IbItalicContent(value: json['value'] ?? '');
  }
}

class IbInlineCodeContent extends IbInlineContent {
  IbInlineCodeContent({required this.value}) : super(type: 'code');
  final String value;

  factory IbInlineCodeContent.fromJson(Map<String, dynamic> json) {
    return IbInlineCodeContent(value: json['value'] ?? '');
  }
}

class IbLinkContent extends IbInlineContent {
  IbLinkContent({required this.text, required this.url}) : super(type: 'link');
  final String text;
  final String url;

  factory IbLinkContent.fromJson(Map<String, dynamic> json) {
    return IbLinkContent(text: json['text'] ?? '', url: json['url'] ?? '');
  }
}

// Block content types
class IbHeadingContent extends IbStructuredContent {
  IbHeadingContent({required this.level, required this.text, required this.id})
    : super(type: 'heading');

  final int level;
  final String text;
  final String id;

  factory IbHeadingContent.fromJson(Map<String, dynamic> json) {
    return IbHeadingContent(
      level: json['level'] ?? 1,
      text: json['text'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class IbParagraphContent extends IbStructuredContent {
  IbParagraphContent({required this.content}) : super(type: 'paragraph');
  final List<IbInlineContent> content;

  factory IbParagraphContent.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return IbParagraphContent(
      content:
          contentList.map((item) => IbInlineContent.fromJson(item)).toList(),
    );
  }
}

class IbListItemContent {
  IbListItemContent({required this.content, this.items});
  final List<IbInlineContent> content;
  final List<IbListItemContent>? items;

  factory IbListItemContent.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    final itemsList = json['items'] as List<dynamic>?;

    return IbListItemContent(
      content:
          contentList.map((item) => IbInlineContent.fromJson(item)).toList(),
      items:
          itemsList?.map((item) => IbListItemContent.fromJson(item)).toList(),
    );
  }
}

class IbListContent extends IbStructuredContent {
  IbListContent({required this.ordered, required this.items})
    : super(type: 'list');
  final bool ordered;
  final List<IbListItemContent> items;

  factory IbListContent.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return IbListContent(
      ordered: json['ordered'] ?? false,
      items: itemsList.map((item) => IbListItemContent.fromJson(item)).toList(),
    );
  }
}

class IbCodeBlockContent extends IbStructuredContent {
  IbCodeBlockContent({this.language, required this.code})
    : super(type: 'code_block');
  final String? language;
  final String code;

  factory IbCodeBlockContent.fromJson(Map<String, dynamic> json) {
    return IbCodeBlockContent(
      language: json['language'],
      code: json['code'] ?? '',
    );
  }
}

class IbBlockquoteContent extends IbStructuredContent {
  IbBlockquoteContent({required this.content}) : super(type: 'blockquote');
  final List<IbInlineContent> content;

  factory IbBlockquoteContent.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return IbBlockquoteContent(
      content:
          contentList.map((item) => IbInlineContent.fromJson(item)).toList(),
    );
  }
}

class IbTableContent extends IbStructuredContent {
  IbTableContent({required this.headers, required this.rows})
    : super(type: 'table');
  final List<String> headers;
  final List<List<String>> rows;

  factory IbTableContent.fromJson(Map<String, dynamic> json) {
    final headersList = json['headers'] as List<dynamic>? ?? [];
    final rowsList = json['rows'] as List<dynamic>? ?? [];

    return IbTableContent(
      headers: headersList.map((h) => h.toString()).toList(),
      rows:
          rowsList
              .map(
                (row) =>
                    (row as List<dynamic>)
                        .map((cell) => cell.toString())
                        .toList(),
              )
              .toList(),
    );
  }
}

class IbQuizAnswerContent {
  IbQuizAnswerContent({required this.text, required this.correct});
  final String text;
  final bool correct;

  factory IbQuizAnswerContent.fromJson(Map<String, dynamic> json) {
    return IbQuizAnswerContent(
      text: json['text'] ?? '',
      correct: json['correct'] ?? false,
    );
  }
}

class IbQuizQuestionContent {
  IbQuizQuestionContent({required this.question, required this.answers});
  final String question;
  final List<IbQuizAnswerContent> answers;

  factory IbQuizQuestionContent.fromJson(Map<String, dynamic> json) {
    final answersList = json['answers'] as List<dynamic>? ?? [];
    return IbQuizQuestionContent(
      question: json['question'] ?? '',
      answers:
          answersList
              .map((answer) => IbQuizAnswerContent.fromJson(answer))
              .toList(),
    );
  }
}

class IbQuizContent extends IbStructuredContent {
  IbQuizContent({required this.questions}) : super(type: 'quiz');
  final List<IbQuizQuestionContent> questions;

  factory IbQuizContent.fromJson(Map<String, dynamic> json) {
    final questionsList = json['questions'] as List<dynamic>? ?? [];
    return IbQuizContent(
      questions:
          questionsList.map((q) => IbQuizQuestionContent.fromJson(q)).toList(),
    );
  }
}

class IbBinarySimulatorContent extends IbStructuredContent {
  IbBinarySimulatorContent() : super(type: 'binary_simulator');
}

class IbHorizontalRuleContent extends IbStructuredContent {
  IbHorizontalRuleContent() : super(type: 'horizontal_rule');
}

// List item as a block (for API compatibility)
class IbListItemBlockContent extends IbStructuredContent {
  IbListItemBlockContent({required this.ordered, required this.content})
    : super(type: 'list_item');
  final bool ordered;
  final List<IbInlineContent> content;

  factory IbListItemBlockContent.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return IbListItemBlockContent(
      ordered: json['ordered'] ?? false,
      content:
          contentList.map((item) => IbInlineContent.fromJson(item)).toList(),
    );
  }
}
