import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/profile.dart';

class ProfileFormModel extends ChangeNotifier {
  final ProfileRepository _userRepo = ProfileRepository();
  Profile? newUser;
  bool _isEdit = false;

  Future loadData(bool isEdit) async {
    newUser = (await _userRepo.get()) ?? Profile();
    _isEdit = isEdit;
    notifyListeners();
  }

  void setIcon(CustomImageData? value) {
    newUser?.icon = value;
    notifyListeners();
  }

  Future saveUser() async {
    try {
      if (newUser == null) return;
      if (!_isEdit) {
        await _userRepo.insert(newUser!);
      } else {
        await _userRepo.update(newUser!);
      }
      
    } 
    catch (e) {
      return e.toString();
    }
  }

  void setName(String? name) {
    newUser?.name = name ?? '';
    notifyListeners();
  }
}