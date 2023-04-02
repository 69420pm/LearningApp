import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class SearchBar extends StatelessWidget {
  SearchBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO Search methode here
      onTap: onTap,
      child: Container(
        height: UISizeConstants.defaultSize * 6,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(
                Radius.circular(UISizeConstants.cornerRadius),),),
        child: Row(
          children: [
            const SizedBox(width: UISizeConstants.defaultSize * 2),
            const Icon(Icons.search),
            const SizedBox(width: UISizeConstants.defaultSize * 2),
            Text(
              'Search',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,),
            ),
          ],
        ),
      ),
    );
  }
}
