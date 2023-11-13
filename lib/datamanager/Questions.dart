class Question {
  String title;
  String question;

  Question({required this.title, required this.question});

  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      title: data['title'],
      question: data['question'],
    );
  }
}