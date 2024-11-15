import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _LearnViewMobile(),
    );
  }
}

class _LearnViewMobile extends StatelessWidget {
  const _LearnViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
