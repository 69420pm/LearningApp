import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/generated/l10n.dart';

class StreakTile extends StatelessWidget {
  const StreakTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //get from database
    const streak = 420;

    return UICard(
      useGradient: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              streak.toString(),
              style: UIText.titleBig.copyWith(color: UIColors.textDark),
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: UIConstants.defaultSize),
            Text(
              S.of(context).dayStreak,
              style: UIText.label.copyWith(
                color: UIColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
