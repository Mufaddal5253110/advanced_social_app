import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/activity_provider.dart';
import 'package:myapp/providers/all_post_provider.dart';
import 'package:myapp/providers/comment_provider.dart';
import 'package:myapp/providers/post_provider.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/about.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/utils/locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);

  Hive.registerAdapter(PostModelAdapter());
  Hive.registerAdapter(UserModalAdapter());

  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(create: (context) => UserData()),
        ChangeNotifierProvider<PostProvider>(
            create: (context) => PostProvider()),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<AllPostProvider>(
            create: (context) => AllPostProvider()),
        ChangeNotifierProvider<ActivityProvider>(
            create: (context) => ActivityProvider()),
        ChangeNotifierProvider<CommentProvider>(
            create: (context) => CommentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('jwtToken') != null) {
      print(prefs.getString('jwtToken'));
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data == true ? HomePage() : LoginPage();
              // return LoginPage();

            }
          },
          future: isLoggedIn(),
        ));
  }
}
