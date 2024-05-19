import 'package:uuid/uuid.dart';

class Uid {
  static String uid() {
    const uuid = Uuid();
    return uuid.v5(null, null) + DateTime.now().toIso8601String();
  }
}
