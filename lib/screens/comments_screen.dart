import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myapp/models/commentmodel.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/comment_provider.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/utils/connectivityChecker.dart';
import 'package:myapp/widgets/captionTile.dart';
import 'package:myapp/widgets/commentTile.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final bool? refresh;
  final PostModel? post;

  const CommentsScreen({
    Key? key,
    this.refresh,
    this.post,
  }) : super(key: key);
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<CommentModel?> _comments = [];
  final scrollController = ScrollController();

  List<CommentModel?> get comments => _comments;

  UserModal? currentUser;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // currentUser = Provider.of<UserData>(context, listen: false).getUser;
    Provider.of<CommentProvider>(context, listen: false)
        .fetchNextComments(widget.post!.id!);
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
      if (Provider.of<CommentProvider>(context, listen: false).hasNext) {
        Provider.of<CommentProvider>(context, listen: false)
            .fetchNextComments(widget.post!.id!);
      }
    }
  }

  void onrefresh() async {
    if (await ConnectivityChecker.isInternet()) {
      await Provider.of<CommentProvider>(context, listen: false)
          .fetchNextComments(widget.post!.id!, reset: true);
    }
  }

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  TextEditingController commentcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Comments"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.8,
              child: RefreshIndicator(
                onRefresh: () async {
                  return onrefresh();
                },
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  children: [
                    if (widget.post?.caption != null)
                      CaptionTile(
                        post: widget.post,
                      ),
                    ...Provider.of<CommentProvider>(context, listen: true)
                        .comments
                        .map(
                          (com) => CommentTile(
                            comment: com,
                          ),
                        )
                        .toList(),
                    if (Provider.of<CommentProvider>(context, listen: true)
                            .hasNext &&
                        Provider.of<CommentProvider>(context, listen: true)
                            .comments
                            .isNotEmpty)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<CommentProvider>(context, listen: false)
                                .fetchNextComments(widget.post!.id!);
                          },
                          child: spinkit,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: Get.height * 0.06,
              width: Get.width * 0.9,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentcontroller,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (commentcontroller.text.trim().isNotEmpty) {
                        // CommentModel currentcomment = new CommentModel(
                        //   comment: commentcontroller.text.trim(),
                        //   user: currentUser,
                        //   createdAt: DateTime.now(),
                        // );

                        var response = await DatabaseServices.postComment(
                          widget.post!.id!,
                          {"comment": commentcontroller.text.trim()},
                        );
                        if (response["success"]) {
                          commentcontroller.clear();
                          onrefresh();
                        }
                        Get.snackbar(
                          response['success'] ? 'Success' : 'Failed',
                          response['message'],
                          backgroundColor:
                              response['success'] ? Colors.black38 : Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
