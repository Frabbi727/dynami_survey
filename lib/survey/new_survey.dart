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

  @override
  void initState() {
    super.initState();
    if (!widget.question.singleChoice && widget.question.answerChoices != null) {
      widget.question.answerChoices!.keys.forEach((choice) {
        multiChoiceAnswers[choice] = false;
      });
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
        ],
      ),
    );
  }

  Widget _buildAnswerInput(Question question) {
    if (question.answerChoices != null && question.answerChoices!.isNotEmpty) {
      return question.singleChoice
          ? Column(children: _buildSingleChoiceAnswers(question))
          : Column(children: _buildMultipleChoiceAnswers(question));
    } else {
      return _buildTextInput(); // Text input for open-ended questions
    }
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
          // Track answer with question ID
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
    return question.answerChoices?.keys.map((answer) {
      return CheckboxListTile(
        title: Text(answer),
        value: multiChoiceAnswers[answer],
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
            input=value;
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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
