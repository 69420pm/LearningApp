// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'class_test.g.dart';

@HiveType(typeId:3)
class ClassTest extends Equatable {
  /// unique never changing id
  @HiveField(0)
  final String uid;

  /// possibly changing name
  @HiveField(1)
  String name;

  /// date of the classTest
  @HiveField(2)
  DateTime date;

  /// ids of folder which should get asked more frequently when date gets approached
  @HiveField(3)
  List<String> folderIds;
  ClassTest({
    required this.uid,
    required this.name,
    required this.date,
    required this.folderIds,
  });
  

  ClassTest copyWith({
    String? uid,
    String? name,
    DateTime? date,
    List<String>? folderIds,
  }) {
    return ClassTest(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      date: date ?? this.date,
      folderIds: folderIds ?? this.folderIds,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [uid, name, date, folderIds, folderIds.length];
}
