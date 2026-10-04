import 'package:step_by_step/services/settings/settings_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  static Future<SettingsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
  }

  // =====================

  // ----------- Расчет -------------

  // Требование к 1 уровню
  int get calcReq1 => _prefs.getInt(SettingsFields.calc_req_1_lvl.name) ?? SettingsServiceValues.calc_req_1_lvl;
  void setCalcReq1(int value) => _prefs.setInt(SettingsFields.calc_req_1_lvl.name, value);

  // Коэффициент увеличения требований к уровню
  double get calcKoef => _prefs.getDouble(SettingsFields.calc_koef.name) ?? SettingsServiceValues.calc_koef;
  void setCalcKoef(double value) => _prefs.setDouble(SettingsFields.calc_koef.name, value);

  // Требование для получения 1 очка характеристик
  int get calcCharPointReq => _prefs.getInt(SettingsFields.calc_char_point_req.name) ?? SettingsServiceValues.calc_char_point_req;
  void setCalcCharPointReq(int value) => _prefs.setInt(SettingsFields.calc_char_point_req.name, value);
}