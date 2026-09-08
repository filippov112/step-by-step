import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/models/other/image.dart';


class PurportFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Purport purport = Purport.create(title: '');
  final purportRepo = PurportRepository();

  List<Purport> allPurports = [];

  String selectedTitle = '';
  String selectedDescription = '';
  CustomImageData? selectedIcon;
  DateTime? selectedDate;
  PurportType selectedRarity = PurportType.wealth;

  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setPurport(Purport? value) {
    isEditing = value != null;
    purport = value ?? Purport.create(title: '');
    selectedDate = purport.date;
    selectedRarity = purport.type;
    selectedIcon = purport.icon;
    selectedTitle = purport.title;
    selectedDescription = purport.description;
    notifyListeners();
  }


  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    selectedTitle = title ?? '';
    notifyListeners();
  }
  void setDescription(String? description) {
    selectedDescription = description ?? '';
    notifyListeners();
  }
  void setIcon(CustomImageData? value) {
    selectedIcon = value;
    notifyListeners();
  }
  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }
  void setRarity(PurportType rarity) {
    selectedRarity = rarity;
    notifyListeners();
  }


  // ---------- CRUD ---------------------

  Future deletePurport() async {
    if (isEditing) {
      try {
        await purportRepo.delete(purport.id);
      } catch (e) {
        // print(e);
      }
    }
  }

  Future<bool> savePurport() async {
    purport.title = selectedTitle;
    purport.description = selectedDescription;
    purport.date = selectedDate;
    purport.icon = selectedIcon;
    purport.type = selectedRarity;
    try {
      if (isEditing) {
        await purportRepo.update(purport);
      } else {
        await purportRepo.insert(purport);
      }
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }

}