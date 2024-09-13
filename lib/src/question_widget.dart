import 'package:flutter/material.dart';

import 'model.dart';


class QuestionWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<Map<String, dynamic>> onAnswerSelected;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final Color? inputBorderColor;
  final Color? radioButtonColor;
  final Color? checkBoxColor;
  final TextStyle? textFieldStyle;
  final InputDecoration? textFieldDecoration;

  QuestionWidget({
    required this.question,
    required this.onAnswerSelected,
    this.textColor,
    this.padding,
    this.margin,
    this.fontSize,
    this.inputBorderColor,
    this.radioButtonColor,
    this.checkBoxColor,
    this.textFieldStyle,
    this.textFieldDecoration,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;
  List<Question>? followUpQuestions;
  Map<String, bool> multiChoiceAnswers = {};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  String? selectedDropdownValue;
  List<Question>? dropdownFollowUps;

  @override
  void initState() {
    super.initState();
    if (!widget.question.singleChoice && widget.question.answerChoices != null) {
      multiChoiceAnswers = Map.fromIterable(
        widget.question.answerChoices!.keys,
        key: (key) => key as String,
        value: (value) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? EdgeInsets.all(16.0),
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
            style: TextStyle(
              fontSize: widget.fontSize ?? 16,
              color: widget.textColor ?? Colors.black,
            ),
          ),
          _buildAnswerInput(widget.question),
          if (followUpQuestions != null) ..._buildFollowUpQuestions(),
          if (dropdownFollowUps != null) ..._buildDropdownFollowUps(),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(Question question) {
    if (question.dropdownOptions != null && question.dropdownOptions!.isNotEmpty) {
      return _buildDropdown(question);
    } else if (question.answerChoices != null && question.answerChoices!.isNotEmpty) {
      return question.singleChoice
          ? Column(children: _buildSingleChoiceAnswers(question))
          : Column(children: _buildMultipleChoiceAnswers(question));
    } else {
      return _buildTextInput(); // Text input for open-ended questions
    }
  }

  Widget _buildDropdown(Question question) {
    return DropdownButtonFormField<String>(
      value: selectedDropdownValue,
      decoration: InputDecoration(
        labelText: question.question,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.inputBorderColor ?? Colors.grey),
        ),
      ),
      items: question.dropdownOptions?.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toSet().toList(), // Ensure unique items
      onChanged: (value) {
        setState(() {
          selectedDropdownValue = value;
          dropdownFollowUps = question.dropdownFollowUps?[value];
        });
        widget.onAnswerSelected({
          "id": question.id,
          "question": question.question,
          "answer": selectedDropdownValue,
        });
      },
    );
  }



  List<Widget> _buildSingleChoiceAnswers(Question question) {
    return question.answerChoices?.keys.map((answer) {
      return RadioListTile<String>(
        title: Text(answer),
        value: answer,
        groupValue: selectedAnswer,
        onChanged: (value) {
          setState(() {
            selectedAnswer = value;
            followUpQuestions = question.answerChoices?[value];
          });
          widget.onAnswerSelected({
            "id": question.id,
            "question": question.question,
            "answer": value,
          });
        },
        activeColor: widget.radioButtonColor ?? Colors.blue,
      );
    }).toList() ?? [];
  }

  List<Widget> _buildMultipleChoiceAnswers(Question question) {
    // Initialize multiChoiceAnswers only if it's empty or null
    if (multiChoiceAnswers.isEmpty) {
      multiChoiceAnswers = Map.fromIterable(
        question.answerChoices!.keys,
        key: (key) => key as String,
        value: (value) => false,
      );
    }

    return question.answerChoices?.keys.map((answer) {
      return CheckboxListTile(
        title: Text(answer),
        value: multiChoiceAnswers[answer] ?? false, // Ensure non-null value
        onChanged: (bool? value) {
          setState(() {
            multiChoiceAnswers[answer] = value ?? false;
          });
          widget.onAnswerSelected({
            "id": question.id,
            "question": question.question,
            "answer": multiChoiceAnswers,
          });
        },
        activeColor: widget.checkBoxColor ?? Colors.blue,
      );
    }).toList() ?? [];
  }

  Widget _buildTextInput() {
    String? input;
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: textController,
        style: widget.textFieldStyle ?? TextStyle(color: Colors.black),
        decoration: widget.textFieldDecoration ?? InputDecoration(
          hintText: "Type your answer here",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.inputBorderColor ?? Colors.grey),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            input = value;
            widget.onAnswerSelected({
              "id": widget.question.id,
              "question": widget.question.question,
              "answer": input,
            });
          }
        },
        validator: (value) {
          if (widget.question.isMandatory && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  List<Widget> _buildFollowUpQuestions() {
    return followUpQuestions?.map((q) => QuestionWidget(
      question: q,
      onAnswerSelected: widget.onAnswerSelected,
      textColor: widget.textColor,
      padding: widget.padding,
      margin: widget.margin,
      fontSize: widget.fontSize,
      inputBorderColor: widget.inputBorderColor,
      radioButtonColor: widget.radioButtonColor,
      checkBoxColor: widget.checkBoxColor,
      textFieldStyle: widget.textFieldStyle,
      textFieldDecoration: widget.textFieldDecoration,
    )).toList() ?? [];
  }

  List<Widget> _buildDropdownFollowUps() {
    return dropdownFollowUps?.map((q) => QuestionWidget(
      question: q,
      onAnswerSelected: widget.onAnswerSelected,
      textColor: widget.textColor,
      padding: widget.padding,
      margin: widget.margin,
      fontSize: widget.fontSize,
      inputBorderColor: widget.inputBorderColor,
      radioButtonColor: widget.radioButtonColor,
      checkBoxColor: widget.checkBoxColor,
      textFieldStyle: widget.textFieldStyle,
      textFieldDecoration: widget.textFieldDecoration,
    )).toList() ?? [];
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
