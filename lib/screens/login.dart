import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/services/authServices.dart';
import 'package:myapp/widgets/custom_textfield_1.dart';
import 'package:http/http.dart' as http;

import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());

  // TextEditingController firstnamecontroller = TextEditingController();
  // TextEditingController lasttnamecontroller = TextEditingController();

  bool validemail = true;
  bool validfirstname = true;
  bool validlastname = true;

  bool validpassword = true;
  bool isLogin = false;

  bool isRegistered = true;
  bool isFbRegistered = true;

  var facebookLogin = FacebookLogin();

  var finalBody = {};

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
      ),
      body: Center(
        child: isLogin
            ? spinkit
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   'You have pushed the button this many times:',
                    // ),
                    // Obx(
                    //   () => Text(
                    //     '${controller.count.value}',
                    //     style: Theme.of(context).textTheme.headline4,
                    //   ),
                    // ),
                    // if (isFbRegistered)
                    Obx(
                      () => CustomTextField1(
                        label: "Enter E-mail",
                        controller: controller.emailcontroller.value,
                        icon: Icons.email,
                        initialtext: finalBody["username"] ?? '',
                        validity: validemail,
                        topMargin: 20,
                        errorText: "Invalid Email id",
                      ),
                    ),
                    if (isFbRegistered == false || isRegistered == false)
                      Obx(
                        () => CustomTextField1(
                          label: "Enter firstname",
                          controller: controller.firstnamecontroller.value,
                          icon: Icons.person,
                          initialtext: finalBody["firstname"] ?? '',
                          validity: validfirstname,
                          topMargin: 20,
                          errorText: "Invalid firstname",
                        ),
                      ),
                    if (isFbRegistered == false || isRegistered == false)
                      Obx(
                        () => CustomTextField1(
                          label: "Enter lastname",
                          controller: controller.lastnamecontroller.value,
                          icon: Icons.person,
                          initialtext: finalBody["lastname"] ?? '',
                          validity: validlastname,
                          topMargin: 20,
                          errorText: "Invalid lastname",
                        ),
                      ),

                    Obx(
                      () => CustomTextField1(
                        label: "Enter password",
                        controller: controller.passwordcontroller.value,
                        icon: Icons.lock,
                        initialtext: '',
                        validity: validpassword,
                        topMargin: 20,
                        errorText: "Invalid password",
                      ),
                    ),
                    if (isFbRegistered && isRegistered)
                      TextButton(
                        child: Text("Login"),
                        onPressed: () {
                          onSubmit();
                        },
                      ),
                    if (isFbRegistered == false || isRegistered == false)
                      TextButton(
                        child: Text("Signup"),
                        onPressed: () {
                          onSignup();
                        },
                      ),
                    if (isFbRegistered)
                      ElevatedButton(
                        child: Text("Login with Facebook"),
                        onPressed: () => initiateFacebookLogin(),
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void onSubmit() async {
    // setState(() {
    //   isLogin = true;
    // });

    if (controller.emailcontroller.value.text.trim().isEmpty) {
      setState(() {
        validemail = false;
      });
    } else {
      if (validemail == false) {
        setState(() {
          validemail = true;
        });
      }
    }
    if (controller.emailcontroller.value.text.trim().isNotEmpty) {
      print("Validating email");
      var urlPattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(urlPattern);
      bool verify =
          regex.hasMatch(controller.emailcontroller.value.text.trim());

      setState(() {
        validemail = verify;
      });
    }
    if (controller.passwordcontroller.value.text.trim().isEmpty) {
      setState(() {
        validpassword = false;
      });
    } else {
      if (validpassword == false) {
        setState(() {
          validpassword = true;
        });
      }
    }
    if (controller.passwordcontroller.value.text.trim().isNotEmpty &&
        controller.passwordcontroller.value.text.trim().length < 8) {
      print("Validating password");
      setState(() {
        validpassword == false;
      });
    }
    if (controller.passwordcontroller.value.text.trim().isNotEmpty &&
        controller.emailcontroller.value.text.trim().isNotEmpty) {
      setState(() {
        isLogin = true;
      });
      Map finalData = finalBody;
      finalData.addAll({
        "password": controller.passwordcontroller.value.text.trim(),
        "username": controller.emailcontroller.value.text.trim(),
      });

      var response = await AuthServices.login(finalData);

      setState(() {
        isLogin = false;
      });

      if (response["success"]) {
        // Navigating to homePage
        Get.offAll(HomePage());
      } else {
        if (response["message"] == "Invalid Password") {
          setState(() {
            validpassword = false;
            isLogin = false;
          });
        } else {
          Get.snackbar(
            "Not Reistered",
            "Please registere first!",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
          isRegistered = false;
        }
      }
    }
  }

  void onSignup() async {
    if (controller.emailcontroller.value.text.trim().isEmpty) {
      setState(() {
        validemail = false;
      });
    } else {
      if (validemail == false) {
        setState(() {
          validemail = true;
        });
      }
    }
    if (controller.emailcontroller.value.text.trim().isNotEmpty) {
      print("Validating email");
      var urlPattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(urlPattern);
      bool verify =
          regex.hasMatch(controller.emailcontroller.value.text.trim());

      setState(() {
        validemail = verify;
      });
    }
    if (controller.firstnamecontroller.value.text.trim().isEmpty) {
      setState(() {
        validfirstname = false;
      });
    } else {
      if (validfirstname == false) {
        setState(() {
          validfirstname = true;
        });
      }
    }
    if (controller.lastnamecontroller.value.text.trim().isEmpty) {
      setState(() {
        validlastname = false;
      });
    } else {
      if (validlastname == false) {
        setState(() {
          validlastname = true;
        });
      }
    }
    if (controller.passwordcontroller.value.text.trim().isEmpty) {
      setState(() {
        validpassword = false;
      });
    } else {
      if (validpassword == false) {
        setState(() {
          validpassword = true;
        });
      }
    }
    if (controller.passwordcontroller.value.text.trim().isNotEmpty &&
        controller.passwordcontroller.value.text.trim().length < 8) {
      print("Validating password");
      setState(() {
        validpassword == false;
      });
    }
    if (validfirstname && validemail && validlastname && validpassword) {
      setState(() {
        isLogin = true;
      });
      var finalData = {
        'firstname': controller.firstnamecontroller.value.text.trim(),
        'lastname': controller.lastnamecontroller.value.text.trim(),
        'fullname': controller.firstnamecontroller.value.text.trim() +
            " " +
            controller.lastnamecontroller.value.text.trim(),
        'username': controller.emailcontroller.value.text.trim(),
        'profileImage': finalBody["profileImage"],
        'fbId': finalBody["fbId"],
        'password': controller.passwordcontroller.value.text.trim(),
      };

      var response = await AuthServices.signup(finalData);

      setState(() {
        isLogin = false;
      });

      if (response["error"] != null) {
        Get.snackbar(
          "Something Went Wrong",
          response["error"]["message"],
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
      }

      if (response["success"]) {
        // Navigating to homePage
        Get.offAll(HomePage());
      } else {
        Get.snackbar(
          "Something Went Wrong",
          "Please try Later!",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
        isRegistered = false;
      }
    }
  }

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
          setState(() {
            finalBody = body;
            isFbRegistered = false;
          });
          // emailcontroller.value.text = profile['email'];
        }

        break;
    }
  }
}
