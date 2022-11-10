import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Overview"),
        ),
        floatingActionButton: Column(
          children: [
            SizedBox(
              height: 200,
            ),

            /// Add card FAB
            FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: 'card',
              onPressed: () => Navigator.of(context).pushNamed('/add_card'),
            ),

            /// Add subject FAB
            FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: 'subject',
              onPressed: () => Navigator.of(context).pushNamed('/add_subject'),
            ),
          ],
        ),
        body: Text("text alla"));
  }
}
