import 'package:flutter/material.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/hiveService.dart';
import 'package:myapp/utils/connectivityChecker.dart';

class AllPostProvider extends ChangeNotifier {
  final _posts = <PostModel>[];
  String _errorMessage = '';
  int documentLimit = 3;
  bool _hasNext = true;
  bool _isFetchingPosts = false;
  bool dataaddedtohive = false;
  int count = 0;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<PostModel> get posts => _posts;

  // DateTime? pointer;

  Future fetchingPostFromHive({bool refresh: false}) async {
    bool exists = await HiveService.isExists(boxName: "AllPostTable");
    if (refresh) {
      _posts.clear();
      count = 0;
      _hasNext = true;
    }
    if (exists) {
      var postlist = await HiveService.getBoxes("AllPostTable");
      // print(postlist);
      (postlist as List).map((post) {
        _posts.add(PostModel.fromJson(post));
      }).toList();
    } else {
      dataaddedtohive = false;
    }
    notifyListeners();
  }

  Future fetchNextPosts(List<String> followings, {bool reset = false}) async {
    if (_isFetchingPosts) return;

    _errorMessage = '';
    _isFetchingPosts = true;
    if (await ConnectivityChecker.isInternet()) {
      try {
        // bool exists = await HiveService.isExists(boxName: "MyPostTable");
        // if (exists) {
        //   var postlist = await HiveService.getBoxes("MyPostTable");
        //   (postlist as List).reversed.map((post) {
        //     _posts.add(PostModel.fromJson(post));
        //   }).toList();
        // }
        // DateTime start = _posts.isNotEmpty
        //     ? _posts[_posts.length-1].createdAt!
        //     : DateTime.now();
        int start;
        start = _posts.isNotEmpty ? _posts.length : 0;
        if (reset) start = 0;
        // if (start == documentLimit && count < 1) {
        //   _posts.clear();
        //   dataaddedtohive = false;
        //   start = 0;
        //   count++;
        // }
        // print(count);
        print("start ==> ${start}");
        final resp = await DatabaseServices.getAllPostsBetween(
          0,
          documentLimit + start,
          followings,
        );
        _posts.clear();

        (resp['posts'] as List).map((post) {
          _posts.add(PostModel.fromJson(post));
        }).toList();

        // Adding data to hive
        if (dataaddedtohive == false || start == 0) {
          List data = resp['posts'];
          await HiveService.addBoxes(data.sublist(0,5), "AllPostTable");
          dataaddedtohive = true;
        }

        // if (resp['posts'].length == 0) fetchNextPosts(followings);
        print(resp['posts'].length % documentLimit);
        if (resp['posts'].length % documentLimit != 0 ||
            resp['posts'].length == 0)
          _hasNext = false;
        else
          _hasNext = true;
        notifyListeners();
      } catch (error) {
        _errorMessage = error.toString();
        notifyListeners();
      }
    }

    _isFetchingPosts = false;
  }
}
