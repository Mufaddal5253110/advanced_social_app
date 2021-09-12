import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/screens/comments_screen.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/utils/connectivityChecker.dart';
import 'package:myapp/widgets/profileImage.dart';
import 'package:provider/provider.dart';

class PostTile extends StatefulWidget {
  final PostModel? post;

  const PostTile({Key? key, this.post}) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final FlareControls flareControls = FlareControls();

  UserModal? user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserData>(context, listen: true).getUser;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoBar(),
          _mediaBar(),
          _actionBar(),
          _postInfoBar(),
          // _addCommentBar(),
          _timeStamp(),
        ],
      ),
    );
  }

  Widget _userInfoBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
      ),
      child: Row(
        children: [
          ProfileImage(
            height: 40,
            width: 40,
            url: widget.post?.user?.profileImage,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.post?.user?.fullname ?? ''),
              widget.post?.location != null
                  ? Text(widget.post?.location ?? '')
                  : const SizedBox(),
            ],
          ),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.more_vert, size: 20), onPressed: () {})
        ],
      ),
    );
  }

  Widget _mediaBar() {
    return GestureDetector(
      onDoubleTap: () async {
        flareControls.play("like");
        if (!widget.post!.likes!.contains(user?.id) &&
            await ConnectivityChecker.isInternet()) {
          // First adding to list
          setState(() {
            widget.post?.likes?.add(user!.id!);
          });
          // Updating on backend
          var response = await DatabaseServices.likePost(widget.post?.id);
          await DatabaseServices.postActivity({
            "from": user?.id,
            "to": widget.post!.user?.id,
            "type": "PL",
            "post": widget.post!.id,
          });
          Get.snackbar(
            response['success'] ? 'Success' : 'Failed',
            response['message'],
            backgroundColor: response['success'] ? Colors.black38 : Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(3, 4),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl:
                      'http://192.168.43.193:3000/${widget.post?.imageurl}',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 160.0,
            width: 160.0,
            child: Center(
              child: FlareActor(
                'assets/animation/heart.flr',
                controller: flareControls,
                animation: 'idle',
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _actionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _actionButton(
              icon: widget.post!.likes!.contains(user?.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              clr: widget.post!.likes!.contains(user?.id)
                  ? Colors.red
                  : Colors.black,
              len: widget.post?.likes?.length ?? 0,
              onTap: () async {
                if (!widget.post!.likes!.contains(user?.id) &&
                    await ConnectivityChecker.isInternet()) {
                  // First adding to list
                  setState(() {
                    widget.post?.likes?.add(user!.id!);
                  });
                  // Updating on backend
                  var response =
                      await DatabaseServices.likePost(widget.post?.id);
                  await DatabaseServices.postActivity({
                    "from": user?.id,
                    "to": widget.post!.user?.id,
                    "type": "PL",
                    "post": widget.post!.id,
                  });
                  Get.snackbar(
                    response['success'] ? 'Success' : 'Failed',
                    response['message'],
                    backgroundColor:
                        response['success'] ? Colors.black38 : Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                  );
                } else if (widget.post!.likes!.contains(user?.id) &&
                    await ConnectivityChecker.isInternet()) {
                  // First removing from list
                  setState(() {
                    widget.post?.likes?.remove(user?.id);
                  });
                  // Updating on backend
                  var response =
                      await DatabaseServices.unlikePost(widget.post?.id);
                  Get.snackbar(
                    response['success'] ? 'Success' : 'Failed',
                    response['message'],
                    backgroundColor:
                        response['success'] ? Colors.black38 : Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                  );
                }
              }),
          _actionButton(
              icon: Icons.comment,
              onTap: () => Get.to(CommentsScreen(
                    post: widget.post,
                  ))),
          _actionButton(icon: Icons.send, onTap: () {}),
          const Spacer(),
          _actionButton(icon: Icons.bookmark_add_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _actionButton(
      {IconData? icon,
      Function? onTap,
      Color clr = Colors.black,
      int len = 0}) {
    return GestureDetector(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              icon,
              size: 28,
              color: clr,
            ),
          ),
          if (len != 0)
            Text(
              len.toString(),
            ),
        ],
      ),
      onTap: () {
        printInfo(info: "taped");
        onTap!();
      },
    );
  }

  Widget _postInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: widget.post?.caption != null ? 3 : 0),
            child: widget.post?.caption != null
                ? Text(
                    " " + widget.post!.caption!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  )
                // RichText(
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //     text: TextSpan(
                //       text: widget.post?.user?.firstname,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, color: Colors.black),
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: " " + widget.post!.caption!,
                //           style: TextStyle(
                //               fontWeight: FontWeight.normal,
                //               color: Colors.black),
                //         ),
                //       ],
                //     ),
                //   )
                : const SizedBox(),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: widget.post?.comments?.length != 0 ? 3 : 0),
            child: widget.post?.comments?.length != 0
                ? Text(
                    "View all ${widget.post?.comments?.length} comments",
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  // Widget _addCommentBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //     child: Row(
  //       children: [
  //         const CircleAvatar(
  //           radius: 14,
  //           backgroundImage: AssetImage("assets/images/dp.jpg"),
  //         ),
  //         const SizedBox(
  //           width: 6,
  //         ),
  //         Expanded(
  //           child: TextFormField(
  //             decoration: const InputDecoration(
  //               hintText: "Add a comment...",
  //               focusedBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Colors.white,
  //                   width: 0,
  //                 ),
  //               ),
  //               enabledBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Colors.white10,
  //                   width: 0,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const Spacer(),
  //         const Text("👌   😂   ➕ ")
  //       ],
  //     ),
  //   );
  // }

  Widget _timeStamp() {
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 8),
      child: Text(
        DateFormat("dd MMMM yyyy").format(widget.post!.createdAt!),
      ),
    );
  }
}
