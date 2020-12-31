import 'package:intl/intl.dart';

const externalFiles = '/storage/emulated/0';
const List<String> abbrWeekdays = ['пн','вт','ср','чт','пт','сб','вс'];
const RUBLE_SIGN = '₽';

/// Тип действия с данными
enum DataActionType {
  Insert,
  Update,
  Delete,
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Сегодня
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Проверка строки на пустоту
bool isEmpty(String value) => value == null || value.trim().isEmpty;

/// Проверка строки на непустоту
bool isNotEmpty(String value) => !isEmpty(value);

/// Преобразование строки в дату
DateTime stringToDate(String value) {
  DateTime result = isNotEmpty(value) ? DateTime.tryParse(value.trim()) : null;
  if (result == null) {
    final _parseFormat = RegExp(r'^(\d\d)\.(\d\d)\.(\d\d\d\d)$');
    Match match = _parseFormat.firstMatch(value);
    if (match != null) {
      final day = int.parse(match[1]);
      final month = int.parse(match[2]);
      final year = int.parse(match[3]);
      result = DateTime(year, month, day);
    }
  }
  return result;
}

/// Удаление концевых пробелов из строки
String trim(String value) =>
    isNotEmpty(value) ? value.trim() : '';

/// Преобразование строки в число
double stringToDouble(String value) {
  return isNotEmpty(value) ? double.tryParse(value.replaceAll(',', '.').trim()) : null;
}

/// Преобразование строки в целое
int stringToInt(String value) =>
    isNotEmpty(value) ? int.tryParse(value.trim()) : null;

/// Преобразование дробного числа в строку
String doubleToString(double number, {
  bool thousandSeparator = true,
  bool suppressZero = false,
  String period = ',',
}) {
  final str = number != null ? NumberFormat('${thousandSeparator ? '#,' : ''}##0.00').format(number) : '';
  return isNotEmpty(str) && (!suppressZero || number != 0) ? str.replaceAll(',', period) : '';
}

/// Преобразование даты в строку
String dateToString(DateTime date) =>
    date != null ? DateFormat('dd.MM.yyyy').format(date) : '';

/// Преобразование даты периода в строку
String periodToString(DateTime period) {
  final str = period != null ? DateFormat(DateFormat.YEAR_MONTH).format(period) : '';
  return str.toUpperCase().substring(0, str.length - 3);
}

/// Преобразование даты периода в строку
String abbrWeekday(DateTime date) {
  return date != null ? DateFormat(DateFormat.ABBR_WEEKDAY).format(date) : '';
}

/// Дата является выходным днём
bool isHoliday(DateTime date) {
  final weekday = abbrWeekday(date);
  final weekdayIndex = abbrWeekdays.indexOf(weekday);
  return [5,6].contains(weekdayIndex);
}

/// Дата является днём рождения
bool isBirthday(DateTime date, DateTime birthday) =>
    date?.day == birthday?.day && date?.month == birthday?.month;

/// Заглавная первая буква в строке
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

/// Строка нуждается в исправлении
bool needStringUpdate(String oldValue, String newValue) =>
    trim(oldValue) == '' && trim(newValue) != '' ||
        trim(oldValue) != '' && trim(newValue) != '' && trim(oldValue) != trim(newValue);

/// Дата нуждается в исправлении
bool needDateUpdate(DateTime oldValue, DateTime newValue) =>
    oldValue == null && newValue != null ||
        oldValue != null && newValue != null && oldValue != newValue;

/// Преобразование URI в строку
String uriToString(Uri uri) {
  final encoded = uri?.path?.replaceFirst('/external_files', externalFiles)?.replaceFirst('/media', externalFiles);
  return encoded != null ? Uri.decodeFull(encoded) : null;
}

/// Первый символ строки является цифрой
bool isDigit(String s) => ['0','1','2','3','4','5','6','7','8','9'].contains(s.substring(0, 0));