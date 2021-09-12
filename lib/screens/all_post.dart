import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/all_post_provider.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/upload_post.dart';
import 'package:myapp/utils/connectivityChecker.dart';
import 'package:myapp/widgets/postTile.dart';
import 'package:provider/provider.dart';

class AllPosts extends StatefulWidget {
  final refresh;

  const AllPosts({
    Key? key,
    this.refresh,
  }) : super(key: key);
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  List<PostModel> _posts = [];
  final scrollController = ScrollController();

  List<PostModel> get posts => _posts;

  UserModal? currentUser;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<UserData>(context, listen: false).getUser;
    Provider.of<AllPostProvider>(context, listen: false)
        .fetchingPostFromHive()
        .then((value) async =>
            await Provider.of<AllPostProvider>(context, listen: false)
                .fetchNextPosts(currentUser!.followings!));
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
      if (Provider.of<AllPostProvider>(context, listen: false).hasNext) {
        Provider.of<AllPostProvider>(context, listen: false)
            .fetchNextPosts(currentUser!.followings!);
      }
    }
  }

  void onrefresh() async {
    if (await ConnectivityChecker.isInternet()) {
      await Provider.of<AllPostProvider>(context, listen: false)
          .fetchingPostFromHive()
          .then((value) async =>
              await Provider.of<AllPostProvider>(context, listen: false)
                  .fetchNextPosts(currentUser!.followings!, reset: true));
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
        title: Text("MyApp"),
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
            ...Provider.of<AllPostProvider>(context, listen: true)
                .posts
                .map(
                  (post) => PostTile(
                    post: post,
                  ),
                )
                .toList(),
            if (Provider.of<AllPostProvider>(context, listen: true).hasNext &&
                Provider.of<AllPostProvider>(context, listen: true)
                    .posts
                    .isNotEmpty)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Provider.of<AllPostProvider>(context, listen: false)
                        .fetchNextPosts(currentUser!.followings!);
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
