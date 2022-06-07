import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Now_Playing_Screen/nowplayingscreen.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    List<Audio> recent = [];
    final box = Songbox.getInstance();
    var recentplay = box.get("Recently_Played");
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
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
          iconTheme: IconThemeData(color: Colors.black, size: 35.h.w),
          title: Text(
            'Recently Played',
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Do You Want to Delete'),
                            actions: [
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 20.h.w,
                                    color: Colors.black,
                                  ),
                                  label: Text('Cancel',
                                      style: TextStyle(
                                        fontSize: 20..h.w,
                                        color: Colors.black,
                                      ))),
                              TextButton.icon(
                                  onPressed: () {
                                   setState(() {
                                     recentplay!.clear();
                                   });
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    size: 20.h.w,
                                    color: Colors.black,
                                  ),
                                  label: Text('Ok',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.black,
                                      )))
                            ],
                          ));
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: SafeArea(
            child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount:
                          recentplay!.length > 10 ? 10 : recentplay.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: recentplay[index] != "musics"
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0.h, left: 10.0.w, right: 10.0.w),
                                  child: Container(
                                      height: 75.h,
                                      width: double.infinity.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              106, 217, 197, 218)),
                                      child: ListTile(
                                        onTap: () {
                                          for (var element in recentplay) {
                                            recent.add(Audio.file(
                                                element.songurl!,
                                                metas: Metas(
                                                    title: element.songname,
                                                    id: element.id.toString(),
                                                    artist: element.artist)));
                                          }
                                          OpenPlayer(
                                                  fullSongs: recent,
                                                  index: index,
                                                  SongId: '')
                                              .openAssetPlayer(
                                                  index: index, songs: recent);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      NowPlayingScreen(
                                                          index: index,
                                                          fullSongs: recent)));
                                        },
                                        title: Text(
                                          recentplay[index].songname,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          recentplay[index].artist,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // ignore: sized_box_for_whitespace
                                        leading: Container(
                                          height: 50.h,
                                          width: 50.w,
                                          child: QueryArtworkWidget(
                                            id: recentplay[index].id!,
                                            type: ArtworkType.AUDIO,
                                            artworkBorder:
                                                BorderRadius.circular(5),
                                            // artworkFit: BoxFit.cover,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.asset(
                                                  "asset/images/new3.png"),
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              : Container(),
                        );
                      });
                })),
      ),
    );
  }
}
