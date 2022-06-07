import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/My_Music/widgets/playlistscreenaddsongs.dart';
import 'package:music_tape/presentation/Now_Playing_Screen/nowplayingscreen.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatefulWidget {
  String playlistName;
  PlaylistScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final box = Songbox.getInstance();

  List<Songmodel>? dbSongs = [];
  List<Songmodel>? playlistSongs = [];
  List<Audio> playPlaylist = [];

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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
          elevation: 0,
          title: Text(
            widget.playlistName,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                padding: EdgeInsets.only(right: 20.w),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: const Color.fromARGB(255, 214, 165, 236),
                      context: context,
                      builder: (context) {
                        return SongSheet(
                          playlistName: widget.playlistName,
                        );
                      });
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30.h.w,
                ))
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (context, value, child) {
                      var playlistSongs = box.get(widget.playlistName)!;
                      return playlistSongs.isEmpty
                          ? Center(
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: 5.h,
                                width: 100.w,
                                child: const Text(
                                  'Add Some Songs',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: playlistSongs.length,
                              itemBuilder: (context, index) => GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0.h,
                                            left: 10.0.w,
                                            right: 10.0.w),
                                        child: Container(
                                            height: 75.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color.fromARGB(
                                                    106, 217, 197, 218)),
                                            child: ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -3),
                                              leading: QueryArtworkWidget(
                                                  id: playlistSongs[index].id,
                                                  artworkBorder:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  type: ArtworkType.AUDIO),
                                              title: Text(
                                                playlistSongs[index].songname,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                playlistSongs[index].artist,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: PopupMenuButton(
                                                itemBuilder:
                                                    (BuildContext context) => [
                                                  const PopupMenuItem(
                                                    value: "1",
                                                    child: Text(
                                                      "Remove song",
                                                    ),
                                                  ),
                                                ],
                                                onSelected: (value) async {
                                                  if (value == "1") {
                                                    playlistSongs
                                                        .removeAt(index);
                                                    box.put(widget.playlistName,
                                                        playlistSongs);
                                           
                                                  }
                                                },
                                              ),
                                              onTap: () {
                                                for (var element
                                                    in playlistSongs) {
                                                  playPlaylist.add(
                                                    Audio.file(
                                                      element.songurl!,
                                                      metas: Metas(
                                                        title: element.songname,
                                                        id: element.id
                                                            .toString(),
                                                        artist: element.artist,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                OpenPlayer(
                                                  fullSongs: playPlaylist,
                                                  index: index,
                                                  SongId: playPlaylist[index]
                                                      .metas
                                                      .id
                                                      .toString(),
                                                ).openAssetPlayer(
                                                    index: index,
                                                    songs: playPlaylist);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NowPlayingScreen(
                                                      fullSongs: playPlaylist,
                                                      index: index,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))),
                                  ));
                    }))
          ],
        )),
      ),
    );
  }
}
