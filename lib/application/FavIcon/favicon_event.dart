part of 'favicon_bloc.dart';

@immutable
abstract class FaviconEvent {
FaviconEvent();
}
class FaviconChangeEvent extends FaviconEvent{
  final IconData iconData;
   FaviconChangeEvent({required this.iconData});

}

class FaviconChangedEvent extends FaviconEvent{
  FaviconChangedEvent();
}
class BottomNavigationChangeEvent extends FaviconEvent{
  int pageNo;
  BottomNavigationChangeEvent({required this.pageNo});
}