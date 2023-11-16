/// when an editor tile should be interactable in read only mode, 
/// e.g. play audio of audio tile or show image
abstract class ReadOnlyInteractable {
  bool interactable;
  ReadOnlyInteractable({
    required this.interactable,
  });
}
