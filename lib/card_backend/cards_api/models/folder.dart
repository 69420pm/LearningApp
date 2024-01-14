// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/card_backend/cards_api/models/file.dart';

part 'folder.g.dart';

@HiveType(typeId:1)
class Folder extends File implements Equatable {
  /// unique never changing id
  @HiveField(0)
  @override
  final String uid;

  /// possibly changing name
  @HiveField(1)
  final String name;

  /// to String formatted creation date
  @HiveField(2)
  final DateTime dateCreated;

  Folder({
    required this.uid,
    required this.name,
    required this.dateCreated,
  }) : super(uid: uid);

  Folder copyWith({
    String? uid,
    String? name,
    DateTime? dateCreated,
  }) {
    return Folder(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }


  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [uid, name, dateCreated];
  }
}
