import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: UISizeConstants.defaultSize * 6,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius))),
      child: TextFormField(
        
      )
    );
  }
}
