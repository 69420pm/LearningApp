import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/card_list_tile_search.dart';
import 'package:learning_app/search/view/folder_list_tile_search.dart';
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
          const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchSuccess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CardsSearchResults(
                      foundCards: context.read<SearchBloc>().cardSearchResults,
                      searchRequest: state.searchRequest,
                    ),
                    _SubjectsSearchResults(
                        foundSubjects:
                            context.read<SearchBloc>().subjectSearchResults),
                    _FolderSearchResults(
                      foundFolders:
                          context.read<SearchBloc>().folderSearchResults,
                      searchRequest: state.searchRequest,
                    ),
                  ],
                );
              } else if (state is SearchNothingFound) {
                return Center(
                  child: Text('Nothing found',
                      style: UIText.label.copyWith(color: UIColors.smallText)),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class _CardsSearchResults extends StatelessWidget {
  _CardsSearchResults({
    super.key,
    required this.foundCards,
    this.searchRequest,
  }) {
    if (foundCards.isNotEmpty) {
      var i = 0;
      for (final result in foundCards) {
        widgetCards.add(
          CardListTileSearch(
            card: result.searchedObject as Card,
            searchRequest: searchRequest!,
            parentObjects: result.parentObjects,
          ),
        );
        if (i < foundCards.length - 1) {
          widgetCards.add(const SizedBox(height: UIConstants.itemPadding));
        }
        i++;
      }
    }
  }
  final List<SearchResult> foundCards;
  List<Widget> widgetCards = List.empty(growable: true);
  String? searchRequest;

  @override
  Widget build(BuildContext context) {
    if (foundCards.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Cards',
            actionWidgets: [
              Text(
                '${foundCards.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              )
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ),
          Column(
            children: widgetCards,
          ),
          const SizedBox(height: UIConstants.itemPadding * 3),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _SubjectsSearchResults extends StatelessWidget {
  _SubjectsSearchResults({super.key, required this.foundSubjects}) {
    if (foundSubjects.isNotEmpty) {
      int i = 0;
      for (final element in foundSubjects!) {
        subjectTiles.add(SubjectListTile(subject: element));
        if (i < foundSubjects.length - 1) {
          subjectTiles.add(const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ));
        } else {
          subjectTiles.add(const SizedBox(
            height: UIConstants.itemPadding * 0.5,
          ));
        }
        i++;
      }
    }
  }
  List<Subject> foundSubjects;
  List<Widget> subjectTiles = [
    const SizedBox(
      height: UIConstants.itemPadding * 0.5,
    )
  ];

  @override
  Widget build(BuildContext context) {
    if (foundSubjects.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Subjects',
            actionWidgets: [
              Text(
                '${foundSubjects.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              )
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ),
          Column(
            children: subjectTiles,
          ),
          const SizedBox(height: UIConstants.itemPadding * 3),
        ],
      );
    } else {
      return Container(height: 0);
    }
  }
}

class _FolderSearchResults extends StatelessWidget {
  _FolderSearchResults({
    super.key,
    required this.foundFolders,
    this.searchRequest,
  }) {
    if (foundFolders.isNotEmpty) {
      var i = 0;
      for (final result in foundFolders) {
        widgetFolders.add(
          FolderListTileSearch(
            folder: result.searchedObject as Folder,
            searchRequest: searchRequest!,
            parentObjects: result.parentObjects,
          ),
        );
        if (i < foundFolders.length - 1) {
          widgetFolders.add(const SizedBox(height: UIConstants.itemPadding));
        }
        i++;
      }
    }
  }
  final List<SearchResult> foundFolders;
  List<Widget> widgetFolders = List.empty(growable: true);
  String? searchRequest;

  @override
  Widget build(BuildContext context) {
    if (foundFolders.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Folder',
            actionWidgets: [
              Text(
                '${foundFolders.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              )
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ),
          Column(
            children: widgetFolders,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
