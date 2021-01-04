class User {
  String id;
  String name;
  User({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  User.created(this.id, this.name);
  factory User.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return User.created(data['id'], data['name']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
