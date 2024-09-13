class Question {
  final int id; // Add an id field
  final String question;
  final bool isMandatory;
  final bool singleChoice;
  final Map<String, List<Question>?>? answerChoices;

  Question({
    required this.id, // ID is required
    required this.question,
    this.isMandatory = false,
    this.singleChoice = true,
    this.answerChoices,
  });
}
