// ignore_for_file: public_member_api_docs

import 'package:intl/intl.dart';

final _formatter = NumberFormat();

NumberFormat _currency([int? decimalDigits = 2]) => NumberFormat.currency(
      symbol: r'$',
      decimalDigits: decimalDigits,
      locale: 'en_US',
    );

String get currency => _currency().currencySymbol;

/// Extension for parsing [String] to  [num].
extension Parse on String {
  /// Parse [String] to  [num].
  num get parse => isEmpty ? 0 : _formatter.parse(clearValue);
}

/// Extension for formatting on [String]
extension FormatString on String {
  /// Format [num] to  [String].

  String format({bool separate = true}) =>
      separate ? _formatter.format(parse) : this;

  /// Formats [num] to  [String]
  num formatToNum({bool separate = true}) => format(separate: separate).parse;

  /// Returns [String] with currency symbol
  String currencyFormat({int? decimalDigits}) =>
      _currency(decimalDigits).format(formatToNum(separate: false));
}

/// Extension for formatting [num] to  [String].
extension FormatNum on num {
  /// Returns [String] with currency symbol
  String currencyFormat({int? decimalDigits}) =>
      _currency(decimalDigits).format(this);
}

/// Extension for removing all non-digit characters from a string.
extension ClearValue on String {
  /// Removes all non-digits from string.
  String get clearValue => replaceAll(RegExp(r'[^\d]'), '');
}

/// Extension for formatting [DateTime] to [String].
extension DateFormatter on DateTime {
  /// Format [DateTime] to  [String].
  String formatByPattern(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String ddMMMMHHMM() => DateFormat('dd MMM HH:mm', 'en_US').format(this);

  String hhMM() => DateFormat('HH:mm', 'en_US').format(this);
}
