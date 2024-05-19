class StreamEvent<T> {
  final String id;
  final T value;
  final bool deleted;

  StreamEvent({required this.id, required this.value, required this.deleted});
}

class StreamListEvent<T> {
  final String parentId;
  final List<T> changedValues;
  final List<T> initialValues;
  final bool deleted;

  StreamListEvent(
      {required this.parentId,
      required this.changedValues,
      required this.initialValues,
      required this.deleted});
}
