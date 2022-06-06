import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'favouriteicon_state.dart';

class FavouriteiconCubit extends Cubit<FavouriteiconState> {
  // final box = Songbox.getInstance();
  // List<Songmodel> dbSongs = [];
  // List<dynamic>? likedSongs = [];
  FavouriteiconCubit()
      : super(FavouriteiconInitial(favIcon: Icons.favorite));

  addtoFavourite(favIcon) {
    print(favIcon);
      //  Icon(
      //     Icons.playlist_add,
      //     size: 35.h.w,
      //   );
        emit(FavouriteiconInitial(
          favIcon: favIcon
        ));
  }
}
