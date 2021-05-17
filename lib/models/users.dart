class User {
  String email;
  String name;
  String ImageUrl;
  String uid;

  String get getEmail => this.email;

  set setEmail(String email) => this.email = email;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImageUrl => this.ImageUrl;

  set setImageUrl(ImageUrl) => this.ImageUrl = ImageUrl;

  get getUid => this.uid;

  set setUid(uid) => this.uid = uid;

  User(this.uid, this.name, this.email, this.ImageUrl);

  User.fromJson(Map<String, dynamic> parsedJson) {
    this.uid = parsedJson['uid'];
    this.name = parsedJson['name'];
    this.email = parsedJson['email'];
    this.ImageUrl = parsedJson['imageUrl'];
  }
}
