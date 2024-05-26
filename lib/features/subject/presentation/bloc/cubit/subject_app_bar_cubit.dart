import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subject_app_bar_state.dart';

class SubjectAppBarCubit extends Cubit<SubjectAppBarState> {
  SubjectAppBarCubit() : super(SubjectAppBarNothingSelected());
}
