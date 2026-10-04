import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/services/hours_calculator.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/models/other/image.dart';
import 'package:step_by_step/models/profile.dart';

class ProfileFormModel extends ChangeNotifier {
  late final HoursCalculator calculator;
  final ProfileRepository _userRepo = ProfileRepository();
  Profile? profile;
  bool _isEdit = false;

  ProfileFormModel(this.calculator);

  void loadData(Profile? p) {
    profile = p ?? Profile(chars: CharValues(), baseChars: CharValues());
    _isEdit = p != null;
  }

  void setIcon(CustomImageData? value) {
    profile?.icon = value;
    notifyListeners();
  }

  Future save() async {
    try {
      if (profile == null) return;
      if (!_isEdit) {
        await _userRepo.insert(profile!);
      } else {
        await _userRepo.update(profile!);
      }
      await calculator.recalcUserChars();
    } 
    catch (e) {
      return e.toString();
    }
  }

  void setName(String? name) {
    profile?.name = name ?? '';
    notifyListeners();
  }
  void setBaseChar(Characteristic char, int value) {
    if (profile == null) return;
    final baseChars = profile!.baseChars.map;
    baseChars[char] = value;
    profile!.baseChars.setChars(baseChars);
    notifyListeners();
  }
}