import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.onTap,
  });
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO Search methode here
      onTap: onTap,
      child: Container(
        height: UIConstants.defaultSize * 6,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: UIConstants.defaultSize * 2),
            const Icon(Icons.search),
            const SizedBox(width: UIConstants.defaultSize * 2),
            Text(
              'Search',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
