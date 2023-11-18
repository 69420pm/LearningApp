import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/cards_search_results.dart';
import 'package:learning_app/search/view/folder_search_results.dart';
import 'package:learning_app/search/view/search_text_field.dart';
import 'package:learning_app/search/view/subject_search_results.dart';
import 'package:ui_components/ui_components.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.searchId});
  /// parent id to search e.g. within subjects or folders
  final String? searchId;

  @override
  Widget build(BuildContext context) {
    context.read<SearchBloc>().resetState();
    context.read<SearchBloc>().searchId = searchId;
    return UIPage(
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        shrinkWrap: true,
        children: [
          SearchTextField(searchSubject: searchId!=null,),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchSuccess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardsSearchResults(
                      foundCards: context.read<SearchBloc>().cardSearchResults,
                      searchRequest: state.searchRequest,
                    ),
                    SubjectsSearchResults(
                      foundSubjects:
                          context.read<SearchBloc>().subjectSearchResults,
                    ),
                    FolderSearchResults(
                      foundFolders:
                          context.read<SearchBloc>().folderSearchResults,
                      searchRequest: state.searchRequest,
                    ),
                  ],
                );
              } else if (state is SearchNothingFound) {
                return Center(
                  child: Text(
                    'Nothing found',
                    style: UIText.label.copyWith(color: UIColors.smallText),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
