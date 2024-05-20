// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/bloc/file_bloc.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/widgets/card_list_tile.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/widgets/folder_list_tile.dart';

/// wraps Folder and Card list tiles and updates them listening, to their
/// watch stream accordingly
class ListTileWrapper extends StatelessWidget {
  final String id;
  const ListTileWrapper({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FileBloc>().subscribedStreams[id],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data!.deleted && snapshot.data!.value is Folder) {
              return FolderListTile(
                folder: snapshot.data!.value as Folder,
              );
            } else if (!snapshot.data!.deleted &&
                snapshot.data!.value is Card) {
              return CardListTile(
                card: snapshot.data!.value as Card,
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
