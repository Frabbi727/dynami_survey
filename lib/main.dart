
import 'package:dynamic_question/survey/new_survey.dart';
import 'package:flutter/material.dart';

import 'survey/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Survey Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,

      home: const MyHomePage(title: 'Flutter Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> answers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          itemCount: _sampleQuestions.length,
          itemBuilder: (context, index) {
            return QuestionWidget(

              question: _sampleQuestions[index],
              onAnswerSelected: (answer) {
                setState(() {
                  answers.add(answer); // Collect answers with ID
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateAndSubmit,
        child: Icon(Icons.check),
      ),
    );
  }

  void _validateAndSubmit() {
    bool isValid = true;

    // Validate if all mandatory questions have answers
    for (var question in _sampleQuestions) {
      if (question.isMandatory &&
          !answers.any((element) => element["id"] == question.id)) {
        isValid = false;
        break;
      }
    }

    if (isValid) {
      // Show the collected answers along with the question object
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Survey Completed"),
            content: SingleChildScrollView(
              child: Column(
                children: answers.map((answer) {
                  return Text(answer.toString());
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print(answers);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please answer all mandatory questions"),
        backgroundColor: Colors.red,
      ));
    }
  }

  final List<Question> _sampleQuestions = [
    // Single-choice question with follow-up
    Question(
      id: 1,
      question: 'Do you like coffee?',
      isMandatory: true,
      singleChoice: true,
      answerChoices: {
        "Yes": [
          Question(
            id: 2,
            question: "Which coffee brands have you tried?",
            isMandatory: true,
            singleChoice: false, // Multiple-choice
            answerChoices: {
              "Nestle": null,
              "Starbucks": null,
              "Coffee Day": [
                Question(
                  id: 3,
                  question: "Did you enjoy Coffee Day?",
                  isMandatory: true,
                  answerChoices: {
                    "Yes": [
                      Question(
                        id: 4,
                        question: "Tell us why you like it",
                        isMandatory: true,
                      ),
                    ],
                    "No": [
                      Question(
                        id: 5,
                        question: "What didn't you like?",
                        isMandatory: true,
                      ),
                    ],
                  },
                )
              ],
            },
          ),
        ],
        "No": [
          Question(
            id: 5,
            question: "Do you prefer tea?",
            answerChoices: {
              "Yes": [
                Question(
                  id: 7,
                  question: "Which tea brands do you prefer?",
                  singleChoice: false, // Multiple-choice
                  answerChoices: {
                    "ChaiBucks": null,
                    "Lipton": null,
                    "Tata Tea": null,
                  },
                ),
              ],
              "No": null,
            },
          ),
        ],
      },
    ),

    // Text input question
    Question(
      id: 8,
      question: "Please describe your ideal beverage",
      isMandatory: true,
    ),

    // Multiple-choice question (no follow-ups)
    Question(
      id: 9,

      question: "Which fruits do you like?",
      singleChoice: false, // Multiple-choice
      isMandatory: true,
      answerChoices: {
        "Apple": null,
        "Banana": null,
        "Mango": null,
        "Orange": null,
      },
    ),

    // Single-choice question (no follow-ups)
    Question(
      id: 10,
      question: "Which age group do you belong to?",
      isMandatory: true,
      answerChoices: {
        "18-25": null,
        "26-35": null,
        "36-45": null,
        "46 and above": null,
      },
    ),
  ];
}
