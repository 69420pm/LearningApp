import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:ui_components/ui_components.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({
    super.key,
  });
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: UIColors.overlay,
        borderRadius:
            BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: searchController,
              cursorColor: UIColors.smallText,
              style: UIText.labelBold,
              autofocus: true,
              onFieldSubmitted: (p0) => context
                  .read<SearchBloc>()
                  .add(SearchRequest(searchController.text)),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'search',
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: UIIconButton(
                  icon: UIIcons.arrowBack
                      .copyWith(size: 30, color: UIColors.smallText),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                suffixIcon: UIIconButton(
                  icon: UIIcons.cancel
                      .copyWith(size: 24, color: UIColors.smallText),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
