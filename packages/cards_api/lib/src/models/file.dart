// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class File {
  /// unique never changing id
  final String uid;
  // a list of all parent strings in order from closest to most far away parent
  final List<String> parents;


  const File({
    required this.uid,
    required this.parents,
  });
}
