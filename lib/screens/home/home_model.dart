import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';

class HomeModel extends ChangeNotifier {
  User? user;
  int currentTab = 1;
  bool get userIsExist => user != null;

  final UserRepository _userProvider = UserRepository();
  
  Future loadUser() async {
    user = await _userProvider.get(); 
    notifyListeners();
  }

  void selectTab(int id) {
    currentTab = id;
    notifyListeners();
  }

}