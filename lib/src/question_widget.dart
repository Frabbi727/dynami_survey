import 'package:dynamic_question/src/question_model.dart';
import 'package:flutter/material.dart';


class QuestionForm extends StatefulWidget {
  final List<QuestionModel> questions;
  final Color? buttonColor;
  final String submitButtonText;
  final Color? buttonTextColor;
  final TextStyle? buttonTextStyle;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final Color? inputBorderColor;
  final Color? radioButtonColor;
  final Color? checkBoxColor;
  final TextStyle? textFieldStyle;
  final InputDecoration? textFieldDecoration;
  final void Function(List<Map<String, dynamic>>)? onSubmit; // Callback for form submission

  QuestionForm({
    required this.questions,
    this.submitButtonText = 'Submit',
    this.buttonColor,
    this.buttonTextColor,
    this.buttonTextStyle,
    this.buttonPadding,
    this.textColor,
    this.padding,
    this.margin,
    this.fontSize,
    this.inputBorderColor,
    this.radioButtonColor,
    this.checkBoxColor,
    this.textFieldStyle,
    this.textFieldDecoration,
    this.onSubmit, // Initialize the callback
  });

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _answers = [];

  void _onAnswerSelected(Map<String, dynamic> answer) {
    setState(() {
      // If answer for this question ID already exists, update it
      final index = _answers.indexWhere((element) => element['id'] == answer['id']);
      if (index != -1) {
        _answers[index] = answer;
      } else {
        _answers.add(answer);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Call the onSubmit callback with the answers
      if (widget.onSubmit != null) {
        widget.onSubmit!(_answers);
      } else {
        // Handle the case where no callback is provided
        for (var answer in _answers) {
          print('Question ID: ${answer["id"]}, Answer: ${answer["answer"]}');
        }
      }
    } else {
      // Handle form validation errors
      print('Form validation failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                return QuestionWidget(
                  question: widget.questions[index],
                  onAnswerSelected: _onAnswerSelected,
                  textColor: widget.textColor,
                  padding: widget.padding,
                  margin: widget.margin,
                  fontSize: widget.fontSize,
                  inputBorderColor: widget.inputBorderColor,
                  radioButtonColor: widget.radioButtonColor,
                  checkBoxColor: widget.checkBoxColor,
                  textFieldStyle: widget.textFieldStyle,
                  textFieldDecoration: widget.textFieldDecoration,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 70,
              padding: widget.buttonPadding ?? EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.buttonColor ?? Theme.of(context).primaryColor,
                ),
                child: Text(
                  widget.submitButtonText,
                  style: widget.buttonTextStyle ??
                      TextStyle(
                        color: widget.buttonTextColor ?? Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class QuestionWidget extends StatefulWidget {
  final QuestionModel question;
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
  List<QuestionModel>? followUpQuestions;
  Map<String, bool> multiChoiceAnswers = {};
  final TextEditingController textController = TextEditingController();
  String? selectedDropdownValue;
  List<QuestionModel>? dropdownFollowUps;
  bool hasValidationError = false;

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
          Row(
            children: [
              Flexible(
                child: Text(
                  widget.question.question,
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 16,
                    color: widget.textColor ?? Colors.black,
                  ),
                ),
              ),
              if (widget.question.isMandatory)
                Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: widget.fontSize ?? 16),
                ),
            ],
          ),
          if (widget.question.description != null && widget.question.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.question.description!,
                style: TextStyle(
                  fontSize: (widget.fontSize ?? 16) * 0.8,
                  color: widget.textColor?.withOpacity(0.7) ?? Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          SizedBox(height: 8.0),
          _buildAnswerInput(widget.question),
          if (hasValidationError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'This field is required',
                style: TextStyle(color: Colors.red, fontSize: (widget.fontSize ?? 16) * 0.8),
              ),
            ),
          if (followUpQuestions != null && followUpQuestions!.isNotEmpty) ..._buildFollowUpQuestions(),
          if (dropdownFollowUps != null && dropdownFollowUps!.isNotEmpty) ..._buildDropdownFollowUps(),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(QuestionModel question) {
    if (question.dropdownOptions != null && question.dropdownOptions!.isNotEmpty) {
      return _buildDropdown(question);
    } else if (question.answerChoices != null && question.answerChoices!.isNotEmpty) {
      return question.singleChoice
          ? Column(children: _buildSingleChoiceAnswers(question))
          : Column(children: _buildMultipleChoiceAnswers(question));
    } else {
      return _buildTextInput();
    }
  }

  Widget _buildDropdown(QuestionModel question) {
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
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDropdownValue = value;
          dropdownFollowUps = question.dropdownFollowUps?[value];
          hasValidationError = false;
        });
        widget.onAnswerSelected({
          "id": question.id,
          "question": question.question,
          "answer": selectedDropdownValue,
        });
      },
      validator: (value) {
        if (widget.question.isMandatory && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  List<Widget> _buildSingleChoiceAnswers(QuestionModel question) {
    return question.answerChoices?.keys.map((answer) {
      return RadioListTile<String>(
        title: Text(answer),
        value: answer,
        groupValue: selectedAnswer,
        onChanged: (value) {
          setState(() {
            selectedAnswer = value;
            followUpQuestions = question.answerChoices?[value];
            hasValidationError = false;
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

  List<Widget> _buildMultipleChoiceAnswers(QuestionModel question) {
    return question.answerChoices?.keys.map((answer) {
      return CheckboxListTile(
        title: Text(answer),
        value: multiChoiceAnswers[answer] ?? false,
        onChanged: (bool? value) {
          setState(() {
            multiChoiceAnswers[answer] = value ?? false;
            followUpQuestions = [];
            multiChoiceAnswers.forEach((key, isSelected) {
              if (isSelected) {
                followUpQuestions?.addAll(question.answerChoices?[key] ?? []);
              }
            });
            hasValidationError = false;
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
    return TextFormField(
      controller: textController,
      style: widget.textFieldStyle ?? TextStyle(color: Colors.black),
      decoration: widget.textFieldDecoration ?? InputDecoration(
        hintText: "Type your answer here",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.inputBorderColor ?? Colors.grey),
        ),
      ),
      onChanged: (value) {
        setState(() {
          hasValidationError = value.isEmpty && widget.question.isMandatory;
        });
        widget.onAnswerSelected({
          "id": widget.question.id,
          "question": widget.question.question,
          "answer": value,
        });
      },
      validator: (value) {
        if (widget.question.isMandatory && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  List<Widget> _buildFollowUpQuestions() {
    return followUpQuestions?.map((q) {
      return QuestionWidget(
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
      );
    }).toList() ?? [];
  }

  List<Widget> _buildDropdownFollowUps() {
    return dropdownFollowUps?.map((q) {
      return QuestionWidget(
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
      );
    }).toList() ?? [];
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}


