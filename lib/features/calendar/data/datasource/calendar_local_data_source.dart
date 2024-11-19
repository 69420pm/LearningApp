import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/injection_container.dart';

abstract class CalendarLocalDataSource {
  Future<CalendarModel> getCalendar();
  Future<void> saveCalendar(CalendarModel calendar);
  Future<void> deleteCalendar();
}

class CalendarFireStore implements CalendarLocalDataSource {
  final db = FirebaseFirestore.instance;
  @override
  Future<void> deleteCalendar() {
    // TODO: implement deleteCalendar
    throw UnimplementedError();
  }

  @override
  Future<CalendarModel> getCalendar() async {
    await db
        .collection("calendar")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()?.isNotEmpty ?? false) {
        print(value.data());
        return CalendarModel.fromJson(value.data()!);
      }
    });
    return CalendarModel();
  }

  @override
  Future<void> saveCalendar(CalendarModel calendar) async {
    await db
        .collection("calendar")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(calendar.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }
}

class CalendarHive implements CalendarLocalDataSource {
  final Box<String> calendarBox;

  CalendarHive({
    required this.calendarBox,
  });

  @override
  Future<CalendarModel> getCalendar() async {
    final calendar = calendarBox.get("calendar");
    if (calendar == null) {
      return CalendarModel();
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
