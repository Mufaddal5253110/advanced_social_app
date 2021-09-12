import 'package:flutter/material.dart';
import 'package:myapp/models/usermodal.dart';
import 'package:myapp/providers/userdata.dart';
import 'package:myapp/services/databaseServices.dart';
// import 'package:myapp/services/hiveService.dart';
import 'package:myapp/utils/connectivityChecker.dart';

class UserProvider extends ChangeNotifier {
  final _users = <UserModal>[];
  String _errorMessage = '';
  int documentLimit = 7;
  bool _hasNext = true;
  bool _isFetchingUsers = false;
  // bool dataaddedtohive = false;
  // int count = 0;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<UserModal> get users => _users;

  // Future fetchingPostFromHive({bool refresh: false}) async {
  //   bool exists = await HiveService.isExists(boxName: "MyPostTable");
  //   if (refresh) {
  //     _users.clear();
  //     count = 0;
  //     _hasNext = true;
  //   }
  //   if (exists) {
  //     var postlist = await HiveService.getBoxes("MyPostTable");
  //     (postlist as List).reversed.map((post) {
  //       _users.add(UserModal.fromJson(post));
  //     }).toList();
  //   } else {
  //     dataaddedtohive = false;
  //   }
  //   notifyListeners();
  // }

  Future fetchNextUsers() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;
    if (await ConnectivityChecker.isInternet()) {
      try {
        // bool exists = await HiveService.isExists(boxName: "MyPostTable");
        // if (exists) {
        //   var postlist = await HiveService.getBoxes("MyPostTable");
        //   (postlist as List).reversed.map((post) {
        //     _users.add(UserModal.fromJson(post));
        //   }).toList();
        // }
        int start = _users.isNotEmpty ? _users.length : 0;
        // if (start == documentLimit && count < 1) {
        //   _users.clear();
        //   dataaddedtohive = false;
        //   start = 0;
        //   count++;
        // }
        // print(count);
        // _users.clear();
        print("start ==> $start");
        final resp =
            await DatabaseServices.getUsers(start, start + documentLimit);
        (resp['users'] as List).map((user) {
          _users.add(UserModal.fromJson(user));
        }).toList();

        // Adding data to hive
        // if (dataaddedtohive == false) {
        //   await HiveService.addBoxes(resp['posts'] as List, "MyPostTable");
        //   dataaddedtohive = true;
        // }

        if (resp['users'].length < documentLimit) _hasNext = false;
        notifyListeners();
      } catch (error) {
        _errorMessage = error.toString();
        notifyListeners();
      }
    }

    _isFetchingUsers = false;
  }
}
