// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';

part 'subject.g.dart';

@HiveType(typeId:0)
class Subject extends Equatable {
  /// unique never changing id
  @HiveField(0)
  final String uid;

  /// possibly changing name
  @HiveField(1)
  String name;

  /// to String formatted creation date
  @HiveField(2)
  final DateTime dateCreated;

  /// prefix icon
  @HiveField(3)
  int icon;

  /// days on which subject is scheduled
  @HiveField(4)
  List<bool> scheduledDays;

  /// class tests
  @HiveField(5)
  List<ClassTest> classTests;

  /// whether the subject should get considered for streak
  @HiveField(6)
  bool streakRelevant;

  /// whether this subject is disabled
  @HiveField(7)
  bool disabled;
  
  Subject({
    required this.uid,
    required this.name,
    required this.dateCreated,
    required this.icon,
    required this.scheduledDays,
    required this.classTests,
    required this.streakRelevant,
    required this.disabled,
  });

 
 

//   Subject copyWith({
//     String? id,
//     String? name,
//     String? dateCreated,
//     String? prefixIcon,
//     List<bool>? daysToGetNotified,
//     List<ClassTest>? classTests,
//     bool? streakRelevant,
//     bool? disabled,
//   }) {
//     return Subject(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       dateCreated: dateCreated ?? this.dateCreated,
//       prefixIcon: prefixIcon ?? this.prefixIcon,
//       daysToGetNotified: daysToGetNotified ?? this.daysToGetNotified,
//       classTests: classTests ?? this.classTests,
//       streakRelevant: streakRelevant ?? this.streakRelevant,
//       disabled: disabled ?? this.disabled,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'dateCreated': dateCreated,
//       'prefixIcon': prefixIcon,
//       'daysToGetNotified': daysToGetNotified,
//       'classTests': classTests.map((x) => x.toMap()).toList(),
//       'streakRelevant': streakRelevant,
//       'disabled': disabled,
//     };
//   }

//   factory Subject.fromMap(Map<String, dynamic> map) {
//   return Subject(
//     id: map['id'] as String,
//     name: map['name'] as String,
//     dateCreated: map['dateCreated'] as String,
//     prefixIcon: map['prefixIcon'] as String,
//     daysToGetNotified: List<bool>.from(map['daysToGetNotified'] as List<dynamic>),
//     classTests: (map["classTests"] as List<dynamic>).map((e) => ClassTest.fromMap(e as Map<String,dynamic>)).toList(),

//     streakRelevant: map['streakRelevant'] as bool,
//     disabled: map['disabled'] as bool,
//   );
// }

//   String toJson() => json.encode(toMap());

//   factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   bool get stringify => true;

//   @override
//   List<Object> get props {
//     return [
//       id,
//       name,
//       dateCreated,
//       prefixIcon,
//       daysToGetNotified,
//       classTests,
//       streakRelevant,
//       disabled,
//     ];
//   }

  Subject copyWith({
    String? uid,
    String? name,
    DateTime? dateCreated,
    int? icon,
    List<bool>? scheduledDays,
    List<ClassTest>? classTests,
    bool? streakRelevant,
    bool? disabled,
  }) {
    return Subject(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      icon: icon ?? this.icon,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      classTests: classTests ?? this.classTests,
      streakRelevant: streakRelevant ?? this.streakRelevant,
      disabled: disabled ?? this.disabled,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'uid': uid,
  //     'name': name,
  //     'dateCreated': dateCreated,
  //     'icon': icon,
  //     'scheduledDays': scheduledDays,
  //     'classTests': classTests.map((x) => x.toMap()).toList(),
  //     'streakRelevant': streakRelevant,
  //     'disabled': disabled,
  //   };
  // }

  // factory Subject.fromMap(Map<String, dynamic> map) {
  //   return Subject(
  //     uid: map['uid'] as String,
  //     name: map['name'] as String,
  //     dateCreated: map['dateCreated'] as String,
  //     icon: map['icon'] as int,
  //     scheduledDays: List<bool>.from((map['scheduledDays'] as List<bool>),
  //     classTests: List<ClassTest>.from((map['classTests'] as List<int>).map<ClassTest>((x) => ClassTest.fromMap(x as Map<String,dynamic>),),),
  //     streakRelevant: map['streakRelevant'] as bool,
  //     disabled: map['disabled'] as bool,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      uid,
      name,
      dateCreated,
      icon,
      scheduledDays,
      classTests,
      streakRelevant,
      disabled,
    ];
  }
}
