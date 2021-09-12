import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:myapp/controllers/upload_photo_controller.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/storageServices.dart';
import 'package:myapp/widgets/custom_textfield_1.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModal currentUser = UserModal();

  TextEditingController firstnamecontroller = TextEditingController();

  TextEditingController lasttnamecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController websitecontroller = TextEditingController();

  TextEditingController biocontroller = TextEditingController();

  bool validfirstname = true;

  bool validlastname = true;

  bool validemail = true;

  bool validwebsite = true;

  bool isUpdating = false;

  final UploadPhotoController controller = Get.put(UploadPhotoController());

  var spinkit = SpinKitWave(
    color: Colors.blueAccent,
    size: 35.0,
  );

  // XFile? _profileImage;
  // final ImagePicker _picker = ImagePicker();
  // _handleProfileImageFromGallery() async {
  //   XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = pickedFile;
  //     });
  //     print("ProfileImage ==> ${_profileImage?.path}");
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  String? profileUrl;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserData>(context, listen: true).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: isUpdating,
        progressIndicator: spinkit,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.0),
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            LinearGradient(colors: [Colors.blue, Colors.green]),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Obx(
                            () => controller.profileImage.value.path != ''
                                ? Image.file(
                                    File(controller.profileImage.value.path),
                                    fit: BoxFit.fill,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: currentUser.profileImage!
                                            .contains('http')
                                        ? currentUser.profileImage!
                                        : "http://192.168.43.193:3000/${currentUser.profileImage}",
                                    fit: BoxFit.fill,
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.handleProfileImageFromGallery,
                child: Text("Edit Photo"),
              ),
              CustomTextField1(
                label: "Enter First Name",
                controller: firstnamecontroller,
                icon: Icons.person,
                initialtext: firstnamecontroller.text.isEmpty
                    ? currentUser.firstname ?? ''
                    : firstnamecontroller.text,
                validity: validfirstname,
                topMargin: 10,
                errorText: "Invalid First Name",
              ),
              CustomTextField1(
                label: "Enter Last Name",
                controller: lasttnamecontroller,
                icon: Icons.person,
                initialtext: lasttnamecontroller.text.isEmpty
                    ? currentUser.lastname ?? ''
                    : lasttnamecontroller.text,
                validity: validlastname,
                topMargin: 20,
                errorText: "Invalid Last Name",
              ),
              CustomTextField1(
                label: "Enter E-mail",
                controller: emailcontroller,
                icon: Icons.email,
                initialtext: emailcontroller.text.isEmpty
                    ? currentUser.username ?? ''
                    : emailcontroller.text,
                validity: validemail,
                topMargin: 20,
                errorText: "Invalid Email",
              ),
              CustomTextField1(
                label: "Enter Website Url",
                controller: websitecontroller,
                icon: Icons.connect_without_contact,
                initialtext: websitecontroller.text.isEmpty
                    ? currentUser.website ?? ''
                    : websitecontroller.text,
                validity: validwebsite,
                topMargin: 20,
                errorText: "Invalid URL",
              ),
              CustomTextField1(
                label: "Enter Bio",
                controller: biocontroller,
                icon: Icons.edit,
                initialtext: biocontroller.text.isEmpty
                    ? currentUser.bio ?? ''
                    : biocontroller.text,
                validity: true,
                topMargin: 20,
                bottomMargin: 30,
                maxLines: -1,
              ),
              ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    setState(() {
      isUpdating = true;
    });
    if (firstnamecontroller.text.trim().isEmpty) {
      setState(() {
        validfirstname = false;
      });
    } else {
      if (validfirstname == false) {
        setState(() {
          validfirstname = true;
        });
      }
    }
    if (lasttnamecontroller.text.trim().isEmpty) {
      setState(() {
        validlastname = false;
      });
    } else {
      if (validlastname == false) {
        setState(() {
          validlastname = true;
        });
      }
    }
    if (emailcontroller.text.trim().isEmpty) {
      setState(() {
        validemail = false;
      });
    } else {
      if (validemail == false) {
        setState(() {
          validemail = true;
        });
      }
    }
    if (emailcontroller.text.trim().isNotEmpty) {
      print("Validating email");
      var urlPattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(urlPattern);
      bool verify = regex.hasMatch(emailcontroller.text.trim());

      setState(() {
        validemail = verify;
      });
    }
    if (websitecontroller.text.trim().isNotEmpty) {
      print("Validating website");

      var urlPattern =
          r'^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$';
      RegExp regex = RegExp(urlPattern, caseSensitive: false);
      setState(() {
        validwebsite = regex.hasMatch(websitecontroller.text.trim());
      });
    }
    // Uploading profilephoto and getting url
    if (controller.profileImage != null)
      try {
        profileUrl =
            await StorageServices.uploadImage(controller.profileImage.value);
        profileUrl = profileUrl!.replaceAll('\\', '/');
        print("profileUrl ===> $profileUrl");
      } catch (e) {
        print("profileUrl Error ====> ${e.toString()}");
      }
    if (validfirstname && validemail && validlastname && validwebsite) {
      print("Entering Else Part");
      UserModal newUser = new UserModal(
        firstname: firstnamecontroller.text.trim(),
        lastname: lasttnamecontroller.text.trim(),
        username: emailcontroller.text.trim(),
        fullname: firstnamecontroller.text.trim() +
            ' ' +
            lasttnamecontroller.text.trim(),
        website: websitecontroller.text.trim(),
        bio: biocontroller.text.trim(),
        admin: currentUser.admin,
        dbID: currentUser.dbID,
        fbId: currentUser.fbId,
        id: currentUser.id,
        profileImage: profileUrl ?? currentUser.profileImage,
      );

      var response = await DatabaseServices.updateProfile(newUser, context);

      Get.snackbar(
        response['success'] ? 'Success' : 'Failed',
        response['message'],
        backgroundColor: response['success'] ? Colors.black38 : Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      // Future.delayed(Duration(seconds: 5)).then((value) => setState(() {
      //       isUpdating = false;
      //     }));
      setState(() {
        isUpdating = false;
      });
    }
  }

  // Container CustomTextField1(
  //   String label,
  //   TextEditingController controller,
  //   IconData icon,
  //   String initialtext,
  //   bool validity, {
  //   double topMargin = 0.0,
  //   double bottomMargin = 0.0,
  //   double leftMargin = 0.0,
  //   double rightMargin = 0.0,
  //   int maxLines = 1,
  //   String errorText = '',
  // }) {
  //   return Container(
  //     margin: EdgeInsets.only(
  //       top: topMargin,
  //       bottom: bottomMargin,
  //       left: leftMargin,
  //       right: rightMargin,
  //     ),
  //     width: Get.width * 0.85,
  //     child: TextField(
  //       controller: controller..text = initialtext,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         errorText: !validity ? errorText : null,
  //         filled: true,
  //         fillColor: Colors.grey[300],
  //         prefixIcon: Icon(icon),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.transparent),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blue),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.red),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.red),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //       ),
  //       maxLines: maxLines == -1 ? null : maxLines,
  //     ),
  //   );
  // }
}
