import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/injection_container.dart';

abstract class CalendarDataSource {
  Future<CalendarModel?> getCalendar();
  Future<void> saveCalendar(CalendarModel calendar);
  Future<void> deleteCalendar();
}

class CalendarFireStore implements CalendarDataSource {
  final db = FirebaseFirestore.instance;
  @override
  Future<void> deleteCalendar() {
    // TODO: implement deleteCalendar
    throw UnimplementedError();
  }

  @override
  Future<CalendarModel?> getCalendar() async {
    return await db
        .collection("calendar")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()?.isNotEmpty ?? false) {
        return CalendarModel.fromJson(value.data()!);
      }
    }, onError: (e) {
      e.toString().contains("[cloud_firestore/unavailable]")
          ? null
          : throw Exception(e.toString());
    });
  }

  @override
  Future<void> saveCalendar(CalendarModel calendar) async {
    //if device is offline, await does not finish and app pauses
    unawaited(db
        .collection("calendar")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(calendar.toJson())
        .onError((e, _) => throw (Exception(e))));
  }
}

class CalendarHive implements CalendarDataSource {
  final Box<String> calendarBox;

  CalendarHive({
    required this.calendarBox,
  });

  @override
  Future<CalendarModel?> getCalendar() async {
    final calendar = calendarBox.get("calendar");
    if (calendar == null) {
      return null;
    }
    return CalendarModel.fromJson(jsonDecode(calendar));
  }

  @override
  Future<void> saveCalendar(CalendarModel calendar) async {
    await calendarBox.put("calendar", jsonEncode(calendar.toJson()));
  }

  @override
  Future<void> deleteCalendar() async {
    await calendarBox.delete("calendar");
  }
}
