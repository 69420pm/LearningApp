// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

abstract class EditorTileDC extends Equatable {
  /// unique never changing id
  final String uid;
  const EditorTileDC({
    required this.uid,
  });
}
