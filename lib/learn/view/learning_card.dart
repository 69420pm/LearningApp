import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class LearningCard extends StatelessWidget {
  const LearningCard({super.key, required this.card});

  final Card card;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LearnCubit, LearnState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              if (state is FrontState) {
                context.read<LearnCubit>().turnOverCard();
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.all(
                  Radius.circular(UIConstants.cornerRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.cardHorizontalPadding / 2,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: UIConstants.defaultSize * 3),
                    Text(
                      'HIER SOLLTE DIE VORDERSEITE DER KARTE STEHEN',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: UIConstants.defaultSize * 3),
                    if (state is BackState)
                      Expanded(
                        child: Scrollbar(
                          radius: const Radius.circular(10),
                          thickness: UIConstants.defaultSize / 2,
                          interactive: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: UIConstants.cardHorizontalPadding / 2,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                'HIER SOLLTE RÜCKSEITE DER KARTE STEHEN Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron. Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron. Das Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den ThronDas Jahr 69 nach unserer Zeitrechnung (DCCCXXII nach dem römischen Kalender ab urbe condita) geht als das erste Vierkaiserjahr in die Geschichte des Römischen Reichs ein. In kurzen Abständen folgen einander Galba, Otho und schließlich Vitellius auf den Kaiserthron. Erst relativ spät im Jahr greift ein weiterer Thronaspirant in den Bürgerkrieg ein: Vespasian, der von den Legionen der östlichen Provinzen Judäa und Ägypten auf den Schild gehoben wird, besiegt Vitellius und seine Rheinlegion in der Zweiten Schlacht von Bedriacum entscheidend und besteigt somit als erster Kaiser aus der Dynastie der Flavier den Thron',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: UIConstants.defaultSize * 3),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
