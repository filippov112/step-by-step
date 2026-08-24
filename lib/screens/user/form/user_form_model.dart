import 'package:flutter/material.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/models/user.dart';

class UserFormModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();
  User? newUser;
  bool _isEdit = false;

  Future loadData(bool isEdit) async {
    newUser = (await _userRepo.get()) ?? User(dateBirth: DateTime(2000));
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

  void setDateBirth(DateTime? selectedDate) {
    newUser?.dateBirth = selectedDate ?? DateTime(2000);
    notifyListeners();
  }

  void setName(String? name) {
    newUser?.name = name ?? '';
    notifyListeners();
  }
}