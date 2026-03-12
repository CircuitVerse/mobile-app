import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_json_page_data.dart';
import 'package:mobile_app/ui/views/new_ib/components/binary_simulator_widget.dart';
import 'package:mobile_app/ui/views/new_ib/components/quiz_widget.dart';

class JsonContentRenderer extends StatelessWidget {
  const JsonContentRenderer({
    required this.sections,
    required this.headingKeys,
    super.key,
  });

  final List<IbJsonSection> sections;
  final Map<String, GlobalKey> headingKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          sections.map((section) => _renderSection(context, section)).toList(),
    );
  }

  Widget _renderSection(BuildContext context, IbJsonSection section) {
    final data = section.data as Map<String, dynamic>;

    switch (section.type) {
      case 'heading':
        return _buildHeading(context, data);
      case 'paragraph':
        return _buildParagraph(context, data);
      case 'section':
        return _buildSection(context, data);
      case 'example':
        return _buildExample(context, data);
      case 'widget':
        return _buildWidget(context, data);
      case 'quiz':
        return _buildQuiz(context, data);
      case 'steps':
        return _buildSteps(context, data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeading(BuildContext context, Map<String, dynamic> data) {
    final level = data['level'] as int;
    final text = data['text'] as String;
    final id = data['id'] as String?;

    TextStyle? style;
    double topPadding;
    double bottomPadding;

    switch (level) {
      case 1:
        style = Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.bold,
        );
        topPadding = 24;
        bottomPadding = 16;
        break;
      case 2:
        style = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        );
        topPadding = 20;
        bottomPadding = 12;
        break;
      case 3:
        style = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        );
        topPadding = 16;
        bottomPadding = 10;
        break;
      case 4:
        style = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        );
        topPadding = 14;
        bottomPadding = 8;
        break;
      case 5:
        style = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w500,
        );
        topPadding = 12;
        bottomPadding = 6;
        break;
      default:
        style = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w500,
        );
        topPadding = 10;
        bottomPadding = 6;
    }

    if (id != null && !headingKeys.containsKey(id)) {
      headingKeys[id] = GlobalKey();
    }

    return Padding(
      key: id != null ? headingKeys[id] : null,
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(text, style: style),
    );
  }

  Widget _buildParagraph(BuildContext context, Map<String, dynamic> data) {
    final text = data['text'] as String;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: IbTheme.textColor(context),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, Map<String, dynamic> data) {
    final heading = data['heading'] as Map<String, dynamic>?;
    final content = data['content'] as List<dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) _buildHeading(context, heading),
        if (content != null)
          ...content.map((item) {
            final itemData = item as Map<String, dynamic>;
            final type = itemData['type'] as String;
            return _renderSection(
              context,
              IbJsonSection(type: type, data: itemData),
            );
          }),
      ],
    );
  }

  Widget _buildExample(BuildContext context, Map<String, dynamic> data) {
    final title = data['title'] as String?;
    final exampleData = data['data'] as Map<String, dynamic>?;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: IbTheme.primaryHeadingColor(context).withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: IbTheme.primaryHeadingColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (exampleData != null) _buildExampleData(context, exampleData),
        ],
      ),
    );
  }

  Widget _buildExampleData(BuildContext context, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: IbTheme.textColor(context),
                  ),
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: entry.value.toString()),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildWidget(BuildContext context, Map<String, dynamic> data) {
    final widgetType = data['widget_type'] as String?;

    if (widgetType == 'binary_simulator') {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BinarySimulatorWidget(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildQuiz(BuildContext context, Map<String, dynamic> data) {
    final questions = data['questions'] as List<dynamic>?;
    if (questions == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: QuizWidget(questions: questions),
    );
  }

  Widget _buildSteps(BuildContext context, Map<String, dynamic> data) {
    final title = data['title'] as String?;
    final steps = data['steps'] as List<dynamic>?;
    final note = data['note'] as String?;

    if (steps == null || steps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: IbTheme.primaryHeadingColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ...steps.map((step) {
            final stepData = step as Map<String, dynamic>;
            final stepNumber = stepData['step'] as int;
            final description = stepData['description'] as String;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: IbTheme.primaryHeadingColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        stepNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: IbTheme.textColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Note: $note',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: IbTheme.textColor(context).withAlpha(179),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
