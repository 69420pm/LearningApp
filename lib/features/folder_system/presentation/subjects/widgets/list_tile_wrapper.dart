// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/bloc/file_bloc.dart';

class ListTileWrapper extends StatelessWidget {
  String id;
  ListTileWrapper({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FileBloc>().subscribedStreams[id],
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.value is Folder)
            return Text("s");
          return Text("sd");
        });
  }
}
