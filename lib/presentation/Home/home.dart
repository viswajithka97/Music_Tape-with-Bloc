// ignore_for_file: implementation_imports

import 'package:assets_audio_player/assets_audio_player.dart';
// ignore: unnecessary_import
import 'package:assets_audio_player/src/playable.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_tape/presentation/Drawer/drawer.dart';
import 'package:music_tape/presentation/Now_Playing_Screen/nowplayingscreen.dart';
import 'package:music_tape/presentation/Folders/folders.dart';
import 'package:music_tape/presentation/Favourites/favourites.dart';
import 'package:music_tape/presentation/My_Music/mymusic..dart';
import 'package:music_tape/presentation/Playlist/playlistpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  List<Audio> allsongs;
  Home({Key? key, required this.allsongs}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final audioQuery = OnAudioQuery();
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');

  int _currentSelectedIndex = 0;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      MyMusic(
        fullsongs: widget.allsongs,
      ),
      const Folderslist(),
       PlaylistPage(),
      const Favourites(),
    ];
    return Scaffold(
      drawer: const drawer(),
      bottomSheet: GestureDetector(onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NowPlayingScreen(
                      index: 0,
                      fullSongs: widget.allsongs,
                    )));
      }, child: assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing? playing) {
        final myAudio = find(widget.allsongs, playing!.audio.assetAudioPath);

        return Container(
          height: 80.h,
          color: const Color.fromARGB(255, 191, 155, 230),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: QueryArtworkWidget(
                          // ignore: prefer_const_constructors
                          nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset('asset/images/new3.png')),
                          id: int.parse(myAudio.metas.id!),
                          artworkBorder: BorderRadius.circular(5.0),
                          type: ArtworkType.AUDIO),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                        width: 180.w,
                        child: Marquee(
                          velocity: 20,
                          startAfter: Duration.zero,
                          blankSpace: 100,
                          text: myAudio.metas.title!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                        width: 180.w,
                        child: Marquee(
                          startAfter: Duration.zero,
                          blankSpace: 150,
                          velocity: 20,
                          text: myAudio.metas.artist!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 45.w.h,
              ),
              Wrap(
                spacing: 15.0.w.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        assetsAudioPlayer.previous();
                      },
                      icon: Icon(
                        Icons.skip_previous,
                        size: 35.w.h,
                      )),
                  PlayerBuilder.isPlaying(
                      player: assetsAudioPlayer,
                      builder: (context, isPlaying) {
                        return Container(
                          height: 50.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: IconButton(
                            onPressed: () async {
                              await assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 35.h.w,
                            ),
                          ),
                        );
                      }),
                  GestureDetector(
                    child: IconButton(
                      onPressed: () {
                        assetsAudioPlayer.next();
                      },
                      icon: Icon(
                        Icons.skip_next,
                        size: 35.h.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      })),
      body: _widgetOptions.elementAt(_currentSelectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, -0.8),
            colors: [
              Color.fromARGB(255, 172, 120, 225),
              Color.fromARGB(147, 181, 156, 218),
              Color.fromARGB(164, 194, 138, 220),
              Color(0xFFAA8BE5),
              Color(0xFFAD78E1),
              Color(0xFFAB76E0),
            ],
            radius: 100.5,
            focalRadius: 0.5,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
              // canvasColor:   Color.fromARGB(255, 191, 156, 199),
              canvasColor: Colors.transparent),
          child: BottomNavigationBar(
              selectedItemColor: Colors.black,
              unselectedItemColor: const Color.fromARGB(175, 255, 255, 255),
              currentIndex: _currentSelectedIndex,
              onTap: (newIndex) {
                setState(() {
                  _currentSelectedIndex = newIndex;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.headphones), label: 'My Music'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.folder), label: 'Folders'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.playlist_add), label: 'Playlist'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outlined), label: 'Favourite'),
              ]),
        ),
      ),
    );
  }
}
