String getDateIntervalString(DateTime first, DateTime? last) {
  final DateTime last0 = last ?? DateTime.now();

  // Вычисляем полные года
  int years = last0.year - first.year;
  // Корректируем, если день рождения ещё не наступил в этом году
  if (last0.month < first.month || 
      (last0.month == first.month && last0.day < first.day)) {
    years--;
  }
  
  // Вычисляем оставшиеся дни после полных лет
  final lastBirthday = DateTime(last0.year, first.month, first.day);
  final nextBirthday = DateTime(
    last0.year + (last0.isAfter(lastBirthday) ? 1 : 0),
    first.month,
    first.day,
  );
  final daysUntilNextBirthday = nextBirthday.difference(last0).inDays;
  final daysAfterLastBirthday = last0.difference(lastBirthday).inDays;
  
  // Определяем дни (если ДР уже был в этом году — считаем от него, иначе — до следующего)
  int days;
  if (last0.isAfter(lastBirthday)) {
    days = daysAfterLastBirthday;
  } else {
    days = 365 - daysUntilNextBirthday; // приблизительно
  }
  
  // Более точный способ: берём остаток от общего количества дней
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
  } else if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) {
    yearsStr = '$years года';
  } else {
    yearsStr = '$years лет';
  }
  
  // Склонение для дней
  String daysStr;
  if (days % 10 == 1 && days % 100 != 11) {
    daysStr = '$days день';
  } else if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
    daysStr = '$days дня';
  } else {
    daysStr = '$days дней';
  }
  
  return years > 0 ? '$yearsStr, $daysStr' : daysStr;
}