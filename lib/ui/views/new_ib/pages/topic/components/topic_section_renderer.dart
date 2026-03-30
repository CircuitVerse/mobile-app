import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/ui/views/new_ib/shared/widgets/binary_simulator_widget.dart';
import 'package:mobile_app/ui/views/new_ib/shared/widgets/quiz_widget.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/components/topic_table.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/components/topic_example.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/components/topic_steps.dart';

class TopicSectionRenderer extends StatelessWidget {
  final dynamic section;

  const TopicSectionRenderer({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final sectionType = section['type'] as String?;

    switch (sectionType) {
      case 'heading':
        return _buildHeading(context);
      case 'section':
        return _buildSection(context);
      case 'paragraph':
        return _buildParagraph(context);
      case 'example':
        return TopicExample(data: section);
      case 'subsection':
        return _buildSubsection(context);
      case 'steps':
        return TopicSteps(data: section);
      case 'widget':
        return _buildWidget(context);
      case 'quiz':
        return _buildQuiz(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeading(BuildContext context) {
    final level = section['level'] as int? ?? 1;
    final text = section['text'] as String? ?? '';

    if (level == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: IbTheme.primaryHeadingColor(context),
          ),
        ),
      );
    } else if (level == 2) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: IbTheme.primaryHeadingColor(context),
          ),
        ),
      );
    } else if (level == 3) {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: IbTheme.primaryHeadingColor(context),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSection(BuildContext context) {
    final heading = section['heading'];
    final headingMap = heading != null
        ? (heading is Map<String, dynamic>
            ? heading
            : Map<String, dynamic>.from(heading as Map))
        : null;
    final content = section['content'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headingMap != null) TopicSectionRenderer(section: headingMap),
        ...content.map((item) => TopicSectionRenderer(section: item)).toList(),
      ],
    );
  }

  Widget _buildParagraph(BuildContext context) {
    final text = section['text'] as String? ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: IbTheme.textColor(context).withAlpha(204),
        ),
      ),
    );
  }

  Widget _buildSubsection(BuildContext context) {
    final heading = section['heading'] as String? ?? '';
    final tables = section['tables'] as List<dynamic>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          ),
        ...tables.map((table) => TopicTable(data: table)).toList(),
      ],
    );
  }

  Widget _buildWidget(BuildContext context) {
    final widgetType = section['widget_type'] as String?;

    if (widgetType == 'binary_simulator') {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BinarySimulatorWidget(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildQuiz(BuildContext context) {
    final questionsRaw = section['questions'] as List<dynamic>? ?? [];
    // Convert Map<dynamic, dynamic> to Map<String, dynamic>
    final questions = questionsRaw.map((q) {
      if (q is Map<String, dynamic>) {
        return q;
      } else {
        return Map<String, dynamic>.from(q as Map);
      }
    }).toList();
    return QuizWidget(questions: questions);
  }
}
