String formatDate(DateTime date) {
  return '${date.day} ${_getMonthName(date.month)} ${date.year}';
}
String _getMonthName(int month) {
  const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 
                  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
  return months[month - 1];
}

String getShortMonthName(int month) {
  const months = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 
                  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
  return months[month - 1];
}