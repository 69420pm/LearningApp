// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/emoji_picker/emoji.dart';
import 'package:learning_app/ui_components/widgets/emoji_picker/emoji_convert.dart';
import 'package:learning_app/ui_components/widgets/text_form_field.dart';

class UIEmojiPicker extends StatefulWidget {
  const UIEmojiPicker({
    super.key,
    required this.onEmojiClicked,
  });

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
  bool isInSearch = false;
  final searchTextEditingController = TextEditingController();

  @override
  void initState() {
    getEmojis();
    super.initState();
  }

  Future<void> getEmojis() async {
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
            if (!isLoaded && !isInSearch) {
              return const SizedBox();
            } else if (isLoaded && !isInSearch) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          labelStyle: const TextStyle(fontSize: 22),
                          tabs: List.generate(
                            categories.length,
                            (index) => Tab(
                              child: Text(
                                emojis.firstWhere(
                                      (element) =>
                                          element.category == categories[index],
                                    ).emoji,
                              ),
                            ),
                          ),
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                      ),
                      const SizedBox(width: UIConstants.defaultSize),
                      IconButton(
                          onPressed: () => setState(() => isInSearch = true),
                          icon: const Icon(Icons.search),),
                    ],
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
                              .where(
                                (element) =>
                                    element.category == categories[index],
                              )
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    widget.onEmojiClicked(e);
                                  },
                                  child: Text(
                                    e.emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ),
                  ),
                ],
              );
            } else {
              const maxLengthOfSearch = 100;
              var searchEmojisList = emojis.where(
                (element) {
                  if (element.description
                      .contains(searchTextEditingController.text)) {
                    return true;
                  }
                  for (final element in element.tags) {
                    if (element.contains(searchTextEditingController.text)) {
                      return true;
                    }
                  }
                  return false;
                },
              ).toList();

              if (searchEmojisList.length > maxLengthOfSearch) {
                searchEmojisList =
                    searchEmojisList.sublist(0, maxLengthOfSearch);
              }

              return Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() {
                          isInSearch = false;
                        }),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: UITextFormField(
                          onChanged: (p0) => setState(() {}),
                          controller: searchTextEditingController,
                          validation: (value) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 10,
                    crossAxisSpacing: UIConstants.defaultSize / 2,
                    mainAxisSpacing: UIConstants.defaultSize / 2,
                    children: searchEmojisList
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              widget.onEmojiClicked(e);
                            },
                            child: Text(
                              e.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
