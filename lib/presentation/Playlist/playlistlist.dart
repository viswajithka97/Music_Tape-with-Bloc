import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/My_Music/widgets/createplaylist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class PlaylistList extends StatelessWidget {
  PlaylistList({Key? key, required this.song}) : super(key: key);
  Songmodel song;

  List playlists = [];

  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    final box = Songbox.getInstance();
    playlists = box.keys.toList();

    return AlertDialog(
      title: const Text('Playlist'),
      // ignore: sized_box_for_whitespace
      content: Container(
        height: 400.h,
        width: double.minPositive,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
              title: const Text(
                'Create New Playlist',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const createPlaylist());
              },
            ),
            ...playlists
                .map(
                  (audio) => audio != "musics" && audio != "favourites" && audio != "Recently_Played"
                      ? ListTile(
                          onTap: () async {
                            playlistSongs = box.get(audio);
                            List existingSongs = [];
                            existingSongs = playlistSongs!
                                .where((element) =>
                                    element.id.toString() == song.id.toString())
                                .toList();
                            if (existingSongs.isEmpty) {
                              final songs =
                                  box.get("musics") as List<Songmodel>;
                              final temp = songs.firstWhere((element) =>
                                  element.id.toString() == song.id.toString());
                              playlistSongs?.add(temp);

                              await box.put(audio, playlistSongs!);

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  song.songname! + ' Added to Playlist',
                                ),
                              ));
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    song.songname! + ' is already in Playlist.',
                                  ),
                                ),
                              );
                            }
                          },
                          leading: const Icon(Icons.queue_music),
                          title: Text(
                            audio.toString(),
                            style: TextStyle(
                              fontSize: 22.sp,
                            ),
                          ),
                        )
                      : Container(),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
