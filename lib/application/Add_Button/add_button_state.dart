// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_button_bloc.dart';

@immutable
abstract class AddButtonState {
  AddButtonState();
}

class AddButtonInitial extends AddButtonState {}

class AddButtonChange extends AddButtonState {

final IconData? addIconData;

  AddButtonChange({
   this.addIconData,
  });

}
class AddButtonChanged extends AddButtonState{
  AddButtonChanged();
}
