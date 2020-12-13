import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/ui/views/ib/ib_post_data.dart';

class IbPostView extends StatefulWidget {
  static const String id = 'ib_post_view';
  final String postId;

  const IbPostView({Key key, this.postId}) : super(key: key);

  @override
  _IbPostViewState createState() => _IbPostViewState();
}

class _IbPostViewState extends State<IbPostView> {
  final RegExp p_md = RegExp(r'^[\sA-Za-z]+');
  final RegExp headings_md = RegExp(r'([#]+)\s(.+)');
  final RegExp md_tags = RegExp(r'^{:\s(.+)}$');

  // Customize Styles here
  TextStyle getThemeData(int headings_weight) {
    switch (headings_weight) {
      case 1:
        return Theme.of(context).textTheme.headline3;
        break;
      case 2:
        return Theme.of(context).textTheme.headline4;
        break;
      case 3:
        return Theme.of(context).textTheme.headline5;
        break;
      default:
        return Theme.of(context).textTheme.headline6;
    }
  }

  // Heading widget
  Widget _buildHeadingsWidget(String content, int headings_weight) => Text(
        content,
        style: getThemeData(headings_weight).copyWith(
          fontWeight: FontWeight.w400,
          color: AppTheme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      );

  // Text Widget
  Widget _buildTextWidget(String content) => Text(content);

  // Markdown Block Parser
  Widget mdParser(String block) {
    //print('[->] ' + block);

    if (headings_md.hasMatch(block)) {
      // Headings Markdown
      var headings_weight =
          headings_md.firstMatch(block)?.group(1)?.length ?? 1;
      return _buildHeadingsWidget(
          headings_md.firstMatch(block)?.group(2), headings_weight);
    } else if (p_md.hasMatch(block)) {
      // Paragraphs
      return _buildTextWidget(block);
    } else if (md_tags.hasMatch(block)) {
      // Md tags - NOT SUPPORTED
      return Container();
    } else {
      return Container();
    }
  }

  // Main Interactive Book Parser
  List<Widget> IbParser() {
    var widgets = <Widget>[];

    // Assume raw content is coming here through API call
    var content = post_data['raw_content'] as String;

    for (final block in content.split(RegExp(r'\n+'))) {
      widgets.add(mdParser(block));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Book Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: IbParser(),
        ),
      ),
    );
  }
}
