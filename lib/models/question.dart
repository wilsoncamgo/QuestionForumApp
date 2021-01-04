class Question {
  int id;
  String userId;
  int topicId;
  String question;
  DateTime dateSumb;
  Question({this.id, this.userId, this.topicId, this.question, this.dateSumb});
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'],
        userId: json['user_id'],
        topicId: json['topic_id'],
        question: json['question'],
        dateSumb: DateTime.parse(json['date_sumb']));
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'topic_id': topicId,
        'question': question,
        'date_sumb': dateSumb
      };
}
