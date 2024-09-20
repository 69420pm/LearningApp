// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/core/id/uid.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/features/file_system/domain/entities/card.dart';
import 'package:learning_app/features/file_system/domain/entities/file.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_file.dart';
import 'package:learning_app/injection_container.dart';

class MultiDragIndicator extends StatefulWidget {
  const MultiDragIndicator({
    super.key,
    required this.fileUIDs,
  });

  final List<String> fileUIDs;

  @override
  State<MultiDragIndicator> createState() => _MultiDragIndicatorState();
}

class _MultiDragIndicatorState extends State<MultiDragIndicator> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
        border:
            Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            AmountIndicator(amount: widget.fileUIDs.length),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.itemPaddingLarge,
                vertical: UIConstants.defaultSize,
              ),
              child: SizedBox(
                width: UIConstants.defaultSize * 10,
                child: DefaultTextStyle(
                  style: UIText.normal,
                  child: Text(
                    widget.fileUIDs.first,
                    overflow: TextOverflow.ellipsis,
                    style: UIText.label,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountIndicator extends StatelessWidget {
  const AmountIndicator({
    super.key,
    required this.amount,
    this.icon,
  });

  final int amount;
  final UIIcon? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: amount > 0
          ? [
              if (amount > 1)
                DefaultTextStyle(
                  //* or else yellow lines below text
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Text(
                    amount.toString(),
                    style: UIText.label,
                  ),
                ),
              if (amount > 1)
                const SizedBox(width: UIConstants.itemPaddingSmall),
              if (icon != null) icon!,
            ]
          : [],
    );
  }
}
