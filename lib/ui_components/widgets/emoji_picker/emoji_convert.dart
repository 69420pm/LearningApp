// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'package:learning_app/ui_components/widgets/emoji_picker/emoji.dart';
import 'package:learning_app/ui_components/widgets/emoji_picker/emojis.dart';

class EmojiConvert {
  EmojiConvert() {
    getEmojis();
  }

  final path =
      'packages/ui_components/lib/src/widgets/emoji_picker/emojis.json';

  static Future<List<Emoji>> getEmojis() async {
    // ignore: avoid_dynamic_calls
    final emojisDynamic = json
        .decode(EmojiJson.emojiJson)
        .map(
          (json) => Emoji(
            emoji: json['emoji'] as String,
            description: json['description'] as String,
            category: json['category'] as String,
            aliases: List<String>.from(json['aliases'] as List<dynamic>),
            tags: List<String>.from(json['tags'] as List<dynamic>),
            unicodeVersion: json['unicode_version'] as String,
            iosVersion: json['ios_version'] as String,
          ),
        )
        .toList() as List<dynamic>;

    return emojisDynamic.map((e) => e as Emoji).toList();
  }
}
