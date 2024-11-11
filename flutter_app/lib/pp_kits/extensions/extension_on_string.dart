import 'package:flutter_app/generated/l10n.dart';
import 'package:intl/intl.dart';

extension IntlExtension on S {
  String tr(String key) {
    return Intl.message(toString(), name: key, args: []);
  }
}

extension StringExtension on String {
  String get localized => S.current.tr(this);

  String localizedWithArgs(
      {List<String>? args, Map<String, String>? namedArgs}) {
    if (args == null && namedArgs == null) {
      return S.current.tr(this);
    }
    //return this.tr(args: args, namedArgs: namedArgs);
    return localized;
  }

  bool isEmoji() {
    final emojiRegex = RegExp(
      r'(\u00A9|\u00AE|[\u2000-\u3300]|[\uD83C-\uDBFF\uDC00-\uDFFF])',
    );
    return emojiRegex.hasMatch(this);
  }
}
