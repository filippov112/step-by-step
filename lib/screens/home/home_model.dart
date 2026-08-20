import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/home/widgets/modules.dart';

class HomeModel extends ChangeNotifier {
  User? user;
  AppModule currentModule = AppModule.tasks;
  bool get userIsExist => user != null;

  final UserRepository _userRepo = UserRepository();
  
  Future loadUser() async {
    user = await _userRepo.get(); 
    notifyListeners();
  }

  void selectModule(AppModule module) {
    currentModule = module;
    notifyListeners();
  }

}