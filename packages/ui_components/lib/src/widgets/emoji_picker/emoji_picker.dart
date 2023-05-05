import 'package:flutter/material.dart';
import 'package:ui_components/src/widgets/emoji_picker/emoji.dart';
import 'package:ui_components/src/widgets/emoji_picker/emoji_convert.dart';
import 'package:ui_components/ui_components.dart';

class UIEmojiPicker extends StatefulWidget {
  UIEmojiPicker({super.key, required this.onEmojiClicked});

  final void Function(Emoji) onEmojiClicked;

  @override
  State<UIEmojiPicker> createState() => _UIEmojiPickerState();
}

class _UIEmojiPickerState extends State<UIEmojiPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Emoji> emojis = List.empty(growable: true);
  List<String> categories = List.empty(growable: true);
  bool isLoaded = false;

  @override
  void initState() {
    getEmojies();
    super.initState();
  }

  getEmojies() async {
    emojis = await EmojiConvert.getEmojis();
    for (final e in emojis) {
      if (!categories.contains(e.category)) {
        categories.add(e.category);
      }
    }
    setState(() {
      _tabController = TabController(length: categories.length, vsync: this);
      isLoaded = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
        child: SizedBox(
      height: UIConstants.defaultSize * 40,
      child: Builder(
        builder: (context) {
          if (!isLoaded) {
            return const SizedBox();
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  automaticIndicatorColorAdjustment: true,
                  labelStyle: TextStyle(fontSize: 22),
                  tabs: List.generate(
                    categories.length,
                    (index) => Tab(
                      child: Text(emojis
                              .firstWhere((element) =>
                                  element.category == categories[index])
                              .emoji +
                          " "),
                    ),
                  ),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                const SizedBox(height: UIConstants.defaultSize),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(categories.length, (index) {
                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 10,
                        crossAxisSpacing: UIConstants.defaultSize / 2,
                        mainAxisSpacing: UIConstants.defaultSize / 2,
                        children: emojis
                            .where((element) =>
                                element.category == categories[index])
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    widget.onEmojiClicked(e);
                                  },
                                  child: Text(
                                    e.emoji,
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ))
                            .toList(),
                      );
                    }),
                  ),
                ),
              ],
            );
          }
        },
      ),
    ));
  }
}
