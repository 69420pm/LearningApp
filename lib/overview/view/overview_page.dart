import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';

/// Overview page for cards, learn all button, FAB etc.
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeCubit())],
      child: const OverviewView(),
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        children: [
          SizedBox(height: 200,),
          /// Add card FAB
          FloatingActionButton(
            heroTag: 'card',
            onPressed: () => Navigator.of(context).pushNamed('/add_card'),
          ),
          /// Add subject FAB
          FloatingActionButton(
            heroTag: 'subject',
            onPressed: () => Navigator.of(context).pushNamed('/add_subject'),
          ),
          /// Add group FAB
          FloatingActionButton(
            heroTag: 'group',
            onPressed: () => Navigator.of(context).pushNamed('/add_group'),
          ),
        ],
      ),
      body: Text("hey guys")
    );
  }
}
