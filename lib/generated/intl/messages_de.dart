// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(count) =>
      "Nächster Klassenarbeit ${Intl.plural(count, zero: 'heute!', one: 'in 1 Tag', other: 'in ${count} Tagen')}";

  static String m1(name) => "Willkommen zurück, ${name}!";

  static String m2(count) =>
      "${Intl.plural(count, zero: 'Einen schönen Tag!', one: '1 Karte übrig', other: '${count} Karten übrig')}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'Heute fertig', other: 'Alle Karten lernen')}";

  static String m4(date) => "${date}";

  static String m5(count) =>
      "${Intl.plural(count, one: 'Fach', other: 'Fächer')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "calendarTitle": MessageLookupByLibrary.simpleMessage("Kalender"),
        "classTestIn": m0,
        "homePageAppBar": m1,
        "learnCardSubTitle": m2,
        "learnCardTitle": m3,
        "month": m4,
        "subject": m5
      };
}
