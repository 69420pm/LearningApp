// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome back, {name}!`
  String homePageAppBar(Object name) {
    return Intl.message(
      'Welcome back, $name!',
      name: 'homePageAppBar',
      desc: '',
      args: [name],
    );
  }

  /// `{count, plural, other{Subjects} one{Subject}}`
  String subject(num count) {
    return Intl.plural(
      count,
      other: 'Subjects',
      one: 'Subject',
      name: 'subject',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, zero{Finished Today} other{Learn All Cards}}`
  String learnCardTitle(num count) {
    return Intl.plural(
      count,
      zero: 'Finished Today',
      other: 'Learn All Cards',
      name: 'learnCardTitle',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, zero{Have a nice day!} one{1 card left} other{{count} cards left}}`
  String learnCardSubTitle(num count) {
    return Intl.plural(
      count,
      zero: 'Have a nice day!',
      one: '1 card left',
      other: '$count cards left',
      name: 'learnCardSubTitle',
      desc: '',
      args: [count],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `{date}`
  String month(DateTime date) {
    final DateFormat dateDateFormat = DateFormat.yMMMM(Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      '$dateString',
      name: 'month',
      desc: '',
      args: [dateString],
    );
  }

  /// `Next class test {count, plural, zero{today!} one{in 1 day} other{in {count} days}}`
  String classTestIn(num count) {
    return Intl.message(
      'Next class test ${Intl.plural(count, zero: 'today!', one: 'in 1 day', other: 'in $count days')}',
      name: 'classTestIn',
      desc: '',
      args: [count],
    );
  }

  /// `day streak`
  String get dayStreak {
    return Intl.message(
      'day streak',
      name: 'dayStreak',
      desc: '',
      args: [],
    );
  }

  /// `streak saver`
  String get streakSaver {
    return Intl.message(
      'streak saver',
      name: 'streakSaver',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
