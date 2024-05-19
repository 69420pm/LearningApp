import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app_clone/features/home/presentation/bloc/home_bloc.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subjectId});
  final String subjectId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        context.namedLocation(
          'subject',
          pathParameters: <String, String>{'subjectId': subjectId},
        ),
      ),
      child: SizedBox(
        height: 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: context.read<HomeBloc>().subscribedStreams[subjectId],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data!.deleted) {
                    return Text(
                      snapshot.data!.value!.name,
                    );
                  }
                  return const Text("deleted");
                } else {
                  return const Text('error');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
