part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable{
    List<Object> get props => [];
}
class SerachInputEvent extends SearchEvent {
  final String search;

   SerachInputEvent({required this.search});
  @override
  List<Object> get props => [search];
}
