import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'model.dart';

// class SurveyController extends GetxController {
//   var questions = <Question>[].obs;
//   var isSubmitted = false.obs;
//
//   @override
//   void onInit() {
//     loadQuestions();
//     super.onInit();
//   }
//
//   void loadQuestions() async {
//     final String response = await rootBundle.loadString('assets/questions.jso/**/n');
//     final data = await json.decode(response);
//     questions.value = List<Question>.from(data.map((q) => Question.fromJson(q)));
//   }
//
//   void saveAnswer(int id, String answer) {
//     Question question = questions.firstWhere((q) => q.id == id);
//     question.answer = answer;
//     update();
//   }
//
//   bool validateAnswers() {
//     for (var question in questions) {
//       if (question.answer == null || question.answer!.isEmpty) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   void submitSurvey() {
//     if (validateAnswers()) {
//       isSubmitted.value = true;
//       // Save logic, for example, send data to server or store locally
//       print("Survey submitted: ${questions.map((q) => q.toJson()).toList()}");
//     } else {
//       Get.snackbar('Error', 'Please answer all the questions before submitting.');
//     }
//   }
// }
