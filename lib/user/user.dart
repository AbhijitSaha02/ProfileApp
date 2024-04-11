class User {
  String image;
  String name;
  String age;
  String email;
  String contact;
  String aboutDescription;
  String passcode;

  User({
    required this.image,
    required this.name,
    required this.age,
    required this.email,
    required this.contact,
    required this.aboutDescription,
    required this.passcode,
  });

  User copy({
    String? imagePath,
    String? name,
    String? age,
    String? email,
    String? contact,
    String? about,
    String? passcode,
  }) =>
      User(
        image: imagePath ?? image,
        name: name ?? this.name,
        age: age ?? this.age,
        email: email ?? this.email,
        contact: contact ?? this.contact,
        aboutDescription: about ?? aboutDescription,
        passcode: passcode ?? this.passcode,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        image: json['imagePath'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        contact: json['contact'],
        aboutDescription: json['about'],
        passcode: json['passcode'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'name': name,
        'age': age,
        'email': email,
        'contact': contact,
        'about': aboutDescription,
        'passcode': passcode,
      };
}
