class QuestionModel {
  final int id;
  final String question;
  final String? description;
  final bool isMandatory;
  final bool singleChoice;
  final Map<String, List<QuestionModel>?>? answerChoices;
  final List<String>? dropdownOptions;
  final Map<String, List<QuestionModel>?>? dropdownFollowUps;
  QuestionModel({
    required this.id,
    required this.question,
    this.isMandatory = false,
    this.singleChoice = true,
    this.answerChoices,
    this.dropdownOptions,
    this.dropdownFollowUps,
    this.description,// Initialize new field
  });
}
