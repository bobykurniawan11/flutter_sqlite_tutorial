class User {
  String email;
  String nama;

  User({this.email, this.nama});

  factory User.fromMap(Map<String, dynamic> json) =>
      new User(email: json["email"], nama: json["nama"]);

  Map<String, dynamic> toMap() => {"email": email, "nama": nama};
}
