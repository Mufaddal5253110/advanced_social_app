import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future uploadImage(XFile image) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.43.193:3000/uploadImage'));
    request.files.add(await http.MultipartFile.fromPath('imageFile', image.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1])));

    request.headers.addAll({
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
    });
    var res = await request.send();
    // listen for response
    
    var respStr = await http.Response.fromStream(res);
    print("respStr.body => ${respStr.body}");
    print("respStr => $respStr");
    var response = jsonDecode(respStr.body);
    return response["data"]["path"];
  }
}
