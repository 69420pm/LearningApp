import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIIcons.debug.copyWith(size: 140),
            const SizedBox(height: UIConstants.itemPaddingLarge * 3),
            Text('Learning App',
                style: UIText.titleBig.copyWith(color: UIColors.textLight)),
            const Spacer(),
            UICardButton(
              onPressed: () {
                context.go("${AppRouter.landingPath}/${AppRouter.loginPath}");
              },
              color: UIColors.primary,
              text: Text(
                'Login',
                style: UIText.labelBold.copyWith(color: UIColors.textDark),
              ),
            ),
            const SizedBox(height: UIConstants.itemPaddingLarge),
            UICardButton(
              onPressed: () {
                context
                    .go("${AppRouter.landingPath}/${AppRouter.registerPath}");
              },
              color: UIColors.primary,
              text: Text(
                'Register',
                style: UIText.labelBold.copyWith(color: UIColors.textLight),
              ),
              hollow: true,
            ),
            const SizedBox(height: UIConstants.itemPadding * 5),
          ],
        ),
      ),
    ));
  }
}
