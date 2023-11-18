import 'package:uuid/uuid.dart';

class Uid {
  String uid() {
    return const Uuid().v4().replaceAll('/', '_').substring(0, 10) +
        DateTime.now().toString();
  }

  String uidNoSpecialCharacters() {
    return const Uuid()
            .v4()
            .replaceAll('/', '')
            .replaceAll(':', '')
            .replaceAll('-', '')
            .replaceAll('.', '')
            .replaceAll(' ', '')
            .substring(0, 10) +
        DateTime.now()
            .toString()
            .replaceAll('/', '')
            .replaceAll(':', '')
            .replaceAll('-', '')
            .replaceAll('.', '')
            .replaceAll(' ', '');
  }
}
