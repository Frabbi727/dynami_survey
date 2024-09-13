class QuestionModel {
  final int id;
  final String question;
  final bool isMandatory;
  final bool singleChoice;
  final Map<String, List<QuestionModel>?>? answerChoices;
  final List<String>? dropdownOptions;
  final Map<String, List<QuestionModel>?>? dropdownFollowUps; // Follow-up questions based on dropdown selection

  QuestionModel({
    required this.id,
    required this.question,
    this.isMandatory = false,
    this.singleChoice = true,
    this.answerChoices,
    this.dropdownOptions,
    this.dropdownFollowUps, // Initialize new field
  });
}
