import 'package:flutter/material.dart';
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
          child: UITextFormField(
            controller: searchController,
            validation: (p0) {},
            hintText: "Search",
            onFieldSubmitted: (p0) => print("submit"),
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
