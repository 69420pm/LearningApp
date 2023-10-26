// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

abstract class EditorTileDC extends Equatable {
  /// unique never changing id
  final String id;
  const EditorTileDC({
    required this.id,
  });

  @override
  String toString() => 'EditorTileDC(id: $id)';
}
