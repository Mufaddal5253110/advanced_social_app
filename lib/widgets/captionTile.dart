import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/commentmodel.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/widgets/profileImage.dart';

class CaptionTile extends StatefulWidget {
  final PostModel? post;

  const CaptionTile({
    Key? key,
    this.post,
  }) : super(key: key);

  @override
  _CaptionTileState createState() => _CaptionTileState();
}

class _CaptionTileState extends State<CaptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            leading: ProfileImage(
              height: 35,
              width: 35,
              url: widget.post?.user?.profileImage,
            ),
            title: Text(
              widget.post?.user?.fullname ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat("dd MMMM yyyy").format(widget.post!.createdAt!),
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
              widget.post!.caption!,
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
