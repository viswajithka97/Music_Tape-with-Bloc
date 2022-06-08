part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable{
    SearchState();
  @override
  List<Object> get props => [];
}

class SearchBlocInitial extends SearchState {

   final List<Audio> fullSongs;

 SearchBlocInitial({required this.fullSongs});

  @override
  List<Audio> get props => fullSongs;
  


  }

