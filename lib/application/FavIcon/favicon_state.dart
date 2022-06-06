part of 'favicon_bloc.dart';

@immutable
abstract class FaviconState {
    FaviconState();

}
class FaviconInitial extends FaviconState{
  
}

class FaviconChange extends FaviconState {
  final IconData iconData;

  FaviconChange({required this.iconData});
}

class FaviconChanged extends FaviconState {
  FaviconChanged();
}
