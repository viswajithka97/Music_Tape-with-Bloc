import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_tape/application/FavIcon/favicon_bloc.dart';
import 'package:music_tape/application/FavouriteIconCubit/favouriteicon_cubit.dart';
import 'package:music_tape/core/db_model.dart';

import 'package:music_tape/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SongmodelAdapter());

  await Hive.openBox<List>(boxname);

  final box = Songbox.getInstance();

  List<dynamic> favKeys = box.keys.toList();

  if (!(favKeys.contains("favourites"))) {
    List<dynamic> likedSongs = [];

    await box.put("favourites", likedSongs);
  }
  List<dynamic> watchlaterKeys = box.keys.toList();

  if (!(watchlaterKeys.contains("Recently_Played"))) {
    List<dynamic> watchlater = [];

    await box.put("Recently_Played", watchlater);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(490, 1064),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return FavouriteiconCubit();
                },
              ),
              BlocProvider(
                create: (context) {
                  return FaviconBloc();
                },
              )
            ],
            child: const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: splashScreen(),
            ),
          );
        });
  }
}

