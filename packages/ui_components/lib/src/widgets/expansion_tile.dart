// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  Text title;
  double titleSpacing;
  double iconSpacing;
  Widget trailing;
  Color backgroundColor;
  Border border;

  UIExpansionTile({
    super.key,
    required this.children,
    required this.title,
    required this.titleSpacing,
    required this.iconSpacing,
    required this.trailing,
    required this.backgroundColor,
    required this.border,
  });

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isOpened = false;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: _key,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
        color: widget.backgroundColor,
        border: widget.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                const SizedBox(width: UIConstants.defaultSize),
                GestureDetector(
                  onTap: update,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) {
                      return Transform.rotate(
                        angle: pi * _animation.value / 2 - pi / 2,
                        child: UIIcons.expandMore,
                      );
                    },
                  ),
                ),
                SizedBox(width: widget.titleSpacing),
                widget.title,
                const Spacer(),
                widget.trailing,
                const SizedBox(width: UIConstants.defaultSize),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => widget.children[index],
              itemCount: widget.children.length,
            ),
          ),
        ],
      ),
    );
  }

  void update() {
    setState(() {
      _isOpened = !_isOpened;
    });
    if (_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
