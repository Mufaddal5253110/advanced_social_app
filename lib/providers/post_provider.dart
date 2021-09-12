import 'package:flutter/material.dart';
import 'package:myapp/models/postmodel.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/hiveService.dart';
import 'package:myapp/utils/connectivityChecker.dart';

class PostProvider extends ChangeNotifier {
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

  Future fetchingPostFromHive({bool refresh: false}) async {
    bool exists = await HiveService.isExists(boxName: "MyPostTable");
    if (refresh) {
      // _posts.clear();
      // count = 0;
      // _hasNext = true;
    }
    if (exists) {
      var postlist = await HiveService.getBoxes("MyPostTable");
      (postlist as List).reversed.map((post) {
        _posts.add(PostModel.fromJson(post));
      }).toList();
    } else {
      dataaddedtohive = false;
    }
    notifyListeners();
  }

  Future fetchNextPosts({bool reset = false}) async {
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
        int start;

        start = _posts.isNotEmpty ? _posts.length : 0;
        // if (reset) start = 0;
        if (reset) {
          _posts.clear();
          dataaddedtohive = false;
          start = 0;
          count++;
        }
        print(count);
        print("start ==> $start");
        final resp = await DatabaseServices.getMyPostsBetween(
            start, start + documentLimit);
        (resp['posts'] as List).reversed.map((post) {
          _posts.add(PostModel.fromJson(post));
        }).toList();

        // Adding data to hive
        if (dataaddedtohive == false || start == 0) {
          await HiveService.addBoxes(resp['posts'] as List, "MyPostTable");
          dataaddedtohive = true;
        }

        if (resp['posts'].length < documentLimit)
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
