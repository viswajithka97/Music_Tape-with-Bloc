import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/My_Music/widgets/editPlaylistName.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_tape/presentation/My_Music/widgets/createplaylist.dart';
import 'package:music_tape/presentation/Playlist/customplaylist.dart';
import 'package:music_tape/presentation/Playlist/playlistscreen.dart';
import 'package:music_tape/presentation/Playlist/Recenly_Played/recentlyplayed.dart';

class PlaylistPage extends StatelessWidget {
   PlaylistPage({Key? key}) : super(key: key);


  final box = Songbox.getInstance();
  List playlists = [];
  List<Songmodel>? playlistSongs = [];

  String? playlistName = '';

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black, size: 35.sp),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: Text(
            'Playlist',
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0.w),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const createPlaylist(),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        size: 35.h.w,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 10.0.w),
                child: Container(
                  height: 75.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(106, 217, 197, 218)),
                  child: ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    leading: const Icon(
                      Icons.audio_file,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    title: const Text(
                      'Recently Played',
                    ),
                    subtitle: Text(
                      '${recentplay!.length} Songs',
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RecentlyPlayed()));
                    },
                  ),
                ),
              ),
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: box.listenable(),
                      builder: (context, boxes, _) {
                        playlists = box.keys.toList();
                        return ListView.builder(
                            itemCount: playlists.length,
                            itemBuilder: (context, index) {
                              var playlistSongs = box.get(playlists[index])!;

                              return Container(
                                child: playlists[index] != "musics" &&
                                        playlists[index] != "favourites" &&
                                        playlists[index] != "Recently_Played"
                                    ? CustomPlayList(
                                        titleNew: playlists[index].toString(),
                                        subtitileNew:
                                            playlistSongs.length.toString(),
                                        leadingNew: Icons.queue_music,
                                        trailingNew: PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text(
                                                'Remove Playlist',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                              value: "0",
                                            ),
                                            PopupMenuItem(
                                              value: "1",
                                              child: Text(
                                                "Rename Playlist",
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == "0") {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            'Do You Want to Delete'),
                                                        actions: [
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20.h.w,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              label: Text(
                                                                  'Cancel',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 20
                                                                      ..h.w,
                                                                    color: Colors
                                                                        .black,
                                                                  ))),
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                box.delete(
                                                                    playlists[
                                                                        index]);
                                                                 playlists = box
                                                                      .keys
                                                                      .toList();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icon(
                                                                Icons.check,
                                                                size: 20.h.w,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              label: Text('Ok',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                        .black,
                                                                  )))
                                                        ],
                                                      ));
                                            }
                                            if (value == "1") {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EditPlaylist(
                                                  playlistName:
                                                      playlists[index],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        ontapNew: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlaylistScreen(
                                                        playlistName:
                                                            playlists[index],
                                                      )));
                                        },
                                      )
                                    : Container(),
                              );
                            });
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
