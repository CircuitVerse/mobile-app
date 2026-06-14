import 'package:flutter/material.dart';
import 'navbar.dart';
import 'widgets/features-grid.dart';
import 'widgets/getting-started.dart';

class InteractiveBook extends StatelessWidget {
  const InteractiveBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Interactive Book')),
      drawer: Navbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Color.fromARGB(255, 19, 184, 129),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 60, color: Colors.white),
                  Text(
                    "Interactive Book",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Learn, Explore and thrive",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 214, 214, 214),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The Computer Logical Organization is basically the abstraction which is below the operating system and above the digital logic level. Now at this point, the important points are the functional units/subsystems that refer to some hardware which is made up of lower level building blocks. This interactive book gives a complete understanding on Computer Logical Organization starting from basic computer overview till the advanced level. This book is aimed to provide the knowledge to the reader on how to analyze the combinational and sequential circuits and implement them. You can use the combinational circuit/sequential circuit/combination of both the circuits, as per the requirement. After completing this book, you will be able to implement the type of digital circuit, which is suitable for specific application.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Text(
                    "Audience",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    "This book is mainly prepared for the students who are interested in the concepts of digital circuits and Computer Logical Organization. Digital circuits contain a set of Logic gates and these can be operated with binary values, 0 and 1.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Text(
                    "Prerequisites",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    "Before you start learning from this Book, I hope that you have some basic knowledge about computers and how they work. A basic idea regarding the initial concepts of Digital Electronics is enough to understand the topics covered in this tutorial.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            FeaturesGrid(),
            GettingStarted(),
          ],
        ),
      ),
    );
  }
}

