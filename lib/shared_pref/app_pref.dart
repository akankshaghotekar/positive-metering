import 'dart:convert';

import 'package:positive_metering/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static const String _isLoggedIn = "is_logged_in";
  static const String _userData = "user_data";

  static Future<void> saveUser(LoginModel user) async {
    final pref = await SharedPreferences.getInstance();

    await pref.setBool(_isLoggedIn, true);

    await pref.setString(
      _userData,
      jsonEncode({
        "usersrno": user.userSrNo,
        "name": user.name,
        "email": user.email,
        "gender": user.gender,
        "region_srno": user.regionSrNo,
        "subregion_srno": user.subRegionSrNo,
      }),
    );
  }

  static Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(_userData);

    if (data != null) {
      return jsonDecode(data);
    }

    return null;
  }

  static Future<String?> getUserSrNo() async {
    final user = await getUser();
    return user?['usersrno'];
  }
}
