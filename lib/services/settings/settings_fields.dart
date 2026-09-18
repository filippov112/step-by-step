enum SettingsFields {
  // Требование к 1 уровню
  calc_req_1_lvl,
  // Коэффициент увеличения требований к уровню
  calc_koef,
  // Требование для получения 1 очка характеристик
  calc_char_point_req,
}

class SettingsServiceValues {
  // Требование к 1 уровню
  static const int calc_req_1_lvl = 50;
  // Коэффициент увеличения требований к уровню
  static const double calc_koef = 1.1;
  // Требование для получения 1 очка характеристик
  static const int calc_char_point_req = 24;
}