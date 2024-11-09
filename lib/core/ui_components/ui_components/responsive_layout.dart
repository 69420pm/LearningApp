import 'package:flutter/material.dart';

/// A widget that provides a responsive layout for its child widgets.
///
/// This widget adjusts its layout based on the screen size, allowing for
/// different layouts on different screen sizes (mobile, desktop).
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  final Widget? mobile;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return mobile ?? Text("Mobile not implemeted yet");
        } else {
          return desktop ?? Text("Desktop not implemeted yet");
        }
      },
    );
  }
}
