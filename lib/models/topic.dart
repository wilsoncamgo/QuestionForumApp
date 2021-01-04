class Topic {
  int number;
  String topic;
  Topic({this.number, this.topic});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      number: json['id'],
      topic: json['topic'],
    );
  }
}
