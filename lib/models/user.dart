class User {
  String id;
  String name;
  User({this.id, this.name});

  User.created(this.id, this.name);
  factory User.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return User.created(data['id'], data['name']);
  }
}
