// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Welcome back, ${name}!";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'Have a nice day!', one: '1 card left', other: '${count} cards left')}";

  static String m2(count) =>
      "${Intl.plural(count, zero: 'Finished Today', other: 'Learn All Cards')}";

  static String m4(date) => "${date}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'Subject', other: 'Subjects')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "calendarTitle": MessageLookupByLibrary.simpleMessage("Calendar"),
        "homePageAppBar": m0,
        "learnCardSubTitle": m1,
        "learnCardTitle": m2,
        "month": m4,
        "subject": m3
      };
}
