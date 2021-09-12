import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/providers/post_provider.dart';
import 'package:myapp/screens/upload_post.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/hiveService.dart';
import 'package:myapp/utils/connectivityChecker.dart';
import 'package:myapp/widgets/postTile.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MyPosts extends StatefulWidget {
  final refresh;

  const MyPosts({
    Key? key,
    this.refresh,
  }) : super(key: key);
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<PostModel> _posts = [];
  final scrollController = ScrollController();

  List<PostModel> get posts => _posts;

  bool isLoading = false;

  // getData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   bool exists = await HiveService.isExists(boxName: "MyPostTable");
  //   if (exists) {
  //     List<PostModel> postss = [];
  //     print("Getting data from Hive");

  //     var postlist = await HiveService.getBoxes("MyPostTable");
  //     print(postlist);
  //     (postlist as List).reversed.map((post) {
  //       postss.add(PostModel.fromJson(post));
  //     }).toList();
  //     setState(() {
  //       _posts = postss;
  //       isLoading = false;
  //     });
  //   }
  //   List<PostModel> postss = [];
  //   var resp = await DatabaseServices.getMyPosts();
  //   if (resp['success']) {
  //     (resp['posts']['posts'] as List).reversed.map((post) {
  //       postss.add(PostModel.fromJson(post));
  //     }).toList();
  //   }
  //   await HiveService.addBoxes(resp['posts']['posts'] as List, "MyPostTable");
  //   setState(() {
  //     _posts = postss;
  //     isLoading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getData();
    // scrollController.addListener(scrollListener);
    Provider.of<PostProvider>(context, listen: false)
        .fetchingPostFromHive(refresh: widget.refresh)
        .then((value) =>
            Provider.of<PostProvider>(context, listen: false).fetchNextPosts());
    // Provider.of<PostProvider>(context, listen: false).fetchNextPosts();
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
      if (Provider.of<PostProvider>(context, listen: false).hasNext) {
        Provider.of<PostProvider>(context, listen: false).fetchNextPosts();
      }
    }
  }

  void onrefresh() async {
    if (await ConnectivityChecker.isInternet()) {
      await Provider.of<PostProvider>(context, listen: false)
          .fetchingPostFromHive(refresh: true)
          .then((value) async =>
              await Provider.of<PostProvider>(context, listen: false)
                  .fetchNextPosts());
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
        title: Text('My Feed'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return onrefresh();
        },
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.all(12),
          children: [
            ...Provider.of<PostProvider>(context, listen: true)
                .posts
                .map(
                  (post) => PostTile(
                    post: post,
                  ),
                )
                .toList(),
            if (Provider.of<PostProvider>(context, listen: true).hasNext &&
                Provider.of<PostProvider>(context, listen: true)
                    .posts
                    .isNotEmpty)
              Center(
                child: GestureDetector(
                  onTap: Provider.of<PostProvider>(context, listen: false)
                      .fetchNextPosts,
                  child: spinkit,
                ),
              ),
            if (Provider.of<PostProvider>(context, listen: true).posts.isEmpty)
              Center(
                child: Text("No Posts Found"),
              )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Get.to(UploadPost(
      //     onUpload: onrefresh,
      //   )),
      //   tooltip: 'Add Post',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
