import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/search_text_field.dart';
import 'package:ui_components/ui_components.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIPage(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: UIConstants.itemPadding),
        SearchTextField(),
        SizedBox(
          height: UIConstants.itemPadding*1.5,
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchSuccess) {
              return _CardsSearchResults(foundCards: state.foundCards);
            } else if (state is SearchInitial) {
              return const Text('use search bar below');
            } else if (state is SearchNothingFound) {
              return _CardsSearchResults(foundCards: List.empty());
            }
            return const Text('loading');
          },
        )
      ],
    ));
  }
}

class _CardsSearchResults extends StatelessWidget {
  _CardsSearchResults({super.key, required this.foundCards});
  List<Widget> foundCards;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UILabelRow(
          labelText: "Cards",
          actionWidgets: [
            Text(foundCards.length.toString(),
                style: UIText.label.copyWith(color: UIColors.smallText))
          ],
        ),
        SizedBox(
          height: UIConstants.itemPadding*1.5,
        ),
        Column(
          children: foundCards,
        )
      ],
    );
  }
}
