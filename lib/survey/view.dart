/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'model.dart';


class SurveyPage extends StatelessWidget {
  final SurveyController surveyController = Get.put(SurveyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Survey')),
      body: Obx(() {
        if (surveyController.questions.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ...surveyController.questions.map((question) {
                return _buildQuestion(question);
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: surveyController.submitSurvey,
                child: Text('Submit Survey'),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuestion(Question question) {
    switch (question.type) {
      case 'yes_no':
        return _buildYesNoQuestion(question);
      case 'multiple_choice':
        return _buildMultipleChoiceQuestion(question);
      case 'text':
        return _buildTextInputQuestion(question);
      default:
        return Text('Unknown question type');
    }
  }

  Widget _buildYesNoQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question??"", style: const TextStyle(fontSize: 18)),
        Row(
          children: [
            _buildChoiceButton(question, 'Yes'),
            const SizedBox(width: 10),
            _buildChoiceButton(question, 'No'),
          ],
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question??"", style: TextStyle(fontSize: 18)),
        Column(
          children: question.options!.map((option) {
            return _buildChoiceButton(question, option);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextInputQuestion(Question question) {
    TextEditingController controller = TextEditingController(text: question.answer);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: (val) {
          surveyController.saveAnswer(question.id??0, val);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: question.question,
        ),
      ),
    );
  }

  Widget _buildChoiceButton(Question question, String option) {
    return ElevatedButton(
      onPressed: () {
        surveyController.saveAnswer(question.id??0, option);
      },
      child: Text(option),
    );
  }
}
*/
