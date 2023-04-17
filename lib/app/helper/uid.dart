import 'package:uuid/uuid.dart';

class Uid {
String uid() {
  print(DateTime.now().toString());
    return const Uuid().v4().replaceAll('/', '_').substring(0, 10) +
        DateTime.now().toString();
  }
}
