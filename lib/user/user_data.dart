import 'dart:convert';

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static SharedPreferences? preferences;
  // static const keyUser = 'user';

  static User myUser = User(
    image:
        'https://happytravel.viajes/wp-content/uploads/2020/04/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
    name: 'Your name',
    age: 'Your Age',
    email: 'Your email',
    contact: 'Your contact number',
    aboutDescription: 'About yourself',
    passcode: '000000',
  );

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  static Future setUser(User user, String keyUser) async {
    final json = jsonEncode(user.toJson());

    await preferences!.setString(keyUser, json);
  }

  static User getUser(String keyUser) {
    final json = preferences?.getString(keyUser);
    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
