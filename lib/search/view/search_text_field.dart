import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        height: UIConstants.defaultSize * 6,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius:
                const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),),
        child: TextFormField(),);
  }
}
