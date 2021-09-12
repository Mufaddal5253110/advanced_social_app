import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dbHelper.dart';

class AuthServices {
  static Future facebookAuth(Map body) async {
    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/login/facebook');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    final prefs = await SharedPreferences.getInstance();
    if (res.statusCode == 200 && respdata['success']) {
      prefs.setString('jwtToken', respdata['token']);
      // Get.offAll(AboutPage());

      // Inserting Data
      UserModal user = UserModal.fromJson(respdata['user']);
      DBHelper helper = DBHelper.instance;
      int id = await helper.insert(user);
      print(id);

      // Navigating to homePage
      Get.offAll(HomePage());
    }
  }

  static Future login(Map body) async {
    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/login/');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    final prefs = await SharedPreferences.getInstance();
    if (res.statusCode == 200 && respdata['success']) {
      prefs.setString('jwtToken', respdata['token']);
      // Get.offAll(AboutPage());

      // Inserting Data
      UserModal user = UserModal.fromJson(respdata['user']);
      DBHelper helper = DBHelper.instance;
      int id = await helper.insert(user);
      print(id);
    }

    return respdata;
  }

    static Future signup(Map body) async {
    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/signup/');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    final prefs = await SharedPreferences.getInstance();
    if (res.statusCode == 200 && respdata['success']) {
      prefs.setString('jwtToken', respdata['token']);
      // Get.offAll(AboutPage());

      // Inserting Data
      UserModal user = UserModal.fromJson(respdata['user']);
      DBHelper helper = DBHelper.instance;
      int id = await helper.insert(user);
      print(id);
    }

    return respdata;
  }
}
