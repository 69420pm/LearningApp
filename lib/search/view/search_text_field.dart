import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_search_text_field.dart';class SearchTextField extends StatelessWidget {
  SearchTextField({
    super.key,
    this.searchSubject = false,
  });
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  final bool searchSubject;

  @override
  Widget build(BuildContext context) {
    return UISearchTextField(
      onChanged: (value) {
        if (value.trim().isEmpty) {
          context.read<SearchBloc>().resetState();
        } else {
          context.read<SearchBloc>().add(SearchRequest(value));
        }
      },
      hintText: 'search${searchSubject ? ' folder' : ''}',
      suffixIconPressed: () {
        context.read<SearchBloc>().resetState();
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 54,
  //     decoration: const BoxDecoration(
  //       color: UIColors.overlay,
  //       borderRadius:
  //           BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 4),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextFormField(
  //             focusNode: focusNode,
  //             controller: searchController,
  //             cursorColor: UIColors.smallText,
  //             style: UIText.labelBold,
  //             autofocus: true,
  //             onChanged: (value) {
  //               if (value.trim().isEmpty) {
  //                   context.read<SearchBloc>().resetState();

  //               } else {
  //                 context
  //                     .read<SearchBloc>()
  //                     .add(SearchRequest(searchController.text));
  //               }
  //             },
  //             // onFieldSubmitted: (p0) {
  //             //   context
  //             //       .read<SearchBloc>()
  //             //       .add(SearchRequest(searchController.text));
  //             // },
  //             decoration: InputDecoration(
  //               isDense: true,
  //               hintText: 'search${searchSubject ? ' folder' : ''}',
  //               contentPadding: const EdgeInsets.symmetric(vertical: 14),
  //               prefixIcon: UIIconButton(
  //                 icon: UIIcons.arrowBack
  //                     .copyWith(size: 30, color: UIColors.smallText),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               suffixIcon: UIIconButton(
  //                 icon: UIIcons.cancel
  //                     .copyWith(size: 24, color: UIColors.smallText),
  //                 onPressed: () {
  //                   searchController.clear();
  //                   context.read<SearchBloc>().resetState();
  //                   focusNode.requestFocus();
  //                 },
  //               ),
  //               border: InputBorder.none,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
