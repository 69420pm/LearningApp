import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:meta/meta.dart';

part 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewCubitState> {
  OverviewCubit(this.cardsRepository) : super(OverviewInitialState());

  final CardsRepository cardsRepository;

  void updateLearnAllButton() {
    emit(UpdateLearnAllButtonState());
  }
}
