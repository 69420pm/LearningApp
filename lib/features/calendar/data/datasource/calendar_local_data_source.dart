import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';

abstract class CalendarLocalDataSource {
  Future<StreaksModel> getStreaks();
  Future<void> saveStreaks(StreaksModel streaks);
  Stream<StreaksModel?> watchStreaks();

  Future<void> deleteStreaks();
}

class CalendarHive implements CalendarLocalDataSource {
  final Box<String> streaksBox;

  CalendarHive({
    required this.streaksBox,
  });

  @override
  Future<StreaksModel> getStreaks() async {
    final streaks = streaksBox.get("streaks");
    if (streaks == null) {
      return StreaksModel();
    }
    return StreaksModel.fromJson(jsonDecode(streaks));
  }

  @override
  Future<void> saveStreaks(StreaksModel streaks) async {
    await streaksBox.put("streaks", jsonEncode(streaks.toJson()));
  }

  @override
  Stream<StreaksModel?> watchStreaks() {
    return streaksBox.watch(key: "streaks").map((event) {
      if (event.value == null) {
        return null;
      }
      return StreaksModel.fromJson(jsonDecode(event.value!));
    });
  }

  @override
  Future<void> deleteStreaks() async {
    await streaksBox.delete("streaks");
  }
}
