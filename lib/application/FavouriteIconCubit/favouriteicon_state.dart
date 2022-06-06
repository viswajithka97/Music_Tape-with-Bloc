part of 'favouriteicon_cubit.dart';

@immutable
abstract class FavouriteiconState {}

 class FavouriteiconInitial extends FavouriteiconState {
  final IconData? favIcon;
 FavouriteiconInitial({required this.favIcon});
}
