import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Home/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: camel_case_types
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

List<Audio> fullSongs = [];
List<SongModel> fetchedSongs = [];
List<SongModel> allSongs = [];
List<Songmodel> dbSongs = [];
List<Songmodel> mappedSongs = [];
Set<String> gotPathset = {};
List<String> gotPath = [];

// ignore: camel_case_types
class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    requestStoragePermission();
    home();
    super.initState();
  }

  final _audioQuery = OnAudioQuery();
  final box = Songbox.getInstance();

  requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }

    fetchedSongs = await _audioQuery.querySongs();

    for (var element in fetchedSongs) {
      if (element.fileExtension == "mp3") {
        allSongs.add(element);
      }
    }

    mappedSongs = allSongs
        .map(
          (audio) => Songmodel(
              songname: audio.title,
              artist: audio.artist,
              songurl: audio.uri,
              duration: audio.duration,
              id: audio.id),
        )
        .toList();

    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songmodel>;

    for (var element in dbSongs) {
      fullSongs.add(
        Audio.file(
          element.songurl.toString(),
          metas: Metas(
              title: element.songname,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.10),
          colors: [
            Color(0xFFAD78E1),
            Color(0xFFB59CDA),
            Color(0xFFC28ADC),
            Color(0xFFAA8BE5),
            Color(0xFFAD78E1),
            Color(0xFFAB76E0),
          ],
          radius: 1.5,
          focalRadius: 15.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                  ),

                  Text(
                    'Music Tape',
                    style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Image.asset('asset/images/splash.png'),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Feel the Music',
                    style: TextStyle(fontSize: 30.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 70.0.w.h)
          ],
        )),
      ),
    );
  }

  Future<void> home() async {
    await Future.delayed(
      const Duration(seconds: 4),
    );

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => Home(allsongs: fullSongs)));
  }
}
