import 'package:learning_app/features/calendar/data/models/time_span_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

class StreaksModel extends Streaks {
  StreaksModel() : super();

  StreaksModel.custom({required List<TimeSpanModel> streaks})
      : super.custom(streaks: streaks);

  factory StreaksModel.fromJson(Map<String, dynamic> json) {
    return StreaksModel.custom(
      streaks: (json['streaks'] as List)
          .map((e) => TimeSpanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'streaks': streaks.map((e) => e.toModel().toJson()).toList(),
    };
  }
}
