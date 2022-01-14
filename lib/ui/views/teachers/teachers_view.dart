import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/teachers/components/teachers_card.dart';

class TeachersView extends StatelessWidget {
  const TeachersView({Key? key, this.showAppBar = true}) : super(key: key);

  static const String id = 'teachers_view';
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const <Widget>[
            CVHeader(
              title: 'TEACHERS',
              description:
                  'CircuitVerse has been designed to be very easy to use in class. The platform has features to assist teachers in class and assignments.',
            ),
            CVSubheader(title: 'Benefits'),
            TeachersCard(
              assetPath: 'assets/images/teachers/groups.png',
              cardHeading: 'Create Groups and add your students',
              cardDescription:
                  'You can create groups and add your students to them! If students are already registered with CircuitVerse they will be added automatically. If they are not registered with CircuitVerse yet, an invitation will be sent to register. Once they register, they will be added automatically.',
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/assignment.png',
              cardHeading: 'Post Assignments',
              cardDescription:
                  'To create an assignment, simply click an add new assignment button. Give the details of the assignment and the deadline. The assignment will automatically close at deadline. Students cannot continue their assignment unless the teacher reopens the assignment again.',
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/grading.png',
              cardHeading: 'Grading assignments',
              cardDescription:
                  'Grade assignments very easily with the in build preview. Simply select the student, to his/her assignment work.',
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/embed.png',
              cardHeading:
                  'Use Interactive Circuits in your Blogs, Study Materials or PowerPoint presentations',
              cardDescription:
                  'Make sure the project is public. Click on embed, to get the embed HTML5 code, then simply embed the circuit. You may need to use a PowerPoint plugin like Live Slides to embed the live Circuit.',
            ),
          ],
        ),
      ),
    );
  }
}
