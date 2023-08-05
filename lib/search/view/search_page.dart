import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:ui_components/ui_components.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalPadding),
        child: SafeArea(
          child: Column(
            children: [
              UITextFormField(
                autofocus: true,
                controller: searchController,
                initialValue: context.read<SearchBloc>().lastSearch,
                validation: (p0) {
                  return null;
                },
                hintText: 'Search',
                onFieldSubmitted: (p0) => context
                    .read<SearchBloc>()
                    .add(SearchRequest(searchController.text)),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              //UIEmojiPicker(),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchSuccess) {
                    print(state.foundCards);
                    return SizedBox(
                      height: 100,
                      child: Column(children: state.foundCards),
                    );
                  } else if (state is SearchInitial) {
                    return const Text('use search bar below');
                  } else if (state is SearchNothingFound) {
                    return const Text('nothing found');
                  }
                  return const Text('loading');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
