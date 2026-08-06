String getAgeString(DateTime birthDate) {
  final now = DateTime.now();
  
  // Вычисляем разницу в днях
  final difference = now.difference(birthDate);
  final totalDays = difference.inDays;
  
  if (totalDays < 0) {
    return 'Дата рождения в будущем';
  }
  
  // Вычисляем полные года
  int years = now.year - birthDate.year;
  // Корректируем, если день рождения ещё не наступил в этом году
  if (now.month < birthDate.month || 
      (now.month == birthDate.month && now.day < birthDate.day)) {
    years--;
  }
  
  // Вычисляем оставшиеся дни после полных лет
  final lastBirthday = DateTime(now.year, birthDate.month, birthDate.day);
  final nextBirthday = DateTime(
    now.year + (now.isAfter(lastBirthday) ? 1 : 0),
    birthDate.month,
    birthDate.day,
  );
  final daysUntilNextBirthday = nextBirthday.difference(now).inDays;
  final daysAfterLastBirthday = now.difference(lastBirthday).inDays;
  
  // Определяем дни (если ДР уже был в этом году — считаем от него, иначе — до следующего)
  int days;
  if (now.isAfter(lastBirthday)) {
    days = daysAfterLastBirthday;
  } else {
    days = 365 - daysUntilNextBirthday; // приблизительно
  }
  
  // Более точный способ: берём остаток от общего количества дней
  // Вычисляем дни, прошедшие после последнего дня рождения
  final birthdayThisYear = DateTime(now.year, birthDate.month, birthDate.day);
  if (now.isAfter(birthdayThisYear)) {
    days = now.difference(birthdayThisYear).inDays;
  } else {
    final birthdayLastYear = DateTime(now.year - 1, birthDate.month, birthDate.day);
    days = now.difference(birthdayLastYear).inDays;
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
  
  return '$yearsStr, $daysStr';
}