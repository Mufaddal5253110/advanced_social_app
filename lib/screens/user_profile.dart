import 'package:flutter/material.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/dbHelper.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final UserModal? user;

  const UserProfile({Key? key, this.user}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModal? currentUser;
  DBHelper helper = DBHelper.instance;
  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('About ${widget.user?.firstname}'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.user?.profileImage != null)
                ProfileImage(url: widget.user?.profileImage),
              SizedBox(height: 28.0),
              Text(
                "${widget.user?.fullname ?? ''}\n${widget.user?.username ?? ''}",
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              if (widget.user?.bio != '')
                Text(
                  "BIO : ${widget.user?.bio ?? ''}",
                  style: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.left,
                ),
              if (widget.user?.website != '')
                TextButton(
                  onPressed: () {},
                  child: Text(widget.user?.website ?? ''),
                ),
              SizedBox(height: 20.0),
              if (!currentUser!.followings!.contains(widget.user?.id))
                ElevatedButton(
                  onPressed: () async {
                    currentUser?.followings?.add(widget.user?.id ?? '');
                    Provider.of<UserData>(context, listen: false)
                        .setUser(currentUser!);
                    await helper.updateOther(
                        currentUser!.toUpdateFollowing(), currentUser?.dbID);
                    var resp =
                        await DatabaseServices.followUser(widget.user?.id);
                    print(resp);
                    if (!resp["success"]) {
                      currentUser?.followings?.remove(widget.user?.id ?? '');
                      Provider.of<UserData>(context, listen: false)
                          .setUser(currentUser!);
                      await helper.updateOther(
                          currentUser!.toUpdateFollowing(), currentUser?.dbID);
                    }
                  },
                  child: Text(
                    "Follow",
                  ),
                ),
              if (currentUser!.followings!.contains(widget.user?.id))
                TextButton(
                  onPressed: () async {
                    currentUser?.followings?.remove(widget.user?.id ?? '');
                    Provider.of<UserData>(context, listen: false)
                        .setUser(currentUser!);
                    await helper.updateOther(
                        currentUser!.toUpdateFollowing(), currentUser?.dbID);
                    var resp =
                        await DatabaseServices.unfollowUser(widget.user?.id);
                    print(resp);
                    if (!resp["success"]) {
                      currentUser?.followings?.add(widget.user?.id ?? '');
                      Provider.of<UserData>(context, listen: false)
                          .setUser(currentUser!);
                      await helper.updateOther(
                          currentUser!.toUpdateFollowing(), currentUser?.dbID);
                    }
                  },
                  child: Text(
                    "UnFollow",
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
