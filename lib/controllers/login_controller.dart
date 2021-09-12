import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/services/authServices.dart';

class LoginController extends GetxController {
  final count = 0.obs;

  var facebookLogin = FacebookLogin();
  var finalBody = {}.obs;
  var isFbRegistered = true.obs;

  Rx<TextEditingController> emailcontroller = TextEditingController().obs;
  Rx<TextEditingController> passwordcontroller = TextEditingController().obs;
  Rx<TextEditingController> firstnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> lastnamecontroller = TextEditingController().obs;



  increment() => count.value++;

  void initiateFacebookLogin() async {
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print(facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.loggedIn:
        Uri url = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');
        var graphResponse = await http.get(url);

        var profile = json.decode(graphResponse.body);
        print(profile.toString());
        var body = {
          'firstname': profile['first_name'],
          'lastname': profile['last_name'],
          'fullname': profile['name'],
          'username': profile['email'],
          'profileImage': profile['picture']['data']['url'],
          'fbId': profile['id'],
        };

        var resp = await AuthServices.login(body);
        if (resp["success"]) {
          // Navigating to homePage
          Get.offAll(HomePage());
        } else {
          Get.snackbar(
            "Not Reistered",
            "please Enter Password and then logged In!",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
          finalBody.value = body;

          isFbRegistered.value = false;
          // emailcontroller.value.text = profile['email'];
        }

        break;
    }
  }
}
