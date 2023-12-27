import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/user.dart';
import 'package:pinpoint_app/api/users_controller.dart';

class UserProvider extends ChangeNotifier {
  List<User> _userList = [];
  
  List<User> get userList => _userList;

  Future<void> fetchData() async {
    try {
      List<User> fetchedList = await fetchUserList();
      _userList = fetchedList;
      notifyListeners();
    } catch (e) {
      // Handle errors
    }
  }
}
