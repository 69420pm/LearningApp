// ignore_for_file: public_member_api_docs

class Emoji {
  Emoji({
    required this.emoji,
    required this.description,
    required this.category,
    required this.aliases,
    required this.tags,
    required this.unicodeVersion,
    required this.iosVersion,
  });

  final String emoji;
  final String description;
  final String category;
  final List<String> aliases;
  final List<String> tags;
  final String unicodeVersion;
  final String iosVersion;
}
