import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_components/ui_components.dart';

class UIAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UIAppBar(
      {Key? key,
      this.title,
      this.automaticallyImplyLeading = true,
      this.actions,
      this.leading,
      this.bottom})
      : super(key: key);
  final String? title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: UIConstants.cardHorizontalPadding),
        child: leading,
      ),
      elevation: 0,
      leadingWidth: 0,
      titleSpacing: 0,
      backgroundColor: UIColors.background,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: UIColors.background,
          statusBarBrightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarContrastEnforced: true,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor: UIColors.background,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      title: Text(
        title ?? "",
        style: UIText.labelBold.copyWith(color: UIColors.textLight),
      ),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: UIConstants.cardHorizontalPadding),
            ]
          : actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
