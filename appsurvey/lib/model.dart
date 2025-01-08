import 'dart:math' as math;

class Question {
  final String question;
  final List<String> possibleAnswers;
  final int correctAnswer;
  Question(this.question, this.possibleAnswers, this.correctAnswer);
}

class QuestionBank {
  final List<Question> _questions = _createQuestions();

  bool get hasNextQuestion => _questions.isNotEmpty;
  int get remainingQuestions => _questions.length;

  Question? getRandomQuestion() {
    if (_questions.isEmpty) {
      return null;
    }

    var i = math.Random().nextInt(_questions.length);
    var question = _questions[i];

    _questions.removeAt(i);
    return question;
  }
}

List<Question> _createQuestions() {
  return [
    Question(
      'Vui lòng chia sẻ trải nghiệm của bạn?',
      ['Không hài lòng', 'Bình thường', 'Hài lòng', 'Rất hài lòng'],
      0,
    ),
    Question(
      'Chia sẽ cảm nhận của bạn?',
      [
        'Vui vẻ thân thiện',
        'Nhiệt tình',
        'Thời gian nhiều hơn',
        'Ý kiến khác',
      ],
      1,
    ),
    Question(
      'Bạn hài lòng về điều gì nhất?',
      [
        'Tư vấn đầy đủ',
        'Nội dung rõ ràng',
        'Có kinh nghiệm',
        'Ý kiến khác',
      ],
      0,
    ),
  ];
}
