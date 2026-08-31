import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/screens/home/widgets/modules.dart';

class HomeModel extends ChangeNotifier {
  Profile? user;
  AppModule currentModule = AppModule.walls;
  bool get userIsExist => user != null;

  final ProfileRepository _userRepo = ProfileRepository();
  
  Future loadUser() async {
    user = await _userRepo.get(); 
    notifyListeners();
  }

  void selectModule(AppModule module) {
    currentModule = module;
    notifyListeners();
  }

}