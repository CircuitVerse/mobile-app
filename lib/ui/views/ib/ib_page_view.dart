import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/home/home_viewmodel.dart';

class IbPageView extends StatefulWidget {
  static const String id = 'ib_page_view';
  final String page_id;

  IbPageView({this.page_id = 'index.md'});

  @override
  _IbPageViewState createState() => _IbPageViewState();
}

class _IbPageViewState extends State<IbPageView> {
  Widget _buildHeadings1(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline4.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }

  Widget _buildHeadings2(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildHeadings3(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildSubtitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        content,
        textAlign: TextAlign.justify,
        style: TextStyle(
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        'Copyright © 2021 Contributors to CircuitVerse. Distributed under a [CC-by-sa] license.',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, model, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeadings1('Interactive-Book'),
            _buildSubtitle('Learn Digital Logic Design easily.'),
            _buildParagraph(
                'The Computer Logical Organization is basically the abstraction which is below the operating system and above the digital logic level. Now at this point, the important points are the functional units/subsystems that refer to some hardware which is made up of lower level building blocks.'),
            _buildParagraph(
              'This interactive book gives a complete understanding on Computer Logical Organization starting from basic computer overview till the advanced level. This book is aimed to provide the knowledge to the reader on how to analyze the combinational and sequential circuits and implement them. You can use the combinational circuit/sequential circuit/combination of both the circuits, as per the requirement. After completing this book, you will be able to implement the type of digital circuit, which is suitable for specific application.',
            ),
            _buildDivider(),
            _buildHeadings2('Audience'),
            _buildParagraph(
              'This book is mainly prepared for the students who are interested in the concepts of digital circuits and Computer Logical Organization. Digital circuits contain a set of Logic gates and these can be operated with binary values, 0 and 1.',
            ),
            _buildHeadings3('Prerequistes'),
            _buildParagraph(
                'Before you start learning from this Book, I hope that you have some basic knowledge about computers and how they work. A basic idea regarding the initial concepts of Digital Electronics is enough to understand the topics covered in this tutorial.'),
            _buildDivider(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }
}
