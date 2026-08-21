String formatDate(DateTime date) {
  return '${date.day} ${_getMonthName(date.month)} ${date.year}';
}
String _getMonthName(int month) {
  const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 
                  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
  return months[month - 1];
}