import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/screens/home/modules.dart';

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