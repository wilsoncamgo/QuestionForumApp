import 'package:intl/intl.dart';

class Answer {
  int id;
  int questionId;
  String userId;
  String answer;
  DateTime dateSumb;
  Answer({this.id, this.userId, this.questionId, this.answer, this.dateSumb});
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
        id: json['id'],
        questionId: json['question_id'],
        userId: json['user_id'],
        answer: json['answer'],
        dateSumb: DateTime.parse(json['date_sumb']));
  }
  Map<String, dynamic> toJson() => {
        'question_id': questionId.toString(),
        'user_id': userId,
        'answer': answer,
        'date_sumb': DateFormat("yyyy-MM-dd").format(dateSumb)
      };
}
