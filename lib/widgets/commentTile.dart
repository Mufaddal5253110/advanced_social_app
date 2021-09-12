import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/commentmodel.dart';
import 'package:myapp/widgets/profileImage.dart';

class CommentTile extends StatefulWidget {
  final CommentModel? comment;

  const CommentTile({
    Key? key,
    this.comment,
  }) : super(key: key);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Divider(
          //   height: 1,
          //   color: Colors.grey,
          // ),
          ListTile(
            leading: ProfileImage(
              height: 35,
              width: 35,
              url: widget.comment?.user?.profileImage,
            ),
            title: Text(
              widget.comment?.user?.fullname ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat("dd MMMM yyyy").format(widget.comment!.createdAt!),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w300,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
              ),
            ),
          ),
          Container(
            width: Get.width * 0.55,
            child: Text(
              widget.comment!.comment!,
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
    );
  }
}
