class DateTool {
  // Прибавка таймзоны для корректности определения дат
  static final timezone = DateTime.now().timeZoneOffset;
  
  // Конвертация в дни от начала эпохи
  static int? datetimeToDays(DateTime? datetime) {
    return datetime == null ? null : (datetime.add(timezone)).millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);
  }

  // Конвертация во временную часть в расчете числа минут
  static int? datetimeToTimeMinutes(DateTime? datetime) {
    return datetime == null ? null : (datetime.add(timezone)).millisecondsSinceEpoch % (24 * 60 * 60 * 1000) ~/ (60 * 1000);
  }

  // Восстановление даты времени из компонентов (дни + минуты от начала суток)
  static DateTime? joinDateTime({int? date, int? time}) {
    DateTime? result;
    if (date != null) {
      result = DateTime.fromMillisecondsSinceEpoch(date * (24 * 60 * 60 * 1000));
    }
    if (time != null) {
      final dTime = DateTime.fromMillisecondsSinceEpoch(time * 60 * 1000);
      result = DateTime(result?.year ?? 0, result?.month ?? 0, result?.day ?? 0, dTime.hour, dTime.minute);
    }
    if (result != null) {
      result = result.subtract(timezone);
    }
    return result;
  }

  // Сегодняшнее число
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}