import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  const ProfileImage({
    Key? key,
    this.url,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(
            url!.contains('http') ? url! : 'http://192.168.43.193:3000/${url}',
          ),
        ),
      ),
    );
  }
}
