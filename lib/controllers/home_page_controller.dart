import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/services/dbHelper.dart';
import 'package:myapp/services/hiveService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageController extends GetxController {
  var facebookLogin = FacebookLogin();
  DBHelper helper = DBHelper.instance;

  void logout() async {
    await facebookLogin.logOut();
    await helper.delete('1');
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await HiveService.clearBoxes("MyPostTable");
    print("Logged out");
    Get.offAll(LoginPage());
  }
}
