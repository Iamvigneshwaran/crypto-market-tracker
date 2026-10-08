import 'package:intl/intl.dart';

class Fmt {
  static String price(double v) {
    if (v == 0) return '\$0.00';
    final digits = v >= 1 ? 2 : (v >= 0.01 ? 4 : 6);
    return NumberFormat.currency(symbol: '\$', decimalDigits: digits).format(v);
  }

  static String priceOrDash(double? v) => v == null ? '--' : price(v);

  /// $1.69T, $31.77B
  static String compact(double v) =>
      NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 2).format(v);

  static String compactOrDash(double? v) => v == null ? '--' : compact(v);

  static String percent(double? v) =>
      v == null ? '--' : '${v.abs().toStringAsFixed(2)}%';

  static String signedPercent(double? v) => v == null
      ? '--'
      : '${v >= 0 ? '+' : '-'}${v.abs().toStringAsFixed(2)}%';

  /// 20.1M BTC
  static String supply(double? v, {String symbol = ''}) {
    if (v == null) return '--';
    final s = NumberFormat.compact().format(v);
    return symbol.isEmpty ? s : '$s ${symbol.toUpperCase()}';
  }

  static String date(String? iso) {
    final d = DateTime.tryParse(iso ?? '');
    return d == null ? '--' : DateFormat('d MMM yyyy').format(d.toLocal());
  }

    static String count(int? v) =>
      v == null ? '--' : NumberFormat.decimalPattern().format(v);

  /// Dominance: 57.2%
  static String plainPercent(double? v) =>
      v == null ? '--' : '${v.toStringAsFixed(1)}%';

  /// CoinGecko description la HTML tags irukkum (<a href=...>), adhai remove pannum
  static String stripHtml(String html) => html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll(RegExp(r'\r?\n\s*\n+'), '\n\n')
      .trim();
}