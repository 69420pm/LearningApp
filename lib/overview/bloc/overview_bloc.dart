import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc(this.cardsRepository) : super(OverviewInitial()) {
    // on<OverviewSubjectSubscriptionRequested>((event, emit) async {
    //   await _onSubjectSubscriptionRequested(event, emit);
    // });
  }

  final CardsRepository cardsRepository;

  // Future<void> _onSubjectSubscriptionRequested(
  //   OverviewSubjectSubscriptionRequested event,
  //   Emitter<OverviewState> emit,
  // ) async {
  //   emit(OverviewLoading());
  //   await emit.forEach<List<Subject>>(cardsRepository.getSubjects(),
  //       onData: (subjects) {
  //         return OverviewSuccess(subjects: subjects);
  //       },
  //       onError: (_, __) => OverviewFailure(errorMessage: 'Subject loading failed'),);
  // }
}
