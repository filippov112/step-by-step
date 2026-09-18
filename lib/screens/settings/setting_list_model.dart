import 'package:chaos_control/services/settings/settings_service.dart';
import 'package:flutter/material.dart';

class SettingListModel extends ChangeNotifier {
  bool _hasChanged = false;
  bool get hasChanged => _hasChanged;
  SettingsService settings;

  SettingListModel(this.settings);

  Future save() async {
    settings.setCalcReq1(req1);
    settings.setCalcKoef(koef);
    settings.setCalcCharPointReq(charReq);
    _hasChanged = false;
    notifyListeners();
  }

  Future cancel() async {
    loadData();
    _hasChanged = false;
    notifyListeners();
  }

  void loadData() {
    req1 = settings.calcReq1;
    koef = settings.calcKoef;
    charReq = settings.calcCharPointReq;
  }

  void _change() {
    _hasChanged = true;
    notifyListeners();
  }

  // ========= Константы расчета =============

  // Требование к 1 уровню
  int req1 = 50;
  void setReq1(int value) {
    req1 = value;
    _change();
  }

  // Коэффициент увеличения требований к уровню
  double koef = 1.1;
  void setKoef(double value) {
    koef = value;
    _change();
  }

  // Требование для получения 1 очка характеристик
  int charReq = 24;
  void setCharReq(int value) {
    charReq = value;
    _change();
  }
}