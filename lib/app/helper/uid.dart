import 'package:uuid/uuid.dart';

class Uid {
String uid() {
    return const Uuid().v4().replaceAll('/', '_').substring(0, 10) +
        DateTime.now().toIso8601String();
  }
}
