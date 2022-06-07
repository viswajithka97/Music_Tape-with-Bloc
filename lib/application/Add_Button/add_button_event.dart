// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_button_bloc.dart';

@immutable
abstract class AddButtonEvent {
  AddButtonEvent();
}
class AddButtonChangeEvent extends AddButtonEvent {
  final IconData addbuttoniconData;
  AddButtonChangeEvent({
    required this.addbuttoniconData,
  });
}
class AddButtonChangedEvent extends AddButtonEvent{
  AddButtonChangedEvent();
}
