import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/profile.dart';

class ProfileFormModel extends ChangeNotifier {
  late final SpiritCalculator calculator;
  final ProfileRepository _userRepo = ProfileRepository();
  Profile? profile;
  bool _isEdit = false;

  ProfileFormModel(this.calculator);

  void loadData(Profile? p) {
    profile = p ?? Profile();
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
  void setChar(Characteristic char, int value) {
    switch (char) {
      case Characteristic.happiness:
        profile?.happinessBase = value;
      case Characteristic.diligence:
        profile?.diligenceBase = value;
      case Characteristic.intellection:
        profile?.intellectionBase = value;
      case Characteristic.durability:
        profile?.durabilityBase = value;
      case Characteristic.potencial:
        profile?.potencialBase = value;
    }
    notifyListeners();
  }
}