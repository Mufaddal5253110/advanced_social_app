import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/user_profile.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<UserModal> _users = [];
  final scrollController = ScrollController();

  List<UserModal> get users => _users;

  bool isLoading = false;

  UserModal? currentUser;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchNextUsers();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent && // / 2 &&
        !scrollController.position.outOfRange) {
      if (Provider.of<UserProvider>(context, listen: false).hasNext) {
        Provider.of<UserProvider>(context, listen: false).fetchNextUsers();
      }
    }
  }

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search'),
        elevation: 0,
      ),
      body: ListView(
        controller: scrollController,
        padding: EdgeInsets.all(12),
        children: [
          ...Provider.of<UserProvider>(context, listen: true).users.map((user) {
            return currentUser?.id != user.id
                ? Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: ListTile(
                      title: Text(user.fullname!),
                      leading: ProfileImage(
                        height: 50,
                        width: 50,
                        url: user.profileImage ?? '',
                      ),
                      onTap: () => Get.to(
                        UserProfile(
                          user: user,
                        ),
                      ),
                    ),
                  )
                : SizedBox.fromSize();
          }).toList(),
          if (Provider.of<UserProvider>(context, listen: true).hasNext &&
              Provider.of<UserProvider>(context, listen: true).users.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: Provider.of<UserProvider>(context, listen: false)
                    .fetchNextUsers,
                child: spinkit,
              ),
            ),
        ],
      ),
    );
  }
}
