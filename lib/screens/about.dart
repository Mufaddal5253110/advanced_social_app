import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/home_page_controller.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/edit_profile.dart';
import 'package:myapp/services/dbHelper.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final HomePageController controller = Get.put(HomePageController());
  UserModal currentUser = UserModal();
  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('About ${currentUser.firstname}'),
        elevation: 0,
      ),
      body: Center(
        child: _displayUserData(currentUser),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(EditProfile()),
        tooltip: 'Edit Profile',
        child: Icon(Icons.edit),
      ),
    );
  }

  _displayUserData(UserModal profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (profileData.profileImage != null)
          ProfileImage(url: profileData.profileImage),
        SizedBox(height: 28.0),
        Text(
          "FBID ${profileData.fbId ?? ''}\n${profileData.fullname ?? ''}\n${profileData.username ?? ''}",
          style: TextStyle(
            fontSize: 20.0,
            letterSpacing: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.0),
        if (profileData.bio != '')
          Text(
            "BIO : ${profileData.bio ?? ''}",
            style: TextStyle(
              fontSize: 12.0,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.left,
          ),
        if (profileData.website != '')
          TextButton(
            onPressed: () {},
            child: Text(profileData.website ?? ''),
          ),
        SizedBox(height: 20.0),
        ElevatedButton(onPressed: controller.logout, child: Text("Log Out"))
      ],
    );
  }
}
