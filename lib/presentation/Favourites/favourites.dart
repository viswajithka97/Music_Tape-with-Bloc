import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Favourites/favouriteaddbutton.dart';
import 'package:music_tape/presentation/My_Music/widgets/popupmenu.dart';
import 'package:music_tape/presentation/Now_Playing_Screen/nowplayingscreen.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favourites extends StatelessWidget {
 Favourites({Key? key}) : super(key: key);

  List<Audio> playliked = [];
  final box = Songbox.getInstance();
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
            iconTheme: IconThemeData(color: Colors.black, size: 35.h.w),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 146, 93, 199),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(
              'Favourites',
              style: TextStyle(fontSize: 25.sp, color: Colors.black),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0.w),
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor:
                              const Color.fromARGB(255, 214, 165, 236),
                          context: context,
                          builder: (ctx) {
                            return FavouriteAddSong();
                          });
                    },
                    icon: const Icon(Icons.add)),
              )
            ],
          ),
          body: SafeArea(
              child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    var likedSongs = box.get("favourites");
                    return ListView.builder(
                      itemCount: likedSongs!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            for (var element in likedSongs) {
                              playliked.add(Audio.file(element.songurl!,
                                  metas: Metas(
                                      title: element.songname,
                                      id: element.id.toString(),
                                      artist: element.artist)));
                            }
                            OpenPlayer(
                              fullSongs: playliked,
                              index: index,
                              SongId: playliked[index].metas.id.toString(),
                            ).openAssetPlayer(index: index, songs: playliked);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NowPlayingScreen(
                                  fullSongs: playliked,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: likedSongs[index] != "musics"
                                ? Padding(
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
                                        visualDensity: const VisualDensity(vertical: -3),
                                          title: Text(
                                            likedSongs[index].songname,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            likedSongs[index].artist,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // ignore: sized_box_for_whitespace
                                          leading: Container(
                                            height: 50.h,
                                            width: 50.w,
                                            child: QueryArtworkWidget(
                                              id: likedSongs[index].id!,
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
                                          trailing: MusicListMenu(
                                              songId: likedSongs[index]
                                                  .id
                                                  .toString())),
                                    ),
                                  )
                                : Container(),
                          ),
                        );
                      },
                    );
                  }))),
    );
  }
}
