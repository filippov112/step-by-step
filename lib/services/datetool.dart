import 'package:chaos_control/services/numerictool.dart';

class DateTool {
  // Прибавка таймзоны для корректности определения дат
  static final timezone = DateTime.now().timeZoneOffset;

  // Конвертация в дни от начала эпохи
  static int? datetimeToDays(DateTime? datetime) {
    return datetime == null
        ? null
        : (datetime.add(timezone)).millisecondsSinceEpoch ~/
              (24 * 60 * 60 * 1000);
  }

  // Конвертация во временную часть в расчете числа минут
  static int? datetimeToTimeMinutes(DateTime? datetime) {
    return datetime == null
        ? null
        : (datetime.add(timezone)).millisecondsSinceEpoch %
              (24 * 60 * 60 * 1000) ~/
              (60 * 1000);
  }

  // Восстановление даты времени из компонентов (дни + минуты от начала суток)
  static DateTime? joinDateTime({int? date, int? time}) {
    DateTime? result;
    if (date != null) {
      result = DateTime.fromMillisecondsSinceEpoch(
        date * (24 * 60 * 60 * 1000),
      );
    }
    if (time != null) {
      final dTime = DateTime.fromMillisecondsSinceEpoch(time * 60 * 1000);
      result = DateTime(
        result?.year ?? 0,
        result?.month ?? 0,
        result?.day ?? 0,
        dTime.hour,
        dTime.minute,
      );
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

  // Текстовое представление даты
  static String fullDateFormat(DateTime? date) {
    if (date == null) return '';
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  static String shortDateFormat(DateTime? date) {
    if (date == null) return '';
    return '${NumericTool.toZeroFormat(date.day, 2)}.${NumericTool.toZeroFormat(date.month, 2)}.${NumericTool.toZeroFormat(date.year, 4)}';
  }

  static String _getMonthName(int month) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return months[month - 1];
  }

  // Краткое обозначение месяца
  static String shortMonthFormat(int month) {
    const months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'мая',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];
    return months[month - 1];
  }

  static String age(DateTime first, DateTime? last) {
    final DateTime last0 = last ?? DateTime.now();

    // Вычисляем полные года
    int years = last0.year - first.year;
    // Корректируем, если день рождения ещё не наступил в этом году
    if (last0.month < first.month ||
        (last0.month == first.month && last0.day < first.day)) {
      years--;
    }
    int days;

    // Берём остаток от общего количества дней
    // Вычисляем дни, прошедшие после последнего дня рождения
    final birthdayThisYear = DateTime(last0.year, first.month, first.day);
    if (last0.isAfter(birthdayThisYear)) {
      days = last0.difference(birthdayThisYear).inDays;
    } else {
      final birthdayLastYear = DateTime(last0.year - 1, first.month, first.day);
      days = last0.difference(birthdayLastYear).inDays;
    }

    // Склонение для лет
    String yearsStr;
    if (years % 10 == 1 && years % 100 != 11) {
      yearsStr = '$years год';
    } else if (years % 10 >= 2 &&
        years % 10 <= 4 &&
        (years % 100 < 10 || years % 100 >= 20)) {
      yearsStr = '$years года';
    } else {
      yearsStr = '$years лет';
    }

    // Склонение для дней
    String daysStr;
    if (days % 10 == 1 && days % 100 != 11) {
      daysStr = '$days день';
    } else if (days % 10 >= 2 &&
        days % 10 <= 4 &&
        (days % 100 < 10 || days % 100 >= 20)) {
      daysStr = '$days дня';
    } else {
      daysStr = '$days дней';
    }

    return years > 0 ? '$yearsStr, $daysStr' : daysStr;
  }
}
