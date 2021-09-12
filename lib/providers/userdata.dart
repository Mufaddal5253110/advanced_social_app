import 'package:flutter/material.dart';
import 'package:myapp/models/usermodal.dart';

class UserData extends ChangeNotifier {
  // String currentUserId;

  UserModal currentUser = UserModal();
  // DefaultAstro defaultAstro;

  

  UserModal get getUser {
    return currentUser;
  }

  setUser(UserModal user) {
    currentUser = user;
    notifyListeners();
  }
}