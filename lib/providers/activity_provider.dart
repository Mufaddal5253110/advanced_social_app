import 'package:flutter/material.dart';
import 'package:myapp/models/activitymodel.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/utils/connectivityChecker.dart';

class ActivityProvider extends ChangeNotifier {
  final _activity = <Activitymodel>[];
  String _errorMessage = '';
  int documentLimit = 3;
  bool _hasNext = true;
  bool _isFetchingActivity = false;
  // bool dataaddedtohive = false;
  // int count = 0;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Activitymodel> get activity => _activity;

  // DateTime? pointer;

  // Future fetchingPostFromHive({bool refresh: false}) async {
  //   bool exists = await HiveService.isExists(boxName: "AllPostTable");
  //   if (refresh) {
  //     _activity.clear();
  //     count = 0;
  //     _hasNext = true;
  //   }
  //   if (exists) {
  //     var postlist = await HiveService.getBoxes("AllPostTable");
  //     // print(postlist);
  //     (postlist as List).map((post) {
  //       _activity.add(PostModel.fromJson(post));
  //     }).toList();
  //   } else {
  //     dataaddedtohive = false;
  //   }
  //   notifyListeners();
  // }

  Future fetchNextActivity({bool reset = false}) async {
    if (_isFetchingActivity) return;

    _errorMessage = '';
    _isFetchingActivity = true;
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
        start = _activity.isNotEmpty ? _activity.length : 0;
        if (reset) start = 0;
        // if (start == documentLimit && count < 1) {
        //   _posts.clear();
        //   dataaddedtohive = false;
        //   start = 0;
        //   count++;
        // }
        // print(count);
        print("start ==> ${start}");
        final resp = await DatabaseServices.getActivity(
          documentLimit + start,
        );
        _activity.clear();

        (resp['activity'] as List).map((activity) {
          print("adding");
          _activity.add(Activitymodel.fromJson(activity));
        }).toList();

        // Adding data to hive
        // if (dataaddedtohive == false || start == 0) {
        //   await HiveService.addBoxes(resp['posts'] as List, "AllPostTable");
        //   dataaddedtohive = true;
        // }

        // if (resp['posts'].length == 0) fetchNextPosts(followings);
        print(resp['activity'].length % documentLimit);
        if (resp['activity'].length % documentLimit != 0 ||
            resp['activity'].length == 0)
          _hasNext = false;
        else
          _hasNext = true;
        notifyListeners();
      } catch (error) {
        _errorMessage = error.toString();
        notifyListeners();
      }
    }

    _isFetchingActivity = false;
  }
}
