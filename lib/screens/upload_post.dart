import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:myapp/controllers/upload_photo_controller.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/all_post_provider.dart';
import 'package:myapp/providers/post_provider.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/hiveService.dart';
import 'package:myapp/services/storageServices.dart';
import 'package:myapp/widgets/custom_textfield_1.dart';
import 'package:provider/provider.dart';

class UploadPost extends StatefulWidget {
  final Function? onUpload;

  const UploadPost({Key? key, this.onUpload}) : super(key: key);
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController captioncontroller = TextEditingController();

  TextEditingController locationcontroller = TextEditingController();

  bool validcaption = true;

  final UploadPhotoController controller = Get.put(UploadPhotoController());

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  bool isUploading = false;

  UserModal? currentUser;
  String? postUrl;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Post'),
        elevation: 0,
      ),
      body: LoadingOverlay(
          isLoading: isUploading,
          progressIndicator: spinkit,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: controller.handleProfileImageFromGallery,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      left: Get.width * 0.1,
                    ),
                    width: Get.width * 0.6,
                    height: Get.width * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Obx(() => controller.profileImage.value.path != ''
                        ? Image.file(
                            File(controller.profileImage.value.path),
                            fit: BoxFit.fill,
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 50,
                          )),
                  ),
                ),
                CustomTextField1(
                  label: "Caption",
                  controller: captioncontroller,
                  icon: Icons.edit,
                  initialtext: '',
                  validity: true,
                  topMargin: 20,
                  bottomMargin: 30,
                  maxLines: -1,
                  leftMargin: Get.width * 0.075,
                ),
                CustomTextField1(
                  label: "Location",
                  controller: locationcontroller,
                  icon: Icons.map,
                  initialtext: '',
                  validity: true,
                  topMargin: 20,
                  bottomMargin: 30,
                  leftMargin: Get.width * 0.075,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isUploading = true;
                    });

                    // Uploading profilephoto and getting url
                    if (controller.profileImage != null)
                      try {
                        postUrl = await StorageServices.uploadImage(
                            controller.profileImage.value);
                        postUrl = postUrl!.replaceAll('\\', '/');
                        print("postUrl ===> $postUrl");
                      } catch (e) {
                        print("postUrl Error ====> ${e.toString()}");
                      }
                    if (postUrl != null) {
                      PostModel post = PostModel(
                        user: currentUser,
                        caption: captioncontroller.text.trim(),
                        location: locationcontroller.text.trim(),
                        imageurl: postUrl,
                      );
                      var response = await DatabaseServices.uploadPost(post);
                      if (response['success']) {
                        captioncontroller.clear();
                        locationcontroller.clear();
                        // postUrl = null;
                      }
                      // await HiveService.clearBoxes("MyPostTable");

                      // await widget.onUpload!();
                      await Provider.of<AllPostProvider>(context,listen: false)
                          .fetchNextPosts(
                        currentUser!.followings!,
                        reset: true,
                      );

                      await Provider.of<PostProvider>(context,listen: false).fetchNextPosts(
                        reset: true,
                      );

                      setState(() {
                        isUploading = false;
                      });

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
                  child: Text("Upload Post"),
                )
              ],
            ),
          )),
    );
  }
}
