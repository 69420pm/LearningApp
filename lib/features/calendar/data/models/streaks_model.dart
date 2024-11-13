import 'package:learning_app/features/calendar/data/models/streak_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

class StreaksModel extends Streaks {
  StreaksModel() : super();

  StreaksModel.custom({required List<StreakModel> streaks})
      : super.custom(streaks: streaks);

  factory StreaksModel.fromJson(Map<String, dynamic> json) {
    return StreaksModel.custom(
      streaks: (json['streaks'] as List)
          .map((e) => StreakModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'streaks': streaks.map((e) => e.toJson()).toList(),
    };
  }
}
