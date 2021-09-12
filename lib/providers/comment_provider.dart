import 'package:flutter/material.dart';
import 'package:myapp/models/commentmodel.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/utils/connectivityChecker.dart';

class CommentProvider extends ChangeNotifier {
  final _comments = <CommentModel>[];
  String _errorMessage = '';
  int documentLimit = 6;
  bool _hasNext = true;
  bool _isFetchingComments = false;
  // bool dataaddedtohive = false;
  // int count = 0;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<CommentModel?> get comments => _comments;

  // Future fetchingPostFromHive({bool refresh: false}) async {
  //   bool exists = await HiveService.isExists(boxName: "MyPostTable");
  //   if (refresh) {
  //     // _posts.clear();
  //     // count = 0;
  //     // _hasNext = true;
  //   }
  //   if (exists) {
  //     var postlist = await HiveService.getBoxes("MyPostTable");
  //     (postlist as List).reversed.map((post) {
  //       _posts.add(CommentModel.fromJson(post));
  //     }).toList();
  //   } else {
  //     dataaddedtohive = false;
  //   }
  //   notifyListeners();
  // }

  Future fetchNextComments(String postid, {bool reset = false}) async {
    if (_isFetchingComments) return;

    _errorMessage = '';
    _isFetchingComments = true;
    if (await ConnectivityChecker.isInternet()) {
      try {
        // bool exists = await HiveService.isExists(boxName: "MyPostTable");
        // if (exists) {
        //   var postlist = await HiveService.getBoxes("MyPostTable");
        //   (postlist as List).reversed.map((post) {
        //     _posts.add(CommentModel.fromJson(post));
        //   }).toList();
        // }
        int start;

        start = _comments.isNotEmpty ? _comments.length : 0;
        // if (reset) start = 0;
        if (reset) {
          // _comments.clear();
          // dataaddedtohive = false;
          start = 0;
          // count++;
        }
        // print(count);
        print("start ==> $start");
        final resp =
            await DatabaseServices.getComments(postid, start + documentLimit);
        _comments.clear();
        (resp['comments'] as List).reversed.map((post) {
          _comments.add(CommentModel.fromJson(post));
        }).toList();

        // // Adding data to hive
        // if (dataaddedtohive == false || start == 0) {
        //   await HiveService.addBoxes(resp['comments'] as List, "MyPostTable");
        //   dataaddedtohive = true;
        // }

        print(resp['comments'].length % documentLimit);
        if (resp['comments'].length != start + documentLimit)
          _hasNext = false;
        else
          _hasNext = true;
        notifyListeners();
      } catch (error) {
        _errorMessage = error.toString();
        notifyListeners();
      }
    }

    _isFetchingComments = false;
  }
}
