import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:ui_components/ui_components.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: BlocBuilder<LearnCubit, LearnState>(
      builder: (context, state) {
        return GestureDetector(
            onTap: () {
              if (state is FrontState)
                context.read<LearnCubit>().turnOverCard();
            },
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(UISizeConstants.cornerRadius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UISizeConstants.paddingEdge / 2,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: UISizeConstants.defaultSize * 3),
                        Text("Was ist die beste Zahl?",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontWeight: FontWeight.bold)),
                        SizedBox(height: UISizeConstants.defaultSize * 3),
                        if (state is BackState)
                          Expanded(
                            child: Scrollbar(
                              radius: Radius.circular(10),
                              thickness: UISizeConstants.defaultSize / 2,
                              interactive: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: UISizeConstants.paddingEdge / 2,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                      "Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron. Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron. Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den ThronDas Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant)),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: UISizeConstants.defaultSize * 3),
                      ]),
                )));
      },
    ));
  }
}
