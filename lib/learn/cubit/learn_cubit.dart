import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnState> {
  LearnCubit() : super(FrontState());

  void turnOverCard() {
    emit(BackState());
  }

  void newCard(int raitingLastCard) {
    emit(FrontState());
  }
}
