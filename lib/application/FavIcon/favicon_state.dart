part of 'favicon_bloc.dart';

@immutable
 class FaviconState {
    FaviconState();

}
class FaviconInitial extends FaviconState{
  int index;
  FaviconInitial({this.index=0});
}

class FaviconChange extends FaviconState {

  final IconData? iconData;

  FaviconChange({this.iconData,});
}

class FaviconChanged extends FaviconState {
  FaviconChanged();
}
