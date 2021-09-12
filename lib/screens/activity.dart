import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myapp/models/activitymodel.dart';
import 'package:myapp/providers/activity_provider.dart';
import 'package:myapp/utils/connectivityChecker.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activitymodel> _activity = [];
  final scrollController = ScrollController();

  List<Activitymodel> get posts => _activity;

  @override
  void initState() {
    super.initState();
    // currentUser = Provider.of<UserData>(context, listen: false).getUser;
    Provider.of<ActivityProvider>(context, listen: false).fetchNextActivity();
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
      if (Provider.of<ActivityProvider>(context, listen: false).hasNext) {
        Provider.of<ActivityProvider>(context, listen: false)
            .fetchNextActivity();
      }
    }
  }

  void onrefresh() async {
    if (await ConnectivityChecker.isInternet()) {
      await Provider.of<ActivityProvider>(context, listen: false)
          .fetchNextActivity(reset: true);
    }
  }

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Activity"),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return onrefresh();
        },
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
          children: [
            ...Provider.of<ActivityProvider>(context, listen: true)
                .activity
                .map(
                  (act) => Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: ListTile(
                      title: Text(act.from!.fullname!),
                      leading: ProfileImage(
                        height: 50,
                        width: 50,
                        url: act.from?.profileImage ?? '',
                      ),
                      // onTap: () => Get.to(
                      //   UserProfile(
                      //     user: user,
                      //   ),
                      // ),
                    ),
                  ),
                )
                .toList(),
            if (Provider.of<ActivityProvider>(context, listen: true).hasNext &&
                Provider.of<ActivityProvider>(context, listen: true)
                    .activity
                    .isNotEmpty)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Provider.of<ActivityProvider>(context, listen: false)
                        .fetchNextActivity();
                  },
                  child: spinkit,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
