import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/services/dbHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhotoController extends GetxController {
  // Rx<String>? profileurl = ''.obs;
  var profileImage = XFile('').obs;

  final ImagePicker _picker = ImagePicker();

  handleProfileImageFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print(pickedFile.path);
      profileImage.value = pickedFile;
      print("ProfileImage ==> ${profileImage.value.path}");
    } else {
      print('No image selected.');
    }
  }
}
