import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'favicon_event.dart';
part 'favicon_state.dart';

class FaviconBloc extends Bloc<FaviconEvent, FaviconState> {
  FaviconBloc() : super(FaviconInitial()) {
    on<FaviconChangeEvent>((event, emit) {
      emit(FaviconChange(iconData: event.iconData));
      emit(FaviconChanged());
    });
    on<FaviconChangedEvent>((event, emit) {
      emit(FaviconChanged());
      emit(FaviconChanged());
    });
    on<BottomNavigationChangeEvent>((event, emit) {
      emit(FaviconInitial(index: event.pageNo));
    });
  }
}
