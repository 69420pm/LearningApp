import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/search_text_field.dart';
import 'package:ui_components/ui_components.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UISizeConstants.paddingEdge),
        child: SafeArea(
          child: Column(
            children: [
              UITextFormField(
                autofocus: true,
                controller: searchController,
                validation: (p0) {},
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
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchSuccess) {
                    print(state.foundCards);
                    return SizedBox(
                      height: 100,
                      child: Column(children: state.foundCards),
                    );
                  }
                  return Text("loading");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
