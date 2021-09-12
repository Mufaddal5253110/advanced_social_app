import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/home_page_controller.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/about.dart';
import 'package:myapp/screens/activity.dart';
import 'package:myapp/screens/all_post.dart';
import 'package:myapp/screens/my_post.dart';
import 'package:myapp/screens/upload_post.dart';
import 'package:myapp/screens/users_list.dart';
import 'package:myapp/services/dbHelper.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController controller = Get.put(HomePageController());

  DBHelper helper = DBHelper.instance;
  UserModal currentUser = UserModal();
  bool isloading = false;
  int selectedPage = 1;

  void getData() async {
    setState(() {
      isloading = true;
    });
    UserModal user = await helper.fetch();
    Provider.of<UserData>(context, listen: false).setUser(user);
    print(user.toJson());
    setState(() {
      currentUser = user;
      isloading = false;
    });
  }

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 40.0,
  );

  Widget getPage(int index) {
    switch (index) {
      // case 3:
      //   return MyPosts(
      //     refresh: true,
      //   );
      case 3:
        return ActivityScreen();
      case 1:
        return AllPosts();
      case 2:
        return UsersList();
      case 4:
        return AboutPage();

      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return isloading
        ? Scaffold(
            body: Center(
              child: spinkit,
            ),
          )
        : Scaffold(
            // appBar: AppBar(
            //   title: Text("MyApp"),
            //   actions: [
            //     IconButton(
            //       onPressed: () => Get.to(AboutPage()),
            //       icon: ProfileImage(
            //         height: 40,
            //         width: 40,
            //         url: currentUser.profileImage,
            //       ),
            //     )
            //   ],
            //   elevation: 0,
            // ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () => Get.to(UploadPost()),
            //   tooltip: 'Add Post',
            //   child: Icon(Icons.add),
            // ),
            // drawer: Drawer(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     children: <Widget>[
            //       UserAccountsDrawerHeader(
            //         accountName: Text(currentUser.fullname!),
            //         accountEmail: Text(currentUser.username!),
            //         currentAccountPicture: ProfileImage(
            //           url: currentUser.profileImage ?? '',
            //         ),
            //       ),
            //       ListTile(
            //         title: Text("My Post"),
            //         selected: selectedPage == 1,
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           setState(() {
            //             selectedPage = 1;
            //           });
            //         },
            //       ),
            //       ListTile(
            //         title: Text("All Posts"),
            //         selected: selectedPage == 2,
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           setState(() {
            //             selectedPage = 2;
            //           });
            //         },
            //       ),
            //       ListTile(
            //         title: Text("All Users"),
            //         selected: selectedPage == 3,
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           setState(() {
            //             selectedPage = 3;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            // body: getPage(selectedPage),
            body: Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.white,
                  // child: getPage(selectedPage),
                ),
                Container(
                  height: Get.height * 0.9,
                  width: Get.width,
                  child: getPage(selectedPage),
                ),
                Positioned(
                  bottom: 5,
                  left: Get.width * 0.05,
                  child: Container(
                    width: Get.width * 0.9,
                    height: Get.height * 0.08,
                    // padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            if (selectedPage != 1)
                              setState(() {
                                selectedPage = 1;
                              });
                          },
                          icon: Icon(
                            Icons.home,
                            size: selectedPage == 1 ? 35 : 30,
                            color: selectedPage == 1
                                ? Colors.orange
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (selectedPage != 2)
                              setState(() {
                                selectedPage = 2;
                              });
                          },
                          icon: Icon(
                            Icons.search,
                            size: selectedPage == 2 ? 35 : 30,
                            color: selectedPage == 2
                                ? Colors.orange
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(UploadPost(
                              // onUpload: onrefresh,
                              )),
                          child: Container(
                            height: 43,
                            width: 43,
                            // padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 35,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (selectedPage != 3)
                              setState(() {
                                selectedPage = 3;
                              });
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: selectedPage == 3 ? 35 : 30,
                            color: selectedPage == 3
                                ? Colors.orange
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (selectedPage != 4)
                              setState(() {
                                selectedPage = 4;
                              });
                          },
                          icon: ProfileImage(
                            height: selectedPage == 4 ? 35 : 30,
                            width: selectedPage == 4 ? 35 : 30,
                            url: currentUser.profileImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
