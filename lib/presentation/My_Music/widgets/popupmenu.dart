import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Playlist/playlistlist.dart';

// ignore: must_be_immutable
class MusicListMenu extends StatelessWidget {
  final String songId;

  MusicListMenu({Key? key, required this.songId}) : super(key: key);

  final box = Songbox.getInstance();

  List<Songmodel> dbSongs = [];
  List<Audio> fullSongs = [];

  List playlists = [];

  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    dbSongs = box.get("musics") as List<Songmodel>;

    List? favourites = box.get("favourites");

    final temp = databaseSongs(dbSongs, songId);

    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert_outlined,
        ),
        itemBuilder: (BuildContext context) => [
              favourites!
                      .where((element) =>
                          element.id.toString() == temp.id.toString())
                      .isEmpty
                  ? PopupMenuItem(
                      onTap: () async {
                        favourites.add(temp);
                        await box.put("favourites", favourites);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              temp.songname! + " Added to Favourites",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Add to Favourite",
                      ),
                    )
                  : PopupMenuItem(
                      onTap: () async {
                        favourites.removeWhere((element) =>
                            element.id.toString() == temp.id.toString());
                        await box.put("favourites", favourites);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              temp.songname! + " Removed from Favourites",
                            ),
                          ),
                        );
                      },
                      child: const Text('Remove From Favourites')),
              const PopupMenuItem(
                value: 1,
                child: Text(
                  "Add to Playlist",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
        onSelected: (value) {
          if (value == 1) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PlaylistList(song: temp);
                });
          }
        });
  }

  Songmodel databaseSongs(List<Songmodel> songs, String id) {
    return songs.firstWhere(
      (element) => element.songurl.toString().contains(id),
    );
  }
}
