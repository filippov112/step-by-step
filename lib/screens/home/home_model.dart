import 'package:flutter/material.dart';
import 'package:step_by_step/models/profile.dart';
import 'package:step_by_step/screens/home/modules.dart';

class HomeModel extends ChangeNotifier {
  Profile? profile;
  AppModule currentModule = AppModule.chronicle;
  bool get userIsExist => profile != null;

  final ProfileRepository _profileRepo = ProfileRepository();
  
  Future loadData() async {
    profile = await _profileRepo.get(); 
    notifyListeners();
  }

  void selectModule(AppModule module) {
    currentModule = module;
    notifyListeners();
  }

}