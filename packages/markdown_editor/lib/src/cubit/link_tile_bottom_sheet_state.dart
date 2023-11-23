part of 'link_tile_bottom_sheet_cubit.dart';

@immutable
sealed class LinkTileBottomSheetState {}

final class LinkTileBottomSheetInitial extends LinkTileBottomSheetState {}

class LinkTileBottomSheetLoading extends LinkTileBottomSheetState{}

class LinkTileBottomSheetSuccess extends LinkTileBottomSheetState{}

class LinkTileBottomSheetNothingFound extends LinkTileBottomSheetState{}

