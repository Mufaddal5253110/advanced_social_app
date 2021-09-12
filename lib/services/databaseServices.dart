import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

import 'dbHelper.dart';

@lazySingleton
class DatabaseServices {
  static Future updateProfile(UserModal user, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/profile');
    var res = await http.put(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode(user.toUpdateProfileJson()),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);

    if (res.statusCode == 200 && respdata['success']) {
      // Updating local database
      DBHelper helper = DBHelper.instance;
      int id = await helper.update(user);
      print(id);

      // Updating provider
      Provider.of<UserData>(context, listen: false).setUser(user);
    }
    return respdata;
  }

  static Future uploadPost(PostModel post) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/my');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode(post.toJsonForPost()),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);

    // if (res.statusCode == 200 && respdata['success']) {
    //   // Updating local database
    //   DBHelper helper = DBHelper.instance;
    //   int id = await helper.update(user);
    //   print(id);

    //   // Updating provider
    //   Provider.of<UserData>(context, listen: false).setUser(user);
    // }
    return respdata;
  }

  static Future getMyPosts() async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/my');
    var res = await http.get(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future getMyPostsBetween(int start, int end) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/my/get');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode({'start': start, 'end': end}),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future likePost(String? postid) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/like/$postid/');
    var res = await http.get(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future unlikePost(String? postid) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/unlike/$postid/');
    var res = await http.get(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future getUsers(int start, int end) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode({'start': start, 'end': end}),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future followUser(String? userid) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/follow');
    var res = await http.post(url2,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
        },
        body: jsonEncode({
          "userid": userid,
        }));
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future unfollowUser(String? userid) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/users/unfollow');
    var res = await http.post(url2,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
        },
        body: jsonEncode({
          "userid": userid,
        }));
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future getAllPostsBetween(
      int start, int end, List<String> followings) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/all');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode({
        'start': start,
        'end': end,
        'followings': followings,
      }),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future postActivity(Map data) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/activity/');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode(data),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future getActivity(int end) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/Activity/get');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode({
        'end': end,
      }),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future getComments(String postid, int end) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 =
        Uri.parse('http://192.168.43.193:3000/post/comment/$postid/$end');
    var res = await http.get(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }

  static Future postComment(String postid,Map data) async {
    final prefs = await SharedPreferences.getInstance();
    print("prefs.getString('jwtToken') ==> ${prefs.getString('jwtToken')}");

    Uri url2 = Uri.parse('http://192.168.43.193:3000/post/comment/$postid/0');
    var res = await http.post(
      url2,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('jwtToken')}'
      },
      body: jsonEncode(data),
    );
    var respdata = jsonDecode(res.body);
    print(respdata);
    return respdata;
  }
}
