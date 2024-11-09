import 'package:flutter/material.dart';

/// A widget that provides a responsive layout for its child widgets.
///
/// This widget adjusts its layout based on the screen size, allowing for
/// different layouts on different screen sizes (mobile, desktop).
///
/// Either [mobile] or [desktop] must be provided, otherwise an exception is thrown.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.desktop,
  });

  final Widget? mobile;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (mobile == null && desktop == null) {
          throw Exception("At least one of mobile or desktop must be provided");
        }
        if (constraints.maxWidth < 600) {
          return mobile ?? _NotImplementedInfo(desktop!);
        } else {
          return desktop ?? _NotImplementedInfo(mobile!);
        }
      },
    );
  }
}

/// A widget that displays a banner indicating that the layout is not implemented.
class _NotImplementedInfo extends StatelessWidget {
  const _NotImplementedInfo(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: "Layout not implemented",
      location: BannerLocation.topStart,
      child: child,
    );
  }
}
