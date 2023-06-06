import 'package:acscallingchatflutter/custom_packages/shared_preferennces/shared_preference.dart';

class AppSharedPreference {

  //Setters
  void addString({required String key, required String value}) async {
    await SharedPreferences.addString(key: key, value: value);
  }

  //Getters
  getString({required String key}) async {
    String value = await SharedPreferences.getString(key: key);
    return value;
  }
}
